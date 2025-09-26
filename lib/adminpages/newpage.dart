import 'package:flutter/material.dart';
import 'package:myprojects/adminpages/DashboardPage.dart';

class Signin extends StatefulWidget {
  const Signin({super.key});

  @override
  State<Signin> createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  void _signin() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(
        _formKey.currentContext!,
      ).showSnackBar(const SnackBar(content: Text('Successfully sign in')));
    }
  }

  String? _validateEmail(value) {
    if (value!.isEmpty) {
      return 'please enter your email';
    }
    RegExp emailRegExp = RegExp(
      r"^(?![-.])[a-zA-Z0-9.%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}(?<![-._])$",
    );
    if (!emailRegExp.hasMatch(value)) {
      return 'please enter the valid mail';
    }
    return null;
  }

  String? _validatePassword(value) {
    if (value!.isEmpty) {
      return 'please enter your password';
    }
    RegExp regex = RegExp("^((?=S*?[A-Z])(?=S*?[a-z])(?=S*?[0-9]).{6,})");

    if (!regex.hasMatch(value)) {
      return 'valid password';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 50),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.lightBlueAccent, Colors.lightBlue, Colors.blue],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 50),
              child: Text(
                'Please Signin',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 45,
                  color: Colors.white,
                ),
              ),
            ),

            SizedBox(height: 30),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(
                  top: 50,
                  right: 30,
                  left: 30,
                  bottom: 50,
                ),
                width: MediaQuery.of(context).size.width,

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Email',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 45,
                        color: Colors.blue,
                      ),
                    ),

                    TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(
                        hintText: 'Enter your Email',
                        prefixIcon: Icon(Icons.email_outlined),
                      ),
                      validator: _validateEmail,
                    ),
                    SizedBox(height: 50),
                    Text(
                      'Password',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 45,
                        color: Colors.blue,
                      ),
                    ),
                    TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(
                        hintText: 'Enter your Password',
                        prefixIcon: Icon(Icons.password),
                      ),
                      validator: _validatePassword,
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Dashboardpage(),
                              ),
                            );
                          },
                          child: Text(
                            'Forgot Password?',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Container(
                      key: _formKey,
                      height: 50,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _signin,
                        child: Text('Sign in'),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height / 12),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Dont have an Account?',
                          style: TextStyle(fontSize: 20, color: Colors.grey),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Dashboardpage(),
                              ),
                            );
                          },
                          child: Text(
                            'SignUp',
                            style: TextStyle(fontSize: 20, color: Colors.red),
                          ),
                        ),
                      ],
                    ),
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
