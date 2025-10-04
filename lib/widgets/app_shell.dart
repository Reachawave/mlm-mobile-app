// widgets/app_shell.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:new_project/widgets/app_drawer.dart';
import 'package:new_project/auth/Login.dart';

class AppShell extends StatelessWidget {
  final String title;
  final Widget body;
  final List<Widget>? actions; // add your extra actions if needed
  final bool showDrawer;

  const AppShell({
    super.key,
    required this.title,
    required this.body,
    this.actions,
    this.showDrawer = true,
  });

  Future<void> _confirmAndLogout(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Confirm Logout"),
        content: const Text("Are you sure you want to log out?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: const Text("Logout"),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      if (!context.mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const Loginpage()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: showDrawer ? const AppDrawer() : null,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: showDrawer
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black12, width: 1),
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Builder(
                    builder: (context) => IconButton(
                      icon: const Icon(Icons.menu),
                      onPressed: () => Scaffold.of(context).openDrawer(),
                    ),
                  ),
                ),
              )
            : null,
        title: Text(title, style: const TextStyle(color: Colors.black)),
        centerTitle: false,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          const SizedBox(width: 10),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () => _confirmAndLogout(context),
              child: SizedBox(
                height: 30,
                child: Image.asset('lib/icons/user.png'),
              ),
            ),
          ),
          ...?actions,
        ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: Colors.black12),
        ),
      ),
      body: body,
    );
  }
}
