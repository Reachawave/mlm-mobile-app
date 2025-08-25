import 'package:flutter/material.dart';

class TotalVenturesPage extends StatelessWidget {
  const TotalVenturesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: TotalVenturesBody());
  }
}

class TotalVenturesBody extends StatefulWidget {
  const TotalVenturesBody({super.key});

  @override
  State<TotalVenturesBody> createState() => _TotalVenturesBodyState();
}

class _TotalVenturesBodyState extends State<TotalVenturesBody> {
  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> data = [
      {
        "name": "Chinnala Tyuh5 acres ramannapet venture",
        "location": "kanyakumari",
      },
      {"name": "Sunitha 5 acres ramannapet venture", "location": "kondagattu"},
      {"name": "Ravi Kumar-4,hnk,chinnapendyala", "location": "vemulawada"},
    ];
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
            width: double.infinity,
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
                      "Manage Ventures",
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 6.0),
                    InkWell(
                      onTap: () {
                        // showUserFormDialog(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white54,
                          borderRadius: BorderRadius.circular(
                            6,
                          ), // rounded corners
                          border: Border.all(
                            color: Colors.green, // border color
                            width: 0.5,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              height: 16,
                              child: Image.asset(
                                'lib/icons/add.png',
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(
                              width: 6,
                            ), // spacing between icon and text
                            Text(
                              "Create Venture",
                              style: TextStyle(
                                fontSize: 14,
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
                                "lib/icons/bag.png",
                                color: Colors.green,
                              ),
                            ),
                            SizedBox(width: 10.0),
                            Text(
                              "Ventures",
                              style: TextStyle(
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          "Monitor the progress of all ongoing ventures",
                          style: TextStyle(fontSize: 14.0, color: Colors.green),
                        ),
                        SizedBox(height: 30.0),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Name & Location",
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.green,
                                ),
                              ),
                              Text(
                                "Availability",
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 3.0),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: data.length,
                          itemBuilder: (BuildContext context, int index) {
                            final item = data[index];
                            final name = item["name"] ?? '';
                            final location = item["location"] ?? '';

                            return Column(
                              children: [
                                const Divider(
                                  thickness: 0.3,
                                  color: Colors.green,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Name + ID
                                      // Name + ID column (auto-wrap)
                                      Expanded(
                                        flex: 1,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              name,
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.black,
                                              ),
                                              softWrap: true,
                                              overflow: TextOverflow.visible,
                                              maxLines: null,
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              location,
                                              style: const TextStyle(
                                                fontSize: 10,
                                                color: Colors.green,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 30),
                                      Container(
                                        width: 90, // full device width
                                        height: 20,
                                        decoration: BoxDecoration(
                                          color: Colors
                                              .green, // 👈 fill with green
                                          borderRadius: BorderRadius.circular(
                                            30,
                                          ), // 👈 pill shape
                                        ),
                                      ),
                                    ],
                                  ),
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
