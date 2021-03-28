import 'package:flutter/material.dart';
import 'package:planet_app/provider/planet_provider.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import 'compo/image_and_icons.dart';
import 'compo/title_and_price.dart';

class DetailsScreen extends StatelessWidget {
  
  final String id;
   final String keyy;
   final int index;
   final bool fromFavoritePage;
  DetailsScreen({this.keyy,this.id,this.index,this.fromFavoritePage});
  @override
  Widget build(BuildContext context) {
    var plantItem ;
    if(keyy=='i'){
      plantItem =Provider.of<PlantProvider>(context).indoorfindById(id);
    } else if(keyy=='o'){
      plantItem =Provider.of<PlantProvider>(context).outdoorfindById(id);
    } else {
      plantItem =Provider.of<PlantProvider>(context).favoriteItemsfindById(id);
    }
    Size size = MediaQuery.of(context).size;
    return Scaffold(
     
   body:SingleChildScrollView(
      child: Column(
        children: <Widget>[
          ImageAndIcons(size: size,id: id,keyy: keyy,index: index,),
          TitleAndPrice(title: plantItem.name, description: plantItem.description,id:id,keyy: keyy,),
          SizedBox(height: kDefaultPadding),
          // Row(
          //   children: <Widget>[
          //     SizedBox(
          //       width: size.width / 2,
          //       height: 84,
          //       child: FlatButton(
          //         shape: RoundedRectangleBorder(
          //           borderRadius: BorderRadius.only(
          //             topRight: Radius.circular(20),
          //           ),
          //         ),
          //         color: kPrimaryColor,
          //         onPressed: () {},
          //         child: Text(
          //           "Buy Now",
          //           style: TextStyle(
          //             color: Colors.white,
          //             fontSize: 16,
          //           ),
          //         ),
          //       ),
          //     ),
          //     Expanded(
          //       child: FlatButton(
          //         onPressed: () {},
          //         child: Text("Description"),
          //       ),
          //     ),
          //   ],
          // ),
        ],
      ),
   )
      
    );
  }
}