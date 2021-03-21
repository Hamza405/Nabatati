import 'package:flutter/material.dart';
import 'package:planet_app/provider/planet_provider.dart';
import 'package:planet_app/screens/details_screen/details_screen.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';

class HomePagePlants extends StatelessWidget {
  final String keey;
  HomePagePlants(this.keey);
  @override
  Widget build(BuildContext context) {
    var plantsData;
    if(keey=='i'){
      plantsData = Provider.of<PlantProvider>(context).indoorPlant;
    }else{
      plantsData = Provider.of<PlantProvider>(context).outdoorPlant;
    }
    return 
    Container(
      width: double.infinity,
      height: 200,
      child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: plantsData.length,
          separatorBuilder: (context, index) => SizedBox(
            width: 10,
          ),
          itemBuilder: (ctx,index) => RecomendPlantCard(
            title: plantsData[index].name,
            image: plantsData[index].imageUrl,
            description:plantsData[index].description,
            id: plantsData[index].id,
            keey:keey,
            index: index,
          ),
       
      ),
    );
  }
}

class RecomendPlantCard extends StatelessWidget {
  const RecomendPlantCard({
    Key key,
    this.keey,
    this.id,
    this.image,
    this.title,
    this.index,
    this.description,
    
  }) : super(key: key);

  final String image, title, description,id;
  final String keey;
  final int index;
  

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (ctx) => DetailsScreen(id: id,keyy: keey ,index:index)),);
      },
      child: Container(
        margin: EdgeInsets.only(
          left: kDefaultPadding,
          top: kDefaultPadding / 2,
          bottom: kDefaultPadding / 2,
        ),
        width: size.width * 0.6,
        height: 185,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
                  child: FadeInImage(
            placeholder: AssetImage('assets/icons/loading.gif'),
            image: NetworkImage(image),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
