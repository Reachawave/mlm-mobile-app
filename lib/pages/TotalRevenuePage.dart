import 'package:flutter/material.dart';

class TotalRevenuePage extends StatelessWidget {
  const TotalRevenuePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: TotalRevenueBody());
  }
}

class TotalRevenueBody extends StatefulWidget {
  const TotalRevenueBody({super.key});

  @override
  State<TotalRevenueBody> createState() => _TotalRevenueBodyState();
}

class _TotalRevenueBodyState extends State<TotalRevenueBody> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawerEnableOpenDragGesture: false,
      drawer: Drawer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 30.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.close,
                    color: Colors.black54,
                    size: 18,
                  ),
                  onPressed: () {
                    Navigator.pop(context); // Close drawer
                  },
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 2),
              child: Row(
                children: [
                  Icon(Icons.menu, color: Colors.green),
                  SizedBox(width: 15),
                  Text(
                    "Sri Vayutej \nDevelopers",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  DrawerMenuRow(
                    imagePath: "lib/icons/home.png",
                    title: "Dashboard",
                  ),
                  DrawerMenuRow(icon: Icons.people_outlined, title: "Agents"),
                  DrawerMenuRow(
                    imagePath: "lib/icons/bag.png",
                    title: "Ventures",
                  ),
                  DrawerMenuRow(
                    imagePath: "lib/icons/git.png",
                    title: "Branches",
                  ),
                  DrawerMenuRow(
                    icon: Icons.account_balance_wallet_outlined,
                    title: "Investments",
                  ),
                  DrawerMenuRow(
                    imagePath: "lib/icons/coins.png",
                    title: "Payouts",
                  ),
                  DrawerMenuRow(
                    imagePath: "lib/icons/decision-tree.png",
                    title: "Referral Tree",
                  ),
                  DrawerMenuRow(
                    imagePath: "lib/icons/coins.png",
                    title: "Withdrawals",
                  ),
                  DrawerMenuRow(
                    imagePath: "lib/icons/charts.png",
                    title: "Reports",
                  ),
                  SizedBox(height: 150),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      child: Row(
                        children: [
                          Container(
                            height: 24,
                            child: Image.asset(
                              'lib/icons/back-arrow.png',
                              color: Colors.green,
                            ),
                          ),
                          SizedBox(width: 15),
                          Text(
                            "Go Back",
                            style: TextStyle(fontSize: 16, color: Colors.green),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Padding(
          padding: EdgeInsets.all(8.0),
          child: Container(
            height: 15,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black12, // Sets the color of the border
                width: 1.0, // Sets the width of the border
              ),
              color: Colors.white,
              borderRadius: BorderRadius.circular(
                10.0,
              ), // Uniform radius for all corners
            ),
            child: Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  Scaffold.of(context).openDrawer(); // 👈 open only by button
                },
              ),
            ),
          ),
        ),

        actions: [
          Container(
            height: 25,
            child: Image.asset('lib/icons/active.png', color: Colors.black),
          ),
          SizedBox(width: 10.0),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Container(
              height: 30,
              child: Image.asset('lib/icons/user.png'),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Container(color: Colors.black12, height: 1.0),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
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
                    SizedBox(width: 20.0),
                    Text(
                      "All Investments",
                      style: TextStyle(
                        fontSize: 26.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30.0),
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
                                "lib/icons/pig.png",
                                color: Colors.green,
                              ),
                            ),
                            SizedBox(width: 10.0),
                            Text(
                              "Recent Investments",
                              style: TextStyle(
                                fontSize: 26.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          "A log of rfecent investment activities",
                          style: TextStyle(fontSize: 16.0, color: Colors.green),
                        ),
                        SizedBox(height: 30.0),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Agent",
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.green,
                                ),
                              ),
                              Text(
                                "Amount",
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 3.0),
                        Divider(thickness: 0.3, color: Colors.green),
                        ListView.builder(
                          shrinkWrap: true, // ✅ let it size itself
                          physics:
                              const NeverScrollableScrollPhysics(), // ✅ avoid nested scroll
                          itemCount: 10,
                          itemBuilder: (BuildContext context, int index) {
                            return Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: const [
                                          Text(
                                            "p.sunitha",
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.black,
                                            ),
                                          ),
                                          SizedBox(height: 2),
                                          Text(
                                            "svd-st-23",
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.green,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: const [
                                          Visibility(
                                            visible: false,
                                            child: Text(
                                              "p.sunitha",
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            "50,000",
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const Divider(
                                  thickness: 0.3,
                                  color: Colors.green,
                                ),
                              ],
                            );
                          },
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

class DrawerMenuRow extends StatelessWidget {
  final IconData? icon; // optional icon
  final String? imagePath; // optional image
  final String title;

  const DrawerMenuRow({
    super.key,
    this.icon,
    this.imagePath,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    Widget leadingWidget;

    if (imagePath != null) {
      // If image provided, show image
      leadingWidget = Image.asset(
        imagePath!,
        width: 24,
        height: 24,
        color: Colors.green, // optional tint
      );
    } else if (icon != null) {
      // If icon provided, show icon
      leadingWidget = Icon(icon, color: Colors.green);
    } else {
      // fallback (empty box if nothing passed)
      leadingWidget = const SizedBox(width: 24, height: 24);
    }

    return InkWell(
      onTap: () {
        Navigator.pop(context); // Close drawer on tap
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        child: Row(
          children: [
            leadingWidget,
            const SizedBox(width: 15),
            Text(
              title,
              style: const TextStyle(fontSize: 20, color: Colors.green),
            ),
          ],
        ),
      ),
    );
  }
}
