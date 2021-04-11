import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:planet_app/provider/planet_provider.dart';
import 'package:planet_app/screens/admin%20page/edit_plants.dart';
import 'package:planet_app/screens/admin%20page/uploade_image_screen.dart';
import 'package:planet_app/screens/settings_screen/compo/settings_screen.dart';
import 'package:planet_app/widget/drawer.dart';
import 'package:provider/provider.dart';

import '../../controle_page.dart';
import 'compo/headrAdminPage.dart';

class AdminPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    
    return Scaffold(
      appBar: AppBar(
        // automaticallyImplyLeading: false,
      elevation: 0,
      // leading: IconButton(
      //   icon: SvgPicture.asset("assets/icons/menu.svg"),
      //   onPressed: () =>Scaffold.of(context).openDrawer()
      // ),
      actions: [
        IconButton(
          icon: Icon(Icons.add_to_photos_outlined),
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (ctx) => UploadImageScreen()));
          },
        )
      ],
    ),
      drawer: MyDrawer(),
      body: Column(
        children: [
          HeaderAdminPage(size),
          FutureBuilder(
            // future: Provider.of<PlantProvider>(context, listen: false)
            //     .fetchPlants(),
            builder: (ctx, dataSnapShot) {
              if (dataSnapShot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (dataSnapShot.error != null) {
                return Center(child: Text('Something wrong!,please try agin'));
              } else {
                return Consumer<PlantProvider>(
                  builder: (ctx, model, _) => Expanded(
                    child: ListView.builder(
                      itemCount: model.plants.length,
                      itemBuilder: (ctx, index) => Column(
                        children: [
                          ListTile(
                            // title: Text('${model.plants[index].name} - ${model.plants[index].category}'),
                            title: Text('${model.plants[index].name}'),
                            leading: CircleAvatar(
                              backgroundImage:
                                  NetworkImage(model.plants[index].imageUrl),
                            ),
                            trailing: Container(
                              height: 100,
                              width: 100,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.edit),
                                    onPressed: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (ctx) => AddPlantPage(
                                                  imageUrl: model
                                                      .plants[index].imageUrl,
                                                  id: model.plants[index].id)));
                                    },
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete),
                                    onPressed: () async {
                                      return showDialog(
                                          context: context,
                                          builder: (ctx) => AlertDialog(
                                                title: Text('Are you sure ?'),
                                                content: Text(
                                                    'Do you want to remove this plant from your Database ?'),
                                                actions: [
                                                  FlatButton(
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                    child: Text('No'),
                                                    onPressed: () =>
                                                        Navigator.of(ctx).pop(),
                                                  ),
                                                  FlatButton(
                                                    child: Text('Yes'),
                                                    onPressed: () async {
                                                      try{
                                                        await model.deletePlant(
                                                            model.plants[index]
                                                                .id);
                                                                
                                                                Navigator.of(ctx).pop();
                                                                }catch(e){
                                                                  Navigator.of(ctx).pop();
                                                                  showDialog(context: context, builder: (ctx)=>AlertDialog(title: Text('Error'),content: Text('Something wrong, please try agin!'),));
                                                                }
                                                    },
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                  ),
                                                ],
                                              ));
                                    },
                                    color: Theme.of(context).errorColor,
                                  )
                                ],
                              ),
                            ),
                          ),
                          Divider(
                            height: 2,
                            color: Theme.of(context).primaryColor,
                          )
                        ],
                      ),
                    ),
                  ),
                );
              }
            },
          )
        ],
      ),
    );
  }


  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      leading: IconButton(
        icon: SvgPicture.asset("assets/icons/menu.svg"),
        onPressed: () {
          Scaffold.of(context).openDrawer();
        },
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.add_a_photo_rounded),
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (ctx) => UploadImageScreen()));
          },
        )
      ],
    );
  }
}
