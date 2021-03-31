import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:planet_app/controle_page.dart';
import 'package:planet_app/screens/admin%20page/compo/header_edit_screens.dart';

import 'add_plant_screen.dart';
import 'edit_plants.dart';

class UploadImageScreen extends StatefulWidget {
  @override
  _UploadImageScreenState createState() => _UploadImageScreenState();
}

class _UploadImageScreenState extends State<UploadImageScreen> {
  File _image;
  final picker = ImagePicker();
  String imageUrl;
  bool _loading = false;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: [
          HeaderEditsScreens('Uploade Image', size),
          Padding(
            padding: const EdgeInsets.only(top: 25, left: 16, right: 16),
            child: Column(
              children: [
                _image == null
                    ? Center(child: Text('Select an Image'))
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        
                        child: Container(
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height * 0.7,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: FileImage(
                                    _image,
                                  ),
                                  fit: BoxFit.cover)),
                        ),
                      ),
                SizedBox(
                  height: 25,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                                      child: FlatButton(
                        
                        onPressed: pickImage,
                        child: Text('Select image',
                            style: TextStyle(color: Colors.white)),
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    _loading
                        ? Center(child: CircularProgressIndicator())
                        : FlatButton(
                            onPressed: () async {
                              setState(() {
                                _loading = true;
                              });

                              try {
                                if(_image==null){
                                  showDialog(context: context, builder: (ctx)=>AlertDialog(
                                    content: Text('Please select an image'),
                                    
                                  ));
                                   setState(() {
                                _loading = false;
                              });
                                  return;
                                }
                                await addImageToStorage();
                                setState(() {
                                  _loading = false;
                                });
                                Navigator.of(context).pushReplacement(MaterialPageRoute(
                                    builder: (ctx) =>
                                        AddPlantPage(imageUrl: imageUrl,id: null,)));
                              } catch (e) {
                                setState(() {
                                  _loading = false;
                                });
                                print(e.toString());
                                 showDialog(context: context, builder: (ctx)=>AlertDialog(
                                    content: Text('Something wrong!'),
                                    
                                  ));
                              }},
                            child: Text('Upload Image',
                                style: TextStyle(color: Colors.white)),
                            color: Theme.of(context).primaryColor,
                          ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  void pickImage() async {
    final image = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (image != null) {
        setState(() {
          _image = File(image.path);
        });
      } else {
        return;
      }
    });
  }

  Future<void> addImageToStorage() async {
    var i = DateTime.now().toIso8601String();
    final firebaseStorageRef =
        FirebaseStorage.instance.ref().child('images/$i');
    await firebaseStorageRef.putFile(_image).whenComplete(() async {
      imageUrl = await firebaseStorageRef.getDownloadURL();
      print(imageUrl.toString());
    });
  }
}
