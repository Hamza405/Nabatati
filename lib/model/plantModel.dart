import 'package:flutter/foundation.dart';

class PlantModel with ChangeNotifier {
  String id;
   String name;
   String description;
   String imageUrl;
   String minimal_level_humidity;
   String category;
  PlantModel({this.id,this.name, this.description,this.imageUrl,this.minimal_level_humidity,this.category});
  String get getId => id;
  PlantModel.fromJson(Map<dynamic,dynamic> map){
    if (map ==null) {
      
      return;
    }
    name = map['name'];
    description = map['description'];
    imageUrl = map['imageUrl'];
    minimal_level_humidity =map['minimal_level_humidity'];
    category = map['category'];

  }
   toJson(){
    return {
      'name' : name,
    'description' : description,
    'imageUrl' :imageUrl,
    'minimal_level_humidity':minimal_level_humidity,
    'category':category
    
    };
  }
}