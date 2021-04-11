import 'package:flutter/material.dart';
import 'package:planet_app/model/plantModel.dart';
import 'package:planet_app/provider/planet_provider.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';

class NameAndOther extends StatefulWidget {
  const NameAndOther(
      {Key key, this.title, this.description, this.id, this.keyy,this.minimal_level_humidity,this.category})
      : super(key: key);

  final String title, description, id, keyy,minimal_level_humidity,category;

  @override
  _TitleAndPriceState createState() => _TitleAndPriceState();
}

class _TitleAndPriceState extends State<NameAndOther> {
  @override
  Widget build(BuildContext context) {
    bool _loading = false;
    // if(keyy=='f')  _isFav = true;
    print(widget.keyy);
    final plant = Provider.of<PlantProvider>(context, listen: false);
    PlantModel _userPlant = plant.findById(widget.id);
    bool oldStatue = _userPlant.isFavorite;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${widget.title}',
                style: Theme.of(context)
                    .textTheme
                    .headline4
                    .copyWith(color: kTextColor, fontWeight: FontWeight.bold),
              ),
              Consumer<PlantModel>(
                builder: (ctx, dara, _) => _loading
                    ? Center(child: CircularProgressIndicator())
                    : FlatButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          _userPlant.isFavorite
                              ? 'Remove from my plants'
                              : 'Add to my plants',
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Theme.of(context).primaryColor,
                        onPressed: () async {
                          if (widget.keyy == 'f') {
                            Navigator.of(context).pop();
                            await _userPlant.toggleFavoriteStatus(plant.token,plant.userId);
                          if (oldStatue) {
                              plant.deleteItemFromFavorite(widget.id);
                            }
                            return;
                          }
                          await _userPlant.toggleFavoriteStatus(plant.token,plant.userId);
                          if(!mounted) return;
                          setState(() {});
                          

                          Scaffold.of(context).showSnackBar(SnackBar(
                              backgroundColor: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.5),
                              content: Text(_userPlant.isFavorite
                                  ? 'The plant has been added to your plants'
                                  : 'The plant has been removed from your plants')));
                        }),
              )
            ],
          ),
          SizedBox(
            height: 24,
          ),
          Text(
            widget.description == null
                ? 'The plant dose not has a description!!!'
                : widget.description,
            style: TextStyle(fontSize: 25),
          ),
          SizedBox(
            height: 24,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              
              Text(
                'Type :',
                style: TextStyle( fontSize: 25,fontWeight: FontWeight.bold),
              ),
              Text(
                widget.category,
                style: TextStyle(fontSize: 20), 
              )
            ],
          ),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              
              Text(
                'Minimal humidity :',
                style: TextStyle( fontSize: 20,fontWeight: FontWeight.bold),
              ),
              Text(
                widget.minimal_level_humidity,
                style: TextStyle(fontSize: 20), 
              )
            ],
          ),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              
              Text(
                'Actually humidity :',
                style: TextStyle( fontSize: 20,fontWeight: FontWeight.bold),
              ),
              Text(
                widget.minimal_level_humidity,
                style: TextStyle(fontSize: 20), 
              )
            ],
          ),
          SizedBox(
            height: 15,
          ),
          FlatButton(
            minWidth: 150,
            height: 40,
              shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
              color: Theme.of(context).primaryColor,          
              child: Text('ٌRegalation',style: TextStyle(color: Colors.white),),
              onPressed: (){},
            )
         
        ],
      ),
    );
  }
}
