// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:intl/intl.dart';

// class VisitorDetailPage extends StatelessWidget {
//   final Map<String, dynamic> visitorData;
//   late String formattedCheckInTime;
//   late String formattedCheckOutTime;

//   VisitorDetailPage({
//     super.key,
//     required this.visitorData,
//   });

//   String formatTimestamp(Timestamp timestamp) {
//     // Convert the Firestore timestamp to a DateTime object
//     DateTime dateTime = timestamp.toDate();

//     // Format the DateTime as a string as per your requirements
//     String formattedDateTime = DateFormat.yMd().add_jm().format(dateTime);

//     return formattedDateTime;
//   }

//   @override
//   Widget build(BuildContext context) {
//     formattedCheckInTime = formatTimestamp(visitorData['checkInTime']);
//     formattedCheckOutTime = formatTimestamp(visitorData['checkOutTime']);

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Visitor Details'),
//         centerTitle: true,
//         backgroundColor: Colors.blue[400],
//         elevation: 10,
//       ),
//       backgroundColor: Colors.blue[400],
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Container(
//             decoration: BoxDecoration(
//               // color: Colors.white,
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 SizedBox(height: 20),
//                 Container(
//                   margin: EdgeInsets.only(top: 30),
//                   child: Center(
//                       child: ClipOval(
//                     child: Image.asset(
//                       'assets/images/splash_logo.png',
//                       width: 150,
//                       height: 150,
//                     ),
//                   )),
//                 ),
//                 SizedBox(height: 10),
//                 Text(
//                   'Visitor Details',
//                   style: TextStyle(
//                     color: Colors.black,
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 Container(
//                   height: 600,
//                   margin: EdgeInsets.only(top: 50),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.only(
//                         topLeft: Radius.circular(60),
//                         topRight: Radius.circular(60)),
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.all(10.0),
//                     child: Column(
//                       children: [
//                         SizedBox(height: 10),
//                         Container(
//                           margin: EdgeInsets.only(left: 20, right: 20),
//                           child: Column(
//                             children: [
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,

//                                 children: [
//                                   Text(
//                                     'Visitor Name',
//                                     style: TextStyle(
//                                       color: Colors.black,
//                                       fontSize: 15,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                   Text(
//                                     visitorData['visitorName'],
//                                     style: TextStyle(
//                                       color: Colors.black,
//                                       fontSize: 15,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               SizedBox(height: 10),
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Text(
//                                     'House Number',
//                                     style: TextStyle(
//                                       color: Colors.black,
//                                       fontSize: 15,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                   Text(
//                                     visitorData['visitorHouseVisiting'],
//                                     style: TextStyle(
//                                       color: Colors.black,
//                                       fontSize: 15,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               SizedBox(height: 10),
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Text(
//                                     'Check In Time',
//                                     style: TextStyle(
//                                       color: Colors.black,
//                                       fontSize: 15,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                   Text(
//                                     formattedCheckInTime,
//                                     style: TextStyle(
//                                       color: Colors.black,
//                                       fontSize: 15,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               SizedBox(height: 10),
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Text(
//                                     'Check Out Time',
//                                     style: TextStyle(
//                                       color: Colors.black,
//                                       fontSize: 15,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                   Text(
//                                     formattedCheckOutTime,
//                                     style: TextStyle(
//                                       color: Colors.black,
//                                       fontSize: 15,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Text(
//                                     'Nationality',
//                                     style: TextStyle(
//                                       color: Colors.black,
//                                       fontSize: 15,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                   Text(
//                                     visitorData['visitorNationality'],
//                                     style: TextStyle(
//                                       color: Colors.black,
//                                       fontSize: 15,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Text(
//                                     'Visitor ID card number',
//                                     style: TextStyle(
//                                       color: Colors.black,
//                                       fontSize: 15,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                   Text(
//                                     visitorData['visitorId'],
//                                     style: TextStyle(
//                                       color: Colors.black,
//                                       fontSize: 15,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Text(
//                                     'Visitor Phone Number',
//                                     style: TextStyle(
//                                       color: Colors.black,
//                                       fontSize: 15,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                   Text(
//                                     visitorData['visitorPhoneContact'],
//                                     style: TextStyle(
//                                       color: Colors.black,
//                                       fontSize: 15,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                 ],
//                               )
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class VisitorDetailPage extends StatelessWidget {
  final Map<String, dynamic> visitorData;
  late String formattedCheckInTime;
  late String formattedCheckOutTime;

  VisitorDetailPage({
    Key? key,
    required this.visitorData,
  });

  String formatTimestamp(Timestamp timestamp) {
    // Convert the Firestore timestamp to a DateTime object
    DateTime dateTime = timestamp.toDate();

    // Format the DateTime as a string as per your requirements
    String formattedDateTime = DateFormat.yMd().add_jm().format(dateTime);

    return formattedDateTime;
  }

  @override
  Widget build(BuildContext context) {
    formattedCheckInTime = formatTimestamp(visitorData['checkInTime']);
    formattedCheckOutTime =
        formatTimestamp(visitorData['checkOutTime'] ?? Timestamp.now());

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
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(height: 20),
                Container(
                  margin: EdgeInsets.only(top: 30),
                  child: Center(
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/splash_logo.png',
                        width: 150,
                        height: 150,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Visitor Details',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  height: 600,
                  margin: EdgeInsets.only(top: 40),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(60),
                      topRight: Radius.circular(60),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Expanded(
                      child: ListView(
                        children: List.generate(8, (index) {
                          return Column(
                            children: [
                              SizedBox(height: 10),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 5,
                                        blurRadius: 7,
                                        offset: Offset(2, 3),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        getLabelText(index),
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        getVisitorData(index),
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        }),
                      ),
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

  String getLabelText(int index) {
    switch (index) {
      case 0:
        return 'Visitor Name';
      case 1:
        return 'House Number';
      case 2:
        return 'Check In Time';
      case 3:
        return 'Check Out Time';
      case 4:
        return 'Nationality';
      case 5:
        return 'Visitor ID card number';
      case 6:
        return 'Visitor Phone Number';
      case 7:
        return 'Checked In By';
      default:
        return '';
    }
  }

  String getVisitorData(int index) {
    switch (index) {
      case 0:
        return visitorData['visitorName'];
      case 1:
        return visitorData['visitorHouseVisiting'];
      case 2:
        return formattedCheckInTime;
      case 3:
        return formattedCheckOutTime;
      case 4:
        return visitorData['visitorNationality'];
      case 5:
        return visitorData['visitorId'];
      case 6:
        return visitorData['visitorPhoneContact'];
      case 7:
        return visitorData['staffId'];
      default:
        return '';
    }
  }
}
