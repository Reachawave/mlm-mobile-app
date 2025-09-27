import 'package:flutter/material.dart';

import 'mainpage.dart';

class MyNetworkPage extends StatefulWidget {
  const MyNetworkPage({super.key});

  @override
  State<MyNetworkPage> createState() => _MyNetworkPageState();
}

class _MyNetworkPageState extends State<MyNetworkPage> {
  // bool _isExpanded = false; // for arrow toggle
  // List<String>
  // referrals = ["Agent 1", "Agent 2", "Agent 3"];

  // Suppose this is your data
  final List<Map<String, dynamic>> levels = [
    {
      "level": 1,
      "referrals": ["Agent A", "Agent B", "Agent C"],
    },
    {
      "level": 2,
      "referrals": ["Agent D", "Agent E", "Agent F", "Agent G", "Agent H"],
    },
    {
      "level": 3,
      "referrals": ["Agent I", "Agent J", "Agent K"],
    },
    {
      "level": 4,
      "referrals": ["Agent L", "Agent M", "Agent N"],
    },
  ];

  List<bool> _isExpandedList =
      []; // Track which levels are expanded// sample list

  @override
  void initState() {
    super.initState();
    _isExpandedList = List.generate(levels.length, (_) => false);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🔙 Back button + Title
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
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Image.asset(
                          'lib/icons/back-arrow.png',
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(width: 20.0),
                    const Text(
                      "My Network",
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30.0),

                // 📦 Card Container
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey, width: 1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Referral tree header
                        Row(
                          children: [
                            Container(
                              height: 23.0,
                              child: Image.asset(
                                "lib/icons/decision-tree.png",
                                color: Colors.green,
                              ),
                            ),
                            const SizedBox(width: 10.0),
                            const Text(
                              "Referral Tree",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const Text(
                          "Your network of referrals, upline and downline",
                          style: TextStyle(color: Colors.green, fontSize: 16.0),
                        ),

                        const SizedBox(height: 20.0),

                        // Upline
                        Container(
                          height: 80.0,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey, width: 1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      height: 18.0,
                                      child: Image.asset(
                                        "lib/icons/up-arrow.png",
                                        color: Colors.green,
                                      ),
                                    ),
                                    const SizedBox(width: 10.0),
                                    const Text(
                                      "Your Upline",
                                      style: TextStyle(
                                        color: Colors.green,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10.0),
                                const Text(
                                  "You are a top-level agent",
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 14.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 10.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  height: 18.0,
                                  child: Image.asset(
                                    "lib/icons/ticperson.png",
                                    color: Colors.green,
                                  ),
                                ),
                                const SizedBox(width: 10.0),
                                const Text(
                                  "Your Downline",
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 10.0),

                        ListView.builder(
                          shrinkWrap:
                              true, // required when inside Column/SingleChildScrollView
                          physics:
                              const NeverScrollableScrollPhysics(), // prevent nested scroll
                          itemCount: levels.length,
                          itemBuilder: (context, index) {
                            final levelData = levels[index];
                            final level = levelData["level"];
                            final referrals =
                                levelData["referrals"] as List<String>;
                            final isExpanded = _isExpandedList[index];

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      _isExpandedList[index] = !isExpanded;
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 8.0,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Level $level (${referrals.length} Referrals)",
                                          style: const TextStyle(fontSize: 20),
                                        ),
                                        Icon(
                                          isExpanded
                                              ? Icons.keyboard_arrow_up
                                              : Icons.keyboard_arrow_down,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                if (isExpanded)
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: referrals.map((ref) {
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                          top: 8.0,
                                          left: 12.0,
                                        ),
                                        child: Row(
                                          children: [
                                            // 👤 Icon
                                            Container(
                                              height: 30,
                                              width: 30,
                                              decoration: BoxDecoration(
                                                color: Colors.green.withOpacity(
                                                  0.1,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                              ),
                                              child: Center(
                                                child: Image.asset(
                                                  "lib/icons/ticperson.png",
                                                  height: 18,
                                                  color: Colors.green,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 10),

                                            // Name
                                            Expanded(
                                              child: Text(
                                                ref,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),

                                            // Status container
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 12,
                                                    vertical: 6,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: Colors.green.withOpacity(
                                                  0.15,
                                                ),
                                                border: Border.all(
                                                  color: Colors.green,
                                                  width: 1,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: const Text(
                                                "Active",
                                                style: TextStyle(
                                                  color: Colors.green,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                SizedBox(height: 10.0),
                                Divider(color: Colors.grey, thickness: 1),
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
