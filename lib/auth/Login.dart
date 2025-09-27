// lib/auth/Login.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:new_project/adminpages/DashboardPage.dart';
import 'package:new_project/adminpages/Forgotpassword.dart';
import 'package:new_project/agentpages/mainpage.dart';
import 'package:new_project/utils/ApiConstants.dart';

class Loginpage extends StatelessWidget {
  const Loginpage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: LoginBody());
  }
}

class LoginBody extends StatefulWidget {
  const LoginBody({super.key});

  @override
  State<LoginBody> createState() => _LoginBodyState();
}

class _LoginBodyState extends State<LoginBody> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _obscurePassword = true;
  String _message = '';
  bool _loading = false;

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return "Please enter an email address.";
    final re = RegExp(r'^[\w\.-]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!re.hasMatch(value)) return "Please enter a valid email address.";
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return "Please enter a password.";
    if (value.length < 8) return "Password must be atleast 8 characters long.";
    return null;
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    setState(() {
      _message = '';
      _loading = true;
    });

    try {
      final uri = Uri.parse("${Constants.ipBaseUrl}/public/login");
      final response = await http.post(
        uri,
        headers: const {"Accept": "application/json", "Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );

      debugPrint("Status Code: ${response.statusCode}");
      debugPrint("Body: ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        if ((data["status"] ?? "").toString().toLowerCase() == "success") {
          final loginData = Map<String, dynamic>.from(data["loginData"] ?? {});
          await _Prefs.saveLoginData(loginData);

          final role = (loginData["role"] ?? "").toString().toUpperCase();
          debugPrint("Role: $role");
          debugPrint("Email: ${loginData['email']}");
          debugPrint("Token: ${loginData['token']}");
          debugPrint("agentId: ${loginData['agentId']}");

          if (!mounted) return;
          if (role == "ADMIN" || role == "DIRECTOR") {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const Dashboardpage()));
          } else if (role == "AGENT") {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const Agentdashboardmainpage()));
          } else {
            setState(() => _message = "Unknown role!");
          }
        } else {
          setState(() => _message = (data["message"] ?? "Login failed!").toString());
        }
      } else {
        setState(() => _message = "Error: ${response.statusCode}");
      }
    } catch (e) {
      setState(() => _message = "Something went wrong: $e");
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Column(
            children: [
              const SizedBox(height: 60.0),
              const Text("Welcome to", style: TextStyle(color: Colors.green, fontSize: 20)),
              const Text(
                "Sri Vayutej\nDevelopers",
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green, fontSize: 40),
              ),
              const Text("your partner in buiding a greener future",
                  style: TextStyle(color: Colors.green, fontSize: 20)),
              const SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey, width: 1),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 10.0),
                          SizedBox(
                            height: 60,
                            child: Image.asset('lib/icons/bank.png', color: Colors.grey),
                          ),
                          const SizedBox(height: 15.0),
                          const Text("Login",
                              style: TextStyle(color: Colors.black, fontSize: 25, fontWeight: FontWeight.bold)),
                          const Text("Enter your email below to login ",
                              style: TextStyle(color: Colors.green, fontSize: 20)),
                          const Text("your account", style: TextStyle(color: Colors.green, fontSize: 20)),
                          const SizedBox(height: 10),
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text("Email", style: TextStyle(fontSize: 16.0)),
                          ),
                          const SizedBox(height: 6.0),
                          TextFormField(
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            validator: validateEmail,
                            controller: emailController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                              hintText: "m@example.com",
                              hintStyle: TextStyle(color: Colors.green, fontSize: 16),
                              contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Password", style: TextStyle(fontSize: 16.0)),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (_) => const Forgotpasswod()),
                                  );
                                },
                                child: const Text("Forgot Password?",
                                    style: TextStyle(fontSize: 16.0, color: Colors.green)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6.0),
                          TextFormField(
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            validator: validatePassword,
                            controller: passwordController,
                            obscureText: _obscurePassword,
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility,
                                    color: Colors.green),
                                onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                              ),
                              border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                              contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                padding: const EdgeInsets.symmetric(vertical: 14),
                              ),
                              onPressed: _loading ? null : _login,
                              child: _loading
                                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                                  : const Text("Login"),
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          if (_message.isNotEmpty) Text(_message, style: const TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Prefs {
  static Future<void> saveLoginData(Map<String, dynamic> loginData) async {
    final prefs = await SharedPreferences.getInstance();

    final role = loginData["role"] as String?;
    final id = _asInt(loginData["id"]);
    final agentId = _asInt(loginData["agentId"]);
    final email = loginData["email"] as String?;
    final username = loginData["username"] as String?;
    final token = loginData["token"] as String?;

    if (role != null) await prefs.setString("role", role);
    if (id != null) await prefs.setInt("id", id);
    if (agentId != null) await prefs.setInt("agentId", agentId);
    if (email != null) await prefs.setString("email", email);
    if (username != null) await prefs.setString("username", username);
    if (token != null) await prefs.setString("token", token);

    // store whole object too (handy for future)
    await prefs.setString('login_data', jsonEncode(loginData));
  }

  static int? _asInt(dynamic v) {
    if (v == null) return null;
    if (v is int) return v;
    if (v is num) return v.toInt();
    if (v is String) return int.tryParse(v);
    return null;
  }

  /// Returns agentId if saved; otherwise falls back to optId (if present).
  static Future<int?> getAgentId() async {
    final prefs = await SharedPreferences.getInstance();
    final a = prefs.getInt("agentId");
    if (a != null) return a;
    return prefs.getInt("optId");
  }
}
