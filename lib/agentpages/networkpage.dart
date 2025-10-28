import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:new_project/utils/AuthApi.dart';
import 'mainpage.dart';

class MyNetworkPage extends StatefulWidget {
  const MyNetworkPage({super.key});

  @override
  State<MyNetworkPage> createState() => _MyNetworkPageState();
}

class _MyNetworkPageState extends State<MyNetworkPage> {
  bool _loading = true;
  String? _token;
  String? _agentId;

  /// Map like: "Level1" → List< Map<String, dynamic> >
  Map<String, dynamic> _treeDetails = {};

  // Track expanded levels
  List<bool> _isExpandedList = [];

  @override
  void initState() {
    super.initState();
    _initAndFetch();
  }

  Future<void> _initAndFetch() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _token = prefs.getString("token");
      // If you stored agentId as int:
      final agentIdRaw = prefs.get("agentId");
      _agentId = agentIdRaw?.toString();

      debugPrint("MyNetworkPage: token=$_token, agentId=$_agentId");

      if (_token == null || _agentId == null) {
        _showError("Session expired. Please login again.");
        setState(() => _loading = false);
        return;
      }

      await _fetchNetworkLevels();
    } catch (e, st) {
      debugPrint("Error in _initAndFetch: $e");
      debugPrint("Stack: $st");
      setState(() {
        _loading = false;
      });
      _showError("Initialization error: $e");
    }
  }

  Future<void> _fetchNetworkLevels() async {
    setState(() {
      _loading = true;
    });
    try {
      final res = await AuthApi().fetchCommissionLevel(
        token: _token!,
        agentId: _agentId!,
      );

      debugPrint("Commission fetch response data: ${res.data}");

      final data = res.data ?? {};
      final tree = data["treeDetails"] as Map<String, dynamic>? ?? {};

      setState(() {
        _treeDetails = tree;
        // Prepare expansion list length
        _isExpandedList = List<bool>.generate(tree.keys.length, (_) => false);
        _loading = false;
      });
    } catch (e, st) {
      debugPrint("Error in _fetchNetworkLevels: $e");
      debugPrint("Stack: $st");
      setState(() {
        _loading = false;
      });
      _showError("Failed to load network: $e");
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Network"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (c) => Agentdashboardmainpage(initialIndex: 0),
              ),
            );
          },
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _buildNetworkList(),
    );
  }

  Widget _buildNetworkList() {
    if (_treeDetails.isEmpty) {
      return const Center(child: Text("No network data found."));
    }

    final levelKeys = _treeDetails.keys.toList(); // e.g. ["Level1", "Level2", ...]

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: List.generate(levelKeys.length, (index) {
          final levelKey = levelKeys[index];
          final referralsDynamic = _treeDetails[levelKey];
          List<Map<String, dynamic>> referrals = [];

          if (referralsDynamic is List) {
            referrals = referralsDynamic.cast<Map<String, dynamic>>();
          }

          final isExpanded = _isExpandedList.length > index
              ? _isExpandedList[index]
              : false;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    _isExpandedList[index] = !isExpanded;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "$levelKey (${referrals.length})",
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Icon(isExpanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down),
                    ],
                  ),
                ),
              ),
              if (isExpanded)
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Column(
                    children: referrals.map((agent) {
                      final agentName = agent["agentName"]?.toString() ?? "";
                      final referredName = agent["referedAgentName"]?.toString() ?? "";
                      final amount = agent["amount"]?.toString() ?? "";
                      final level = agent["level"]?.toString() ?? "";

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: ListTile(
                          title: Text(agentName),
                          subtitle: Text("Referred: $referredName\nLevel: $level\nAmount: $amount"),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              const Divider(),
            ],
          );
        }),
      ),
    );
  }
}
