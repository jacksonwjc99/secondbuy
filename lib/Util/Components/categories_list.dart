import 'package:flutter/material.dart';

class CategoryList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130.0,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          Category(
            image_location: 'icons/washing-machine.png',
            image_caption: 'Electrical Appliances',
          ),
          Category(
            image_location: 'icons/computer.png',
            image_caption: 'Computers',
          ),
          Category(
            image_location: 'icons/smartphone-call.png',
            image_caption: 'Mobiles and Tablets',
          ),
          Category(
            image_location: 'icons/tv.png',
            image_caption: 'TV, Audio and Video',
          ),
          Category(
            image_location: 'icons/mens.png',
            image_caption: "Men's",
          ),
          Category(
            image_location: 'icons/womens.png',
            image_caption: "Women's",
          ),
          Category(
            image_location: 'icons/shoes.png',
            image_caption: 'Shoes',
          ),
          Category(
            image_location: 'icons/watches.png',
            image_caption: 'Watches and Fashion Accessories',
          ),
          Category(
            image_location: 'icons/bags.png',
            image_caption: 'Bags and Luggages',
          ),
          Category(
            image_location: 'icons/furniture.png',
            image_caption: 'Furnitures and Decoration',
          ),
          Category(
            image_location: 'icons/sports.png',
            image_caption: 'Sports and Outdoors',
          ),
          Category(
            image_location: 'icons/hobby.png',
            image_caption: 'Hobbies and Collectibles',
          ),
          Category(
            image_location: 'icons/book.png',
            image_caption: 'Books and Magazine',
          ),
          Category(
            image_location: 'icons/music.png',
            image_caption: 'Music and Games',
          ),
          Category(
            image_location: 'icons/ticket.png',
            image_caption: 'Tickets and Vouchers',
          ),
          Category(
            image_location: 'icons/vehicle.png',
            image_caption: 'Vehicles',
          ),
          Category(
            image_location: 'icons/properties.png',
            image_caption: 'Properties',
          ),
        ],
      ),
    );
  }
}

class Category extends StatelessWidget {
  final String image_location;
  final String image_caption;

  Category({this.image_location, this.image_caption});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: InkWell(
        onTap: () {},
        child: Container(
          width: 120.0,
          child: ListTile(
            title: Image.asset(
              image_location,
              width: 70.0,
              height: 70.0,
            ),
            subtitle: Container(
              margin: const EdgeInsets.only(top: 10.0),
              child: Text(
                image_caption,
                style: TextStyle(fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
