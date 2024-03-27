import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lapo_rider/authentication/auth_screen.dart';
import 'package:lapo_rider/global/global.dart';
import 'package:lapo_rider/mainScreen/home_screen.dart';

class MySplashScreen extends StatefulWidget {
  const MySplashScreen({Key? key}) : super(key: key);

  @override
  State<MySplashScreen> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MySplashScreen> 
{
  startTimer()  
  {

    Timer(const Duration(seconds: 4), () async 
    {
        //if the rider is already logged in   
         if(firebaseAuth.currentUser != null)
         {
            Navigator.push(context, MaterialPageRoute(builder: (c) => const HomeScreen()));
         }
         // if the rider not logged in
         else
         {
            Navigator.push(context, MaterialPageRoute(builder: (c) => const AuthScreen()));
         }
    });
  }

  @override
  void initState() {
    super.initState();

    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
          color: Colors.white,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Image.asset("images/images/riders.png"),
                ),
                
                const SizedBox(height: 10,),

                const Padding(
                  padding: EdgeInsets.all(18.0),
                  child: Text(
                    "The Great Chosen For Delivery",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black54,
                      fontFamily: "Signatra",
                      fontSize: 40,
                      letterSpacing: 3,
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
