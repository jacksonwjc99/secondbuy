import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:secondbuy/Util/Global.dart';

class MyPurchase extends StatefulWidget {

  @override
  _MyPurchaseState createState() => _MyPurchaseState();
}

class _MyPurchaseState extends State<MyPurchase> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder<List<String>>(
        future: getPurchaseList(),
        builder: (BuildContext context, AsyncSnapshot purchaseListSnapshot) {
          if (purchaseListSnapshot.connectionState != ConnectionState.done)
            return Global.Loading("Loading");
          print(purchaseListSnapshot.data);
          if (purchaseListSnapshot.data.isEmpty) {
            return Global.Message("Your Purchase History is empty", 20, Icons.info, 30, Colors.blue);
          }
          else{
            //Purchase list not empty
            return StreamBuilder(
                stream: FirebaseDatabase.instance.reference().child("products").onValue,
                builder: (BuildContext context, AsyncSnapshot<Event> snapshot) {

                  if (snapshot.hasData) {
                    Map<dynamic, dynamic> map = snapshot.data.snapshot.value;
                    map.removeWhere((key, value) => !purchaseListSnapshot.data.toString().contains(value['id']));


                    return GridView.builder(
                        itemCount: map.values.toList().length,
                        gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          return single_prod(
                            product_id: map.values.toList()[index]['id'],
                            product_name: map.values.toList()[index]['name'],
                            product_photoURL: map.values.toList()[index]['prodImg'].values.toList()[0]['image'],
                            product_price: map.values.toList()[index]['price'],
                          );
                        });
                  }
                  else {
                    return Global.Loading("Loading your purchase list");
                  }
                }
            );
          }
        },
      ),
    );
  }

  Future<List<String>> getPurchaseList() async {
    var purchaseDb = FirebaseDatabase.instance.reference().child("users").child(Global.useruid).child("purchases");

    return purchaseDb.once().then((DataSnapshot snapshot) {
      List<String> purchaseList = new List();

      if(snapshot.value != null) {
        try{
          snapshot.value.forEach((key, value) {

            Map<dynamic, dynamic> purchases = value;
            purchaseList.add(purchases.values.toList()[0]);
          });

        } on NoSuchMethodError catch (e) {
          print(e.stackTrace);
        }
        return new List.from(purchaseList);
      }
      else {
        return new List.from(purchaseList);
      }

    });
  }

}

// Product widget
class single_prod extends StatelessWidget {
  final product_id;
  final product_name;
  final product_photoURL;
  final product_price;

  single_prod({
    this.product_id,
    this.product_name,
    this.product_photoURL,
    this.product_price,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Hero(
        tag: product_id,
        child: Material(
          child: InkWell(
            onTap: () {
              // do something
            },
            child: GridTile(
              footer: Container(
                color: Colors.white70,
                child: ListTile(
                  leading: Text(
                    product_name,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  title: Text(
                    "RM $product_price",
                    textAlign: TextAlign.right,
                  ),
                ),
              ),
              child: Image.network(product_photoURL, fit: BoxFit.cover),
              //child: Text("HELLO"),
            ),
          ),
        ),
      ),
    );
  }


}

