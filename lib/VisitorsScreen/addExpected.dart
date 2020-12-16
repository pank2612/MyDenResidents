import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_share_me/flutter_share_me.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:residents/Bloc/AuthBloc.dart';
import 'package:residents/Constant/Constant_Color.dart';
import 'package:residents/Constant/constantTextField.dart';
import 'package:residents/Constant/globalsVariable.dart' as global;
import 'package:residents/Constant/globalsVariable.dart';
import 'package:residents/Constant/tokenGenerate.dart';
import 'package:residents/ModelClass/ActivationModel.dart';
import 'package:residents/ModelClass/UserModel.dart';
import 'package:residents/ModelClass/visitorModel.dart';
import 'package:screenshot/screenshot.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddExpected extends StatefulWidget {
  // final House house;
  //
  // const AddExpected({Key key, this.house}) : super(key: key);

  @override
  _AddExpectedState createState() => _AddExpectedState();
}

class _AddExpectedState extends State<AddExpected> {
  List<Contact> contacts = [];

  List<Contact> contactsFiltered = [];
  Map<String, Color> contactsColorMap = new Map();
  List<Visitor> vendorsList = List<Visitor>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  TextEditingController _dateController = TextEditingController();
  TextEditingController _tokenController = TextEditingController();
  TextEditingController _firstTimeController = TextEditingController();
  TextEditingController _secondTimeController = TextEditingController();
  ScreenshotController screenshotController = ScreenshotController();
  TextEditingController searchController = new TextEditingController();

  bool isAllDay = true;
  bool isLoading = false;
  UserData _userData = UserData();
  File _imageFile;
  bool showPhoneNumber = false;

  getPermissions() async {
    if (await Permission.contacts
        .request()
        .isGranted) {
      getAllContacts();
      searchController.addListener(() {
        filterContacts();
      });
    }
  }

  String flattenPhoneNumber(String phoneStr) {
    return phoneStr.replaceAllMapped(RegExp(r'^(\+)|\D'), (Match m) {
      return m[0] == "+" ? "+" : "";
    });
  }

  getAllContacts() async {
    List colors = [Colors.green, Colors.indigo, Colors.yellow, Colors.orange];
    int colorIndex = 0;
    List<Contact> _contacts = (await ContactsService.getContacts()).toList();
    _contacts.forEach((contact) {
      Color baseColor = colors[colorIndex];
      contactsColorMap[contact.displayName] = baseColor;
      colorIndex++;
      if (colorIndex == colors.length) {
        colorIndex = 0;
      }
    });
    setState(() {
      contacts = _contacts;
    });
  }

  filterContacts() {
    List<Contact> _contacts = [];
    _contacts.addAll(contacts);
    if (searchController.text.isNotEmpty) {
      _contacts.retainWhere((contact) {
        String searchTerm = searchController.text.toLowerCase();
        String searchTermFlatten = flattenPhoneNumber(searchTerm);
        String contactName = contact.displayName.toLowerCase();
        bool nameMatches = contactName.contains(searchTerm);
        if (nameMatches == true) {
          return true;
        }

        if (searchTermFlatten.isEmpty) {
          return false;
        }

        var phone = contact.phones.firstWhere((phn) {
          String phnFlattened = flattenPhoneNumber(phn.value);
          return phnFlattened.contains(searchTermFlatten);
        }, orElse: () => null);

        return phone != null;
      });
    }
    setState(() {
      contactsFiltered = _contacts;
    });
  }

  Future<Null> _selectDate(BuildContext context, DateTime firstDate,
      DateTime lastDate) async {
    DateTime selectedDate = firstDate;
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: firstDate,
        lastDate: lastDate);
    if (picked != null) selectedDate = picked;
    String _formattedate =
    new DateFormat(global.dateFormat).format(selectedDate);
    setState(() {
      _dateController.value = TextEditingValue(text: _formattedate);
    });
  }

  void showScaffold(String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  @override
  void initState() {
    _userData = context.bloc<AuthBloc>().getCurrentUser();
    print(_userData.phoneNo);
    print(_userData.gender);
    global.type = "Select Visitor ";
    global.number = "0";
    global.mobileNumberController.clear();
    global.nameController.clear();
    super.initState();
    getPermissions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: showPhoneNumber ? searchAppBar(context)
            :AppBar(
          backgroundColor: UniversalVariables.background,
          title: Text("Expected Visitors"),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Stack(
          children: [
            Padding(
              padding: EdgeInsets.all(20),
              child: ListView(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        showPhoneNumber = true;
                      });

                      print(showPhoneNumber);
                      // Navigator.push(
                      //     context, MaterialPageRoute(builder: (context) => ContactPage()));
                    },
                    child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                                color: UniversalVariables.background)),
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.contact_phone,
                                size: 30,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Add from Contact",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w800),
                              )
                            ],
                          ),
                        )),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Form(
                    key: global.formKey,
                    child: Column(
                      children: [
                        constantTextField().InputField(
                            "Enter Mobile Number",
                            "",
                            validationKey.mobileNo,
                            global.mobileNumberController,
                            false,
                            IconButton(
                                icon: Icon(Icons.contact_phone),
                                onPressed: () {}),
                            1,
                            1,
                            TextInputType.number,
                            false),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: constantTextField().InputField(
                                  "Visitor's Name",
                                  "",
                                  validationKey.name,
                                  global.nameController,
                                  false,
                                  IconButton(
                                      icon: Icon(Icons.contact_phone),
                                      onPressed: () {}),
                                  1,
                                  1,
                                  TextInputType.text,
                                  false),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Icon(
                              Icons.add,
                              size: 30,
                              color: UniversalVariables.background,
                            ),
                            Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                        color: UniversalVariables.background)),
                                child: Padding(
                                  padding: EdgeInsets.all(0),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        "$number",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w800),
                                      ),
                                      PopupMenuButton<String>(
                                        icon: const Icon(Icons.arrow_drop_down),
                                        onSelected: (String val) {
                                          global.number = val;
                                          setState(() {
                                            global.changeValidation =
                                            global.documentData[val];
                                          });
                                        },
                                        itemBuilder: (BuildContext context) {
                                          return global.guestNumber
                                              .map<PopupMenuItem<String>>(
                                                  (int val) {
                                                return new PopupMenuItem(
                                                    child: new Text(
                                                        val.toString()),
                                                    value: val.toString());
                                              }).toList();
                                        },
                                      ),
                                    ],
                                  ),
                                )),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Visitor Type",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w800),
                            ),
                            Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                        color: UniversalVariables.background)),
                                child: Padding(
                                  padding: EdgeInsets.all(0),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        "$type",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w800),
                                      ),
                                      PopupMenuButton<String>(
                                        icon: const Icon(Icons.arrow_drop_down),
                                        onSelected: (String val) {
                                          global.type = val;
                                          setState(() {
                                            global.changeValidation =
                                            global.documentData[val];
                                          });
                                        },
                                        itemBuilder: (BuildContext context) {
                                          return global.guestType
                                              .map<PopupMenuItem<String>>(
                                                  (String val) {
                                                return new PopupMenuItem(
                                                    child: new Text(val),
                                                    value: val);
                                              }).toList();
                                        },
                                      ),
                                    ],
                                  ),
                                ))
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        InkWell(
                          onTap: () {
                            _selectDate(
                                context,
                                DateTime.now().subtract(Duration(days: 0)),
                                DateTime.now().add(Duration(days: 365)));
                          },
                          child: IgnorePointer(
                              child: constantTextField().InputField(
                                  "Enter Date",
                                  "",
                                  validationKey.date,
                                  _dateController,
                                  true,
                                  IconButton(
                                    icon: Icon(Icons.calendar_today),
                                    onPressed: () {},
                                  ),
                                  1,
                                  1,
                                  TextInputType.name,
                                  false)),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Checkbox(
                              activeColor: UniversalVariables.background,
                              value: isAllDay,
                              onChanged: (value) {
                                setState(() {
                                  isAllDay = value;
                                  print(isAllDay);
                                });
                              },
                            ),
                            Text("All Day"),
                          ],
                        ),
                        !isAllDay
                            ? Column(
                          children: [
                            InkWell(
                                onTap: () {
                                  showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay(
                                          hour: DateTime
                                              .now()
                                              .hour,
                                          minute:
                                          DateTime
                                              .now()
                                              .minute))
                                      .then((TimeOfDay value) {
                                    if (value != null) {
                                      _firstTimeController.text =
                                          value.format(context);
                                    }
                                  });
                                },
                                child: IgnorePointer(
                                  child: constantTextField().InputField(
                                      "9:00 pm",
                                      "",
                                      validationKey.time,
                                      _firstTimeController,
                                      true,
                                      IconButton(
                                          icon:
                                          Icon(Icons.arrow_drop_down),
                                          onPressed: () {}),
                                      1,
                                      1,
                                      TextInputType.emailAddress,
                                      false),
                                )),
                            SizedBox(
                              height: 10,
                            ),
                            InkWell(
                                onTap: () {
                                  showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay(
                                          hour: DateTime
                                              .now()
                                              .hour,
                                          minute:
                                          DateTime
                                              .now()
                                              .minute))
                                      .then((TimeOfDay value) {
                                    if (value != null) {
                                      _secondTimeController.text =
                                          value.format(context);
                                    }
                                  });
                                },
                                child: IgnorePointer(
                                  child: constantTextField().InputField(
                                      "6:00 am",
                                      "6:00 am",
                                      validationKey.time,
                                      _secondTimeController,
                                      true,
                                      IconButton(
                                        icon: Icon(Icons.arrow_drop_down),
                                        onPressed: () {},
                                      ),
                                      1,
                                      1,
                                      TextInputType.emailAddress,
                                      false),
                                )),
                          ],
                        )
                            : Container()
                      ],
                    ),
                  ),

                  SizedBox(
                    height: 50,
                  ),
                  RaisedButton(
                    color: UniversalVariables.background,
                    onPressed: () {
                      global.uuid = Uuid().v1();
                      _tokenController.text = RandomString(10);
                      addExpected();

                      // getHouseDetails();
                    },
                    child: Text(
                      "Add",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: UniversalVariables.ScaffoldColor),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                ],
              ),
            ),
            showPhoneNumber
                ? _showContactList()
                : Container()
            //  CircularProgressIndicator()
            // showContactList ? _showContactList() : Container()
          ],
        ));
  }

  addExpected() {
    if (global.formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });
      if ("$type" == "Select Visitor >" || "$number" == "0") {
        showScaffold("Select visitor type or Visitor Number");
      } else {
        Visitor visitor = Visitor(
            name: global.nameController.text,
            mobileNumber: global.mobileNumberController.text,
            visitorNumber: "$number",
            visitorType: "$type",
            inviteDate:
            DateFormat(global.dateFormat).parse(_dateController.text),
            houseId: global.parentId,
            enable: true,
            ownerHouse: global.flatNo,
            ownerMobileNumber: _userData.phoneNo,
            ownerName: _userData.name,
            token: _tokenController.text,
            id: global.uuid,
            firstInviteTime: _firstTimeController.text,
            secondInviteTime: _secondTimeController.text,
            allDay: isAllDay,
            inviteBye: _userData.name,
            societyId: global.mainId);
        Firestore.instance
            .collection(global.SOCIETY)
            .document(global.mainId)
            .collection(global.VISITORS)
            .document(global.uuid)
            .setData(jsonDecode(jsonEncode(visitor.toJson())))
            .then((value) {
          _showDialog();
        });
      }
    }
  }

  SaveActivationCode(){
    ActivationCode activationCode = ActivationCode(


    );
  }

  Future<void> _showDialog() async {
    return showDialog<void>(
      context: context,
      //barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Column(
            children: [
              Text("Entry Code Created For " +
                  global.nameController.text +
                  " : "),
              Text(
                _tokenController.text,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: UniversalVariables.background),
              )
            ],
          ),
          content: SingleChildScrollView(
            child: Container(
                decoration:
                BoxDecoration(border: Border.all(color: Colors.black)),
                child: Stack(
                  children: [
                    Screenshot(
                      controller: screenshotController,
                      child: ListBody(
                        children: <Widget>[
                          Container(
                            child: Column(
                              children: [
                                Container(
                                  width: MediaQuery
                                      .of(context)
                                      .size
                                      .width,
                                  height: 70,
                                  child: Image.asset(
                                    "images/back.png",
                                    fit: BoxFit.cover,
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                              child: Padding(
                                padding: EdgeInsets.all(15),
                                child: Column(
                                  children: [
                                    Text(
                                      _userData.name +
                                          " has invited you to on " +
                                          _dateController.text +
                                          _firstTimeController.text +
                                          " - " +
                                          _secondTimeController.text,
                                      style: TextStyle(
                                          fontStyle: FontStyle.italic),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .center,
                                      children: [
                                        Icon(
                                          Icons.home,
                                          color: UniversalVariables.background,
                                          size: 30,
                                        ),
                                        Text(
                                          "MyDen",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize: 20),
                                        )
                                      ],
                                    ),
                                    Text(
                                      "OTP to be used on arrival at gate",
                                      style: TextStyle(
                                          fontStyle: FontStyle.italic),
                                    ),
                                    Card(
                                        color: UniversalVariables.background,
                                        child: Padding(
                                          padding: EdgeInsets.all(5),
                                          child: Text(
                                            _tokenController.text,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w800,
                                                color: UniversalVariables
                                                    .ScaffoldColor),
                                          ),
                                        )),
                                    Text(
                                      "Please tell this number to the security guard at gate for entry to society",
                                      style: TextStyle(
                                          fontStyle: FontStyle.italic,
                                          fontSize: 10),
                                    ),
                                  ],
                                ),
                              )),
                          Container(
                            child: Column(
                              children: [
                                Container(
                                  width: MediaQuery
                                      .of(context)
                                      .size
                                      .width,
                                  height: 30,
                                  child: Image.asset(
                                    "images/back.png",
                                    fit: BoxFit.cover,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      left: 90,
                      top: 50,
                      child: Card(
                          elevation: 10,
                          child: Padding(
                            padding: EdgeInsets.all(3),
                            child: Text(
                              "Invitation",
                              style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  color: UniversalVariables.background,
                                  fontSize: 20),
                            ),
                          )),
                    ),
                    Positioned(
                      left: 75,
                      bottom: 7,
                      child: Text(
                        "www.MyDen.Com",
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          color: UniversalVariables.ScaffoldColor,
                        ),
                      ),
                    ),
                  ],
                )),
          ),
          actions: <Widget>[
            GestureDetector(
                onTap: () async {
                  _imageFile = null;
                  screenshotController
                      .capture(delay: Duration(milliseconds: 10))
                      .then((File image) async {
                    setState(() {
                      _imageFile = image;
                    });
                  });
                  var response = await FlutterShareMe().shareToSystem(
                      msg: global.RWATokenMsg + _tokenController.text);

                  if (response == 'success') {}
                  Navigator.pop(context);
                },
                child: Container(
                    color: UniversalVariables.background,
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    child: Padding(
                      padding: EdgeInsets.all(5),
                      child: Icon(
                        Icons.share,
                        color: UniversalVariables.ScaffoldColor,
                        size: 30,
                      ),
                    )))
          ],
        );
      },
    );
  }

  Widget _showContactList() {
    bool isSearching = searchController.text.isNotEmpty;
    return contacts.length != 0
        ? Container(
      color: Colors.white,
      padding: EdgeInsets.all(20),
      child: Column(children: <Widget>[


        Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: isSearching == true
                  ? contactsFiltered.length
                  : contacts.length,
              itemBuilder: (context, index) {
                Contact contact = isSearching == true
                    ? contactsFiltered[index]
                    : contacts[index];
                var baseColor =
                contactsColorMap[contact.displayName] as dynamic;
                Color color1 = baseColor[800];
                Color color2 = baseColor[400];
                return GestureDetector(
                  onTap: () {
                    global.mobileNumberController.text =
                        contact.phones
                            .elementAt(0)
                            .value;
                    global.nameController.text = contact.displayName;
                    setState(() {
                      showPhoneNumber = false;
                    });
                  },
                  child: ListTile(
                      title: Text(contact.displayName),
                      subtitle: Text(contact.phones.length > 0
                          ? contact.phones
                          .elementAt(0)
                          .value
                          : ''),
                      leading: (contact.avatar != null &&
                          contact.avatar.length > 0)
                          ? CircleAvatar(
                        backgroundImage: MemoryImage(contact.avatar),
                      )
                          : Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                  colors: [
                                    color1,
                                    color2,
                                  ],
                                  begin: Alignment.bottomLeft,
                                  end: Alignment.topRight)),
                          child: CircleAvatar(
                              child: Text(contact.initials(),
                                  style: TextStyle(color: Colors.white)),
                              backgroundColor: Colors.transparent))),
                );
              },
            )),
      ]),
    )
        : Center(
        child: Padding(
          padding: EdgeInsets.all(25),
          child: Card(
              elevation: 10,
              child: Padding(
                padding: EdgeInsets.all(25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CircularProgressIndicator(),
                    Text(
                      "Loading Contact....",
                      style: TextStyle(
                          fontWeight: FontWeight.w800, fontSize: 17),
                    )
                  ],
                ),
              )),
        ));
  }

  searchAppBar(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: UniversalVariables.background,
      elevation: 0,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(20),
        child: Padding(
          padding: EdgeInsets.only(left: 20),
          child: TextField(
            controller: searchController,
            cursorColor: Colors.black,
            autofocus: true,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 20,
            ),
            decoration: InputDecoration(
              suffixIcon: IconButton(
                icon: Icon(
                  Icons.close,
                  color: Colors.white,
                ),
                onPressed: () {
                  WidgetsBinding.instance
                      .addPostFrameCallback((_) => searchController.clear());
                },
              ),
              border: InputBorder.none,
              hintText: "Search Mobile Number",
              hintStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.white70,
              ),
            ),
          ),
        ),
      ),
    );
  }

}
