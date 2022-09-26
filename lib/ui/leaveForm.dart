import 'dart:ui';
import 'package:flutter/cupertino.dart';
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

  final myController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    myController.dispose();
    super.dispose();
  }
  
String leaveType = "sick";

  @override
  Widget build(BuildContext context) {
    debugPrint("Rebuilding students leave form");
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor.withOpacity(1),
      body: SingleChildScrollView(
        child: Padding(
          padding:
              const EdgeInsets.only(top: 30, bottom: 30, left: 10, right: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () {
                      global.switchToPrimaryUi();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: 2.0,
                              color: Theme.of(context).secondaryHeaderColor),
                          borderRadius: const BorderRadius.all(Radius.circular(10))),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Icon(Icons.close_outlined,
                            color: Theme.of(context).secondaryHeaderColor),
                      ),
                    ),
                  ),
                  Text(
                    "APPLY FOR NEW LEAVE",
                    style: TextStyle(
                        color: Theme.of(context).textSelectionTheme.cursorColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  InkWell(
                    onTap: () {},
                    child: Container(
                      decoration: const BoxDecoration(
                          color: Colors.blueAccent,
                          borderRadius: BorderRadius.all(Radius.circular(13))),
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(Icons.done, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 50),
              Card(
                color: Theme.of(context).backgroundColor.withOpacity(1),
                shadowColor: Colors.black,
                surfaceTintColor: Colors.white,
                elevation: 20,
                child: SizedBox(
                  height: 150,
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "TYPE",
                          style: TextStyle(
                              color: Theme.of(context).secondaryHeaderColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),

                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(width: 0.5, color: Theme.of(context).secondaryHeaderColor),
                            borderRadius: BorderRadius.circular(10)
                          ),
                          child: Row(
                            children: [
                              Flexible(
                                child: DropdownButton(
                                  isExpanded: true,
                                  isDense: false,
                                  underline: SizedBox(),
                                  icon: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Icon(
                                        CupertinoIcons.arrowtriangle_down,
                                        size: 17,
                                        color:
                                            Theme.of(context).secondaryHeaderColor,
                                      ),
                                    ),
                                  onChanged: (val) => setState(() {
                                    leaveType = val.toString();
                                  }),
                                  value: leaveType,
                                  items: [
                                    for(var x in {"sick" : [Colors.blue, "Sick Leave"], "duty" : [Colors.yellowAccent, "On Duty"], "what" : [Colors.amber, "????????????????"]}.entries)
                                      DropdownMenuItem(
                                        value: x.key,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Flexible(
                                              child: Padding(
                                                padding: const EdgeInsets.all(18.0),
                                                child: CircleAvatar(
                                                  backgroundColor: x.value[0] as Color,
                                                )
                                              ),
                                            ),
                              
                                            Flexible(
                                              child: Padding(
                                                padding: const EdgeInsets.all(5),
                                                child: global.textWidget(x.value[1] as String),
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Card(
                color: Theme.of(context).backgroundColor.withOpacity(1),
                shadowColor: Colors.black,
                surfaceTintColor: Colors.white,
                elevation: 20,
                child: SizedBox(
                  height: 235,
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "START DATE",
                          style: TextStyle(
                              color: Theme.of(context).secondaryHeaderColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        Flexible(
                          child: InkWell(
                            child: Container(
                              clipBehavior: Clip.antiAlias,
                              height: 35,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 0.5,
                                      color:
                                          Theme.of(context).secondaryHeaderColor),
                                  borderRadius:
                                      const BorderRadius.all(Radius.circular(8))),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Flexible(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10, right: 10),
                                      child: DateTimeField(
                                          initialEntryMode:
                                              DatePickerEntryMode.calendarOnly,
                                          mode: DateTimeFieldPickerMode.date,
                                          dateTextStyle: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(context)
                                                  .secondaryHeaderColor),
                                          decoration: const InputDecoration(
                                            isDense: true,
                                            border: InputBorder.none,
                                          ),
                                          selectedDate: startDate,
                                          onDateSelected: (DateTime value) {
                                            setState(() {
                                              startDate = value;
                                            });
                                          }),
                                    ),
                                  ),
                                  Container(
                                    color: Theme.of(context).hintColor,
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Icon(
                                        Icons.date_range,
                                        color:
                                            Theme.of(context).secondaryHeaderColor,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          "END DATE",
                          style: TextStyle(
                              color: Theme.of(context).secondaryHeaderColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        Flexible(
                          child: InkWell(
                            child: Container(
                              height: 35,
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 0.5,
                                      color:
                                          Theme.of(context).secondaryHeaderColor),
                                  borderRadius:
                                      const BorderRadius.all(Radius.circular(8))),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Flexible(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10, right: 10),
                                      child: DateTimeField(
                                          initialEntryMode:
                                              DatePickerEntryMode.calendarOnly,
                                          mode: DateTimeFieldPickerMode.date,
                                          dateTextStyle: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(context)
                                                  .secondaryHeaderColor),
                                          decoration: const InputDecoration(
                                            isDense: true,
                                            border: InputBorder.none,
                                          ),
                                          selectedDate: endDate,
                                          onDateSelected: (DateTime value) {
                                            setState(() {
                                              endDate = value;
                                            });
                                          }),
                                    ),
                                  ),
                                  Container(
                                    color: Theme.of(context).hintColor,
      
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Icon(
                                        Icons.date_range,
                                        color:
                                            Theme.of(context).secondaryHeaderColor,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 10,),
      
              Card(
                color: Theme.of(context).backgroundColor.withOpacity(1),
                shadowColor: Colors.black,
                surfaceTintColor: Colors.white,
                elevation: 20,
                child: SizedBox(
                  height: 150,
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "REASON",
                          style: TextStyle(
                              color: Theme.of(context).secondaryHeaderColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
      
                        global.textField("", controller: myController)
                      ],
                    ),
                  ),
                ),
              ),
      
            ],
          ),
        ),
      ),
    );
  }
}
