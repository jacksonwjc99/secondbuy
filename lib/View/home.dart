import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:secondbuy/Util/Components/categories_list.dart';
import 'package:secondbuy/Util/Components/products.dart';
import 'package:secondbuy/View/searchSeller.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    Widget image_carousel = new Container(
      height: 170.0,
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
        automaticallyImplyLeading: false,
        title: Image.asset('icons/logo.png', fit: BoxFit.cover, scale: 1.5),
        centerTitle: true,
        actions: <Widget>[
          new IconButton(
              icon: Icon(
                Icons.search,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SearchSeller()),
                );
              })
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          image_carousel,

          new Container(
            padding: const EdgeInsets.all(10.0),
            child: new Text('Categories'),
          ),

          //horizontal list view for all categories
          CategoryList(),

          //show product text
          new Container(
            padding: const EdgeInsets.all(10.0),
            child: new Text('Recent Products'),
          ),

          Expanded(
            child: Products(),
          ),
        ],
      ),

    );
  }
}
