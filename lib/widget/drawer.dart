import 'package:flutter/material.dart';
import 'package:planet_app/provider/planet_provider.dart';
import 'package:planet_app/screens/admin%20page/admin_page.dart';
import 'package:planet_app/screens/auth%20screen/auth_screen.dart';
import 'package:planet_app/screens/settings_screen/compo/settings_screen.dart';
import 'package:provider/provider.dart';

import '../controle_page.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<PlantProvider>(context).isAdmin;
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text('Nabatati'),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home Page'),
            onTap: () => Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (ctx) => ControllerPage())),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Admin page'),
            onTap: () => Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (ctx) => AdminPage())),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (ctx) => SettingsScreen()));
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () {
              Navigator.of(context).pop();
              Provider.of<PlantProvider>(context, listen: false).logout();
              Navigator.of(context).pushReplacementNamed('/');
            },
          )
        ],
      ),
    );
  }
}
