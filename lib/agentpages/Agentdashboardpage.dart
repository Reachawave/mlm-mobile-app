import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:new_project/auth/Login.dart';
import 'mainpage.dart' show Agentdashboardmainpage;

class Agentdashboardpage extends StatelessWidget {
  const Agentdashboardpage({super.key});

  @override
  Widget build(BuildContext context) {
    return const DashBody();
  }
}

class DashBody extends StatefulWidget {
  const DashBody({super.key});

  @override
  State<DashBody> createState() => _DashBodyState();
}

class _DashBodyState extends State<DashBody> {
  // --- LOGIN/PROFILE STATE ---
  String? username;

  // --- CALCULATOR CONTROLLERS ---
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
  bool showEarnings = false;

  double get totalEarning =>
      l1Earning + l2Earning + l3Earning + l4Earning + l5Earning;

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  Future<void> _loadUsername() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString("username"); // saved during login
    });
  }

  void calculateEarnings() {
    final double base = double.tryParse(avgInvestmentCtrl.text) ?? 50000;

    final int l1 = int.tryParse(l1Ctrl.text) ?? 0;
    final int l2 = int.tryParse(l2Ctrl.text) ?? 0;
    final int l3 = int.tryParse(l3Ctrl.text) ?? 0;
    final int l4 = int.tryParse(l4Ctrl.text) ?? 0;
    final int l5 = int.tryParse(l5Ctrl.text) ?? 0;

    setState(() {
      // 10, 2, 1, 1, 1 per-mille (‰)
      l1Earning = l1 * base * 0.010; // 10‰  => 1.0%
      l2Earning = l2 * base * 0.002; // 2‰   => 0.2%
      l3Earning = l3 * base * 0.001; // 1‰   => 0.1%
      l4Earning = l4 * base * 0.001; // 1‰   => 0.1%
      l5Earning = l5 * base * 0.001; // 1‰   => 0.1%
    });
  }

  // --- LOGOUT FLOW WITH CONFIRMATION ---
  Future<void> _confirmLogoutAndExit() async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Confirm Logout"),
        content: const Text("Are you sure you want to log out?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text("Logout"),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const Loginpage()),
        (route) => false,
      );
    }
  }

  @override
  void dispose() {
    avgInvestmentCtrl.dispose();
    l1Ctrl.dispose();
    l2Ctrl.dispose();
    l3Ctrl.dispose();
    l4Ctrl.dispose();
    l5Ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ---- APP BAR WITH LOGOUT BUTTON ----
      appBar: AppBar(
        title: const Text("Agent Dashboard"),
        actions: [
          IconButton(
            tooltip: "Logout",
            icon: const Icon(Icons.logout),
            onPressed: _confirmLogoutAndExit,
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Welcome Back",
                  style: TextStyle(color: Colors.green, fontSize: 22),
                ),
                const SizedBox(height: 5.0),
                Text(
                  username ?? "Agent",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
                const SizedBox(height: 20.0),

                // --------- ROW 1: My Referrals + Withdraw ---------
                Row(
                  children: [
                    _dashboardCard(
                      color: const Color(0xFF4A9782),
                      icon: Image.asset(
                        "lib/icons/user-avatar.png",
                        width: 40,
                        height: 40,
                        color: Colors.white,
                      ),
                      title: "My Referrals",
                      subtitle1: "View Your",
                      subtitle2: "Network",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                Agentdashboardmainpage(initialIndex: 1),
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 10),
                    _dashboardCard(
                      color: const Color(0xFFD92C54),
                      icon: const Icon(
                        Icons.account_balance_wallet_outlined,
                        size: 40,
                        color: Colors.white,
                      ),
                      title: "Withdraw",
                      // no value line
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                Agentdashboardmainpage(initialIndex: 2),
                          ),
                        );
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 10.0),

                // --------- ROW 2: Commission + Profile ---------
                Row(
                  children: [
                    _dashboardCard(
                      color: const Color(0xFF3D74B6),
                      icon: const Icon(
                        Icons.show_chart,
                        size: 40,
                        color: Colors.white,
                      ),
                      title: "Commission",
                      subtitle1: "Report",
                      subtitle2: "Earnings details",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                Agentdashboardmainpage(initialIndex: 3),
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 10),
                    _dashboardCard(
                      color: const Color(0xFFB13BFF),
                      icon: Image.asset(
                        "lib/icons/profile.png",
                        width: 40,
                        height: 40,
                        color: Colors.white,
                      ),
                      title: "Profile",
                      subtitle1: "your details",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                Agentdashboardmainpage(initialIndex: 5),
                          ),
                        );
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 20.0),

                // ----- EARNINGS CALCULATOR -----
                Container(
                  width: 1000,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black12, width: 1.0),
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              height: 24.0,
                              child: Image.asset(
                                "lib/icons/calculator.png",
                                color: Colors.green,
                              ),
                            ),
                            const SizedBox(width: 10.0),
                            const Text(
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
                          children: const [
                            Text(
                              "Estimate your potential commission",
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.green,
                              ),
                            ),
                            Text(
                              "based on your referral network",
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30.0),
                        const Text(
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
                                Radius.circular(5),
                              ),
                            ),
                            hintText: "50000",
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
                        const SizedBox(height: 10.0),

                        // Level 1 & 2
                        Row(
                          children: [
                            Expanded(
                              child: _levelField(
                                label: "Level 1",
                                controller: l1Ctrl,
                                onChanged: (_) => calculateEarnings(),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _levelField(
                                label: "Level 2",
                                controller: l2Ctrl,
                                onChanged: (_) => calculateEarnings(),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10.0),

                        // Level 3 & 4
                        Row(
                          children: [
                            Expanded(
                              child: _levelField(
                                label: "Level 3",
                                controller: l3Ctrl,
                                onChanged: (_) => calculateEarnings(),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _levelField(
                                label: "Level 4",
                                controller: l4Ctrl,
                                onChanged: (_) => calculateEarnings(),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10.0),

                        // Level 5 + Calculate button
                        Row(
                          children: [
                            Expanded(
                              child: _levelField(
                                label: "Level 5",
                                controller: l5Ctrl,
                                onChanged: (_) => calculateEarnings(),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 25),
                                  SizedBox(
                                    height: 45,
                                    width: 300,
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
                                        calculateEarnings();
                                        setState(() => showEarnings = true);
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

                        const SizedBox(height: 20.0),

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
                                      SizedBox(
                                        height: 20.0,
                                        child: Image.asset(
                                          "lib/icons/history.png",
                                          color: Colors.green,
                                        ),
                                      ),
                                      const SizedBox(width: 10.0),
                                      const Text(
                                        "Estimated Earnings",
                                        style: TextStyle(
                                          color: Colors.green,
                                          fontSize: 20.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20.0),

                                  _earningRow(
                                    "Level 1 Commission (10‰)",
                                    l1Earning,
                                  ),
                                  _earningRow(
                                    "Level 2 Commission (2‰)",
                                    l2Earning,
                                  ),
                                  _earningRow(
                                    "Level 3 Commission (1‰)",
                                    l3Earning,
                                  ),
                                  _earningRow(
                                    "Level 4 Commission (1‰)",
                                    l4Earning,
                                  ),
                                  _earningRow(
                                    "Level 5 Commission (1‰)",
                                    l5Earning,
                                  ),

                                  const SizedBox(height: 10.0),
                                  const Divider(
                                    thickness: 0.3,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(height: 10.0),

                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: const [
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
                                        style: const TextStyle(
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
                // --- end calculator ---
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ------- Small UI helpers -------
  Widget _dashboardCard({
    required Color color,
    required Widget icon,
    required String title,
    String? subtitle1,
    String? subtitle2,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: 200,
        width: 175,
        child: Card(
          color: color,
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                icon,
                const SizedBox(height: 20),
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
                if (subtitle1 != null)
                  Text(
                    subtitle1,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                if (subtitle2 != null)
                  Text(
                    subtitle2,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _levelField({
    required String label,
    required TextEditingController controller,
    required void Function(String) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16.0, color: Colors.black),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          onChanged: onChanged,
          decoration: const InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
            hintStyle: TextStyle(color: Colors.green, fontSize: 16),
            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          ),
        ),
      ],
    );
  }

  Widget _earningRow(String title, double value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(color: Colors.green, fontSize: 16.0),
        ),
        Text(
          "₹${value.toStringAsFixed(0)}",
          style: const TextStyle(color: Colors.black, fontSize: 16.0),
        ),
      ],
    );
  }
}
