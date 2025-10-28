import 'package:flutter/material.dart';
import 'package:new_project/utils/diff_utils.dart';
import 'package:new_project/widgets/app_shell.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:new_project/widgets/app_drawer.dart';
import 'package:new_project/utils/AuthApi.dart';
import 'package:new_project/adminpages/CreateVenturePage.dart';

class TotalVenturesPage extends StatelessWidget {
  const TotalVenturesPage({super.key});

  // @override
  // Widget build(BuildContext context) =>
  //     const Scaffold(body: TotalVenturesBody());

  @override
  Widget build(BuildContext context) {
    return const AppShell(title: 'Ventures', body: TotalVenturesBody());
  }
}

class TotalVenturesBody extends StatefulWidget {
  const TotalVenturesBody({super.key});

  @override
  State<TotalVenturesBody> createState() => _TotalVenturesBodyState();
}

class _TotalVenturesBodyState extends State<TotalVenturesBody> {
  final _search = TextEditingController();
  final _focusNode = FocusNode();

  AuthApi? _api;
  bool _loading = true;
  String? _error;
  List<_Venture> _ventures = [];

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
    final token = sp.getString('auth_token') ?? sp.getString('token') ?? '';
    if (token.isEmpty) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = 'You are not logged in';
      });
      return;
    }

    _api = AuthApi(token: token);
    await _loadVentures();
  }

  Future<void> _loadVentures() async {
    try {
      final resp = await _api!.getVentureDetails();
      final raw = (resp.data?['ventureDetails'] as List?) ?? [];
      _ventures = raw
          .map((e) => _Venture.fromJson(Map<String, dynamic>.from(e)))
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
        _error = 'Failed to load ventures: $e';
      });
    }
  }

  Future<void> _goToCreateVenture() async {
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
      MaterialPageRoute(builder: (_) => CreateVenturePage(api: api)),
    );
    if (created == true) {
      _loadVentures();
    }
  }

  // ---------- EDIT VENTURE ----------
  Future<void> _openEditVenture(_Venture v) async {
    final formKey = GlobalKey<FormState>();
    final nameCtrl = TextEditingController(text: v.ventureName);
    final locCtrl = TextEditingController(text: v.location);
    String status = v.status;

    bool submitting = false;
    String? errorText;

    // include common statuses + keep unknown current status
    final statuses = <String>{"Active", "Inactive", "On Hold", status}.toList();

    final saved = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setS) {
            Future<void> submit() async {
              if (!formKey.currentState!.validate()) return;

              // Build original vs edited maps
              final original = <String, dynamic>{
                "ventureName": v.ventureName,
                "location": v.location,
                "status": v.status,
              };
              final edited = <String, dynamic>{
                "ventureName": nameCtrl.text,
                "location": locCtrl.text,
                "status": status,
              };

              // Only send changed, non-null, trimmed fields
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
                await _api!.updateVentureMobile(
                  id: v.id.toString(),
                  body: diff,
                );
                if (!mounted) return;
                Navigator.pop(ctx, true);
              } catch (e) {
                setS(() {
                  submitting = false;
                  errorText = e.toString();
                });
              }
            }

            InputDecoration dec(String label) => InputDecoration(
              labelText: label,
              border: const OutlineInputBorder(),
              isDense: true,
            );

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
                                'Edit Venture (#${v.id})',
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

                          Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            children: [
                              SizedBox(
                                width: 520,
                                child: TextFormField(
                                  controller: nameCtrl,
                                  decoration: dec('Venture Name'),
                                  validator: (v) =>
                                      v!.trim().isEmpty ? 'Required' : null,
                                ),
                              ),
                              SizedBox(
                                width: 520,
                                child: TextFormField(
                                  controller: locCtrl,
                                  decoration: dec('Location'),
                                  validator: (v) =>
                                      v!.trim().isEmpty ? 'Required' : null,
                                ),
                              ),
                              SizedBox(
                                width: 520,
                                child: DropdownButtonFormField<String>(
                                  value: status,
                                  items: statuses
                                      .map(
                                        (s) => DropdownMenuItem(
                                          value: s,
                                          child: Text(s),
                                        ),
                                      )
                                      .toList(),
                                  onChanged: (val) =>
                                      setS(() => status = val ?? status),
                                  decoration: dec('Status'),
                                ),
                              ),
                            ],
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

    if (saved == true) {
      await _loadVentures();
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Venture updated')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _search.text.trim().isEmpty
        ? _ventures
        : _ventures.where((v) {
            final q = _search.text.trim().toLowerCase();
            return v.ventureName.toLowerCase().contains(q) ||
                v.location.toLowerCase().contains(q) ||
                v.status.toLowerCase().contains(q) ||
                v.id.toString().toLowerCase().contains(q);
          }).toList();

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
              onRefresh: _loadVentures,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Back + Title
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
                          "Manage Ventures",
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
                                  'Search by name / id / location / status...',
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
                          onTap: _goToCreateVenture,
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
                                  'lib/icons/add.png',
                                  height: 14,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 6),
                                const Text(
                                  "Create Venture",
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

                    // Card/Table
                    Container(
                      width: double.infinity, // responsive
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
                                SizedBox(
                                  height: 24,
                                  child: Image.asset(
                                    "lib/icons/bag.png",
                                    color: Colors.green,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                const Text(
                                  "Ventures",
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const Text(
                              "Monitor the progress of all ongoing ventures",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.green,
                              ),
                            ),
                            const SizedBox(height: 12),

                            // Header row
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 6.0,
                                horizontal: 4,
                              ),
                              child: Row(
                                children: const [
                                  Expanded(
                                    flex: 5,
                                    child: Text(
                                      "Name & Location",
                                      style: TextStyle(color: Colors.green),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                      "Availability",
                                      style: TextStyle(color: Colors.green),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      "Actions",
                                      style: TextStyle(color: Colors.green),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Divider(thickness: 0.3, color: Colors.green),

                            ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: filtered.length,
                              separatorBuilder: (_, __) => const Divider(
                                thickness: 0.25,
                                color: Colors.green,
                              ),
                              itemBuilder: (context, i) {
                                final v = filtered[i];
                                final percent = v.totalTrees == 0
                                    ? 0.0
                                    : (v.treesSold / v.totalTrees).clamp(
                                        0.0,
                                        1.0,
                                      );

                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8.0,
                                    horizontal: 4,
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      // name + location + status badge
                                      Expanded(
                                        flex: 5,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              v.ventureName,
                                              style: const TextStyle(
                                                fontSize: 13,
                                              ),
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              v.location,
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.green,
                                              ),
                                            ),
                                            const SizedBox(height: 6),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                    vertical: 4,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: _statusColor(v.status),
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                              ),
                                              child: Text(
                                                v.status,
                                                style: const TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      // availability bar with breathing room
                                      Expanded(
                                        flex: 3,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                            right: 12.0,
                                          ),
                                          child: _AvailabilityBar(
                                            sold: v.treesSold,
                                            total: v.totalTrees,
                                            percent: percent,
                                          ),
                                        ),
                                      ),

                                      // small spacer
                                      const SizedBox(width: 8),

                                      // fixed-width actions (prevents touching)
                                      SizedBox(
                                        width: 44,
                                        child: IconButton(
                                          tooltip: 'Edit',
                                          icon: const Icon(
                                            Icons.edit,
                                            size: 20,
                                          ),
                                          onPressed: () => _openEditVenture(v),
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
    );
  }

  // badge color
  static Color _statusColor(String s) {
    switch (s.toLowerCase()) {
      case 'active':
        return Colors.green;
      case 'inactive':
        return Colors.redAccent;
      case 'on hold':
        return Colors.orange;
      default:
        return Colors.blueGrey;
    }
  }
}

class _AvailabilityBar extends StatelessWidget {
  final int sold;
  final int total;
  final double percent;

  const _AvailabilityBar({
    super.key,
    required this.sold,
    required this.total,
    required this.percent,
  });

  @override
  Widget build(BuildContext context) {
    const barH = 18.0;
    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        Container(
          height: barH,
          decoration: BoxDecoration(
            color: Colors.black12,
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        FractionallySizedBox(
          widthFactor: percent.isNaN ? 0 : percent,
          child: Container(
            height: barH,
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
        Positioned.fill(
          child: Center(
            child: Text(
              "$sold / $total",
              style: const TextStyle(fontSize: 10, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}

class _Venture {
  final int id;
  final String ventureName;
  final String location;
  final String status;
  final int totalTrees;
  final int treesSold;

  _Venture({
    required this.id,
    required this.ventureName,
    required this.location,
    required this.status,
    required this.totalTrees,
    required this.treesSold,
  });

  factory _Venture.fromJson(Map<String, dynamic> j) => _Venture(
    id: (j['id'] ?? 0) as int,
    ventureName: (j['ventureName'] ?? '').toString(),
    location: (j['location'] ?? '').toString(),
    status: (j['status'] ?? '').toString(),
    totalTrees: (j['totalTrees'] ?? 0) as int,
    treesSold: (j['treesSold'] ?? 0) as int,
  );
}
