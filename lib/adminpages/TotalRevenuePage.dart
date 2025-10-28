import 'package:flutter/material.dart';
import 'package:new_project/widgets/app_shell.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:new_project/utils/AuthApi.dart';
import 'package:new_project/widgets/app_drawer.dart';

class TotalRevenuePage extends StatelessWidget {
  const TotalRevenuePage({super.key});

  // @override
  // Widget build(BuildContext context) {
  //   return const Scaffold(body: TotalRevenueBody());
  // }

  @override
  Widget build(BuildContext context) {
    return const AppShell(title: 'Investment', body: TotalRevenueBody());
  }
}

class TotalRevenueBody extends StatefulWidget {
  const TotalRevenueBody({super.key});

  @override
  State<TotalRevenueBody> createState() => _TotalRevenueBodyState();
}

class _TotalRevenueBodyState extends State<TotalRevenueBody> {
  AuthApi? _api;
  bool _loading = true;
  String? _error;

  // Investments derived from agentDetails
  List<_Investment> _investments = [];

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
    await _loadInvestments();
  }

  Future<void> _loadInvestments() async {
    try {
      final resp = await _api!.getAgentDetails();
      final raw = (resp.data?['agentDetails'] as List?) ?? [];

      final items = raw
          .map((e) => Map<String, dynamic>.from(e))
          .map((j) {
            return _Investment(
              name: (j['name'] ?? '').toString(),
              referalId: (j['referalId'] ?? '').toString(),
              totalAmount: (j['totalAmount'] == null)
                  ? 0.0
                  : (j['totalAmount'] as num).toDouble(),
              createdAtStr: (j['createdAt'] ?? '').toString(),
            );
          })
          .where((x) => x.totalAmount > 0)
          .toList();

      // Sort by createdAt desc; if parse fails, keep at the end
      items.sort(
        (a, b) => (b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0))
            .compareTo(a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0)),
      );

      setState(() {
        _investments = items;
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
        _error = 'Failed to load investments: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawerEnableOpenDragGesture: false,
      drawer: const AppDrawer(),
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
              onRefresh: _loadInvestments,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header row with back button
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
                            "All Investments",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Card
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
                                    "lib/icons/pig.png",
                                    height: 24,
                                    color: Colors.green,
                                  ),
                                  const SizedBox(width: 10),
                                  const Text(
                                    "Recent Investments",
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const Text(
                                "A log of recent investment activities",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.green,
                                ),
                              ),
                              const SizedBox(height: 20),

                              // Header
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0,
                                  vertical: 6,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: const [
                                    Text(
                                      "Agent (Name • Referral ID)",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.green,
                                      ),
                                    ),
                                    Text(
                                      "Amount",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.green,
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
                                itemCount: _investments.length,
                                separatorBuilder: (_, __) => const Divider(
                                  thickness: 0.3,
                                  color: Colors.green,
                                ),
                                itemBuilder: (context, i) {
                                  final inv = _investments[i];
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0,
                                      vertical: 10,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Agent
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              inv.name,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.black,
                                              ),
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              inv.referalId,
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.green,
                                              ),
                                            ),
                                            if (inv.createdAt != null)
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  top: 4,
                                                ),
                                                child: Text(
                                                  _fmtDate(inv.createdAt!),
                                                  style: const TextStyle(
                                                    fontSize: 11,
                                                    color: Colors.black54,
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),

                                        // Amount
                                        Text(
                                          _fmtCurrency(inv.totalAmount),
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.black,
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

  String _fmtCurrency(double v) {
    // simple ₹ formatting without extra dependencies
    // 50,000.00 -> keep without decimals if .00
    final str = v.toStringAsFixed(v.truncateToDouble() == v ? 0 : 2);
    return '₹ $str';
  }

  String _fmtDate(DateTime d) {
    // yyyy-mm-dd -> dd MMM yyyy
    // (Simple manual map to avoid intl dependency)
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

// ---------- simple investment view model ----------
class _Investment {
  final String name;
  final String referalId;
  final double totalAmount;
  final String createdAtStr;

  DateTime? get createdAt {
    // Accept '2025-09-27' or similar formats; fallback null
    try {
      return DateTime.tryParse(createdAtStr);
    } catch (_) {
      return null;
    }
  }

  _Investment({
    required this.name,
    required this.referalId,
    required this.totalAmount,
    required this.createdAtStr,
  });
}
