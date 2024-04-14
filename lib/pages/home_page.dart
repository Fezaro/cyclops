import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser!;
  late Future<List<Map<String, dynamic>>> _visitorData;

// get user details from user coll in db
  Future<Map<String, dynamic>?> getUserDetails() async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        print('User ID: ${user.uid}');
        final db = FirebaseFirestore.instance;

        // Query the 'users' collection where 'uid' field matches the user's UID
        final userSnapshot = await db
            .collection('users')
            .where('uid', isEqualTo: user.uid)
            .get();

        if (userSnapshot.docs.isNotEmpty) {
          // Retrieve the first document from the query result
          final userData =
              userSnapshot.docs.first.data() as Map<String, dynamic>;
          return userData;
        } else {
          print('User document does not exist');
          return null;
        }
      } else {
        print('User is not logged in');
        return null;
      }
    } catch (e) {
      print('Error fetching user details: $e');
      return null;
    }
  }

  //store user details in a map
  Map<String, dynamic> userDetails = {};

  // get user  details from user collection in the database and check if role is admin
  Future<bool> isAdmin() async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        final db = FirebaseFirestore.instance;

        // Query the 'users' collection where 'uid' field matches the user's UID
        final userSnapshot = await db
            .collection('users')
            .where('uid', isEqualTo: user.uid)
            .get();

        if (userSnapshot.docs.isNotEmpty) {
          // Retrieve the first document from the query result
          final userData =
              userSnapshot.docs.first.data() as Map<String, dynamic>;
          return userData['role'] == 'admin';
        } else {
          print('User document does not exist');
          return false;
        }
      } else {
        print('User is not logged in');
        return false;
      }
    } catch (e) {
      print('Error checking admin role: $e');
      return false;
    }
  }

  // get visitor data
  Future<List<Map<String, dynamic>>> getVisitorData() async {
    final db = FirebaseFirestore.instance;
    final visitorDataSnapshot = await db
        .collection('visitors')
        .where('checkOutFlag', isEqualTo: false)
        .get();

    return visitorDataSnapshot.docs.map((doc) => doc.data()).toList();
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
              ))),
          centerTitle: true,
          backgroundColor: Colors.blue[400],
          elevation: 10,
          leading: FutureBuilder<bool>(
            future: isAdmin(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // Return a loading indicator or placeholder while waiting for the result
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                // Handle errors
                return Icon(Icons.error_outline_outlined);
              } else if (snapshot.data == true) {
                // Return the admin icon if the user is an admin
                return IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/admin');
                  },
                  icon: const Icon(
                    Icons.admin_panel_settings,
                    color: Colors.pink,
                    size: 30,
                  ),
                );
              } else {
                // Return null if the user is not an admin
                return Icon(Icons.shield_rounded);
              }
            },
          ),
          actions: [
            IconButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushNamed(context, '/main');
              },
              icon: const Icon(Icons.logout),
            ),
            // Conditional display of the register link based on user's role
            // if (isAdmin())
            //   TextButton(
            //     onPressed: () {
            //       // Navigate to the register page
            //       Navigator.pushNamed(context, '/register');
            //     },
            //     child: Text(
            //       'Register',
            //       style: TextStyle(color: Colors.white),
            //     ),
            //   ),
          ],
        ),
        backgroundColor: Colors.blue[400],
        body: SafeArea(
          child: FutureBuilder<Map<String, dynamic>?>(
            future: getUserDetails(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError || snapshot.data == null) {
                return Text('Error fetching user details');
              } else {
                userDetails = snapshot.data!;
                print(userDetails);
                return Container(
                  // alignment: FractionalOffset.bottomCenter,
                  decoration: BoxDecoration(
                    // color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Stack(
                        // fit: StackFit.passthrough,
                        // alignment: Alignment.bottomCenter,
                        children: [
                          Container(
                            height: 600,
                            margin: EdgeInsets.only(top: 100),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(60),
                                  topRight: Radius.circular(60)),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    GestureDetector(
                                      onTap: () => Navigator.pushNamed(
                                          context, '/visitor_in'),
                                      child: Container(
                                        margin: EdgeInsets.only(
                                            left: 20,
                                            right: 5,
                                            top: 140,
                                            bottom: 30),
                                        height: 200,
                                        width: 170,
                                        padding: EdgeInsets.all(10),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                                // margin: EdgeInsets.only(top: 20),
                                                height: 120,
                                                padding: EdgeInsets.all(20),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                child: Image.asset(
                                                    'assets/images/check_in.png')),
                                            SizedBox(height: 10),
                                            Text(
                                              'Check In',
                                              style: GoogleFonts.mavenPro(
                                                  textStyle: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              )),
                                            ),
                                          ],
                                        ),
                                        decoration: BoxDecoration(
                                            color: Colors.grey[50],
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            boxShadow: [
                                              // darker right
                                              BoxShadow(
                                                color: Colors.grey.shade500,
                                                spreadRadius: 1,
                                                blurRadius: 10,
                                                offset: Offset(3, 3),
                                              ),

                                              // lighter left
                                              BoxShadow(
                                                color: Colors.grey.shade500,
                                                spreadRadius: 1,
                                                blurRadius: 10,
                                                offset: Offset(-3, -3),
                                              ),
                                            ]),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () => Navigator.pushNamed(
                                          context, '/visitor_out'),
                                      child: Container(
                                        margin: EdgeInsets.only(
                                            left: 5,
                                            right: 20,
                                            top: 140,
                                            bottom: 30),
                                        padding: EdgeInsets.all(10),
                                        height: 200,
                                        width: 170,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                                // margin: EdgeInsets.only(top: 20),
                                                height: 120,
                                                padding: EdgeInsets.all(20),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  // border: Border.all(
                                                  //   color: Colors.black,
                                                  //   width: 1,
                                                  // )
                                                ),
                                                child: Image.asset(
                                                    'assets/images/check-out.png')),
                                            SizedBox(height: 10),
                                            Text(
                                              'Visitor\nCheck Out',
                                              style: GoogleFonts.mavenPro(
                                                textStyle: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        decoration: BoxDecoration(
                                            color: Colors.grey[50],
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            boxShadow: [
                                              // darker right
                                              BoxShadow(
                                                color: Colors.grey.shade500,
                                                spreadRadius: 1,
                                                blurRadius: 10,
                                                offset: Offset(3, 3),
                                              ),

                                              // lighter left
                                              BoxShadow(
                                                color: Colors.grey.shade300,
                                                spreadRadius: 1,
                                                blurRadius: 10,
                                                offset: Offset(-3, -3),
                                              ),
                                            ]),
                                      ),
                                    ),
                                  ],
                                ),
                                GestureDetector(
                                  onTap: () => Navigator.pushNamed(
                                      context, '/visitor_logs'),
                                  child: Container(
                                    height: 150,
                                    decoration: BoxDecoration(
                                        color: Colors.grey[50],
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: [
                                          // darker right
                                          BoxShadow(
                                            color: Colors.grey.shade500,
                                            spreadRadius: 1,
                                            blurRadius: 10,
                                            offset: Offset(3, 3),
                                          ),

                                          // lighter left
                                          BoxShadow(
                                            color: Colors.grey.shade300,
                                            spreadRadius: 1,
                                            blurRadius: 10,
                                            offset: Offset(-3, -3),
                                          ),
                                        ]),
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                            // margin: EdgeInsets.only(top: 20),
                                            height: 120,
                                            width: 150,
                                            padding: EdgeInsets.all(20),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              // border: Border.all(
                                              //   color: Colors.black,
                                              //   width: 1,
                                              // )
                                            ),
                                            child: Image.asset(
                                                'assets/images/logbook.png')),
                                        SizedBox(width: 10),
                                        Text(
                                          'Visitor\nLogs',
                                          style: GoogleFonts.mavenPro(
                                            textStyle: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 200,
                            padding: EdgeInsets.all(10),
                            margin: EdgeInsets.symmetric(
                                horizontal: 50, vertical: 10),
                            decoration: BoxDecoration(
                              color: Colors.deepOrange[200],
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.deepOrange.withOpacity(0.3),
                                  spreadRadius: 5,
                                  blurRadius: 10,
                                  offset: Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Center(
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Text(
                                      'Welcome: ${userDetails['firstName'].toString().toUpperCase()} ',
                                      style: GoogleFonts.mavenPro(
                                          textStyle: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue[600],
                                      ))),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text('Role: ${userDetails['role']}',
                                      style: GoogleFonts.mavenPro(
                                          textStyle: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.redAccent,
                                      ))),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                      // today's date
                                      'Date Today: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                                      style: GoogleFonts.mavenPro(
                                          textStyle: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ))),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  FutureBuilder<List<Map<String, dynamic>>>(
                                    future: _visitorData,
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return CircularProgressIndicator();
                                      } else if (snapshot.hasError) {
                                        return Text('Error: ${snapshot.error}');
                                      } else {
                                        int totalVisitors =
                                            snapshot.data?.length ?? 0;
                                        return Text(
                                          'Visitors In the premises : $totalVisitors',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }
            },
          ),
        ));
  }
}
