// lib/adminpages/CreateAgentPage.dart
import 'package:flutter/material.dart';
import 'package:new_project/utils/AuthApi.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateAgentPage extends StatefulWidget {
  const CreateAgentPage({super.key, required this.api});
  final AuthApi api;

  @override
  State<CreateAgentPage> createState() => _CreateAgentPageState();
}

class _CreateAgentPageState extends State<CreateAgentPage> {
  // ------- form controllers (only fields used by createAgentMobile) -------
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _contactNumber = TextEditingController();
  final _address = TextEditingController();
  final _aadharNo = TextEditingController();
  final _bankName = TextEditingController();
  final _accountNo = TextEditingController();
  final _ifscCode = TextEditingController();
  final _accountHolderName = TextEditingController();
  final _panNo = TextEditingController();
  final _otherName = TextEditingController();
  final _fatherName = TextEditingController();

  // count and computed amount
  static const double _unitPrice = 50000.0;
  final _countCtrl = TextEditingController(text: '1');
  int get _count => int.tryParse(_countCtrl.text) ?? 1;
  double get _totalAmount => (_count < 1 ? 1 : _count) * _unitPrice;

  // ------- lookups (from API) -------
  bool _loadingLookups = true;
  List<_Branch> _branches = [];
  List<_Venture> _ventures = [];
  List<_AgentLite> _agents = [];

  int? _selectedBranchId;
  int? _selectedVentureId;
  int _selectedUplineId = 0; // 0 = no upline

  bool _submitting = false;
  final _formKey = GlobalKey<FormState>();

  // ---------- lifecycle ----------
  @override
  void initState() {
    super.initState();
    _loadLookups();
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _contactNumber.dispose();
    _address.dispose();
    _aadharNo.dispose();
    _bankName.dispose();
    _accountNo.dispose();
    _ifscCode.dispose();
    _accountHolderName.dispose();
    _panNo.dispose();
    _otherName.dispose();
    _countCtrl.dispose();
    _fatherName.dispose();
    super.dispose();
  }

  // ---------- API lookups ----------
  Future<void> _loadLookups() async {
    setState(() => _loadingLookups = true);
    try {
      // ensure token on API (read from SharedPreferences)
      final sp = await SharedPreferences.getInstance();
      final token = sp.getString('auth_token') ?? sp.getString('token') ?? '';
      if (token.isEmpty) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('You are not logged in')),
        );
        Navigator.pop(context);
        return;
      }
      widget.api.setAuthToken(token);

      // parallel fetch
      final results = await Future.wait([
        widget.api.getBranchDetails(),   // => branchDetails
        widget.api.getVentureDetails(),  // => ventureDetails
        widget.api.getAgentDetails(),    // => agentDetails
      ]);

      final branchJson = (results[0].data?['branchDetails'] as List?) ?? [];
      final ventureJson = (results[1].data?['ventureDetails'] as List?) ?? [];
      final agentJson = (results[2].data?['agentDetails'] as List?) ?? [];

      _branches = branchJson
          .map((e) => _Branch(
        id: (e['id'] ?? 0) as int,
        name: (e['branchName'] ?? '').toString(),
        location: (e['location'] ?? '').toString(),
      ))
          .toList();

      _ventures = ventureJson
          .map((e) => _Venture(
        id: (e['id'] ?? 0) as int,
        name: (e['ventureName'] ?? '').toString(),
        location: (e['location'] ?? '').toString(),
        status: (e['status'] ?? '').toString(),
        totalTrees: (e['totalTrees'] ?? 0) as int,
        treesSold: (e['treesSold'] ?? 0) as int,
      ))
          .toList();

      _agents = agentJson
          .map((e) => _AgentLite(
        id: (e['id'] ?? 0) as int,
        name: (e['name'] ?? '').toString(),
        referalCode: (e['referalId'] ?? '').toString(),
      ))
          .toList();

      // defaults
      _selectedBranchId = _branches.isNotEmpty ? _branches.first.id : null;
      _selectedVentureId = _ventures.isNotEmpty ? _ventures.first.id : null;
      _selectedUplineId = 0;

      if (mounted) setState(() => _loadingLookups = false);
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _loadingLookups = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
    } catch (e) {
      if (!mounted) return;
      setState(() => _loadingLookups = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to load lookups: $e')));
    }
  }

  // ---------- submit ----------
  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    if (_selectedBranchId == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select a branch')));
      return;
    }
    if (_selectedVentureId == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select a venture')));
      return;
    }

    // normalize count >= 1
    final safeCount = (_count < 1) ? 1 : _count;

    setState(() => _submitting = true);
    try {
      final resp = await widget.api.createAgentMobile(
        name: _name.text.trim(),
        email: _email.text.trim(),
        contactNumber: _contactNumber.text.trim(),
        totalAmount: safeCount * _unitPrice,
        ventureId: _selectedVentureId!,
        agentReferalId: _selectedUplineId, // 0 = no upline
        address: _address.text.trim(),
        aadharNo: _aadharNo.text.trim(),
        bankName: _bankName.text.trim(),
        accountNo: _accountNo.text.trim(),
        ifscCode: _ifscCode.text.trim(),
        branchId: _selectedBranchId!,
        otherName: _otherName.text.trim(),
        accountHolderName: _accountHolderName.text.trim(),
        panNo: _panNo.text.trim(),
        count: safeCount,
        fatherName: _fatherName.text.trim(),
      );

      if (!mounted) return;
      if (resp.isSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(resp.message.isNotEmpty ? resp.message : 'Agent created')),
        );
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(resp.message.isNotEmpty ? resp.message : 'Failed to create agent')),
        );
      }
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Unexpected error: $e')));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  // ---------- UI ----------
  OutlineInputBorder get _gb => const OutlineInputBorder();
  OutlineInputBorder get _fb => const OutlineInputBorder(
    borderSide: BorderSide(color: Colors.green, width: 2.0),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create Agent")),
      body: _loadingLookups
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            _h("Basic Info"),
            _label("Name"),
            _text(_name, validator: _req),
            const SizedBox(height: 10),

            _label("Nominee Name (e.g., Sub Agent)"),
            _text(_otherName),
            const SizedBox(height: 16),

            _label("Father/Spouse Name"),
            _text(_fatherName),
            const SizedBox(height: 16),

            _label("Email"),
            _text(_email, validator: _reqEmail),
            const SizedBox(height: 10),

            _label("Contact Number"),
            _text(_contactNumber, validator: _req),
            const SizedBox(height: 10),

            _label("Address"),
            _text(_address, validator: _req),
            const SizedBox(height: 10),

            _label("Upline (Referral)"),
            DropdownButtonFormField<int>(
              value: _selectedUplineId,
              items: [
                const DropdownMenuItem<int>(value: 0, child: Text("No Upline")),
                ..._agents.map((a) => DropdownMenuItem<int>(
                  value: a.id,
                  child: Text("${a.name} • ${a.referalCode}"),
                )),
              ],
              onChanged: (v) => setState(() => _selectedUplineId = v ?? 0),
              decoration: _ddDecoration(),
            ),
            const SizedBox(height: 10),

            _h("KYC"),
            _label("Aadhar No"),
            _text(_aadharNo, validator: _req),
            const SizedBox(height: 10),

            _label("PAN No"),
            _text(_panNo, validator: _req),
            const SizedBox(height: 10),

            _h("Bank Details"),
            _label("Bank Name"),
            _text(_bankName, validator: _req),
            const SizedBox(height: 10),

            _label("Account Holder Name"),
            _text(_accountHolderName, validator: _req),
            const SizedBox(height: 10),

            _label("Account No"),
            _text(_accountNo, validator: _req),
            const SizedBox(height: 10),

            _label("IFSC Code"),
            _text(_ifscCode, validator: _req),
            const SizedBox(height: 16),

            _h("Mappings"),
            _label("Branch"),
            DropdownButtonFormField<int>(
              value: _selectedBranchId,
              items: _branches
                  .map((b) => DropdownMenuItem<int>(
                value: b.id,
                child: Text("${b.name} • ${b.location}"),
              ))
                  .toList(),
              onChanged: (v) => setState(() => _selectedBranchId = v),
              decoration: _ddDecoration(),
            ),
            const SizedBox(height: 10),

            _label("Venture"),
            DropdownButtonFormField<int>(
              value: _selectedVentureId,
              items: _ventures
                  .map((v) => DropdownMenuItem<int>(
                value: v.id,
                child: Text("${v.name} • ${v.location} (${v.treesSold}/${v.totalTrees})"),
              ))
                  .toList(),
              onChanged: (v) => setState(() => _selectedVentureId = v),
              decoration: _ddDecoration(),
            ),
            const SizedBox(height: 10),

            _h("Investment"),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text("Number of Trees", style: TextStyle(fontSize: 14)),
                Text("Total Amount", style: TextStyle(fontSize: 14)),
              ],
            ),
            const SizedBox(height: 8),
            Row(children: [
              IconButton(
                icon: const Icon(Icons.remove, size: 20),
                onPressed: () {
                  final current = int.tryParse(_countCtrl.text) ?? 1;
                  final next = current > 1 ? current - 1 : 1;
                  _countCtrl.text = '$next';
                  setState(() {}); // refresh total
                },
              ),
              SizedBox(
                width: 70,
                child: TextFormField(
                  controller: _countCtrl,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    border: _gb,
                    focusedBorder: _fb,
                    contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add, size: 20),
                onPressed: () {
                  final current = int.tryParse(_countCtrl.text) ?? 1;
                  _countCtrl.text = '${current + 1}';
                  setState(() {});
                },
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text("₹ ${_totalAmount.toStringAsFixed(2)}"),
                ),
              ),
            ]),

            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                onPressed: _submitting ? null : _submit,
                child: _submitting
                    ? const Padding(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: SizedBox(height: 22, width: 22, child: CircularProgressIndicator(strokeWidth: 2)),
                )
                    : const Text("Create Agent"),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  // ---------- small UI helpers ----------
  String? _req(String? v) => (v == null || v.trim().isEmpty) ? 'Required' : null;

  String? _reqEmail(String? v) {
    if (v == null || v.trim().isEmpty) return 'Required';
    final s = v.trim();
    if (!s.contains('@') || !s.contains('.')) return 'Invalid email';
    return null;
  }

  InputDecoration _ddDecoration() => InputDecoration(
    border: _gb,
    enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.grey, width: 1.5)),
    focusedBorder: _fb,
    contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
  );

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Text(text),
  );

  Widget _h(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 8, top: 8),
    child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
  );

  Widget _text(TextEditingController c, {String? Function(String?)? validator}) => TextFormField(
    controller: c,
    validator: validator,
    decoration: InputDecoration(
      border: _gb,
      focusedBorder: _fb,
      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
    ),
  );
}

// ---------- simple local models ----------
class _Branch {
  final int id;
  final String name;
  final String location;
  _Branch({required this.id, required this.name, required this.location});
}

class _Venture {
  final int id;
  final String name;
  final String location;
  final String status;
  final int totalTrees;
  final int treesSold;
  _Venture({
    required this.id,
    required this.name,
    required this.location,
    required this.status,
    required this.totalTrees,
    required this.treesSold,
  });
}

class _AgentLite {
  final int id;
  final String name;
  final String referalCode;
  _AgentLite({required this.id, required this.name, required this.referalCode});
}
