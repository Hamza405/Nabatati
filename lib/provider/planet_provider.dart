import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../model/plantModel.dart';
class PlantProvider with ChangeNotifier {
  final CollectionReference _indoorPlantCollectionRef = FirebaseFirestore.instance.collection('indoorplant');
  final CollectionReference _outdoorPlantCollectionRef = FirebaseFirestore.instance.collection('outdoorplant');

  ValueNotifier<bool> _loading = ValueNotifier(false);
  ValueNotifier<bool> get loading => _loading; 

  List<PlantModel> _indoorPlant =[];
  List<PlantModel> _outdoorPlant =[];
  List<PlantModel> _fav =[];

  List<PlantModel> get indoorPlant => _indoorPlant;
  List<PlantModel> get outdoorPlant => _outdoorPlant;
  List<PlantModel> get fav => _fav;
  
  PlantProvider(){
    // fetchData();
  }


  // toggleFavorite(int index){
  //   _indoorPlant[inded]
  // }

  fetchData()async{
    List<PlantModel> ind =[];
    List<PlantModel> out =[];
    List<PlantModel> fav =[];
    
    print('11');
  _loading.value = true;
  try{
    await  _indoorPlantCollectionRef.get().then((value) {
      for(int i=0; i<value.docs.length;i++){
        ind.add(PlantModel.fromJson(value.docs[i].data()));
        ind[i].id = value.docs[i].id;
      }
    });
    
     
  }catch(e){
     _loading.value = false;
    throw e;
  }

  try{
    await  _outdoorPlantCollectionRef.get().then((value) {
      for(int i=0; i<value.docs.length;i++){
        out.add(PlantModel.fromJson(value.docs[i].data()));
        out[i].id = value.docs[i].id;
      }
    });
   
    _loading.value = false;
  }catch(e){
     _loading.value = false;
    throw e;
  }
  _indoorPlant = ind;
  _outdoorPlant=out;
  for(int i =0;i<_indoorPlant.length;i++){
      if(_indoorPlant[i].isFavorite==true){
        fav.add(_indoorPlant[i]);
      }
    }
     for(int i =0;i<_outdoorPlant.length;i++){
      if(_outdoorPlant[i].isFavorite==true){
        fav.add(_outdoorPlant[i]);
      }
    }
    _fav=fav;
   
    notifyListeners();
  }

  getFavoriteItem(){
    List<PlantModel> _currentFavorite;
    for(int i =0;i<_indoorPlant.length;i++){
      if(_indoorPlant[i].isFavorite==true){
        _currentFavorite.add(_indoorPlant[i]);
      }
    }
    for(int i =0;i<_outdoorPlant.length;i++){
      if(_outdoorPlant[i].isFavorite==true){
        _currentFavorite.add(_outdoorPlant[i]);
      }
    }
    _fav=_currentFavorite;
    notifyListeners();
  }

  Future<void> toggleItemFavorite(String id,bool currentFavorite,String key)async{
    List<PlantModel> _currentFavorite =[];
    bool z=false;
    try{
    if(key=='i'){
       
    bool favorite = !currentFavorite;
    await _indoorPlantCollectionRef.doc(id).update({
      'isFavorite':favorite
    });
    var ti = _indoorPlant.indexWhere((element) => element.id==id); 
    _indoorPlant[ti].isFavorite = favorite;
    
    
    } else if(key=='o'){
      bool favorite = !currentFavorite;
    await _outdoorPlantCollectionRef.doc(id).update({
      'isFavorite':favorite
    });
    var ti = _outdoorPlant.indexWhere((element) => element.id==id); 
    _outdoorPlant[ti].isFavorite = favorite;
    
    }else if(key=='f'){
      _indoorPlant.forEach((element) {
        if (element.id == id){
          z=true;
          return;
        }
       });
      if(z){
            
    bool favorite = !currentFavorite;
    await _indoorPlantCollectionRef.doc(id).update({
      'isFavorite':favorite
    });
    var ti = _indoorPlant.indexWhere((element) => element.id==id); 
    _indoorPlant[ti].isFavorite = favorite;
      } else{
        bool favorite = !currentFavorite;
    await _outdoorPlantCollectionRef.doc(id).update({
      'isFavorite':favorite
    });
    var ti = _outdoorPlant.indexWhere((element) => element.id==id); 
    _outdoorPlant[ti].isFavorite = favorite;
      }
    }
    }catch(e){
      throw e;
    }
    for(int i =0;i<_outdoorPlant.length;i++){
      if(_outdoorPlant[i].isFavorite==true){
        _currentFavorite.add(_outdoorPlant[i]);
      }
    }
    for(int i =0;i<_indoorPlant.length;i++){
      if(_indoorPlant[i].isFavorite==true){
        _currentFavorite.add(_indoorPlant[i]);
      }
    }
    _fav=_currentFavorite;
    
    
    
    notifyListeners();
   
  }

   PlantModel indoorfindById(String id) {
    return _indoorPlant.firstWhere((element) => element.id == id);
  }
   PlantModel outdoorfindById(String id) {
    return _outdoorPlant.firstWhere((element) => element.id == id);
  }
   PlantModel favoriteItemsfindById(String id) {
    return _fav.firstWhere((element) => element.id == id);
  }
}