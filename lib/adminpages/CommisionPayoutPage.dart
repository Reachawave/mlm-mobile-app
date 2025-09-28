import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:new_project/utils/AuthApi.dart';
import 'package:new_project/widgets/app_drawer.dart';

class CommisionPayoutPage extends StatelessWidget {
  const CommisionPayoutPage({super.key});

  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: CommisionPayoutBody());
}

class CommisionPayoutBody extends StatefulWidget {
  const CommisionPayoutBody({super.key});

  @override
  State<CommisionPayoutBody> createState() => _CommisionPayoutBodyState();
}

class _CommisionPayoutBodyState extends State<CommisionPayoutBody> {
  AuthApi? _api;
  bool _loading = true;
  String? _error;

  List<_WithdrawlRow> _rows = [];

  @override
  void initState() {
    super.initState();
    _initApiAndLoad();
  }

  Future<void> _initApiAndLoad() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    final sp = await SharedPreferences.getInstance();
    final token = sp.getString('token') ?? sp.getString('auth_token') ?? '';
    if (token.isEmpty) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = 'You are not logged in';
      });
      return;
    }

    _api = AuthApi(token: token);
    await _loadWithdrawls();
  }

  Future<void> _loadWithdrawls() async {
    try {
      final resp = await _api!.getWithdrawlDetails();
      final raw = (resp.data?['withdrawlDetails'] as List?) ?? [];

      final rows = raw.map((e) => Map<String, dynamic>.from(e)).map((j) {
        return _WithdrawlRow(
          id: (j['id'] ?? 0) as int,
          name: (j['name'] ?? '').toString(),
          referalId: (j['referalId'] ?? '').toString(),
          email: (j['email'] ?? '').toString(),
          withdrawlAmount: (j['withdrawlAmount'] == null)
              ? 0.0
              : (j['withdrawlAmount'] as num).toDouble(),
          status: (j['status'] ?? '').toString(),
          raisedDateStr: (j['raisedDate'] ?? '').toString(),
          paidDateStr: (j['paidDate'] ?? '').toString(),
        );
      }).toList();

      // Newest first by raisedDate
      rows.sort(
        (a, b) => (b.raisedDate ?? DateTime.fromMillisecondsSinceEpoch(0))
            .compareTo(a.raisedDate ?? DateTime.fromMillisecondsSinceEpoch(0)),
      );

      setState(() {
        _rows = rows;
        _loading = false;
        _error = null;
      });
    } on ApiException catch (e) {
      setState(() {
        _loading = false;
        _error = e.message;
      });
    } catch (e) {
      setState(() {
        _loading = false;
        _error = 'Failed to load payouts: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawerEnableOpenDragGesture: false,
      drawer: const AppDrawer(), // ✅ use unified sidebar
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black12),
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
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
          IconButton(
            tooltip: 'Refresh',
            onPressed: _loading ? null : _loadWithdrawls,
            icon: const Icon(Icons.refresh, color: Colors.black87),
          ),
          const SizedBox(width: 4),
        ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: Colors.black12),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(_error!, textAlign: TextAlign.center),
              ),
            )
          : RefreshIndicator(
              onRefresh: _loadWithdrawls,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header row (back button + title)
                      Row(
                        children: [
                          InkWell(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              height: 45,
                              width: 45,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black12),
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                              ),
                              child: Center(
                                child: Image.asset(
                                  'lib/icons/back-arrow.png',
                                  color: Colors.black,
                                  height: 18,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          const Text(
                            "Commission Payouts",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Card with table
                      Container(
                        width: 1000,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black12, width: 1),
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Image.asset(
                                    "lib/icons/coins.png",
                                    height: 24,
                                    color: Colors.green,
                                  ),
                                  const SizedBox(width: 10),
                                  const Text(
                                    "Payout History",
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const Text(
                                "A complete log of all agent withdrawal requests",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.green,
                                ),
                              ),
                              const SizedBox(height: 20),

                              // Header row
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0,
                                  vertical: 6,
                                ),
                                child: Row(
                                  children: const [
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        "Agent",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.green,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        "Amount",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.green,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        "Date",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.green,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        "Status",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.green,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Divider(
                                thickness: 0.3,
                                color: Colors.green,
                              ),

                              // Rows
                              ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: _rows.length,
                                separatorBuilder: (_, __) => const Divider(
                                  thickness: 0.3,
                                  color: Colors.green,
                                ),
                                itemBuilder: (context, i) {
                                  final r = _rows[i];
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0,
                                      vertical: 10,
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Agent
                                        Expanded(
                                          flex: 3,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                r.name,
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                r.referalId,
                                                style: const TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.green,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                        // Amount
                                        Expanded(
                                          flex: 2,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                              top: 6,
                                            ),
                                            child: Text(
                                              _fmtCurrency(r.withdrawlAmount),
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                        ),

                                        // Date
                                        Expanded(
                                          flex: 2,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                              top: 6,
                                            ),
                                            child: Text(
                                              r.raisedDate != null
                                                  ? _fmtDate(r.raisedDate!)
                                                  : '-',
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                        ),

                                        // Status (pill)
                                        Expanded(
                                          flex: 2,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                              top: 2,
                                            ),
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 12,
                                                    vertical: 6,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: _statusBg(r.status),
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                              ),
                                              child: Text(
                                                r.status.isEmpty
                                                    ? '-'
                                                    : r.status,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w600,
                                                  color: _statusFg(r.status),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
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

  // --------------- UI helpers ---------------
  Color _statusBg(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.green;
      case 'declined':
        return Colors.red;
      case 'pending':
        return Colors.grey;
      default:
        return Colors.grey.shade300;
    }
  }

  Color _statusFg(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
      case 'declined':
        return Colors.white;
      case 'pending':
        return Colors.black;
      default:
        return Colors.black;
    }
  }

  String _fmtCurrency(double v) {
    final str = v.toStringAsFixed(v.truncateToDouble() == v ? 0 : 2);
    return '₹ $str';
  }

  String _fmtDate(DateTime d) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${d.day.toString().padLeft(2, '0')} ${months[d.month - 1]} ${d.year}';
  }
}

// --------- local view model ----------
class _WithdrawlRow {
  final int id;
  final String name;
  final String referalId;
  final String email;
  final double withdrawlAmount;
  final String status;
  final String raisedDateStr; // e.g. "2025-09-27"
  final String paidDateStr;

  DateTime? get raisedDate {
    try {
      return DateTime.tryParse(raisedDateStr);
    } catch (_) {
      return null;
    }
  }

  _WithdrawlRow({
    required this.id,
    required this.name,
    required this.referalId,
    required this.email,
    required this.withdrawlAmount,
    required this.status,
    required this.raisedDateStr,
    required this.paidDateStr,
  });
}
