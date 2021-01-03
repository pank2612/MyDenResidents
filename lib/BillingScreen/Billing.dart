import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:residents/Constant/Constant_Color.dart';
import 'package:residents/Constant/globalsVariable.dart' as global;
import 'package:residents/ModelClass/billing.dart';

class BillingMainScreen extends StatefulWidget {
  @override
  _BillingMainScreenState createState() => _BillingMainScreenState();
}

class _BillingMainScreenState extends State<BillingMainScreen> {
  List<BillingModel> billingList = List<BillingModel>();
  bool isLoading = false;
  bool hasMore = true;
  int documentLimit = 5;
  DocumentSnapshot lastDocument = null;
  bool isExpanded = false;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    getBillingDetails(lastDocument);
    super.initState();
  }

  @override


  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Billing"),
      ),
      body: Column(children: [
        SizedBox(
          height: 10,
        ),

        Expanded(
          child: billingList.length == 0
              ? Center(child: Text("No Data"))
              : ListView.builder(
            controller: _scrollController,
            itemCount: billingList.length,
            itemBuilder: (context, index) {
              return Padding(
                  padding: const EdgeInsets.only(left: 12, right: 12),
                  child: GestureDetector(
                      onTap: () {

                      },
                      child: Card(
                        // width: MediaQuery.of(context).size.width,
                        child: ExpansionTile(
                          title: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Row(children: [
                              Container(
                                width: MediaQuery.of(context).size.width/2,
                                child: Text(
                                  billingList[index].billingHeader,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 20,

                                  ),overflow: TextOverflow.ellipsis,maxLines: 1,
                                ),
                              ),
                              Spacer(),
                              GestureDetector(
                                  onTap: () {
                                    // Route route = MaterialPageRoute(
                                    //     builder: (context) =>
                                    //         EditEventData(
                                    //             event: eventList[
                                    //             index]));
                                    // Navigator.push(context, route)
                                    //     .then(onGoBack);
                                  },
                                  child: Icon(Icons.mode_edit)),
                              SizedBox(
                                width: 5,
                              ),
                              GestureDetector(
                                  onTap: () {
                                    // _showDeletDialog(
                                    //     accountinList[index]);
                                  },
                                  child: Icon(Icons.delete)),
                            ]),
                          ),
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(children: [
                                    Text(
                                      "Area - " +
                                          billingList[index].perUnit,
                                      style: TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                    Spacer(),
                                    Text(
                                      "TimePeriod - " +
                                          billingList[index].totalAmount.toString(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ]),
                                  // Text(
                                  //   "Bill Issue Date - " +
                                  //       DateFormat(global.dateFormat)
                                  //           .format(accountinList[index]
                                  //           .startDate),
                                  //   style: TextStyle(
                                  //     fontSize: 15,
                                  //   ),
                                  // ),
                                  // Text(
                                  //   "Last Date - " +
                                  //       DateFormat(global.dateFormat)
                                  //           .format(accountinList[index]
                                  //           .endDate),
                                  //   style: TextStyle(
                                  //     fontSize: 15,
                                  //   ),
                                  // ),
                                  // Text(
                                  //   "Valid UpTo - " +
                                  //       accountinList[index].day + " days",
                                  //   style: TextStyle(
                                  //     fontSize: 15,
                                  //   ),
                                  // ),
                                  SizedBox(height: 10,),
                                  // Text(
                                  //   eventList[index].description,
                                  //   style: TextStyle(
                                  //       fontSize: 15,fontWeight: FontWeight.w800
                                  //   ),
                                  // ),
                                ],
                              ),
                            )
                          ],
                          onExpansionChanged: (bool expanding) =>
                              setState(
                                      () => this.isExpanded = expanding),
                        ),
                      )
                  )


              );
            },
          ),
        ),
        isLoading
            ? Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.all(5),
          color: UniversalVariables.background,
          child: Text(
            'Loading......',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: UniversalVariables.ScaffoldColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
            : Container()
      ]),
    );
  }
  getBillingDetails(DocumentSnapshot _lastDocument) async {
    int documentLimit = 10;
    if (!hasMore) {

      return;
    }
    if (isLoading) {
      return;
    }
    setState(() {
      isLoading = true;
    });

    QuerySnapshot querySnapshot;
    print('No More Data');
    if (_lastDocument == null) {
      billingList.clear();
      querySnapshot = await Firestore.instance
          .collection('Society')
          .document(global.mainId)
          .collection("Billing")
          .where("enable",isEqualTo: true)
          .limit(documentLimit)
          .getDocuments();
    } else {
      print('No call data');
      querySnapshot = await Firestore.instance
          .collection('Society')
          .document(global.mainId)
          .collection("Billing")
          .startAfterDocument(_lastDocument)
          .where("enable",isEqualTo: true)
          .limit(documentLimit)
          .getDocuments();
    }
    print("Society data");

    if (querySnapshot.documents.length < documentLimit) {
      print("data finish");
      hasMore = false;
    }
    if (querySnapshot.documents.length != 0) {
      lastDocument =
      querySnapshot.documents[querySnapshot.documents.length - 1];
      print("final data");

      setState(() {
        querySnapshot.documents.forEach((element) {
          var billing = BillingModel();
          billing = BillingModel.fromJson(element.data);
          billingList.add(billing);
        });
      });
    }
    setState(() {
      isLoading = false;
    });
  }
}
