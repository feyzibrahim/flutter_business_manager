import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:business_manager/home.dart';
import 'package:business_manager/services/auth.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:business_manager/services/commen.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String email;
  String password;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 28.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    'Please sign in to continue',
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
                            labelText: 'Email',
                            icon: Icon(Icons.email),
                          ),
                          onChanged: (text) => email = text,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value.isEmpty) {
                              loader(false);
                              return 'Enter Email';
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
                          obscureText: true,
                          onChanged: (text) => password = text,
                          validator: (value) {
                            if (value.isEmpty) {
                              loader(false);
                              return 'Enter Password';
                            }
                            if (value.length < 6) {
                              loader(false);
                              return 'Password must be 6 digits or more';
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
                                    vertical: 15.0, horizontal: 19.0),
                                child: SpinKitThreeBounce(
                                  color: Colors.blue,
                                  size: 25.0,
                                ),
                              )
                            : MaterialButton(
                                onPressed: () {
                                  var form = _formKey.currentState;
                                  if (form.validate()) {
                                    loader(true);
                                    AuthService()
                                        .login(email, password)
                                        .then((value) {
                                      var user = value;
                                      if (user == null) {
                                        loader(false);
                                        CommenService().showSnack(context,
                                            'Please verify your email and password');
                                      } else {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => Home(),
                                          ),
                                        );
                                      }
                                    });
                                  }
                                },
                                padding: EdgeInsets.all(15.0),
                                child: Row(
                                  children: [
                                    Text('Login'),
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
