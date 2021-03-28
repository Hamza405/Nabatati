import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:planet_app/screens/admin%20page/edit_plants.dart';
import 'package:provider/provider.dart';
import 'constants.dart';
import 'provider/planet_provider.dart';
import 'screens/admin page/admin_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<PlantProvider>(
          create:(ctx)=> PlantProvider(),
          child:MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: kBackgroundColor,
          primaryColor: kPrimaryColor,
          textTheme: Theme.of(context).textTheme.apply(bodyColor: kTextColor),
          // visualDensity: VisualDensity.adaptivePlatformDensity,

        ),
        routes: {
          'a': (ctx)=>AddPlantPage()
        },
        home: AdminPage(),
      ),
    );
  }
}
