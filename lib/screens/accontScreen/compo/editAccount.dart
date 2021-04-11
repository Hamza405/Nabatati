import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:planet_app/model/userModel.dart';
import 'package:planet_app/provider/planet_provider.dart';
import 'package:provider/provider.dart';

import '../accountScreen.dart';
import 'accountScreenHeadr.dart';

class EditAccountScreen extends StatefulWidget {
  final UserModel user;
  EditAccountScreen(this.user);
  @override
  _EditAccountScreenState createState() => _EditAccountScreenState();
}

class _EditAccountScreenState extends State<EditAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneNumberFocusNode = FocusNode();
  bool _loading=false;
  UserModel _newUser = UserModel(
    databaseId: '',
    userId: '',
    name: '',
    phoneNumber: '',
    email: ''
  );

  Future<void> savedForm()async{
    final valdit = _formKey.currentState.validate();
    if (!valdit) {
      return;
    }
    setState(() {
      _loading=true;
    });
    _formKey.currentState.save();
    try{
    await Provider.of<PlantProvider>(context,listen: false).editUserInfo(_newUser.databaseId, _newUser);
     setState(() {
      _loading=false;
    });
    }catch(e){
      
      setState(() {
      _loading=false;
    });
    throw e;
    }
  }
   @override
  void dispose() {
    _phoneNumberFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
          body: Column(
        children: [
          HeaderAccountScreen('Edit my Account', size),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.all(15),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  TextFormField(
                    initialValue: widget.user.name,
                    decoration: InputDecoration(
                      labelText: 'Your Name',
                    ),
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please Enter your name';
                      }
                      return null;
                    },
                    onFieldSubmitted: (_) => FocusScope.of(context)
                        .requestFocus(_phoneNumberFocusNode),
                    onSaved: (value){
                      _newUser = UserModel(
                        databaseId: widget.user.databaseId,
                        name: value,
                        phoneNumber: widget.user.phoneNumber,
                        email: widget.user.email,
                        userId: widget.user.userId
                      );
                      print(_newUser.name);
                    },
                  
                  ),
                  TextFormField(
                    initialValue: widget.user.phoneNumber,
                    decoration: InputDecoration(
                      labelText: 'Your phone number',
                    ),
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter your phone number';
                      }
                      return null;
                    },
                    textInputAction: TextInputAction.done,
                    focusNode: _phoneNumberFocusNode,
                    onSaved: (value){
                      _newUser = UserModel(
                        databaseId: widget.user.databaseId,
                        name: _newUser.name,
                        phoneNumber: value.toString(),
                        email: widget.user.email,
                        userId: widget.user.userId
                        
                      );
                    },
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  _loading?Center(child:CircularProgressIndicator()): Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      FlatButton(
                        color: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          onPressed: () async{
                            try{
                              await savedForm();
                              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx)=>AccountScreen()));
                            }catch(e){
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
                          child: Text('Save')),
                      FlatButton(
                        color: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Cancel')),
                    ],
                  )
                ],
              ),
            ),
          ))
        ],
      ),
    );
  }
}
