import 'package:flutter/material.dart';
import 'package:planet_app/provider/planet_provider.dart';
import 'package:planet_app/screens/home_page/compo/home_page_plants.dart.dart';
import 'package:planet_app/screens/home_page/compo/title_with_more_bbtn.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';
import 'compo/header.dart';

class HomePage extends StatelessWidget {
 
  @override
  Widget build(BuildContext context) {
  Size size = MediaQuery.of(context).size;
    return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            HeaderWithSearchBox(size: size),
            Expanded(child: 
            SingleChildScrollView(
              child: FutureBuilder(
                future: Provider.of<PlantProvider>(context,listen: false).fetchPlants(),

                builder: (ctx,data){
                  
                  if(data.connectionState==ConnectionState.waiting){
                    return Center(child:CircularProgressIndicator());
                  }
                  if(data.error!=null){
                    
                     return Center(child:Text('Some thing wrong please try again!'));
                  }
                  return Column(
                children: [
                   TitleWithMoreBtn(title: "Indoorplant",press:'i',),
            HomePagePlants('i'),
            TitleWithMoreBtn(title: "Outdoorplant", press:'o'),
            HomePagePlants('o'),
            SizedBox(height: kDefaultPadding),
                ],
            );}
                             
            ) 
            ))
          ]
        
          
    );
          
  }
}


