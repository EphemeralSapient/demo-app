
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
  Timestamp? createdAt, lastSeen, updatedAt;

  String? classBelong = "None";
  String? firstName, lastName;

  bool isStudent = false;
  bool? isDayscholar;

  bool? collegeBus;
  int? collegeBusId;

  int? registerNum;
  String? rollNo;

  int? phoneNo;
  //int? parentPhoneNo;

  int? roomNo;
  int? hostelType;

  
  // Staff
  List<dynamic>? handlingDepartment;
  

  String? department = "-";
  String? year = "-";
  String? section = "-";
  Map<String, dynamic> hashes = global.hashes; // Despite using "dynamic", it is "String"
  int? notificationCount = 0;

  


  account_obj fromJSON(Map<String, Object?> Data) {
    account_obj newObj = account_obj();

    //newObj.timeStamp = Data["loginTimeStamp"];

    newObj.createdAt = Data["createdAt"] as Timestamp?;
    newObj.updatedAt = Data["updatedAt"] as Timestamp?;
    newObj.lastSeen = Data["lastSeen"] as Timestamp?;
    newObj.classBelong = Data["class"] as String?;
    newObj.firstName = Data["firstName"] as String?;
    newObj.lastName = Data["lastName"] as String?;
    newObj.rollNo = Data["rollNo"] as String?;

    newObj.isDayscholar = Data["isDayscholar"] as bool?;
    newObj.collegeBus = Data["collegeBus"] as bool?;
    newObj.collegeBusId = Data["collegeBusId"] as int?;
    newObj.registerNum = Data["registerNum"] as int?;
    newObj.phoneNo = Data["phoneNo"] as int?;

    newObj.isStudent = Data["isStudent"] as bool;
    newObj.notificationCount = Data["notifications"] as int?;
    newObj.department = Data["department"] as String?;
    newObj.year = Data["year"] as String?;
    dynamic hashesCheck = Data["hashes"];
    newObj.hashes = (hashesCheck != null) ? hashesCheck as Map<String,dynamic> : {};
    newObj.section = Data["section"] as String?;
    
    newObj.handlingDepartment = Data["handlingDepartment"] as List<dynamic>?;


    return newObj;
  }

  @override
  String toString() {
    return "$classBelong $department $year $section $hashes $isStudent $notificationCount";
  }

  Map<String, Object?> toJson() {
    return {
      //"loginTimeStamp" : timeStamp,
      "createdAt" : createdAt,
      "updatedAt" : updatedAt,
      "lastSeen" : lastSeen,
      "firstName" : firstName,
      "lastName" : lastName,

      "rollNo" : rollNo,
      "registerNum" : registerNum,
      "phoneNo" : phoneNo,
      "isDayscholar":isDayscholar,
      "collegeBus" : collegeBus,
      "collegeBusId" : collegeBusId,

      "handlingDepartment" : handlingDepartment,
      
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

  // Gotta remove this needless function
  Map<String, Object?> toJsonUpdateLogin() {
    return {
      //"loginTimeStamp" : timeStamp
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