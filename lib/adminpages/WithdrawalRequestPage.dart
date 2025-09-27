import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:new_project/utils/AuthApi.dart';
import 'package:new_project/widgets/app_drawer.dart';
import 'package:new_project/models/withdrawl_item.dart';
import 'package:new_project/adminpages/ProcessWithdrawalPage.dart';

class Withdrawalrequestpage extends StatefulWidget {
  const Withdrawalrequestpage({super.key});

  @override
  State<Withdrawalrequestpage> createState() => _WithdrawalrequestpageState();
}

class _WithdrawalrequestpageState extends State<Withdrawalrequestpage> {
  AuthApi? _api;

  bool _loading = true;
  String? _error;

  final _search = TextEditingController();
  final _focusNode = FocusNode();

  // fetched & derived
  List<WithdrawlItem> _items = [];
  Map<int, _AgentLite> _agentsById = {};

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
        setState(() {
          _loading = false;
          _error = 'You are not logged in';
        });
        return;
      }
      _api = AuthApi(token: token);
      await _loadData();
    } catch (e) {
      setState(() {
        _loading = false;
        _error = 'Failed to initialize: $e';
      });
    }
  }

  Future<void> _loadData() async {
    try {
      // 1) Load agents for enrichment by agentId
      final agentsResp = await _api!.getAgentDetails();
      final agentRaw = (agentsResp.data?['agentDetails'] as List?) ?? [];
      _agentsById = {
        for (final e in agentRaw)
          (e['id'] as int): _AgentLite.fromJson(Map<String, dynamic>.from(e)),
      };

      // 2) Load PENDING withdrawals
      final wResp = await _api!.getWithdrawlPendingDetails();
      final wRaw = (wResp.data?['withdrawlDetails'] as List?) ?? [];

      _items = wRaw
          .map<WithdrawlItem>((e) {
            final m = Map<String, dynamic>.from(e);
            final agentId = (m['agentId'] ?? 0) as int;

            // Prefer values from withdrawal; fallback to agent data when missing
            final ag = _agentsById[agentId];
            final name = (m['name'] ?? ag?.name ?? '').toString();
            final referalId = (m['referalId'] ?? ag?.referalId ?? '')
                .toString();
            final email = (m['email'] ?? ag?.email ?? '').toString();

            return WithdrawlItem(
              id: (m['id'] ?? 0) as int,
              agentId: agentId,
              name: name,
              referalId: referalId,
              email: email,
              amount: (m['withdrawlAmount'] ?? 0).toDouble(),
              status: (m['status'] ?? '').toString(),
              raisedDateStr: (m['raisedDate'] ?? '').toString(),
            );
          })
          .where((w) => w.status.toLowerCase() == 'pending')
          .toList();

      setState(() {
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
        _error = 'Failed to load: $e';
      });
    }
  }

  Future<void> _processItem(WithdrawlItem item) async {
    if (_api == null) return;

    // Open the processing page; refresh on success
    final updated = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => Processwithdrawalpage(item: item)),
    );
    if (updated == true) {
      _loadData();
    }
  }

  Future<void> _cancelItemWithReason(WithdrawlItem item) async {
    final reasonCtrl = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cancel Withdrawal'),
        content: TextField(
          controller: reasonCtrl,
          maxLines: 3,
          decoration: const InputDecoration(
            hintText: 'Enter a clear reason for cancellation',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Submit'),
          ),
        ],
      ),
    );

    if (ok != true) return;

    final reason = reasonCtrl.text.trim();
    if (reason.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Reason is required')));
      return;
    }

    try {
      final resp = await _api!.updateWithdrawlStatus(
        id: item.id,
        status: 'Cancelled',
        reason: reason,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(resp.message.isNotEmpty ? resp.message : 'Cancelled'),
        ),
      );
      _loadData();
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message)));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Unexpected error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _search.text.trim().isEmpty
        ? _items
        : _items.where((w) {
            final q = _search.text.trim().toLowerCase();
            return w.name.toLowerCase().contains(q) ||
                w.referalId.toLowerCase().contains(q) ||
                w.email.toLowerCase().contains(q);
          }).toList();

    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black12),
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
          IconButton(
            tooltip: 'Refresh',
            onPressed: _loading ? null : _loadData,
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
              onRefresh: _loadData,
              child: LayoutBuilder(
                builder: (context, c) {
                  final isWide = c.maxWidth >= 720;
                  return SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title row
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
                                  child: const Center(
                                    child: Icon(
                                      Icons.arrow_back,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 20),
                              const Text(
                                "Withdrawal Requests",
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

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
                                borderSide: const BorderSide(
                                  color: Colors.grey,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: Colors.grey,
                                ),
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

                          // Card with table or card list (responsive)
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black12,
                                width: 1,
                              ),
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
                                        Icons.monetization_on_outlined,
                                        size: 24,
                                        color: Colors.green,
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        "Withdrawal Requests",
                                        style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Text(
                                    "Review and process pending withdrawal requests",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.green,
                                    ),
                                  ),
                                  const SizedBox(height: 16),

                                  if (filtered.isEmpty)
                                    Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 28,
                                      ),
                                      alignment: Alignment.center,
                                      child: const Text(
                                        'No matching requests.',
                                        style: TextStyle(color: Colors.black54),
                                      ),
                                    )
                                  else if (isWide)
                                    _TableView(
                                      items: filtered,
                                      onProcess: _processItem,
                                      onCancel: _cancelItemWithReason,
                                    )
                                  else
                                    _CardListView(
                                      items: filtered,
                                      onProcess: _processItem,
                                      onCancel: _cancelItemWithReason,
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }

  String _fmtAmount(double v) {
    final s = v.toStringAsFixed(v.truncateToDouble() == v ? 0 : 2);
    return '₹ $s';
  }

  // Display as yyyy-MM-dd
  String _fmtDate(DateTime d) {
    final y = d.year.toString().padLeft(4, '0');
    final m = d.month.toString().padLeft(2, '0');
    final day = d.day.toString().padLeft(2, '0');
    return '$y-$m-$day';
  }
}

// ------- WIDE VIEW: DataTable --------
class _TableView extends StatelessWidget {
  const _TableView({
    required this.items,
    required this.onProcess,
    required this.onCancel,
  });

  final List<WithdrawlItem> items;
  final ValueChanged<WithdrawlItem> onProcess;
  final ValueChanged<WithdrawlItem> onCancel;

  @override
  Widget build(BuildContext context) {
    final rows = items.map((w) {
      return DataRow(
        cells: [
          DataCell(
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(w.name, style: const TextStyle(fontSize: 13)),
                const SizedBox(height: 2),
                Text(
                  w.referalId,
                  style: const TextStyle(fontSize: 11, color: Colors.green),
                ),
                const SizedBox(height: 2),
                Text(
                  w.email,
                  style: const TextStyle(fontSize: 11, color: Colors.black54),
                ),
              ],
            ),
          ),
          DataCell(
            Text(_fmtAmount(w.amount), style: const TextStyle(fontSize: 13)),
          ),
          DataCell(
            Text(_fmtDate(w.raisedDate), style: const TextStyle(fontSize: 13)),
          ),
          DataCell(
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton.icon(
                  onPressed: () => onProcess(w),
                  icon: const Icon(Icons.chevron_right, size: 16),
                  label: const Text('Process', style: TextStyle(fontSize: 12)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: () => onCancel(w),
                  icon: const Icon(Icons.close, size: 16),
                  label: const Text('Cancel', style: TextStyle(fontSize: 12)),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }).toList();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 800),
        child: DataTable(
          headingTextStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.green,
          ),
          dataRowMinHeight: 56,
          dataRowMaxHeight: 72,
          columnSpacing: 24,
          columns: const [
            DataColumn(label: Text('Agent')),
            DataColumn(label: Text('Amount')),
            DataColumn(label: Text('Raised')),
            DataColumn(label: Text('Actions')),
          ],
          rows: rows,
        ),
      ),
    );
  }

  String _fmtAmount(double v) {
    final s = v.toStringAsFixed(v.truncateToDouble() == v ? 0 : 2);
    return '₹ $s';
  }

  String _fmtDate(DateTime? d) {
    if (d == null) return '-';
    final y = d.year.toString().padLeft(4, '0');
    final m = d.month.toString().padLeft(2, '0');
    final day = d.day.toString().padLeft(2, '0');
    return '$y-$m-$day';
  }
}

// ------- NARROW VIEW: Cards --------
class _CardListView extends StatelessWidget {
  const _CardListView({
    required this.items,
    required this.onProcess,
    required this.onCancel,
  });

  final List<WithdrawlItem> items;
  final ValueChanged<WithdrawlItem> onProcess;
  final ValueChanged<WithdrawlItem> onCancel;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: items.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, i) {
        final w = items[i];
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
              // Agent
              Text(
                w.name,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                w.referalId,
                style: const TextStyle(fontSize: 12, color: Colors.green),
              ),
              const SizedBox(height: 2),
              Text(
                w.email,
                style: const TextStyle(fontSize: 12, color: Colors.black54),
              ),
              const SizedBox(height: 10),

              // Amount + Date
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _kv('Amount', _fmtAmount(w.amount)),
                  _kv('Raised', _fmtDate(w.raisedDate)),
                ],
              ),
              const SizedBox(height: 12),

              // Actions
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => onProcess(w),
                      icon: const Icon(Icons.chevron_right, size: 16),
                      label: const Text('Process'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    onPressed: () => onCancel(w),
                    icon: const Icon(Icons.close),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
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

  Widget _kv(String k, String v) => Row(
    children: [
      Text('$k: ', style: const TextStyle(fontSize: 12, color: Colors.black54)),
      Text(v, style: const TextStyle(fontSize: 12)),
    ],
  );

  String _fmtAmount(double v) {
    final s = v.toStringAsFixed(v.truncateToDouble() == v ? 0 : 2);
    return '₹ $s';
  }

  String _fmtDate(DateTime? d) {
    if (d == null) return '-';
    final y = d.year.toString().padLeft(4, '0');
    final m = d.month.toString().padLeft(2, '0');
    final day = d.day.toString().padLeft(2, '0');
    return '$y-$m-$day';
  }
}

// ------- lightweight agent DTO for enrichment -------
class _AgentLite {
  final int id;
  final String name;
  final String referalId;
  final String email;

  const _AgentLite({
    required this.id,
    required this.name,
    required this.referalId,
    required this.email,
  });

  factory _AgentLite.fromJson(Map<String, dynamic> j) => _AgentLite(
    id: (j['id'] ?? 0) as int,
    name: (j['name'] ?? '').toString(),
    referalId: (j['referalId'] ?? '').toString(),
    email: (j['email'] ?? '').toString(),
  );
}
