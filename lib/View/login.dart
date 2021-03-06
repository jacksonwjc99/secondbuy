import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:secondbuy/Util/Global.dart';
import 'package:secondbuy/View/forgotPassword.dart';
import 'package:secondbuy/View/nav.dart';
import 'package:secondbuy/View/signup.dart';
import 'package:firebase_database/firebase_database.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageSate createState() => _LoginPageSate();
}

class _LoginPageSate extends State<LoginPage> {
  String _email;
  String _password;
  String cuuid, email, mobile;

  final formkey = new GlobalKey<FormState>();

  _getRequests() async {}

  checkFields() {
    final form = formkey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  LoginUser() {
    if (checkFields()) {
      FirebaseAuth.instance
          .signInWithEmailAndPassword(email: _email, password: _password)
          .then((user) {
        print("signed in as ${user.user.uid}");
        Global.useruid = user.user.uid;
        Global.username = user.user.displayName;
        print("!!!!!!" + Global.useruid);

        final userRef =
        FirebaseDatabase().reference().child("users").child(user.user.uid);
        userRef.update({
          'password': _password,
        });

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Nav(page: "Hamepage")),
        );
        Fluttertoast.showToast(
          msg: "Login Successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black45,
        );
      }).catchError((e) {
        print(e);
        Fluttertoast.showToast(
          msg: "Invalid Email or Password",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black45,
        );
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
                MaterialPageRoute(builder: (context) => Nav(page: "Hamepage")),
              );
            }),
      ),
      body: ListView(
        shrinkWrap: true,
        children: <Widget>[
          Container(
            height: 120.0,
            width: 120.0,
            child: Image.asset(
              'icons/logo2.png',
              scale: 0.5,
            ),
          ),
          //borderRadius: BorderRadius.only(
          //bottomLeft: Radius.circular(500.0),
          //bottomRight: Radius.circular(500.0)),

          Center(
            child: Padding(
              padding: const EdgeInsets.all(28.0),
              child: Center(
                  child: Form(
                key: formkey,
                child: ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    SizedBox(
                      width: 20.0,
                      height: 10.0,
                    ),
                    SizedBox(
                      width: 20.0,
                      height: 10.0,
                    ),
                    _input("required email", false, "Email", 'Enter your Email',
                        (value) => _email = value),
                    SizedBox(
                      width: 20.0,
                      height: 10.0,
                    ),
                    _input("required password", true, "Password", 'Password',
                        (value) => _password = value),
                    new Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  InkWell(
                                    child: Text(
                                      'Forgot Password?',
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
                                            builder: (context) => ForgotPass()),
                                      );
                                    },
                                  )
                                ],
                              ),
                              SizedBox(height: 15.0),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: OutlineButton(
                                      child: Text("Login"),
                                      onPressed: LoginUser,
                                      shape: new RoundedRectangleBorder(
                                          borderRadius:
                                              new BorderRadius.circular(30.0)),
                                      borderSide: BorderSide(
                                        style: BorderStyle.solid,
                                        width: 1,
                                      ),
                                    ),
                                    flex: 1,
                                  ),
                                ],
                              ),
                              SizedBox(height: 70.0),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  InkWell(
                                    child: Text(
                                      'Do not have an account?',
                                      style: TextStyle(
                                        fontFamily: 'Montserrat',
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(height: 10.0),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  InkWell(
                                    child: Text(
                                      'Sign Up Now!',
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
                                            builder: (context) => SignUpPage()),
                                      );
                                    },
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )),
            ),
          ),
        ],
      ),
    );
  }

  Widget _input(String validation, bool, String label, String hint, save) {
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
    );
  }
}

class PageTwo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //somewhere
    Navigator.pop(context, true);
  }
}
