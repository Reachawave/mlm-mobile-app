import 'package:flutter/material.dart';
import 'package:myprojects/pages/WithdrawalRequestPage.dart';

import 'CommisionPayoutPage.dart';
import 'DashboardPage.dart';
import 'ManageAgentsPage.dart';
import 'ManageBranches.dart';
import 'TotalRevenuePage.dart';

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
  void showUserFormDialog(BuildContext context) {
    final TextEditingController ventureNameController = TextEditingController();
    final TextEditingController locationController = TextEditingController();
    final TextEditingController totaltreesController = TextEditingController();
    final TextEditingController treessoldController = TextEditingController();
    String? selectedVenureStatus;

    final List<String> venturestatus = ["Upcoming", "Ongoing", "Completed"];

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          insetPadding: EdgeInsets.zero, // 👈 removes side margins
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero, // 👈 square corners
          ),
          child: SizedBox(
            width: double.infinity, // 👈 full width
            height: 700, // adjust height as needed
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 30.0,
                vertical: 8.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // 👇 Close button at top-right
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.black54),
                    iconSize: 24,
                    onPressed: () => Navigator.of(context).pop(),
                  ),

                  // Title + subtitle
                  Column(
                    children: const [
                      Text(
                        "Create New Venture",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "Fill in the details below to add a new venture",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.green, fontSize: 16.0),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),

                  // 👇 Scrollable form
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Venture Name",
                            style: TextStyle(fontSize: 16.0),
                          ),
                          const SizedBox(height: 6.0),
                          TextField(
                            controller: ventureNameController,
                            decoration: const InputDecoration(
                              hintText: "e.g.,Green Meadows Phase 1",
                              hintStyle: TextStyle(
                                color: Colors.green,
                                fontSize: 16,
                              ),
                              border: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.green,
                                  width: 2.0,
                                ),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 20,
                              ),
                            ),
                          ),

                          const SizedBox(height: 10),
                          const Text(
                            "Location",
                            style: TextStyle(fontSize: 16.0),
                          ),
                          const SizedBox(height: 6.0),
                          TextField(
                            controller: locationController,
                            decoration: const InputDecoration(
                              hintText: "e.g.,Near Pharma City",
                              hintStyle: TextStyle(
                                color: Colors.green,
                                fontSize: 16,
                              ),
                              border: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.green,
                                  width: 2.0,
                                ),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 20,
                              ),
                            ),
                          ),

                          const SizedBox(height: 10),
                          const Text(
                            "Status",
                            style: TextStyle(fontSize: 16.0),
                          ),
                          const SizedBox(height: 6.0),
                          DropdownButtonFormField<String>(
                            value: selectedVenureStatus,
                            items: venturestatus.map((ventures) {
                              return DropdownMenuItem(
                                value: ventures,
                                child: Text(
                                  ventures,
                                  style: const TextStyle(fontSize: 14),
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedVenureStatus = value;
                              });
                            },
                            hint: const Text(
                              "Select venture status",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: Colors.grey,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: Colors.grey,
                                  width: 1.5,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: Colors.green,
                                  width: 2,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 14,
                                horizontal: 12,
                              ),
                            ),
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                            ),
                            dropdownColor: Colors.white,
                            icon: const Icon(
                              Icons.arrow_drop_down,
                              color: Colors.black,
                            ),
                          ),

                          const SizedBox(height: 10),
                          const Text(
                            "Total Trees",
                            style: TextStyle(fontSize: 16.0),
                          ),
                          const SizedBox(height: 6.0),
                          TextField(
                            controller: totaltreesController,
                            decoration: const InputDecoration(
                              hintText: "e.g.,100",
                              hintStyle: TextStyle(
                                color: Colors.green,
                                fontSize: 16,
                              ),
                              border: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.green,
                                  width: 2.0,
                                ),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 20,
                              ),
                            ),
                          ),

                          const SizedBox(height: 10),
                          const Text(
                            "Trees Sold(Initial)",
                            style: TextStyle(fontSize: 16.0),
                          ),
                          const SizedBox(height: 6.0),
                          TextField(
                            controller: totaltreesController,
                            decoration: const InputDecoration(
                              hintText: "0",
                              hintStyle: TextStyle(
                                color: Colors.green,
                                fontSize: 16,
                              ),
                              border: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.green,
                                  width: 2.0,
                                ),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 20,
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity, // full width button
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                              ),
                              onPressed: () {
                                print(
                                  "venture name: ${ventureNameController.text}",
                                );
                                print("location: ${locationController.text}");

                                print(
                                  "total trees: ${totaltreesController.text}",
                                );
                                print(
                                  "trees sold: ${treessoldController.text}",
                                );

                                Navigator.of(context).pop();
                              },
                              child: const Text(
                                "Create Venture",
                                style: TextStyle(fontSize: 16.0),
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
        );
      },
    );
  }

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
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Dashboardpage(),
                        ),
                      );
                    },
                    imagePath: "lib/icons/home.png",
                    title: "Dashboard",
                  ),

                  DrawerMenuRow(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ManageAgentPage(),
                        ),
                      );
                    },
                    icon: Icons.people_outlined,
                    title: "Agents",
                  ),
                  DrawerMenuRow(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TotalVenturesPage(),
                        ),
                      );
                    },
                    imagePath: "lib/icons/bag.png",
                    title: "Ventures",
                  ),

                  DrawerMenuRow(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ManageBranchesPage(),
                        ),
                      );
                    },
                    imagePath: "lib/icons/git.png",
                    title: "Branches",
                  ),
                  DrawerMenuRow(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TotalRevenuePage(),
                        ),
                      );
                    },
                    icon: Icons.account_balance_wallet_outlined,
                    title: "Investments",
                  ),
                  DrawerMenuRow(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CommisionPayoutPage(),
                        ),
                      );
                    },
                    imagePath: "lib/icons/coins.png",
                    title: "Payouts",
                  ),
                  DrawerMenuRow(
                    onTap: () {
                      Navigator.pop(context);
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => const TotalRevenuePage(),
                      //   ),
                      // );
                    },
                    imagePath: "lib/icons/decision-tree.png",
                    title: "Referral Tree",
                  ),
                  DrawerMenuRow(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Withdrawalrequestpage(),
                        ),
                      );
                    },
                    imagePath: "lib/icons/coins.png",
                    title: "Withdrawals",
                  ),
                  DrawerMenuRow(
                    onTap: () {
                      Navigator.pop(context);
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => const TotalRevenuePage(),
                      //   ),
                      // );
                    },
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
                    Expanded(
                      flex: 1,
                      child: Text(
                        "Manage\nVentures",
                        style: TextStyle(
                          fontSize: 26.0,
                          fontWeight: FontWeight.bold,
                        ),
                        softWrap: true,
                        overflow: TextOverflow.visible,
                        maxLines: null,
                      ),
                    ),
                    // Text(
                    //   "Manage\nVentures",
                    //   style: TextStyle(
                    //     fontSize: 26.0,
                    //     fontWeight: FontWeight.bold,
                    //   ),
                    // ),
                    SizedBox(width: 20.0),
                    InkWell(
                      onTap: () {
                        showUserFormDialog(context);
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
                          style: TextStyle(fontSize: 16.0, color: Colors.green),
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
                                                fontSize: 14,
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
                                                fontSize: 14,
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
  final VoidCallback? onTap; // <-- add this

  const DrawerMenuRow({
    super.key,
    this.icon,
    this.imagePath,
    required this.title,
    this.onTap, // <-- accept callback
  });

  @override
  Widget build(BuildContext context) {
    Widget leadingWidget;

    if (imagePath != null) {
      leadingWidget = Image.asset(
        imagePath!,
        width: 24,
        height: 24,
        color: Colors.green,
      );
    } else if (icon != null) {
      leadingWidget = Icon(icon, color: Colors.green);
    } else {
      leadingWidget = const SizedBox(width: 24, height: 24);
    }

    return InkWell(
      onTap: onTap, // <-- call the callback
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
