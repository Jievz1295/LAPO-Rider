import 'package:flutter/material.dart';
import 'package:lapo_rider/authentication/login.dart';
import 'package:lapo_rider/authentication/register.dart';


class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, 
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                 Colors.cyan,
                  Color.fromARGB(255, 175, 0, 0),
                ],
                begin: FractionalOffset(0.0, 0.0),
                end: FractionalOffset(0.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              )
            ),
          ),
          title: const Text(
            "Riders App",
            style: TextStyle(
              fontSize: 45,
              color: Colors.white,
              fontFamily: "Signatra",

            ),     
          ),
          centerTitle: true,
          bottom: const TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.lock, color: Colors.white,),
                text: "Login",
              ),
              Tab(
                icon: Icon(Icons.person, color: Colors.white,),
                text: "Register",
              )
            ],
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Colors.white,
                Colors.black54,
              ],
            )
          ),
          child: const TabBarView(
            children: [
                LoginScreen(),
                RegisterScreen(),
              ],
          ),
        )
      ),
    );
  }
}
