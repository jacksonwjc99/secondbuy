import 'package:flutter/material.dart';
import 'package:secondbuy/View/nav.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Nav(),
    );
  }
}
