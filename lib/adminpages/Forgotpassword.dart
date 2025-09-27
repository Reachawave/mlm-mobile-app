import 'package:flutter/material.dart';
import 'package:new_project/auth/Login.dart';

class Forgotpasswod extends StatelessWidget {
  const Forgotpasswod({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: ForgotpasswodBody());
  }
}

class ForgotpasswodBody extends StatefulWidget {
  const ForgotpasswodBody({super.key});

  @override
  State<ForgotpasswodBody> createState() => _ForgotpasswodBodyState();
}

class _ForgotpasswodBodyState extends State<ForgotpasswodBody> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
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
                  mainAxisAlignment: MainAxisAlignment.center,
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
                      "Forgot password",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Enter your email and we'll send you a ",
                      style: TextStyle(color: Colors.green, fontSize: 18),
                    ),
                    Text(
                      "link to reset your password",
                      style: TextStyle(color: Colors.green, fontSize: 18),
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

                        SizedBox(height: 20.0),
                        SizedBox(
                          width: double.infinity, // take full available width
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Colors.green, // 👈 button background color
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
                            child: const Text("Send Reset Link"),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 20,
                          child: Image.asset(
                            'lib/icons/back-arrow.png',
                            color: Colors.green,
                          ),
                        ),
                        SizedBox(width: 5.0),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Loginpage(),
                              ),
                            );
                          },
                          child: Text(
                            "Back to login",
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.green,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.0),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
