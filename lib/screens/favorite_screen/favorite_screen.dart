import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:planet_app/provider/planet_provider.dart';
import 'package:planet_app/provider/planet_provider.dart';
import 'package:planet_app/screens/favorite_screen/compo/header_favorite_screen.dart';
import 'package:planet_app/screens/plants_screen/plantItem.dart';
import 'package:provider/provider.dart';

class FavoriteScreen extends StatefulWidget {
  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  bool _isInit=true;
  bool _loading=false;
  
  @override
  void didChangeDependencies() async {
    if(_isInit){
      setState(() {
        _loading = true;
      });
      await Provider.of<PlantProvider>(context,listen: false).fetchUserPlants();
       if (!mounted) return;
      setState(() {
        _loading = false;
      });
    }
    
    _isInit = false;
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final plantsData = Provider.of<PlantProvider>(context);
    return Padding(
      padding: const EdgeInsets.only(right:10,left:10),
      child:Column(
            children: [
              HeaderFavoriteScreen(size),
              _loading?Center(child:CircularProgressIndicator()): plantsData.fav.isEmpty?Center(child:Text('Your plants list is empty!')) :
              Expanded(
                  child: StaggeredGridView.countBuilder(
                      itemCount: plantsData.fav.length,
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      staggeredTileBuilder: (index) => StaggeredTile.fit(1),
                      itemBuilder: (ctx, index) => PlantItem(
                            size: size,
                            name: plantsData.fav[index].name,
                            description: plantsData.fav[index].description,
                            imageUrl: plantsData.fav[index].imageUrl,
                            id: plantsData.fav[index].id,
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


// FutureBuilder(
//                 future: plantsData.fetchUserPlants(),
//                 builder: (context,dataSnapShot){
//                   if(dataSnapShot.connectionState==ConnectionState.waiting){
//                     return Center(child: CircularProgressIndicator());
//                   }
//                   else if(dataSnapShot.error!=null){
// return Center(child:Text('Something wrong please try agin!'));
//                   }
//                   else if(plantsData.fav.isEmpty){
//                     return Center(child:Text('Your plants list is empty!'));
//                   }
//                   else{
//                     return Expanded(
//                   child: StaggeredGridView.countBuilder(
//                       itemCount: plantsData.fav.length,
//                       crossAxisCount: 2,
//                       mainAxisSpacing: 16,
//                       crossAxisSpacing: 16,
//                       staggeredTileBuilder: (index) => StaggeredTile.fit(1),
//                       itemBuilder: (ctx, index) => PlantItem(
//                             size: size,
//                             name: plantsData.fav[index].name,
//                             description: plantsData.fav[index].description,
//                             imageUrl: plantsData.fav[index].imageUrl,
//                             id: plantsData.fav[index].id,
//                             keey: 'f',
//                           )));
//                   }

//                 },
//               ),