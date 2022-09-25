import 'dart:ui';
import 'package:ngp/global.dart' as global;
import 'package:flutter/material.dart';
import 'package:date_field/date_field.dart';
import 'package:flutter/widgets.dart';

void leaveFormPrompt(BuildContext buildContext) {
  showModalBottomSheet(
      context: buildContext,
      backgroundColor: Colors.transparent,
      builder: (context) => Center(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                blendMode: BlendMode.srcIn,
                child: Container(
                  height: 200,
                  width: double.infinity,
                  //color: Theme.of(buildContext).buttonColor,
                  decoration: BoxDecoration(
                      color: Theme.of(buildContext).buttonColor,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20))),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 5),
                      Container(
                        height: 5,
                        width: 125,
                        decoration: BoxDecoration(
                            color: Theme.of(buildContext)
                                .textSelectionTheme
                                .selectionHandleColor!
                                .withOpacity(0.25),
                            borderRadius: BorderRadius.circular(50)),
                      ),
                      SizedBox(height: 20),
                      ListTile(
                        leading: Icon(
                          Icons.view_compact,
                          color: Theme.of(buildContext)
                              .textSelectionTheme
                              .selectionHandleColor,
                        ),
                        title: Text(
                          "View the leave applications",
                          style: TextStyle(
                            color: Theme.of(buildContext)
                                .textSelectionTheme
                                .cursorColor,
                          ),
                        ),
                        onTap: () {
                          debugPrint("paging to View Leave Applicaitons");
                        },
                      ),
                      global.accountType == 2
                          ? ListTile(
                              leading: Icon(Icons.add_circle,
                                  color: Theme.of(buildContext)
                                      .textSelectionTheme
                                      .selectionHandleColor),
                              title: Text(
                                "Apply for new leave application",
                                style: TextStyle(
                                  color: Theme.of(buildContext)
                                      .textSelectionTheme
                                      .cursorColor,
                                ),
                              ),
                              onTap: () {
                                global.switchToSecondaryUi(leaveFormApply());
                                Navigator.of(buildContext).pop();
                                debugPrint(
                                    "paging to APPLY a new Leave Applicaitons");
                              },
                            )
                          : const SizedBox(),
                    ],
                  ),
                ),
              ),
            ),
          ));
}

class leaveFormApply extends StatefulWidget {
  @override
  State<leaveFormApply> createState() => _leaveFormApplyState();
}

class _leaveFormApplyState extends State<leaveFormApply> {
  DateTime startDate = DateTime.now();

  DateTime endDate = DateTime.now().add(const Duration(days: 1));

  final myController = TextEditingController(text: "Purpose for leave");

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          global.padHeight(20),
          Center(
              child: Text(
            'Student Leave Form',
            style: TextStyle(
                color: Theme.of(context).textSelectionTheme.cursorColor,
                //decoration: TextDecoration.overline,
                fontSize: 24),
          )),
          global.padHeight(50),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            global.textWidget(
                "Branch : ${global.accObj!.department!.toUpperCase()} - ${global.accObj!.section!.toUpperCase()}"),
            global.textWidget("Year : ${global.accObj!.year!.toUpperCase()}"),
            global.textWidget("Roll Number : adding this too!"),

            //global.textWidget("Semester : ??")
          ]),
          global.padHeight(20),
          Text.rich(
            TextSpan(
              text: 'Name of the student : ',
              style: TextStyle(
                  fontSize: 20,
                  color: Theme.of(context).textSelectionTheme.selectionColor),
              children: <TextSpan>[
                TextSpan(
                  text: 'DIOOOOO',
                  style: TextStyle(
                      fontSize: 20,
                      color: Theme.of(context).textSelectionTheme.cursorColor),
                ),
                // can add more TextSpans here...
              ],
            ),
          ),
          global.padHeight(20),
          Text.rich(
            TextSpan(
              text: 'Register number : ',
              style: TextStyle(
                  fontSize: 20,
                  color: Theme.of(context).textSelectionTheme.selectionColor),
              children: <TextSpan>[
                TextSpan(
                  text: '7107123456',
                  style: TextStyle(
                      fontSize: 20,
                      color: Theme.of(context).textSelectionTheme.cursorColor),
                ),
                // can add more TextSpans here...
              ],
            ),
          ),
          global.padHeight(45),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                children: [
                  global.textWidgetWithHeavyFont("From date :"),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: 100,
                    height: 50,
                    child: DateTimeField(
                        initialEntryMode: DatePickerEntryMode.calendarOnly,
                        mode: DateTimeFieldPickerMode.date,
                        dateTextStyle: TextStyle(
                            color: Theme.of(context)
                                .textSelectionTheme
                                .cursorColor),
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context)
                                    .textSelectionTheme
                                    .cursorColor!),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context)
                                    .textSelectionTheme
                                    .cursorColor!),
                          ),
                        ),
                        selectedDate: startDate,
                        onDateSelected: (DateTime value) {
                          setState(() {
                            startDate = value;
                          });
                        }),
                  ),
                ],
              ),
              Row(
                children: [
                  global.textWidgetWithHeavyFont("To date :"),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: 100,
                    height: 50,
                    child: DateTimeField(
                        initialEntryMode: DatePickerEntryMode.calendarOnly,
                        mode: DateTimeFieldPickerMode.date,
                        dateTextStyle: TextStyle(
                            color: Theme.of(context)
                                .textSelectionTheme
                                .cursorColor),
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context)
                                    .textSelectionTheme
                                    .cursorColor!),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context)
                                    .textSelectionTheme
                                    .cursorColor!),
                          ),
                        ),
                        selectedDate: endDate,
                        onDateSelected: (DateTime value) {
                          setState(() {
                            endDate = value;
                          });
                        }),
                  ),
                ],
              ),
            ],
          ),
          global.padHeight(20),
          TextField(
            controller: myController,
            style: TextStyle(
                color: Theme.of(context).textSelectionTheme.cursorColor),
            minLines: 1,
            maxLines: 7,
            decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                    color: Theme.of(context).textSelectionTheme.cursorColor!),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                    color: Theme.of(context).textSelectionTheme.cursorColor!),
              ),
            ),
            onChanged: (text) {
              // Wut to do here
            },
          ),
          global.padHeight(20),
          ElevatedButton.icon(
            onPressed: () {
              global.uiPageControl!.animateToPage(0, duration: const Duration(seconds: 1), curve: Curves.easeInOutExpo);
            },
            icon: Icon(Icons.done), 
            label: global.textWidget("Submit"),
            style: ElevatedButton.styleFrom(
              shadowColor: Colors.transparent,
              primary: Theme.of(context).buttonColor
            )
          )
        ],
      ),
    );
  }
}
