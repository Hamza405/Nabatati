import 'package:flutter/foundation.dart';

class PlantModel with ChangeNotifier {
  String id;
   String name;
   String description;
   String imageUrl;
   bool isFavorite;
  PlantModel(this.name, this.description,this.imageUrl,this.isFavorite);
  String get getId => id;
  PlantModel.fromJson(Map<dynamic,dynamic> map){
    if (map ==null) {
      
      return;
    }
    name = map['name'];
    description = map['description'];
    imageUrl = map['imageUrl'];
    isFavorite =map['isFavorite'];

  }
   toJson(){
    return {
      'name' : name,
    'description' : description,
    'imageUrl' :imageUrl,
    'isFavorite':isFavorite
    
    };
  }
}