import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:new_project/utils/AuthApi.dart';
import 'package:new_project/widgets/app_drawer.dart';
import 'package:new_project/adminpages/CreateAgentPage.dart';
import 'package:new_project/utils/diff_utils.dart';

class ManageAgentPage extends StatelessWidget {
  const ManageAgentPage({super.key});

  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: ManageAgentPageBody());
}

class ManageAgentPageBody extends StatefulWidget {
  const ManageAgentPageBody({super.key});

  @override
  State<ManageAgentPageBody> createState() => _ManageAgentPageBodyState();
}

class _ManageAgentPageBodyState extends State<ManageAgentPageBody> {
  final _search = TextEditingController();
  final _focusNode = FocusNode();

  AuthApi? _api;
  bool _loading = true;
  String? _error;
  List<_Agent> _agents = [];

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
    await _loadAgents();
  }

  Future<void> _loadAgents() async {
    try {
      final resp = await _api!.getAgentDetails();
      final raw = (resp.data?['agentDetails'] as List?) ?? [];
      _agents = raw
          .map((e) => _Agent.fromJson(Map<String, dynamic>.from(e)))
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
        _error = 'Failed to load agents: $e';
      });
    }
  }

  Future<void> _goToCreateAgent() async {
    final sp = await SharedPreferences.getInstance();
    final token = sp.getString('auth_token') ?? sp.getString('token') ?? '';
    if (token.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('You are not logged in')));
      return;
    }
    final api = AuthApi(token: token);
    if (!mounted) return;
    final created = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => CreateAgentPage(api: api)),
    );
    if (created == true) {
      _loadAgents();
    }
  }

  // ---------- EDIT: open modal, submit PUT /agent/update/mobile/{id} ----------
  Future<void> _openEditDialog(_Agent a) async {
    final formKey = GlobalKey<FormState>();

    // Controllers prefilled from the row data
    final name = TextEditingController(text: a.name);
    final otherName = TextEditingController(text: a.otherName);
    final aadharNo = TextEditingController(text: a.aadharNo);
    final panNo = TextEditingController(text: a.panNo);
    final address = TextEditingController(text: a.address);
    final bankName = TextEditingController(text: a.bankName);
    final ifscCode = TextEditingController(text: a.ifscCode);
    final accountNo = TextEditingController(text: a.accountNo);
    final accountHolderName = TextEditingController(text: a.accountHolderName);

    bool submitting = false;
    String? errorText;

    final updated = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return StatefulBuilder(
          builder: (ctx, setS) {
            InputDecoration dec(String label) => const InputDecoration(
              border: OutlineInputBorder(),
              isDense: true,
            ).copyWith(labelText: label);

            Future<void> submit() async {
              if (!formKey.currentState!.validate()) return;

              // Build original vs edited maps
              final original = <String, dynamic>{
                "name": a.name,
                "aadharNo": a.aadharNo,
                "address": a.address,
                "bankName": a.bankName,
                "ifscCode": a.ifscCode,
                "accountNo": a.accountNo,
                "accountHolderName": a.accountHolderName,
                "otherName": a.otherName,
                "panNo": a.panNo,
              };

              final edited = <String, dynamic>{
                "name": name.text,
                "aadharNo": aadharNo.text,
                "address": address.text,
                "bankName": bankName.text,
                "ifscCode": ifscCode.text.toUpperCase(),
                "accountNo": accountNo.text,
                "accountHolderName": accountHolderName.text,
                "otherName": otherName.text,
                "panNo": panNo.text.toUpperCase(),
              };

              // Only send changed (and non-null) fields
              final diff = changedFields(original, edited);

              if (diff.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('No changes to save')),
                );
                return;
              }

              setS(() {
                submitting = true;
                errorText = null;
              });

              try {
                await _api!.updateAgentMobile(id: a.id.toString(), body: diff);
                if (!mounted) return;
                Navigator.pop(ctx, true);
              } catch (e) {
                setS(() {
                  submitting = false;
                  errorText = e.toString();
                });
              }
            }

            return Dialog(
              insetPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 24,
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 520),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.edit, color: Colors.green),
                              const SizedBox(width: 8),
                              Text(
                                'Edit Agent (${a.referalId})',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              const Spacer(),
                              IconButton(
                                icon: const Icon(Icons.close),
                                onPressed: submitting
                                    ? null
                                    : () => Navigator.pop(ctx, false),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          if (errorText != null) ...[
                            Text(
                              errorText!,
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 8),
                          ],

                          LayoutBuilder(
                            builder: (c, con) {
                              final twoCols = con.maxWidth > 460;
                              double colW(bool full) =>
                                  full ? con.maxWidth : (con.maxWidth - 12) / 2;

                              return Wrap(
                                spacing: 12,
                                runSpacing: 12,
                                children: [
                                  SizedBox(
                                    width: colW(false),
                                    child: TextFormField(
                                      controller: name,
                                      decoration: dec('Name'),
                                      validator: (v) =>
                                          v!.trim().isEmpty ? 'Required' : null,
                                    ),
                                  ),
                                  SizedBox(
                                    width: colW(false),
                                    child: TextFormField(
                                      controller: otherName,
                                      decoration: dec('Other Name'),
                                    ),
                                  ),
                                  SizedBox(
                                    width: colW(false),
                                    child: TextFormField(
                                      controller: aadharNo,
                                      decoration: dec('Aadhar No'),
                                      keyboardType: TextInputType.number,
                                      validator: (v) =>
                                          v!.trim().isEmpty ? 'Required' : null,
                                    ),
                                  ),
                                  SizedBox(
                                    width: colW(false),
                                    child: TextFormField(
                                      controller: panNo,
                                      decoration: dec('PAN No'),
                                      textCapitalization:
                                          TextCapitalization.characters,
                                      validator: (v) =>
                                          v!.trim().isEmpty ? 'Required' : null,
                                    ),
                                  ),
                                  SizedBox(
                                    width: colW(true),
                                    child: TextFormField(
                                      controller: address,
                                      decoration: dec('Address'),
                                      maxLines: 2,
                                    ),
                                  ),
                                  SizedBox(
                                    width: colW(false),
                                    child: TextFormField(
                                      controller: bankName,
                                      decoration: dec('Bank Name'),
                                    ),
                                  ),
                                  SizedBox(
                                    width: colW(false),
                                    child: TextFormField(
                                      controller: ifscCode,
                                      decoration: dec('IFSC Code'),
                                      textCapitalization:
                                          TextCapitalization.characters,
                                    ),
                                  ),
                                  SizedBox(
                                    width: colW(false),
                                    child: TextFormField(
                                      controller: accountNo,
                                      decoration: dec('Account No'),
                                      keyboardType: TextInputType.number,
                                    ),
                                  ),
                                  SizedBox(
                                    width: colW(false),
                                    child: TextFormField(
                                      controller: accountHolderName,
                                      decoration: dec('Account Holder Name'),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),

                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: submitting ? null : submit,
                                  icon: submitting
                                      ? const SizedBox(
                                          height: 18,
                                          width: 18,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.white,
                                          ),
                                        )
                                      : const Icon(Icons.save),
                                  label: const Text('Save changes'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                  ),
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
            );
          },
        );
      },
    );

    if (updated == true) {
      await _loadAgents();
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Agent updated')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _search.text.trim().isEmpty
        ? _agents
        : _agents.where((a) {
            final q = _search.text.trim().toLowerCase();
            return a.name.toLowerCase().contains(q) ||
                a.referalId.toLowerCase().contains(q) ||
                a.contactNumber.toLowerCase().contains(q);
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
            onPressed: _loading ? null : _loadAgents,
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
              onRefresh: _loadAgents,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                            "Manage Agents",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Search + Create
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _search,
                              focusNode: _focusNode,
                              onChanged: (_) => setState(() {}),
                              decoration: InputDecoration(
                                hintText:
                                    'Search by name / referral / phone...',
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
                          ),
                          const SizedBox(width: 8),
                          InkWell(
                            onTap: _goToCreateAgent,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: Colors.green,
                                  width: 0.5,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.asset(
                                    'lib/icons/add-friend.png',
                                    height: 14,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(width: 6),
                                  const Text(
                                    "Create Agent",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Table card (fixed-width, horizontal scroll)
                      _AgentsTable(
                        agents: filtered,
                        onEdit: _openEditDialog, // <— wired here
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}

// ====== Fixed-width, horizontally scrollable agents table ======

class _AgentsTable extends StatelessWidget {
  const _AgentsTable({required this.agents, required this.onEdit});

  final List<_Agent> agents;
  final Future<void> Function(_Agent) onEdit;

  static const double _wAgent = 300;
  static const double _wContact = 220;
  static const double _wMap = 340; // Venture • Branch
  static const double _wActions = 220;

  @override
  Widget build(BuildContext context) {
    final totalWidth = _wAgent + _wContact + _wMap + _wActions;

    return Container(
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
                Icon(Icons.people_outlined, size: 30, color: Colors.green),
                SizedBox(width: 10),
                Text(
                  "Agents",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Text(
              "Manage and view all registered agents and their referral upline",
              style: TextStyle(fontSize: 12, color: Colors.green),
            ),
            const SizedBox(height: 16),

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints: BoxConstraints(minWidth: totalWidth),
                child: Column(
                  children: [
                    // Header
                    const Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 6.0,
                        horizontal: 4,
                      ),
                      child: Row(
                        children: [
                          _HeaderCell(width: _wAgent, text: "Agent"),
                          _HeaderCell(width: _wContact, text: "Contact"),
                          _HeaderCell(width: _wMap, text: "Venture • Branch"),
                          _HeaderCell(width: _wActions, text: "Actions"),
                        ],
                      ),
                    ),
                    const Divider(
                      thickness: 0.3,
                      color: Colors.green,
                      height: 0,
                    ),

                    // Rows
                    ...List.generate(agents.length, (i) {
                      final a = agents[i];
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 8.0,
                              horizontal: 4,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _Cell(
                                  width: _wAgent,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        a.name,
                                        style: const TextStyle(fontSize: 13),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        a.referalId,
                                        style: const TextStyle(
                                          fontSize: 11,
                                          color: Colors.green,
                                        ),
                                      ),
                                      if ((a.agentReferalName ?? '').isNotEmpty)
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            top: 2,
                                          ),
                                          child: Text(
                                            "Upline: ${a.agentReferalName}",
                                            style: const TextStyle(
                                              fontSize: 11,
                                              color: Colors.black54,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                _Cell(
                                  width: _wContact,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        a.contactNumber,
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        a.email,
                                        style: const TextStyle(
                                          fontSize: 11,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                _Cell(
                                  width: _wMap,
                                  child: Wrap(
                                    spacing: 6,
                                    runSpacing: 6,
                                    children: [
                                      _chip(
                                        "${a.ventureName} • ${a.ventureLocation}",
                                      ),
                                      _chip("${a.branchName} • ${a.location}"),
                                    ],
                                  ),
                                ),
                                _Cell(
                                  width: _wActions,
                                  child: Wrap(
                                    spacing: 6,
                                    children: [
                                      _actionButton(
                                        iconPath: 'lib/icons/down-arrow.png',
                                        label: 'Receipt',
                                        onTap: () {},
                                      ),
                                      _actionButton(
                                        iconPath: 'lib/icons/edit-button.png',
                                        label: 'Edit',
                                        onTap: () => onEdit(a), // <— OPEN EDIT
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (i != agents.length - 1)
                            const Divider(
                              thickness: 0.25,
                              color: Colors.green,
                              height: 0,
                            ),
                        ],
                      );
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _chip(String text) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
      color: Colors.green.shade50,
      borderRadius: BorderRadius.circular(50),
    ),
    child: Text(
      text,
      style: const TextStyle(fontSize: 11, color: Colors.green),
    ),
  );

  static Widget _actionButton({
    required String iconPath,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: Colors.grey.shade400, width: 0.8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(iconPath, height: 14, color: Colors.black87),
            const SizedBox(width: 6),
            Text(label, style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }
}

class _HeaderCell extends StatelessWidget {
  const _HeaderCell({required this.width, required this.text});

  final double width;
  final String text;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Text(text, style: const TextStyle(color: Colors.green)),
    );
  }
}

class _Cell extends StatelessWidget {
  const _Cell({required this.width, required this.child});

  final double width;
  final Widget child;

  @override
  Widget build(BuildContext context) => SizedBox(width: width, child: child);
}

// ---------- model ----------
class _Agent {
  final int id;
  final String name;
  final String referalId;
  final String email;
  final String contactNumber;
  final String address;
  final String branchName;
  final String location;
  final String ventureName;
  final String ventureLocation;
  final int ventureId;
  final int branchId;
  final double totalAmount;
  final int count;
  final String bankName;
  final String accountNo;
  final String ifscCode;
  final String accountHolderName;
  final String panNo;
  final String aadharNo;
  final int agentReferalId;
  final String? agentReferalName;
  final String otherName;
  final String createdAt;

  _Agent({
    required this.id,
    required this.name,
    required this.referalId,
    required this.email,
    required this.contactNumber,
    required this.address,
    required this.branchName,
    required this.location,
    required this.ventureName,
    required this.ventureLocation,
    required this.ventureId,
    required this.branchId,
    required this.totalAmount,
    required this.count,
    required this.bankName,
    required this.accountNo,
    required this.ifscCode,
    required this.accountHolderName,
    required this.panNo,
    required this.aadharNo,
    required this.agentReferalId,
    required this.agentReferalName,
    required this.otherName,
    required this.createdAt,
  });

  factory _Agent.fromJson(Map<String, dynamic> j) => _Agent(
    id: (j['id'] ?? 0) as int,
    name: (j['name'] ?? '').toString(),
    referalId: (j['referalId'] ?? '').toString(),
    email: (j['email'] ?? '').toString(),
    contactNumber: (j['contactNumber'] ?? '').toString(),
    address: (j['address'] ?? '').toString(),
    branchName: (j['branchName'] ?? '').toString(),
    location: (j['location'] ?? '').toString(),
    ventureName: (j['ventureName'] ?? '').toString(),
    ventureLocation: (j['ventureLocation'] ?? '').toString(),
    ventureId: (j['ventureId'] ?? 0) as int,
    branchId: (j['branchId'] ?? 0) as int,
    totalAmount: (j['totalAmount'] ?? 0).toDouble(),
    count: (j['count'] ?? 0) as int,
    bankName: (j['bankName'] ?? '').toString(),
    accountNo: (j['accountNo'] ?? '').toString(),
    ifscCode: (j['ifscCode'] ?? '').toString(),
    accountHolderName: (j['accountHolderName'] ?? '').toString(),
    panNo: (j['panNo'] ?? '').toString(),
    aadharNo: (j['aadharNo'] ?? '').toString(),
    agentReferalId: (j['agentReferalId'] ?? 0) as int,
    agentReferalName: (j['agentReferalName'])?.toString(),
    otherName: (j['otherName'] ?? '').toString(),
    createdAt: (j['createdAt'] ?? '').toString(),
  );
}
