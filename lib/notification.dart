import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:paytm/paytm.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc/bloc.dart';

import 'Bloc/AuthBloc.dart';
import 'Constant/globalsVariable.dart';
import 'ModelClass/paytmModelClass.dart';

const String payment = "Payment";
const String webStaging = "WEBSTAGING";
const String currency = "INR";
const mid = "lUvMfI35194252768557";
const String custId = "cust01";
const String callBackUrl =
    "https://securegw-stage.paytm.in/theia/paytmCallback";

final HttpsCallable callable = CloudFunctions.instance
    .getHttpsCallable(functionName: 'payment')
  ..timeout = const Duration(seconds: 30);
var dateAndTime = DateTime.now();
int amount = 10;
var orderID = "81ndioen28dndw900";
Future<bool> paytmFunction() async {
  print("IN PAYTM FUNC");
  try {
    print("IN TRY");
    final HttpsCallableResult result = await callable.call(
      <String, dynamic>{
        'orderId': "1234567DFGHJHBhjjhuj",
        'amt': "10",
        'custId': custId
      },
    );
    print('result');
    print("ORDERID : $orderID");
    print(result.data);
    print(result.data['checksum']);

    var body = {
      "requestType": payment,
      "mid": mid,
      "websiteName": webStaging,
      "orderId": orderID.toString(),
      "callbackUrl": callBackUrl,
      "txnAmount": {
        "value": amount.toString(),
        "currency": currency,
      },
      "userInfo": {
        "custId": custId,
      }
    };
    print(body);
    var head = {"signature": result.data['checksum']};
    print(head);

    var post_data = {"body": body, "head": head};

    print(post_data.toString());

    var pp = jsonEncode(post_data);
    var url =
        'https://securegw-stage.paytm.in/theia/api/v1/initiateTransaction?mid=lUvMfI35194252768557&orderId=' +
            orderID.toString();
    var response = await http.post(
      url,
      body: pp,
      headers: {
        'Content-Type': 'application/json',
        'Content-Length': pp.length.toString()
      },
    );
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    bool isValidToken = false;
    String tokenString = '';
    final tokenResponse = jsonDecode(response.body);
    if (tokenResponse['body']['resultInfo']['resultStatus'] == 'S') {
      tokenString = tokenResponse['body']['txnToken'];
      isValidToken = true;
      print("token details");
      print(isValidToken);
      print(tokenString);
      var paytmResponse;
      paytmResponse = await Paytm.payWithPaytm(
          mid,
          orderID.toString(),
          tokenString,
          amount.toString(),
          callBackUrl + "?ORDER_ID=" + orderID.toString(),
          true);
      print("Paytm Response ------- ${paytmResponse}");
      if (paytmResponse['RESPCODE'] == "01") {
        print("Paytm Response Code------- ${paytmResponse['RESPCODE']}");
        PaytmModel paytmModel = PaytmModel(
            GATEWAYNAME: paytmResponse['GATEWAYNAME'],
            TXNID: paytmResponse['TXNID'],
            BANKNAME: paytmResponse['BANKNAME'],
            BANKTXNID: paytmResponse['BANKTXNID'],
            CURRENCY: paytmResponse['CURRENCY'],
            ORDERID: paytmResponse['ORDERID'],
            PAYMENTMODE: paytmResponse['PAYMENTMODE'],
            RESPCODE: paytmResponse['RESPCODE'],
            RESPMSG: paytmResponse['RESPMSG'],
            STATUS: paytmResponse['STATUS'],
            TXNAMOUNT: paytmResponse['TXNAMOUNT'],
            TXNDATE: paytmResponse['TXNDATE'],
            //remark: remark,
            paymentDateAndTime: dateAndTime.toString());
        // print(
        //     "Previous Balance ${context.bloc<AuthBloc>().state.userData.balance}");
        print(
            "Recent Added Balance ${double.parse((paytmResponse['TXNAMOUNT'])).toInt()}");
        //int totalBalance = context.bloc<AuthBloc>().state.userData.balance +

        //print("Total Balance ${totalBalance}");
        // print("userID is ----- $userId");
        // context.bloc<AuthBloc>().state.userData.balance +=
        //     double.parse((paytmResponse['TXNAMOUNT'])).toInt();
        //UserData userData = UserData(balance: totalBalance);
        // Firestore.instance
        //     .collection(USERS)
        //     .document("yGOdMejwH3TfOMrWPCKVZwg6BnA3")
        //     .setData(
        //     {"balance": context.bloc<AuthBloc>().state.userData.balance},
        //     merge: true);
        // context
        //     .bloc<AuthBloc>()
        //     .updateUser(context.bloc<AuthBloc>().state.userData);

        // Firestore.instance
        //     .collection(USERS)
        //     .document("yGOdMejwH3TfOMrWPCKVZwg6BnA3")
        //     .collection(TRANSACTIONS)
        //     .document(orderID.toString())
        //     .setData(paytmModel.toJson(), merge: true);

        await Fluttertoast.showToast(
          msg: "Transaction successful",
          backgroundColor: Colors.black,
          textColor: Colors.white,
        );
        return true;
      } else {
        //if (paytmResponse['RESPCODE'] == " ") {
        PaytmModel paytmModel = PaytmModel(
            CURRENCY: paytmResponse['CURRENCY'],
            RESPMSG: paytmResponse['RESPMSG'],
            STATUS: paytmResponse['STATUS'],
            ORDERID: paytmResponse['ORDERID'],
            TXNAMOUNT: paytmResponse['TXNAMOUNT'],
            paymentDateAndTime: dateAndTime.toString());
        print("Paytm response MSG---------- ${paytmModel.RESPMSG}");
        Firestore.instance
            .collection(USERS)
            .document("yGOdMejwH3TfOMrWPCKVZwg6BnA3")
            .collection(TRANSACTIONS)
            .document(orderID.toString())
            .setData(paytmModel.toJson(), merge: true);
        //}
        await Fluttertoast.showToast(
          msg: "Transaction Failed, Try again",
          backgroundColor: Colors.black,
          textColor: Colors.white,
        );
        return false;
      }
    }
  } on CloudFunctionsException catch (e) {
    print('caught firebase functions exception');
    print(e.code);
    print(e.message);
    print(e.details);

    await Fluttertoast.showToast(
        msg: "Transaction Failed",
        textColor: Colors.white,
        backgroundColor: Colors.black);
    return false;
  } catch (e) {
    await Fluttertoast.showToast(
        msg: "Transaction Failed, Try Again",
        textColor: Colors.white,
        backgroundColor: Colors.black);
    print(e);
    return false;
  }
}