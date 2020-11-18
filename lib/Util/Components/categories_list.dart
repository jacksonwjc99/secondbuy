import 'package:flutter/material.dart';
import 'package:secondbuy/Util/Components/products.dart';
import 'package:secondbuy/View/productpage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CategoryList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.0,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          Category(
            image_location: 'icons/washing-machine.png',
            image_caption: 'Electronics',
            category: 'electronics',
            subCategory: '',
          ),
          Category(
            image_location: 'icons/computer.png',
            image_caption: 'Computers',
            category: '',
            subCategory: 'Computer and Laptops',
          ),
          Category(
            image_location: 'icons/audio.png',
            image_caption: 'Audio',
            category: '',
            subCategory: 'Audio',
          ),
          Category(
            image_location: 'icons/tv.png',
            image_caption: 'TV and Entertainment Systems',
            category: '',
            subCategory: 'TV and Entertainment Systems',
          ),
          Category(
            image_location: 'icons/smartphone-call.png',
            image_caption: 'Mobile and Gadgets',
            category: 'mobile',
            subCategory: '',
          ),
          Category(
            image_location: 'icons/mens.png',
            image_caption: "Men's",
            category: 'men',
            subCategory: '',
          ),
          Category(
            image_location: 'icons/womens.png',
            image_caption: "Women's",
            category: 'women',
            subCategory: '',
          ),
          Category(
            image_location: 'icons/shoes.png',
            image_caption: 'Shoes',
            category: '',
            subCategory: 'Shoes',
          ),
          Category(
            image_location: 'icons/watches.png',
            image_caption: 'Watches and Fashion Accessories',
            category: '',
            subCategory: 'Accessories',
          ),
          Category(
            image_location: 'icons/bags.png',
            image_caption: 'Bags and Wallets',
            category: '',
            subCategory: 'Bags and Wallets',
          ),
          Category(
            image_location: 'icons/furniture.png',
            image_caption: 'Home and Furniture',
            category: 'furniture',
            subCategory: '',
          ),
          Category(
            image_location: 'icons/sports.png',
            image_caption: 'Sports and Outdoors',
            category: 'sports',
            subCategory: '',
          ),
          Category(
            image_location: 'icons/hobby.png',
            image_caption: 'Toys and Games',
            category: 'toysgames',
            subCategory: '',
          ),
          Category(
            image_location: 'icons/book.png',
            image_caption: 'Books and Stationery',
            category: 'stationery',
            subCategory: '',
          ),
          Category(
            image_location: 'icons/ticket.png',
            image_caption: 'Tickets and Vouchers',
            category: 'ticket',
            subCategory: '',
          ),
          Category(
            image_location: 'icons/vehicle.png',
            image_caption: 'Vehicles',
            category: 'vehicle',
            subCategory: '',
          ),
          Category(
            image_location: 'icons/properties.png',
            image_caption: 'Properties',
            category: 'property',
            subCategory: '',
          ),
        ],
      ),
    );
  }
}

class Category extends StatelessWidget {
  final String image_location;
  final String image_caption;
  final String category;
  final String subCategory;

  Category(
      {this.image_location,
      this.image_caption,
      this.category,
      this.subCategory});

  final FirebaseAuth auth = FirebaseAuth.instance;
  String uid;
  var i = 0;

  getUser() async {
    final FirebaseUser user = await auth.currentUser();
    if (i == 0) {
      uid = user.uid;
      i++;
    }
  }

  @override
  Widget build(BuildContext context) {
    getUser();
    print(uid);
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: InkWell(
        onTap: () {
          print(category + " + " + subCategory);
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProductPage(
                        product: Products(
                      category: category,
                      subCategory: subCategory,
                      id: uid,
                    ))),
          );
        },
        child: Container(
          width: 95.0,
          child: ListTile(
            title: Image.asset(
              image_location,
              width: 50.0,
              height: 50.0,
            ),
            subtitle: Container(
              margin: const EdgeInsets.only(top: 10.0),
              child: Text(
                image_caption,
                style: TextStyle(fontSize: 10),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
