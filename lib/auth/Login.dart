import 'package:flutter/material.dart';
import 'package:new_project/adminpages/DashboardPage.dart';
import 'package:new_project/adminpages/Forgotpassword.dart';
import 'package:new_project/utils/ApiConstants.dart';

import '../agentpages/mainpage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


class Loginpage extends StatelessWidget {
  const Loginpage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: LoginBody());
  }
}

class LoginBody extends StatefulWidget {
  const LoginBody({super.key});

  @override
  State<LoginBody> createState() => _LoginBodyState();
}

class _LoginBodyState extends State<LoginBody> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter an email address.";
    }
    RegExp emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegExp.hasMatch(value)) {
      return "Please enter a valid email address.";
    }
    return null;
  }

  String? validatePassword(String? Passvalue) {
    if (Passvalue == null || Passvalue.isEmpty) {
      return "Please enter a password.";
    }
    if (Passvalue.length < 8) {
      return "Password must be atleast 8 characters long.";
    }
    return null;
  }

  // void submitForm() {
  //   if (_formKey.currentState!.validate()) {
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(builder: (context) => Agentdashboardmainpage()),
  //     );
  //   }
  // }

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String _message = '';


  Future<void> _login() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        _message = "Please enter email and password!";
      });
      return;
    }

    try {
      final response = await http.post(

        Uri.parse("${Constants.ipBaseUrl}public/login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
          "password": password,
        }),
      );

      // 👇 Print raw response
      print("Status Code: ${response.statusCode}");
      print("Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data["status"] == "success") {
          String role = data["loginData"]["role"];



          debugPrint("✅ Login Success");
          debugPrint("Role: $role");
          debugPrint("Email: ${data['loginData']['email']}");
          debugPrint("Token: ${data['loginData']['token']}");

          if (role == "ADMIN") {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const Dashboardpage()),
            );
          } else if (role == "DIRECTOR") {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const Agentdashboardmainpage()),
            );
          } else if (role == "AGENT") {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const Agentdashboardmainpage()),
            );
          } else {
            setState(() {
              _message = "Unknown role!";
            });
          }
        } else {
          setState(() {
            _message = "Login failed!";
          });
        }
      } else {
        setState(() {
          _message = "Error: ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        _message = "Something went wrong: $e";
      });
    }
  }


  // void _login() {
  //   String username = emailController.text.trim();
  //   String password = passwordController.text.trim();
  //
  //   if (username == "admin" && password == "123") {
  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(builder: (context) => const Dashboardpage()),
  //     );
  //   } else if (username == "director" && password == "123") {
  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(builder: (context) => const Dashboardpage()),
  //     );
  //   } else if (username == "agent" && password == "123") {
  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(builder: (context) => const Agentdashboardmainpage()),
  //     );
  //   } else {
  //     setState(() {
  //       _message = "Invalid username or password!";
  //     });
  //   }
  // }

  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Container(
            width: double.infinity,
            child: Column(
              children: [
                SizedBox(height: 60.0),
                Text(
                  "Welcome to",
                  style: TextStyle(color: Colors.green, fontSize: 20),
                ),
                Text(
                  "Sri Vayutej\nDevelopers",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                    fontSize: 40,
                  ),
                ),
                Text(
                  "your partner in buiding a greener future",
                  style: TextStyle(color: Colors.green, fontSize: 20),
                ),
                SizedBox(height: 20.0),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white, // 👈 color inside decoration
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.grey, // 👈 border color
                        width: 1, // 👈 border thickness
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 10.0),
                          Container(
                            height: 60,
                            child: Image.asset(
                              'lib/icons/bank.png',
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(height: 15.0),
                          Text(
                            "Login",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Enter your email below to login ",
                            style: TextStyle(color: Colors.green, fontSize: 20),
                          ),
                          Text(
                            "your account",
                            style: TextStyle(color: Colors.green, fontSize: 20),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 10),
                              Text("Email", style: TextStyle(fontSize: 16.0)),
                              SizedBox(height: 6.0),
                              TextFormField(
                                autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                                validator: validateEmail,
                                controller: emailController,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(
                                        5,
                                      ), // 👈 rectangle with rounded corners
                                    ),
                                  ),
                                  hintText: "m@example.com",
                                  hintStyle: TextStyle(
                                    color: Colors.green,
                                    fontSize: 16,
                                  ),

                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10, // 👈 height of TextField
                                    horizontal: 20,
                                  ),
                                ),
                              ),

                              SizedBox(height: 16.0),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Password",
                                    style: TextStyle(fontSize: 16.0),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Forgotpasswod(),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      "Forgot Password?",
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 6.0),
                              TextFormField(
                                autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                                validator: validatePassword,
                                controller: passwordController,
                                obscureText:
                                _obscurePassword, // 👈 use the state variable
                                decoration: InputDecoration(
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscurePassword
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: Colors.green,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _obscurePassword =
                                        !_obscurePassword; // toggle visibility
                                      });
                                    },
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(
                                        5,
                                      ), // 👈 rectangle with rounded corners
                                    ),
                                  ),

                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                    horizontal: 20,
                                  ),
                                ),
                              ),
                              SizedBox(height: 20.0),
                              SizedBox(
                                width: double
                                    .infinity, // take full available width
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors
                                        .green, // 👈 button background color
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                        5,
                                      ), // 👈 border radius
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ), // taller button
                                  ),
                                  onPressed: () {
                                    _login();
                                  },
                                  child: const Text("Login"),
                                ),
                              ),
                              SizedBox(height: 10.0),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DirectorDashboard extends StatelessWidget {
  const DirectorDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Director Dashboard")),
      body: const Center(
        child: Text("Welcome, Director!", style: TextStyle(fontSize: 22)),
      ),
    );
  }
}
