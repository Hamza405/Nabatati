import 'package:flutter/material.dart';
import 'package:planet_app/screens/admin%20page/admin_page.dart';
import 'package:planet_app/widget/drawer.dart';

import '../../../controle_page.dart';
import 'Settings_screen_body.dart';
import 'header_settings_screen.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
     Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: buildAppBar(),
      drawer: MyDrawer(),
      body:Column(
        children: [
          HeaderSettingsScreen(size),
          SettingsScreenBody(size)
        ],
      )
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