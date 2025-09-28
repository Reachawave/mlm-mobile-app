import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:new_project/utils/AuthApi.dart';
import 'package:new_project/widgets/app_drawer.dart';

class ReferralPage extends StatefulWidget {
  const ReferralPage({super.key});

  @override
  State<ReferralPage> createState() => _ReferralPageState();
}

class _ReferralPageState extends State<ReferralPage> {
  AuthApi? _api;

  bool _loadingAgents = true;
  bool _loadingLevels = false;
  String? _error;

  final _search = TextEditingController();
  final _searchFocus = FocusNode();

  List<_AgentLite> _agents = [];
  _AgentLite? _selected; // selected agent for levels

  // Map level -> list of entries (always keep 1..5 keys)
  final Map<int, List<_LevelEntry>> _levels = {
    1: [],
    2: [],
    3: [],
    4: [],
    5: [],
  };

  @override
  void initState() {
    super.initState();
    _initApiAndLoad();
  }

  @override
  void dispose() {
    _search.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  Future<void> _initApiAndLoad() async {
    setState(() {
      _loadingAgents = true;
      _error = null;
    });

    try {
      final sp = await SharedPreferences.getInstance();
      final token = sp.getString('token') ?? sp.getString('auth_token') ?? '';
      if (token.isEmpty) {
        setState(() {
          _loadingAgents = false;
          _error = 'You are not logged in';
        });
        return;
      }
      _api = AuthApi(token: token);
      await _loadAgents();
    } catch (e) {
      setState(() {
        _loadingAgents = false;
        _error = 'Failed to initialize: $e';
      });
    }
  }

  Future<void> _loadAgents() async {
    try {
      final resp = await _api!.getAgentDetails();
      final raw = (resp.data?['agentDetails'] as List?) ?? [];
      _agents =
          raw
              .map((e) => _AgentLite.fromJson(Map<String, dynamic>.from(e)))
              .toList()
            ..sort(
              (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
            );

      setState(() {
        _loadingAgents = false;
        _error = null;
      });
    } on ApiException catch (e) {
      setState(() {
        _loadingAgents = false;
        _error = e.message;
      });
    } catch (e) {
      setState(() {
        _loadingAgents = false;
        _error = 'Failed to load agents: $e';
      });
    }
  }

  Future<void> _loadLevelsFor(_AgentLite agent) async {
    setState(() {
      _selected = agent;
      _loadingLevels = true;
      for (var i = 1; i <= 5; i++) {
        _levels[i] = [];
      }
    });

    try {
      // GET /agent/mobile/commision/level/{id}
      final resp = await _api!.getReferralLevels(agentId: agent.id);

      // Expected: {"treeDetails": {"Level1": [...], "Level2":[...], ...}}
      final Map<String, dynamic> tree =
          (resp.data?['treeDetails'] as Map?)?.map(
            (k, v) => MapEntry(k.toString(), v),
          ) ??
          <String, dynamic>{};

      for (var i = 1; i <= 5; i++) {
        final list = (tree['Level$i'] as List?) ?? const [];
        _levels[i] = list.map<_LevelEntry>((j) {
          final m = Map<String, dynamic>.from(j as Map);
          return _LevelEntry(
            level: (m['level'] ?? i) as int,
            amount: (m['amount'] ?? 0).toDouble(),
            parentAgentId: (m['agentId'] ?? 0) as int,
            // root id in payload
            agentReferedId: (m['agentReferedId'] ?? 0) as int,
            // child id
            agentName: (m['agentName'] ?? '').toString(),
            referedAgentName: (m['referedAgentName'] ?? '').toString(),
          );
        }).toList();
      }
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message)));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to load levels: $e')));
    } finally {
      if (mounted) setState(() => _loadingLevels = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredAgents = _search.text.trim().isEmpty
        ? _agents
        : _agents.where((a) {
            final q = _search.text.trim().toLowerCase();
            return a.name.toLowerCase().contains(q) ||
                a.referalId.toLowerCase().contains(q) ||
                a.email.toLowerCase().contains(q);
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
            onPressed: _loadingAgents ? null : _loadAgents,
            icon: const Icon(Icons.refresh, color: Colors.black87),
          ),
          const SizedBox(width: 4),
        ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: Colors.black12),
        ),
      ),
      body: _loadingAgents
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(_error!, textAlign: TextAlign.center),
              ),
            )
          : LayoutBuilder(
              builder: (context, c) {
                final wide = c.maxWidth >= 900;

                if (wide) {
                  // Side-by-side on wide screens
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(width: 360, child: _agentsPanel(filteredAgents)),
                      const VerticalDivider(
                        width: 1,
                        thickness: 1,
                        color: Color(0xFFECECEC),
                      ),
                      // Levels on the right
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(16),
                          child: _levelsPanel(),
                        ),
                      ),
                    ],
                  );
                } else {
                  // Stacked on narrow screens (mobile)
                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _agentsPanel(filteredAgents),
                        const SizedBox(height: 12),
                        _levelsPanel(),
                      ],
                    ),
                  );
                }
              },
            ),
    );
  }

  // ---------------- UI: Agents panel ----------------
  Widget _agentsPanel(List<_AgentLite> filteredAgents) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Agents',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _search,
            focusNode: _searchFocus,
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
                borderSide: const BorderSide(color: Colors.green, width: 2),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.black12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 8),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filteredAgents.length,
              separatorBuilder: (_, __) =>
                  const Divider(height: 1, color: Color(0xFFECECEC)),
              itemBuilder: (context, i) {
                final a = filteredAgents[i];
                final selected = _selected?.id == a.id;
                return ListTile(
                  dense: true,
                  selected: selected,
                  selectedTileColor: Colors.green.shade50,
                  title: Text(
                    a.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    a.referalId,
                    style: const TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _loadLevelsFor(a),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- UI: Levels panel ----------------
  Widget _levelsPanel() {
    if (_selected == null) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.only(top: 40),
          child: Text('Select an agent to view referral levels (up to 5).'),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header of selected agent
        Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: const BoxDecoration(
                color: Color(0xFFEDEDED),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _selected!.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'ID: ${_selected!.referalId}',
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),

        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF9FAF3),
            border: Border.all(color: const Color(0xFFE4E9D0)),
            borderRadius: BorderRadius.circular(10),
          ),
          child: _loadingLevels
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: CircularProgressIndicator(),
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (int lvl = 1; lvl <= 5; lvl++) ...[
                      if (lvl > 1) const SizedBox(height: 6),
                      _levelGroup(
                        level: lvl,
                        entries: _levels[lvl] ?? const [],
                      ),
                    ],
                  ],
                ),
        ),
      ],
    );
  }

  Widget _levelGroup({required int level, required List<_LevelEntry> entries}) {
    return Container(
      margin: EdgeInsets.only(left: level == 1 ? 0 : 18),
      padding: EdgeInsets.only(left: level == 1 ? 0 : 18, top: 6, bottom: 6),
      decoration: level == 1
          ? null
          : const BoxDecoration(
              border: Border(
                left: BorderSide(color: Color(0xFFDCE4C3), width: 2),
              ),
            ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Level title row
          Row(
            children: [
              _levelBadge(level),
              const SizedBox(width: 8),
              Text(
                'Level $level',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 8),

          if (entries.isEmpty)
            Padding(
              padding: const EdgeInsets.only(left: 34),
              child: Text(
                'No entries',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
              ),
            )
          else
            for (final e in entries) ...[
              Padding(
                padding: const EdgeInsets.only(left: 34, bottom: 10),
                child: _nodeTile(
                  title: e.referedAgentName.isNotEmpty
                      ? e.referedAgentName
                      : 'ID: ${e.agentReferedId}',
                  subtitle: 'ID: ${e.agentReferedId}',
                ),
              ),
            ],
        ],
      ),
    );
  }

  Widget _levelBadge(int level) {
    return Container(
      width: 26,
      height: 26,
      decoration: const BoxDecoration(
        color: Color(0xFFE0E0E0),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        '$level',
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _nodeTile({required String title, required String subtitle}) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: const BoxDecoration(
            color: Color(0xFFEDEDED),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 12, color: Colors.black54),
            ),
          ],
        ),
      ],
    );
  }
}

// --------- DTOs ---------
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

class _LevelEntry {
  final int level;
  final double amount;
  final int parentAgentId; // the root id in the payload
  final int agentReferedId; // the child id on this level
  final String agentName;
  final String referedAgentName;

  const _LevelEntry({
    required this.level,
    required this.amount,
    required this.parentAgentId,
    required this.agentReferedId,
    required this.agentName,
    required this.referedAgentName,
  });
}
