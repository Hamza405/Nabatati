import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:planet_app/provider/planet_provider.dart';
import 'package:provider/provider.dart';
import '../../../constants.dart';

class ImageAndIcons extends StatelessWidget {
  final String keyy,id;
  final Size size;
  final int index;
  ImageAndIcons({this.keyy,this.size,this.id,this.index,});
  @override
  Widget build(BuildContext context) {
    var s=Scaffold.of(context);
   var plantItem ;
    if(keyy=='i'){
      plantItem =Provider.of<PlantProvider>(context,listen:false).indoorfindById(id);
    } else if(keyy=='o'){
      plantItem =Provider.of<PlantProvider>(context,listen:false).outdoorfindById(id);
    } else {
      plantItem =Provider.of<PlantProvider>(context,listen:false).favoriteItemsfindById(id);
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: kDefaultPadding * 3),
      child: SizedBox(
        height: size.height * 0.6,
        child: Stack(
                 
            children: <Widget>[
              
              Container(
                  height: size.height * 0.6,
                  width: size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(63),
                      bottomLeft: Radius.circular(63),
                    ),
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0, 10),
                        blurRadius: 60,
                        color: kPrimaryColor.withOpacity(0.29),
                      ),
                    ],
                    image: DecorationImage(
                      alignment: Alignment.centerLeft,
                      fit: BoxFit.fill,
                      image: NetworkImage(plantItem.imageUrl),
                    ),
                  ),
                
              ),
              Padding(
                padding: const EdgeInsets.only(top:25),
                child: Align(
                          alignment: Alignment.topLeft,
                          child: IconButton(
                            padding:
                                EdgeInsets.symmetric(horizontal: kDefaultPadding),
                            icon: SvgPicture.asset("assets/icons/back_arrow.svg"),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
              ),
              
            ],
          ),
        ),
     
    );
  }
}


// Expanded(
//                 child: Padding(
//                   padding:
//                       const EdgeInsets.symmetric(vertical: kDefaultPadding * 3),
//                   child: Column(
//                     children: <Widget>[
//                       Align(
//                         alignment: Alignment.topLeft,
//                         child: IconButton(
//                           padding:
//                               EdgeInsets.symmetric(horizontal: kDefaultPadding),
//                           icon: SvgPicture.asset("assets/icons/back_arrow.svg"),
//                           onPressed: () {
//                             Navigator.pop(context);
//                           },
//                         ),
//                       ),
//                       // Spacer(),
//                       // IconCard(icon: "assets/icons/sun.svg"),
//                       // IconCard(icon: "assets/icons/icon_2.svg"),
//                       // IconCard(icon: "assets/icons/icon_3.svg"),
//                       // IconCard(icon: "assets/icons/icon_4.svg"),
//                     ],
//                   ),
//                 ),
//               ),