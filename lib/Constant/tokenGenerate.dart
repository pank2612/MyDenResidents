import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';

const chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
String RandomString(int strlen) {
  Random rnd = new Random(new DateTime.now().millisecondsSinceEpoch);
  String result = "";
  for (var i = 0; i < strlen; i++) {
    result += chars[rnd.nextInt(chars.length)];
  }
  return result;
}


String RandomPassword(int strlen) {
  Random rnd = new Random(new DateTime.now().millisecondsSinceEpoch);
  String result = "";
  for (var i = 0; i < strlen; i++) {
    result += rnd.toString();
  }
  return result;
}



// class NavigationService {
//   GlobalKey<NavigatorState> _navigationKey = GlobalKey<NavigatorState>();
//
//   GlobalKey<NavigatorState> get navigationKey => _navigationKey;
//
//   void pop() {
//     return _navigationKey.currentState.pop();
//   }
//
//   Future<dynamic> navigateTo(String routeName, {dynamic arguments}) {
//     return _navigationKey.currentState
//         .pushNamed(routeName, arguments: arguments);
//   }
// }
//
//
// GetIt locator = GetIt.instance;
//
// void setupLocator() {
//   locator.registerLazySingleton(() => NavigationService());
//
// }