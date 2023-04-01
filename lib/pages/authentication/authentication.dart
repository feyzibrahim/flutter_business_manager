import 'package:flutter/material.dart';
import 'package:business_manager/pages/authentication/login.dart';
import 'package:business_manager/pages/authentication/registration.dart';

bool isLogin = true;

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            isLogin ? LoginPage() : RegistrationPage(),
            FlatButton(
              padding: EdgeInsets.all(15.0),
              onPressed: () {
                setState(() {
                  isLogin = !isLogin;
                });
              },
              child: isLogin
                  ? Text('New User? Click Here to Register')
                  : Text('Already a member? Login'),
            ),
          ],
        ),
      ),
    );
  }
}
