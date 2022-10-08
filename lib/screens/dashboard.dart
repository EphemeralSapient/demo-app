import 'package:flutter/material.dart';
import 'package:ngp/sub_screen/assignments.dart';
import 'package:ngp/sub_screen/modifyTimeTable.dart';
import 'package:ngp/sub_screen/moreActions.dart';
import 'package:ngp/sub_screen/timetable.dart';
import '../sub_screen/notification_centre.dart';
import '../sub_screen/events.dart';
import 'package:marquee/marquee.dart' show Marquee;
import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth;
import 'package:ngp/global.dart' as global;

class dash extends StatefulWidget {
  @override
  State<dash> createState() => _dashState();
}

class _dashState extends State<dash> {
  @override
  Widget build(context) {
    debugPrint("building dash screen | Account type : ${global.accountType}");
    return Scaffold(
      backgroundColor: Theme.of(context).buttonColor,
      body: //ShaderMask(

        //shaderCallback: (Rect rect) {
          //return const LinearGradient(
            //begin: Alignment.center,
            //end: Alignment.bottomCenter,
            //colors: [
              //Colors.transparent,
              //Colors.transparent,
              //Colors.black
            //],
            //stops: [0.0, 0.5, 1.0],
          //).createShader(rect);
        //},
        //blendMode: BlendMode.dstOut,

        //child:
         SingleChildScrollView(
          child: Column(children: [
      
            SizedBox(
              height: 200,
              child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Stack(
                    children: [
        
                      Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Colors.transparent,
                          border: Border.all(
                            width: 1.1,
                            color: Colors.red,
                          ),
                        ),
                        width: 45,
                        height: 45,
                        child: ClipOval(
                          child: global.account?.isAnonymous != true
                              ? FadeInImage.assetNetwork(placeholder: "asset/images/loading.gif", image: global.account!.photoURL!)
                              : const Icon(Icons.person),
                        ),
                      ),
                      Positioned(
                          top: 20,
                          left: 60,
                          child: RichText(
                              text: TextSpan(children: [
                            TextSpan(
                                text: "Welcome, ",
                                style: TextStyle(
                                  fontSize: 11,
                                    color: Theme.of(context)
                                        .textSelectionTheme
                                        .selectionHandleColor,
                                    fontFamily: "Montserrat")),
                            TextSpan(
                                text: global.account!.isAnonymous == true
                                    ? "Guest"
                                    : (global.accObj != null)
                                      ? "${global.accObj!.title ?? ""} ${global.accObj!.firstName} ${global.accObj!.lastName}"
                                      : "${global.account!.displayName}!",
                                style: TextStyle(
                                  fontSize: 12,
                                    color: Theme.of(context)
                                        .textSelectionTheme
                                        .cursorColor,
                                    fontFamily: "Montserrat"))
                          ]))),
                      Padding(
                          padding: EdgeInsets.only(top: 60, left: 75),
                          child: timetable_short(),)
                   
                    
                    
                    ],
                  )),
            ),
            
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  global.accountType != 3 ? notifyUi() : const SizedBox(), // Meant only for students and faculty 
      
                  const SizedBox(height: 25,),
      
                  global.accountType != 3 ? moreActionsShort() : const SizedBox(),
      
                  eventsUi(), // Can be accessed by any member
      
                  const SizedBox(height: 25,),
      
                  global.accountType == 2 ? assignmentUi() : const SizedBox(),
      
                  global.accountType == 1 ? modifyTimetableUi() : const SizedBox(),
      
                  
                ],
              ),
            ),
          
            const SizedBox(height: 100)
          ]),
        ),
      //),
    );
  }
}
