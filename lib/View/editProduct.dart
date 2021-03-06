import 'dart:io';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:secondbuy/Util/Global.dart';
import 'package:secondbuy/View/login.dart';
import 'package:secondbuy/View/nav.dart';
import 'package:secondbuy/View/signup.dart';

class EditProduct extends StatefulWidget {
  EditProduct({Key key, @required this.productID}) : super(key: key);
  final String productID;

  @override
  _EditProductState createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  @override
  void initState() {
    super.initState();
  }

  //form key
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final FirebaseAuth auth = FirebaseAuth.instance;

  //List<Asset> images = List<Asset>();

  //input variables
  String prodName;
  double prodPrice;
  String prodDetails;
  String address;
  DateTime saledate;

  //category
//  List<String> _category = ['A', 'B', 'C', 'D'];
//  String _selectedCategory;
//  List<String> _subCategory = ['A', 'B', 'C', 'D'];
//  String _selectedSubCategory;
  String category;
  String subCategory;
  bool disabledDropdown = true;
  List<DropdownMenuItem<String>> menuItems = List();

  final electronics = {
    "1": "Computers and Laptops",
    "2": "Audio",
    "3": "TV and Entertainment Systems",
    "4": "Computer Parts and Accessories",
    "5": "Home Appliances",
    "6": "Others"
  };

  final mobile = {
    "1": "Mobile Phones",
    "2": "Tablets",
    "3": "Wearables",
    "4": "Others",
  };

  final women = {
    "1": "Bags and Wallets",
    "2": "Shoes",
    "3": "Clothes",
    "4": "Accessories",
    "5": "Others",
  };

  final men = {
    "1": "Bags and Wallets",
    "2": "Footwear",
    "3": "Clothes",
    "4": "Accessories",
    "5": "Others",
  };

  final furniture = {
    "1": "Home Decor",
    "2": "Furniture",
    "3": "Others",
  };

  final stationery = {
    "1": "Comics and Manga",
    "2": "Magazines",
    "3": "Education Books",
    "4": "Others",
  };

  final toysgames = {
    "1": "Board Games and Cards",
    "2": "Action Figures and Collectibles",
    "3": "Others",
  };

  final tickets = {
    "1": "Event Tickets",
  };

  final sports = {
    "1": "Sports Equipment",
    "2": "Bicycles",
    "3": "Others",
  };

  final vehicles = {
    "1": "Cars",
    "2": "Motorcycles",
  };

  final property = {
    "1": "Rentals",
    "2": "For Sale",
  };

  void populateElectronics() {
    for (String key in electronics.keys) {
      menuItems.add(DropdownMenuItem<String>(
        value: electronics[key],
        child: Text(electronics[key]),
      ));
    }
  }

  void populateMobile() {
    for (String key in mobile.keys) {
      menuItems.add(DropdownMenuItem<String>(
        value: mobile[key],
        child: Text(mobile[key]),
      ));
    }
  }

  void populateWomen() {
    for (String key in women.keys) {
      menuItems.add(DropdownMenuItem<String>(
        value: women[key],
        child: Text(women[key]),
      ));
    }
  }

  void populateMen() {
    for (String key in men.keys) {
      menuItems.add(DropdownMenuItem<String>(
        value: men[key],
        child: Text(men[key]),
      ));
    }
  }

  void populateFurniture() {
    for (String key in furniture.keys) {
      menuItems.add(DropdownMenuItem<String>(
        value: furniture[key],
        child: Text(furniture[key]),
      ));
    }
  }

  void populateStationery() {
    for (String key in stationery.keys) {
      menuItems.add(DropdownMenuItem<String>(
        value: stationery[key],
        child: Text(stationery[key]),
      ));
    }
  }

  void populateToysGames() {
    for (String key in toysgames.keys) {
      menuItems.add(DropdownMenuItem<String>(
        value: toysgames[key],
        child: Text(toysgames[key]),
      ));
    }
  }

  void populateTickets() {
    for (String key in tickets.keys) {
      menuItems.add(DropdownMenuItem<String>(
        value: tickets[key],
        child: Text(tickets[key]),
      ));
    }
  }

  void populateSports() {
    for (String key in sports.keys) {
      menuItems.add(DropdownMenuItem<String>(
        value: sports[key],
        child: Text(sports[key]),
      ));
    }
  }

  void populateVehicles() {
    for (String key in vehicles.keys) {
      menuItems.add(DropdownMenuItem<String>(
        value: vehicles[key],
        child: Text(vehicles[key]),
      ));
    }
  }

  void populateProperty() {
    for (String key in property.keys) {
      menuItems.add(DropdownMenuItem<String>(
        value: property[key],
        child: Text(property[key]),
      ));
    }
  }

  void valueChanged(_value) {
    if (_value == "electronics") {
      menuItems = [];
      populateElectronics();
    } else if (_value == "mobile") {
      menuItems = [];
      populateMobile();
    } else if (_value == "women") {
      menuItems = [];
      populateWomen();
    } else if (_value == "men") {
      menuItems = [];
      populateMen();
    } else if (_value == "furniture") {
      menuItems = [];
      populateFurniture();
    } else if (_value == "stationery") {
      menuItems = [];
      populateStationery();
    } else if (_value == "toysgames") {
      menuItems = [];
      populateToysGames();
    } else if (_value == "tickets") {
      menuItems = [];
      populateTickets();
    } else if (_value == "sports") {
      menuItems = [];
      populateSports();
    } else if (_value == "vehicles") {
      menuItems = [];
      populateVehicles();
    } else if (_value == "property") {
      menuItems = [];
      populateProperty();
    }
    setState(() {
      category = _value;
      disabledDropdown = false;
    });
  }

  void secondValueChanged(_value) {
    setState(() {
      subCategory = _value;
    });
  }

  //deal option
  String _radioValue = "meetup";

  //condition
  String _radioValue2 = "new";

  var isUserLogin = false;
  var i = 0;
  var j = 0;

  @override
  Widget build(BuildContext context) {
    FirebaseDatabase.instance
        .reference()
        .child("products")
        .child(widget.productID)
        .once()
        .then((DataSnapshot productSnapshot) {
      Map<dynamic, dynamic> products = productSnapshot.value;
      if (j == 0) {
        prodName = products['name'];
        prodPrice = products['price'].toDouble();
        prodDetails = products['details'];
        _radioValue = products['dealopt'];
        _radioValue2 = products['condition'];
        //category = products['category'];
        //subCategory = products['subcategory'];
        address = products['address'];
        saledate = DateTime.parse(products['sellDate']);
        j++;
      }
    });

    auth.currentUser().then((user) {
      if (user != null) {
        if (i == 0) {
          Global.getDBUser().then((dbUser) {
            if (dbUser != null) {
              print("user is logged in");
              setState(() {
                isUserLogin = true;
              });
            }
          });
          i++;
        }
      } else {
        print("guest detected");
        isUserLogin = false;
      }
    });

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          'Edit Product',
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
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView(
        shrinkWrap: true,
        children: <Widget>[
          if (isUserLogin == false) notLogin(),
          if (isUserLogin == true)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Center(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        InputField(
                            "Product Name is required",
                            false,
                            "Product Name",
                            'Product Name',
                            (value) => prodName = value,
                            prodName),
                        SizedBox(
                          width: 20.0,
                          height: 20.0,
                        ),
                        CategoryDropDown("Please select a category"),
                        SizedBox(
                          width: 20.0,
                          height: 20.0,
                        ),
                        SubCategoryDropDown("Please select a subcategory"),
                        SizedBox(
                          width: 20.0,
                          height: 20.0,
                        ),
                        NumberField(
                            "Product Price is required",
                            false,
                            "Product Price",
                            "Product Price",
                            (value) => prodPrice = double.parse(value),
                            prodPrice),
                        SizedBox(
                          width: 20.0,
                          height: 20.0,
                        ),
                        TextArea(
                            "Product Details is required",
                            false,
                            "Product Details",
                            "Product Details",
                            (value) => prodDetails = value,
                            prodDetails),
                        SizedBox(
                          width: 20.0,
                          height: 10.0,
                        ),
                        Condition(),
                        SizedBox(
                          width: 20.0,
                          height: 10.0,
                        ),
                        DealOption(),
                        AddressField(
                            "Meetup Address is required",
                            false,
                            "Meetup Address",
                            "Meetup Address",
                            (value) => address = value,
                            address),
                        SizedBox(
                          width: 20.0,
                          height: 10.0,
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: OutlineButton(
                                child: Text("Update"),
                                onPressed: () {
                                  if (_formKey.currentState.validate()) {
                                    _scaffoldKey.currentState.showSnackBar(
                                        SnackBar(
                                            content:
                                                Text('Updating your product')));
                                    print(_formKey.currentState.validate());
                                    _formKey.currentState.save();
                                    UpdatingProduct();
                                  } else {
                                    print(_formKey.currentState.validate());
                                  }
                                },
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
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

//  Widget buildGridView() {
//    return GridView.count(
//      crossAxisCount: 3,
//      children: List.generate(images.length, (index) {
//        Asset asset = images[index];
//        return AssetThumb(
//          asset: asset,
//          width: 300,
//          height: 300,
//        );
//      }),
//    );
//  }

  // load multiple image
//  Future<void> loadAssets() async {
//    List<Asset> resultList = List<Asset>();
//    String error = 'No Error Dectected';
//
//    try {
//      resultList = await MultiImagePicker.pickImages(
//        maxImages: 300,
//        enableCamera: true,
//        selectedAssets: images,
//      );
//    } on Exception catch (e) {
//      error = e.toString();
//    }
//
//    if (!mounted) return;
//
//    setState(() {
//      images = resultList;
//      _error = error;
//    });
//  }

  Widget notLogin() {
    return Container(
      margin: const EdgeInsets.only(top: 250.0),
      child: InkWell(
        child: Text(
          "Login now to view more",
          textAlign: TextAlign.center,
          style: TextStyle(fontStyle: FontStyle.italic, fontSize: 25),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
        },
      ),
    );
  }

  // Creating widgets for form
  Widget InputField(
      String valMsg, bool, String label, String hint, save, initialValue) {
    return new TextFormField(
      initialValue: initialValue,
      decoration: InputDecoration(
        hintText: hint,
        labelText: label,
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 20.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
      ),
      obscureText: bool,
      validator: (value) => value.isEmpty ? valMsg : null,
      onSaved: save,
    );
  }

  Widget AddressField(
      String valMsg, bool, String label, String hint, save, initialValue) {
    return new TextFormField(
      initialValue: initialValue,
      decoration: InputDecoration(
        enabled: false,
        hintText: hint,
        labelText: label,
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 20.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
      ),
      obscureText: bool,
      validator: (value) =>
          value.isEmpty && _radioValue == "meetup" ? valMsg : null,
      onSaved: save,
    );
  }

  Widget NumberField(
      String valMsg, bool, String label, String hint, save, initialValue) {
    return new TextFormField(
      initialValue: initialValue.toString(),
      decoration: InputDecoration(
        hintText: hint,
        labelText: label,
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 20.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
      ),
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        WhitelistingTextInputFormatter.digitsOnly
      ],
      obscureText: bool,
      validator: (value) => value.isEmpty ? valMsg : null,
      onSaved: save,
    );
  }

  Widget CategoryDropDown(String valMsg) {
    return Container(
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          side: BorderSide(
              width: 1.0, style: BorderStyle.solid, color: Colors.grey),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: DropdownButtonHideUnderline(
          child: DropdownButtonFormField<String>(
            validator: (value) => value == null ? valMsg : null,
            //isExpanded: false,
            hint: Text(
              "Select a category",
            ),
            value: category,
            onChanged: (_value) => () {
              subCategory = null;
              valueChanged(_value);
            }(),
            items: [
              DropdownMenuItem<String>(
                value: "electronics",
                child: Text("Electronics"),
              ),
              DropdownMenuItem<String>(
                value: "mobile",
                child: Text("Mobile and Gadgets"),
              ),
              DropdownMenuItem<String>(
                value: "women",
                child: Text("Women's Fashion"),
              ),
              DropdownMenuItem<String>(
                value: "men",
                child: Text("Men's Fashion"),
              ),
              DropdownMenuItem<String>(
                value: "furniture",
                child: Text("Home and Furniture"),
              ),
              DropdownMenuItem<String>(
                value: "stationery",
                child: Text("Books and Stationery"),
              ),
              DropdownMenuItem<String>(
                value: "toysgames",
                child: Text("Toys and Games"),
              ),
              DropdownMenuItem<String>(
                value: "tickets",
                child: Text("Tickets and Vouchers"),
              ),
              DropdownMenuItem<String>(
                value: "sports",
                child: Text("Sports"),
              ),
              DropdownMenuItem<String>(
                value: "vehicles",
                child: Text("Vehicles"),
              ),
              DropdownMenuItem<String>(
                value: "property",
                child: Text("Property"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget SubCategoryDropDown(String valMsg) {
    return Container(
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          side: BorderSide(
              width: 1.0, style: BorderStyle.solid, color: Colors.grey),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: DropdownButtonHideUnderline(
          child: DropdownButtonFormField<String>(
            validator: (value) => value == null ? valMsg : null,
            //isExpanded: false,
            hint: Text("Select a category"),
            disabledHint: Text(
              "Select category first",
            ),
            value: subCategory,
            onChanged: disabledDropdown
                ? null
                : (_value) => secondValueChanged(_value),
            items: menuItems,
          ),
        ),
      ),
    );
  }

  Widget DealOption() {
    return Row(
      children: <Widget>[
        new Radio(
          value: "meetup",
          groupValue: _radioValue,
          onChanged: _handleRadioValueChange,
        ),
        new Text(
          'Meetup',
          style: new TextStyle(fontSize: 16.0),
        ),
        new Radio(
          value: "delivery",
          groupValue: _radioValue,
          onChanged: _handleRadioValueChange,
        ),
        new Text(
          'Delivery',
          style: new TextStyle(fontSize: 16.0),
        ),
      ],
    );
  }

  Widget Condition() {
    return Row(
      children: <Widget>[
        new Radio(
          value: "new",
          groupValue: _radioValue2,
          onChanged: _handleRadioValueChange2,
        ),
        new Text(
          'New',
          style: new TextStyle(fontSize: 16.0),
        ),
        new Radio(
          value: "used",
          groupValue: _radioValue2,
          onChanged: _handleRadioValueChange2,
        ),
        new Text(
          'Used',
          style: new TextStyle(fontSize: 16.0),
        ),
      ],
    );
  }

  void _handleRadioValueChange(String opt) {
    setState(() {
      _radioValue = opt;

      switch (_radioValue) {
        case "meetup":
          print(3);
          break;
        case "delivery":
          print(4);
          break;
      }
    });
    print(1);
  }

  void _handleRadioValueChange2(String opt) {
    setState(() {
      _radioValue2 = opt;

      switch (_radioValue2) {
        case "new":
          print(5);
          break;
        case "used":
          print(6);
          break;
      }
    });
    print(2);
  }

  Widget TextArea(
      String valMsg, bool, String label, String hint, save, initialValue) {
    return new TextFormField(
      initialValue: initialValue,
      decoration: InputDecoration(
        hintText: hint,
        labelText: label,
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 20.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
      ),
      maxLines: 10,
      obscureText: bool,
      validator: (value) => value.isEmpty ? valMsg : null,
      onSaved: save,
    );
  }

  // adding product to firebase
  Future<FirebaseUser> UpdatingProduct() async {
    final FirebaseUser user = await auth.currentUser();
    var productDb = FirebaseDatabase.instance
        .reference()
        .child("products")
        .child(widget.productID);
    var userDb =
        FirebaseDatabase.instance.reference().child("users").child(user.uid);

    //getting seller location
    var sellerLocation;
    await userDb.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> seller = snapshot.value;
      sellerLocation = seller['address'];
    });

    DateFormat df = DateFormat('yyyy-MM-dd HH:mm:ss');
    DateTime dateNow = df.parse(saledate.toString());

    //uploading product
    print(user.displayName);
    await productDb.update({
      'name': prodName,
      'price': prodPrice,
      'details': prodDetails.trim(),
      'dealopt': _radioValue,
      'condition': _radioValue2,
      'location': sellerLocation,
      'sellDate': dateNow.toString(),
      'sellerID': user.uid,
      'sellerName': user.displayName,
      'address': address,
      'category': category,
      'subcategory': subCategory,
    });
  }
}
