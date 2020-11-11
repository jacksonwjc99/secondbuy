import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:firebase_database/firebase_database.dart';

class ProdDetails extends StatefulWidget {
  ProdDetails({Key key, @required this.prodID}) : super(key : key);
  final String prodID;

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProdDetails> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseDatabase.instance.reference().child("products").child(widget.prodID).onValue,
      builder: (BuildContext context, AsyncSnapshot<Event> snapshot) {
        if (snapshot.hasData) {
          Map<dynamic, dynamic> map = snapshot.data.snapshot.value;

          double c_width = MediaQuery.of(context).size.width*0.94;

          Widget image_carousel = new Container(
            height: 280.0,
            child: new Carousel(
              boxFit: BoxFit.cover,
              images: [
                Image.network(map.values.toList()[0].values.toList()[0]['image']),
              ],
              autoplay: true,
              autoplayDuration: Duration(seconds: 8),
              animationCurve: Curves.fastOutSlowIn,
              animationDuration: Duration(milliseconds: 1000),
              dotSize: 3.0,
              indicatorBgPadding: 4.0,
            ),
          );

          //0 - image id
          //1 - address
          //2 - rating
          //3 - sellerName
          //4 - condition
          //5 - sellerID
          //6 - dealopt
          //7 - price
          //8 review
          //9 - name
          //10 - purchasedDate
          //11 - details
          //12 - fav
          //13 - locaiton
          //14 - sellDate
          //15 - prodID
          //16 - category
          //17 - reply
          //18 - subcategory
          //19 - status

          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              title: Text(
                map.values.toList()[9],
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              centerTitle: true,
              elevation: 0,
              automaticallyImplyLeading: true,
              leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
            ),
            body: SingleChildScrollView(
              child: new Column(
                children: <Widget>[
                  Divider(color: Colors.black),
                  //show slide
                  image_carousel,
                  Row(
                    children: <Widget>[
                      new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          //Product
                          new Container(
                            padding: const EdgeInsets.only(left: 20.0, bottom: 10.0, top: 20.0),
                            child: new Text(
                              'About the Product',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                          ),

                          new Container(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: new Text(
                              'Product Name',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          new Container(
                            padding: const EdgeInsets.only(left: 30.0),
                            width: c_width,
                            child: new Text(
                              map.values.toList()[9],
                            ),
                          ),
                          SizedBox(height: 30.0),

                          new Container(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: new Text(
                              'Price',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          new Container(
                            padding: const EdgeInsets.only(left: 30.0),
                            width: c_width,
                            child: new Text(
                              map.values.toList()[7].toString(),
                            ),
                          ),
                          SizedBox(height: 30.0),

                          new Container(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: new Text(
                              'Upload Time',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          new Container(
                            padding: const EdgeInsets.only(left: 30.0),
                            width: c_width,
                            child: new Text(
                              'Just Now',
                              style: TextStyle(fontStyle: FontStyle.italic),
                            ),
                          ),
                          SizedBox(height: 30.0),

                          new Container(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: new Text(
                              'Condition',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          new Container(
                            padding: const EdgeInsets.only(left: 30.0),
                            width: c_width,
                            child: new Text(
                              map.values.toList()[4].toString(),
                            ),
                          ),
                          SizedBox(height: 30.0),

                          new Container(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: new Text(
                              'Product Description',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          new Container(
                            padding: const EdgeInsets.only(left: 30.0),
                            width: c_width,
                            child: new Text(
                              map.values.toList()[11].toString(),
                              textAlign: TextAlign.justify,
                            ),
                          ),
                          SizedBox(height: 30.0),

                          //deal option
                          new Container(
                            padding: const EdgeInsets.only(left: 20.0, bottom: 10.0),
                            child: new Text(
                              'Getting This',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                          ),

                          new Container(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: new Text(
                              'Deal Option',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          new Container(
                            padding: const EdgeInsets.only(left: 30.0),
                            width: c_width,
                            child: new Text(
                                map.values.toList()[6].toString() + " at " + map.values.toList()[1].toString(),
                            ),
                          ),
                          SizedBox(height: 30.0),

                          //seller details
                          new Container(
                            padding: const EdgeInsets.only(left: 20.0, bottom: 10.0),
                            child: new Text(
                              'About the Seller',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                          ),

                          new Container(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: new Text(
                              'Seller Name',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          new Container(
                            padding: const EdgeInsets.only(left: 30.0),
                            width: c_width,
                            child: new Text(
                              map.values.toList()[3].toString(),
                            ),
                          ),
                          SizedBox(height: 20.0),
                        ],
                      ),
                    ],
                  ),
                  Divider(color: Colors.black),
                  Row(
                    children: <Widget>[
                      Expanded(
                          child:  new IconButton(icon: Icon(Icons.favorite_border, color: Colors.black,), onPressed: (){})
                      ),

                      Expanded(
                        child: OutlineButton(
                          child: Text("Chat"),
                          onPressed: (){},
                          shape: new RoundedRectangleBorder(
                              borderRadius:
                              new BorderRadius.circular(
                                  30.0)),
                          borderSide: BorderSide(
                            style: BorderStyle.solid,
                            width: 1,
                          ),
                        ),
                        flex: 1,
                      ),
                      SizedBox(width: 20.0),
                      Expanded(
                        child: OutlineButton(
                          child: Text("Make Offers"),
                          onPressed: (){},
                          shape: new RoundedRectangleBorder(
                              borderRadius:
                              new BorderRadius.circular(
                                  30.0)),
                          borderSide: BorderSide(
                            style: BorderStyle.solid,
                            width: 1,
                          ),
                        ),
                        flex: 1,
                      ),
                      SizedBox(width: 20.0),
                    ],
                  ),
                ],
              ),
            ),
          );
        }
        else {
          return CircularProgressIndicator();
        }
      }
    );
  }
}


