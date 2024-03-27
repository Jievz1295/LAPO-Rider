import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lapo_rider/assistantMethod/get_current_location.dart';
import 'package:lapo_rider/global/global.dart';
import 'package:lapo_rider/mainScreen/food_delivery_screen.dart';
import 'package:lapo_rider/maps/map_utils.dart';

class FoodPickingScreen extends StatefulWidget 
{
  String? purchaserId;
  String? sellerId;
  String? getOrderID;
  String? purchaserAddress;
  double? purchaserLat;
  double? purchaserLng;

  FoodPickingScreen({
    this.purchaserId,
    this.sellerId,
    this.getOrderID,
    this.purchaserAddress,
    this.purchaserLat,
    this.purchaserLng,
    });

  @override
  State<FoodPickingScreen> createState() => _FoodPickingScreeState();
}

class _FoodPickingScreeState extends State<FoodPickingScreen> 
{
  double? sellerLat, sellerLng;
  getSellerData() async
  {
    FirebaseFirestore.instance
    .collection("sellers")
    .doc(widget.sellerId)
    .get()
    .then((DocumentSnapshot)
    {
      sellerLat = DocumentSnapshot.data()!["lat"];
      sellerLng = DocumentSnapshot.data()!["lng"];

    });
  }

  @override
  void initState() {
    super.initState();

    getSellerData();
  }

  confirmFoodHasBeenPicked(getOrderId, sellerId, purchaserId, purchaserAddress, purchaserLat, purchaserLng)
  {
    FirebaseFirestore.instance
    .collection("orders")
    .doc(getOrderId).update({
      "status": "delivering",
      "address": completeAddress,
      "lat": position!.latitude,
      "lng": position!.longitude,
    });

    Navigator.push(context, MaterialPageRoute(builder: (c)=> FoodDeliveryScreen(
      purchaserId: purchaserId,
      purchaserAddress: purchaserAddress,
      purchaserLat: purchaserLat,
      purchaserLng: purchaserLng,
      sellerId: sellerId,
      getOrderId: getOrderId,
    )));
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "images/images/confirm1.png",
            width: 350,
          ),

          const SizedBox(height: 5,),

          GestureDetector(
            onTap: ()
            {
              //show location from rider current location towards seller location
              MapUtils.launchMapFromSourceToDestination(position!.latitude, position!.longitude, sellerLat, sellerLng);
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
                      "Show Restaurant/Cafe Location",
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
                  UserLocation uLocation = UserLocation();
                  uLocation.getCurrenLocation;

                  //confirmed that rider has picked food from seller
                  confirmFoodHasBeenPicked(
                    widget.getOrderID, 
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
                      "Order has been Picked - Confirmed",
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