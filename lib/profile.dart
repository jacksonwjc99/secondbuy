import 'package:flutter/material.dart';
import 'package:secondbuy/login.dart';

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Container(
        child: OutlineButton(
          child: Text("Login Now"),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
            );
          },
          shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(30.0)),
          borderSide: BorderSide(
            style: BorderStyle.solid,
            width: 1,
          ),
        ),
      ),
    );
  }
}
