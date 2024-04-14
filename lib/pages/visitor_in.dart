// import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cyclops/components/my_button.dart';
import 'package:cyclops/components/my_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:google_mlkit_commons/google_mlkit_commons.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class VistorInPage extends StatefulWidget {
  const VistorInPage({super.key});

  @override
  State<VistorInPage> createState() => _VistorInPageState();
}

class _VistorInPageState extends State<VistorInPage> {
  final _visitorNameController = TextEditingController();
  final _visitorIdController = TextEditingController();
  final _visitorHouseVisitingController = TextEditingController();
  final _visitorNationalityController = TextEditingController();
  final _visitorPhoneContactController = TextEditingController();

  var _result = List<String>.empty(growable: true);
  bool _loading = false;

  ImagePicker picker = ImagePicker();
  // InputImage _pickedImage ;

  Future _pickImage() async {
    final pickedImageFile = await picker.pickImage(
      source: ImageSource.camera,
    );
    if (pickedImageFile == null) {
      return null;
    }
    final _pickedImage = InputImage.fromFilePath(pickedImageFile.path);
    return _pickedImage;
  }

  //Recognize text from image

  Future recognizeText(InputImage _pickedImage) async {
    // create an instance of text recognizer
    final textRecognizer = TextRecognizer();
    List<String> lines = [];
    // pass image to processImage() to get RecognisedText object
    final RecognizedText recognizedText =
        await textRecognizer.processImage(_pickedImage);
    // String recogText = recognizedText.text;

    for (TextBlock block in recognizedText.blocks) {
      // final Rect boundingBox = block.boundingBox;
      // final List<Point<int>> cornerPoints = block.cornerPoints;
      // final String text = block.text;
      // final List<String> languages = block.recognizedLanguages;

      for (TextLine line in block.lines) {
        // Same getters as TextBlock
        // final Rect boundingBox = line.boundingBox;
        final String lineText = line.text;
        print(lineText);
        lines.add(lineText);
      }
    }

    String resultText = lines.join(' ');

    setState(() {
      _result = lines;
    });

    return resultText;
    // _result = text;
  }

  Future fetchDetailData(String resultText) async {
    try {
      const apiUrl =
          'https://us-central1-projex.cloudfunctions.net/id_extract-1';

      // convert result list to string
      final jsonObj = jsonEncode(
        {
          'message': resultText,
        },
      );

      print(jsonObj);

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonObj,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final String name = data['fullName'];
        final String idNumber = data['idNumber'];
        final String nationality = data['nationality'];

        _visitorIdController.text = idNumber;
        _visitorNameController.text = name;
        _visitorNationalityController.text = nationality;

        print(data);
        print(name);
        print(idNumber);
        print(nationality);
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
    }
  }

  Future sendToDb(
    String visitorName,
    String visitorId,
    String visitorHouseVisiting,
    String visitorNationality,
    String visitorPhoneContact,
  ) async {
    final db = FirebaseFirestore.instance;
    final visitorRef = db.collection('visitors').doc();
    // add timestamp
    final createdAt = FieldValue.serverTimestamp();
    final staffId = FirebaseAuth.instance.currentUser!.uid;

    print("staffId: $staffId");

    // final data payload
    final visitorData = {
      'visitorRefId': visitorRef.id,
      'visitorName': visitorName,
      'visitorId': visitorId,
      'visitorHouseVisiting': visitorHouseVisiting,
      'visitorNationality': visitorNationality,
      'visitorPhoneContact': visitorPhoneContact,
      'checkInTime': createdAt,
      'checkOutTime': null,
      'checkOutFlag': false,
      'staffId': staffId,
      // 'securityGuardId': null,
    };

    await visitorRef.set(visitorData);
  }

  Future prepScanDetails() async {
    try {
      setState(() {
        _loading = true;
      });

      if (_loading == true) {
        showDialog(
          context: context,
          builder: ((context) {
            return Center(child: CircularProgressIndicator());
          }),
        );
        final _pickedImage = await _pickImage();
        String textPayload = await recognizeText(_pickedImage);
        fetchDetailData(textPayload);

        setState(() {
          _loading = false;
        });
        if (_loading == false) {
          // ignore: use_build_context_synchronously
          Navigator.of(context).pop();
        }
      }
    } on Exception catch (e) {
      // TODO
      print("PrepScanErr : $e");
    }
  }

  Future checkInVisitor() async {
    final visitorName = _visitorNameController.text.trim();
    final visitorId = _visitorIdController.text.trim();
    final visitorHouseVisiting = _visitorHouseVisitingController.text.trim();
    final visitorNationality = _visitorNationalityController.text.trim();
    final visitorPhoneContact = _visitorPhoneContactController.text.trim();
    // check if any field is empty
    if (visitorName.isEmpty ||
        visitorId.isEmpty ||
        visitorHouseVisiting.isEmpty ||
        visitorNationality.isEmpty ||
        visitorPhoneContact.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Visitor Check In'),
            content: Text('Please fill in all fields.'),
            actions: [
              TextButton(
                onPressed: () {
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

    // await prepScanDetails();
    try {
      await sendToDb(
        visitorName,
        visitorId,
        visitorHouseVisiting,
        visitorNationality,
        visitorPhoneContact,
      );

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Visitor Checked In'),
            content: Text('Visitor details have been saved successfully.'),
            actions: [
              TextButton(
                onPressed: () {
                  // ignore: use_build_context_synchronously
                  // Navigator.of(context).pop();
                  Navigator.pushNamed(
                      context, '/visitor_out'); // Close the dialog
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } on Exception catch (e) {
      // TODO
      print(e);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Visitor Checked In'),
            content: Text('Visitor details registration failed .'),
            actions: [
              TextButton(
                onPressed: () {
                  // ignore: use_build_context_synchronously
                  // Navigator.of(context).pop();
                  Navigator.pushNamed(
                      context, '/visits_ongoing'); // Close the dialog
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  void dispose() {
    _visitorNameController.dispose();
    _visitorIdController.dispose();
    _visitorHouseVisitingController.dispose();
    _visitorNationalityController.dispose();
    _visitorPhoneContactController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Visitor Check in',
           style: GoogleFonts.mavenPro(
                        textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ), 
           ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue[400],
        elevation: 10,
      ),
      backgroundColor: Colors.blue[400],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            // alignment: FractionalOffset.bottomCenter,
            decoration: BoxDecoration(
              // color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  height: 100,
                  width: 100,
                  margin: EdgeInsets.only(top: 40),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: GestureDetector(
                    onTap: prepScanDetails,
                    child: Icon(
                      Icons.camera_enhance_rounded,
                      size: 50,
                      color: Colors.redAccent[700],
                      shadows: [
                        Shadow(
                          blurRadius: 10.0,
                          color: Colors.black,
                          offset: Offset(1.0, 3.0),
                        ),
                      ],
                      semanticLabel: 'Take a picture of the visitor ID',
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: prepScanDetails,
                  child: Container(
                    margin: EdgeInsets.only(top: 20),
                    child: const Text(
                      'Tap to scan visitor ID',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            blurRadius: 10.0,
                            color: Colors.black,
                            offset: Offset(1.0, 3.0),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 550,
                  margin: EdgeInsets.only(top: 50),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(60),
                        topRight: Radius.circular(60)),
                  ),
                  child: Container(
                    margin: EdgeInsets.only(
                      top: 50,
                    ),
                    child: Column(
                      children: [
                        //display _results here
                        // Column(children: [
                        //   for (var i in _result) Text(i.toString()),
                        // ]),

                        MyTextField(
                            controller: _visitorNameController,
                            hintText: 'Name',
                            obscureText: false),
                        MyTextField(
                            controller: _visitorIdController,
                            hintText: 'ID',
                            obscureText: false),
                        MyTextField(
                            controller: _visitorHouseVisitingController,
                            hintText: 'House Visiting',
                            obscureText: false),
                        MyTextField(
                            controller: _visitorNationalityController,
                            hintText: 'nationality',
                            obscureText: false),
                        MyTextField(
                            controller: _visitorPhoneContactController,
                            hintText: 'Phone Contact',
                            obscureText: false),
                        Container(
                          margin: EdgeInsets.only(top: 20),
                          child: MyButton(
                              onPressed: checkInVisitor,
                              btnText: 'Check-In Visitor'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
