import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ngp/database.dart';
import 'package:ngp/global.dart' as global;
import 'package:ngp/sub_screen/infoEdit.dart';

class profile extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: Theme.of(context).buttonColor,
      body: Center(
        child: global.textWidgetWithHeavyFont("WIP"),
      ),
    );
  }
}
