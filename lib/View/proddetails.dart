import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';

import 'main.dart';

class ProdDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double c_width = MediaQuery.of(context).size.width*0.94;

    Widget image_carousel = new Container(
      height: 280.0,
      child: new Carousel(
        boxFit: BoxFit.cover,
        images: [
          Image.asset('images/bicycle1.jpg'),
          Image.asset('images/fan1.jpg'),
          Image.asset('images/earphone1.jpg'),
        ],
        autoplay: true,
        autoplayDuration: Duration(seconds: 8),
        animationCurve: Curves.fastOutSlowIn,
        animationDuration: Duration(milliseconds: 1000),
        dotSize: 3.0,
        indicatorBgPadding: 4.0,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Product Name',
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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => App()),
              );
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
                        'Random product',
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
                        'RM 100',
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
                        'New',
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
                        'This is a nice product This is a nice product This is a nice product This is a nice product This is a nice product This is a nice product This is a nice product This is a nice product This is a nice product This is a nice product ',
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
                        'Meetup at Kuala Lumpur',
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
                        'Jackson',
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
}
