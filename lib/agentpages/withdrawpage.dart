import 'package:flutter/material.dart';


class withdrawpage extends StatelessWidget {
  const withdrawpage({super.key});

  @override
  Widget build(BuildContext context) {
    return withdawbody();
  }
}

class withdawbody extends StatefulWidget {
  const withdawbody({super.key});

  @override
  State<withdawbody> createState() => _withdawbodyState();
}

class _withdawbodyState extends State<withdawbody> {
  @override
  Widget build(BuildContext context) {

    final List<Map<String, String>> data = [
      {

        "time": "19:45:00",
        "amount": "2,00,000",
        "date": "1/08/2025,",
        "status": "Pending",
      },
      {

        "time": "4:06:45",
        "amount": "1,50,000",
        "date": "5/08/2025,",
        "status": "Approved",
      },
      {
        "time": "11:06:45",
        "amount": "75,000",
        "date": "10/08/2025,",
        "status": "Declined",
      },
      {

        "time": "10:05:00",
        "amount": "2,00,000",
        "date": "1/08/2025,",
        "status": "Pending",
      },
      {
        "time": "18:24:23",
        "amount": "1,50,000",
        "date": "5/08/2025,",
        "status": "Approved",
      },
      {

        "time": "8:33:00",
        "amount": "75,000",
        "date": "10/08/2025,",
        "status": "Declined",
      },
      // Add more rows as needed
    ];

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
                        Navigator.pop(context); // Go back to previous page
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
                    Text(
                      "Withdraw Funds",
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30.0),
                Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.green, // background color
                    border: Border.all(
                      color: Colors.green, // border color
                      width: 1, // border thickness
                    ),
                    borderRadius: BorderRadius.circular(20), // 👈 circular border radius
                  ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          Text("Available Balance",style: TextStyle(color: Colors.white,fontSize: 24.0),),
                          Row(
                            children: [
                              Container(
                                height: 30.0,
                                child: Image.asset(
                                  "lib/icons/rupee-indian.png",
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: 5.0),
                              Text("0",style: TextStyle(color: Colors.white,fontSize: 50.0,fontWeight: FontWeight.bold),),
                            ],
                          )
                        ],

                      ),
                    ),

                ),
                SizedBox(height: 20.0),
                Container(
                  height: 280,
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
                        Text("Request Withdrawal",style: TextStyle(color: Colors.black,fontSize: 26.0,fontWeight: FontWeight.bold),),
                        Text("Enter the amount you wish to withdraw",
                          style: TextStyle(color: Colors.green,fontSize: 16.0),),
                        SizedBox(height: 20.0),
                        Row(
                          children: [
                            Text(
                              "Amount to withdraw",
                              style: TextStyle(fontSize: 16.0, color: Colors.black),
                            ),
                            SizedBox(width: 5.0),
                            Text(
                              "(",
                              style: TextStyle(fontSize: 16.0, color: Colors.black),
                            ),
                            Container(
                              height: 13.0,
                              child: Image.asset(
                                "lib/icons/rupee-indian.png",
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              ")",
                              style: TextStyle(fontSize: 16.0, color: Colors.black),
                            ),

                          ],
                        ),
                        SizedBox(height: 6.0),
                        TextField(
                          // controller: emailController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(
                                  5,
                                ), // 👈 rectangle with rounded corners
                              ),
                            ),
                            hintText: "e.g.,5000",
                            hintStyle: TextStyle(
                              color: Colors.green,
                              fontSize: 20,
                            ),

                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 10, // 👈 height of TextField
                              horizontal: 20,
                            ),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        SizedBox(
                          width:
                          double.infinity, // take full available width
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors
                                  .green, // 👈 button background color
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  5,
                                ), // 👈 border radius
                              ),
                              padding: const EdgeInsets.symmetric(
                                vertical: 10,
                              ), // taller button
                            ),
                            onPressed: () {

                            },
                            child:  Row(
                                 mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: 20.0,
                                  child: Image.asset(
                                    "lib/icons/upload.png",
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(width: 10.0),
                                Text("Request Withdrawal",style: TextStyle(color: Colors.white,fontSize: 20.0),),
                              ],
                            ),
                          ),
                        ),

                      ],

                    ),
                  ),

                ),
                SizedBox(height: 20.0),
                Container(
                  height: 300,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.grey,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              height: 23.0,
                              child: Image.asset(
                                "lib/icons/history.png",
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(width: 10.0),
                            const Text(
                              "Withdrawal History",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 26.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const Text(
                          "A log of your past Withdrawal requests",
                          style: TextStyle(color: Colors.green, fontSize: 16.0),
                        ),
                        const SizedBox(height: 20.0),

                        // 👇 ListView takes remaining space and scrolls
                        Expanded(
                          child: ListView.builder(
                            itemCount: data.length,
                            itemBuilder: (BuildContext context, int index) {
                              final item = data[index];
                              final time = item["time"]!;
                              final amount = item["amount"]!;
                              final date = item["date"]!;
                              final status = item["status"]!;

                              return Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween, // 👈 equal spacing
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // LEFT SIDE (amount + date + time)
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                height: 15.0,
                                                child: Image.asset(
                                                  "lib/icons/rupee-indian.png",
                                                  color: Colors.black,
                                                ),
                                              ),
                                              const SizedBox(width: 5),
                                              Text(
                                                amount,
                                                style: const TextStyle(
                                                  fontSize: 16.0,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                date,
                                                style: const TextStyle(
                                                  fontSize: 12.0,
                                                  color: Colors.green,
                                                ),
                                              ),
                                              const SizedBox(width: 5),
                                              Text(
                                                time,
                                                style: const TextStyle(
                                                  fontSize: 12.0,
                                                  color: Colors.green,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),

                                      // RIGHT SIDE (status badge)
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: getStatusContainerColor(status),
                                          borderRadius: BorderRadius.circular(50),
                                        ),
                                        child: Text(
                                          status,
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w600,
                                            color: getStatusTextColor(status),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20.0),
                                ],
                              );
                            },
                          ),
                        )

                      ],
                    ),
                  ),
                )


              ],
            ),
          ),
        ),
      ),
    );;
  }
}




// Helper to get background color
Color getStatusContainerColor(String status) {
  switch (status.toLowerCase()) {
    case "approved":
      return Colors.green;
    case "declined":
      return Colors.red;
    case "pending":
      return Colors.grey;
    default:
      return Colors.grey.shade300;
  }
}

// Helper to get text color
Color getStatusTextColor(String status) {
  switch (status.toLowerCase()) {
    case "approved":
    case "declined":
      return Colors.white;
    case "pending":
      return Colors.black;
    default:
      return Colors.black;
  }
}



