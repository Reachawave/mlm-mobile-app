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

  final WithdrawlBalanceItem item;

  final String? presetStatus;

  @override
  State<Processwithdrawalpage> createState() => _ProcesswithdrawalpageState();
}

class _ProcesswithdrawalpageState extends State<Processwithdrawalpage> {
  bool _submitting = false;

  // Form fields
  final _withdrawAmountCtrl = TextEditingController(); // must be 1..balance
  final _totalAmountCtrl = TextEditingController(); // read-only, = balance
  final _refNoCtrl = TextEditingController(); // required
  final _paymentDateCtrl = TextEditingController(); // yyyy-MM-dd required
  String _mode = 'Upi';

  String? _amountError;

  double get _balance => widget.item.balanceAmount;

  @override
  void initState() {
    super.initState();
    _totalAmountCtrl.text = _fmtNumber(_balance);
    _withdrawAmountCtrl.text = _balance > 0 ? _fmtNumber(_balance) : '';
    _withdrawAmountCtrl.addListener(_validateAmount); // live validation
  }

  @override
  void dispose() {
    _withdrawAmountCtrl.removeListener(_validateAmount);
    _withdrawAmountCtrl.dispose();
    _totalAmountCtrl.dispose();
    _refNoCtrl.dispose();
    _paymentDateCtrl.dispose();
    super.dispose();
  }

  // ===== Helpers =====

  void _toast(String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  double? _asDouble(String s) {
    final v = s.trim();
    if (v.isEmpty) return null;
    return double.tryParse(v);
  }

  String _fmtNumber(double v) =>
      v.toStringAsFixed(v.truncateToDouble() == v ? 0 : 2);

  InputDecoration _decoration() => const InputDecoration(
    border: OutlineInputBorder(),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.green, width: 2),
    ),
    contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
  );

  // ===== Validation =====

  /// Withdraw Amount must be between 1 and balance (inclusive)
  void _validateAmount() {
    final v = _asDouble(_withdrawAmountCtrl.text);
    if (v == null) {
      setState(() => _amountError = 'Enter a valid number');
      return;
    }
    if (v <= 0) {
      setState(() => _amountError = 'Amount must be greater than 0');
      return;
    }
    if (v > _balance) {
      setState(
        () => _amountError =
            'Amount cannot exceed current balance (₹ ${_fmtNumber(_balance)})',
      );
      return;
    }
    if (_amountError != null) setState(() => _amountError = null);
  }

  bool get _isFormValid {
    if (_balance <= 0) return false; // cannot process zero balance
    if (_amountError != null) return false;

    final withdraw = _asDouble(_withdrawAmountCtrl.text);
    if (withdraw == null || withdraw <= 0 || withdraw > _balance) return false;

    if (_refNoCtrl.text.trim().isEmpty) return false;
    if (_paymentDateCtrl.text.trim().isEmpty) return false;

    return true;
  }

  // ===== Actions =====

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
          '${d.day.toString().padLeft(2, '0')}'; // yyyy-MM-dd
      setState(() {});
    }
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();

    // Final guard
    if (!_isFormValid) {
      _toast('Please complete the form correctly.');
      return;
    }

    // Token
    final sp = await SharedPreferences.getInstance();
    final token = sp.getString('token') ?? sp.getString('auth_token') ?? '';
    if (token.isEmpty) {
      _toast('Missing token');
      return;
    }

    // Values
    final withdraw = _asDouble(_withdrawAmountCtrl.text)!; // safe: _isFormValid
    final total = _balance; // equals current balance, read-only
    final ref = _refNoCtrl.text.trim();
    final pDate = _paymentDateCtrl.text.trim();

    setState(() => _submitting = true);
    try {
      // POST /admin/mobile/withdrawl/save
      final resp = await AuthApi().saveAdminWithdrawl(
        agentId: widget.item.agentId.toString(),
        token: token,
        withdrawlAmount: withdraw,
        totalAmount: total,
        referenceNumber: ref,
        paymentDate: pDate,
        paymentMode: _mode,
      );

      if (!mounted) return;
      _toast(resp.message.isNotEmpty ? resp.message : 'Saved');
      Navigator.pop(context, true); // ask previous page to refresh
    } on ApiException catch (e) {
      if (!mounted) return;
      _toast(e.message);
    } catch (e) {
      if (!mounted) return;
      _toast('Unexpected error: $e');
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  // ===== UI =====

  @override
  Widget build(BuildContext context) {
    final w = widget.item;

    return Scaffold(
      appBar: AppBar(title: const Text('Process Withdrawal')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SummaryCard(w: w, fmtAmount: (v) => '₹ ${_fmtNumber(v)}'),
            const SizedBox(height: 16),

            // Status (fixed visual)
            Row(
              children: [
                ChoiceChip(
                  selected: true,
                  label: const Text('Paid'),
                  onSelected: (_) {},
                  selectedColor: Colors.green.shade100,
                ),
              ],
            ),
            const SizedBox(height: 16),

            if (_balance <= 0) ...[
              // Quick banner if zero balance
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  border: Border.all(color: Colors.orange.shade200),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'This agent has zero balance. Processing is disabled.',
                  style: TextStyle(color: Colors.orange),
                ),
              ),
            ],

            // Withdraw Amount (must be 1..balance)
            _LabeledField(
              label: 'Withdraw Amount * (1 - ₹ ${_fmtNumber(_balance)})',
              child: TextField(
                controller: _withdrawAmountCtrl,
                keyboardType: TextInputType.number,
                onChanged: (_) => _validateAmount(),
                decoration: _decoration().copyWith(errorText: _amountError),
                enabled: _balance > 0, // disable if zero balance
              ),
            ),
            const SizedBox(height: 12),

            // Total Amount (read-only; equals current balance)
            _LabeledField(
              label: 'Total Amount *',
              child: TextField(
                controller: _totalAmountCtrl,
                readOnly: true,
                enabled: false,
                decoration: _decoration().copyWith(
                  hintText: 'Total equals current balance',
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Reference number
            _LabeledField(
              label: 'Reference Number *',
              child: TextField(
                controller: _refNoCtrl,
                decoration: _decoration(),
                enabled: _balance > 0,
              ),
            ),
            const SizedBox(height: 12),

            // Payment date
            _LabeledField(
              label: 'Payment Date *',
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _paymentDateCtrl,
                      readOnly: true,
                      decoration: _decoration().copyWith(
                        hintText: 'yyyy-MM-dd',
                      ),
                      enabled: _balance > 0,
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _balance > 0 ? _pickDate : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Pick'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Payment mode
            _LabeledField(
              label: 'Payment Mode *',
              child: DropdownButtonFormField<String>(
                value: _mode,
                items: const [
                  DropdownMenuItem(value: 'Upi', child: Text('UPI')),
                  DropdownMenuItem(value: 'NEFT', child: Text('NEFT')),
                  DropdownMenuItem(value: 'IMPS', child: Text('IMPS')),
                  DropdownMenuItem(value: 'Cash', child: Text('Cash')),
                  DropdownMenuItem(value: 'Other', child: Text('Other')),
                ],
                onChanged: _balance > 0
                    ? (v) => setState(() => _mode = v ?? 'Upi')
                    : null,
                decoration: _decoration(),
              ),
            ),

            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: (_submitting || !_isFormValid) ? null : _submit,
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
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.w, required this.fmtAmount});

  final WithdrawlBalanceItem w;
  final String Function(double) fmtAmount;

  @override
  Widget build(BuildContext context) {
    return Container(
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
          _kv('Bank Name', w.bankName),
          _kv('Account No', w.accountNumber),
          _kv('Ifsc Code', w.ifscCode),
          _kv('Account Holder Name', w.accountHolderName),
          _kv('Current Balance', fmtAmount(w.balanceAmount)),
          const SizedBox(height: 6),
          const Divider(height: 24),
          const Text(
            'Update Status',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
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
}

/// Simple labeled field wrapper
class _LabeledField extends StatelessWidget {
  const _LabeledField({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [Text(label), const SizedBox(height: 6), child],
    );
  }
}
