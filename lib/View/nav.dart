import 'package:flutter/material.dart';
import 'package:secondbuy/View/profile.dart';
import 'package:secondbuy/View/home.dart';
import 'package:secondbuy/View/sell.dart';
import 'package:secondbuy/View/chat.dart';

class Nav extends StatefulWidget {
  Nav({Key key, this.page}) : super(key: key);
  String page;

  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Nav> {
  Future<bool> _onBackPressed() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit an App'),
            actions: <Widget>[
              new GestureDetector(
                onTap: () => Navigator.of(context).pop(false),
                child: Text("NO"),
              ),
              SizedBox(
                height: 16,
                width: 20,
              ),
              new GestureDetector(
                onTap: () => Navigator.of(context).pop(true),
                child: Text("YES"),
              ),
              SizedBox(
                height: 16,
                width: 20,
              ),
            ],
          ),
        ) ??
        false;
  }

  int _currentIndex = 0;

  final List<Widget> _children = [Homepage(), Chat(), Sell(), Profile()];

  void checkPage() {
    if (widget.page == "Homepage") {
      onTabTapped(0);
    } else if (widget.page == "Chat") {
      onTabTapped(1);
    } else if (widget.page == "Sell") {
      onTabTapped(2);
    } else if (widget.page == "Profile") {
      onTabTapped(3);
    }
    widget.page = null;
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.page != null) {
      checkPage();
    }

    return new WillPopScope(
      onWillPop: _onBackPressed,
      child: new Scaffold(
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
      ),
    );
  }
}
