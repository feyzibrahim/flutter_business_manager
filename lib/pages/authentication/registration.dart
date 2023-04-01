import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:business_manager/home.dart';
import 'package:business_manager/services/auth.dart';
import 'package:business_manager/services/commen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String name;
  String email;
  String password;
  String passwordAgain;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Container(
              padding: EdgeInsets.all(30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Registration',
                    style: TextStyle(
                      fontSize: 28.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    'Please create a new account to continue',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Name',
                            icon: Icon(Icons.person),
                          ),
                          textCapitalization: TextCapitalization.words,
                          onChanged: (text) => name = text,
                          keyboardType: TextInputType.name,
                          validator: (value) {
                            loader(false);
                            if (value.isEmpty) {
                              return 'Enter Name';
                            } else {
                              return null;
                            }
                          },
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Email',
                            icon: Icon(Icons.email),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          onChanged: (text) => email = text,
                          validator: (value) {
                            loader(false);
                            if (value.isEmpty) {
                              return 'Enter Email id';
                            } else {
                              return null;
                            }
                          },
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Password',
                            icon: Icon(Icons.lock),
                          ),
                          onChanged: (text) => password = text,
                          obscureText: true,
                          validator: (value) {
                            loader(false);
                            if (value.isEmpty) {
                              return 'Enter password';
                            } else if (value.length < 6) {
                              return 'Password must be 6 or more digits';
                            } else {
                              return null;
                            }
                          },
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Password again',
                            icon: Icon(Icons.lock),
                          ),
                          obscureText: true,
                          onChanged: (text) => passwordAgain = text,
                          validator: (value) {
                            loader(false);
                            if (value.isEmpty) {
                              return 'Enter Password';
                            } else if (value.length < 6) {
                              return 'Password must be 6 or more digits';
                            } else if (value != password) {
                              return 'Password did not match';
                            } else {
                              return null;
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        decoration: AdaptiveTheme.of(context).mode.isDark
                            ? CommenService().roundedCornerForDark(Colors.black)
                            : CommenService().roundedCorner(Colors.white),
                        child: isLoading
                            ? Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 15.0, horizontal: 50.0),
                                child: SpinKitThreeBounce(
                                  color: Colors.blue,
                                  size: 25.0,
                                ),
                              )
                            : MaterialButton(
                                onPressed: () {
                                  var form = _formKey.currentState;
                                  if (form.validate()) {
                                    if (password == passwordAgain) {
                                      loader(true);
                                      AuthService()
                                          .signUp(email, password, name)
                                          .then((value) {
                                        var user = value;
                                        if (user != null) {
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => Home(),
                                            ),
                                          );
                                        } else {
                                          loader(false);
                                          CommenService().showSnack(context,
                                              'Something went wrong please try again');
                                        }
                                      });
                                    }
                                  }
                                },
                                padding: EdgeInsets.all(15.0),
                                child: Row(
                                  children: [
                                    Text('Create Account'),
                                    Icon(Icons.arrow_right_alt_rounded),
                                  ],
                                ),
                              ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void loader(bool load) {
    setState(() {
      isLoading = load;
    });
  }
}
