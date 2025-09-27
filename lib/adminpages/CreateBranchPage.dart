import 'package:flutter/material.dart';
import 'package:new_project/utils/AuthApi.dart';


class CreateBranchPage extends StatefulWidget {
  const CreateBranchPage({super.key, required this.api});

  final AuthApi api;

  @override
  State<CreateBranchPage> createState() => _CreateBranchPageState();
}

class _CreateBranchPageState extends State<CreateBranchPage> {
  final _formKey = GlobalKey<FormState>();
  final _branchNameCtrl = TextEditingController();
  final _locationCtrl = TextEditingController();
  bool _submitting = false;

  @override
  void dispose() {
    _branchNameCtrl.dispose();
    _locationCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _submitting = true);
    try {
      final resp = await widget.api.createBranch(
        branchName: _branchNameCtrl.text.trim(),
        location: _locationCtrl.text.trim(),
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text((resp.message ?? 'Branch created successfully').toString())),
      );
      Navigator.of(context).pop(true);
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Failed to create branch')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Something went wrong: $e')),
      );
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Branch')),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text('Branch Name'),
              const SizedBox(height: 6),
              TextFormField(
                controller: _branchNameCtrl,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  hintText: 'e.g., Hyderabad Main',
                  border: OutlineInputBorder(),
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Branch name is required';
                  if (v.trim().length < 3) return 'Must be at least 3 characters';
                  return null;
                },
              ),
              const SizedBox(height: 12),

              const Text('Location'),
              const SizedBox(height: 6),
              TextFormField(
                controller: _locationCtrl,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(
                  hintText: 'e.g., Ameerpet',
                  border: OutlineInputBorder(),
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Location is required';
                  return null;
                },
                onFieldSubmitted: (_) => _submit(),
              ),
              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitting ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: _submitting
                      ? const SizedBox(
                    width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2),
                  )
                      : const Text('Create Branch'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
