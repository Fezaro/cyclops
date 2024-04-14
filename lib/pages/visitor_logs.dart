import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cyclops/components/visitor_log_tab.dart';
import 'package:cyclops/pages/visitors_log_detail.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class visitorLogsPage extends StatefulWidget {
  const visitorLogsPage({super.key});

  @override
  State<visitorLogsPage> createState() => _visitorLogsPageState();
}

class _visitorLogsPageState extends State<visitorLogsPage> {
  late Future<List<Map<String, dynamic>>> _visitorData;

  Future<List<Map<String, dynamic>>> getVisitorCheckOutData() async {
    final db = FirebaseFirestore.instance;
    final visitorDataSnapshot = await db
        .collection('visitors')
        .where('checkOutFlag', isEqualTo: true)
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

//   void _navigateToDetailPage(Map<String, dynamic> visitorData) {
//   Navigator.push(
//     context,
//     MaterialPageRoute(
//       builder: (context) => VisitorDetailPage(visitorData: visitorData),
//     ),
//   );
// }

  @override
  void initState() {
    // TODO: implement initState
    _visitorData = getVisitorCheckOutData();
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
      ),
      backgroundColor: Colors.blue[400],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              // color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
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
                        'Total Visitors Checked Out: $totalVisitors',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.pink[400],
                          fontSize: 20,
                        ),
                      );
                    }
                  },
                ),
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
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        } else {
                          List<Map<String, dynamic>> data = snapshot.data ?? [];
                          return ListView.builder(
                            itemCount: data.length,
                            itemBuilder: (context, index) {
                              Timestamp checkOutTimestamp = data[index]
                                      ['checkOutTime'] ??
                                  Timestamp.now();
                              String formattedCheckOutTime =
                                  formatTimestamp(checkOutTimestamp);
                              return GestureDetector(
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => VisitorDetailPage(
                                        visitorData: data[index]),
                                  ),
                                ),
                                child: VisitorLogTab(
                                  houseNumber: data[index]
                                      ['visitorHouseVisiting'],
                                  visitorName: data[index]['visitorName'],
                                  checkOutTime: formattedCheckOutTime,
                                ),
                              );
                            },
                          );
                        }
                      },
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

