
import 'package:flutter/material.dart';
import 'package:planet_app/screens/auth%20screen/compo/auth_card.dart';

enum AuthMode { Signup, Login }
class AuthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(10, 255, 10, 1).withOpacity(0.5),
                  Color.fromRGBO(90, 190, 240, 1).withOpacity(0.9),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0, 1],
              ),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              height: deviceSize.height,
              width: deviceSize.width,
              child: Center(child:AuthCard())
            ),
          ),
        ],
      ),
    );
  }
}