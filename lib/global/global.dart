import 'package:firebase_auth/firebase_auth.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences? sharedPreferences;
FirebaseAuth firebaseAuth = FirebaseAuth.instance;

Position? position;
List<Placemark>? placeMarks;
String completeAddress="";

String perFoodDeliveryAmount="";
String previousEarnings=""; // this is for seller's old total earnings
String previousRiderEarnings=""; // this is for rider's old total earnings
