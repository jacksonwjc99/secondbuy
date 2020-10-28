import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';

import 'main.dart';

class product_details extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
          style: TextStyle(color: Colors.black,),
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
      body: new ListView(
        children: <Widget>[
          Divider(color: Colors.black),
          //show slide
          image_carousel,
          Container(

          ),
        ],
      ),
    );
  }
}
