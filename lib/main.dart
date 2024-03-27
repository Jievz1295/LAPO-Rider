import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:lapo_rider/global/global.dart';
import 'package:lapo_rider/splashScreen/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future <void> main() async
{
  WidgetsFlutterBinding.ensureInitialized();

  sharedPreferences =  await SharedPreferences.getInstance();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);

  runApp(const MyApp());
}




class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LAPO Riders App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MySplashScreen(),
    );
  }
}