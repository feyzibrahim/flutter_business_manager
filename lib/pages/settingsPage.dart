import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool isDark = false;
  bool isCashInAndOut = false;

  @override
  void initState() {
    loadCashInOut();
    if (AdaptiveTheme.of(context).mode.isDark) {
      isDark = true;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
        ),
      ),
      body: Column(
        children: [
          ListTile(
            leading: Icon(Icons.brightness_2),
            title: Text('Theme'),
            subtitle: Text('Dark'),
            trailing: Switch(
              onChanged: (value) {
                AdaptiveTheme.of(context).toggleThemeMode();
                setState(() {
                  isDark = !isDark;
                });
              },
              value: isDark,
            ),
          ),
          ListTile(
            leading: Icon(Icons.credit_card),
            title: Text('Change to '),
            subtitle: Text('Cash in & Cash Out'),
            trailing: Switch(
              onChanged: (value) async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                setState(() {
                  prefs.setBool('isCashInOut', !isCashInAndOut);
                  isCashInAndOut = !isCashInAndOut;
                });
              },
              value: isCashInAndOut,
            ),
          )
        ],
      ),
    );
  }

  void loadCashInOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isCashInAndOut = prefs.getBool('isCashInOut') ?? false;
    });
  }
}
