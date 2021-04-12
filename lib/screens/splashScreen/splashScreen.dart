import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(child:Container(width: size.width*0.5,height:size.height*0.7 ,child: Image.asset('assets/images/splashScreen.png'))),
      
    );
  }
}