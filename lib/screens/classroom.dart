import 'dart:ui';

import 'package:intl/intl.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_field/date_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ngp/database.dart';
import 'package:ngp/global.dart' as global;
import 'package:semicircle_indicator/semicircle_indicator.dart';

dynamic data;

class classroom extends StatefulWidget {
  const classroom({super.key});

  @override
  State<classroom> createState() => _classroomState();
}

class _classroomState extends State<classroom> {

  Map<dynamic,dynamic> info = {};
  List<dynamic> allClassInfo = [];
  bool loading = true;

  @override void initState() {
    super.initState();
    
    if(global.accountType == 3) return; 

    Future.delayed(const Duration(), () async { 
      if(global.accountType == 2){
         var get = await global.Database!.get( global.Database!.addCollection("classroom", "/class"), global.accObj!.classBelong!);

        if(get.status == db_fetch_status.nodata) {
          // Create the damned thing
          var data = {"department" : global.accObj!.department, "classCode" : global.accObj!.classBelong ,"year" : global.accObj!.year ,"section" : global.accObj!.section};
          await global.Database!.create(global.collectionMap["classroom"]!, global.accObj!.classBelong!, data);
          info = data;
        } else {
          info = get.data as Map;
        }
      } else {
        CollectionReference _collectionRef = global.Database!.addCollection("classroom", "/class");
        QuerySnapshot querySnapshot = await _collectionRef.get();
        allClassInfo = querySnapshot.docs.map((doc) => doc.data()).toList();
      }

      setState( () => loading = false);

    });
  }

  List<String> depart = ["All"];

  @override
  Widget build(BuildContext context) {

    List<String> departments = ["All"];
    for(Map<String, dynamic> x in allClassInfo) {
      if(x.containsKey("department") && departments.contains(x["department"]) == false) {
        departments.add(x["department"]);
      }
    }

    return Scaffold(
      backgroundColor: Theme.of(context).buttonColor,
      body: global.accountType == 2 ?
        Padding(
          padding: const EdgeInsets.all(20),
          
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,

              children: [
                global.padHeight(10),
                Card(
                  color: Theme.of(context).buttonColor.withOpacity(0.3),
                  surfaceTintColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  borderOnForeground: false,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("         ${global.accObj!.year!.toUpperCase()}   ${global.accObj!.department!.toUpperCase()}-${global.accObj!.section!.toUpperCase()}         ", 
                      style: TextStyle(
                        color: Theme.of(context).textSelectionTheme.selectionHandleColor,
                        fontSize: 29
                      ),
                    ),
                  ),
                ),

                global.padHeight(45),

                global.textWidgetWithHeavyFont("PERSONAL RECORD"),
                global.padHeight(10),
                Card(
                  color: Theme.of(context).buttonColor.withOpacity(0.3),
                  surfaceTintColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  borderOnForeground: false,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: double.infinity,
                      height: 150,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              SizedBox(
                                height: 130,
                                width: 110,
                                child: Card(
                                  color: Theme.of(context).buttonColor.withOpacity(0.6),
                                  surfaceTintColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  borderOnForeground: false,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Stack(
                                      clipBehavior: Clip.none,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: global.textWidget("Attendance"),
                                        ),

                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Center(
                                            child: SemicircularIndicator(
                                              radius: 30,
                                              strokeWidth: 2,
                                              contain: true,
                                              backgroundColor: Colors.white,
                                              color: Colors.orange,
                                              bottomPadding: 0,
                                              child: Text(
                                                '75%',
                                                style: TextStyle(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w600,
                                                    color: Theme.of(context).textSelectionTheme.cursorColor),
                                              ),
                                            ),
                                          ),
                                        ),

                                      ],
                                    )
                                  ),
                                ),
                              ),


                              SizedBox(
                                height: 130,
                                width: 110,
                                child: Card(
                                  color: Theme.of(context).buttonColor.withOpacity(0.6),
                                  surfaceTintColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  borderOnForeground: false,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Stack(
                                      clipBehavior: Clip.none,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: global.textWidget("Test score"),
                                        ),

                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Center(
                                            child: SemicircularIndicator(
                                              radius: 30,
                                              strokeWidth: 2,
                                              progress: 0.35,
                                              contain: true,
                                              backgroundColor: Colors.white,
                                              color: Colors.blue,
                                              bottomPadding: 0,
                                              child: Text(
                                                '35%',
                                                style: TextStyle(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w600,
                                                    color: Theme.of(context).textSelectionTheme.cursorColor),
                                              ),
                                            ),
                                          ),
                                        ),

                                      ],
                                    )
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    )
                  ),
                ),

                global.padHeight(),
                global.textDoubleSpanWiget("Status :", " Present on the class right now."),
                                

                global.padHeight(45),

                global.textWidgetWithHeavyFont("CLASS RECORD"),
                global.padHeight(10),
                Card(
                  color: Theme.of(context).buttonColor.withOpacity(0.3),
                  surfaceTintColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  borderOnForeground: false,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: double.infinity,
                      height: 150,
                      child: SingleChildScrollView()
                    )
                  ),
                ),

                global.padHeight(30)
              ],
            )
          ),
        )

        :
        
        Padding(
          padding: const EdgeInsets.all(28.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ChoiceChip(
                label: global.textWidget("Department : ${depart.join(",")}"),
                onSelected:(value) {
                  global.alert.quickAlert(
                    context,
                    SizedBox(),
                    bodyFn : () {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          for(String x in departments)
                            InkWell(
                              onTap: () {
                                global.quickAlertGlobalVar(() {
                                  if(!depart.contains(x)) {
                                    depart.add(x);
                                  } else {
                                    depart.remove(x);
                                  }
                                });
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  global.textWidget(x),
                                  
                                  Checkbox(
                                    value: depart.contains(x),
                                    onChanged: (bool? val) {
                                      global.quickAlertGlobalVar(() {
                                        if(!depart.contains(x)) {
                                          depart.add(x);
                                        } else {
                                          depart.remove(x);
                                        }
                                      });
                                    },
                                  )
                                ],
                              ),
                            ),
                        ]
                      );
                    },

                    popFn: () {
                      setState(() {
                        //depart = changeDepart;
                      });
                    },
                    opacity: 0.5
                  );
                },
                selected: false,
                backgroundColor: Theme.of(context).buttonColor,
              ),

              SizedBox(height: 25,),

              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for(var x in allClassInfo)
                      if(x["department"] != null && (depart.contains("All") || depart.contains(x["department"])))
                        Card(
                           shadowColor: Colors.transparent,
                           surfaceTintColor: Colors.transparent,
                           color: Theme.of(context).buttonColor.withOpacity(0.5),
                           child: InkWell(
                            onTap: () {
                              data = x;
                              global.switchToSecondaryUi(classInfoUI());
                            },
                             child: SizedBox(
                              height: 175,
                              width: double.infinity,
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    global.textWidgetWithHeavyFont("${x["year"]}  ${x["department"]}-${x["section"]}"),
                                  
                                    SizedBox(height: 20,),
                                    
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        global.textDoubleSpanWiget("Absentees Count : ", "${x["absents"]} | null%"),
                                        global.textDoubleSpanWiget("On Duty Count : ", "${x["onduty"]}"),
                                      ],
                                    ),
                                    global.padHeight(15),
                                    global.textDoubleSpanWiget("Current on going class : ", "null"),
                                    global.padHeight(),
                                    global.textDoubleSpanWiget("Class faculty : ", "null")
                                  ],
                                ),
                              ),
                             ),
                           ),
                        )
                  ],
                ),
              )
            ],
          ),
        )
        ,
    );
  }

}

class classInfoUI extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var x = data ?? {};
    return Scaffold(
      backgroundColor: Theme.of(context).buttonColor.withOpacity(0.0),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          global.switchToPrimaryUi();
        },
        label: Text("Done", style: TextStyle(color: Colors.white),),
        icon: Icon(Icons.done),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(right: 30, left: 30, top: 20, bottom: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              global.textWidgetWithHeavyFont("${x["year"]}  ${x["department"]}-${x["section"]}"),

              SizedBox(height:40),

              Card(
                shadowColor: Colors.transparent,
                surfaceTintColor: Colors.transparent,
                color: Theme.of(context).buttonColor.withOpacity(0.5),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: InkWell(
                  onTap: () {
                    debugPrint("Prompting attendance checklist UI");
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (c, a1, a2) => attendanceChecklist(),
                        opaque: false,
                        transitionsBuilder: (context, animation, secondaryAnimation, child) => FadeTransition(opacity: animation, child:
                          ScaleTransition(
                            scale: animation.drive(
                              Tween(begin: 1.5, end: 1.0).chain(
                                CurveTween(curve: Curves.easeOutCubic)
                              ),
                            ),
                            child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: animation.value * 20, sigmaY: animation.value * 20),
                                child:  child,
                            )
                          )
                        ),  
                        transitionDuration: const Duration(seconds: 1)
                      )
                    );

                  },
                  child: SizedBox(
                    height: 100,
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.all(28.0),
                            child: Text(
                              "Attendance Checklist",
                              style : TextStyle(
                                color: Theme.of(context).textSelectionTheme.selectionColor,
                                fontSize: 24,
                                letterSpacing: 1.3,
                                fontFamily: "Metropolis"
                              )
                            )
                          )
                        ),

                        Container(
                          height: double.infinity,
                          width: 7,
                          color: Colors.lightBlue,
                        )
                      ],
                    )
                  )
                )
              ),

              SizedBox(height:15),
              Card(
                shadowColor: Colors.transparent,
                surfaceTintColor: Colors.transparent,
                color: Theme.of(context).buttonColor.withOpacity(0.5),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: InkWell(
                  onTap: () {
                    debugPrint("Prompting Time Table [Edit] UI");
                  },
                  child: SizedBox(
                    height: 100,
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.all(28.0),
                            child: Text(
                              "Update Time Table",
                              style : TextStyle(
                                color: Theme.of(context).textSelectionTheme.selectionColor,
                                fontSize: 24,
                                letterSpacing: 1.3,
                                fontFamily: "Metropolis"
                              )
                            )
                          )
                        ),

                        Container(
                          height: double.infinity,
                          width: 7,
                          color: Colors.deepPurpleAccent,
                        )
                      ],
                    )
                  )
                )
              ),

              SizedBox(height:15),
              Card(
                shadowColor: Colors.transparent,
                surfaceTintColor: Colors.transparent,
                color: Theme.of(context).buttonColor.withOpacity(0.5),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: InkWell(
                  onTap: () {
                    debugPrint("Prompting Class Info [Edit] UI");
                  },
                  child: SizedBox(
                    height: 100,
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.all(28.0),
                            child: Text(
                              "Update Class Information",
                              style : TextStyle(
                                color: Theme.of(context).textSelectionTheme.selectionColor,
                                fontSize: 24,
                                letterSpacing: 1.3,
                                fontFamily: "Metropolis"
                              )
                            )
                          )
                        ),

                        Container(
                          height: double.infinity,
                          width: 7,
                          color: Colors.brown,
                        )
                      ],
                    )
                  )
                )
              ),

              SizedBox(height: 40),
              global.textWidget("Adding more data in here, such as Absentees name [current day], and then class info in an overview [class strength, roll start to end no.]")
            ],
          ),
        ),
      ),
    );  
  }

}

class attendanceChecklist extends StatefulWidget {
  @override
  State<attendanceChecklist> createState() => _attendanceChecklistState();
}

class _attendanceChecklistState extends State<attendanceChecklist> {
  DateTime chosenDay = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).buttonColor.withOpacity(0.3),
      appBar: AppBar(
        title: global.textWidget("Attendance update sheet"),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back, color: Theme.of(context).textSelectionTheme.selectionHandleColor,),
        ),
        backgroundColor: Theme.of(context).buttonColor.withOpacity(0.8),
        shadowColor: Colors.transparent,
        foregroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(35),
              bottomLeft: Radius.circular(35)),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          Navigator.pop(context);

          final get = await global.Database!.update(global.Database!.addCollection("class", "/class"), data["classCode"], data);

          ScaffoldMessenger.of(global.rootCTX!).showSnackBar(SnackBar(
            content: Text(get.status == db_fetch_status.success ? "Successfully updated the attendance!" : "Failed to update, ${get.data.toString()}"),
          ));
        },
        label: const Text("UPDATE", style: TextStyle(color: Colors.white),),
        icon: const Icon(CupertinoIcons.refresh_thick),
      ),

      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,

          children: [
            SizedBox(height:30),

            Center(
              child: Container(
                height: 50,
                width: 200,
                decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).textSelectionTheme.selectionColor!),
                  borderRadius: BorderRadius.circular(10)
                ),
                clipBehavior: Clip.antiAlias,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      
                    },
                    child: DateTimeField(
                      initialEntryMode:
                          DatePickerEntryMode.calendarOnly,
                      mode: DateTimeFieldPickerMode.date,
                      dateTextStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context)
                              .textSelectionTheme.selectionColor),
                      decoration: const InputDecoration(
                        isDense: true,
                        border: InputBorder.none,
                      ),
                      selectedDate: chosenDay,
                      onDateSelected: (DateTime value) {
                        setState(() {
                          chosenDay = value;
                        });
                      }),
                  ),
                ),
              ),
            ),


            
          ],
        ),
      ) 

    );
  }
}