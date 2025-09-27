import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:new_project/widgets/app_drawer.dart';
import 'package:new_project/utils/AuthApi.dart';
import 'package:new_project/adminpages/CreateVenturePage.dart';

class TotalVenturesPage extends StatelessWidget {
  const TotalVenturesPage({super.key});

  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: TotalVenturesBody());
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
            onPressed: _loading ? null : _loadVentures,
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
              onRefresh: _loadVentures,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Back + Title (same as Agents/Branches)
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

                    // Search + Create (same styling as Agents)
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: const [
                                  Expanded(
                                    flex: 6,
                                    child: Text(
                                      "Name & Location",
                                      style: TextStyle(color: Colors.green),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 4,
                                    child: Text(
                                      "Availability",
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
                                        flex: 6,
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
                                                color: Colors.green,
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

                                      // availability bar
                                      Expanded(
                                        flex: 4,
                                        child: _AvailabilityBar(
                                          sold: v.treesSold,
                                          total: v.totalTrees,
                                          percent: percent,
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
