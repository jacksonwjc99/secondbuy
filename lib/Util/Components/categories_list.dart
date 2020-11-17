import 'package:flutter/material.dart';
import 'package:secondbuy/Util/Components/products.dart';
import 'package:secondbuy/View/proddetails.dart';
import 'package:secondbuy/View/productpage.dart';

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
            image_caption: 'Electrical Appliances',
            category: '',
            subCategory: 'appliances',
          ),
          Category(
            image_location: 'icons/computer.png',
            image_caption: 'Computers',
            category: '',
            subCategory: 'computer',
          ),
          Category(
            image_location: 'icons/smartphone-call.png',
            image_caption: 'Mobiles and Tablets',
            category: '',
            subCategory: 'phones',
          ),
          Category(
            image_location: 'icons/audio.png',
            image_caption: 'Audio',
            category: '',
            subCategory: 'audio',
          ),
          Category(
            image_location: 'icons/tv.png',
            image_caption: 'TV, Audio and Video',
            category: '',
            subCategory: 'tv',
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
            subCategory: 'shoes',
          ),
          Category(
            image_location: 'icons/watches.png',
            image_caption: 'Watches and Fashion Accessories',
            category: '',
            subCategory: 'accessories',
          ),
          Category(
            image_location: 'icons/bags.png',
            image_caption: 'Bags and Luggages',
            category: '',
            subCategory: 'bags',
          ),
          Category(
            image_location: 'icons/furniture.png',
            image_caption: 'Furnitures and Decoration',
            category: '',
            subCategory: 'furniture',
          ),
          Category(
            image_location: 'icons/sports.png',
            image_caption: 'Sports and Outdoors',
            category: 'sports',
            subCategory: '',
          ),
          Category(
            image_location: 'icons/hobby.png',
            image_caption: 'Hobbies and Collectibles',
            category: 'toysgames',
            subCategory: '',
          ),
          Category(
            image_location: 'icons/book.png',
            image_caption: 'Books and Magazine',
            category: 'stationery',
            subCategory: '',
          ),
          Category(
            image_location: 'icons/music.png',
            image_caption: 'Music and Games',
            category: 'toysgames',
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

  @override
  Widget build(BuildContext context) {
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
                    ))),
          );
        },
        child: Container(
          width: 90.0,
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
