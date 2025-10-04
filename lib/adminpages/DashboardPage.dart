// adminpages/DashboardPage.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:new_project/adminpages/ReferrelPage.dart';
import 'package:new_project/adminpages/ReportsPage.dart';
import 'package:new_project/adminpages/ManageAgentsPage.dart';
import 'package:new_project/adminpages/TotalVenturesPage.dart';
import 'package:new_project/adminpages/ManageBranches.dart';
import 'package:new_project/adminpages/TotalRevenuePage.dart';
import 'package:new_project/adminpages/WithdrawalRequestPage.dart';
import 'package:new_project/adminpages/CommisionPayoutPage.dart';
import 'package:new_project/utils/AuthApi.dart';
import 'package:new_project/widgets/app_shell.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import 'CreateAgentPage.dart';
import 'CreateBranchPage.dart';
import 'CreateVenturePage.dart';

class Dashboardpage extends StatelessWidget {
  const Dashboardpage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppShell(title: 'Dashboard', body: DashboardBody());
  }
}

class DashboardBody extends StatefulWidget {
  const DashboardBody({super.key});

  @override
  State<DashboardBody> createState() => _DashboardBodyState();
}

class _DashboardBodyState extends State<DashboardBody> {
  // ---- API & Totals ----
  final AuthApi _authApi = AuthApi();
  bool _loadingTotals = true;
  String? _totalsError;

  int _totalAgents = 0;
  double _totalCommission = 0;
  int _totalVentures = 0;
  int _totalBranches = 0;
  int _totalPendingWithdrawals = 0;
  double _totalRevenue = 0;

  // ---- Date Range overlay ----
  String _selectedDateText = "pick a date range";
  final GlobalKey _fieldKey = GlobalKey();
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    _fetchTotals();
  }

  Future<void> _fetchTotals() async {
    setState(() {
      _loadingTotals = true;
      _totalsError = null;
    });

    try {
      final sp = await SharedPreferences.getInstance();
      final token = sp.getString('auth_token') ?? sp.getString('token') ?? '';
      if (token.isEmpty) {
        setState(() {
          _loadingTotals = false;
          _totalsError = 'You are not logged in';
        });
        return;
      }
      _authApi.setAuthToken(token);

      final resp = await _authApi.getAgentDashboard();
      final td = (resp.data?['treeDetails'] as Map?) ?? {};

      setState(() {
        _totalAgents = (td['totalAgents'] ?? 0) as int;
        _totalCommission = (td['totalCommision'] ?? 0).toDouble();
        _totalVentures = (td['totalVentures'] ?? 0) as int;
        _totalBranches = (td['totalBranch'] ?? 0) as int;
        _totalPendingWithdrawals = (td['totalPendingWithdrawls'] ?? 0) as int;
        _totalRevenue = (td['totalRevenue'] ?? 0).toDouble();
        _loadingTotals = false;
      });
    } on ApiException catch (e) {
      setState(() {
        _loadingTotals = false;
        _totalsError = e.message;
      });
    } catch (e) {
      setState(() {
        _loadingTotals = false;
        _totalsError = 'Failed to load dashboard: $e';
      });
    }
  }

  // ---- Date Range handling ----
  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    if (args.value is! PickerDateRange) return;
    final range = args.value as PickerDateRange;

    final start = range.startDate;
    final end0 = range.endDate ?? start;
    if (start == null || end0 == null) return;

    final now = DateTime.now();
    final end = end0.isAfter(now) ? now : end0;

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

  void _showCalendar(BuildContext context) {
    if (_overlayEntry != null) return;
    if (_fieldKey.currentContext == null) return;

    final renderBox = _fieldKey.currentContext!.findRenderObject() as RenderBox;
    final pos = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;
    final now = DateTime.now();

    final screenWidth = MediaQuery.of(context).size.width;
    const overlayWidth = 320.0;
    final left = (pos.dx + overlayWidth > screenWidth)
        ? (screenWidth - overlayWidth - 8)
        : pos.dx;

    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: _removeOverlay,
              behavior: HitTestBehavior.translucent,
            ),
          ),
          Positioned(
            top: pos.dy + size.height + 5,
            left: left,
            width: overlayWidth,
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
    return SingleChildScrollView(
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
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _timeChip("Today"),
              _timeChip("This Week"),
              _timeChip("This Month"),
              _timeChip("All Time"),
            ],
          ),
          const SizedBox(height: 10),

          // Date range input with overlay
          GestureDetector(
            key: _fieldKey,
            onTap: () => _overlayEntry == null
                ? _showCalendar(context)
                : _removeOverlay(),
            child: Container(
              height: 55,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
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
                        fontSize: 16,
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

          const SizedBox(height: 16),

          // Metrics: loading / error / fixed-height 2-col grid
          if (_loadingTotals)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (_totalsError != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(
                _totalsError!,
                style: const TextStyle(color: Colors.red),
              ),
            )
          else
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // two cards per row
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                mainAxisExtent: 205,
              ),
              itemCount: 8,
              itemBuilder: (context, index) {
                switch (index) {
                  case 0:
                    return _metricCard(
                      color: const Color(0xFF4A9782),
                      leading: const Icon(
                        Icons.account_balance_wallet_outlined,
                        size: 40,
                        color: Colors.white,
                      ),
                      title: "TOTAL REVENUE",
                      bigValue: _moneyText(_totalRevenue),
                      footer: Text(
                        "$_totalVentures ventures",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const TotalRevenuePage(),
                        ),
                      ),
                    );
                  case 1:
                    return _metricCard(
                      color: const Color(0xFFD92C54),
                      leading: SizedBox(
                        height: 40,
                        child: Image.asset(
                          'lib/icons/coins.png',
                          color: Colors.white,
                        ),
                      ),
                      title: "COMMISSION PAID",
                      bigValue: _moneyText(_totalCommission),
                      footer: const Text(
                        "Paid to agent network",
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const CommisionPayoutPage(),
                        ),
                      ),
                    );
                  case 2:
                    return _metricCard(
                      color: const Color(0xFFB13BFF),
                      leading: const Icon(
                        Icons.people_outlined,
                        size: 40,
                        color: Colors.white,
                      ),
                      title: "TOTAL AGENTS",
                      bigValue: _countText(_totalAgents),
                      footer: const Text(
                        "All registered agents",
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ManageAgentPage(),
                        ),
                      ),
                    );
                  case 3:
                    return _metricCard(
                      color: const Color(0xFFD92C54),
                      leading: SizedBox(
                        height: 40,
                        child: Image.asset(
                          'lib/icons/bag.png',
                          color: Colors.white,
                        ),
                      ),
                      title: "TOTAL VENTURES",
                      bigValue: _countText(_totalVentures),
                      footer: const Text(
                        "Ready for investment",
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const TotalVenturesPage(),
                        ),
                      ),
                    );
                  case 4:
                    return _metricCard(
                      color: const Color(0xFFFFD66B),
                      leading: SizedBox(
                        height: 40,
                        child: Image.asset(
                          'lib/icons/bank.png',
                          color: Colors.white,
                        ),
                      ),
                      title: "TOTAL BRANCHES",
                      bigValue: _countText(_totalBranches),
                      footer: const Text(
                        "Across the organization",
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ManageBranchesPage(),
                        ),
                      ),
                    );
                  case 5:
                    return _metricCard(
                      color: const Color(0xFF67AE6E),
                      leading: SizedBox(
                        height: 40,
                        child: Image.asset(
                          'lib/icons/decision-tree.png',
                          color: Colors.white,
                        ),
                      ),
                      title: "REFERRAL TREE",
                      bigValue: _twoLineBigValue("VIEW", "NETWORK"),
                      footer: const Text(
                        "Complete agent hierarchy",
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ReferralPage()),
                      ),
                    );
                  case 6:
                    return _metricCard(
                      color: const Color(0xFF3D74B6),
                      leading: SizedBox(
                        height: 40,
                        child: Image.asset(
                          'lib/icons/pig.png',
                          color: Colors.white,
                        ),
                      ),
                      title: "WITHDRAWAL REQUESTS",
                      bigValue: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '$_totalPendingWithdrawals',
                              maxLines: 1,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            "Pending",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      footer: const Text(
                        "Approve agent payouts",
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const Withdrawalrequestpage(),
                        ),
                      ),
                    );
                  default:
                    return _metricCard(
                      color: const Color(0xFF5C7285),
                      leading: SizedBox(
                        height: 40,
                        child: Image.asset(
                          'lib/icons/charts.png',
                          color: Colors.white,
                        ),
                      ),
                      title: "REPORTS",
                      bigValue: _twoLineBigValue("VIEW &", "EXPORT"),
                      footer: const Text(
                        "Download detailed reports",
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => Reportspage()),
                      ),
                    );
                }
              },
            ),

          const SizedBox(height: 24),

          // QUICK ACTIONS
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
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
              _quickAction(
                iconPath: 'lib/icons/git.png',
                label: 'Create Branch',
                iconHeight: 30,
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
                      builder: (_) => CreateBranchPage(api: _authApi),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ---- UI helpers ----
  Widget _timeChip(String text) => Container(
    decoration: BoxDecoration(
      border: Border.all(color: Colors.black12, width: 1),
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
    child: Text(text, style: const TextStyle(fontSize: 14)),
  );

  // Money value with rupee icon + shrink-to-fit
  Widget _moneyText(num amount) => Row(
    children: [
      const Icon(Icons.currency_rupee_outlined, size: 24, color: Colors.white),
      const SizedBox(width: 2),
      Expanded(
        child: FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(
            _fmtINR(amount).replaceFirst('₹', ''),
            maxLines: 1,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    ],
  );

  // Big count with shrink-to-fit
  Widget _countText(int value) => FittedBox(
    fit: BoxFit.scaleDown,
    alignment: Alignment.centerLeft,
    child: Text(
      '$value',
      maxLines: 1,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 26,
        fontWeight: FontWeight.bold,
      ),
    ),
  );

  // Two-line big value (auto-shrinks as a group)
  Widget _twoLineBigValue(String a, String b) => Expanded(
    child: Align(
      alignment: Alignment.topLeft,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.topLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              a,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              b,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    ),
  );

  Widget _metricCard({
    required Color color,
    required String title,
    Widget? leading,
    required Widget bigValue,
    Widget? footer,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Card(
        color: color,
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (leading != null) leading,
              const SizedBox(height: 6),
              Text(
                title,
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
              const SizedBox(height: 6),
              Expanded(
                child: Align(alignment: Alignment.topLeft, child: bigValue),
              ),
              if (footer != null) ...[const SizedBox(height: 8), footer],
            ],
          ),
        ),
      ),
    );
  }

  Widget _quickAction({
    required String iconPath,
    required String label,
    required double iconHeight,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 220,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black12, width: 1),
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            SizedBox(
              height: iconHeight,
              child: Image.asset(iconPath, color: Colors.black),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _fmtINR(num v) {
    final hasCents = (v % 1) != 0;
    return NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹',
      decimalDigits: hasCents ? 2 : 0,
    ).format(v);
  }
}
