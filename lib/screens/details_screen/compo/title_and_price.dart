import 'package:flutter/material.dart';
import 'package:planet_app/model/plantModel.dart';
import 'package:planet_app/provider/planet_provider.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';

class TitleAndPrice extends StatelessWidget {
  const TitleAndPrice({Key key, this.title, this.description, this.id,this.keyy})
      : super(key: key);

  final String title, description, id,keyy;
  

  @override
  Widget build(BuildContext context) {
    bool _isFav =false;
    if(keyy=='f')  _isFav = true;
    print(keyy);
    final plant = Provider.of<PlantProvider>(context);
    PlantModel _userPlant = plant.findById(id);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
      child: Column(
        children: [
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${title}',
                  style: Theme.of(context)
                      .textTheme
                      .headline4
                      .copyWith(color: kTextColor, fontWeight: FontWeight.bold),
                ),
                FlatButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(_isFav?'Remove from my plants' :
                    'Add to my plants'
                        ,
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Theme.of(context).primaryColor,
                  onPressed: () async {
                    if(_isFav){
                      await plant.deleteUserPlant(id).then((value) {
                        Scaffold.of(context).showSnackBar(SnackBar(
                          backgroundColor: Theme.of(context).primaryColor.withOpacity(0.5),
                            content: Text(
                                'The plant has been removed from your plants')));
                      });
                      Navigator.of(context).pop();
                      return;
                    }
                    
                      await plant.addPlantToUserPlant(_userPlant).then((value) {
                        Scaffold.of(context).showSnackBar(SnackBar(
                          backgroundColor: Theme.of(context).primaryColor.withOpacity(0.5),
                            content: Text(
                                'The plant has been added to your plants')));
                      });
                  
                    
                  },
                )
              ],
            ),
        
          SizedBox(
            height: 24,
          ),
          Text(
            description == null
                ? 'The plant dose not has a description!!!'
                : description,
            style: TextStyle(fontSize: 25),
          )
        ],
      ),
    );
  }
}
