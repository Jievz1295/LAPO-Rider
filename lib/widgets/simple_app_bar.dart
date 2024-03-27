import 'package:flutter/material.dart';

class SimpleAppBar extends StatelessWidget implements PreferredSizeWidget
{
  String? title;

  final PreferredSizeWidget? bottom;
  
  SimpleAppBar({this.bottom, this.title});

  @override
  Size get preferredSize => bottom==null?Size(56, AppBar().preferredSize.height):Size(56, 80+AppBar().preferredSize.height);

  @override
  Widget build(BuildContext context) 
  {
    return AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 206, 14, 14),
                  Colors.amber,
                ],
                begin:  FractionalOffset(0.0, 0.0),
                end:  FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp),
          ),
        ),
        elevation: 0.0,
        centerTitle: true,
        title: Text(
          title!,
          style: TextStyle(fontSize: 45.0, letterSpacing: 1, color: Colors.white, fontFamily: "Signatra"),
        ),
      );
  }
}