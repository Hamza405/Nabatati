import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:planet_app/provider/planet_provider.dart';
import 'package:planet_app/screens/home_page/compo/header.dart';
import 'package:provider/provider.dart';

import 'hedaer_screen.dart';
import 'plantItem.dart';

class PlantsScreen extends StatelessWidget {
  final String keey;
  PlantsScreen({this.keey});
  @override
  Widget build(BuildContext context) {
    final plants = Provider.of<PlantProvider>(context);
    var plantsData;
    if(keey=='i'){
      plantsData = plants.indoorPlant;
    }else if(keey=='o'){
       plantsData = plants.outdoorPlant;
    }else{
       plantsData = plants.fav;
    }
    
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(right:10,left:10),
          child: Column(
            children: [
              HeaderPlants(size: size,keey: keey,),
              Expanded(child: StaggeredGridView.countBuilder(
                itemCount: plantsData.length,
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                staggeredTileBuilder: (index)=>StaggeredTile.fit(1),
                itemBuilder: (ctx,index)=>PlantItem(
                  size: size,
                   name:plantsData[index].name ,
          description:plantsData[index].description ,
          imageUrl:plantsData[index].imageUrl ,
          id:plantsData[index].id,
          keey: keey

                ),
              )),
            ],
          ),
        ));
  }
 
  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      leading: IconButton(
        icon: SvgPicture.asset("assets/icons/back_arrow.svg"),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }
}

 