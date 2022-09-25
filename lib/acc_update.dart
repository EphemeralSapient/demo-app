
import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:ngp/database.dart';

import './global.dart' as global;


bool isLock = false;
bool isNew = false;
int rev = 0;

void releaseLockAccUpdate() {
  isLock = false;
  rev++;
}

// Function gets invoked when dashboard gets started
void initUpdater(bool? override) async {
  // TODO : Add support for staff account type
  if ((isLock == true || global.accountType == 3) && override != true) {
    return;
  } else {
    isLock=true;
  }

  int lockRev = rev;
  // If the student haven't chose the class yet.
  if(global.accountType == 2 && global.accObj!.classBelong == "pending") {
    while(global.accObj!.classBelong == "pending") {
      await Future.delayed(const Duration(milliseconds: 250));
    }
    debugPrint("Class value got assigned | ${global.accObj!.classBelong}");
    isNew = true;    
  }

  if(global.prefs!.getBool("classPending") == true) {
    debugPrint("Automatic sign in verified");
    global.prefs!.setBool("classPending", false);
  }

  // Upate occurred on user database
  StreamSubscription<DocumentSnapshot<Object?>>? sub;
  sub = global.Database!.addCollection("acc", "/acc").doc(global.loggedUID!).snapshots().listen((event) async {
      
      if(rev!=lockRev) {
        sub?.cancel();
        return;
      }

      dynamic data = event.data();

      if(data == null) return debugPrint("Data was not supplied in /acc collection stream event listener");


      final oldData = global.accObj!;
      var newData = global.accObj!.fromJSON(data as Map<String, dynamic>);

      //Self init the hash since there's no value in hash map yet.
      if(newData.hashes.isEmpty == true){
        var s = "Self init hash value ${DateTime.now().toString()}";
        global.Database!.update(global.Database!.addCollection("acc", "/acc"), global.loggedUID!, {"hashes" : {"timetable_timing" : s, "timetable_subject" : s }});
      }

      if(oldData.hashes.toString().compareTo(newData.hashes.toString()) != 0) {
      
        final oh = oldData.hashes;
        final nh = newData.hashes;
        bool canUpdate = true;
        if(oh["timetable_timing"] != nh["timetable_timing"]){
          // Accessing the /timetable from the database; contains Reference to document -> List<String>
          var ttCollectRef = global.Database!.addCollection("timetable", "/timetable");

          var get = await global.Database!.get(ttCollectRef, newData.classBelong ?? "??");
          debugPrint("Updating time table Timing for ${newData.classBelong ?? "??"} class.");

          if(get.status == db_fetch_status.exists) {
            dynamic fetchedData = get.data;
            fetchedData = await fetchedData["timing"].get();
            fetchedData = fetchedData.data();

            debugPrint("Successfully fetched the time table timing data! | ${fetchedData.toString()}");
            global.timetable_timing = fetchedData["time"];
            global.updateListToStorage("timetable_timing", jsonEncode(fetchedData["time"]));
          } else { canUpdate = false; debugPrint("${get.status} | ${get.data.toString()}");}
  
        } if(oh["timetable_subject"] != nh["timetable_subject"]){
           debugPrint("Updating time table subject data");
          // Time table subjects contains Map<String, Map<String, dynamic>>
          var ttCollectRef = global.Database!.addCollection("course", "/course");

          var get = await global.Database!.get(ttCollectRef, newData.classBelong ?? "??");
          debugPrint("Updating time table subjects [/course] for ${newData.classBelong ?? "??"} class.");

          if(get.status == db_fetch_status.exists) {
            dynamic fetchedData = get.data;
            fetchedData = fetchedData["courseMap"];

            debugPrint("Successfully fetched the time table subject data! | ${fetchedData.toString()}");
            global.timetable_subject = fetchedData;
            global.updateListToStorage("timetable_subject", jsonEncode(fetchedData));
          } else { canUpdate = false; debugPrint("${get.status} | ${get.data.toString()}");}
        } if(oh["course_data"] != nh["course_data"]) {
          debugPrint("Updating course data");
          // Contains course info such as subject full details
          var ttCollectRef = global.Database!.addCollection("course", "/course");

          var get = await global.Database!.get(ttCollectRef, newData.classBelong ?? "??");

          if(get.status == db_fetch_status.exists) {
            dynamic fetchedData = get.data;

            debugPrint("Successfully fetched the time course data! | $fetchedData");
            global.course_data = jsonDecode(fetchedData["courseInfo"] ?? "{}");
            global.updateListToStorage("course_data", fetchedData);
          } else { canUpdate = false; }
        }

        if(canUpdate == true) global.updateMapToStorage("hashes",nh);

      } else if(oldData.toString() != newData.toString()) {
        debugPrint("something inside the class changed!");
      
      } else {
        debugPrint("Stream on /acc event got recived with no changes between new and old account data");
      }
      
      global.accObj = newData;  
    },
    onError: (e) {
      debugPrint("What, error? $e");
    }
  );
}


void oneTimeCheckAndUpdate() async {

}