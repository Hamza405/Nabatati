import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import '../model/plantModel.dart';
import 'package:http/http.dart' as http;

class PlantProvider with ChangeNotifier {
  final CollectionReference _indoorPlantCollectionRef =
      FirebaseFirestore.instance.collection('indoorplant');
  final CollectionReference _outdoorPlantCollectionRef =
      FirebaseFirestore.instance.collection('outdoorplant');

  ValueNotifier<bool> _loading = ValueNotifier(false);
  ValueNotifier<bool> get loading => _loading;

  List<PlantModel> _indoorPlant = [];
  List<PlantModel> _outdoorPlant = [];
  List<PlantModel> fav = [];
  List<PlantModel> _plants = [];

  List<PlantModel> get indoorPlant => _indoorPlant;
  List<PlantModel> get outdoorPlant => _outdoorPlant;
  List<PlantModel> get plants => _plants;

  PlantProvider() {
    // fetchData();
  }

  // toggleFavorite(int index){
  //   _indoorPlant[inded]
  // }

  Future<void> fetchFavorite() async{
    plants.forEach((element) {

     });
  }

  Future<void> fetchPlants() async {
    Uri url = Uri.parse(
        'https://nabtati-6386c-default-rtdb.firebaseio.com/plants.json');
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) return;
      Uri url1 = Uri.parse(
        'https://nabtati-6386c-default-rtdb.firebaseio.com/userPlants/admin.json');
      final favoriteResponse = await http.get(url1);
      final favoriteData = json.decode(favoriteResponse.body);  
      final List<PlantModel> _loadedPlants = [];
      extractedData.forEach((key, value) {
        _loadedPlants.add(PlantModel(
            id: key,
            name: value['name'],
            description: value['description'],
            minimal_level_humidity: value['minimal_level_humidity'],
            category: value['category'],
            imageUrl: value['imageUrl'],
            isFavorite: favoriteData == null?false: favoriteData[key]?? false,
          ));
      });
      List<PlantModel> _inP = [];
      List<PlantModel> _outP = [];
      List<PlantModel> _f = [];
      _loadedPlants.forEach((element) {
        if (element.category == 'Indoor Plant') {
          _inP.add(element);
        } else if (element.category == 'Outdoor Plant') {
          _outP.add(element);
        }
      });
      _loadedPlants.forEach((element) { 
        if (element.isFavorite == true){
          _f.add(element);
        }
       });
      _indoorPlant = _inP;
      _outdoorPlant = _outP;
      fav=_f;
      _plants = _loadedPlants;
      notifyListeners();
    } catch (e) {
      throw HttpException(e.toString());
    }
  }

  Future<void> fetchUserPlants() async {
    Uri url = Uri.parse(
        'https://nabtati-6386c-default-rtdb.firebaseio.com/plants.json');
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) return;
      Uri url1 = Uri.parse(
        'https://nabtati-6386c-default-rtdb.firebaseio.com/userPlants/admin.json');
      final favoriteResponse = await http.get(url1);
      final favoriteData = json.decode(favoriteResponse.body);  
      final List<PlantModel> _loadedPlants = [];
      extractedData.forEach((key, value) {
        _loadedPlants.add(PlantModel(
            id: key,
            name: value['name'],
            description: value['description'],
            minimal_level_humidity: value['minimal_level_humidity'],
            category: value['category'],
            imageUrl: value['imageUrl'],
            isFavorite: favoriteData == null?false: favoriteData[key]?? false,
          ));
      });
      List<PlantModel> _f = [];
      _loadedPlants.forEach((element) { 
        if (element.isFavorite == true){
          _f.add(element);
        }
       });
      fav=_f;
      _plants = _loadedPlants;
      notifyListeners();
    } catch (e) {
      throw HttpException(e.toString());
    }
  }

  Future<void> addPlants(PlantModel plant) async {
    Uri url = Uri.parse(
        'https://nabtati-6386c-default-rtdb.firebaseio.com/plants.json');
    try {
      final response = await http.post(url,
          body: json.encode({
            
            'name': plant.name,
            'description': plant.description,
            'imageUrl': plant.imageUrl,
            'minimal_level_humidity': plant.minimal_level_humidity,
            'category': plant.category
          }));
      final newplant = PlantModel(
          id: json.decode(response.body)['name'],
          name: plant.name,
          description: plant.description,
          minimal_level_humidity: plant.minimal_level_humidity,
          imageUrl: plant.imageUrl);
      _indoorPlant.add(newplant);
      print('secc');
      notifyListeners();
    } catch (e) {
      print(e.toString());
      throw HttpException(e.toString());
    }
  }

  Future<void> editPlant(String id, PlantModel newPlant) async {
    Uri url = Uri.parse(
        'https://nabtati-6386c-default-rtdb.firebaseio.com/plants/$id.json');
    final plantIndex = _plants.indexWhere((element) => element.id == id);
    if (plantIndex == null) return;
    try {
      final response = await http.patch(url,
          body: json.encode({
            'name': newPlant.name,
            'description': newPlant.description,
            'minimal_level_humidity': newPlant.minimal_level_humidity,
            'category': newPlant.category
          }));
          if(response.statusCode >=400){
            throw HttpException('error');
          }
      _plants[plantIndex] = newPlant;
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> addPlantToUserPlant(PlantModel plant)async{
    Uri url = Uri.parse(
        'https://nabtati-6386c-default-rtdb.firebaseio.com/UserPlants.json');
     try {
      final response = await http.post(url,
          body: json.encode({
            'id':plant.id,
            'name': plant.name,
            'description': plant.description,
            'imageUrl': plant.imageUrl,
            'minimal_level_humidity': plant.minimal_level_humidity,
            'category': plant.category
          }));
      final newplant = PlantModel(
          id: plant.id,
          name: plant.name,
          description: plant.description,
          minimal_level_humidity: plant.minimal_level_humidity,
          imageUrl: plant.imageUrl);
      fav.add(newplant);
      print('secc');
      notifyListeners();
    } catch (e) {
      print(e.toString());
      throw HttpException(e.toString());
    } 
  }

  Future<void> deletePlant(String id) async {
    Uri url = Uri.parse(
        'https://nabtati-6386c-default-rtdb.firebaseio.com/plants/$id.json');
    final plantIndex = _plants.indexWhere((element) => element.id == id);
    var existingPlantIndex = _plants[plantIndex];
    
   
    try{
    final resopnse = await http.delete(url);
     _plants.removeWhere((element) => element.id == id);
    notifyListeners();
    if (resopnse.statusCode >= 400) {
      _plants.insert(plantIndex, existingPlantIndex);
      notifyListeners();
      print(resopnse.statusCode.toString());
      throw HttpException('could not delete product!');
    }
    existingPlantIndex = null;
    }catch(e){
      throw e;
    }
  }

   
  findById(String id) {
    return _plants.firstWhere((element) => element.id == id);
  }

  fetchData() async {
    List<PlantModel> ind = [];
    List<PlantModel> out = [];
    List<PlantModel> fav = [];

    print('11');
    _loading.value = true;
    try {
      await _indoorPlantCollectionRef.get().then((value) {
        for (int i = 0; i < value.docs.length; i++) {
          ind.add(PlantModel.fromJson(value.docs[i].data()));
          ind[i].id = value.docs[i].id;
        }
      });
    } catch (e) {
      _loading.value = false;
      throw e;
    }

    try {
      await _outdoorPlantCollectionRef.get().then((value) {
        for (int i = 0; i < value.docs.length; i++) {
          out.add(PlantModel.fromJson(value.docs[i].data()));
          out[i].id = value.docs[i].id;
        }
      });

      _loading.value = false;
    } catch (e) {
      _loading.value = false;
      throw e;
    }
    _indoorPlant = ind;
    _outdoorPlant = out;

    notifyListeners();
  }

  PlantModel indoorfindById(String id) {
    return _indoorPlant.firstWhere((element) => element.id == id);
  }

  PlantModel outdoorfindById(String id) {
    return _outdoorPlant.firstWhere((element) => element.id == id);
  }

  PlantModel favoriteItemsfindById(String id) {
    return fav.firstWhere((element) => element.id == id);
  }

  deleteItemFromFavorite(String id){
    fav.removeWhere((element) => element.id==id);
    notifyListeners();
  }

}
