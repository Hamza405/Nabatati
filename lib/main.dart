import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:planet_app/controle_page.dart';
import 'package:planet_app/model/plantModel.dart';
import 'package:planet_app/screens/admin%20page/edit_plants.dart';
import 'package:planet_app/screens/settings_screen/compo/settings_screen.dart';
import 'package:planet_app/screens/splashScreen/splashScreen.dart';
import 'package:provider/provider.dart';
import 'constants.dart';
import 'provider/planet_provider.dart';
import 'screens/admin page/admin_page.dart';
import 'screens/auth screen/auth_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
          providers:[ ChangeNotifierProvider<PlantProvider>(
            create:(ctx)=> PlantProvider(),
          ),
          ChangeNotifierProvider<PlantModel>(
           create:(ctx)=> PlantModel(), 
          )

          ],
            child:Consumer<PlantProvider>(
                          builder:(ctx,auth,_)=> MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              scaffoldBackgroundColor: kBackgroundColor,
              primaryColor: kPrimaryColor,
              textTheme: Theme.of(context).textTheme.apply(bodyColor: kTextColor),
              // visualDensity: VisualDensity.adaptivePlatformDensity,

          ),
          home: auth.isAuth ? ControllerPage() 
                :FutureBuilder(
                  future: auth.autoLogin(),
                  builder: (ctx,dataSnapShot)=>dataSnapShot.connectionState==ConnectionState.waiting?SplashScreen():AuthScreen(),
                ),
        ),
            ),
      );
    
  }
}
