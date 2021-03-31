import 'package:flutter/material.dart';
import 'package:planet_app/screens/admin%20page/admin_page.dart';

import '../../../controle_page.dart';
import 'Settings_screen_body.dart';
import 'header_settings_screen.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
     Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: buildAppBar(),
      drawer: buildDrawer(context),
      body:Column(
        children: [
          HeaderSettingsScreen(size),
          SettingsScreenBody(size)
        ],
      )
    );
  }

  
  Drawer buildDrawer(BuildContext context) {
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
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx)=>SettingsScreen()));
            },
          ),
          Divider(),
        ],
      ),
    );
  }



  AppBar buildAppBar() {
    return AppBar(
      elevation: 0,
      // leading: IconButton(
      //   icon: SvgPicture.asset("assets/icons/menu.svg"),
      //   onPressed: buildDrawer,
      // ),
    );
  }
}