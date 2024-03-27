import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lapo_rider/assistantMethod/get_current_location.dart';
import 'package:lapo_rider/global/global.dart';
import 'package:lapo_rider/maps/map_utils.dart';
import 'package:lapo_rider/splashScreen/splash_screen.dart';

class FoodDeliveryScreen extends StatefulWidget 
{
  String? purchaserId;
  String? purchaserAddress;
  double? purchaserLat;
  double? purchaserLng;
  String? sellerId;
  String? getOrderId;

  FoodDeliveryScreen({
    this.purchaserId,
    this.purchaserAddress,
    this.purchaserLat,
    this.purchaserLng,
    this.sellerId,
    this.getOrderId,
  });


  @override
  State<FoodDeliveryScreen> createState() => _FoodDeliveryScreenState();
}



class _FoodDeliveryScreenState extends State<FoodDeliveryScreen> 
{
  String orderTotalAmount = "";

  confirmFoodHasBeenDelivered(getOrderId, sellerId, purchaserId, purchaserAddress, purchaserLat, purchaserLng)
  {
    String riderNewTotalEarningAmount = ((num.parse(previousRiderEarnings)) + (num.parse(perFoodDeliveryAmount))).toString();

    FirebaseFirestore.instance
        .collection("orders")
        .doc(getOrderId).update({
      "status": "ended",
      "address": completeAddress,
      "lat": position!.latitude,
      "lng": position!.longitude,
      "earnings": perFoodDeliveryAmount, // <-- (pay per food delivery amount)
    }).then((value)
    {
       FirebaseFirestore.instance
        .collection("riders")
        .doc(sharedPreferences!.getString("uid"))
        .update(
          {
            "earnings": riderNewTotalEarningAmount, // <-- total earnings amount of riders
          });
    }).then((value){
       FirebaseFirestore.instance
        .collection("sellers")
        .doc(widget.sellerId)
        .update(
          {
            "earnings": (double.parse(orderTotalAmount) + (double.parse(previousEarnings))).toString(), // <-- total earnings amount of sellers
          });
    }).then((value)
    {
      FirebaseFirestore.instance
      .collection("users")
      .doc(purchaserId)
      .collection("orders")
      .doc(getOrderId).update(
        {
          "status": "ended",
          "riderUID": sharedPreferences!.getString("uid"),
        });
      
    });

    Navigator.push(context, MaterialPageRoute(builder: (c)=> const MySplashScreen()));

     //purchaserId: purchaserId,
      //purchaserAddress: purchaserAddress,
      //purchaserLat: purchaserLat,
      //purchaserLng: purchaserLng,
      //sellerId: sellerId,
      //getOrderId: getOrderId,
  }

  getOrderTotalAmount()
  {
    FirebaseFirestore.instance
        .collection("orders")
        .doc(widget.getOrderId)
        .get()
        .then((snap)
    {
      orderTotalAmount = snap.data()!["totalAmount"].toString();
      widget.sellerId = snap.data()!["sellerUID"].toString();
    }).then((value)
      {
        getSellerData();
      });
  }

  getSellerData()
  {
      FirebaseFirestore.instance
        .collection("sellers")
        .doc(widget.sellerId)
        .get()
        .then((snap)
        {
          previousEarnings = snap.data()!["earnings"].toString();
        });
  }

  @override
  void initState() {
    super.initState();

    //rider location update
    UserLocation uLocation = UserLocation();
    uLocation.getCurrenLocation;

    getOrderTotalAmount();
  }

  @override
  Widget build(BuildContext context) {
       return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "images/images/confirm2.png",
           // width: 350,
          ),

          const SizedBox(height: 5,),

          GestureDetector(
            onTap: ()
            {
              //show location from rider current location towards seller location
              MapUtils.launchMapFromSourceToDestination(position!.latitude, position!.longitude, widget.purchaserLat, widget.purchaserLng);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                
                Image.asset(
                  "images/images/restaurant.png",
                  width: 50,
                ),
                
                const SizedBox(width: 7,),
               
                Column(
                  children: [
                    SizedBox(height: 12,),
          
                    Text(
                      "Show Delivery/Drop-Off Location",
                      style: TextStyle(
                        fontFamily: "Signatra",
                        fontSize: 18,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
              
              ],
            ),
          ),
        
          const SizedBox(height: 40,),

          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Center(
              child: InkWell(
                onTap: ()
                {
                  //rider location update
                  UserLocation uLocation = UserLocation();
                  uLocation.getCurrenLocation;

                  //confirmed that rider has picked food from seller
                  confirmFoodHasBeenDelivered(
                    widget.getOrderId, 
                    widget.sellerId, 
                    widget.purchaserId, 
                    widget.purchaserAddress, 
                    widget.purchaserLat, 
                    widget.purchaserLng
                  );
                  
                },
                child: Container(
                    decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                      Colors.amber,
                      Color.fromARGB(255, 0, 143, 12),
                      ],
                      begin: FractionalOffset(0.0, 0.0),
                      end: FractionalOffset(0.0, 0.0),
                      stops: [0.0, 1.0],
                      tileMode: TileMode.clamp,
                    )
                  ),
                  width: MediaQuery.of(context).size.width - 90,
                  height: 50,
                  child: const Center(
                    child: Text(
                      "Order has been Delivered - Confirm",
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ),
                ),
              ),
            ),
          ),
        
        ],
      ),
    );
  }
}