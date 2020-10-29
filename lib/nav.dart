import 'package:flutter/material.dart';
import 'package:secondbuy/profile.dart';
import 'package:secondbuy/home.dart';
import 'package:secondbuy/sell.dart';
import 'package:secondbuy/chat.dart';


class Nav extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Nav> {
  int _currentIndex = 0;
  final List<Widget> _children = [Homepage(), Chat(), Sell(), Profile()];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      // new
      //nav bar: https://willowtreeapps.com/ideas/how-to-use-flutter-to-build-an-app-with-bottom-navigation
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: onTabTapped, // new
        currentIndex: _currentIndex, // new
        items: [
          new BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          new BottomNavigationBarItem(
            icon: Icon(Icons.message),
            title: Text('Messages'),
          ),
          new BottomNavigationBarItem(
            icon: Icon(Icons.add),
            title: Text('Sell'),
          ),
          new BottomNavigationBarItem(
              icon: Icon(Icons.person), title: Text('Profile'))
        ],
      ),
    );
  }
}
