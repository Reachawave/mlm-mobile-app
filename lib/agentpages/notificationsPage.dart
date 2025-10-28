import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:new_project/utils/AuthApi.dart';
import 'package:shared_preferences/shared_preferences.dart';


import 'mainpage.dart' show Agentdashboardmainpage;

class notifypage extends StatelessWidget {
  const notifypage({super.key});

  @override
  Widget build(BuildContext context) => const _NotifyBody();
}

class _NotifyBody extends StatefulWidget {
  const _NotifyBody({super.key});

  @override
  State<_NotifyBody> createState() => _NotifyBodyState();
}

class _NotifyBodyState extends State<_NotifyBody> {
  final _api = AuthApi();

  bool _loading = true;
  String? _error;

  late final String _todayIso; // yyyy-MM-dd
  List<Map<String, dynamic>> _all = [];

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _todayIso =
        "${now.year.toString().padLeft(4, '0')}-"
        "${now.month.toString().padLeft(2, '0')}-"
        "${now.day.toString().padLeft(2, '0')}";
    _loadTodayFromApi();
  }

  Future<void> _loadTodayFromApi() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      // Read token & agentId from SharedPreferences (same as your other screens)
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token");
      final agentId = prefs.getInt("agentId")?.toString();

      if (token == null || token.isEmpty || agentId == null) {
        throw Exception("Missing token/agentId in SharedPreferences.");
      }

      // --- Call your existing API like in _loadWithdrawData() ---
      final historyRes = await _api.fetchWithdrawalHistory(
        agentId: agentId,
        token: token,
      );


      final Map<String, dynamic> historyData =
          (historyRes as dynamic).data ?? <String, dynamic>{};

      final list = historyData["withdrawlDetails"];
      List<Map<String, dynamic>> items;
      if (list is List) {
        items = list.map<Map<String, dynamic>>((e) {
          if (e is Map) return Map<String, dynamic>.from(e);
          return <String, dynamic>{};
        }).toList();
      } else {
        items = [];
        debugPrint(
          "WARNING: historyData['withdrawlDetails'] is not a List: $list",
        );
      }

      setState(() {
        _all = items;
        _loading = false;
      });
    } catch (e, st) {
      debugPrint("EXCEPTION in _loadTodayFromApi: $e");
      debugPrint("STACKTRACE: $st");
      setState(() {
        _error = "Error loading notifications: $e";
        _loading = false;
      });
    }
  }


  String _normalizeIso(String s) {
    if (s.length >= 10 && s[4] == '-' && s[7] == '-') {
      return s.substring(0, 10);
    }
    return s;
  }

  String? _extractDateStr(Map<String, dynamic> item) {
    final pd = item["paymentDate"];
    if (pd is String && pd.isNotEmpty) return _normalizeIso(pd);

    final d = item["date"];
    if (d is String && d.isNotEmpty) return d; // keep dd/MM/yyyy as-is

    final rd = item["raisedDate"];
    if (rd is String && rd.isNotEmpty) return _normalizeIso(rd);

    return null;
  }

  bool _isToday(Map<String, dynamic> item) {
    final ds = _extractDateStr(item);
    if (ds == null) return false;

    if (ds.contains('/')) {
      final parts = ds.split('/');
      if (parts.length == 3) {
        final d = parts[0].padLeft(2, '0');
        final m = parts[1].padLeft(2, '0');
        final y = parts[2].padLeft(4, '0');
        final yyyyMmDd = "$y-$m-$d";
        return yyyyMmDd == _todayIso;
      }
      return false;
    }

    return _normalizeIso(ds) == _todayIso;
  }

  String _displayDate(Map<String, dynamic> item) {
    // Prefer to show paymentDate → date → raisedDate (like you wanted)
    final dateStr =
        (item["paymentDate"] as String?) ??
        (item["date"] as String?) ??
        (item["raisedDate"] as String?) ??
        "";
    return _normalizeIso(dateStr);
  }

  String _displayMessage(Map<String, dynamic> item) {
    final msg = item["message"];
    if (msg is String && msg.trim().isNotEmpty) return msg;

    // Build a fallback readable line from common API fields
    final status = (item["status"] ?? "").toString();
    final amt = item["withdrawlAmount"];
    final mode = (item["paymentMode"] ?? "").toString();
    final ref = (item["referalId"] ?? "").toString();

    final parts = <String>[];
    if (status.isNotEmpty) parts.add(status);
    if (amt != null) parts.add("₹${amt.toString()}");
    if (mode.isNotEmpty) parts.add(mode);
    if (ref.isNotEmpty) parts.add(ref);

    return parts.isEmpty ? "No message provided" : parts.join(" • ");
  }

  @override
  Widget build(BuildContext context) {
    final todays = _all.where(_isToday).toList(growable: false);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row (kept same)
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              Agentdashboardmainpage(initialIndex: 0),
                        ),
                      );
                    },
                    child: Container(
                      height: 45,
                      width: 45,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black12, width: 1.0),
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: SizedBox(
                        height: 8,
                        child: Image.asset(
                          'lib/icons/back-arrow.png',
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20.0),
                  const Text(
                    "Notifications",
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30.0),

              if (_loading)
                const Expanded(
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (_error != null)
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.error_outline, color: Colors.red),
                        const SizedBox(height: 8),
                        Text(
                          _error!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.red),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: _loadTodayFromApi,
                          child: const Text("Retry"),
                        ),
                      ],
                    ),
                  ),
                )
              else
                Expanded(
                  child: todays.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(
                                Icons.inbox_outlined,
                                size: 48,
                                color: Colors.grey,
                              ),
                              SizedBox(height: 8),
                              Text(
                                "No notifications for today",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(12),
                          itemCount: todays.length,
                          itemBuilder: (context, index) {
                            final item = todays[index];

                            final title1 =
                                (item["title1"] as String?) ?? "Payment";
                            final title2 =
                                (item["title2"] as String?) ?? "Processed";
                            final time = (item["time"] as String?) ?? "";

                            final dateStr = _displayDate(item);

                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: item["isRead"] == true
                                    ? Colors.grey[300]
                                    : Colors.white,
                                border: Border.all(
                                  color: Colors.grey,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              title1,
                                              style: const TextStyle(
                                                fontSize: 25.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              title2,
                                              style: const TextStyle(
                                                fontSize: 25.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const Spacer(),
                                        Visibility(
                                          visible: item["isRead"] != true,
                                          child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                // Mark read in the backing list too
                                                final idx = _all.indexOf(item);
                                                if (idx != -1) {
                                                  _all[idx]["isRead"] = true;
                                                }
                                                todays[index]["isRead"] = true;
                                              });
                                            },
                                            child: Container(
                                              width: 110,
                                              height: 45,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                border: Border.all(
                                                  color: Colors.grey,
                                                  width: 1,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.all(
                                                  10.0,
                                                ),
                                                child: Row(
                                                  children: [
                                                    SizedBox(
                                                      height: 14,
                                                      child: Image.asset(
                                                        'lib/icons/check.png',
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 5.0),
                                                    const Text(
                                                      "Mark Read",
                                                      style: TextStyle(
                                                        fontSize: 14.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "$dateStr ,",
                                          style: const TextStyle(
                                            fontSize: 14.0,
                                            color: Colors.green,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          " $time",
                                          style: const TextStyle(
                                            fontSize: 14.0,
                                            color: Colors.green,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 20.0),
                                    Text(
                                      _displayMessage(item),
                                      style: const TextStyle(
                                        fontSize: 14.0,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
