import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:residents/Constant/Constant_Color.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:residents/Constant/globalsVariable.dart' as global;

class ContactPage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<ContactPage> {
  List<Contact> contacts = [];
  List<Contact> contactsFiltered = [];
  Map<String, Color> contactsColorMap = new Map();
  TextEditingController searchController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    getPermissions();
  }

  getPermissions() async {
    if (await Permission.contacts.request().isGranted) {
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

  @override
  Widget build(BuildContext context) {
    bool isSearching = searchController.text.isNotEmpty;
    return Scaffold(
        appBar: searchAppBar(context),
        body: contacts.length != 0
            ? Container(
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
                      return GestureDetector(onTap: (){
                        global.mobileNumberController.text = contact.phones.elementAt(0).value;
                        global.nameController.text = contact.displayName;
                        Navigator.pop(context);
                      },
                      child: ListTile(
                          title: Text(contact.displayName),
                          subtitle: Text(contact.phones.length > 0
                              ? contact.phones.elementAt(0).value
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
                                      style:
                                      TextStyle(color: Colors.white)),
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
                            "Loading Contact",
                            style: TextStyle(
                                fontWeight: FontWeight.w800, fontSize: 17),
                          )
                        ],
                      ),
                    )),
              )));
  }

  searchAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: UniversalVariables.background,
      leading: IconButton(
        icon:
            Icon(Icons.arrow_back_ios, color: UniversalVariables.ScaffoldColor),
        onPressed: () => Navigator.pop(context),
      ),
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
