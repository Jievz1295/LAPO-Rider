import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lapo_rider/assistantMethod/assistant_methods.dart';
import 'package:lapo_rider/global/global.dart';
import 'package:lapo_rider/widgets/order_card.dart';
import 'package:lapo_rider/widgets/progress_bar.dart';
import 'package:lapo_rider/widgets/simple_app_bar.dart';


class NotYetDeliveredScreen extends StatefulWidget 
{

  @override
  State<NotYetDeliveredScreen> createState() => _NotYetDeliveredScreenState();
}


class _NotYetDeliveredScreenState extends State<NotYetDeliveredScreen> 
{
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: SimpleAppBar(title: "To be Deliver",),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
          .collection("orders")
          .where("riderUID", isEqualTo: sharedPreferences!.getString("uid"))
          .where("status", isEqualTo: "delivering")
          .snapshots(),
        builder: (c, snapshot)
        {
          return snapshot.hasData 
              ? ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (c, index) 
                {
                  return FutureBuilder<QuerySnapshot>(
                    future: FirebaseFirestore.instance
                        .collection("items")
                        .where("itemID", whereIn: separateOrdersItemIDs((snapshot.data!.docs[index].data()! as Map<String, dynamic>) ["productIDs"]))
                        .orderBy("publishedDate", descending: true)
                        .get(),
                      builder: (c, snap)
                      {
                        return snap.hasData 
                            ? OrderCard(
                          itemCount: snap.data!.docs.length,
                          data: snap.data!.docs,
                          orderID: snapshot.data!.docs[index].id,
                          separateQuantitiesList: separateOrderItemQuantities((snapshot.data!.docs[index].data()! as Map<String, dynamic>)["productIDs"]),
                        ) 
                            : Center(child: circularProgress());
                      },
                  );
                },
              ) 
              : Center(child: circularProgress(),);
         },

        ),
      ));
  }
}