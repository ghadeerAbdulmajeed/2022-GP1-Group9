import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rasd/shared/LocalString.dart';
import 'package:rasd/Splash.dart';
import 'package:rasd/shared/GlobalColors.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  // This widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      translations: LocalString(),
      locale: Locale('en', 'US'),
      debugShowCheckedModeBanner: false,
      title: 'Flutter', //what does this mean??
      theme: ThemeData(
          primaryColor: GlobalColors.mainColorGreen,
          scaffoldBackgroundColor: Colors.white,
          unselectedWidgetColor: GlobalColors.mainColorGreen,
          fontFamily: 'Tajawal'),
      home: Splash(),
    );
  }
}
