import 'package:flutter/material.dart';
import 'package:new_project/utils/diff_utils.dart';
import 'package:new_project/widgets/app_shell.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:new_project/widgets/app_drawer.dart';
import 'package:new_project/utils/AuthApi.dart';
import 'package:new_project/adminpages/CreateBranchPage.dart';

class ManageBranchesPage extends StatelessWidget {
  const ManageBranchesPage({super.key});

  // @override
  // Widget build(BuildContext context) =>
  //     const Scaffold(body: ManageBranchesPageBody());

  @override
  Widget build(BuildContext context) {
    return const AppShell(title: 'Branches', body: ManageBranchesPageBody());
  }
}

class ManageBranchesPageBody extends StatefulWidget {
  const ManageBranchesPageBody({super.key});

  @override
  State<ManageBranchesPageBody> createState() => _ManageBranchesPageBodyState();
}

class _ManageBranchesPageBodyState extends State<ManageBranchesPageBody> {
  final _search = TextEditingController();
  final _focusNode = FocusNode();

  AuthApi? _api;
  bool _loading = true;
  String? _error;
  List<_Branch> _branches = [];

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
    await _loadBranches();
  }

  Future<void> _loadBranches() async {
    try {
      final resp = await _api!.getBranchDetails();
      final raw = (resp.data?['branchDetails'] as List?) ?? [];
      _branches = raw
          .map((e) => _Branch.fromJson(Map<String, dynamic>.from(e)))
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
        _error = 'Failed to load branches: $e';
      });
    }
  }

  Future<void> _goToCreateBranch() async {
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
      MaterialPageRoute(builder: (_) => CreateBranchPage(api: api)),
    );
    if (created == true) {
      _loadBranches();
    }
  }

  // ---------- EDIT BRANCH ----------
  Future<void> _openEditBranch(_Branch b) async {
    final formKey = GlobalKey<FormState>();
    final nameCtrl = TextEditingController(text: b.branchName);
    final locCtrl = TextEditingController(text: b.location);

    bool submitting = false;
    String? errorText;

    final saved = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setS) {
            InputDecoration dec(String label) => InputDecoration(
              labelText: label,
              border: const OutlineInputBorder(),
              isDense: true,
            );

            Future<void> submit() async {
              if (!formKey.currentState!.validate()) return;

              // Build original vs edited maps
              final original = <String, dynamic>{
                "branchName": b.branchName,
                "location": b.location,
              };
              final edited = <String, dynamic>{
                "branchName": nameCtrl.text,
                "location": locCtrl.text,
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
                await _api!.updateBranchMobile(id: b.id.toString(), body: diff);
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
                              const Icon(
                                Icons.edit_location_alt,
                                color: Colors.green,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Edit Branch (#${b.id})',
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
                                  decoration: dec('Branch Name'),
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
      await _loadBranches();
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Branch updated')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _search.text.trim().isEmpty
        ? _branches
        : _branches.where((b) {
            final q = _search.text.trim().toLowerCase();
            return b.branchName.toLowerCase().contains(q) ||
                b.location.toLowerCase().contains(q) ||
                b.id.toString().toLowerCase().contains(q);
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
              onRefresh: _loadBranches,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Back + Title (same as Agents)
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
                          "Manage Branches",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Search + Create (same styling as Agents)
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _search,
                            focusNode: _focusNode,
                            onChanged: (_) => setState(() {}),
                            decoration: InputDecoration(
                              hintText: 'Search by id / name / location...',
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
                          onTap: _goToCreateBranch,
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
                                  'lib/icons/git.png',
                                  height: 14,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 6),
                                const Text(
                                  "Create Branch",
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
                                  height: 20,
                                  child: Image.asset(
                                    'lib/icons/bank.png',
                                    color: Colors.green,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                const Text(
                                  "Branches",
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const Text(
                              "Manage all company branches",
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
                                    flex: 2,
                                    child: Text(
                                      "ID",
                                      style: TextStyle(color: Colors.green),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 4,
                                    child: Text(
                                      "Name",
                                      style: TextStyle(color: Colors.green),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 4,
                                    child: Text(
                                      "Location",
                                      style: TextStyle(color: Colors.green),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
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
                                final b = filtered[i];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8.0,
                                    horizontal: 4,
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          b.id.toString(),
                                          style: const TextStyle(fontSize: 13),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 4,
                                        child: Text(
                                          b.branchName,
                                          style: const TextStyle(fontSize: 13),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 4,
                                        child: Text(
                                          b.location,
                                          style: const TextStyle(fontSize: 13),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Wrap(
                                          spacing: 8,
                                          children: [
                                            OutlinedButton.icon(
                                              onPressed: () =>
                                                  _openEditBranch(b),
                                              icon: const Icon(
                                                Icons.edit,
                                                size: 16,
                                              ),
                                              label: const Text(
                                                'Edit',
                                                style: TextStyle(fontSize: 12),
                                              ),
                                              style: OutlinedButton.styleFrom(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 8,
                                                    ),
                                                side: BorderSide(
                                                  color: Colors.grey.shade400,
                                                  width: 0.8,
                                                ),
                                              ),
                                            ),
                                          ],
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
}

// ---------- model ----------
class _Branch {
  final int id;
  final String branchName;
  final String location;

  _Branch({required this.id, required this.branchName, required this.location});

  factory _Branch.fromJson(Map<String, dynamic> j) => _Branch(
    id: (j['id'] ?? 0) as int,
    branchName: (j['branchName'] ?? '').toString(),
    location: (j['location'] ?? '').toString(),
  );
}
