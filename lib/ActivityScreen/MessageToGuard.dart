import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:residents/Constant/Constant_Color.dart';
import 'package:residents/Constant/constantTextField.dart';
import 'package:residents/Constant/globalsVariable.dart' as global;
import 'package:residents/ModelClass/MessageToGuard.dart';
import 'package:uuid/uuid.dart';

class MessageToGuard extends StatefulWidget {
  @override
  _MessageToGuardState createState() => _MessageToGuardState();
}

class _MessageToGuardState extends State<MessageToGuard> {
  TextEditingController _messageController = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: UniversalVariables.background,
          title: Text("MessageToGuard"),
        ),
        body: ListView(
          children: [
            SizedBox(
              height: 40,
            ),
            Padding(
              padding: EdgeInsets.all(15),
                child: Column(
                  children: [

                    Form(
                      key: global.formKey,
                      child:  constantTextField().InputField(
                          "Write message to guard",
                          "Write message to guard",
                          validationKey.Description,
                          _messageController,
                          false,
                          IconButton(
                            icon: Icon(Icons.arrow_back_ios),
                            onPressed: () {},
                          ),
                          8,
                          1,
                          TextInputType.name,
                          false),
                    ),
                    SizedBox(height: 20,),
                    GestureDetector(
                      onTap: () {
                        messageTogUard();
                      },
                      child: Container(
                        child: Center(
                          child: Text(
                            "Send",
                            style: TextStyle(
                                color: UniversalVariables.ScaffoldColor,
                                fontWeight: FontWeight.w800),
                          ),
                        ),
                        width: MediaQuery
                            .of(context)
                            .size
                            .width,
                        height: 40,
                        decoration: BoxDecoration(
                            color: UniversalVariables.background,
                            borderRadius: BorderRadius.circular(15)
                            )),
                      ),

                  ],
                ),

            )
          ],
        ));
  }

  messageTogUard() {
    if (global.formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });

      MessageSendToGuard messageSendToGuard = MessageSendToGuard(
          id: Uuid().v1(),
          enable: true,
          creationDate: DateTime.now(),
          message: _messageController.text);
      Firestore.instance
          .collection(global.SOCIETY)
          .document(global.mainId)
          .collection("MessageToGuard")
          .document(messageSendToGuard.id)
          .setData(jsonDecode(jsonEncode(messageSendToGuard.toJson())));
    }
  }
}
