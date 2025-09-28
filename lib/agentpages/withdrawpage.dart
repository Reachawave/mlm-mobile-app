import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:new_project/utils/AuthApi.dart';
import 'mainpage.dart';

class WithdrawPage extends StatelessWidget {
  const WithdrawPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const WithdrawBody();
  }
}

class WithdrawBody extends StatefulWidget {
  const WithdrawBody({super.key});

  @override
  State<WithdrawBody> createState() => _WithdrawBodyState();
}

class _WithdrawBodyState extends State<WithdrawBody> {
  final TextEditingController _amountController = TextEditingController();
  double _balance = 0.0;
  List<dynamic> _withdrawals = [];
  bool _loading = true;

  final AuthApi _api = AuthApi();
  String? _agentId;
  String? _token;

  @override
  void initState() {
    super.initState();
    _initializeAndLoad();
  }

  Future<void> _initializeAndLoad() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _agentId = prefs.getInt("agentId")?.toString();
      _token = prefs.getString("token");

      debugPrint("DEBUG: agentId=$_agentId, token=$_token");

      if (_agentId == null || _token == null) {
        debugPrint("ERROR: agentId or token is null");
        _showError("Session expired. Please login again.");
        setState(() => _loading = false);
        return;
      }

      await _loadWithdrawData();
    } catch (e, st) {
      debugPrint("EXCEPTION in _initializeAndLoad: $e");
      debugPrint("STACKTRACE: $st");
      setState(() => _loading = false);
      _showError("Initialization failed: $e");
    }
  }

  Future<void> _loadWithdrawData() async {
    setState(() => _loading = true);
    try {
      final balanceRes = await _api.fetchBalance(
        agentId: _agentId!,
        token: _token!,
      );
      final historyRes = await _api.fetchWithdrawalHistory(
        agentId: _agentId!,
        token: _token!,
      );

      debugPrint("DEBUG: Balance response data = ${balanceRes.data}");
      debugPrint("DEBUG: History response data = ${historyRes.data}");

      setState(() {
        final balanceData = balanceRes.data ?? {};
        final historyData = historyRes.data ?? {};

        // If data structure is different, these might be null
        final bal = balanceData["withdrawlDetails"]?["balance"];
        if (bal is num) {
          _balance = bal.toDouble();
        } else {
          debugPrint("WARNING: balanceData['withdrawlDetails']['balance'] is not a num: $bal");
        }

        final list = historyData["withdrawlDetails"];
        if (list is List) {
          _withdrawals = list;
        } else {
          debugPrint("WARNING: historyData['withdrawlDetails'] is not a List: $list");
          _withdrawals = [];
        }

        _loading = false;
      });
    } catch (e, st) {
      debugPrint("EXCEPTION in _loadWithdrawData: $e");
      debugPrint("STACKTRACE: $st");
      setState(() => _loading = false);
      _showError("Error loading data: $e");
    }
  }

  Future<void> _submitWithdrawal() async {
    final amountText = _amountController.text.trim();
    final amount = double.tryParse(amountText.replaceAll(',', ''));

    if (amount == null || amount <= 0) {
      _showError("Enter a valid amount");
      return;
    }

    if (_agentId == null || _token == null) {
      _showError("Session expired. Please login again.");
      return;
    }

    try {
      debugPrint("DEBUG: Requesting withdrawal: amount = $amount");
      final response = await _api.requestWithdrawal(
        agentId: _agentId!,
        token: _token!,
        amount: amount,
      );
      debugPrint("DEBUG: Withdrawal response = ${response.data}, status = ${response.status}");

      _showSuccess("Withdrawal request sent");
      _amountController.clear();
      _loadWithdrawData();
    } catch (e, st) {
      debugPrint("EXCEPTION in _submitWithdrawal: $e");
      debugPrint("STACKTRACE: $st");
      _showError("Failed to request withdrawal: $e");
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: Colors.red),
    );
  }

  void _showSuccess(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: Colors.green),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: 30),
              _buildBalanceCard(),
              const SizedBox(height: 20),
              _buildRequestForm(),
              const SizedBox(height: 20),
              _buildHistoryCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (c) => Agentdashboardmainpage(initialIndex: 0),
              ),
            );
          },
          child: Container(
            height: 45,
            width: 45,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black12),
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Image.asset('lib/icons/back-arrow.png', color: Colors.black),
          ),
        ),
        const SizedBox(width: 20),
        const Text(
          "Withdraw Funds",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildBalanceCard() {
    return Container(
      height: 150,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Available Balance", style: TextStyle(color: Colors.white, fontSize: 24)),
          Row(
            children: [
              Image.asset("lib/icons/rupee-indian.png", height: 30, color: Colors.white),
              const SizedBox(width: 5),
              Text(
                _balance.toStringAsFixed(2),
                style: const TextStyle(color: Colors.white, fontSize: 50, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRequestForm() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Request Withdrawal", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          const Text("Enter the amount you wish to withdraw", style: TextStyle(color: Colors.green)),
          const SizedBox(height: 20),
          Row(
            children: [
              const Text("Amount to withdraw", style: TextStyle(fontSize: 16)),
              const SizedBox(width: 5),
              Image.asset("lib/icons/rupee-indian.png", height: 13),
            ],
          ),
          const SizedBox(height: 6),
          TextField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: "e.g., 5000",
              hintStyle: TextStyle(color: Colors.green),
              border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _submitWithdrawal,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("lib/icons/upload.png", height: 20, color: Colors.white),
                  const SizedBox(width: 10),
                  const Text("Request Withdrawal", style: TextStyle(fontSize: 20)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      height: 300,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset("lib/icons/history.png", height: 23),
              const SizedBox(width: 10),
              const Text("Withdrawal History", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
            ],
          ),
          const Text("A log of your past Withdrawal requests", style: TextStyle(color: Colors.green)),
          const SizedBox(height: 20),
          Expanded(
            child: _withdrawals.isEmpty
                ? const Center(child: Text("No history found."))
                : ListView.builder(
              itemCount: _withdrawals.length,
              itemBuilder: (context, idx) {
                final item = _withdrawals[idx];
                final amount = item["withdrawlAmount"]?.toString() ?? "0";
                final date = item["raisedDate"] ?? '';
                final status = item["status"] ?? 'Unknown';

                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Image.asset("lib/icons/rupee-indian.png", height: 15),
                                const SizedBox(width: 5),
                                Text(
                                  amount,
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Text(date, style: const TextStyle(color: Colors.green, fontSize: 12)),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: getStatusContainerColor(status),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Text(
                            status,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: getStatusTextColor(status),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                );
              },
            ),
          )
        ],
      ),
    );
  }

  // Helpers for status color
  Color getStatusContainerColor(String status) {
    switch (status.toLowerCase()) {
      case "approved":
        return Colors.green;
      case "declined":
        return Colors.red;
      case "pending":
        return Colors.grey;
      default:
        return Colors.grey.shade300;
    }
  }

  Color getStatusTextColor(String status) {
    switch (status.toLowerCase()) {
      case "approved":
      case "declined":
        return Colors.white;
      case "pending":
        return Colors.black;
      default:
        return Colors.black;
    }
  }
}
