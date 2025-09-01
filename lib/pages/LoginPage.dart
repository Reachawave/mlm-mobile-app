import 'package:flutter/material.dart';

import 'Forgotpassword.dart';

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
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
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
                            TextField(
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            TextField(
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
                              width:
                                  double.infinity, // take full available width
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
                                  Navigator.of(context).pop();
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
    );
  }
}
