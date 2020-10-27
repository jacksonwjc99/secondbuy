import 'package:flutter/material.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:carousel_pro/carousel_pro.dart';

import 'package:secondbuy/Util/Components/categories_list.dart';
import 'package:secondbuy/Util/Components/products.dart';

class Homepage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget image_carousel = new Container(
      height: 200.0,
      child: new Carousel(
        boxFit: BoxFit.cover,
        images: [
          AssetImage('images/sell1.jpg'),
          AssetImage('images/sell2.jpg'),
          AssetImage('images/sell3.jpg'),
        ],
        autoplay: true,
        animationCurve: Curves.fastOutSlowIn,
        animationDuration: Duration(milliseconds: 1000),
        dotSize: 3.0,
        indicatorBgPadding: 4.0,
      ),
    );

    return Scaffold(
      //search bar: https://blog.smartnsoft.com/an-automatic-search-bar-in-flutter-flappy-search-bar-a470bc67fa1f
      //body: SafeArea(
      //child: Padding(
      // padding: const EdgeInsets.symmetric(horizontal: 20),
      //child: SearchBar(),
      //),
      // ),
      appBar: new AppBar(
        backgroundColor: Colors.white,
        title: Image.asset('icons/logo.png', fit: BoxFit.cover, scale: 1.5),
        centerTitle: true,
        actions: <Widget>[
          new IconButton(icon: Icon(Icons.search, color: Colors.black,), onPressed: (){})
        ],
      ),
      body: new ListView(
        children: <Widget>[
          //show slide
          image_carousel,

          //show categories text
          new Padding(
            padding: const EdgeInsets.all(10.0),
            child: new Text('Categories'),
          ),

          //horizontal list view for all categories
          CategoryList(),

          //show product text
          new Padding(
            padding: const EdgeInsets.all(10.0),
            child: new Text('Recent Products'),
          ),

          Container(
            height: 320.0,
            child: Products(),
          ),
        ],
      ),
    );
  }
}
