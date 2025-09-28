import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:new_project/utils/AuthApi.dart';
import 'package:new_project/models/withdrawl_item.dart';

class Processwithdrawalpage extends StatefulWidget {
  const Processwithdrawalpage({
    super.key,
    required this.item,
    this.presetStatus,
  });

  final WithdrawlItem item;
  final String? presetStatus;

  @override
  State<Processwithdrawalpage> createState() => _ProcesswithdrawalpageState();
}

class _ProcesswithdrawalpageState extends State<Processwithdrawalpage> {
  AuthApi? _api;
  bool _submitting = false;

  String _status = 'Paid';
  final _refNo = TextEditingController();
  final _paymentDateCtrl = TextEditingController(); // dd-MM-yyyy
  final _reason = TextEditingController();
  String _mode = 'Upi';
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _status = widget.presetStatus ?? 'Paid';
    _initApi();
  }

  @override
  void dispose() {
    _refNo.dispose();
    _paymentDateCtrl.dispose();
    _reason.dispose();
    super.dispose();
  }

  Future<void> _initApi() async {
    final sp = await SharedPreferences.getInstance();
    final token = sp.getString('token') ?? sp.getString('auth_token') ?? '';
    _api = AuthApi(token: token);
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final d = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 5),
    );
    if (d != null) {
      _paymentDateCtrl.text =
          '${d.year.toString().padLeft(4, '0')}-'
          '${d.month.toString().padLeft(2, '0')}-'
          '${d.day.toString().padLeft(2, '0')}';
      setState(() {});
    }
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();

    if (_status == 'Paid') {
      if (_refNo.text.trim().isEmpty || _paymentDateCtrl.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Reference number and Payment date are required'),
          ),
        );
        return;
      }
    } else if (_status == 'Cancelled') {
      if (_reason.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please enter a reason for cancellation'),
          ),
        );
        return;
      }
    }

    setState(() => _submitting = true);
    try {
      final resp = await _api!.updateWithdrawlStatus(
        id: widget.item.id,
        status: _status,
        referenceNumber: _status == 'Paid' ? _refNo.text.trim() : null,
        paymentDate: _status == 'Paid' ? _paymentDateCtrl.text.trim() : null,
        paymentMode: _status == 'Paid' ? _mode : null,
        reason: _status == 'Cancelled' ? _reason.text.trim() : null,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(resp.message.isNotEmpty ? resp.message : 'Updated'),
        ),
      );
      Navigator.pop(context, true); // tell list to refresh
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message)));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Unexpected error: $e')));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final w = widget.item;

    return Scaffold(
      appBar: AppBar(title: const Text('Process Withdrawal')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Summary
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _kv('Agent', '${w.name} • ${w.referalId}'),
                    _kv('Agent ID', '${w.agentId}'),
                    _kv('Email', w.email),
                    _kv('Requested Amount', _fmtAmount(w.amount)),
                    _kv(
                      'Raised Date',
                      w.raisedDate != null ? _fmtDate(w.raisedDate!) : '-',
                    ),
                    const SizedBox(height: 6),
                    const Divider(height: 24),
                    const Text(
                      'Update Status',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Status selector
              Row(
                children: [
                  ChoiceChip(
                    selected: _status == 'Paid',
                    label: const Text('Paid'),
                    onSelected: (_) => setState(() => _status = 'Paid'),
                    selectedColor: Colors.green.shade100,
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    selected: _status == 'Cancelled',
                    label: const Text('Cancelled'),
                    onSelected: (_) => setState(() => _status = 'Cancelled'),
                    selectedColor: Colors.red.shade100,
                  ),
                ],
              ),
              const SizedBox(height: 16),

              if (_status == 'Paid') ...[
                const Text('Reference Number'),
                const SizedBox(height: 6),
                TextField(
                  controller: _refNo,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green, width: 2),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                const Text('Payment Date'),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _paymentDateCtrl,
                        readOnly: true,
                        decoration: const InputDecoration(
                          hintText: 'dd-MM-yyyy',
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.green,
                              width: 2,
                            ),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 12,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: _pickDate,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Pick'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                const Text('Payment Mode'),
                const SizedBox(height: 6),
                DropdownButtonFormField<String>(
                  value: _mode,
                  items: const [
                    DropdownMenuItem(value: 'Upi', child: Text('UPI')),
                    DropdownMenuItem(value: 'NEFT', child: Text('NEFT')),
                    DropdownMenuItem(value: 'IMPS', child: Text('IMPS')),
                    DropdownMenuItem(value: 'Cash', child: Text('Cash')),
                    DropdownMenuItem(value: 'Other', child: Text('Other')),
                  ],
                  onChanged: (v) => setState(() => _mode = v ?? 'Upi'),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green, width: 2),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 12,
                    ),
                  ),
                ),
              ] else ...[
                const Text('Reason *'),
                const SizedBox(height: 6),
                TextField(
                  controller: _reason,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    hintText: 'Enter a clear reason for cancellation',
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green, width: 2),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 12,
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitting ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: _submitting
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _kv(String k, String v) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Row(
      children: [
        SizedBox(
          width: 140,
          child: Text(k, style: const TextStyle(color: Colors.black54)),
        ),
        const Text(':  '),
        Expanded(child: Text(v)),
      ],
    ),
  );

  String _fmtDate(DateTime d) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${d.day.toString().padLeft(2, '0')} ${months[d.month - 1]} ${d.year}';
  }

  String _fmtAmount(double v) {
    final s = v.toStringAsFixed(v.truncateToDouble() == v ? 0 : 2);
    return '₹ $s';
  }
}
