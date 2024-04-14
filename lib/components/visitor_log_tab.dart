import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class VisitorLogTab extends StatelessWidget {
  final String houseNumber;
  final String checkOutTime;
  final String visitorName;

  const VisitorLogTab({
    Key? key,
    required this.houseNumber,
    required this.checkOutTime,
    required this.visitorName,
  }) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey[200],
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
              color: Colors.grey.shade500,
              spreadRadius: 1,
              blurRadius: 10,
              offset: Offset(-3, -3),
            ),
          ],
        ),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.all(2),
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.deepOrange[400],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    houseNumber,
                    style: GoogleFonts.mavenPro(
                      textStyle: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(2),
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.deepOrange[400],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    visitorName,
                    style: GoogleFonts.mavenPro(
                      textStyle: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 5, vertical: 8),
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.pink[100],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Time Out',
                  style: GoogleFonts.mavenPro(
                    textStyle: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                Text(
                  checkOutTime,
                  style: GoogleFonts.mavenPro(
                    textStyle: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.all(2),
            padding: EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(20),
            ),
            child: IconButton(
              icon: Icon(Icons.arrow_forward_ios_rounded),
              iconSize: 12,
              color: Colors.blue[400],
              onPressed: () {},
            ),
          ),
        ]));
  }
}
