import 'package:flutter/material.dart';
import 'package:new_project/adminpages/ReferrelPage.dart';
import 'package:new_project/adminpages/ReportsPage.dart';
import 'package:new_project/auth/Login.dart';
import 'package:new_project/widgets/drawer_menu_row.dart' show DrawerMenuRow;
import 'package:new_project/adminpages/DashboardPage.dart' show Dashboardpage;
import 'package:new_project/adminpages/ManageAgentsPage.dart'
    hide DrawerMenuRow;
import 'package:new_project/adminpages/TotalVenturesPage.dart'
    hide DrawerMenuRow;
import 'package:new_project/adminpages/ManageBranches.dart' hide DrawerMenuRow;
import 'package:new_project/adminpages/TotalRevenuePage.dart'
    hide DrawerMenuRow;
import 'package:new_project/adminpages/WithdrawalRequestPage.dart'
    hide DrawerMenuRow;
import 'package:new_project/adminpages/CommisionPayoutPage.dart'
    hide DrawerMenuRow;
import 'package:shared_preferences/shared_preferences.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 30.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: const Icon(Icons.close, color: Colors.black54, size: 18),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 2),
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
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const Dashboardpage()),
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
                        builder: (_) => const ManageAgentPage(),
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
                        builder: (_) => const TotalVenturesPage(),
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
                        builder: (_) => const ManageBranchesPage(),
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
                        builder: (_) => const TotalRevenuePage(),
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
                        builder: (_) => const CommisionPayoutPage(),
                      ),
                    );
                  },
                  imagePath: "lib/icons/coins.png",
                  title: "Payouts",
                ),
                DrawerMenuRow(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ReferralPage()),
                    );
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
                        builder: (_) => const Withdrawalrequestpage(),
                      ),
                    );
                  },
                  imagePath: "lib/icons/coins.png",
                  title: "Withdrawals",
                ),
                DrawerMenuRow(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const Reportspage()),
                    );
                  },
                  imagePath: "lib/icons/charts.png",
                  title: "Reports",
                ),
                DrawerMenuRow(
                  onTap: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text("Confirm Logout"),
                        content: const Text(
                          "Are you sure you want to log out?",
                        ),
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
                      await prefs.clear(); // clear session/token
                      Navigator.pop(context); // close drawer
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (_) => const Loginpage()),
                        (route) => false,
                      );
                    }
                  },
                  icon: Icons.logout,
                  title: "Logout",
                ),

                const SizedBox(height: 150),
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: Row(
                      children: [
                        SizedBox(
                          height: 24,
                          child: Image(
                            image: AssetImage('lib/icons/back-arrow.png'),
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
    );


  }
}
