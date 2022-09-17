import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ngp/database.dart';
import 'package:ngp/global.dart' as global;
import 'terminate.dart';

const staffIds = [
  "ilavarasans@drngpit.ac.in",
  "nowayofway@gmail.com"
];

/*
  Future.delayed(const Duration(milliseconds : 1500),() async {
    Navigator.pop(global.loginScreenRouteCTX!);
    await Future.delayed(const Duration(milliseconds: 500));
*/

bool lock = false;
Future<String?> validate(int typo) async {
    if(lock == true) return "Already in process.";
    lock = true;
    
    //Verification process ----------------------------------------------
     // Adding the collection information to the map
    debugPrint("Validating the account info...");
    global.loggedUID = global.account!.uid;
    debugPrint("Validating the uid [${global.loggedUID.toString()}]");      

    // Adds 
    db_fetch_return check; // Temp variable for checking operation status
    db_fetch_return get = await global.Database!.get(global.Database!.addCollection("acc","/acc") , global.loggedUID.toString());

    if(get.status == db_fetch_status.error) return "Error : ${get.data}";

    
    global.accObj!.timeStamp = DateTime.now().toUtc().toIso8601String();

    if(get.status == db_fetch_status.nodata) {
      // Create the data
      global.accObj!.isStudent = global.accountType == 2;
      global.accObj!.classBelong = "pending";
      debugPrint("Creating the data");

      // Updating
      check = await global.Database!.create(global.collectionMap["acc"]!, global.loggedUID.toString(), global.accObj!.toJson());

      if(check.status == db_fetch_status.error) return "Account creation failed : ${check.data.toString()}";
    } else {
      debugPrint(get.data!.toString());
      Map<String, dynamic> getData = get.data! as Map<String, dynamic>;

      global.accObj = global.accObj!.fromJSON(getData);
      global.accObj!.hashes = {};

    }
    
    // Updating the existing 
    check = await global.Database!.update(global.collectionMap["acc"]!, global.loggedUID.toString(), global.accObj!.toJsonUpdateLogin());

    if(check.status == db_fetch_status.error) return "Account update failed : ${check.data.toString()}";


    // // Verification and creation stage over ---------------------------------
    global.accountType = typo;
    await global.prefs!.setInt("accountType", typo);
    // if(staffIds.contains(global.account!.email) == true) {
    //   global.accountType = 1;

    //   // Pass code is required here to proceed
      

    // } else {
    //   global.accountType =2;
    
       if(typo == 2) {
         await global.prefs!.setBool("classPending", true);
       }


    // }
    

  Future.delayed(const Duration(milliseconds: 500), () async {
    Navigator.pop(global.loginScreenRouteCTX!);
    await Future.delayed(const Duration(milliseconds: 1000));
    terminateFn();
    lock = false;
  });

  return null;
  //});
}