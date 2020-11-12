import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:secondbuy/Model/Contact.dart';
import 'package:secondbuy/Model/Message.dart';
import 'package:secondbuy/Util/Global.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Chatting extends StatefulWidget{
  Chatting({Key key, @required this.contactID, @required this.contactName, @required this.contactPic, @required this.prodID}) : super(key : key);
  final String contactID;
  final String contactName;
  final String contactPic;
  final String prodID;

  _ChattingState createState() => _ChattingState();
}

class _ChattingState extends State<Chatting> {
  double price;
  String messageInput;

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final msgController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  var uid;
  var i = 0;
  final FirebaseAuth auth = FirebaseAuth.instance;

  void getUserID() async {
    final FirebaseUser user = await auth.currentUser();
    if (i == 0) {
      setState(() {
        uid = user.uid;
      });
      i++;
    }
  }

  @override
  Widget build(BuildContext context) {
    getUserID();

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.attach_money),
            color:Colors.white,
            onPressed: () {
              ShowOfferWidget();
            },
          )
        ],
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(widget.contactPic),
              backgroundColor: Colors.white,
              radius: 15,
            ),
            SizedBox(
              width: 10,
            ),
            Text(widget.contactName),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: <Widget>[
            Expanded(
              child: FutureBuilder<List<Message>>(
                future: GetMessage(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState != ConnectionState.done)
                    return Global.Loading("Loading your chat with seller");

                  if (!snapshot.hasData) {
                    return new Container (
                      child: Text(
                        "No Contacts Found",
                      ),
                    );
                  }

                  FirebaseDatabase.instance.reference().child("chats").child(widget.contactID).onChildChanged.listen((event) {setState(() {
                    //refresh the chat onchange
                  });});

                  return ListView.builder(
                    reverse: true,
                    shrinkWrap: true,
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      Message msg = snapshot.data[index];

                      if(msg.type == "send") {
                        return Column(
                          children: <Widget>[
                            Container(
                              alignment: Alignment.topRight,
                              child: Container(
                                constraints: BoxConstraints(
                                  maxWidth: MediaQuery
                                      .of(context)
                                      .size
                                      .width * 0.8,
                                ),
                                padding: EdgeInsets.all(8),
                                margin: EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  color: Theme
                                      .of(context)
                                      .primaryColor,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 1.5,
                                      blurRadius: 5,
                                    )
                                  ],
                                ),
                                child: Text(
                                  msg.message,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                      else {
                        return Column(
                          children: <Widget>[
                            Container(
                              alignment: Alignment.topLeft,
                              child: Container(
                                constraints: BoxConstraints(
                                  maxWidth: MediaQuery
                                      .of(context)
                                      .size
                                      .width * 0.8,
                                ),
                                padding: EdgeInsets.all(8),
                                margin: EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 1.5,
                                      blurRadius: 5,
                                    )
                                  ],
                                ),
                                child: Text(
                                    msg.message,
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                    }
                  );
                }
              ),
            ),
            SendMsgArea(),
          ],
        ),
      ),
    );
  }

  Widget SendMsgArea() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8),
      height: 50,
      color: Colors.white,
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: msgController,
              decoration: InputDecoration.collapsed(
                hintText: "Send a message ..",
              ),
              textCapitalization: TextCapitalization.sentences,
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            iconSize: 25,
            color: Theme.of(context).primaryColor,
            onPressed: () {
              SendMessage(msgController.text);
              msgController.clear();
            },
          )
        ],
      ),
    );
  }

  Future<List<Message>> GetMessage() async{
    var chatRef = FirebaseDatabase.instance.reference().child("chats").child(uid).child(widget.contactID);
    List<Message> message = new List();

    return chatRef.once().then((DataSnapshot snapshot){
      try{
        snapshot.value.forEach((key, value){
          print(snapshot.value['msg']);
          message.add(new Message(
            message: value['msg'],
            type: value['method'],
            key: key,
          ));
        });

      } on NoSuchMethodError catch (e) {
        print(e.stackTrace);
      }

      //sort the message
      message.sort((a,b) => b.key.compareTo(a.key));

      return new List.from(message);

    });

  }

  SendMessage(String msg) async{
    var send = FirebaseDatabase.instance.reference().child("chats").child(uid).child(widget.contactID);
    var receive = FirebaseDatabase.instance.reference().child("chats").child(widget.contactID).child(uid);

    if(msg != "") {
      send.push().set({
        'msg' : msg,
        'method' : 'send'
      });

      receive.push().set({
        'msg' : msg,
        'method' : 'receive',
      });
    }

    setState(() {

    });

  }

  MakeOffer(String productID) {
    print(productID);
    var offerRef = FirebaseDatabase.instance.reference().child("offer");
    print("RM " + price.toString());
    offerRef.push().set({
      'buyer': uid,
      'seller' : widget.contactID,
      'prodID' : productID == null ? widget.prodID : productID,
      'price' : price,
      'status' : 'waiting',
    });
  }

  ReplyOffer(String choice) {
    var offerRef = FirebaseDatabase.instance.reference().child("offer");
    var productRef = FirebaseDatabase.instance.reference().child("products");
    var userRef = FirebaseDatabase.instance.reference().child("users");

    DateFormat df = DateFormat('yyyy-MM-dd HH:mm:ss');
    DateTime dateNow = df.parse(DateTime.now().toString());

    offerRef.once().then((DataSnapshot snapshot) {
      snapshot.value.forEach((key, value) {
        if(uid == value['seller'] && widget.contactID == value['buyer'] && value['status'] == "waiting" && choice == "accept") {


          // update offer status
          offerRef.child(key).update({
            'status' : 'accepted'
          });

          //update user purchase list
          userRef.child(value['buyer']).child('purchases').push().set({
            'productID' : value['prodID'],
          });

          // update product status to sold
          productRef.child(value['prodID']).update({
            'status' : 'sold',
            'purchasedDate' : dateNow.toString(),
          });

        }
        else {
          offerRef.child(key).update({
            'status' : 'rejected'
          });
        }
      });
    });

  }

  ShowOfferWidget() async{
    var offerRef = FirebaseDatabase.instance.reference().child("offer");
    bool isSeller = false;
    bool isBuyer = false;
    String offerStatus;
    String productID;
    double offeredPrice;

    await offerRef.once().then((DataSnapshot snapshot) {
      if(snapshot.value == null) {
        print("No snapshot value");
      }
      else {
        snapshot.value.forEach((key, value) {
          if(uid == value['seller'] && widget.contactID == value['buyer'] && value['status'] == 'waiting'){
            isSeller = true;
            productID = value['prodID'];
            offeredPrice = double.parse(value['price'].toString());
          }
          else if (uid == value['buyer'] && widget.contactID == value['seller']){
            isBuyer = true;
            productID = value['prodID'];
            offerStatus = value['status'];
            offeredPrice = double.parse(value['price'].toString());
          }
        });
      }
    });

    print(isSeller.toString() + isBuyer.toString());

    showModalBottomSheet(context: context, builder: (BuildContext builder) {
      if ((widget.prodID == null || widget.prodID == "") && isBuyer == false && isSeller == false) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.8,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.minimize),
                        iconSize: 25,
                      ),
                      Icon(
                        Icons.error,
                        size: 30,
                        color: Colors.red,
                      ),
                      SizedBox(
                        height:10,
                      ),
                      Text(
                        "No product is selected. No offer is received at the moment",
                        style: TextStyle(
                          fontSize: 20,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }
      else if (widget.prodID != "" && widget.prodID != null || (isSeller == false && isBuyer == true) || (isSeller == true && isBuyer == false)){
        if(isSeller == true && isBuyer == false){
          return Container(
            height: MediaQuery.of(context).size.height * 0.8,
            child: Form(
              key: _formKey,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          IconButton(
                            icon: Icon(Icons.minimize),
                            iconSize: 25,
                          ),
                          ListView(
                            shrinkWrap: true,
                            children: <Widget>[
                              Text(
                                  "Seller has offered RM " + offeredPrice.toString() + " for the product",
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              OutlineButton(
                                child: Text("Accept"),
                                onPressed: (){
                                  _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('You accepted the offer')));
                                  ReplyOffer("accept");
                                },
                                shape: new RoundedRectangleBorder(
                                    borderRadius:
                                    new BorderRadius.circular(
                                        30.0)),
                                borderSide: BorderSide(
                                  style: BorderStyle.solid,
                                  width: 1,
                                ),
                              ),
                              OutlineButton(
                                child: Text("Reject"),
                                onPressed: (){
                                  _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('You rejected the offer')));
                                  ReplyOffer("reject");
                                },
                                shape: new RoundedRectangleBorder(
                                    borderRadius:
                                    new BorderRadius.circular(
                                        30.0)),
                                borderSide: BorderSide(
                                  style: BorderStyle.solid,
                                  width: 1,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        else{
          return Container(
            height: MediaQuery.of(context).size.height * 0.8,
            child: Form(
              key: _formKey,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          IconButton(
                            icon: Icon(Icons.minimize),
                            iconSize: 25,
                          ),
                          ListView(
                            shrinkWrap: true,
                            children: <Widget>[
                              Text(
                                  "Enter the price to make an offer with the seller. Noted that seller might accept/reject your offer"
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              TextFormField(
                                decoration: InputDecoration(
                                  hintText: "Enter a price",
                                  labelText: "Price to offer",
                                  contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 20.0),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
                                ),
                                keyboardType: TextInputType.number,
                                obscureText: false,
                                validator: (value) => value.isEmpty ? "Please enter a price" : null,
                                onSaved: (value) => price = double.parse(value),
                              ),
                              Text(
                                offerStatus == "rejected" ? "Seller has rejected your offer" : "",
                                style: TextStyle(
                                  color: Colors.red,
                                ),
                              ),
                              Text(
                                offerStatus == "accepted" ? "Seller has accepted your offer" : "",
                                style: TextStyle(
                                  color: Colors.green,
                                ),
                              ),
                              OutlineButton(
                                child: Text("Offer Now"),
                                onPressed: (){
                                  if (_formKey.currentState.validate()) {
                                    if(offerStatus == "rejected" || offerStatus == null){
                                      _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('Price is sent to seller')));
                                      print(_formKey.currentState.validate());
                                      _formKey.currentState.save();
                                      MakeOffer(productID);
                                    }
                                    else if (offerStatus == "accepted") {
                                      _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('Seller already accepted your offer')));
                                    }
                                    else {
                                      _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('Please wait for reply')));
                                    }
                                  }
                                  else{
                                    print(_formKey.currentState.validate());
                                  }
                                },
                                shape: new RoundedRectangleBorder(
                                    borderRadius:
                                    new BorderRadius.circular(
                                        30.0)),
                                borderSide: BorderSide(
                                  style: BorderStyle.solid,
                                  width: 1,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      }
      else{
        return Container(
          height: MediaQuery.of(context).size.height * 0.8,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.minimize),
                        iconSize: 25,
                      ),
                      Icon(
                        Icons.error,
                        size: 30,
                        color: Colors.red,
                      ),
                      SizedBox(
                        height:10,
                      ),
                      Text(
                        "You have not selected any product",
                        style: TextStyle(
                          fontSize: 20,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }

    },isScrollControlled: true);
  }
}