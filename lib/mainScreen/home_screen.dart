import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lapo_rider/assistantMethod/get_current_location.dart';
import 'package:lapo_rider/authentication/auth_screen.dart';
import 'package:lapo_rider/global/global.dart';
import 'package:lapo_rider/mainScreen/delivery_in_progress_screen.dart';
import 'package:lapo_rider/mainScreen/earnings_screen.dart';
import 'package:lapo_rider/mainScreen/history_screen.dart';
import 'package:lapo_rider/mainScreen/new_orders_screen.dart';
import 'package:lapo_rider/mainScreen/not_yet_delivered.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> 
{
  Card makeDashboardItem(String title, IconData iconData, int index)
  {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(8),
      child: Container(
         decoration: index == 0 || index == 3 || index == 4 
         ? const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                 Colors.amberAccent,
                  Color.fromARGB(255, 175, 0, 0),
                ],
                begin: FractionalOffset(0.0, 0.0),
                end: FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              )
            ) 
          : const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.amber,
                   Colors.blue,
                ],
                begin: FractionalOffset(0.0, 0.0),
                end: FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              )
            ),
      child: InkWell(
        onTap: ()
          {
            if(index == 0)
            {
              //New Available Orders
              Navigator.push(context, MaterialPageRoute(builder: (c)=> NewOrdersScreen()));
            }
            if(index == 1)
            {
              //Delivery in Progress
              Navigator.push(context, MaterialPageRoute(builder: (c)=> DeliveryInProgressScreen()));
            }
            if(index == 2)
            {
              //Not Yet Delivered
              Navigator.push(context, MaterialPageRoute(builder: (c)=> NotYetDeliveredScreen()));
            }
            if(index == 3)
            {
              //History
              Navigator.push(context, MaterialPageRoute(builder: (c)=> HistoryScreen()));
            }
            if(index == 4)
            {
              //Total Earnings
              Navigator.push(context, MaterialPageRoute(builder: (c)=> EarningsScreen()));
            }
            if(index == 5)
            {
              //Logout
              firebaseAuth.signOut().then((value){
                Navigator.push(context, MaterialPageRoute(builder: (c)=> const AuthScreen()));
              });
            }
           
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            verticalDirection: VerticalDirection.down,
            children: [
              const SizedBox(height: 50,),
              Center(
                child: Icon(
                  iconData,
                  size: 40,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 10,),
              Center(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),   
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    UserLocation uLocation = UserLocation();
    uLocation.getCurrenLocation();
    getPerFoodDeliveryAmount();
    getRiderPreviousEarnings();
  }

  getRiderPreviousEarnings()
  {
    FirebaseFirestore.instance
        .collection("riders")
        .doc(sharedPreferences!.getString("uid"))
        .get()
        .then((snap)
        {
          previousRiderEarnings = snap.data()!["earnings"].toString();
        });

  }

  getPerFoodDeliveryAmount()
  {
    FirebaseFirestore.instance
        .collection("perDelivery")
        .doc("lapoapp")
        .get()
        .then((snap)
    {
      perFoodDeliveryAmount = snap.data()!["amount"].toString();

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                 Colors.white,
                  Color.fromARGB(255, 175, 0, 0),
                ],
                begin: FractionalOffset(1.0, 5.0),
                end: FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              )
            ),
          ),
        title: Text(
          "Welcome, " +
          sharedPreferences!.getString("name")!,
          style: const TextStyle(
            fontSize: 30,
            color: Colors.white,
            fontFamily: "Signatra",
            letterSpacing: 2,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(vertical: 50.0, horizontal: 1.0),
          child: GridView.count(
            crossAxisCount: 2,
            padding: const EdgeInsets.all(2),
            children: [
              makeDashboardItem("New Available Orders", Icons.assessment, 0),
              makeDashboardItem("Delivery in Progress", Icons.delivery_dining, 1),
              makeDashboardItem("Not yet Delivered", Icons.change_circle, 2),
              makeDashboardItem("History", Icons.history, 3),
              makeDashboardItem("Total Earnings", Icons.monetization_on, 4),
              makeDashboardItem("Logout", Icons.logout, 5),
            ],
          ),
        ),
    );
  }
}