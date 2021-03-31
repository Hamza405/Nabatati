import 'package:flutter/material.dart';
import 'package:planet_app/model/plantModel.dart';
import 'package:planet_app/provider/planet_provider.dart';
import 'package:planet_app/screens/admin%20page/admin_page.dart';
import 'package:planet_app/screens/admin%20page/compo/header_edit_screens.dart';
import 'package:planet_app/screens/admin%20page/uploade_image_screen.dart';
import 'package:provider/provider.dart';

import '../../controle_page.dart';

class AddPlantPage extends StatefulWidget {
  final String id;
  final String imageUrl;
  AddPlantPage({this.imageUrl, this.id});
  @override
  _AddPlantPageState createState() => _AddPlantPageState();
}

class _AddPlantPageState extends State<AddPlantPage> {
  bool onEdit = false;
  bool _loading = false;
  String _plantType;
  String name;
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
  var _isInit = true;
  final _priceFocusNode = FocusNode();
  final _humidityFocusNode = FocusNode();
  final _descritpionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void didChangeDependencies() {
    if (_isInit) {
      if (widget.id != null) {
        onEdit = true;
        print('Editing...');
        _plant = Provider.of<PlantProvider>(context).findById(widget.id);
        _plantType = _plant.category.toString();
        _initValue = {
          'id': _plant.id,
          'name': _plant.name.toString(),
          'description': _plant.description.toString(),
          'minimal_level_humidity': _plant.minimal_level_humidity.toString(),
          'imageUrl': _plant.imageUrl,
          'category': _plant.category
        };
      }
    }
    _isInit = false;
    print(_initValue['name']);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _priceFocusNode.dispose();
    _descritpionFocusNode.dispose();
    _imageUrlController.dispose();
    _humidityFocusNode.dispose();
    super.dispose();
  }

  Future<void> _savedForm() async {
    final valdit = _formKey.currentState.validate();
    if (!valdit) {
      return;
    }
    setState(() {
      _loading = true;
    });
    _formKey.currentState.save();
    if (onEdit) {
      try {
        await Provider.of<PlantProvider>(context, listen: false)
            .editPlant(_plant.id, _plant);
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
      return;
    }
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
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: Column(
          children: [
            HeaderEditsScreens('Make your plant', size),
            Expanded(
                          child: Padding(
                  padding: const EdgeInsets.only(left:16.0,right: 16,bottom: 16),
                  child: Form(
                    key: _formKey,
                    child: ListView(
                      
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
                        TextFormField(
                          initialValue:
                             onEdit? _initValue['minimal_level_humidity'].substring(0, 2):'',
                          decoration: InputDecoration(
                              labelText: 'Minimal Level of Humidity',
                              suffixText: '%'),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter the plant Humidity';
                            }
                            if (double.parse(value) > 100 ||
                                double.parse(value) < 0) {
                              return 'please enter correct precentage';
                            }
                          },
                          textInputAction: TextInputAction.next,
                          focusNode: _humidityFocusNode,
                          onFieldSubmitted: (_) => FocusScope.of(context)
                              .requestFocus(_descritpionFocusNode),
                          onSaved: (value) {
                            String hum = value.toString() + '%';
                            _plant = PlantModel(
                                id: _plant.id,
                                name: _plant.name,
                                description: _plant.description,
                                minimal_level_humidity: hum,
                                imageUrl: widget.imageUrl,
                                category: _plant.category);
                          },
                        ),
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
                  )),
            ),
          ],
        ));
  }

  Drawer buildDrawer() {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text('Hello'),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home Page'),
            onTap: () => Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (ctx) => ControllerPage())),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text('Orders'),
            onTap: () => Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (ctx) => UploadImageScreen())),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Manage Products'),
            onTap: () {},
          ),
          Divider(),
        ],
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      elevation: 0,
      // leading: IconButton(
      //   icon: SvgPicture.asset("assets/icons/menu.svg"),
      //   onPressed: () {},
      // ),
    );
  }
}
