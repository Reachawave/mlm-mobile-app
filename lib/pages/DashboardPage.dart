import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // for date formatting
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'TotalRevenuePage.dart';

class Dashboardpage extends StatelessWidget {
  const Dashboardpage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: DashboardBody());
  }
}

class DashboardBody extends StatefulWidget {
  const DashboardBody({super.key});

  @override
  State<DashboardBody> createState() => _DashboardBodyState();
}

class _DashboardBodyState extends State<DashboardBody> {
  String _selectedDate = "pick a date range"; // default text
  final GlobalKey _fieldKey = GlobalKey();
  OverlayEntry? _overlayEntry;

  /// Handle date selection
  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    if (args.value is PickerDateRange) {
      DateTime? start = args.value.startDate;
      DateTime? end = args.value.endDate ?? start;

      if (start != null && end != null) {
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
                    now.month,
                    1,
                  ), // first day of current month
                  maxDate: DateTime(
                    now.year,
                    now.month + 1,
                    0,
                  ), // last day of current month
                  initialDisplayDate: now,
                  showNavigationArrow: false, // disable next/prev arrows
                  enablePastDates: false, // block past dates
                  allowViewNavigation: false, // 🔒 prevents year/month picker
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
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 15,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black12, // Sets the color of the border
                width: 1.0, // Sets the width of the border
                // Sets the style of the border (e.g., solid, dashed, dotted)
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
            padding: const EdgeInsets.all(8.0),
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
          padding: const EdgeInsets.all(16.0),
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // SizedBox(height: 5.0),
                Text(
                  "Dashboard",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                ),
                SizedBox(height: 12.0),
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black12, // Sets the color of the border
                          width: 1.0, // Sets the width of the border
                          // Sets the style of the border (e.g., solid, dashed, dotted)
                        ),
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(
                          10.0,
                        ), // Uniform radius for all corners
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Today", style: TextStyle(fontSize: 16.0)),
                      ),
                    ),
                    SizedBox(width: 10.0),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black12, // Sets the color of the border
                          width: 1.0, // Sets the width of the border
                          // Sets the style of the border (e.g., solid, dashed, dotted)
                        ),
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(
                          10.0,
                        ), // Uniform radius for all corners
                      ),
                      // color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "This Week",
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ),
                    ),
                    SizedBox(width: 10.0),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black12, // Sets the color of the border
                          width: 1.0, // Sets the width of the border
                          // Sets the style of the border (e.g., solid, dashed, dotted)
                        ),
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(
                          10.0,
                        ), // Uniform radius for all corners
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "This Month",
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.0),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black12, // Sets the color of the border
                      width: 1.0, // Sets the width of the border
                      // Sets the style of the border (e.g., solid, dashed, dotted)
                    ),
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(
                      10.0,
                    ), // Uniform radius for all corners
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("All Time", style: TextStyle(fontSize: 16.0)),
                  ),
                ),
                SizedBox(height: 10.0),
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
                    height: 55.0,
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 14),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.calendar_today, color: Colors.black),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            _selectedDate,
                            style: TextStyle(
                              fontSize: 18,
                              color: _selectedDate == "pick a date range"
                                  ? Colors.grey
                                  : Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10.0),
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TotalRevenuePage(),
                          ),
                        );
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
                                Icon(
                                  Icons.account_balance_wallet_outlined,
                                  size: 40,
                                  color: Colors.white,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  "TOTAL REVENUE", // 👈 text comes from list
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(height: 25.0),
                                Row(
                                  children: [
                                    Expanded(
                                      child: FittedBox(
                                        fit: BoxFit
                                            .scaleDown, // scales both icon + text
                                        alignment: Alignment.centerLeft,
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.currency_rupee_outlined,
                                              size: 30, // 👈 base size
                                              color: Colors.white,
                                            ),
                                            Text(
                                              "17,00,000",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 30, // 👈 base size
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "20", // 👈 text comes from list
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      " investments", // 👈 text comes from list
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Container(
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
                              Container(
                                height: 40,
                                child: Image.asset(
                                  'lib/icons/coins.png',
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                "COMMISSION PAID", // 👈 text comes from list
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  Expanded(
                                    child: FittedBox(
                                      fit: BoxFit
                                          .scaleDown, // scales both icon + text
                                      alignment: Alignment.centerLeft,
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.currency_rupee_outlined,
                                            size: 30, // 👈 base size
                                            color: Colors.white,
                                          ),
                                          Text(
                                            "1,91,000",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 30, // 👈 base size
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Paid to agent", // 👈 text comes from list
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(
                                    "network", // 👈 text comes from list
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
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
                SizedBox(height: 10.0),
                Row(
                  children: [
                    Container(
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
                              Container(
                                height: 40,
                                child: Image.asset(
                                  'lib/icons/text.png',
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                "TOTAL REVENUE", // 👈 text comes from list
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  Expanded(
                                    child: FittedBox(
                                      fit: BoxFit
                                          .scaleDown, // scales both icon + text
                                      alignment: Alignment.centerLeft,
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.currency_rupee_outlined,
                                            size: 30, // 👈 base size
                                            color: Colors.white,
                                          ),
                                          Text(
                                            "15,00,000",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 30, // 👈 base size
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Revenue -", // 👈 text comes from list
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(
                                    "Commissions", // 👈 text comes from list
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Container(
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
                              Icon(
                                Icons.people_outlined,
                                size: 40,
                                color: Colors.white,
                              ),
                              SizedBox(height: 8),
                              Text(
                                "TOTAL AGENTS", // 👈 text comes from list
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: 20),
                              Text(
                                "34", // 👈 text comes from list
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "All registered agents", // 👈 text comes from list
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.0),
                Row(
                  children: [
                    Container(
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
                              Container(
                                height: 40,
                                child: Image.asset(
                                  'lib/icons/bag.png',
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                "TOTAL VENTURES", // 👈 text comes from list
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: 30),
                              Text(
                                "4", // 👈 text comes from list
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "Ready for investment", // 👈 text comes from list
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Container(
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
                              Container(
                                height: 40,
                                child: Image.asset(
                                  'lib/icons/bank.png',
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                "TOTAL BRANCHES", // 👈 text comes from list
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                "2", // 👈 text comes from list
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Across the", // 👈 text comes from list
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(
                                    "organization", // 👈 text comes from list
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
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
                SizedBox(height: 10.0),
                Row(
                  children: [
                    Container(
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
                              Container(
                                height: 40,
                                child: Image.asset(
                                  'lib/icons/decision-tree.png',
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                "REFERRAL TREE", // 👈 text comes from list
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: 30),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "VIEW", // 👈 text comes from list
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "NETWORK", // 👈 text comes from list
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Complete agent", // 👈 text comes from list
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(
                                    "hierarchy", // 👈 text comes from list
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Container(
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
                              Container(
                                height: 40,
                                child: Image.asset(
                                  'lib/icons/pig.png',
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "WITHDRAWAL", // 👈 text comes from list
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    "REQUESTS", // 👈 text comes from list
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "2", // 👈 text comes from list
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "Pending", // 👈 text comes from list
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Approve agent", // 👈 text comes from list
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(
                                    "payouts", // 👈 text comes from list
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
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
                SizedBox(height: 10.0),
                Container(
                  width: 175,
                  child: Card(
                    color: Color(0xFF5C7285),
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
                          Container(
                            height: 40,
                            child: Image.asset(
                              'lib/icons/charts.png',
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "REPORTS", // 👈 text comes from list
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          SizedBox(height: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "VIEW &", // 👈 text comes from list
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "EXPORT", // 👈 text comes from list
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Download detailed", // 👈 text comes from list
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                "reports", // 👈 text comes from list
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 40.0),
                Container(
                  width: 175,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black12, // Sets the color of the border
                      width: 1.0, // Sets the width of the border
                      // Sets the style of the border (e.g., solid, dashed, dotted)
                    ),
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(
                      10.0,
                    ), // Uniform radius for all corners
                  ),
                  // color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Container(
                          height: 25,
                          child: Image.asset(
                            'lib/icons/add-friend.png',
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(width: 20.0),
                        Text("Create Agent", style: TextStyle(fontSize: 16.0)),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10.0),
                Container(
                  width: 175,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black12, // Sets the color of the border
                      width: 1.0, // Sets the width of the border
                      // Sets the style of the border (e.g., solid, dashed, dotted)
                    ),
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(
                      10.0,
                    ), // Uniform radius for all corners
                  ),
                  // color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Container(
                          height: 20,
                          child: Image.asset(
                            'lib/icons/add.png',
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(width: 20.0),
                        Text(
                          "Create Venture",
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10.0),
                Container(
                  width: 175,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black12, // Sets the color of the border
                      width: 1.0, // Sets the width of the border
                      // Sets the style of the border (e.g., solid, dashed, dotted)
                    ),
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(
                      10.0,
                    ), // Uniform radius for all corners
                  ),
                  // color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Container(
                          height: 30,
                          child: Image.asset(
                            'lib/icons/git.png',
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(width: 20.0),
                        Text("Create Branch", style: TextStyle(fontSize: 16.0)),
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
