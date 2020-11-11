import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:secondbuy/Util/Global.dart';
import 'package:secondbuy/View/reviewDetail.dart';

class MyReviews extends StatefulWidget {

  @override
  _MyReviewsState createState() => _MyReviewsState();
}

class _MyReviewsState extends State<MyReviews> {
  @override
  Widget build(BuildContext context) {

    return Container(
      child: FutureBuilder<List<String>>(
        future: getPurchaseList(),
        builder: (BuildContext context, AsyncSnapshot reviewListSnapshot) {
          if (reviewListSnapshot.connectionState != ConnectionState.done)
            return Global.Loading("Loading");
          print(reviewListSnapshot.data);
          if (reviewListSnapshot.data.isEmpty) {
            return Global.Message("You haven't purchase anything", 20, Icons.info, 30, Colors.blue);
          }
          else{
            //Purchase list not empty
            return StreamBuilder(
                stream: FirebaseDatabase.instance.reference().child("products").onValue,
                builder: (BuildContext context, AsyncSnapshot<Event> snapshot) {

                  if (snapshot.hasData) {
                    Map<dynamic, dynamic> map = snapshot.data.snapshot.value;
                    //remove any product that is not purchased by the buyer
                    map.removeWhere((key, value) => !reviewListSnapshot.data.toString().contains(value['id']));

                    //remove any product that is not in review status
                    map.removeWhere((key, value) => value['status'].toString().contains("selling"));


                    if (map.values.isNotEmpty) {
                      return GridView.builder(
                          itemCount: map.values.toList().length,
                          gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 1,
                            mainAxisSpacing: 1,
                            childAspectRatio: 3/1,

                          ),
                          itemBuilder: (BuildContext context, int index) {
                            return single_prod(
                              product_id: map.values.toList()[index]['id'],
                              product_name: map.values.toList()[index]['name'],
                              product_photoURL: map.values.toList()[index]['prodImg'].values.toList()[0]['image'],
                              product_price: map.values.toList()[index]['price'],
                              product_review: map.values.toList()[index]['review'],
                              product_rating: map.values.toList()[index]['rating'],
                              product_status: map.values.toList()[index]['status'],
                            );
                          });
                    }
                    else {
                      return Global.Message("You haven't review anything", 20, Icons.error, 30, Colors.red);
                    }

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

  //Load purchase List
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

  Widget ReviewListButton() {
    return Container(
      child: OutlineButton(
        child: Text("Sell Now"),
        onPressed: (){

        },
        shape: new RoundedRectangleBorder(
            borderRadius:
            new BorderRadius.circular(
                30.0)),
        borderSide: BorderSide(
          style: BorderStyle.solid,
          width: 1,
        ),
      ),
    );
  }


}

// Product widget
class single_prod extends StatelessWidget {
  final product_id;
  final product_name;
  final product_photoURL;
  final product_price;
  final product_review;
  final product_rating;
  final product_status;

  single_prod({
    this.product_id,
    this.product_name,
    this.product_photoURL,
    this.product_price,
    this.product_review,
    this.product_rating,
    this.product_status,
  });


  @override
  Widget build(BuildContext context) {

    return Container(
      height: 100,
      child: Card(
        child: Hero(
          tag: product_id,
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ReviewItem(prodID : product_id, prodName: product_name, prodPic: product_photoURL, prodStatus: product_status, prodReview: product_review, prodPrice: double.parse(product_price.toString()), prodRating: int.parse(product_rating == null? 3.toString() : product_rating),)),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                child: Row (
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Image.network(product_photoURL, fit: BoxFit.cover,),
                    SizedBox(
                      width:10,
                    ),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            product_name,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            product_review == null? "You have not review the product yet" : product_review,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

}

