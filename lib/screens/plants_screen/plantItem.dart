import 'package:flutter/material.dart';
import 'package:planet_app/screens/details_screen/details_screen.dart';

import '../../constants.dart';
class PlantItem extends StatelessWidget {
  final int index;
  final String name,description,imageUrl,id;
  final Size size;
  final String keey;
  PlantItem({this.name, this.description, this.imageUrl,this.size,this.keey,this.id,this.index});
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius:BorderRadius.circular(10),
          child: GestureDetector(
            onTap: (){
              Navigator.of(context).push(
                MaterialPageRoute(builder: (ctx)=>DetailsScreen(
                  id: id,
                  keyy:keey,
                ))
              );
              
            },
                      child: Container(
        height: 200,
        width: 200,
        child: GridTile(
          
            child:FadeInImage(
            placeholder: AssetImage('assets/icons/loading.gif'),
            image: NetworkImage(imageUrl),
            fit: BoxFit.cover,
          ),
            footer: GridTileBar(
              
                title: Text(
                  name,
                  textAlign: TextAlign.center,
                ),
                backgroundColor: kPrimaryColor.withOpacity(0.5),
              ), 
        )
      ),
          ),
    );
         
    
 
}

}