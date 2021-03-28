import 'package:flutter/material.dart';
import 'package:planet_app/model/plantModel.dart';
import 'package:planet_app/provider/planet_provider.dart';
import 'package:provider/provider.dart';

import 'admin_page.dart';

class AddPlantScreen extends StatefulWidget {
  final String imageUrl;
  AddPlantScreen({this.imageUrl});
  @override
  _AddPlantScreenState createState() => _AddPlantScreenState();
}

class _AddPlantScreenState extends State<AddPlantScreen> {

  final _priceFocusNode = FocusNode();
  final _humidityFocusNode = FocusNode();
  final _descritpionFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();

    @override
  void dispose() {
    _priceFocusNode.dispose();
    _descritpionFocusNode.dispose();
    _humidityFocusNode.dispose();
    super.dispose();
  }


  bool _loading = false;
  String _plantType;
   PlantModel _plant = PlantModel(
      id: null,
      name: '',
      description: '',
      imageUrl: '',
      minimal_level_humidity: '',
      category: '');
   var _initValue = {
    'id': '',
    'name': '',
    'description': '',
    'imageUrl': '',
    'minimal_level_humidity': '',
    'category': ''
  };
   Future<void> _savedForm() async {
    final valdit = _formKey.currentState.validate();
    if (!valdit) {
      return;
    }
    setState(() {
      _loading = true;
    });
    _formKey.currentState.save();
    
    try {
      await Provider.of<PlantProvider>(context, listen: false)
          .addPlants(_plant);
      setState(() {
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _loading = false;
      });
      throw e;
      // Scaffold.of(context).showSnackBar(SnackBar(content: Text('Something wrong, please try agin!'),));
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
                  child: Column(
            children: [
              TextFormField(
                    initialValue: _initValue['name'],
                    decoration: InputDecoration(
                      labelText: 'Plant Name',
                    ),
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please Enter your title';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _plant = PlantModel(
                          id: _plant.id,
                          name: value,
                          description: _plant.description,
                          minimal_level_humidity: _plant.minimal_level_humidity,
                          imageUrl: widget.imageUrl,
                          category: _plant.category);
                    },
                    onFieldSubmitted: (_) =>
                        FocusScope.of(context).requestFocus(_humidityFocusNode),
                  ),
              //     TextFormField(
              //       initialValue:
              //           _initValue['minimal_level_humidity'].substring(0, 2),
              //       decoration: InputDecoration(
              //           labelText: 'Minimal Level of Humidity',
              //           suffixText: '%'),
              //       keyboardType: TextInputType.number,
              //       validator: (value) {
              //         if (value.isEmpty) {
              //           return 'Please enter the plant Humidity';
              //         }
              //         if (double.parse(value) > 100 ||
              //             double.parse(value) < 0) {
              //           return 'please enter correct precentage';
              //         }
              //       },
              //       textInputAction: TextInputAction.next,
              //       focusNode: _humidityFocusNode,
              //       onFieldSubmitted: (_) => FocusScope.of(context)
              //           .requestFocus(_descritpionFocusNode),
              //       onSaved: (value) {
              //         String hum = value.toString() + '%';
              //         _plant = PlantModel(
              //             id: _plant.id,
              //             name: _plant.name,
              //             description: _plant.description,
              //             minimal_level_humidity: hum,
              //             imageUrl: widget.imageUrl,
              //             category: _plant.category);
              //       },
              //     ),
                  TextFormField(
                    initialValue: _initValue['description'],
                    decoration: InputDecoration(
                      labelText: 'Description',
                    ),
                    maxLines: 3,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter your description';
                      }
                      if (value.length < 5) {
                        return 'Should be at least 5 characters!';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.multiline,
                    focusNode: _descritpionFocusNode,
                    onFieldSubmitted: (_) =>
                        FocusScope.of(context).requestFocus(_priceFocusNode),
                    onSaved: (value) {
                      _plant = PlantModel(
                          id: _plant.id,
                          name: _plant.name,
                          description: value,
                          minimal_level_humidity: _plant.minimal_level_humidity,
                          imageUrl: widget.imageUrl,
                          category: _plant.category);
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  DropdownButton<String>(
                    hint: _plantType == null
                        ? Text('Plant Type')
                        : Text(_plantType),
                    items: <String>['Indoor Plant', 'Outdoor Plant']
                        .map((String value) {
                      return new DropdownMenuItem<String>(
                        value: value,
                        child: new Text(value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _plantType = value.toString();
                      });
                      _plant = PlantModel(
                          id: _plant.id,
                          name: _plant.name,
                          description: value,
                          minimal_level_humidity: _plant.minimal_level_humidity,
                          imageUrl: widget.imageUrl,
                          category: _plantType);
                    },
                    focusColor: Theme.of(context).primaryColor,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  _loading
                      ? Center(child: CircularProgressIndicator())
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Center(
                              child: Container(
                                width: 175,
                                height: 175,
                                child: CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(widget.imageUrl),
                                ),
                              ),
                            ),
                            Column(
                              children: [
                                FlatButton(
                                  onPressed: () async {
                                    try {
                                      await _savedForm();
                                      Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                              builder: (ctx) => AdminPage()));
                                    } catch (e) {
                                      return showDialog(
                                          context: context,
                                          builder: (ctx) => AlertDialog(
                                                title: Text('Something wrong'),
                                                content:
                                                    Text('please try agin!'),
                                                actions: [
                                                  FlatButton(
                                                      onPressed: () {
                                                        Navigator.of(ctx).pop();
                                                      },
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                      child: Text('Okay!'))
                                                ],
                                              ));
                                    }
                                  },
                                  child: Text('Save'),
                                  color: Theme.of(context).primaryColor,
                                ),
                                FlatButton(
                                    onPressed: () {
                                      Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                              builder: (ctx) => AdminPage()));
                                    },
                                    child: Text('Cancel'),
                                    color: Theme.of(context).primaryColor),
                              ],
                            )
                          ],
                        ),
            ],
          ),
        ),
      ),
      
    );
  }
}