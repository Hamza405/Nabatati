import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:planet_app/helper/http_exception.dart';
import 'package:http/http.dart' as http;
import 'package:planet_app/provider/planet_provider.dart';

class PlantModel with ChangeNotifier {
  String id;
   String name;
   String description;
   String imageUrl;
   String minimal_level_humidity;
   String category;
   bool isFavorite;
  PlantModel({this.id,this.name, this.description,this.imageUrl,this.minimal_level_humidity,this.category,this.isFavorite});
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
    'category':category,
    
    };
  }

    Future<void> toggleFavoriteStatus(String token,String userId) async {
    final oldStatue = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    Uri url = Uri.parse(
        'https://nabtati-6386c-default-rtdb.firebaseio.com/userPlants/$userId/$id.json?auth=$token');
    try {
      final response = await http.put(url, body: json.encode(isFavorite));
      
      if (response.statusCode >= 400) {
        isFavorite = oldStatue;
        notifyListeners();

        throw HttpException('Something wrong try agin later!');
      }
    } catch (e) {
      isFavorite = oldStatue;
      notifyListeners();
      throw e;
    }
  }
}
