import 'package:flutter/material.dart';

class notifypage extends StatelessWidget {
  const notifypage({super.key});

  @override
  Widget build(BuildContext context) {
    return notifybody();
  }
}

class notifybody extends StatefulWidget {
  const notifybody({super.key});

  @override
  State<notifybody> createState() => _notifybodyState();
}

class _notifybodyState extends State<notifybody> {
  List<Map<String, dynamic>> payments = [
    {
      "title1": "Payment",
      "title2": "Processed",
      "date": "31/07/2025",
      "time": "20:40:15",
      "message":
          "Your withdrawal request of 62,000 has been approved and processed. Ref No:00",
      "isRead": false,
    },
    {
      "title1": "Payment",
      "title2": "Processed",
      "date": "15/08/2025",
      "time": "10:22:45",
      "message":
          "Your withdrawal request of 25,000 has been processed successfully. Ref No:01",
      "isRead": false,
    },
    {
      "title1": "Payment",
      "title2": "Processed",
      "date": "20/09/2025",
      "time": "09:15:30",
      "message": "You have successfully deposited 10,000. Ref No:02",
      "isRead": false,
    },
    {
      "title1": "Payment",
      "title2": "Processed",
      "date": "31/07/2025",
      "time": "20:40:15",
      "message":
          "Your withdrawal request of 62,000 has been approved and processed. Ref No:00",
      "isRead": false,
    },
    {
      "title1": "Payment",
      "title2": "Processed",
      "date": "31/07/2025",
      "time": "20:40:15",
      "message":
          "Your withdrawal request of 62,000 has been approved and processed. Ref No:00",
      "isRead": false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context); // Go back to previous page
                    },
                    child: Container(
                      height: 45,
                      width: 45,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black12, width: 1.0),
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(
                          5.0,
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
                  Text(
                    "Notifications",
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30.0),

              // Container(
              //   width: double.infinity,
              //   decoration: BoxDecoration(
              //     color: isRead
              //         ? Colors.grey[300]
              //         : Colors.white, // change color on mark read
              //     border: Border.all(color: Colors.grey, width: 1),
              //     borderRadius: BorderRadius.circular(20),
              //   ),
              //   child: Padding(
              //     padding: const EdgeInsets.all(20.0),
              //     child: Column(
              //       children: [
              //         Row(
              //           children: [
              //             Column(
              //               crossAxisAlignment: CrossAxisAlignment.start,
              //               children: const [
              //                 Text(
              //                   "Payment",
              //                   style: TextStyle(
              //                     fontSize: 25.0,
              //                     fontWeight: FontWeight.bold,
              //                   ),
              //                 ),
              //                 Text(
              //                   "Processed",
              //                   style: TextStyle(
              //                     fontSize: 25.0,
              //                     fontWeight: FontWeight.bold,
              //                   ),
              //                 ),
              //               ],
              //             ),
              //             const Spacer(),
              //             Visibility(
              //               visible: !isRead, // hide after clicked
              //               child: GestureDetector(
              //                 onTap: () {
              //                   setState(() {
              //                     isRead = true; // update state
              //                   });
              //                 },
              //                 child: Container(
              //                   width: 110,
              //                   height: 45,
              //                   decoration: BoxDecoration(
              //                     color: Colors.white,
              //                     border: Border.all(
              //                       color: Colors.grey,
              //                       width: 1,
              //                     ),
              //                     borderRadius: BorderRadius.circular(20),
              //                   ),
              //                   child: Padding(
              //                     padding: const EdgeInsets.all(10.0),
              //                     child: Row(
              //                       children: [
              //                         SizedBox(
              //                           height: 14,
              //                           child: Image.asset(
              //                             'lib/icons/check.png',
              //                             color: Colors.black,
              //                           ),
              //                         ),
              //                         const SizedBox(width: 5.0),
              //                         const Text(
              //                           "Mark Read",
              //                           style: TextStyle(
              //                             fontSize: 14.0,
              //                             fontWeight: FontWeight.bold,
              //                           ),
              //                         ),
              //                       ],
              //                     ),
              //                   ),
              //                 ),
              //               ),
              //             ),
              //           ],
              //         ),
              //         Row(
              //           children: const [
              //             Text(
              //               "31/07/2025 ,",
              //               style: TextStyle(
              //                 fontSize: 14.0,
              //                 color: Colors.green,
              //                 fontWeight: FontWeight.bold,
              //               ),
              //             ),
              //             Text(
              //               " 20:40:15",
              //               style: TextStyle(
              //                 fontSize: 14.0,
              //                 color: Colors.green,
              //                 fontWeight: FontWeight.bold,
              //               ),
              //             ),
              //           ],
              //         ),
              //         const SizedBox(height: 20.0),
              //         const Text(
              //           "Your withdrawal request of 62,000 has been approved and processed. Ref No:00",
              //           style: TextStyle(fontSize: 14.0, color: Colors.black),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: payments.length,
                  itemBuilder: (context, index) {
                    final payment = payments[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: payment["isRead"]
                            ? Colors.grey[300]
                            : Colors.white,
                        border: Border.all(color: Colors.grey, width: 1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      payment["title1"],
                                      style: const TextStyle(
                                        fontSize: 25.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      payment["title2"],
                                      style: const TextStyle(
                                        fontSize: 25.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                Visibility(
                                  visible: !payment["isRead"],
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        payments[index]["isRead"] = true;
                                      });
                                    },
                                    child: Container(
                                      width: 110,
                                      height: 45,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                          color: Colors.grey,
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              height: 14,
                                              child: Image.asset(
                                                'lib/icons/check.png',
                                                color: Colors.black,
                                              ),
                                            ),
                                            const SizedBox(width: 5.0),
                                            const Text(
                                              "Mark Read",
                                              style: TextStyle(
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  "${payment["date"]} ,",
                                  style: const TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  " ${payment["time"]}",
                                  style: const TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20.0),
                            Text(
                              payment["message"],
                              style: const TextStyle(
                                fontSize: 14.0,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
