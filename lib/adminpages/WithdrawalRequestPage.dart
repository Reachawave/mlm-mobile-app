import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:new_project/widgets/app_shell.dart';
import 'package:new_project/utils/AuthApi.dart';
import 'package:new_project/models/withdrawl_item.dart';
import 'package:new_project/adminpages/ProcessWithdrawalPage.dart';

class Withdrawalrequestpage extends StatelessWidget {
  const Withdrawalrequestpage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppShell(title: 'Withdrawals', body: _WithdrawalRequestBody());
  }
}

class _WithdrawalRequestBody extends StatefulWidget {
  const _WithdrawalRequestBody({super.key});

  @override
  State<_WithdrawalRequestBody> createState() => _WithdrawalRequestBodyState();
}

class _WithdrawalRequestBodyState extends State<_WithdrawalRequestBody> {
  AuthApi? _api;

  bool _loading = true;
  String? _error;

  final _search = TextEditingController();
  final _focusNode = FocusNode();

  List<WithdrawlBalanceItem> _balances = [];

  @override
  void initState() {
    super.initState();
    _initApiAndLoad();
  }

  @override
  void dispose() {
    _search.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _initApiAndLoad() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
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
      await _loadBalances();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = 'Failed to initialize: $e';
      });
    }
  }

  Future<void> _loadBalances() async {
    try {
      final balResp = await _api!.getWithdrawlBalanceAdmin();
      final balRaw = (balResp.data?['withdrawlDetails'] as List?) ?? [];
      final items = balRaw
          .map(
            (e) => WithdrawlBalanceItem.fromJson(Map<String, dynamic>.from(e)),
          )
          .toList();

      if (!mounted) return;
      setState(() {
        _balances = items;
        _loading = false;
        _error = null;
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = e.message;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = 'Failed to load: $e';
      });
    }
  }

  Future<void> _openProcess(WithdrawlBalanceItem item) async {
    final updated = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => Processwithdrawalpage(item: item)),
    );
    if (updated == true) {
      await _loadBalances();
    }
  }

  String _fmtAmount(double v) {
    final s = v.toStringAsFixed(v.truncateToDouble() == v ? 0 : 2);
    return '₹ $s';
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(_error!, textAlign: TextAlign.center),
        ),
      );
    }

    final q = _search.text.trim().toLowerCase();
    final filtered = q.isEmpty
        ? _balances
        : _balances.where((b) {
            return b.name.toLowerCase().contains(q) ||
                b.referalId.toLowerCase().contains(q) ||
                b.email.toLowerCase().contains(q);
          }).toList();

    return RefreshIndicator(
      onRefresh: _loadBalances,
      child: LayoutBuilder(
        builder: (context, c) {
          final isWide = c.maxWidth >= 720;
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search
                TextField(
                  controller: _search,
                  focusNode: _focusNode,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: 'Search by name / referral / email...',
                    prefixIcon: const Icon(Icons.search),
                    contentPadding: const EdgeInsets.all(10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Colors.green,
                        width: 2,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Balances card
                Container(
                  width: double.infinity,
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
                          children: const [
                            Icon(
                              Icons.account_balance_wallet_outlined,
                              size: 24,
                              color: Colors.green,
                            ),
                            SizedBox(width: 10),
                            Text(
                              "Agent Balances",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const Text(
                          "Available balance for each agent (from /admin/mobile/withdrawl/balance)",
                          style: TextStyle(fontSize: 12, color: Colors.green),
                        ),
                        const SizedBox(height: 16),

                        if (filtered.isEmpty)
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            alignment: Alignment.centerLeft,
                            child: const Text(
                              'No balances found.',
                              style: TextStyle(color: Colors.black54),
                            ),
                          )
                        else if (isWide)
                          _BalanceTableView(
                            items: filtered,
                            onProcess: _openProcess,
                          )
                        else
                          _BalanceCardListView(
                            items: filtered,
                            onProcess: _openProcess,
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ------- WIDE VIEW: DataTable for balances with Process action -------
class _BalanceTableView extends StatelessWidget {
  const _BalanceTableView({required this.items, required this.onProcess});

  final List<WithdrawlBalanceItem> items;
  final ValueChanged<WithdrawlBalanceItem> onProcess;

  @override
  Widget build(BuildContext context) {
    String _fmtAmount(double v) {
      final s = v.toStringAsFixed(v.truncateToDouble() == v ? 0 : 2);
      return '₹ $s';
    }

    final rows = items.map((b) {
      return DataRow(
        cells: [
          DataCell(
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(b.name, style: const TextStyle(fontSize: 13)),
                const SizedBox(height: 2),
                Text(
                  b.referalId,
                  style: const TextStyle(fontSize: 11, color: Colors.green),
                ),
                const SizedBox(height: 2),
                Text(
                  b.email,
                  style: const TextStyle(fontSize: 11, color: Colors.black54),
                ),
              ],
            ),
          ),
          DataCell(
            Text(
              _fmtAmount(b.balanceAmount),
              style: const TextStyle(fontSize: 13),
            ),
          ),
          DataCell(
            ElevatedButton.icon(
              onPressed: b.balanceAmount > 0 ? () => onProcess(b) : null,
              icon: const Icon(Icons.chevron_right, size: 16),
              label: const Text('Process', style: TextStyle(fontSize: 12)),
              style: ElevatedButton.styleFrom(
                backgroundColor: b.balanceAmount > 0
                    ? Colors.green
                    : Colors.grey,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
            ),
          ),
        ],
      );
    }).toList();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 680),
        child: DataTable(
          headingTextStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.green,
          ),
          dataRowMinHeight: 48,
          dataRowMaxHeight: 64,
          columnSpacing: 24,
          columns: const [
            DataColumn(label: Text('Agent')),
            DataColumn(label: Text('Balance')),
            DataColumn(label: Text('Actions')),
          ],
          rows: rows,
        ),
      ),
    );
  }
}

// ------- NARROW VIEW: Cards for balances with Process action -------
class _BalanceCardListView extends StatelessWidget {
  const _BalanceCardListView({required this.items, required this.onProcess});

  final List<WithdrawlBalanceItem> items;
  final ValueChanged<WithdrawlBalanceItem> onProcess;

  @override
  Widget build(BuildContext context) {
    String _fmtAmount(double v) {
      final s = v.toStringAsFixed(v.truncateToDouble() == v ? 0 : 2);
      return '₹ $s';
    }

    return ListView.separated(
      itemCount: items.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, i) {
        final b = items[i];
        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black12, width: 1),
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                b.name,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                b.referalId,
                style: const TextStyle(fontSize: 12, color: Colors.green),
              ),
              const SizedBox(height: 2),
              Text(
                b.email,
                style: const TextStyle(fontSize: 12, color: Colors.black54),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Text(
                        'Balance: ',
                        style: TextStyle(fontSize: 12, color: Colors.black54),
                      ),
                      Text(
                        _fmtAmount(b.balanceAmount),
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                  ElevatedButton.icon(
                    onPressed: b.balanceAmount > 0 ? () => onProcess(b) : null,
                    icon: const Icon(Icons.chevron_right, size: 16),
                    label: const Text('Process'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: b.balanceAmount > 0
                          ? Colors.green
                          : Colors.grey,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
