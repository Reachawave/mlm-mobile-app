import 'package:flutter/material.dart';
import 'package:myprojects/agentpages/withdrawpage.dart';

import 'agentprofilepage.dart';
import 'mainpage.dart' show Agentdashboardmainpage;

class Agentdashboardpage extends StatelessWidget {
  const Agentdashboardpage({super.key});

  @override
  Widget build(BuildContext context) {
    return dashbody();
  }
}

class dashbody extends StatefulWidget {
  const dashbody({super.key});

  @override
  State<dashbody> createState() => _dashbodyState();
}

class _dashbodyState extends State<dashbody> {
  final TextEditingController avgInvestmentCtrl = TextEditingController(
    text: "50000",
  );
  final TextEditingController l1Ctrl = TextEditingController();
  final TextEditingController l2Ctrl = TextEditingController();
  final TextEditingController l3Ctrl = TextEditingController();
  final TextEditingController l4Ctrl = TextEditingController();
  final TextEditingController l5Ctrl = TextEditingController();

  double l1Earning = 0,
      l2Earning = 0,
      l3Earning = 0,
      l4Earning = 0,
      l5Earning = 0;

  double get totalEarning =>
      l1Earning + l2Earning + l3Earning + l4Earning + l5Earning;

  void calculateEarnings() {
    double base = double.tryParse(avgInvestmentCtrl.text) ?? 50000;

    int l1 = int.tryParse(l1Ctrl.text) ?? 0;
    int l2 = int.tryParse(l2Ctrl.text) ?? 0;
    int l3 = int.tryParse(l3Ctrl.text) ?? 0;
    int l4 = int.tryParse(l4Ctrl.text) ?? 0;
    int l5 = int.tryParse(l5Ctrl.text) ?? 0;

    setState(() {
      // Each "1" entered means 1 unit × base amount
      l1Earning = l1 * base * 0.10; // 10%
      l2Earning = l2 * base * 0.02; // 2%
      l3Earning = l3 * base * 0.01; // 1%
      l4Earning = l4 * base * 0.01; // 1%
      l5Earning = l5 * base * 0.01; // 1%
    });
  }

  bool showEarnings = false;
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
                Text(
                  "Welcome Back",
                  style: TextStyle(color: Colors.green, fontSize: 22),
                ),
                SizedBox(height: 5.0),
                Text(
                  "Name of agent",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                ),
                SizedBox(height: 12.0),
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => TotalRevenuePage(),
                        //   ),
                        // );
                      },
                      child: Container(
                        height: 200,
                        width: 175,
                        child: Card(
                          color: Color(0xFF4A9782),
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.asset(
                                  "lib/icons/user-avatar.png",
                                  width: 40,
                                  height: 40,
                                  color: Colors.white,
                                ),
                                SizedBox(height: 20),
                                Text(
                                  "My Referrals",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                                SizedBox(height: 5.0),
                                Text(
                                  "View Your", // 👈 text comes from list
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  "Network", // 👈 text comes from list
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Agentdashboardmainpage(
                              initialIndex: 2,
                            ), // 👈 Withdraw tab
                          ),
                        );
                      },
                      child: Container(
                        height: 200,
                        width: 175,
                        child: Card(
                          color: Color(0xFFD92C54),
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.account_balance_wallet_outlined,
                                  size: 40,
                                  color: Colors.white,
                                ),
                                SizedBox(height: 30),
                                Visibility(
                                  visible: false,
                                  child: Text(
                                    "Withdraw", // 👈 text comes from list
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 5.0),
                                Text(
                                  "Withdraw", // 👈 text comes from list
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                                Text(
                                  "0", // 👈 text comes from list
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
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
                SizedBox(height: 10.0),
                Row(
                  children: [
                    InkWell(
                      onTap: () {},
                      child: Container(
                        height: 200,
                        width: 175,
                        child: Card(
                          color: Color(0xFF3D74B6),
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.asset(
                                  "lib/icons/notification.png", // 👈 your image path
                                  width: 40, // same as icon size
                                  height: 40,
                                  color: Colors
                                      .white, // optional → applies color overlay like Icon
                                ),
                                SizedBox(height: 30),
                                Visibility(
                                  visible: false,
                                  child: Text(
                                    "Withdraw", // 👈 text comes from list
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 5.0),
                                Text(
                                  "Notifications", // 👈 text comes from list
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                                Text(
                                  "Recent updates", // 👈 text comes from list
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Agentdashboardmainpage(
                              initialIndex: 4,
                            ), // 👈 Withdraw tab
                          ),
                        );
                      },
                      child: Container(
                        height: 200,
                        width: 175,
                        child: Card(
                          color: Color(0xFFB13BFF),
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.asset(
                                  "lib/icons/profile.png", // 👈 your image path
                                  width: 40, // same as icon size
                                  height: 40,
                                  color: Colors
                                      .white, // optional → applies color overlay like Icon
                                ),
                                SizedBox(height: 30),
                                Visibility(
                                  visible: false,
                                  child: Text(
                                    "Withdraw", // 👈 text comes from list
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 5.0),
                                Text(
                                  "Profile", // 👈 text comes from list
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                                Text(
                                  "your details", // 👈 text comes from list
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
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
                SizedBox(height: 10.0),
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => TotalVenturesPage(),
                        //   ),
                        // );
                      },
                      child: Container(
                        height: 200,
                        width: 175,
                        child: Card(
                          color: Color(0xFFD92C54),
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.asset(
                                  "lib/icons/charts.png", // 👈 your image path
                                  width: 40, // same as icon size
                                  height: 40,
                                  color: Colors
                                      .white, // optional → applies color overlay like Icon
                                ),
                                SizedBox(height: 20),
                                Text(
                                  "Commission", // 👈 text comes from list
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                                SizedBox(height: 5.0),
                                Text(
                                  "Report", // 👈 text comes from list
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                                Text(
                                  "Earnings details",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    InkWell(
                      onTap: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => ManageBranchesPage(),
                        //   ),
                        // );
                      },
                      child: Container(
                        height: 200,
                        width: 175,
                        child: Card(
                          color: Color(0xFFFFD66B),
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.asset(
                                  "lib/icons/text.png", // 👈 your image path
                                  width: 40, // same as icon size
                                  height: 40,
                                  color: Colors
                                      .white, // optional → applies color overlay like Icon
                                ),
                                SizedBox(height: 20),
                                Text(
                                  "My Layouts", // 👈 text comes from list
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                                SizedBox(height: 5.0),
                                Text(
                                  "venure", // 👈 text comes from list
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  "documents", // 👈 text comes from list
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
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
                SizedBox(height: 10.0),
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => Referrelpage(),
                        //   ),
                        // );
                      },

                      child: Container(
                        width: 175,
                        child: Card(
                          color: Color(0xFF67AE6E),
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.asset(
                                  "lib/icons/telephone.png", // 👈 your image path
                                  width: 40, // same as icon size
                                  height: 40,
                                  color: Colors
                                      .white, // optional → applies color overlay like Icon
                                ),
                                SizedBox(height: 40),
                                Visibility(
                                  visible: false,
                                  child: Text(
                                    "Withdraw", // 👈 text comes from list
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 5.0),
                                Text(
                                  "Contact Us", // 👈 text comes from list
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                                Text(
                                  "Get support", // 👈 text comes from list
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    InkWell(
                      onTap: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => Withdrawalrequestpage(),
                        //   ),
                        // );
                      },
                      child: Container(
                        width: 175,
                        child: Card(
                          color: Color(0xFF3D74B6),
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.asset(
                                  "lib/icons/info-sign.png", // 👈 your image path
                                  width: 40, // same as icon size
                                  height: 40,
                                  color: Colors
                                      .white, // optional → applies color overlay like Icon
                                ),
                                SizedBox(height: 40),
                                Visibility(
                                  visible: false,
                                  child: Text(
                                    "Withdraw", // 👈 text comes from list
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 5.0),
                                Text(
                                  "About Us", // 👈 text comes from list
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                                Text(
                                  "Our company", // 👈 text comes from list
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
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
                SizedBox(height: 20.0),
                Container(
                  width: 1000,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black12, width: 1.0),
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(
                      10.0,
                    ), // Uniform radius for all corners
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              height: 24.0,
                              child: Image.asset(
                                "lib/icons/calculator.png",
                                color: Colors.green,
                              ),
                            ),
                            SizedBox(width: 10.0),
                            Text(
                              "Potential Earnings Calculator",
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Estimate your potential commission",
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.green,
                              ),
                            ),
                            Text(
                              "based on your refferal network",
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 30.0),
                        Text(
                          "Average Investment per Unit",
                          style: TextStyle(fontSize: 16.0, color: Colors.black),
                        ),
                        TextField(
                          controller: avgInvestmentCtrl,
                          keyboardType: TextInputType.number,
                          onChanged: (_) => calculateEarnings(),
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(
                                  5,
                                ), // 👈 rectangle with rounded corners
                              ),
                            ),
                            hintText: "50000",
                            hintStyle: TextStyle(
                              color: Colors.green,
                              fontSize: 16,
                            ),

                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 10, // 👈 height of TextField
                              horizontal: 20,
                            ),
                          ),
                        ),
                        SizedBox(height: 10.0),

                        Row(
                          children: [
                            // First Column
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Level 1",
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  TextField(
                                    controller: l1Ctrl,
                                    keyboardType: TextInputType.number,
                                    onChanged: (_) => calculateEarnings(),
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(5),
                                        ),
                                      ),
                                      // hintText: "50000",
                                      hintStyle: TextStyle(
                                        color: Colors.green,
                                        fontSize: 16,
                                      ),
                                      contentPadding: EdgeInsets.symmetric(
                                        vertical: 10,
                                        horizontal: 20,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(width: 16), // space between columns
                            // Second Column
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Level 2",
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  TextField(
                                    controller: l2Ctrl,
                                    keyboardType: TextInputType.number,
                                    onChanged: (_) => calculateEarnings(),
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(5),
                                        ),
                                      ),
                                      // hintText: "100",
                                      hintStyle: TextStyle(
                                        color: Colors.green,
                                        fontSize: 16,
                                      ),
                                      contentPadding: EdgeInsets.symmetric(
                                        vertical: 10,
                                        horizontal: 20,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.0),

                        Row(
                          children: [
                            // First Column
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Level 3",
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  TextField(
                                    controller: l3Ctrl,
                                    keyboardType: TextInputType.number,
                                    onChanged: (_) => calculateEarnings(),
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(5),
                                        ),
                                      ),
                                      // hintText: "50000",
                                      hintStyle: TextStyle(
                                        color: Colors.green,
                                        fontSize: 16,
                                      ),
                                      contentPadding: EdgeInsets.symmetric(
                                        vertical: 10,
                                        horizontal: 20,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(width: 16), // space between columns
                            // Second Column
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Level 4",
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  TextField(
                                    controller: l4Ctrl,
                                    keyboardType: TextInputType.number,
                                    onChanged: (_) => calculateEarnings(),
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(5),
                                        ),
                                      ),
                                      // hintText: "100",
                                      hintStyle: TextStyle(
                                        color: Colors.green,
                                        fontSize: 16,
                                      ),
                                      contentPadding: EdgeInsets.symmetric(
                                        vertical: 10,
                                        horizontal: 20,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.0),

                        Row(
                          children: [
                            // 👉 Left side: Text + TextField
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Level 5",
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  SizedBox(
                                    height: 48, // 👈 fixed height
                                    child: TextField(
                                      controller: l5Ctrl,
                                      keyboardType: TextInputType.number,
                                      onChanged: (_) => calculateEarnings(),
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(5),
                                          ),
                                        ),
                                        contentPadding: EdgeInsets.symmetric(
                                          vertical: 10,
                                          horizontal: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(width: 16),

                            // 👉 Right side: Button with same height & width
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Visibility(
                                    visible: false,
                                    child: const Text(
                                      "Hidden",
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 25,
                                  ), // 👈 match top spacing
                                  SizedBox(
                                    height: 45,
                                    width: 300, // 👈 same as TextField
                                    child: ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green,
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            5,
                                          ),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 20,
                                        ),
                                      ),
                                      onPressed: () {
                                        calculateEarnings(); // update values
                                        setState(() {
                                          showEarnings =
                                              true; // 👈 show box only after pressing button
                                        });
                                      },
                                      icon: Image.asset(
                                        "lib/icons/percent.png",
                                        height: 15,
                                        width: 15,
                                        color: Colors.white,
                                      ),
                                      label: const Text(
                                        "Calculate",
                                        style: TextStyle(fontSize: 16.0),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20.0),
                        Visibility(
                          visible: showEarnings,
                          child: Container(
                            height: 350,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white30,
                              border: Border.all(
                                color: Colors.black12,
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
                                        height: 20.0,
                                        child: Image.asset(
                                          "lib/icons/history.png",
                                          color: Colors.green,
                                        ),
                                      ),
                                      const SizedBox(width: 10.0),
                                      const Text(
                                        "Estimated Earnigs",
                                        style: TextStyle(
                                          color: Colors.green,
                                          fontSize: 20.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 20.0),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Level 1 Commission (10%)",
                                        style: TextStyle(
                                          color: Colors.green,
                                          fontSize: 16.0,
                                        ),
                                      ),
                                      Text(
                                        " ₹${l1Earning.toStringAsFixed(0)}",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10.0),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Level 2 Commission (2%)",
                                        style: TextStyle(
                                          color: Colors.green,
                                          fontSize: 16.0,
                                        ),
                                      ),
                                      Text(
                                        " ₹${l2Earning.toStringAsFixed(0)}",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10.0),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Level 3 Commission (1%)",
                                        style: TextStyle(
                                          color: Colors.green,
                                          fontSize: 16.0,
                                        ),
                                      ),
                                      Text(
                                        "₹${l3Earning.toStringAsFixed(0)}",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10.0),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Level 4 Commission (1%)",
                                        style: TextStyle(
                                          color: Colors.green,
                                          fontSize: 16.0,
                                        ),
                                      ),
                                      Text(
                                        "₹${l4Earning.toStringAsFixed(0)}",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10.0),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Level 5 Commission (1%)",
                                        style: TextStyle(
                                          color: Colors.green,
                                          fontSize: 16.0,
                                        ),
                                      ),
                                      Text(
                                        "₹${l5Earning.toStringAsFixed(0)}",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10.0),
                                  Divider(thickness: 0.3, color: Colors.grey),
                                  SizedBox(height: 10.0),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Total Potential ",
                                            style: TextStyle(
                                              color: Colors.green,
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            "Earnings",
                                            style: TextStyle(
                                              color: Colors.green,
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        "₹${totalEarning.toStringAsFixed(0)}",
                                        style: TextStyle(
                                          color: Colors.green,
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
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
        ),
      ),
    );
  }
}
