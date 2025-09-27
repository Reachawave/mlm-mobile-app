// lib/adminpages/CreateVenturePage.dart
import 'package:flutter/material.dart';
import 'package:new_project/utils/AuthApi.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateVenturePage extends StatefulWidget {
  const CreateVenturePage({super.key, required this.api});
  final AuthApi api;

  @override
  State<CreateVenturePage> createState() => _CreateVenturePageState();
}

class _CreateVenturePageState extends State<CreateVenturePage> {
  final _formKey = GlobalKey<FormState>();

  final _ventureName = TextEditingController();
  final _location = TextEditingController();
  final _totalTrees = TextEditingController();
  final _treesSold = TextEditingController(text: '0');

  String? _status = 'Active';
  final _statuses = const ["Active", "Upcoming", "Ongoing", "Completed"];

  bool _loading = false;

  OutlineInputBorder get _gb => const OutlineInputBorder();
  OutlineInputBorder get _fb => const OutlineInputBorder(
    borderSide: BorderSide(color: Colors.green, width: 2.0),
  );

  @override
  void dispose() {
    _ventureName
      ..text = ''
      ..dispose();
    _location
      ..text = ''
      ..dispose();
    _totalTrees
      ..text = ''
      ..dispose();
    _treesSold.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    final total = int.tryParse(_totalTrees.text.trim()) ?? 0;
    final sold = int.tryParse(_treesSold.text.trim()) ?? 0;
    if (sold > total) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Trees sold cannot exceed total trees')),
      );
      return;
    }

    setState(() => _loading = true);
    try {
      // Get saved token and set it on the API
      final sp = await SharedPreferences.getInstance();
      final token = sp.getString('auth_token') ?? sp.getString('token') ?? '';
      if (token.isEmpty) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('You are not logged in')),
        );
        return;
      }
      widget.api.setAuthToken(token);

      final resp = await widget.api.createVentureMobile(
        ventureName: _ventureName.text.trim(),
        location: _location.text.trim(),
        status: _status!, // "Active" | "Upcoming" | ...
        totalTrees: total,
        treesSold: sold,
      );

      if (!mounted) return;
      if (resp.isSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(resp.message.isNotEmpty ? resp.message : 'Venture created')),
        );
        Navigator.pop(context, true); // return to previous screen
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(resp.message.isNotEmpty ? resp.message : 'Failed to create venture')),
        );
      }
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Unexpected error: $e')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create Venture")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text("Venture Name"),
            const SizedBox(height: 6),
            _text(
              _ventureName,
              hint: "e.g., Green Valley",
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
            ),

            const SizedBox(height: 10),
            const Text("Location"),
            const SizedBox(height: 6),
            _text(
              _location,
              hint: "e.g., Hyderabad",
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
            ),

            const SizedBox(height: 10),
            const Text("Status"),
            const SizedBox(height: 6),
            DropdownButtonFormField<String>(
              value: _status,
              items: _statuses
                  .map((s) => DropdownMenuItem(value: s, child: Text(s, style: const TextStyle(fontSize: 14))))
                  .toList(),
              onChanged: (v) => setState(() => _status = v),
              decoration: InputDecoration(
                border: _gb,
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 1.5),
                ),
                focusedBorder: _fb,
                contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
              ),
              dropdownColor: Colors.white,
              icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
            ),

            const SizedBox(height: 10),
            const Text("Total Trees"),
            const SizedBox(height: 6),
            _text(
              _totalTrees,
              hint: "e.g., 500",
              keyboardType: TextInputType.number,
              validator: (v) {
                final n = int.tryParse((v ?? '').trim());
                if (n == null || n <= 0) return 'Enter a valid number > 0';
                return null;
              },
            ),

            const SizedBox(height: 10),
            const Text("Trees Sold (Initial)"),
            const SizedBox(height: 6),
            _text(
              _treesSold,
              hint: "e.g., 120",
              keyboardType: TextInputType.number,
              validator: (v) {
                final n = int.tryParse((v ?? '').trim());
                if (n == null || n < 0) return 'Enter a valid number ≥ 0';
                return null;
              },
            ),

            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                onPressed: _loading ? null : _submit,
                child: _loading
                    ? const Padding(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: SizedBox(height: 22, width: 22, child: CircularProgressIndicator(strokeWidth: 2)),
                )
                    : const Text("Create Venture"),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Widget _text(
      TextEditingController c, {
        String? hint,
        TextInputType? keyboardType,
        String? Function(String?)? validator,
      }) =>
      TextFormField(
        controller: c,
        keyboardType: keyboardType,
        validator: validator,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.green, fontSize: 16),
          border: _gb,
          focusedBorder: _fb,
          contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        ),
      );
}
