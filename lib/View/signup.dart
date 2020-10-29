//https://github.com/dvmjoshi/stuff

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:secondbuy/View/login.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignupPageSate createState() => _SignupPageSate();
}

class _SignupPageSate extends State<SignUpPage> {
  String _email;
  String _password;
  String _username;
  String _contact;
  int _value = 1;

  List<ListItem> _dropdownItems = [
    ListItem(1, "Johor"),
    ListItem(2, "Kedah"),
    ListItem(3, "Kelantan"),
    ListItem(4, "Melacca"),
    ListItem(5, "Negeri Sembilan"),
    ListItem(6, "Pahang"),
    ListItem(7, "Penang"),
    ListItem(8, "Perak"),
    ListItem(9, "Sabah"),
    ListItem(10, "Sarawak"),
    ListItem(11, "Selangor"),
    ListItem(12, "Terengganu"),
    ListItem(13, "Kuala Lumpur"),
    ListItem(14, "Labuan"),
    ListItem(15, "Putrajaya"),
  ];

  List<DropdownMenuItem<ListItem>> _dropdownMenuItems;
  ListItem _selectedItem;

  void initState() {
    super.initState();
    _dropdownMenuItems = buildDropDownMenuItems(_dropdownItems);
    _selectedItem = _dropdownMenuItems[0].value;
  }

  List<DropdownMenuItem<ListItem>> buildDropDownMenuItems(List listItems) {
    List<DropdownMenuItem<ListItem>> items = List();
    for (ListItem listItem in listItems) {
      items.add(
        DropdownMenuItem(
          child: Text(listItem.name),
          value: listItem,
        ),
      );
    }
    return items;
  }

  final formkey = new GlobalKey<FormState>();

  checkFields() {
    final form = formkey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  createUser() async {
    if (checkFields()) {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: _email, password: _password)
          .then((user) {
        print('signed in as ${"user.uid"}');

        Navigator.of(context).pop();
        Navigator.of(context).pushNamed('/userpage');
      }).catchError((e) {
        print(e);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: true,
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
            );
          },
        ),
      ),
      body: ListView(
        shrinkWrap: true,
        children: <Widget>[
          Container(
            height: 100.0,
            width: 100.0,
            child: Image.asset(
              'icons/logo2.png',
              scale: 0.5,
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(28.0),
              child: Center(
                  child: new Form(
                key: formkey,
                child: Center(
                  child: new ListView(
                    shrinkWrap: true,
                    children: <Widget>[
                      _input(
                          "required email",
                          false,
                          "Email",
                          'Enter your Email',
                          (value) => _email = value,
                          TextInputType.text),
                      SizedBox(
                        width: 20.0,
                        height: 20.0,
                      ),
                      _input(
                          "required username",
                          false,
                          "Username",
                          'Enter your Username',
                          (value) => _username = value,
                          TextInputType.text),
                      SizedBox(
                        width: 20.0,
                        height: 20.0,
                      ),
                      _input(
                          "required password",
                          true,
                          "Password",
                          'Enter your Password',
                          (value) => _password = value,
                          TextInputType.text),
                      SizedBox(
                        width: 20.0,
                        height: 20.0,
                      ),
                      _input(
                          "required contact number",
                          false,
                          "Contact No.",
                          'Enter your Contact',
                          (value) => _contact = value,
                          TextInputType.phone),
                      SizedBox(
                        width: 20.0,
                        height: 20.0,
                      ),

                      Container(
                        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            border: Border.all(width: 0.5)),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                              value: _selectedItem,
                              items: _dropdownMenuItems,
                              onChanged: (value) {
                                setState(() {
                                  _selectedItem = value;
                                });
                              }),
                        ),
                      ),
                      Center(
                        child: Padding(
                          padding: EdgeInsets.only(left: 138.0, top: 8.0),
                          child: Row(
                            children: <Widget>[
                              OutlineButton(
                                child: Text("Sign Up"),
                                onPressed: createUser,
                                shape: new RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(30.0)),
                                borderSide: BorderSide(
                                  style: BorderStyle.solid,
                                  width: 1,
                                ),
                              ),
                              SizedBox(
                                height: 18.0,
                                width: 18.0,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )),
            ),
          ),
        ],
      ),
    );
  }

  Widget _input(
      String validation, bool, String label, String hint, save, keyboard) {
    return new TextFormField(
      decoration: InputDecoration(
        hintText: hint,
        labelText: label,
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 20.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
      ),
      obscureText: bool,
      validator: (value) => value.isEmpty ? validation : null,
      onSaved: save,
      keyboardType: keyboard,
    );
  }
}

class ListItem {
  int value;
  String name;

  ListItem(this.value, this.name);
}

class CustomContainer extends StatelessWidget {
  final String labelText;
  final BoxDecoration decoration;

  const CustomContainer({this.labelText, this.decoration});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          height: 80,
        ),
        Positioned(
          bottom: 0,
          child: Container(width: 250, height: 50, decoration: decoration),
        ),
        Positioned(
          left: 10,
          bottom: 40,
          child: Container(color: Colors.white, child: Text(labelText)),
        )
      ],
    );
  }
}
