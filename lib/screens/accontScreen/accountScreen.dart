import 'package:flutter/material.dart';
import 'package:planet_app/provider/planet_provider.dart';
import 'package:provider/provider.dart';

import 'compo/accountScreenHeadr.dart';
import 'compo/editAccount.dart';

class AccountScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
          width: double.infinity,
          height: size.height - MediaQuery.of(context).padding.top,
          child: SingleChildScrollView(
            child: Column(
              children: [
                HeaderAccountScreen('My Account',size),
                FutureBuilder(
                    future: Provider.of<PlantProvider>(context,listen: false).getUserInfo(),
                    builder: (context, dataSnapShot) {
                      if (dataSnapShot.connectionState ==
                          ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }
                      else if (dataSnapShot.error != null) {
                        return Center(
                            child: Text('Somethings wrong please try again!'));
                      } else{
                      return Consumer<PlantProvider>(
                        builder: (context, data, _) => Padding(
                          padding: const EdgeInsets.all(25),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: 100,
                                      height: 100,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          color: Colors.lightBlue[800],
                                          image: DecorationImage(
                                              image: AssetImage(
                                                  'assets/images/profile.png'),
                                              fit: BoxFit.fill)),
                                    ),
                                    IconButton(
                                        icon: Icon(Icons.edit), onPressed: () {
                                          Navigator.of(context).push(MaterialPageRoute(builder: (ctx)=>EditAccountScreen(data.user)));
                                        },color: Theme.of(context).primaryColor,)
                                  ],
                                ),
                                Divider(),
                                SizedBox(height: 30,),
                                Text(
                                  data.user.name,
                                  style: TextStyle(fontSize: 30),
                                ),
                                
                                SizedBox(
                                  height: 25,
                                ),
                                ListTile(
                                  title: Text(data.user.email,
                                    style: TextStyle(fontSize: 25)),
                                    trailing: Icon(Icons.mail,color: Theme.of(context).primaryColor,),
                                ),
                                
                                SizedBox(
                                  height: 15,
                                ),
                                ListTile(
                                  leading:  Text(data.user.phoneNumber,
                                    style: TextStyle(fontSize: 25)),
                                    trailing: Icon(Icons.phone,color: Theme.of(context).primaryColor,),
                                )
                               
                              ],
                            ),
                          ),
                        ),
                      );
                      }
                    }),
              ],
            ),
          )),
    );
  }
}
