import 'package:flutter/material.dart';

import '../../../constants.dart';

class HeaderAccountScreen extends StatelessWidget {
  final Size size;
  final String nameScreen;
  HeaderAccountScreen(this.nameScreen,this.size);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: kDefaultPadding),
      // It will cover 20% of our total height
      height: size.height * 0.1,
      child: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(
              left: kDefaultPadding,
              right: kDefaultPadding,
              
            ),
            height: size.height * 0.1,
            decoration: BoxDecoration(
              color: kPrimaryColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(100),
                bottomRight: Radius.circular(100),
              ),
            ),
            
            
          ),
           Padding(
                padding: const EdgeInsets.only(top:25,left: 15),
                child: Align(
                          alignment: Alignment.topLeft,
                          child: IconButton(
                            padding:
                                EdgeInsets.symmetric(horizontal: kDefaultPadding),
                            icon: Icon(Icons.arrow_back,color:Colors.white),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
              ),
              Padding(
                padding: const EdgeInsets.only(top:25,),
                child: Align(
                          alignment: Alignment.topCenter,
                          child: Text(nameScreen,style: TextStyle(color: Colors.white,fontSize:25,fontWeight: FontWeight.bold),),
                        ),
              ),
        ],
      ),
    ); 
  }
}