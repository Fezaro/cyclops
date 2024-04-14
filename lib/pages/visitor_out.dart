import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../components/checked_in_tab.dart';

class visitorOutPage extends StatefulWidget {
  const visitorOutPage({super.key});

  @override
  State<visitorOutPage> createState() => _visitorOutPageState();
}

class _visitorOutPageState extends State<visitorOutPage> {
  late Future<List<Map<String, dynamic>>> _visitorData;

  Future<List<Map<String, dynamic>>> getVisitorData() async {
    final db = FirebaseFirestore.instance;
    final visitorDataSnapshot = await db
        .collection('visitors')
        .where('checkOutFlag', isEqualTo: false)
        .get();

    return visitorDataSnapshot.docs.map((doc) => doc.data()).toList();
  }

  String formatTimestamp(Timestamp timestamp) {
    // Convert the Firestore timestamp to a DateTime object
    DateTime dateTime = timestamp.toDate();

    // Format the DateTime as a string as per your requirements
    String formattedDateTime = DateFormat.yMd().add_jm().format(dateTime);

    return formattedDateTime;
  }

  Future<void> checkOutVisitor(String visitorRefId) async {
    try {
  final db = FirebaseFirestore.instance;
  
  await db.collection('visitors').doc(visitorRefId).update({
    'checkOutFlag': true,
    'checkOutTime': FieldValue.serverTimestamp(),
  });
  // snack bar
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('Visitor Checked Out'),
      duration: Duration(seconds: 2),
    ),
  );
} on Exception catch (e) {
  // TODO
  print("Visitor db add Error: $e");
  // snack bar
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('An error occurred. Please try again later.'),
      duration: Duration(seconds: 2),
    ),
  );
}
  }

  @override
  void initState() {
    // TODO: implement initState
    _visitorData = getVisitorData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CheckPoint',
              style: GoogleFonts.mavenPro(
                  textStyle: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              )
              )
              ),
        centerTitle: true,
        backgroundColor: Colors.blue[400],
        elevation: 10,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/dashboard');
            },
            icon: Icon(Icons.home,
            color: Colors.white,),
          ),
        ],
      ),
      backgroundColor: Colors.blue[400],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 30),
                child: Center(
                    child: ClipOval(
                  child: Image.asset(
                    'assets/images/splash_logo.png',
                    width: 150,
                    height: 150,
                  ),
                )),
              ),
              SizedBox(height: 10),
              // Display the total number of visitors
              FutureBuilder<List<Map<String, dynamic>>>(
                future: _visitorData,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    int totalVisitors = snapshot.data?.length ?? 0;
                    return Text(
                      'Total Visitors Checked In: $totalVisitors',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  }
                },
              ),
              Container(
                decoration: BoxDecoration(
                  // color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                        height: 600,
                        margin: EdgeInsets.only(top: 50),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(60),
                              topRight: Radius.circular(60)),
                        ),
                        child: Container(
                          margin: EdgeInsets.only(top: 40),
                          child: FutureBuilder<List<Map<String, dynamic>>>(
                            future: _visitorData,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                    child: CircularProgressIndicator());
                              } else if (snapshot.hasError) {
                                return Center(
                                    child: Text('Error: ${snapshot.error}'));
                              } else {
                                List<Map<String, dynamic>> data =
                                    snapshot.data ?? [];
                                return ListView.builder(
                                  itemCount: data.length,
                                  itemBuilder: (context, index) {
                                    Timestamp checkInTimestamp = data[index]
                                            ['checkInTime'] ??
                                        Timestamp.now();
                                    String formattedCheckInTime =
                                        formatTimestamp(checkInTimestamp);
                                    return CheckedInTab(
                                      houseNumber: data[index]
                                          ['visitorHouseVisiting'],
                                      visitorName: data[index]['visitorName'],
                                      checkInTime: formattedCheckInTime,
                                      visitorRefId: data[index][
                                          'visitorRefId'], // Pass the visitor ID
                                      onCheckOut: (visitorRefId) async {
                                        // Call the check-out function and refresh the page
                                        await checkOutVisitor(visitorRefId);
                                        setState(() {
                                          // Reload the visitor data
                                          _visitorData = getVisitorData();
                                        });
                                      },
                                      getVisitorData: getVisitorData,
                                    );
                                  },
                                );
                              }
                            },
                          ),
                        )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
