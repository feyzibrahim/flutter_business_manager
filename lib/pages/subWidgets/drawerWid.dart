import 'package:business_manager/pages/profilePage.dart';
import 'package:business_manager/pages/authentication/authentication.dart';
import 'package:business_manager/pages/dailyClassification.dart';
import 'package:business_manager/pages/monthPage.dart';
import 'package:business_manager/pages/settingsPage.dart';
import 'package:business_manager/services/auth.dart';
import 'package:flutter/material.dart';

class DrawerWid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Container(
            padding: EdgeInsets.only(
              top: 15.0,
              left: 15.0,
              bottom: 15.0,
            ),
            child: Row(
              children: [
                Text(
                  'myb - ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
                Text(
                  'Manage ',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16.0,
                  ),
                ),
                Text(
                  'Your Business',
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.receipt),
            title: Text('Today'),
            selected: true,
            // selectedTileColor: Colors.grey[350],
          ),
          ListTile(
            leading: Icon(Icons.calendar_view_day),
            title: Text('Daily'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DailyClassification(),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.view_column),
            title: Text('Monthly'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MonthPage(),
                ),
              );
            },
          ),
          Divider(height: 1.0),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Profile'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfilePage(),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Settings(),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Log out'),
            onTap: () {
              AuthService().signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => Authenticate(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
