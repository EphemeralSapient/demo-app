// ignore_for_file: non_constant_identifier_names

library globals;

import 'dart:convert';

import 'package:another_transformer_page_view/another_transformer_page_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// ignore: depend_on_referenced_packages
import 'package:shared_preferences/shared_preferences.dart'
    show SharedPreferences;
import 'package:ngp/database.dart';
import 'dart:io';
import 'package:ngp/ui/alert.dart';

SharedPreferences? prefs;
ThemeMode darkMode = ThemeMode.system;

List<String> possibleStaffIds = [
  "ilavarasans@drngpit.ac.in" // Temp, don't mind it
];

db? Database;
Map<String, CollectionReference> collectionMap = {};
Map<String, dynamic> hashes = {};
Map<String, dynamic> departmentWithClasses = {
  "cse" : {
    "full" : "Computer Science and Engineering",
    "sections" : ["a", "b"],
  },
  "mech" : {
    "full" : "Mechanical Engineering",
    "sections" : ["a", "b"],
  },
  "ece" : {
    "full" : "Electronics and Communication Engineering",
    "sections" : ["a","b"]
  }
};
Map<String, dynamic> year = {
  "i" : {
    "full" : "First Year"
  },
  "ii" : {
    "full" : "Second Year"
  },
  "iii" : {
    "full" : "Third Year"
  },
  "iv" : {
    "full" : "Fourth Year"
  }
};
Map<String, dynamic> course_data = {};
Map<String, dynamic> classroom_data = {};
Map<String, dynamic> accountsInDatabase = {};
List<Function> classroom_updateFns = [];
Map<dynamic, dynamic> timetable_subject =
    {}; // Weekend days : int | Subject list : List<String> aka dynamic here
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
bool classroomEventLoaded = false;
bool loginScreenRoute = false;
bool choiceRoute = false;
bool loginRoute = false;
bool bgImage = false;
bool dashboardReached = false;
bool customColorEnable = false;
int customColor = Colors.lightBlue.value;
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
IndexController? uiPageControl;
dynamic temp;
dynamic quickAlertGlobalVar;
dynamic uiSecondaryScrollPhysics = const NeverScrollableScrollPhysics();
dynamic restartApp;
Offset? dragUiPosition;
Widget? uiSecondaryWidgetFn;
Color uiBackgroundColor = Colors.lightBlueAccent;

void switchToSecondaryUi(Widget w) {
  uiSecondaryWidgetFn = w;
  uiSecondaryScrollPhysics = null;
  if(bgRefresh != null) bgRefresh!();
  uiPageControl!.move(1);
      //duration: const Duration(seconds: 1), curve: Curves.easeOutExpo);
}

void switchToPrimaryUi() {
  uiSecondaryScrollPhysics = const NeverScrollableScrollPhysics();
  if(bgRefresh != null) bgRefresh!();
  uiPageControl!.move(0);
      //duration: const Duration(seconds: 1), curve: Curves.easeInExpo);
  //SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
}

void updateSettingsFromStorage() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  prefs = pref;
  darkMode = prefs!.getBool("dark mode") != null
      ? (prefs!.getBool("dark mode") == true ? ThemeMode.dark : ThemeMode.light)
      : ThemeMode.light;
  bgImage =
      prefs!.getBool("bg image") != null ? prefs!.getBool("bg image")! : false;
  accountType = prefs!.getInt("accountType") ?? -1;
  passcode = prefs!.getString("passcode");
  dashboardReached = prefs!.getBool("dashboardReached") ?? false;
  customColorEnable = prefs!.getBool("customColorEnable") ?? false;
  customColor = prefs!.getInt("customColor") ?? Colors.lightBlue.value;
  hashes = jsonDecode(prefs!.getString("hashes") ?? "{}");
  //debugPrint(jsonDecode(jsonDecode(prefs!.getString("timetable_timing") ?? "lol" ))[0]);     This crap wasted my 1 hour time on debugging; damnit
  timetable_timing =
      jsonDecode(jsonDecode(prefs!.getString("timetable_timing") ?? "\"[]\""));
  timetable_subject =
      jsonDecode(jsonDecode(prefs!.getString("timetable_subject") ?? "\"{}\""));
  course_data =
      jsonDecode(jsonDecode(prefs!.getString("course_data") ?? "\"{}\""));

  classroom_data = 
      jsonDecode(prefs!.getString("classroom")??"{}");
  rootRefresh!();
}

void updateMapToStorage(String id, dynamic x) async {
  await prefs!.setString(id, jsonEncode(x));
}

void updateListToStorage(String id, dynamic x) async {
  await prefs!.setString(id, jsonEncode(x));
}

Future<bool> checkNetwork() async {
  if(kIsWeb) return true;
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

Widget padHeight([double p = 5]) {
  return SizedBox(height: p);
}

dynamic nullIfNullElseString(dynamic n) {
  return n!=null ? n.toString() : null; 
}

Widget textField(String labelName,{int? maxLength,TextInputType? keyboardType,List<TextInputFormatter>? inputFormats,FlexFit fit = FlexFit.loose,TextEditingController? controller,bool? enable = true,bool readOnly = false, String? initialText, String? sufText, String? preText,}) {
  BuildContext context = rootCTX!;
  return Flexible(
    fit: fit,
    child: TextFormField(

        enabled: enable,
        readOnly: readOnly,
        initialValue: controller == null ? initialText : null,
        controller: controller,
        keyboardType: keyboardType,
        maxLength: maxLength,
        inputFormatters: inputFormats,

        style: TextStyle(
          fontSize: 13,
            color: Theme.of(context).textSelectionTheme.selectionColor),
        decoration: InputDecoration(
          labelText: labelName,
          prefixText: preText,
          suffixText: sufText,

          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                  color: Theme.of(context)
                      .textSelectionTheme
                      .selectionHandleColor!)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Theme.of(context).textSelectionTheme.selectionColor!)),
          disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Theme.of(context).textSelectionTheme.selectionColor!.withOpacity(0.5))),
          

          isDense: true,
          fillColor: Theme.of(context).textSelectionTheme.cursorColor,
          focusColor: Theme.of(context).textSelectionTheme.selectionHandleColor,
          hoverColor: Theme.of(context).textSelectionTheme.selectionHandleColor,
          
          prefixStyle: TextStyle(
            fontSize: 12,
              color: Theme.of(context).textSelectionTheme.selectionHandleColor),
          labelStyle: TextStyle(
            fontSize: 12,
              color: Theme.of(context).textSelectionTheme.selectionHandleColor),
          counterStyle: TextStyle(
            fontSize: 12,
              color: Theme.of(context).textSelectionTheme.cursorColor),
          floatingLabelStyle: const TextStyle(color: Colors.lightBlue),
        )),
  );
}

Widget textWidget(String text) {
  return Text(
    text,
    style: TextStyle(
      color: Theme.of(rootCTX!).textSelectionTheme.selectionColor,
      fontSize: 12
    ),
  );
}

Widget textDoubleSpanWiget(String a, String b) {
  return Text.rich(
    TextSpan(
      children: [
        TextSpan(
          text: a, 
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(rootCTX!).textSelectionTheme.cursorColor,
            fontWeight: FontWeight.bold
          )
        ),
        TextSpan(
          text: b,
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(rootCTX!).textSelectionTheme.selectionColor,
          ),
        )
      ]
    )
  );
}

Widget textWidgetWithHeavyFont(String text) {
  return Text(
    text,
    style: TextStyle(
        color: Theme.of(rootCTX!).textSelectionTheme.selectionColor,
        fontSize: 17),
  );
}

Widget textWidgetWithBool(String text, bool enable) {
  return Text(
    text,
    style: TextStyle(
      fontSize: 13,
        color: (enable == true)
            ? Theme.of(rootCTX!).textSelectionTheme.cursorColor
            : Theme.of(rootCTX!).textSelectionTheme.selectionColor),
  );
}

Widget textWidgetWithTransparency(String text, double trans) {
  return Text(
    text,
    style: TextStyle(
      color: Theme.of(rootCTX!)
          .textSelectionTheme
          .selectionColor!
          .withOpacity(trans),
    ),
  );
}

class uiSecondaryWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).buttonColor.withOpacity(0.8),
        body: uiSecondaryWidgetFn ?? const SizedBox());
  }
}

void snackbarText(String text) {
  ScaffoldMessenger.of(rootCTX!).showSnackBar(SnackBar(
    content: Text(text),
  ));
}

Map<String, dynamic> convertDynamicToMap(dynamic x) {
  Map<String, dynamic> ret = {};

  for(var a in (x as Map).entries ) {
    ret[a.key.toString()] = a.value;
  }

  return ret;
}