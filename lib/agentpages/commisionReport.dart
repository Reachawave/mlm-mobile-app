import 'package:flutter/material.dart';

import 'mainpage.dart';

class Commisionreport extends StatelessWidget {
  const Commisionreport({super.key});

  @override
  Widget build(BuildContext context) {
    return const reportbody();
  }
}

class reportbody extends StatefulWidget {
  const reportbody({super.key});

  @override
  State<reportbody> createState() => _reportbodyState();
}

class _reportbodyState extends State<reportbody> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Agentdashboardmainpage(initialIndex: 0), // 👈 Withdraw tab
                          ),
                        );
                      },
                      child: Container(
                        height: 45,
                        width: 45,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black12, width: 1.0),
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(
                            10.0,
                          ), // Uniform radius for all corners
                        ),
                        child: Container(
                          height: 8,
                          child: Image.asset(
                            'lib/icons/back-arrow.png',
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 20.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Commission",
                          style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Report",
                          style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 30.0),
                    InkWell(
                      onTap: () {

                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          // color: Colors.green,
                          borderRadius: BorderRadius.circular(
                            6,
                          ), // rounded corners
                          border: Border.all(
                            color: Colors.grey, // border color
                            width: 0.5,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              height: 24,
                              child: Image.asset(
                                'lib/icons/share.png',
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(
                              width: 6,
                            ), // spacing between icon and text
                            Text(
                              "Share",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30.0),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white, // background color
                    border: Border.all(
                      color: Colors.grey, // border color
                      width: 1, // border thickness
                    ),
                    borderRadius: BorderRadius.circular(20), // 👈 circular border radius
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [



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



