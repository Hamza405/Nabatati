import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../constants.dart';

class HeaderPlants extends StatelessWidget {
  const HeaderPlants({
    Key key,
    @required this.size,
    this.keey
  }) : super(key: key);

  final Size size;
  final String keey;

  @override
  Widget build(BuildContext context) {
    String name;
    if(key=='i'){
      name = 'Indoor Plants';
    } else{
name = 'Outdoor Plants';
    }
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
                          child: Text(name,style: TextStyle(color: Colors.white,fontSize:25,fontWeight: FontWeight.bold),),
                        ),
              ),
        ],
      ),
    );
  }
}