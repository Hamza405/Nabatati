import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:planet_app/provider/planet_provider.dart';
import 'package:planet_app/screens/favorite_screen/compo/header_favorite_screen.dart';
import 'package:planet_app/screens/plants_screen/plantItem.dart';
import 'package:provider/provider.dart';

class FavoriteScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final plantsData = Provider.of<PlantProvider>(context).fav;
    return Padding(
      padding: const EdgeInsets.only(right:10,left:10),
      child: Column(
            
            children: [
              HeaderFavoriteScreen(size),
              plantsData.isEmpty?Center(child:Text('Your favorite is empty!')) : Expanded(
                  child: StaggeredGridView.countBuilder(
                      itemCount: plantsData.length,
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      staggeredTileBuilder: (index) => StaggeredTile.fit(1),
                      itemBuilder: (ctx, index) => PlantItem(
                            size: size,
                            name: plantsData[index].name,
                            description: plantsData[index].description,
                            imageUrl: plantsData[index].imageUrl,
                            id: plantsData[index].id,
                            keey: 'f',
                          )))
            ],
         
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      elevation: 0,
      leading: IconButton(
        icon: SvgPicture.asset("assets/icons/menu.svg"),
        onPressed: () {},
      ),
    );
  }
}
