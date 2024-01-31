import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:settings_ui/settings_ui.dart';

import 'package:budget_master/constants/constants.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Constants.primaryColor,
      body: SafeArea(
        bottom: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 15.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 35,
                  ),
                  Text(
                    "Settings",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 35.0,
            ),
            Flexible(
              child: Container(
                width: double.infinity,
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height - 180.0,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
                  color: Colors.white,
                ),
                padding: EdgeInsets.all(10.0),
                child: SettingsList(
                  lightTheme:
                      SettingsThemeData(settingsListBackground: Colors.white),
                  sections: [
                    SettingsSection(
                      title: Text('General'),
                      tiles: [
                        SettingsTile(
                          title: Text('Language'),
                          leading: Icon(Icons.language),
                          onPressed: (BuildContext context) {
                            // Add language change logic here
                          },
                        ),
                        SettingsTile.switchTile(
                          title: Text('Use Dark Mode'),
                          leading: Icon(Icons.dark_mode),
                          initialValue: false,
                          onToggle: (bool value) {
                            // Add dark mode toggle logic here
                          },
                        ),
                      ],
                    ),
                    SettingsSection(
                      title: Text('Account'),
                      tiles: [
                        SettingsTile(
                          title: Text('Logout'),
                          leading: Icon(Icons.exit_to_app),
                          onPressed: (BuildContext context) async {
                            await FirebaseAuth.instance.signOut();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
