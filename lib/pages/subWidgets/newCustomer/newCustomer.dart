import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:business_manager/services/commen.dart';
import 'package:business_manager/services/database.dart';
import 'package:contact_picker/contact_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class NewCustomer extends StatefulWidget {
  @override
  _NewCustomerState createState() => _NewCustomerState();
}

class _NewCustomerState extends State<NewCustomer> {
  TextEditingController _controller = TextEditingController();
  TextEditingController _controllerB = TextEditingController();
  final ContactPicker _contactPicker = new ContactPicker();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding:
            EdgeInsets.only(left: 20.0, right: 20.0, top: 80.0, bottom: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(
              Icons.person,
              size: 80.0,
            ),
            TextField(
              controller: _controller,
              decoration: InputDecoration(hintText: 'Customer Name'),
              textCapitalization: TextCapitalization.words,
            ),
            TextField(
              controller: _controllerB,
              decoration: InputDecoration(hintText: 'Phone No'),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 20.0),
            Container(
              decoration: AdaptiveTheme.of(context).mode.isDark
                  ? CommenService().roundedCornerNoShadow(Colors.grey[900])
                  : CommenService().roundedCorner(Colors.white),
              child: isLoading
                  ? Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: SpinKitThreeBounce(
                        color: Colors.blue,
                        size: 25.0,
                      ),
                    )
                  : FlatButton.icon(
                      icon: Icon(Icons.save),
                      padding: EdgeInsets.all(15.0),
                      onPressed: () {
                        if (_controller.text.isNotEmpty &&
                            _controllerB.text.isNotEmpty) {
                          setState(() {
                            isLoading = true;
                          });
                          DatabaseService()
                              .createCustomer(
                                  _controller.text, _controllerB.text)
                              .then((_) => Navigator.pop(context));
                        }
                      },
                      label: Text('Save'),
                    ),
            ),
            SizedBox(height: 10.0),
            Container(
              decoration: AdaptiveTheme.of(context).mode.isDark
                  ? CommenService().roundedCornerNoShadow(Colors.grey[900])
                  : CommenService().roundedCorner(Colors.white),
              child: FlatButton(
                padding: EdgeInsets.all(20.0),
                child: Text('Choose a Contact from device'),
                onPressed: () {
                  requestPermission();
                },
              ),
            ),
            Expanded(child: Container()),
            Center(child: Text('Swipe Down to go back')),
            SizedBox(height: 5.0),
            Center(child: Icon(Icons.keyboard_arrow_down)),
          ],
        ),
      ),
    );
  }

  void requestPermission() async {
    var result = await Permission.contacts.request();
    if (result == PermissionStatus.granted) {
      Contact contact = await _contactPicker.selectContact();
      if (contact != null) {
        setState(() {
          _controller.text = contact.fullName;
          _controllerB.text = contact.phoneNumber.number
              .toString()
              .replaceAll(new RegExp("[-() ]"), '');
        });
      }
    }
  }
}
