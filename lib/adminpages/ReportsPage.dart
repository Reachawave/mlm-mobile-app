import 'package:flutter/material.dart';
import 'package:new_project/adminpages/WithdrawalRequestPage.dart';
import 'CommisionPayoutPage.dart';
import 'DashboardPage.dart';
import 'ManageAgentsPage.dart';
import 'ManageBranches.dart';
import 'TotalRevenuePage.dart';
import 'TotalVenturesPage.dart';
import 'package:intl/intl.dart'; // for date formatting
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class Reportspage extends StatelessWidget {
  const Reportspage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: ReportspageBody());
  }
}

class ReportspageBody extends StatefulWidget {
  const ReportspageBody({super.key});

  @override
  State<ReportspageBody> createState() => _ReportspageBodyState();
}

class _ReportspageBodyState extends State<ReportspageBody> {
  String _selectedDate = "pick a date range"; // default text
  final GlobalKey _fieldKey = GlobalKey();
  OverlayEntry? _overlayEntry;

  /// Handle date selection
  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    if (args.value is PickerDateRange) {
      DateTime? start = args.value.startDate;
      DateTime? endNullable = args.value.endDate ?? start;

      if (start != null && endNullable != null) {
        DateTime now = DateTime.now();
        // Ensure end is not after today
        DateTime end = endNullable.isAfter(now) ? now : endNullable;

        setState(() {
          if (start == end) {
            // single date
            _selectedDate = DateFormat("dd MMMM yyyy").format(start);
          } else {
            // range
            _selectedDate =
                "${DateFormat('dd MMM yyyy').format(start)} → ${DateFormat('dd MMM yyyy').format(end)}";
          }
        });
      }
    }
  }

  /// Show popup just under TextField
  void _showCalendar(BuildContext context) {
    if (_overlayEntry != null) return; // already open

    final renderBox = _fieldKey.currentContext!.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    DateTime now = DateTime.now();

    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          // tap outside to close
          Positioned.fill(
            child: GestureDetector(
              onTap: _removeOverlay,
              behavior: HitTestBehavior.translucent,
            ),
          ),

          // calendar popup
          Positioned(
            top: position.dy + size.height + 5, // below textfield
            left: position.dx,
            width: 320,
            child: Material(
              elevation: 6,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                height: 320,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: SfDateRangePicker(
                  selectionMode: DateRangePickerSelectionMode.range,
                  onSelectionChanged: _onSelectionChanged,
                  view: DateRangePickerView.month,
                  minDate: DateTime(
                    now.year,
                    1,
                    1,
                  ), // first day of year or desired min
                  maxDate: now, // ✅ prevent selecting future dates
                  initialDisplayDate: now,
                  showNavigationArrow: true, // allow moving across months
                  allowViewNavigation: true, // allow year/month picker
                ),
              ),
            ),
          ),
        ],
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  int _selectedIndex = 0;

  final List<String> _tabs = [
    "Agents",
    "Ventures",
    "Investments",
    "Withdrawals",
    "Branches",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      "Reports",
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.0),
                Container(
                  height: 800,
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
                              height: 22,
                              child: Image.asset(
                                'lib/icons/charts.png',
                                color: Colors.green,
                              ),
                            ),
                            SizedBox(width: 10.0),
                            Text(
                              "Reports",
                              style: TextStyle(
                                fontSize: 22.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.0),
                        Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black12,
                                  width: 1.0,
                                ),
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(6.0),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ), // 👈 smaller padding
                              child: Text(
                                "Today",
                                style: TextStyle(fontSize: 10.0),
                              ),
                            ),
                            SizedBox(width: 10.0),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black12,
                                  width: 1.0,
                                ),
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(6.0),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ), // 👈 smaller padding
                              child: Text(
                                "This Week",
                                style: TextStyle(fontSize: 10.0),
                              ),
                            ),
                            SizedBox(width: 10.0),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black12,
                                  width: 1.0,
                                ),
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(6.0),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ), // 👈 smaller padding
                              child: Text(
                                "This Month",
                                style: TextStyle(fontSize: 10.0),
                              ),
                            ),
                            SizedBox(width: 10.0),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black12,
                                  width: 1.0,
                                ),
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(6.0),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ), // 👈 smaller padding
                              child: Text(
                                "All Time",
                                style: TextStyle(fontSize: 10.0),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 6.0),
                        GestureDetector(
                          key: _fieldKey,
                          onTap: () {
                            if (_overlayEntry == null) {
                              _showCalendar(context);
                            } else {
                              _removeOverlay();
                            }
                          },
                          child: Container(
                            height: 30.0,
                            padding: EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade400),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.calendar_today,
                                  color: Colors.black,
                                  size: 10.0,
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    _selectedDate,
                                    style: TextStyle(
                                      fontSize: 10,
                                      color:
                                          _selectedDate == "pick a date range"
                                          ? Colors.grey
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          "View, download and share detailed reports for your business operations",
                          style: TextStyle(fontSize: 12.0, color: Colors.green),
                        ),
                        SizedBox(height: 20),
                        Container(
                          height: 30.0,
                          padding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade400),
                            borderRadius: BorderRadius.circular(10),
                            color: Color(0xFFDCDCDC),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: List.generate(_tabs.length, (index) {
                              bool isSelected = _selectedIndex == index;
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedIndex = index;
                                  });
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 4,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    _tabs[index],
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: isSelected
                                          ? Colors.black54
                                          : Colors.green,
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),
                        SizedBox(height: 20),

                        // Fragment/page content
                        SizedBox(
                          height: 500, // give a fixed height
                          child: _buildPage(_selectedIndex),
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

  Widget _buildPage(int index) {
    switch (index) {
      case 0:
        return AgentsPage();
      case 1:
        return VenturesPage();
      case 2:
        return InvestmentsPage();
      case 3:
        return WithdrawalPage();
      case 4:
        return branchesPage();
      default:
        return Center(child: Text("Page ${_tabs[index]}"));
    }
  }
}

class AgentsPage extends StatelessWidget {
  final List<Map<String, String>> data = [
    {
      "name": "Chinnala Tyuh",
      "id": "svd-st-23-hgdtyedtyfgujhfuy",
      "email": "chinthlaramesh@gmail.com",
      "branch": "karimnagar",
    },
    {
      "name": "gunti mallesham",
      "id": "jhfuisgfuisegh",
      "email": "guntimallesham@gmail.com",
      "branch": "hammakonda",
    },
    {
      "name": "Sunitha Sharma",
      "id": "jhfuisgfuisegh",
      "email": "SunithaSharma@gmail.com",
      "branch": "karimnagar",
    },
    {
      "name": "kalangani sravanthi",
      "id": "jhfuisgfuisegh",
      "email": "kalanganisravanthi@gmail.com",
      "branch": "karimnagar",
    },
    {
      "name": "erusadla aashakeerthi",
      "id": "jhfuisgfuisegh",
      "email": "erusadlaaashakeerthi@gmail.com",
      "branch": "karimnagar",
    },
    {
      "name": "palle ravinder",
      "id": "jhfuisgfuisegh",
      "email": "palleravinder@gmail.com",
      "branch": "karimnagar",
    },
    {
      "name": "Chinnala Tyuh",
      "id": "svd-st-23-hgdtyedtyfgujhfuy",
      "email": "chinthlaramesh@gmail.com",
      "branch": "karimnagar",
    },
    {
      "name": "gunti mallesham",
      "id": "jhfuisgfuisegh",
      "email": "guntimallesham@gmail.com",
      "branch": "hammakonda",
    },
    {
      "name": "Sunitha Sharma",
      "id": "jhfuisgfuisegh",
      "email": "SunithaSharma@gmail.com",
      "branch": "karimnagar",
    },
    {
      "name": "kalangani sravanthi",
      "id": "jhfuisgfuisegh",
      "email": "kalanganisravanthi@gmail.com",
      "branch": "karimnagar",
    },
    {
      "name": "erusadla aashakeerthi",
      "id": "jhfuisgfuisegh",
      "email": "erusadlaaashakeerthi@gmail.com",
      "branch": "karimnagar",
    },
    {
      "name": "palle ravinder",
      "id": "jhfuisgfuisegh",
      "email": "palleravinder@gmail.com",
      "branch": "karimnagar",
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white54,
                    borderRadius: BorderRadius.circular(6), // rounded corners
                    border: Border.all(
                      color: Colors.grey, // border color
                      width: 0.5,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: 10,
                        child: Image.asset(
                          'lib/icons/share.png',
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(width: 6), // spacing between icon and text
                      Text(
                        "Share",
                        style: TextStyle(fontSize: 10, color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 10),
              InkWell(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white54,
                    borderRadius: BorderRadius.circular(6), // rounded corners
                    border: Border.all(
                      color: Colors.grey, // border color
                      width: 0.5,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: 10,
                        child: Image.asset(
                          'lib/icons/download.png',
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(width: 6), // spacing between icon and text
                      Text(
                        "Download",
                        style: TextStyle(fontSize: 10, color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.0),
          Row(
            children: [
              SizedBox(width: 10.0),
              Text("ID", style: TextStyle(fontSize: 14.0, color: Colors.green)),
              SizedBox(width: 75.0),
              Text(
                "Name",
                style: TextStyle(fontSize: 14.0, color: Colors.green),
              ),
              SizedBox(width: 40.0),
              Text(
                "Email",
                style: TextStyle(fontSize: 14.0, color: Colors.green),
              ),
              SizedBox(width: 50.0),
              Text(
                "Branch",
                style: TextStyle(fontSize: 14.0, color: Colors.green),
              ),
            ],
          ),
          SizedBox(height: 10.0),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,

              itemCount: data.length,
              itemBuilder: (BuildContext context, int index) {
                final item = data[index];
                final name = item["name"] ?? '';
                final id = item["id"] ?? '';
                final email = item["email"] ?? '';
                final branch = item["branch"] ?? '';

                return Column(
                  children: [
                    const Divider(thickness: 0.3, color: Colors.green),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  id,
                                  style: const TextStyle(
                                    fontSize: 8,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 30),
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  name,
                                  style: const TextStyle(
                                    fontSize: 8,
                                    color: Colors.black,
                                  ),
                                  softWrap: true,
                                  overflow: TextOverflow.visible,
                                  maxLines: null,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 30),
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  email,
                                  style: const TextStyle(
                                    fontSize: 8,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 30),
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  branch,
                                  style: const TextStyle(
                                    fontSize: 8,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class VenturesPage extends StatelessWidget {
  final List<Map<String, String>> data = [
    {
      "name": "Chinnala Tyuh",
      "id": "svd-st-23-hgdtyedtyfgujhfuy",
      "treessold": "1",
      "totaltrees": "500",
    },
    {
      "name": "fhtyhrtutr",
      "id": "svd-st-23-hgdtyedtyfgujhfuy",
      "treessold": "8",
      "totaltrees": "1000",
    },
    {
      "name": "dgtsdrfyhdtrh",
      "id": "svd-st-23-hgdtyedtyfgujhfuy",
      "treessold": "2",
      "totaltrees": "900",
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white54,
                    borderRadius: BorderRadius.circular(6), // rounded corners
                    border: Border.all(
                      color: Colors.grey, // border color
                      width: 0.5,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: 10,
                        child: Image.asset(
                          'lib/icons/share.png',
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(width: 6), // spacing between icon and text
                      Text(
                        "Share",
                        style: TextStyle(fontSize: 10, color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 10),
              InkWell(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white54,
                    borderRadius: BorderRadius.circular(6), // rounded corners
                    border: Border.all(
                      color: Colors.grey, // border color
                      width: 0.5,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: 10,
                        child: Image.asset(
                          'lib/icons/download.png',
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(width: 6), // spacing between icon and text
                      Text(
                        "Download",
                        style: TextStyle(fontSize: 10, color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.0),
          Row(
            children: [
              SizedBox(width: 10.0),
              Text("ID", style: TextStyle(fontSize: 14.0, color: Colors.green)),
              SizedBox(width: 75.0),
              Text(
                "Name",
                style: TextStyle(fontSize: 14.0, color: Colors.green),
              ),
              SizedBox(width: 40.0),
              Text(
                "Trees\nSold",
                style: TextStyle(fontSize: 14.0, color: Colors.green),
              ),
              SizedBox(width: 50.0),
              Text(
                "Total\nTrees",
                style: TextStyle(fontSize: 14.0, color: Colors.green),
              ),
            ],
          ),
          SizedBox(height: 10.0),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,

              itemCount: data.length,
              itemBuilder: (BuildContext context, int index) {
                final item = data[index];
                final name = item["name"] ?? '';
                final id = item["id"] ?? '';
                final treessold = item["treessold"] ?? '';
                final totaltrees = item["totaltrees"] ?? '';

                return Column(
                  children: [
                    const Divider(thickness: 0.3, color: Colors.green),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  id,
                                  style: const TextStyle(
                                    fontSize: 8,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 30),
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  name,
                                  style: const TextStyle(
                                    fontSize: 8,
                                    color: Colors.black,
                                  ),
                                  softWrap: true,
                                  overflow: TextOverflow.visible,
                                  maxLines: null,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 30),
                          Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  treessold,
                                  style: const TextStyle(
                                    fontSize: 8,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 30),
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  totaltrees,
                                  style: const TextStyle(
                                    fontSize: 8,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class InvestmentsPage extends StatelessWidget {
  final List<Map<String, String>> data = [
    {
      "agent": "Chinnala Tyuh",
      "id": "hgdtyedtyfgujhfuy",
      "amount": "50000",
      "date": "05/08/2025",
    },
    {
      "agent": "Chinnala Tyuh",
      "id": "hgdtyedtyfgujhfuy",
      "amount": "50000",
      "date": "05/08/2025",
    },
    {
      "agent": "Chinnala Tyuh",
      "id": "hgdtyedtyfgujhfuy",
      "amount": "50000",
      "date": "05/08/2025",
    },
    {
      "agent": "Chinnala Tyuh",
      "id": "hgdtyedtyfgujhfuy",
      "amount": "50000",
      "date": "05/08/2025",
    },
    {
      "agent": "Chinnala Tyuh",
      "id": "hgdtyedtyfgujhfuy",
      "amount": "50000",
      "date": "05/08/2025",
    },
    {
      "agent": "Chinnala Tyuh",
      "id": "hgdtyedtyfgujhfuy",
      "amount": "50000",
      "date": "05/08/2025",
    },
    {
      "agent": "Chinnala Tyuh",
      "id": "hgdtyedtyfgujhfuy",
      "amount": "50000",
      "date": "05/08/2025",
    },
    {
      "agent": "Chinnala Tyuh",
      "id": "hgdtyedtyfgujhfuy",
      "amount": "50000",
      "date": "05/08/2025",
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white54,
                    borderRadius: BorderRadius.circular(6), // rounded corners
                    border: Border.all(
                      color: Colors.grey, // border color
                      width: 0.5,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: 10,
                        child: Image.asset(
                          'lib/icons/share.png',
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(width: 6), // spacing between icon and text
                      Text(
                        "Share",
                        style: TextStyle(fontSize: 10, color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 10),
              InkWell(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white54,
                    borderRadius: BorderRadius.circular(6), // rounded corners
                    border: Border.all(
                      color: Colors.grey, // border color
                      width: 0.5,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: 10,
                        child: Image.asset(
                          'lib/icons/download.png',
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(width: 6), // spacing between icon and text
                      Text(
                        "Download",
                        style: TextStyle(fontSize: 10, color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.0),
          Row(
            children: [
              SizedBox(width: 10.0),
              Text("ID", style: TextStyle(fontSize: 14.0, color: Colors.green)),
              SizedBox(width: 75.0),
              Text(
                "Agent",
                style: TextStyle(fontSize: 14.0, color: Colors.green),
              ),
              SizedBox(width: 40.0),
              Text(
                "Amount",
                style: TextStyle(fontSize: 14.0, color: Colors.green),
              ),
              SizedBox(width: 50.0),
              Text(
                "Date",
                style: TextStyle(fontSize: 14.0, color: Colors.green),
              ),
            ],
          ),
          SizedBox(height: 10.0),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,

              itemCount: data.length,
              itemBuilder: (BuildContext context, int index) {
                final item = data[index];
                final agent = item["agent"] ?? '';
                final id = item["id"] ?? '';
                final amount = item["amount"] ?? '';
                final date = item["date"] ?? '';

                return Column(
                  children: [
                    const Divider(thickness: 0.3, color: Colors.green),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  id,
                                  style: const TextStyle(
                                    fontSize: 8,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 30),
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  agent,
                                  style: const TextStyle(
                                    fontSize: 8,
                                    color: Colors.black,
                                  ),
                                  softWrap: true,
                                  overflow: TextOverflow.visible,
                                  maxLines: null,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 30),
                          Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  amount,
                                  style: const TextStyle(
                                    fontSize: 8,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 30),
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  date,
                                  style: const TextStyle(
                                    fontSize: 8,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class WithdrawalPage extends StatelessWidget {
  final List<Map<String, String>> data1 = [
    {
      "agent": "Chinnala Tyuh",
      "id": "hgdtyedtyfgujhfuy",
      "amount": "50000",
      "date": "05/08/2025",
    },
    {
      "agent": "Chinnala Tyuh",
      "id": "hgdtyedtyfgujhfuy",
      "amount": "50000",
      "date": "05/08/2025",
    },
    {
      "agent": "Chinnala Tyuh",
      "id": "hgdtyedtyfgujhfuy",
      "amount": "50000",
      "date": "05/08/2025",
    },
    {
      "agent": "Chinnala Tyuh",
      "id": "hgdtyedtyfgujhfuy",
      "amount": "50000",
      "date": "05/08/2025",
    },
    {
      "agent": "Chinnala Tyuh",
      "id": "hgdtyedtyfgujhfuy",
      "amount": "50000",
      "date": "05/08/2025",
    },
    {
      "agent": "Chinnala Tyuh",
      "id": "hgdtyedtyfgujhfuy",
      "amount": "50000",
      "date": "05/08/2025",
    },
    {
      "agent": "Chinnala Tyuh",
      "id": "hgdtyedtyfgujhfuy",
      "amount": "50000",
      "date": "05/08/2025",
    },
    {
      "agent": "Chinnala Tyuh",
      "id": "hgdtyedtyfgujhfuy",
      "amount": "50000",
      "date": "05/08/2025",
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white54,
                    borderRadius: BorderRadius.circular(6), // rounded corners
                    border: Border.all(
                      color: Colors.grey, // border color
                      width: 0.5,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: 10,
                        child: Image.asset(
                          'lib/icons/share.png',
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(width: 6), // spacing between icon and text
                      Text(
                        "Share",
                        style: TextStyle(fontSize: 10, color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 10),
              InkWell(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white54,
                    borderRadius: BorderRadius.circular(6), // rounded corners
                    border: Border.all(
                      color: Colors.grey, // border color
                      width: 0.5,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: 10,
                        child: Image.asset(
                          'lib/icons/download.png',
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(width: 6), // spacing between icon and text
                      Text(
                        "Download",
                        style: TextStyle(fontSize: 10, color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.0),
          Row(
            children: [
              SizedBox(width: 10.0),
              Text("ID", style: TextStyle(fontSize: 14.0, color: Colors.green)),
              SizedBox(width: 75.0),
              Text(
                "Agent",
                style: TextStyle(fontSize: 14.0, color: Colors.green),
              ),
              SizedBox(width: 40.0),
              Text(
                "Amount",
                style: TextStyle(fontSize: 14.0, color: Colors.green),
              ),
              SizedBox(width: 50.0),
              Text(
                "Date",
                style: TextStyle(fontSize: 14.0, color: Colors.green),
              ),
            ],
          ),
          SizedBox(height: 10.0),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,

              itemCount: data1.length,
              itemBuilder: (BuildContext context, int index) {
                final item = data1[index];
                final agent = item["agent"] ?? '';
                final id = item["id"] ?? '';
                final amount = item["amount"] ?? '';
                final date = item["date"] ?? '';

                return Column(
                  children: [
                    const Divider(thickness: 0.3, color: Colors.green),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  id,
                                  style: const TextStyle(
                                    fontSize: 8,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 30),
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  agent,
                                  style: const TextStyle(
                                    fontSize: 8,
                                    color: Colors.black,
                                  ),
                                  softWrap: true,
                                  overflow: TextOverflow.visible,
                                  maxLines: null,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 30),
                          Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  amount,
                                  style: const TextStyle(
                                    fontSize: 8,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 30),
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  date,
                                  style: const TextStyle(
                                    fontSize: 8,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class branchesPage extends StatelessWidget {
  final List<Map<String, String>> data2 = [
    {
      "agent": "Chinnala Tyuh",
      "id": "hgdtyedtyfgujhfuy",
      "name": "hgdtyedtyfguj",
      "location": "gterery",
      "totalsales": "5",
    },
    {
      "agent": "Chinnala Tyuh",
      "id": "hgdtyedtyfgujhfuy",
      "name": "hgdtyedtyfguj",
      "location": "gterery",
      "totalsales": "5",
    },
    {
      "agent": "Chinnala Tyuh",
      "id": "hgdtyedtyfgujhfuy",
      "name": "hgdtyedtyfguj",
      "location": "gterery",
      "totalsales": "10",
    },
    {
      "agent": "Chinnala Tyuh",
      "id": "hgdtyedtyfgujhfuy",
      "name": "hgdtyedtyfguj",
      "location": "gterery",
      "totalsales": "20",
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white54,
                    borderRadius: BorderRadius.circular(6), // rounded corners
                    border: Border.all(
                      color: Colors.grey, // border color
                      width: 0.5,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: 10,
                        child: Image.asset(
                          'lib/icons/share.png',
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(width: 6), // spacing between icon and text
                      Text(
                        "Share",
                        style: TextStyle(fontSize: 10, color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 10),
              InkWell(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white54,
                    borderRadius: BorderRadius.circular(6), // rounded corners
                    border: Border.all(
                      color: Colors.grey, // border color
                      width: 0.5,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: 10,
                        child: Image.asset(
                          'lib/icons/download.png',
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(width: 6), // spacing between icon and text
                      Text(
                        "Download",
                        style: TextStyle(fontSize: 10, color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.0),
          Row(
            children: [
              SizedBox(width: 10.0),
              Text("ID", style: TextStyle(fontSize: 14.0, color: Colors.green)),
              SizedBox(width: 50.0),
              Text(
                "Name",
                style: TextStyle(fontSize: 14.0, color: Colors.green),
              ),
              SizedBox(width: 30.0),
              Text(
                "Location",
                style: TextStyle(fontSize: 14.0, color: Colors.green),
              ),
              SizedBox(width: 20.0),
              Text(
                "Agents",
                style: TextStyle(fontSize: 14.0, color: Colors.green),
              ),
              SizedBox(width: 10.0),
              Text(
                "Total\nSales",
                style: TextStyle(fontSize: 14.0, color: Colors.green),
              ),
            ],
          ),
          SizedBox(height: 10.0),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,

              itemCount: data2.length,
              itemBuilder: (BuildContext context, int index) {
                final item = data2[index];
                final agent = item["agent"] ?? '';
                final id = item["id"] ?? '';
                final name = item["name"] ?? '';
                final location = item["location"] ?? '';
                final totalsales = item["totalsales"] ?? '';

                return Column(
                  children: [
                    const Divider(thickness: 0.3, color: Colors.green),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  id,
                                  style: const TextStyle(
                                    fontSize: 8,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 30),
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  name,
                                  style: const TextStyle(
                                    fontSize: 8,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 30),
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  location,
                                  style: const TextStyle(
                                    fontSize: 8,
                                    color: Colors.black,
                                  ),
                                  softWrap: true,
                                  overflow: TextOverflow.visible,
                                  maxLines: null,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 30),
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  agent,
                                  style: const TextStyle(
                                    fontSize: 8,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 30),
                          Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  totalsales,
                                  style: const TextStyle(
                                    fontSize: 8,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
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
