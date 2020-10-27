import 'package:flutter/material.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';

class Homepage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //search bar: https://blog.smartnsoft.com/an-automatic-search-bar-in-flutter-flappy-search-bar-a470bc67fa1f
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SearchBar(),
        ),
      ),
    );
  }
}