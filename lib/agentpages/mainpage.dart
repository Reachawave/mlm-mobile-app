import 'package:flutter/material.dart';
import 'package:new_project/agentpages/withdrawpage.dart';
import 'package:new_project/agentpages/withdrawpage.dart';

import '../adminpages/CommisionPayoutPage.dart';
import '../adminpages/DashboardPage.dart';
import '../adminpages/ManageAgentsPage.dart';
import '../adminpages/ManageBranches.dart';
import '../adminpages/TotalRevenuePage.dart';
import '../adminpages/TotalVenturesPage.dart';
import '../adminpages/WithdrawalRequestPage.dart';
import '../agentpages/Agentdashboardpage.dart';
import 'agentprofilepage.dart';
import 'commisionReport.dart';
import 'networkpage.dart';
import 'notificationsPage.dart';

class Agentdashboardmainpage extends StatefulWidget {
  final int initialIndex;

  const Agentdashboardmainpage({super.key, this.initialIndex = 0});

  @override
  State<Agentdashboardmainpage> createState() => _AgentdashboardmainpageState();
}

class _AgentdashboardmainpageState extends State<Agentdashboardmainpage> {
  late int _selectedIndex;

  final List<Widget> _pages = [
    Agentdashboardpage(),
    MyNetworkPage(),
    withdrawpage(),
    Commisionreport(),
    notifypage(),
    prifilepage(),

  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex; // 👈 Start from passed index
  }

  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30.0),
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
                children: const [
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
                          builder: (context) => Agentdashboardmainpage(
                            initialIndex: 0,
                          ), // 👈 Withdraw tab
                        ),
                      );
                    },
                    imagePath: "lib/icons/home.png",
                    title: "Home",
                  ),
                  DrawerMenuRow(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Agentdashboardmainpage(initialIndex: 1), // 👈 Withdraw tab
                        ),
                      );
                    },
                    imagePath: "lib/icons/decision-tree.png",
                    title: "Network",
                  ),
                  DrawerMenuRow(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Agentdashboardmainpage(
                            initialIndex: 2,
                          ), // 👈 Withdraw tab
                        ),
                      );
                    },
                    icon: Icons.account_balance_wallet_outlined,
                    title: "Withdraw",
                  ),
                  DrawerMenuRow(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Agentdashboardmainpage(initialIndex: 4), // 👈 Withdraw tab
                        ),
                      );
                    },
                    imagePath: "lib/icons/active.png",
                    title: "Notifications",
                  ),
                  DrawerMenuRow(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Agentdashboardmainpage(
                            initialIndex: 5,
                          ), // 👈 Withdraw tab
                        ),
                      );
                    },
                    imagePath: "lib/icons/profile.png",
                    title: "Profile",
                  ),
                  DrawerMenuRow(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Agentdashboardmainpage(
                            initialIndex: 3,
                          ), // 👈 Withdraw tab
                        ),
                      );
                    },
                    imagePath: "lib/icons/charts.png",
                    title: "Commission Report",
                  ),
                  DrawerMenuRow(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    imagePath: "lib/icons/text.png",
                    title: "My Layouts",
                  ),
                  DrawerMenuRow(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    imagePath: "lib/icons/telephone.png",
                    title: "Contact Us",
                  ),
                  DrawerMenuRow(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    imagePath: "lib/icons/info-sign.png",
                    title: "About Us",
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
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 15,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black12, width: 1.0),
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              ),
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 30,
              child: Image.asset('lib/icons/user.png'),
            ),
          ),
        ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(color: Colors.black12, height: 1.0),
        ),
      ),
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onTabTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        items: [
          const BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
            icon: Image.asset(
              "lib/icons/decision-tree.png",
              width: 24,
              height: 24,
              color: Colors.grey,
            ),
            activeIcon: Image.asset(
              "lib/icons/decision-tree.png",
              width: 24,
              height: 24,
              color: Colors.green,
            ),
            label: "Network",
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              "lib/icons/purse.png",
              width: 24,
              height: 24,
              color: Colors.grey,
            ),
            activeIcon: Image.asset(
              "lib/icons/purse.png",
              width: 24,
              height: 24,
              color: Colors.green,
            ),
            label: "Withdraw",
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              "lib/icons/charts.png",
              width: 24,
              height: 24,
              color: Colors.grey,
            ),
            activeIcon: Image.asset(
              "lib/icons/charts.png",
              width: 24,
              height: 24,
              color: Colors.green,
            ),
            label: "Commission",
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: "Notify",
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),

        ],
      ),
    );
  }
}

class DrawerMenuRow extends StatelessWidget {
  final IconData? icon;
  final String? imagePath;
  final String title;
  final VoidCallback? onTap;

  const DrawerMenuRow({
    super.key,
    this.icon,
    this.imagePath,
    required this.title,
    this.onTap,
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
      onTap: onTap,
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
