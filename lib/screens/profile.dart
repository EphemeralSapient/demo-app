import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ngp/database.dart';
import 'package:ngp/global.dart' as global;
import 'package:ngp/sub_screen/infoEdit.dart';

class profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(), () async {
      db_fetch_return fetch = await global.Database!
          .get(global.collectionMap["acc"]!, global.loggedUID!);
      Map<String, dynamic> data = fetch.data as dynamic;
      debugPrint(data.toString());

      data["test"] = Timestamp.now();

      fetch = await global.Database!
          .update(global.collectionMap["acc"]!, global.loggedUID!, data);
      debugPrint(fetch.status.toString());
    });
    debugPrint(" >>>> Done");
    return SizedBox(height:120, width: 80, child: ElevatedButton(onPressed: () {promptStaffInfoEdit();},child: global.textWidgetWithHeavyFont("click me")));
  }
}
