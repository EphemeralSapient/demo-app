// ignore_for_file: non_constant_identifier_names

library globals;


import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:shared_preferences/shared_preferences.dart' show SharedPreferences;
import 'package:ngp/database.dart';
import 'dart:io';
import 'package:ngp/ui/alert.dart';


SharedPreferences? prefs;
ThemeMode darkMode = ThemeMode.system;

List<String> possibleStaffIds = [
  "ilavarasans@drngpit.ac.in" // Temp, don't mind it
];

db? Database;
Map<String,CollectionReference> collectionMap = {}; 
Map<String, dynamic> hashes = {};
Map<String, dynamic> course_data = {};
Map<dynamic, dynamic> timetable_subject = {}; // Weekend days : int | Subject list : List<String> aka dynamic here
List<dynamic> timetable_timing = []; // List of timing in string : List<String>
User? account;
account_obj? accObj;
String? loggedUID;
String? passcode;
int accountType = -1;
int eventsCount = 0;
int notificationCount = 0;
int assignmentCount = 0;
int test = 0;
bool networkAvailable = false;
bool isLoggedIn = false;
bool loaded = false;
bool loginScreenRoute = false;
bool choiceRoute = false;
bool loginRoute = false;
bool bgImage = false;
bool dashboardReached = false;
void Function()? loginRouteCloseFn;
void Function()? rootRefresh;
void Function()? bgRefresh;
Alert alert = Alert();
BuildContext? loginRouteCTX;
BuildContext? loginScreenRouteCTX;
BuildContext? choiceRouteCTX;
BuildContext? rootCTX;
BuildContext? timetableCTX;
PageController? pageControl;
dynamic temp;

void updateSettingsFromStorage() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  prefs = pref;
  darkMode = prefs!.getBool("dark mode") != null ?( prefs!.getBool("dark mode") == true ? ThemeMode.dark : ThemeMode.light): ThemeMode.light;
  bgImage = prefs!.getBool("bg image") != null ? prefs!.getBool("bg image")! : false;
  accountType = prefs!.getInt("accountType") ?? -1;
  passcode = prefs!.getString("passcode");
  dashboardReached = prefs!.getBool("dashboardReached") ?? false;
  hashes = jsonDecode(prefs!.getString("hashes") ?? "{}");
  //debugPrint(jsonDecode(jsonDecode(prefs!.getString("timetable_timing") ?? "lol" ))[0]);     This crap wasted my 1 hour time on debugging; damnit
  timetable_timing = jsonDecode(jsonDecode(prefs!.getString("timetable_timing") ?? "\"[]\""));
  timetable_subject = jsonDecode(jsonDecode(prefs!.getString("timetable_subject") ?? "\"{}\""));
  course_data = jsonDecode(jsonDecode(prefs!.getString("course_data") ?? "\"{}\""));
  rootRefresh!();
}


void updateMapToStorage(String id, dynamic x) async{
  await prefs!.setString(id, jsonEncode(x));
}

void updateListToStorage(String id, dynamic x) async{
  await prefs!.setString(id, jsonEncode(x));
}



Future<bool> checkNetwork() async {
  try {
    final result = await InternetAddress.lookup('example.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      networkAvailable = true;
    }
  } on SocketException catch (_) {
    networkAvailable = false;
  }
  return networkAvailable;
}

void initGlobalVar() async {
  accObj = account_obj();
}

Widget textWidget(String text) {
  return Text(text, style: TextStyle(
    color: Theme.of(rootCTX!).textSelectionTheme.selectionColor,
  ),);
}

Widget textWidgetWithBool(String text, bool enable) {
  return Text(text, style: TextStyle(
    color: (enable==true) ? Theme.of(rootCTX!).textSelectionTheme.cursorColor : Theme.of(rootCTX!).textSelectionTheme.selectionColor
  ),);
}