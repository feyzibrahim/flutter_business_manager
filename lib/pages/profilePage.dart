import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:business_manager/services/commen.dart';
import 'package:business_manager/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:business_manager/services/auth.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool readOnly = true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('User')
              .doc(AuthService().getUid())
              .snapshots(),
          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 20.0),
                    Text("Loading"),
                  ],
                ),
              );
            }

            String loc = snapshot.data.data()['location'];
            String about = snapshot.data.data()['about'];
            String phoneNumber = snapshot.data.data()['phone'];

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'My Profile',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 24.0,
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Column(
                      children: [
                        CircleAvatar(
                          radius: 40.0,
                          backgroundColor: Colors.grey[800],
                          child: Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 50.0,
                          ),
                        ),
                        SizedBox(height: 20.0),
                        Text('${snapshot.data.data()['name']}'),
                      ],
                    ),
                    SizedBox(height: 40.0),
                    Container(
                      decoration: AdaptiveTheme.of(context).mode.isDark
                          ? CommenService().roundedCornerForDark(Colors.black)
                          : CommenService().roundedCorner(Colors.white),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                readOnly: true,
                                initialValue: snapshot.data.data()['email'],
                                decoration: InputDecoration(
                                  icon: Icon(Icons.email),
                                  labelText: 'Email',
                                  border: InputBorder.none,
                                ),
                              ),
                              TextFormField(
                                readOnly: readOnly,
                                initialValue: phoneNumber,
                                decoration: InputDecoration(
                                  icon: Icon(Icons.phone),
                                  labelText: 'Phone Number',
                                  border: InputBorder.none,
                                ),
                                keyboardType: TextInputType.phone,
                                onChanged: (value) => phoneNumber = value,
                              ),
                              TextFormField(
                                readOnly: readOnly,
                                initialValue: loc,
                                decoration: InputDecoration(
                                  icon: Icon(Icons.location_city),
                                  labelText: 'Location',
                                  border: InputBorder.none,
                                ),
                                onChanged: (value) => loc = value,
                              ),
                              TextFormField(
                                readOnly: readOnly,
                                initialValue: about,
                                decoration: InputDecoration(
                                  icon: Icon(Icons.info),
                                  labelText: 'About',
                                  border: InputBorder.none,
                                ),
                                onChanged: (value) => about = value,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    readOnly
                        ? Container()
                        : Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Container(
                              decoration: AdaptiveTheme.of(context).mode.isDark
                                  ? CommenService()
                                      .roundedCornerNoShadow(Colors.grey[900])
                                  : CommenService().roundedCorner(Colors.white),
                              child: FlatButton.icon(
                                onPressed: () {
                                  var form = _formKey.currentState;
                                  if (form.validate()) {
                                    DatabaseService()
                                        .updateProfileDetails(
                                            phoneNumber, loc, about)
                                        .then((value) {
                                      setState(() {
                                        readOnly = true;
                                      });
                                    });
                                  }
                                },
                                icon: Icon(Icons.save),
                                label: Text('Save'),
                              ),
                            ),
                          ),
                  ],
                ),
              ),
            );
          }),
      floatingActionButton: readOnly
          ? FloatingActionButton(
              onPressed: () {
                setState(() {
                  readOnly = false;
                });
              },
              child: Icon(Icons.edit),
            )
          : Container(),
    );
  }
}
