import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:new_project/utils/AuthApi.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:new_project/widgets/app_drawer.dart';
import 'ManageAgentsPage.dart';
import 'TotalVenturesPage.dart';
import 'ManageBranches.dart';
import 'TotalRevenuePage.dart';
import 'WithdrawalRequestPage.dart';
import 'CommisionPayoutPage.dart';
import 'ReportsPage.dart';
import 'CreateAgentPage.dart';
import 'CreateVenturePage.dart';
import 'CreateBranchPage.dart';

class Dashboardpage extends StatelessWidget {
  const Dashboardpage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: DashboardBody());
  }
}

class DashboardBody extends StatefulWidget {
  const DashboardBody({super.key});

  @override
  State<DashboardBody> createState() => _DashboardBodyState();
}

class _DashboardBodyState extends State<DashboardBody> {
  final AuthApi _authApi = AuthApi();

  // Date range picker overlay
  String _selectedDateText = "pick a date range";
  final GlobalKey _fieldKey = GlobalKey();
  OverlayEntry? _overlayEntry;

  // DATE RANGE: handle selection
  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    if (args.value is PickerDateRange) {
      final DateTime? start = args.value.startDate;
      final DateTime? endNullable = args.value.endDate ?? start;

      if (start != null && endNullable != null) {
        final now = DateTime.now();
        final end = endNullable.isAfter(now) ? now : endNullable;

        setState(() {
          if (start.year == end.year &&
              start.month == end.month &&
              start.day == end.day) {
            _selectedDateText = DateFormat("dd MMMM yyyy").format(start);
          } else {
            _selectedDateText =
                "${DateFormat('dd MMM yyyy').format(start)} → ${DateFormat('dd MMM yyyy').format(end)}";
          }
        });
      }
    }
  }

  // Show popup calendar under the field
  void _showCalendar(BuildContext context) {
    if (_overlayEntry != null) return;
    if (_fieldKey.currentContext == null) return;

    final renderBox = _fieldKey.currentContext!.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;
    final now = DateTime.now();

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
          // calendar
          Positioned(
            top: position.dy + size.height + 5,
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
                  minDate: DateTime(now.year, 1, 1),
                  maxDate: now,
                  initialDisplayDate: now,
                  showNavigationArrow: true,
                  allowViewNavigation: true,
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
  void dispose() {
    _removeOverlay();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawerEnableOpenDragGesture: false,
      drawer: const AppDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black12, width: 1),
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            ),
          ),
        ),
        actions: [
          SizedBox(
            height: 25,
            child: Image.asset('lib/icons/active.png', color: Colors.black),
          ),
          const SizedBox(width: 10),
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
          child: Divider(height: 1, color: Colors.black12),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Dashboard",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
            ),
            const SizedBox(height: 12),

            // Time quick filters
            Row(
              children: [
                _timeChip("Today"),
                const SizedBox(width: 10),
                _timeChip("This Week"),
                const SizedBox(width: 10),
                _timeChip("This Month"),
              ],
            ),
            const SizedBox(height: 10),
            _timeChip("All Time"),
            const SizedBox(height: 10),

            // Date range input with overlay
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
                height: 55,
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today, color: Colors.black),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        _selectedDateText,
                        style: TextStyle(
                          fontSize: 18,
                          color: _selectedDateText == "pick a date range"
                              ? Colors.grey
                              : Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 10),

            // ROW 1
            Row(
              children: [
                // TOTAL REVENUE
                _metricCard(
                  height: 200,
                  width: 175,
                  color: const Color(0xFF4A9782),
                  leading: const Icon(
                    Icons.account_balance_wallet_outlined,
                    size: 40,
                    color: Colors.white,
                  ),
                  title: "TOTAL REVENUE",
                  bigValueRow: Row(
                    children: const [
                      Icon(
                        Icons.currency_rupee_outlined,
                        size: 30,
                        color: Colors.white,
                      ),
                      Text(
                        "17,00,000",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  footer: const Text(
                    "20 investments",
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const TotalRevenuePage()),
                  ),
                ),
                const SizedBox(width: 10),

                // COMMISSION PAID
                _metricCard(
                  height: 200,
                  width: 175,
                  color: const Color(0xFFD92C54),
                  leading: SizedBox(
                    height: 40,
                    child: Image.asset(
                      'lib/icons/coins.png',
                      color: Colors.white,
                    ),
                  ),
                  title: "COMMISSION PAID",
                  bigValueRow: Row(
                    children: const [
                      Icon(
                        Icons.currency_rupee_outlined,
                        size: 30,
                        color: Colors.white,
                      ),
                      Text(
                        "1,91,000",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  footer: const Text(
                    "Paid to agent network",
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const CommisionPayoutPage(),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // ROW 2
            Row(
              children: [
                // NET WORTH
                _metricCard(
                  height: 200,
                  width: 175,
                  color: const Color(0xFF3D74B6),
                  leading: SizedBox(
                    height: 40,
                    child: Image.asset(
                      'lib/icons/text.png',
                      color: Colors.white,
                    ),
                  ),
                  title: "NET WORTH",
                  bigValueRow: Row(
                    children: const [
                      Icon(
                        Icons.currency_rupee_outlined,
                        size: 30,
                        color: Colors.white,
                      ),
                      Text(
                        "15,00,000",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  footer: const Text(
                    "Revenue - Commissions",
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  onTap:
                      () {}, // no-op (or navigate to a net-worth details page)
                ),
                const SizedBox(width: 10),

                // TOTAL AGENTS
                _metricCard(
                  height: 200,
                  width: 175,
                  color: const Color(0xFFB13BFF),
                  leading: const Icon(
                    Icons.people_outlined,
                    size: 40,
                    color: Colors.white,
                  ),
                  title: "TOTAL AGENTS",
                  bigValue: const Text(
                    "34",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  footer: const Text(
                    "All registered agents",
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ManageAgentPage()),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // ROW 3
            Row(
              children: [
                // TOTAL VENTURES
                _metricCard(
                  height: 200,
                  width: 175,
                  color: const Color(0xFFD92C54),
                  leading: SizedBox(
                    height: 40,
                    child: Image.asset(
                      'lib/icons/bag.png',
                      color: Colors.white,
                    ),
                  ),
                  title: "TOTAL VENTURES",
                  bigValue: const Text(
                    "4",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  footer: const Text(
                    "Ready for investment",
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const TotalVenturesPage(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),

                // TOTAL BRANCHES
                _metricCard(
                  height: 200,
                  width: 175,
                  color: const Color(0xFFFFD66B),
                  leading: SizedBox(
                    height: 40,
                    child: Image.asset(
                      'lib/icons/bank.png',
                      color: Colors.white,
                    ),
                  ),
                  title: "TOTAL BRANCHES",
                  bigValue: const Text(
                    "2",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  footer: const Text(
                    "Across the organization",
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ManageBranchesPage(),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // ROW 4
            Row(
              children: [
                // REFERRAL TREE
                _metricCard(
                  width: 175,
                  color: const Color(0xFF67AE6E),
                  leading: SizedBox(
                    height: 40,
                    child: Image.asset(
                      'lib/icons/decision-tree.png',
                      color: Colors.white,
                    ),
                  ),
                  title: "REFERRAL TREE",
                  bigValueColumn: const [
                    Text(
                      "VIEW",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "NETWORK",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],

                  footer: const Text(
                    "Complete agent hierarchy",
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  onTap: () {
                    // TODO: navigate to referral tree page when ready
                  },
                ),
                const SizedBox(width: 10),

                // WITHDRAWAL REQUESTS
                _metricCard(
                  width: 175,
                  color: const Color(0xFF3D74B6),
                  leading: SizedBox(
                    height: 40,
                    child: Image.asset(
                      'lib/icons/pig.png',
                      color: Colors.white,
                    ),
                  ),
                  titleColumn: const [
                    Text(
                      "WITHDRAWAL",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    Text(
                      "REQUESTS",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                  bigValueColumn: const [
                    Text(
                      "2",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Pending",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                  footer: const Text(
                    "Approve agent payouts",
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const Withdrawalrequestpage(),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // REPORTS
            _metricCard(
              width: 175,
              color: const Color(0xFF5C7285),
              leading: SizedBox(
                height: 40,
                child: Image.asset('lib/icons/charts.png', color: Colors.white),
              ),
              title: "REPORTS",
              bigValueColumn: const [
                Text(
                  "VIEW &",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "EXPORT",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
              footer: const Text(
                "Download detailed reports",
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => Reportspage()),
              ),
            ),

            const SizedBox(height: 40),

            // QUICK ACTIONS: Create Agent / Venture / Branch
            _quickAction(
              iconPath: 'lib/icons/add-friend.png',
              label: 'Create Agent',
              iconHeight: 25,
              onTap: () async {
                final sp = await SharedPreferences.getInstance();
                final token =
                    sp.getString('auth_token') ?? sp.getString('token') ?? '';
                if (token.isEmpty) {
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('You are not logged in')),
                  );
                  return;
                }
                _authApi.setAuthToken(token);
                if (!mounted) return;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CreateAgentPage(api: _authApi),
                  ),
                );
              },
            ),
            const SizedBox(height: 10),
            _quickAction(
              iconPath: 'lib/icons/add.png',
              label: 'Create Venture',
              iconHeight: 20,
              onTap: () async {
                final sp = await SharedPreferences.getInstance();
                final token =
                    sp.getString('auth_token') ?? sp.getString('token') ?? '';
                if (token.isEmpty) {
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('You are not logged in')),
                  );
                  return;
                }
                _authApi.setAuthToken(token);
                if (!mounted) return;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CreateVenturePage(api: _authApi),
                  ),
                );
              },
            ),
            const SizedBox(height: 10),
            _quickAction(
              iconPath: 'lib/icons/git.png',
              label: 'Create Branch',
              iconHeight: 30,
              onTap: () async {
                // Get saved token (adjust the key to match your login save)
                final sp = await SharedPreferences.getInstance();
                final savedToken = sp.getString('token') ?? '';

                if (savedToken.isEmpty) {
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('You are not logged in')),
                  );
                  return;
                }

                // Set token on the API and navigate
                _authApi.setAuthToken(savedToken);
                if (!mounted) return;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CreateBranchPage(api: _authApi),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // Small helper to render "chips" like Today / This Week / ...
  Widget _timeChip(String text) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black12, width: 1),
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(text, style: const TextStyle(fontSize: 16)),
      ),
    );
  }

  // Reusable metric card
  Widget _metricCard({
    double? height,
    double? width,
    required Color color,
    Widget? leading,
    String? title,
    List<Widget>? titleColumn,
    Widget? bigValue,
    Widget? bigValueRow,
    List<Widget>? bigValueColumn,
    Widget? footer,
    VoidCallback? onTap,
  }) {
    final titleWidget = title != null
        ? Text(title, style: const TextStyle(color: Colors.white, fontSize: 16))
        : (titleColumn != null
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: titleColumn,
                )
              : const SizedBox.shrink());

    final valueWidget =
        bigValue ??
        bigValueRow ??
        (bigValueColumn != null
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: bigValueColumn,
              )
            : const SizedBox(height: 0));

    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: height,
        width: width,
        child: Card(
          color: color,
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
                if (leading != null) leading,
                const SizedBox(height: 8),
                titleWidget,
                const SizedBox(height: 8),
                valueWidget,
                if (footer != null) ...[const SizedBox(height: 8), footer],
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Quick action button (bordered)
  Widget _quickAction({
    required String iconPath,
    required String label,
    required double iconHeight,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 175,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black12, width: 1),
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              SizedBox(
                height: iconHeight,
                child: Image.asset(iconPath, color: Colors.black),
              ),
              const SizedBox(width: 20),
              Text(label, style: const TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }
}
