import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart' show Marquee;
import 'package:ngp/global.dart' as global;
import 'package:intl/intl.dart' show DateFormat;

bool currentIsList1 = true;
List<String> startTime=["00:00","00:00"],endTime=["00:00","00:00"],
              subjectName=["Loading...", "Loading..."];
Widget? l1,l2;
void Function(void Function())? setStateTTS;
bool disposed = true;

bool fnLock = false;
Future<void> fnInit() async {
  if(fnLock == true) return;
  fnLock = true;

  List<dynamic> ttT;
  Map<dynamic, dynamic> ttS;
  bool flag = false;

  while(true){
    await Future.delayed(const Duration(seconds: 5));

    ttS = global.timetable_subject;
    ttT = global.timetable_timing;

    // Timing or subject data isn't there, yet.
    if(ttS.isEmpty == true || ttT.isEmpty == true) continue;

    debugPrint("5 second check running");

    var curr = currentIsList1 == true ? 0 : 1;
    var next = currentIsList1 == false ? 0 : 1;

    var timeNow = DateTime.now();
    var nowTime = DateFormat("hh:mm").parse("${timeNow.hour}:${timeNow.minute}");
    var currEndTime = DateFormat("hh:mm").parse(endTime[curr]);

    // Current time is beyond current subject period timing, changing the subject.
    if(nowTime.isAfter(currEndTime)) {
      String? nextTime;
      int nextTimeIndex = 1;
      bool currTimeInList = ttT.contains(endTime[curr]);

      for(int x = 0; x<ttT.length; x++) {

        if(nowTime.isBefore(DateFormat("hh:mm").parse(ttT[x])) == true) {
          if(x==0){
            nextTimeIndex = -1;
            break;
          }
          
          nextTime = ttT[x];
          nextTimeIndex = x;
          break;
        }
      }

      if((nextTime != null || nextTimeIndex == -1) && ttS[timeNow.weekday.toString()] != null) {
        // Next subject timing exists!

        subjectName[next] =  ttS[timeNow.weekday.toString()][nextTimeIndex-1];
        startTime[next] = ttT[nextTime != null ? nextTimeIndex-1 : 0];
        endTime[next] = ttT[nextTime != null ? nextTimeIndex : 1];
        flag = false;

        debugPrint("Next subject data : ${subjectName[next]} | ${startTime[next]} | ${endTime[next]}");
        setStateTTS!(() {
          currentIsList1=!currentIsList1;
        });
      } else if(currTimeInList == true && nextTime == null) {
        // Next subject timing does not exist, make the time to 00:00 so that it won't repeat
        subjectName[next] = "No on-going class";
        startTime[next] = "00:00";
        endTime[next] = "00:00";

        debugPrint("No on going class right now [time table short]");
        flag = false;
        setStateTTS!(() {
          currentIsList1 = !currentIsList1;
        });
      } else if(flag == false && ttS[timeNow.weekday.toString()] == null) {
        flag = true;
        subjectName[next] = "Is this sunday? hoLiDaY";
        startTime[next] = "00:00";
        endTime[next] = "00:00";

        debugPrint("No data were feed for this day | ${timeNow.weekday}");

        setStateTTS!(() {
          currentIsList1 = !currentIsList1;
        });
      } else if (flag == false) {
        flag = true;
        subjectName[next] = "No classes";
        startTime[next] = "00:00";
        endTime[next] = "00:00";


        setStateTTS!(() {
          currentIsList1 = !currentIsList1;
        });
      }
    }



  }
}

class timetable_short extends StatefulWidget {

  @override
  State<timetable_short> createState() => _timetable_shortState();
}

Widget createTTSWidget( int index ) {
  final context = global.rootCTX!;
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
        primary: Theme.of(context).buttonColor,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10))),
    onPressed: (() {
      debugPrint("ok");
      setStateTTS!(() {
        //subjectName[1] = "You have CLICKED tHiS??";
        //currentIsList1 = !currentIsList1;
      });
      // TODO : Expand the time table ui into timeline 
    }),
    child: Padding(
      padding: const EdgeInsets.only(bottom: 10, top: 5),
      child: SizedBox.fromSize(
        size: Size(double.infinity, 150),
        child: Stack(
          children: [
            Text("Current on-going class : ",
                style: TextStyle(
                    color: Theme.of(context)
                        .textSelectionTheme
                        .selectionHandleColor)),
            Padding(
                padding: const EdgeInsets.only(top: 25),
                child: Marquee(
                    text: subjectName[index],
                    //  textDirection: TextDirection.rtl,
                    blankSpace: 20,
                    style: TextStyle(
                        color: Theme.of(context)
                            .textSelectionTheme
                            .selectionColor,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Raleway"),
                    pauseAfterRound: Duration(seconds: 2),
                    crossAxisAlignment:
                        CrossAxisAlignment.start)),
            Align(
                alignment: Alignment.bottomLeft,
                child: Text(startTime[index],
                    style: TextStyle(
                        color: Theme.of(context)
                            .textSelectionTheme
                            .selectionHandleColor))),
            Align(
                alignment: Alignment.bottomRight,
                child: Text(endTime[index],
                    style: TextStyle(
                        color: Theme.of(context)
                            .textSelectionTheme
                            .selectionHandleColor)))
          ],
        ),
      ),
    ));
}

class _timetable_shortState extends State<timetable_short> {

  @override
  void initState(){
    global.timetableCTX = context;
    super.initState();
    setStateTTS = setState;
    disposed = false;
    fnInit();
  }

  @override
  void dispose(){
    disposed = true;
    super.dispose();
    
  }

  Widget build(BuildContext context){
    setStateTTS = setState;
    l1 = createTTSWidget(0);
    l2 = createTTSWidget(1);
    return AnimatedCrossFade(
      firstChild: l1!,
      secondChild: l2!,
      crossFadeState: currentIsList1 == true ? CrossFadeState.showFirst : CrossFadeState.showSecond,
      duration: const Duration(milliseconds: 1250),
    );
  }
}

class timetable_expand extends StatefulWidget {
  @override
  State<timetable_expand> createState() => _timetable_expandState();
}

class _timetable_expandState extends State<timetable_expand> {
  @override
  Widget build(BuildContext context) {
   return SizedBox();
  }
}