import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:planet_app/screens/favorite_screen/favorite_screen.dart';
import 'screens/admin page/admin_page.dart';
import 'screens/home_page/home_page.dart';
import 'screens/settings_screen/compo/settings_screen.dart';

class ControllerPage extends StatefulWidget {
  @override
  _ControllerPageState createState() => _ControllerPageState();
}

class _ControllerPageState extends State<ControllerPage> {
  int _currentIndex = 0;
  final List<Widget> pages = [
    HomePage(),
    FavoriteScreen(),
  ];
  void onTaped(int index){
    setState(() {
      _currentIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      drawer: buildDrawer(),
      body: pages[_currentIndex],
      bottomNavigationBar: buildNavbar(),
    );
  }

  Drawer buildDrawer(){
    return Drawer(
      child: Column(
        children: [
          AppBar(title:Text('Nabatati'),automaticallyImplyLeading: false,),
          Divider(),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home Page'),
            onTap: () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx)=>ControllerPage())),
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

  BottomNavigationBar buildNavbar() {
    return BottomNavigationBar(
        onTap:onTaped ,
        currentIndex: _currentIndex,
        elevation: 3,
        items: [
           BottomNavigationBarItem(
              // icon: SvgPicture.asset('assets/icons/heart-icon.svg'),
              // activeIcon: Text(
              //   'Favorite',
              //   textAlign: TextAlign.center,
              //   style: TextStyle(
              //       fontWeight: FontWeight.bold, color: kPrimaryColor),
              // ),
              label: 'Home Page',
              icon: Icon(Icons.home)
            ),
          BottomNavigationBarItem(
            label: 'My Plants',
            icon: Icon(Icons.favorite),
            // activeIcon: Text(
            //   'Home',
            //   textAlign: TextAlign.center,
            //   style:
            //       TextStyle(fontWeight: FontWeight.bold, color: kPrimaryColor),
            // ),
          ),
         
        ]);
  }
}
