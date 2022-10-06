import 'dart:convert';
import 'dart:ui';

import 'package:flutter/services.dart';
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
List<String> depart = ["All"];

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
        data=info;
      } else {
        CollectionReference _collectionRef = global.Database!.addCollection("classroom", "/class");
        QuerySnapshot querySnapshot = await _collectionRef.get();
        allClassInfo = querySnapshot.docs.map((doc) => doc.data()).toList();
      }

      setState( () => loading = false);

    });
  }

  @override
  Widget build(BuildContext context) {

    List<String> departments = ["All"];
    for(Map<String, dynamic> x in allClassInfo) {
      if(x.containsKey("department") && departments.contains(x["department"]) == false) {
        departments.add(x["department"]);
      }
    }

    var todayDate = DateFormat("dd-MM-yyyy").format(DateTime.now()).toString();

    String per(int? strength, int? count) {
      if(strength == null || count == null) {
        return "-";
      } else {
        return ( (count/strength) * 100 ).toInt().toString();
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

                global.padHeight(30),

                Wrap(
                  children: [
                    ChoiceChip(
                      label: Text("Check Class Attendance Sheet"),
                      avatar: Icon(Icons.add_task),
                      onSelected: (bool val) {
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
                      selected: false,
                      
                    )
                  ],
                )
              ],
            )
          ),
        )

        :
        
        Padding(
          padding: const EdgeInsets.all(28.0),
          child: SingleChildScrollView(
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
                                      global.textWidgetWithHeavyFont("${x["year"].toString().toUpperCase()}  ${x["department"].toString().toUpperCase()}-${x["section"].toString().toUpperCase()}"),
                                    
                                      SizedBox(height: 20,),
                                      
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          global.textDoubleSpanWiget("Absentees Count : ", "${x["leaveData"] != null && x["leaveData"][todayDate] != null ? x["leaveData"][todayDate].last?.values?.where((e) => e == true).length.toString() : "-"} | ${per((x["endRoll"] ?? 61) - (x["startRoll"] ?? 1), x["leaveData"] != null && x["leaveData"][todayDate] != null ? x["leaveData"][todayDate].last?.values?.where((e) => e == true).length: null)}%"),
                                          global.textDoubleSpanWiget("On Duty Count : ", "${x["leaveData"] != null && x["leaveData"][todayDate] != null ? x["leaveData"][todayDate].last?.values?.where((e) => e == false).length.toString() : "-"} | ${per((x["endRoll"] ?? 61) - (x["startRoll"] ?? 1), x["leaveData"] != null && x["leaveData"][todayDate] != null ? x["leaveData"][todayDate].last?.values?.where((e) => e == false).length: null)}%"),
                                        ],
                                      ),
                                      global.padHeight(15),
                                      global.textDoubleSpanWiget("Total Strength : ", x["endRoll"]!=null && x["startRoll"]!=null ? (x["endRoll"]-x["startRoll"]).toString() : "Not configured"),
                                      //global.textDoubleSpanWiget("Current on going class : ", "Not Implemented"),
                                      //global.padHeight(),
                                      //global.textDoubleSpanWiget("Class faculty : ", "null")
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
          data=null;
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
              global.textWidgetWithHeavyFont("${x["year"].toString().toUpperCase()}  ${x["department"].toString().toUpperCase()}-${x["section"].toString().toUpperCase()}"),

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
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (c, a1, a2) => timeTableEditUi(),
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
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (c, a1, a2) => classInfoEditUi(),
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
  final int startRoll = data["startRoll"] ?? 1;
  final int endRoll = data["endRoll"] ?? 60;
  Map studentInfo = {};
  @override
  void initState() {
    super.initState();
    Future.delayed( const Duration() ,() async {
      try{
        var get = await global.collectionMap["acc"]!.where("class", isEqualTo: data["classCode"]).get();
        var l = [
          for(var x in get.docs)
            x.data()
        ];
        for(dynamic x in l)
          // ignore: curly_braces_in_flow_control_structures
          if(x["registerNum"] != null) {
            debugPrint(int.parse(x["registerNum"].toString().substring(x["registerNum"].toString().length - 3)) .toString());
            studentInfo[int.parse(x["registerNum"].toString().substring(x["registerNum"].toString().length - 3))] = "${x["firstName"]} ${x["lastName"]}";
          }

        setState(() {});
      } catch(e) {
        debugPrint(e.toString());
      }
    }); 
  }
 
  bool odCheck = false;
  Map od = {};

  @override
  Widget build(BuildContext context) {
    String chosenDateStr = DateFormat("dd-MM-yyyy").format(chosenDay).toString();

    if(data["leaveData"] == null) {
      data["leaveData"] = {};
    }

    if(data["leaveData"][chosenDateStr] == null) {
      data["leaveData"][chosenDateStr] = [{}];
    }

    Map leaveData = data["leaveData"][chosenDateStr].last;

    if(odCheck == false && data["leaveData"][chosenDateStr].length > 0) {
      odCheck = true;
      for(var x in data["leaveData"][chosenDateStr][data["leaveData"][chosenDateStr].length-1].entries) {
        if(x.value == false) {
          od[x.key] = true;
        }
      }
    }


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
      floatingActionButton: (global.accountType == 1) ? FloatingActionButton.extended(
        onPressed: () async {
          Navigator.pop(context);

          Map newMap = {"checkBy" : "${global.accObj!.firstName} ${global.accObj!.lastName}"};

          for(var x in leaveData.keys) {
            if(leaveData[x] == true) {
              newMap[x.toString()] = true;
            }
          }
          for(var x in od.keys) {
            if(od[x] == true) {
              newMap[x.toString()] = false;
            }
          }

          //Removing the cache
          data["leaveData"][chosenDateStr].remove(data["leaveData"][chosenDateStr].last);

          if(data["leaveData"][chosenDateStr].isEmpty || data["leaveData"][chosenDateStr].last["checkBy"] != newMap["checkBy"]) {
            data["leaveData"][chosenDateStr].add(newMap);
          
          } else {
            data["leaveData"][chosenDateStr].last = newMap;
          }

          debugPrint(data.toString());
          final get = await global.Database!.update(global.Database!.addCollection("class", "/class"), data["classCode"], data);

          ScaffoldMessenger.of(global.rootCTX!).showSnackBar(SnackBar(
            content: Text(get.status == db_fetch_status.success ? "Successfully updated the attendance!" : "Failed to update, ${get.data.toString()}"),
          ));
        },
        label: const Text("UPDATE", style: TextStyle(color: Colors.white),),
        icon: const Icon(CupertinoIcons.refresh_thick),
      ) : null,

      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
                            odCheck = false;
                          });
                        }),
                    ),
                  ),
                ),
              ),
        
              SizedBox(height:30),
        
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: AnimatedContainer(
                  duration: const Duration(seconds: 1),
                  //clipBehavior: Clip.antiAlias,
                  color: Theme.of(context).buttonColor,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        for(var x in [[Icons.warning, "Class information is not defined properly [such as starting/end roll no]; Advised to update classroom info.", data["lastUpdate"] == null],[Icons.info, "Attendance has been checked by ${data["leaveData"][chosenDateStr].isNotEmpty ? data["leaveData"][chosenDateStr].last["checkBy"] : "null"}", data["leaveData"][chosenDateStr].last["checkBy"] != null]]..iterator)
                          if(x[2] == true)
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Flexible(child: Icon(x[0] as IconData, color: Theme.of(context).textSelectionTheme.selectionHandleColor)),
        
                                  Flexible(flex: 8,child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: global.textWidget(x[1] as String),
                                  )),
                                ],
                              ),
                            )
        
                      ],
                    ),
                  )
                ),
              ),
        
        
              SizedBox(height: 20,),
              global.textWidgetWithHeavyFont("Select roll no. to mark as absent"),
              SizedBox(height:10),
        
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 60, top: 5, left: 8, right: 8),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
              
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Wrap(
                        clipBehavior: Clip.antiAlias,
                        children: [
                          for(int i = startRoll; i<= endRoll; i++)
                            Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: ChoiceChip(
                                onSelected: (bool val) {
                                  setState(() {
                                    leaveData[i.toString()] = val;
                                  });
                                },
                                selected : leaveData[i.toString()] ?? false,
                                label: Text("${i.toString()}${studentInfo[i] != null ? "- ${studentInfo[i]}" : ""}"),
                              ),
                            )
                        ],
                      ),
                    ),
                  ),
                ),
              ),


              SizedBox(height: 20,),
              global.textWidgetWithHeavyFont("Select roll no. to mark On-Duty"),
              SizedBox(height:10),
        
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 60, top: 5, left: 8, right: 8),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
              
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Wrap(
                        clipBehavior: Clip.antiAlias,
                        children: [
                          for(int i = startRoll; i<= endRoll; i++)
                            Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: ChoiceChip(
                                selectedColor: Colors.orangeAccent,
                                onSelected: (bool val) {
                                  setState(() {
                                    od[i.toString()] = val;
                                  });
                                },
                                selected : od[i.toString()] ?? false,
                                label: Text("${i.toString()}${studentInfo[i] != null ? "- ${studentInfo[i]}" : ""}"),
                              ),
                            )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
        
        
            ],
          ),
        ),
      ) 

    );
  }
}

class timeTableEditUi extends StatefulWidget {
  @override
  State<timeTableEditUi> createState() => _timeTableEditUiState();
}

class _timeTableEditUiState extends State<timeTableEditUi> {

  Map timetable = {};
  List courseList = [];

  @override
  void initState() {
    super.initState();
    timetable = jsonDecode(data["timeTable"] ?? "{}");
    courseList = data["course"] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).buttonColor.withOpacity(0.3),
      appBar: AppBar(
        title: global.textWidget("Time Table update sheet"),
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

          debugPrint(data.toString());
          final get = await global.Database!.update(global.Database!.addCollection("class", "/class"), data["classCode"], data);

          ScaffoldMessenger.of(global.rootCTX!).showSnackBar(SnackBar(
            content: Text(get.status == db_fetch_status.success ? "Successfully updated the attendance!" : "Failed to update, ${get.data.toString()}"),
          ));
        },
        label: const Text("UPDATE", style: TextStyle(color: Colors.white),),
        icon: const Icon(CupertinoIcons.refresh_thick),
      ),

      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 5,
                children: [
                  ChoiceChip(
                    label: const Text("Create a new course data"),
                    avatar: Icon(Icons.create),
                    selected: false,
                    onSelected: (bool val) {
                      
                      TextEditingController codeName = TextEditingController();
                      TextEditingController fullName = TextEditingController();
                      TextEditingController facultyName = TextEditingController();
        
                      List facultyList = [];
                      String chosenF = "no one";
        
                      Future.delayed(Duration(), () async {
                        var get = await global.collectionMap["acc"]!.where("isStudent", isEqualTo: false).where("phoneNo", isNotEqualTo: null).get();
        
                        var l = [
                          for(var x in get.docs)
                            x.data()
                        ];
                        
                        global.quickAlertGlobalVar(() {
                          for(dynamic x in l) {
                            if(x["phoneNo"] != null) {
                              facultyList.add("${x["firstName"]} ${x["lastName"]}");
                            }
                          }
                        });
                      });
        
                      global.alert.quickAlert(context, SizedBox(),bodyFn: () => Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
        
                          global.textWidget("Fill the following details"),
                          SizedBox(height:20),
        
                          global.textField("Subject Code Name", controller: codeName),
        
                          SizedBox(height:10),
        
                          global.textField("Subject Full Name", controller: fullName),
        
                          SizedBox(height: 20),
        
                          DropdownButton(
                            items: [
                              for(var x in [["No one", "no one"],["Custom name instead of choice", "cn"]])
                                DropdownMenuItem(
                                  value : x[1],
                                  child: global.textWidget(x[0]),
                                )
                            ,
                              for(var x in facultyList)
                                DropdownMenuItem(
                                  value : x,
                                  child: global.textWidget(x)
                                )
                            ],
                            onChanged: (val) {
                              global.quickAlertGlobalVar(() => chosenF = val.toString());
                            },
                            value: chosenF,
                            dropdownColor: Theme.of(context).buttonColor,
                          ),
        
                          SizedBox(height: 20),
        
                          if(chosenF == "cn")
                            global.textField("Faculty name", controller: facultyName)
                        ],
                      ),
        
                        action: [
                          FloatingActionButton(
                            onPressed: () {
                              Navigator.pop(context);
        
                              Future.delayed(Duration(), () async {
                                String message = "Successfully added the course in the list";
        
                                if(codeName.text == "" || fullName.text == "") {
                                  message = "Failed, field values was not properly filled!";
                                } else {
                                  courseList.add({
                                    "name" : "${codeName.text} - ${fullName.text}",
                                    "code" : codeName.text,
                                    "full" : fullName.text,
                                    "faculty" : chosenF == "cn" ? facultyName.text : chosenF
                                  });
                                  data["course"] = courseList;
        
                                  var get = await global.Database!.update(global.collectionMap["classroom"]!, data["classCode"], data);
        
                                  if(get.status != db_fetch_status.success) {
                                    message = "Error, ${get.data}";
                                  }
                                }
        
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text(message),
                                ));
                                setState(() {});
                              });
                            },
                            child: Text("Submit")
                          )
                        ]
                      );
                    },
                  ),
        
                  ChoiceChip(
                    label: const Text("Change the timing"),
                    avatar: Icon(Icons.timeline),
                    selected: false,
                    onSelected: (bool val) {
        
                    },
                  ),
                ],
              ),
        
        
              SizedBox(height: 20),
              global.textWidget("Drag and drop the courses into specific day"),
        
              SizedBox(height: 30),
        
              ConstrainedBox(
                constraints: BoxConstraints.loose(Size(double.infinity, 200)),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        global.textWidgetWithHeavyFont("COURSES   :"),
                        
                      for(var x in courseList)
                        Draggable(
                          data: x,
                          feedback: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.redAccent),
                                  borderRadius: BorderRadius.circular(10)
                                ),
                                //height: 35,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(x["name"], style: TextStyle(fontSize: 15,))
                                )
                              ),
                            ],
                          ),
                        
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.lightBlue),
                              borderRadius: BorderRadius.circular(10)
                            ),
                            height: 35,
                            //width: 250,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: global.textWidget(x["name"]),
                            )
                          ),
                        
                        ),
                        
                      ],
                    ),
                  ),
                ),
              ),
        
        
              SizedBox(height: 30),
        
              Flexible(
                child : SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for(var x in {"0": "Monday", "1": "Tuesday","2": "Wednessday", "3": "Thursday","4": "Friday", "5":"Saturday"}.entries)
                        DragTarget(
                          onAccept:(dynamic dataa) {
                            List info = [
                              dataa["name"],
                              dataa["faculty"]
                            ];
        
                            if(timetable[x.key] != null && timetable[x.key].isNotEmpty) {
                              timetable[x.key].add(info);
                            } else {
                              timetable[x.key] = [info];
                            }
        
                            setState(() {
                              data["timeTable"] = jsonEncode(timetable);
                            });
                          },
                          onWillAccept: (data) => true,
                          builder: (BuildContext buildContext, List a, List b) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ShaderMask(
                              shaderCallback: (Rect rect) {
                                return const LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [
                                    Colors.black,
                                    Colors.transparent,
                                    Colors.transparent,
                                    Colors.black,
                                  ],
                                  stops: [0.0, 0.1, 0.9, 1.0],
                                ).createShader(rect);
                              },
                              blendMode: BlendMode.dstOut,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    global.textWidgetWithHeavyFont("${x.value} :"),
                              
                                    for(List y in timetable[x.key]??{} )
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(color: Colors.cyanAccent),
                                            borderRadius: BorderRadius.circular(10)
                                          ),
                              
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: global.textWidget(y[0]),
                                              ),
                              
                                              IconButton(
                                                onPressed: () {
                                                  setState(() => timetable[x.key].remove(y));
                                                  data["timeTable"] = jsonEncode(timetable);
                                                },
                                                icon: Icon(Icons.close, color: Theme.of(context).textSelectionTheme.selectionColor,),
                                              )
                              
                                            ],
                                          ),
                                        ),
                                      )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
        
                      ,
        
                    SizedBox(height:40),
        
                    DragTarget(
                        onAccept:(dataa) {
                          debugPrint("Ok deleting the ${dataa.toString()}");
                          courseList.remove(dataa);
        
                          Future.delayed(Duration(), () async {
                            String message = "Successfully removed the course in the list";
                              data["course"] = courseList;
                              var get = await global.Database!.update(global.collectionMap["classroom"]!, data["classCode"], data);
        
                              if(get.status != db_fetch_status.success) {
                                message = "Error, ${get.data}";
                              }
        
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(message),
                            ));
                            setState(() {});
                          });
        
                        },
                        onWillAccept: (data) => true,
                        builder: (BuildContext buildContext, List a, List b) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              global.textWidget("Remove The Course [Drag it here]"),
                            ],
                          ),
                        ),
                      ),
        
                      DragTarget(
                        onAccept:(dynamic dataa) {
                          TextEditingController codeName = TextEditingController(text: dataa["code"]);
                          TextEditingController fullName = TextEditingController(text: dataa["full"]);
                          TextEditingController facultyName = TextEditingController(text: dataa["faculty"]);
        
                          List facultyList = [];
                          String chosenF = "no one";
        
                          Future.delayed(Duration(), () async {
                            var get = await global.collectionMap["acc"]!.where("isStudent", isEqualTo: false).where("phoneNo", isNotEqualTo: null).get();
        
                            var l = [
                              for(var x in get.docs)
                                x.data()
                            ];
                            
                            global.quickAlertGlobalVar(() {
                              for(dynamic x in l) {
                                if(x["phoneNo"] != null) {
                                  facultyList.add("${x["firstName"]} ${x["lastName"]}");
                                }
                              }
        
                            });
                          });
        
                          global.alert.quickAlert(context, SizedBox(),bodyFn: () => Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
        
                              global.textWidget("Fill the following details"),
                              SizedBox(height:20),
        
                              global.textField("Subject Code Name", controller: codeName),
        
                              SizedBox(height:10),
        
                              global.textField("Subject Full Name", controller: fullName),
        
                              SizedBox(height: 20),
        
                              DropdownButton(
                                items: [
                                  for(var x in [["No one", "no one"],["Custom name instead of choice", "cn"]])
                                    DropdownMenuItem(
                                      value : x[1],
                                      child: global.textWidget(x[0]),
                                    )
                                ,
                                  for(var x in facultyList)
                                    DropdownMenuItem(
                                      value : x,
                                      child: global.textWidget(x)
                                    )
                                ],
                                onChanged: (val) {
                                  global.quickAlertGlobalVar(() => chosenF = val.toString());
                                },
                                value: chosenF,
                                dropdownColor: Theme.of(context).buttonColor,
                              ),
        
                              SizedBox(height: 20),
        
                              if(chosenF == "cn")
                                global.textField("Faculty name", controller: facultyName)
                            ],
                          ),
        
                            action: [
                              FloatingActionButton(
                                onPressed: () {
                                  Navigator.pop(context);
        
                                  Future.delayed(Duration(), () async {
                                    String message = "Successfully updated the course in the list";
        
                                    if(codeName.text == "" || fullName.text == "") {
                                      message = "Failed, field values was not properly filled!";
                                    } else {
                                      courseList[courseList.indexOf(dataa)] =
                                      {
                                        "name" : "${codeName.text} - ${fullName.text}",
                                        "code" : codeName.text,
                                        "full" : fullName.text,
                                        "faculty" : chosenF == "cn" ? facultyName.text : chosenF
                                      };
                                      data["course"] = courseList;
        
                                      var get = await global.Database!.update(global.collectionMap["classroom"]!, data["classCode"], data);
        
                                      if(get.status != db_fetch_status.success) {
                                        message = "Error, ${get.data}";
                                      }
                                    }
        
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                      content: Text(message),
                                    ));
                                    setState(() {});
                                  });
                                },
                                child: Text("Update")
                              )
                            ]
                          );
                        },
                        onWillAccept: (data) => true,
                        builder: (BuildContext buildContext, List a, List b) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              global.textWidget("Update The Course data [Drag it here]"),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ),
              SizedBox(height: 30)
            ],
          ),
        ),
      )
    );
  }
}

class classInfoEditUi extends StatelessWidget {
  TextEditingController startRoll = TextEditingController(text: data["startRoll"].toString());
  TextEditingController endRoll = TextEditingController(text: data["endRoll"].toString());
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Theme.of(context).buttonColor.withOpacity(0.3),
      appBar: AppBar(
        title: global.textWidget("Class Info update sheet"),
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

          data["startRoll"] = int.parse(startRoll.text);
          data["endRoll"] = int.parse(endRoll.text);

          debugPrint(data.toString());
          final get = await global.Database!.update(global.Database!.addCollection("class", "/class"), data["classCode"], data);

          ScaffoldMessenger.of(global.rootCTX!).showSnackBar(SnackBar(
            content: Text(get.status == db_fetch_status.success ? "Successfully updated the class information!" : "Failed to update, ${get.data.toString()}"),
          ));
        },
        label: const Text("UPDATE", style: TextStyle(color: Colors.white),),
        icon: const Icon(CupertinoIcons.refresh_thick),
      ),

      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
                        SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: global.textWidgetWithHeavyFont("Roll number structure"),
            ),

            SizedBox(height: 10),

            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    global.textField("Starting Roll No", controller: startRoll, keyboardType: TextInputType.number, inputFormats: [ FilteringTextInputFormatter.digitsOnly ], maxLength: 3 ),
                    SizedBox(width:30),
                    global.textField("Ending Roll No", controller: endRoll, keyboardType: TextInputType.number, inputFormats: [ FilteringTextInputFormatter.digitsOnly ], maxLength: 3 ),
                  ],
                ),
              ),
            )
          ],
        )
      )
    );
  }


}