import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

//import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:imgur/imgur.dart' as imgur;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:secondbuy/Util/Global.dart';
import 'package:secondbuy/View/signup.dart';

class Sell extends StatefulWidget {
  _SellState createState() => _SellState();
}

class _SellState extends State<Sell> {
  @override
  void initState() {
    super.initState();
  }

  //form key
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth auth = FirebaseAuth.instance;

  //images upload variables
  File _image;

  //List<Asset> images = List<Asset>();

  final picker = ImagePicker();
  final client =
      imgur.Imgur(imgur.Authentication.fromClientId('e91a824722e23b9'));

  //input variables
  String prodName;
  double prodPrice;
  String prodDetails;
  String address;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Sell',
          style: TextStyle(color: Colors.black),
        ),
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        shrinkWrap: true,
        children: <Widget>[
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Form(
                  key: _formKey,
                  child: ListView(
                    shrinkWrap: true,
                    children: <Widget>[
                      Container(
                        child: //buildGridView(),
                            _image == null
                                ? Text('No image is selected')
                                : Image.file(_image),
                      ),
                      ImageButton(),
                      SizedBox(
                        width: 20.0,
                        height: 10.0,
                      ),
                      InputField(
                          "Product Name is required",
                          false,
                          "Product Name",
                          'Product Name',
                          (value) => prodName = value),
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
                          (value) => prodPrice = double.parse(value)),
                      SizedBox(
                        width: 20.0,
                        height: 20.0,
                      ),
                      TextArea(
                          "Product Details is required",
                          false,
                          "Product Details",
                          "Product Details",
                          (value) => prodDetails = value),
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
                          (value) => address = value),
                      SizedBox(
                        width: 20.0,
                        height: 10.0,
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: OutlineButton(
                              child: Text("Sell Now"),
                              onPressed: () {
                                if (_formKey.currentState.validate()) {
                                  Scaffold.of(context).showSnackBar(SnackBar(
                                      content: Text('Uploading your Product')));
                                  print(_formKey.currentState.validate());
                                  _formKey.currentState.save();
                                  UploadingProduct();
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

  //Image Upload from gallery
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

  // Creating widgets for form

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

  Widget InputField(String valMsg, bool, String label, String hint, save) {
    return new TextFormField(
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

  Widget AddressField(String valMsg, bool, String label, String hint, save) {
    return new TextFormField(
      decoration: InputDecoration(
        enabled: _radioValue == "meetup" ? true : false,
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

  Widget NumberField(String valMsg, bool, String label, String hint, save) {
    return new TextFormField(
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
          value: "old",
          groupValue: _radioValue2,
          onChanged: _handleRadioValueChange2,
        ),
        new Text(
          'Old',
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
          break;
        case "delivery":
          break;
      }
    });
  }

  void _handleRadioValueChange2(String opt) {
    setState(() {
      _radioValue2 = opt;

      switch (_radioValue2) {
        case "new":
          break;
        case "old":
          break;
      }
    });
  }

  Widget TextArea(String valMsg, bool, String label, String hint, save) {
    return new TextFormField(
      decoration: InputDecoration(
        hintText: hint,
        labelText: label,
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 20.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
      ),
      maxLines: 20,
      obscureText: bool,
      validator: (value) => value.isEmpty ? valMsg : null,
      onSaved: save,
    );
  }

  // adding product to firebase
  Future<FirebaseUser> UploadingProduct() async {
    String id = Global.generateRandomString(8);
    final FirebaseUser user = await auth.currentUser();
    var productDb =
        FirebaseDatabase.instance.reference().child("products").child(id);
    var userDb =
        FirebaseDatabase.instance.reference().child("users").child(user.uid);

    //getting seller location
    var sellerLocation;
    userDb.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> seller = snapshot.value;
      seller.forEach((key, value) {
        sellerLocation = value['location'];
      });
    });

    print("Starts here");
    print("PRODUCT NAME " + prodName);

    //upload Image
    String imgURL;
    await client.image
        .uploadImage(
          imageFile: _image,
        )
        .then((image) => imgURL = image.link);

    print("Image link here : " + imgURL);

    //uploading product

    await productDb.set({
      'name': prodName,
      'price': prodPrice,
      'details': prodDetails,
      'fav': 0,
      'id': id,
      'dealopt': _radioValue,
      'condition': _radioValue2,
      'location': sellerLocation,
      'sellDate': DateTime.now().toString(),
      'sellerID': user.uid,
      'sellerName': user.displayName,
      'address': address,
      'category': category,
      'subCategory': subCategory,
      'status': 'selling',
    });

    //uploading product images
    await productDb.child('prodImg').push().set({
      'image': imgURL,
    });
  }
}
