import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:secondbuy/View/login.dart';

class ForgotPass extends StatefulWidget {
  @override
  _FgtPassPageSate createState() => _FgtPassPageSate();
}

class _FgtPassPageSate extends State<ForgotPass> {
  String _email;

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

  ResetPassword() {
    if (checkFields()) {
      FirebaseAuth.instance.sendPasswordResetEmail(email: _email).then((user) {
        Fluttertoast.showToast(
          msg: "Reset password email has been send",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black45,
        );
      }).catchError((e) {
        print(e);
        Fluttertoast.showToast(
          msg: "Email has not been register",
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
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            }),
      ),
      body: ListView(
        shrinkWrap: true,
        children: <Widget>[
          SizedBox(
            height: 30.0,
          ),
          Container(
            height: 150.0,
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
                child: Center(
                  child: ListView(
                    shrinkWrap: true,
                    children: <Widget>[
                      SizedBox(
                        width: 20.0,
                        height: 30.0,
                      ),
                      _input("required email", false, "Email",
                          'Enter your Email', (value) => _email = value),
                      new Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: <Widget>[
                                SizedBox(height: 15.0),
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: OutlineButton(
                                        child: Text("Reset Password"),
                                        onPressed: ResetPassword,
                                        shape: new RoundedRectangleBorder(
                                            borderRadius:
                                                new BorderRadius.circular(
                                                    30.0)),
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
                                        'Remember your password?',
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
                                        'Login Now!',
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
                                                  LoginPage()),
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
