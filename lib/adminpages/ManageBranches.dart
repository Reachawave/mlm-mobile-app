import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:new_project/widgets/app_drawer.dart';
import 'package:new_project/utils/AuthApi.dart';
import 'package:new_project/adminpages/CreateBranchPage.dart';

class ManageBranchesPage extends StatelessWidget {
  const ManageBranchesPage({super.key});

  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: ManageBranchesPageBody());
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
            onPressed: _loading ? null : _loadBranches,
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
                                      "Branch ID",
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
