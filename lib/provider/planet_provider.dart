import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:planet_app/model/userModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/plantModel.dart';
import 'package:http/http.dart' as http;

class PlantProvider with ChangeNotifier {
  final String keyUserData = 'userData';
  String _token;
  String _userId;
  DateTime _expiryDateToken;
  Timer _authTimer;

  bool _isAdmin =false;
  bool get isAdmin => _isAdmin;
  List<String> _adminsList =[];
  List<String> get adminsList => _adminsList;


  UserModel _user;
  UserModel get user => _user;

  String get userId => _userId;

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_token != null &&
        _expiryDateToken != null &&
        _expiryDateToken.isAfter(DateTime.now())) {
      return _token;
    }
    return null;
  }

  Future<void> signUp(
    
      String email, String password, String name, String phoneNumber) async {
        // await getAdminUser(email);
    try {
      Uri url = Uri.parse(
          'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyCGOk3Q8o1rHQqKKtrA3bwXVCzF7lmo4yM');
      final response = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDateToken = DateTime.now()
          .add(Duration(seconds: int.parse(responseData['expiresIn'])));
      _autoLogout();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'email':email,
        'token': _token,
        'userId': _userId,
        '_expiryDate': _expiryDateToken.toIso8601String()
      });
      prefs.setString(keyUserData, userData);
      Uri url1 = Uri.parse(
          'https://nabtati-6386c-default-rtdb.firebaseio.com/users.json?auth=$token');
      try {
        final responseDataBase = await http.post(url1,
            body: json.encode({
              'userId': userId,
              'name': name,
              'phoneNumber': phoneNumber,
              'email': email,
            }));
        _user = UserModel(
            userId: userId,
            databaseId: json.decode(responseDataBase.body)['name'],
            phoneNumber: phoneNumber,
            email: email);

        print('secc');
        // _isAdmin = _adminsList.contains(email);
        notifyListeners();
      } catch (e) {
        print(e.toString());
        throw HttpException(e.toString());
      }
    } catch (error) {
      throw  error;
    }
  }

  Future<void> signIn(String email, String password) async {
    // getAdminUser(email);
    Uri url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyCGOk3Q8o1rHQqKKtrA3bwXVCzF7lmo4yM');
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDateToken = DateTime.now()
          .add(Duration(seconds: int.parse(responseData['expiresIn'])));
      _autoLogout();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'email':email,
        'token': _token,
        'userId': _userId,
        '_expiryDate': _expiryDateToken.toIso8601String()
      });
      // _isAdmin = _adminsList.contains(email);
      prefs.setString(keyUserData, userData);
    } catch (error) {
      throw error;
    }
  }

  Future<bool> autoLogin() async {
   
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extractedUserData =
        await json.decode(prefs.getString(keyUserData)) as Map<String, Object>;
    final expiryDate = DateTime.parse(extractedUserData['_expiryDate']);
    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    String email = extractedUserData['email'];
    _token = extractedUserData['token'];
    _userId = extractedUserData['userId'];
    _expiryDateToken = expiryDate;
    // await getAdminUser(email);
    notifyListeners();
    _autoLogout();
    return true;
  }

  void logout() async {
    _token = null;
    _expiryDateToken = null;
    _userId = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(keyUserData);
    notifyListeners();
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    var expiryDate = _expiryDateToken.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: expiryDate), logout);
  }

  Future<void> getAdminUser(String email) async {
   
    final Uri url =Uri.parse('https://nabtati-6386c-default-rtdb.firebaseio.com/admin.json?auth=$token');
    final response = await http.get(url);
    final extractedData = json.decode(response.body);
    bool s = extractedData.values.contains((element)=>element['email']==email);
    _isAdmin = s;
    print(_isAdmin.toString());
    print(email);
    notifyListeners();
   
  }

  Future<void> getUserInfo() async {
    try{
    final Uri url = Uri.parse(
        'https://nabtati-6386c-default-rtdb.firebaseio.com/users.json?auth=$token');
    final response = await http.get(url);
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == null) return;
    
    // Map<String,dynamic> s = extractedData.values.firstWhere((element) => element['userId']==userId);
    var ss = extractedData.entries.firstWhere((element) => element.value['userId']==userId);
    var databaseId = ss.key;
    var s = ss.value;
    _user=UserModel(
      databaseId: databaseId,
      userId: userId,
      name: s['name'],
      email: s['email'],
      phoneNumber: s['phoneNumber']
    );
    }catch(e){
      throw e;
    }
  }
  Future<void> editUserInfo(String id,UserModel user)async{
    print(id);
    print(user.name);
    Uri url = Uri.parse('https://nabtati-6386c-default-rtdb.firebaseio.com/users/$id.json?auth=$token');
    try {
      final response = await http.put(url,
          body: json.encode({
            'name': user.name,
            'email': user.email,
            'phoneNumber': user.phoneNumber,
            'userId':user.userId
          }));
      if (response.statusCode >= 400) {
        throw HttpException('error');
      }
      _user=user;
      print(_user.name);
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  List<PlantModel> _indoorPlant = [];
  List<PlantModel> _outdoorPlant = [];
  List<PlantModel> fav = [];
  List<PlantModel> _plants = [];

  List<PlantModel> get indoorPlant => _indoorPlant;
  List<PlantModel> get outdoorPlant => _outdoorPlant;
  List<PlantModel> get plants => _plants;

  Future<void> fetchPlants() async {
    Uri url = Uri.parse(
        'https://nabtati-6386c-default-rtdb.firebaseio.com/plants.json?auth=$token');
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) return;
      Uri url1 = Uri.parse(
          'https://nabtati-6386c-default-rtdb.firebaseio.com/userPlants/$userId.json?auth=$token');
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
          isFavorite: favoriteData == null ? false : favoriteData[key] ?? false,
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
        if (element.isFavorite == true) {
          _f.add(element);
        }
      });
      _indoorPlant = _inP;
      _outdoorPlant = _outP;
      fav = _f;
      _plants = _loadedPlants;
      print('asdasd');
      notifyListeners();
    } catch (e) {
      throw HttpException(e.toString());
    }
  }

  Future<void> fetchUserPlants() async {
    Uri url = Uri.parse(
        'https://nabtati-6386c-default-rtdb.firebaseio.com/plants.json?auth=$token');
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) return;
      Uri url1 = Uri.parse(
          'https://nabtati-6386c-default-rtdb.firebaseio.com/userPlants/$userId.json?auth=$token');
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
          isFavorite: favoriteData == null ? false : favoriteData[key] ?? false,
        ));
      });
      List<PlantModel> _f = [];
      _loadedPlants.forEach((element) {
        if (element.isFavorite == true) {
          _f.add(element);
        }
      });
      fav = _f;
      _plants = _loadedPlants;
      notifyListeners();
    } catch (e) {
      throw HttpException(e.toString());
    }
  }

  Future<void> addPlants(PlantModel plant) async {
    Uri url = Uri.parse(
        'https://nabtati-6386c-default-rtdb.firebaseio.com/plants.json?auth=$token');
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
        'https://nabtati-6386c-default-rtdb.firebaseio.com/plants/$id.json?auth=$token');
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
      if (response.statusCode >= 400) {
        throw HttpException('error');
      }
      _plants[plantIndex] = newPlant;
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> addPlantToUserPlant(PlantModel plant) async {
    Uri url = Uri.parse(
        'https://nabtati-6386c-default-rtdb.firebaseio.com/UserPlants.json?auth=$token');
    try {
      final response = await http.post(url,
          body: json.encode({
            'id': plant.id,
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
        'https://nabtati-6386c-default-rtdb.firebaseio.com/plants/$id.json?auth=$token');
    final plantIndex = _plants.indexWhere((element) => element.id == id);
    var existingPlantIndex = _plants[plantIndex];

    try {
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
    } catch (e) {
      throw e;
    }
  }

  findById(String id) {
    return _plants.firstWhere((element) => element.id == id);
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

  deleteItemFromFavorite(String id) {
    fav.removeWhere((element) => element.id == id);
    notifyListeners();
  }
}
