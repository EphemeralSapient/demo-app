
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:ngp/global.dart' as global;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

enum db_fetch_status {
  exists,
  nodata,
  error,
  success // Meant for update,set, and delete operations
}

class db_fetch_return {
  db_fetch_status? status;
  Object? data;

  db_fetch_return(db_fetch_status s,Object? d) {
    status = s;
    data = d;
  }


}
class account_obj {
  dynamic timeStamp;
  String? classBelong = "None";
  String? department = "-";
  String? year = "-";
  String? section = "-";
  Map<String, dynamic> hashes = global.hashes; // Despite using "dynamic", it is "String"
  bool isStudent = false;
  int? notificationCount = 0;
  


  account_obj fromJSON(Map<String, Object?> Data) {
    account_obj newObj = account_obj();

    newObj.timeStamp = Data["loginTimeStamp"];
    newObj.classBelong = Data["class"] as String?;
    newObj.isStudent = Data["isStudent"] as bool;
    newObj.notificationCount = Data["notifications"] as int?;
    newObj.department = Data["department"] as String?;
    newObj.year = Data["year"] as String?;
    dynamic hashesCheck = Data["hashes"];
    newObj.hashes = (hashesCheck != null) ? hashesCheck as Map<String,dynamic> : {};
    newObj.section = Data["section"] as String?;


    return newObj;
  }

  @override
  String toString() {
    return "$timeStamp $classBelong $department $year $section $hashes $isStudent $notificationCount";
  }

  Map<String, Object?> toJson() {
    return {
      "loginTimeStamp" : timeStamp,
      "new" : true,
      "notifications" : notificationCount,
      "class" : classBelong,
      "isStudent" : isStudent,
      "department" : department,
      "year" : year,
      "hashes" : hashes,
      "section" : section,
    };
  }

  Map<String, Object?> toJsonUpdateLogin() {
    return {
      "loginTimeStamp" : timeStamp
    };
  }
}

class db {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  
  db() {
    firestore.settings=const Settings(persistenceEnabled: true,cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED);
    debugPrint("Okay inited");
    //firestore.
  }

  CollectionReference<Object?> addCollection(String name,String path) {
    if(global.collectionMap.containsKey(name) == true) return global.collectionMap[name]!; // Returns if exists already
    global.collectionMap[name] = firestore.collection(path); // Adding the collection
    return global.collectionMap[name]!;
  }

  Future<db_fetch_return> get(CollectionReference<Object?> collection, String id) async {
     try {
      DocumentSnapshot<Object?> snapshot = await collection.doc(id).get();

      if(snapshot.exists) {

        return db_fetch_return(db_fetch_status.exists, snapshot.data());
      } else {

        return db_fetch_return(db_fetch_status.nodata, null);
      }

    } catch(e) {

      // Error occurred [network issue]
      debugPrint("Error on processing $id document ${e.toString()}");
      return db_fetch_return(db_fetch_status.error,e.toString());
    }
  }

  Future<db_fetch_return> create(CollectionReference<Object?> collection, String id, Object dataForUpdate) async {
     try {
       
       await collection.doc(id).set(dataForUpdate);
       return db_fetch_return(db_fetch_status.success, null);

    } catch(e) {

      // Error occurred [network issue]
      debugPrint("Error on processing $id document ${e.toString()}");
      return db_fetch_return(db_fetch_status.error,e.toString());
    }
  }


  Future<db_fetch_return> update(CollectionReference<Object?> collection, String id, Map<String, Object?> dataForUpdate) async {
     try {
       
       await collection.doc(id).update(dataForUpdate);
       return db_fetch_return(db_fetch_status.success, null);

    } catch(e) {

      // Error occurred [network issue]
      debugPrint("Error on processing $id document ${e.toString()}");
      return db_fetch_return(db_fetch_status.error,e.toString());
    }
  }
  
}