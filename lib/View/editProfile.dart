import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:secondbuy/View/changePassword.dart';
import 'package:imgur/imgur.dart' as imgur;
import 'package:secondbuy/View/nav.dart';

class EditProfile extends StatefulWidget {
  EditProfile({Key key, @required this.id}) : super(key: key);
  final String id;

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  String _address;
  String _username;
  String _contact;
  int _value = 1;

  final FirebaseAuth auth = FirebaseAuth.instance;

  final formkey = new GlobalKey<FormState>();

  checkFields() {
    final form = formkey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  var username, address, contact, email, password, id, photoURL;
  var i = 0;

  getUserDetails() {
    try {
      FirebaseDatabase.instance
          .reference()
          .child("users")
          .child(widget.id)
          .once()
          .then((DataSnapshot snapshot) {
        Map<dynamic, dynamic> userDB = snapshot.value;
        if (i == 0) {
          setState(() {
            username = userDB['username'];
            address = userDB['address'];
            contact = userDB['contact'];
            email = userDB['email'];
            password = userDB['password'];
            photoURL = userDB['photoURL'];
            id = userDB['id'];
          });
          i++;
        }
      });
    } catch (e) {
      print(e);
    }
  }

  saveEdit() async {
    final FirebaseUser user = await auth.currentUser();
    if (checkFields()) {
      try {
        String imgURL;
        if (_image != null) {
          await client.image
              .uploadImage(
                imageFile: _image,
              )
              .then((image) => imgURL = image.link);
        } else {
          imgURL = photoURL;
        }

        //update displayName
        UserUpdateInfo updateUser = UserUpdateInfo();
        updateUser.displayName = _username;
        updateUser.photoUrl = imgURL;
        user.updateProfile(updateUser);

        final userRef =
            FirebaseDatabase().reference().child("users").child(widget.id);
        userRef.update({
          'address': _address.isEmpty ? address : _address,
          'contact': _contact.isEmpty ? contact : _contact,
          'username': _username.isEmpty ? username : _username,
          'photoURL': imgURL,
        });

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Nav(page: "Profile")),
        );
        Fluttertoast.showToast(
          msg: "Profile details has been updated",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black45,
        );
      } catch (e) {
        print(e);
      }
    }
  }

  File _image;
  final picker = ImagePicker();
  final client =
      imgur.Imgur(imgur.Authentication.fromClientId('e91a824722e23b9'));

  @override
  Widget build(BuildContext context) {
    getUserDetails();

    return new Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          'Edit Profile',
          style: TextStyle(color: Colors.black),
        ),
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
              MaterialPageRoute(builder: (context) => Nav(page: "Profile")),
            );
          },
        ),
      ),
      body: ListView(
        shrinkWrap: true,
        children: <Widget>[
          Center(
            child: Padding(
              padding: const EdgeInsets.all(28.0),
              child: Center(
                  child: new Form(
                key: formkey,
                child: Center(
                  child: new Column(
                    children: <Widget>[
                      new Text(
                        "Profile Details",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      SizedBox(
                        width: 20.0,
                        height: 20.0,
                      ),
                      Container(
                        child: _image == null
                            ? Container(
                                height: 250.0,
                                width: 250.0,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: NetworkImage(photoURL == null
                                          ? "https://icon-library.com/images/default-profile-icon/default-profile-icon-16.jpg"
                                          : photoURL),
                                      fit: BoxFit.fitHeight,
                                    ),
                                    shape: BoxShape.rectangle,
                                    border: Border.all(
                                        color: Colors.black45, width: 2)),
                              )
                            : Container(
                                height: 250.0,
                                width: 250.0,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: FileImage(_image),
                                      fit: BoxFit.fitHeight,
                                    ),
                                    shape: BoxShape.rectangle,
                                    border: Border.all(
                                        color: Colors.black45, width: 2)),
                              ),
                      ),
                      ImageButton(),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        'Current username: $username',
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      _charInput(
                          "required username",
                          false,
                          "New Username",
                          'Enter your new Username',
                          (value) => _username = value,
                          TextInputType.text),
                      SizedBox(
                        width: 20.0,
                        height: 20.0,
                      ),
                      Text(
                        'Current contact: $contact',
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      _contactInput(
                          "required contact number",
                          false,
                          "New Contact",
                          'Enter your new Contact',
                          (value) => _contact = value,
                          TextInputType.phone),
                      SizedBox(
                        width: 20.0,
                        height: 20.0,
                      ),
                      Text(
                        'Current address: $address',
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      _addressInput(
                          "required address",
                          false,
                          "New Address",
                          'Enter your new Address',
                          (value) => _address = value,
                          TextInputType.text),
                      Center(
                        child: Padding(
                          padding: EdgeInsets.only(left: 138.0, top: 8.0),
                          child: Row(
                            children: <Widget>[
                              OutlineButton(
                                child: Text("Save"),
                                onPressed: saveEdit,
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          InkWell(
                            child: Text(
                              'Change Password?',
                              style: TextStyle(
                                color: Colors.blue,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ChangePassword(id: widget.id)),
                              );
                            },
                          )
                        ],
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

  Widget ImageButton() {
    return Row(
      children: <Widget>[
        Expanded(
          child: OutlineButton(
            child: Text("Upload Image"),
            onPressed: () {
              getImage();
            },
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0)),
            borderSide: BorderSide(
              style: BorderStyle.solid,
              width: 1,
            ),
          ),
          flex: 1,
        ),
      ],
    );
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Widget _addressInput(
      String validation, bool, String label, String hint, save, keyboard) {
    return new TextFormField(
      decoration: InputDecoration(
        hintText: hint,
        labelText: label,
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 20.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
      ),
      obscureText: bool,
      validator: (value) {
        String errMsg;
        if (value.isNotEmpty) {
          Pattern pattern = r'^[a-zA-Z0-9 ,.-:&]*$';
          RegExp regex = new RegExp(pattern);
          if (!regex.hasMatch(value))
            errMsg = 'Invalid Address';
          else
            return null;
        }
        return errMsg;
      },
      onSaved: save,
      keyboardType: keyboard,
    );
  }

  Widget _charInput(
      String validation, bool, String label, String hint, save, keyboard) {
    return new TextFormField(
      decoration: InputDecoration(
        hintText: hint,
        labelText: label,
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 20.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
      ),
      obscureText: bool,
      validator: (value) {
        String errMsg;
        if (value.isNotEmpty) {
          Pattern pattern = r'^[a-zA-Z ]*$';
          RegExp regex = new RegExp(pattern);
          if (!regex.hasMatch(value))
            errMsg = 'Username must be letter & space only';
          else
            return null;
        }
        return errMsg;
      },
      onSaved: save,
      keyboardType: keyboard,
    );
  }

  Widget _contactInput(
      String validation, bool, String label, String hint, save, keyboard) {
    return new TextFormField(
      decoration: InputDecoration(
        hintText: hint,
        labelText: label,
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 20.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
      ),
      obscureText: bool,
      validator: (value) {
        String errMsg;
        if (value.isNotEmpty) {
          Pattern pattern = r'^[0-9]{10,11}$';
          RegExp regex = new RegExp(pattern);
          if (!regex.hasMatch(value))
            errMsg = 'Contact must be within 10 or 11 digits';
          else
            return null;
        }
        return errMsg;
      },
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
