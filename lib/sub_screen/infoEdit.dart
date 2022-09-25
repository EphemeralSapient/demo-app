import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ngp/database.dart';
import 'package:ngp/global.dart' as global;
import 'package:ngp/ui/toggleButton.dart';



void promptStaffInfoEdit() {
  global.switchToSecondaryUi(staffs_info());
  global.temp = () {
    global.switchToPrimaryUi();
  };
}

class staffs_info extends StatefulWidget {
  @override
  State<staffs_info> createState() => _staffs_infoState();
}

class _staffs_infoState extends State<staffs_info> {
  TextEditingController firstName = TextEditingController(text: global.accObj?.firstName);
  TextEditingController lastName = TextEditingController(text: global.accObj?.lastName);
  TextEditingController phoneNo = TextEditingController(text: global.nullIfNullElseString(global.accObj?.phoneNo));
  TextEditingController passwordController = TextEditingController();

  Map<String, dynamic> choices = {};

  bool ob = true;

  @override
  void initState() {
    for(var x in global.departmentWithClasses.entries) {
      choices[x.key] = [false, x.value["full"]];
    }
    super.initState();
  }

  InputDecoration dec(IconData? icon, String hint) {
    return InputDecoration(    
      
      contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
      prefixIcon: Icon(icon,color: Colors.deepPurpleAccent),
      prefixIconColor: Colors.red,
      prefixStyle: const TextStyle(color: Colors.deepPurpleAccent),    
      suffix: SizedBox(height: 20,width: 20,child: IconButton(onPressed: () => setState(() => ob=!ob), icon: Icon(ob == true ? Icons.visibility_off : Icons.visibility_rounded, color: Theme.of(context).textSelectionTheme.selectionColor,))),                
      hintText: hint,
      isDense: true,
      
      border: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.deepPurpleAccent, width: 1.0),
        borderRadius: BorderRadius.circular(5.0),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25.0),
        borderSide: const BorderSide(
          width: 0.0,
          color: Colors.blueAccent,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5.0),
        borderSide: const BorderSide(
          color: Colors.deepPurpleAccent,
          width: 0.0,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5.0),
        borderSide: const BorderSide(
          color: Colors.redAccent,
          width: 5
        )
      ),

      hintStyle: const TextStyle(color: Colors.deepPurpleAccent),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Future.delayed(const Duration(), () async {
            if(firstName.text == "" || lastName.text == "" || phoneNo.text == "" || passwordController.text == "") {
              global.alert.quickAlert(
                context,
                global.textWidget("Please fill the following form")
              );
            } else {

              bool success = true;

              try {
                
                var newAcc = global.accObj!;
                newAcc.firstName = firstName.text;
                newAcc.lastName = lastName.text;
                newAcc.lastSeen = Timestamp.now();
                newAcc.updatedAt = Timestamp.now();
                newAcc.phoneNo = int.parse(phoneNo.text);
                newAcc.isStudent = false;
                newAcc.handlingDepartment = [];
                for(var x in choices.entries) {
                  if(x.value[0] == true) {
                    newAcc.handlingDepartment!.add(x.key);
                  }
                }
                global.Database!.update(global.Database!.addCollection("acc", "/acc"), global.loggedUID! , newAcc.toJson());

                db_fetch_return checkPerm = await global.Database!.get(global.Database!.addCollection("permissionLevel", "/permissionLevel"), passwordController.text);

                if(checkPerm.status == db_fetch_status.error) {
                  throw Error();
                } else {
                  global.passcode = passwordController.text;
                  global.prefs!.setString("passcode", passwordController.text);
                }
              } catch(e) {
                debugPrint(e.toString());
                success = false;
                global.alert.quickAlert(context , global.textWidget("Invalid password, try again | ${e.toString()}"));
              }

              if(success) {
                global.restartApp();
              } else {
                global.temp();
              }
            }
          });
        },
        backgroundColor: Theme.of(context).textSelectionTheme.selectionHandleColor,
        child: Icon(Icons.done, color: Theme.of(context).backgroundColor),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      backgroundColor: Theme.of(context).buttonColor.withOpacity(0.5),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        //reverse: true,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [  
            Center(
                child: global.textWidgetWithHeavyFont(
                    "Staff Information Form [Required]")),

            const SizedBox(height: 40),
            // Name
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                global.textField("First Name", controller: firstName, initialText: firstName.text),
                const SizedBox(
                  width: 15,
                ),
                global.textField("Last Name",controller: lastName, initialText: lastName.text),
              ],
            ),
            const SizedBox(height: 25),          

            global.textField("Phone Number", preText: "+91 " ,controller: phoneNo , initialText: phoneNo.text,keyboardType: TextInputType.number, inputFormats: [ FilteringTextInputFormatter.digitsOnly ] , maxLength: 10),

            const SizedBox(height: 25),

            TextFormField(
              obscureText: ob,
              maxLines: 1,
              style: const TextStyle(
                fontSize: 18.0,
                color: Colors.deepPurpleAccent,
              ),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                if (value!.isEmpty) {
                  return ("Passcode is required.");
                }
                return null;
              },
              decoration: dec(Icons.password_rounded, "Passcode"),
              controller: passwordController,
              keyboardType: TextInputType.visiblePassword,
              textInputAction: TextInputAction.done,
            ),

            const SizedBox(height: 45),

            global.textWidget("Choose the department[s]"),
            
            const SizedBox(height: 10),

            Wrap(
              spacing: 5.0,
              runSpacing: 3.0,
              children: [
                for(var x in choices.entries)
                  FilterChip(
                    label: Text(x.value[0] == false ? x.key.toUpperCase() : "${x.key.toUpperCase()} - ${x.value[1]}", style: TextStyle(backgroundColor: Colors.transparent,color: Theme.of(context).textSelectionTheme.cursorColor) ),
                    selected: x.value[0],
                    onSelected: (value) => setState(() => x.value[0] = value),
                    shadowColor: Theme.of(context).backgroundColor,
                    //disabledColor: Colors.blue,
                    //selectedColor: Colors.blue,
                    backgroundColor: Theme.of(context).buttonColor,
                    checkmarkColor: Theme.of(context).buttonColor,
                    surfaceTintColor: Colors.transparent,
                    selectedShadowColor: Theme.of(context).textSelectionTheme.cursorColor,
                    pressElevation: 10,
                  )
              ],
            )
          ]
        )
      )
    );
  }
}

void promptStudentsInfoEdit() {
  global.switchToSecondaryUi(students_info());
  global.temp = () {
    global.switchToPrimaryUi();
  };
}

class students_info extends StatefulWidget {
  @override
  State<students_info> createState() => _stuents_infoState();
}

class _stuents_infoState extends State<students_info> {
  TextEditingController firstName = TextEditingController(text: global.accObj?.firstName);
  TextEditingController lastName = TextEditingController(text: global.accObj?.lastName);
  TextEditingController phoneNo = TextEditingController(text: global.nullIfNullElseString(global.accObj?.phoneNo));
  TextEditingController regNo = TextEditingController(text: global.nullIfNullElseString(global.accObj?.registerNum));
  TextEditingController rollNo = TextEditingController(text: global.nullIfNullElseString(global.accObj?.rollNo));

  String? department = global.accObj?.department == '-' ? null : global.accObj?.department;
  String? year = global.accObj?.year == '-' ? null : global.accObj?.year;
  String? section = global.accObj?.section == '-' ? null : global.accObj?.section;

  bool? daysSholar = global.accObj?.isDayscholar ?? true;
  bool? busStudent = global.accObj?.collegeBus ?? false;
  TextEditingController busNo = TextEditingController(text: global.nullIfNullElseString(global.accObj?.collegeBusId));

  @override
  Widget build(BuildContext context) {

    debugPrint("Rebuilding students info form");
    debugPrint(department);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
           if(firstName.text == "" || lastName.text == "" || phoneNo.text == "" || regNo.text == "" || rollNo.text == "" || (busStudent == true && busNo.text == "" || year == null || department == null || section == null)) {
             global.alert.quickAlert(
                context,
                global.textWidget("Field values can't be empty; fill available box to proceed."),
                title: global.textWidgetWithHeavyFont("Error"),
                dismissible: true,
                popable: true,
              );
           } else {
              bool success = true;
              try {
                var newAccObj = global.accObj!;
                newAccObj.updatedAt = Timestamp.now();
                newAccObj.firstName = firstName.text;
                newAccObj.lastName = lastName.text;
                newAccObj.phoneNo = int.parse(phoneNo.text);
                newAccObj.collegeBus = busStudent;
                newAccObj.collegeBusId = int.parse(busNo.text != "" ? busNo.text : "0");
                newAccObj.registerNum = int.parse(regNo.text);
                newAccObj.rollNo = rollNo.text;
                newAccObj.isDayscholar = daysSholar;
                newAccObj.department = department!.toLowerCase();
                newAccObj.isStudent = true;
                newAccObj.year = year;
                newAccObj.section = section;
                newAccObj.classBelong = "${department!.toLowerCase()}_$year$section";
                global.accObj = newAccObj;
                global.Database!.update(global.Database!.addCollection("acc", "/acc"), global.loggedUID! , newAccObj.toJson());
              } catch(e) {
                debugPrint(e.toString());
                global.alert.quickAlert(
                  context,
                  global.textWidget(e.toString()),
                  title: global.textWidgetWithHeavyFont("Error"),
                  dismissible: true,
                  popable: true,
                );
                success = false;
              }

              if(success == true) {
                global.restartApp();
              } else {
                global.temp();
              } 
            }
           
        },
        backgroundColor: Theme.of(context).textSelectionTheme.selectionHandleColor,
        child: Icon(Icons.done, color: Theme.of(context).backgroundColor),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      backgroundColor: Theme.of(context).buttonColor.withOpacity(0.5),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        //reverse: true,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
                child: global.textWidgetWithHeavyFont(
                    "Student Information Form [Required]")),

            const SizedBox(height: 40),
            // Name
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                global.textField("First Name", controller: firstName, initialText: firstName.text),
                const SizedBox(
                  width: 15,
                ),
                global.textField("Last Name",controller: lastName, initialText: lastName.text),
              ],
            ),
            const SizedBox(height: 25),

            global.textField("Register Number",controller: regNo, initialText: regNo.text , keyboardType: TextInputType.number, inputFormats: [ FilteringTextInputFormatter.digitsOnly ], maxLength: 12 ),

            const SizedBox(height: 25),

            global.textField("Roll Number",controller: rollNo, initialText: rollNo.text ,keyboardType: TextInputType.number, maxLength: 8),

            const SizedBox(height: 25),

            global.textField("Phone Number", preText: "+91 " ,controller: phoneNo , initialText: phoneNo.text,keyboardType: TextInputType.number, inputFormats: [ FilteringTextInputFormatter.digitsOnly ] , maxLength: 10),

            const SizedBox(height: 40),

            DropdownButton(
              hint: global.textWidget("Department"),
              dropdownColor: Theme.of(context).buttonColor.withOpacity(0.8),
              isExpanded: true,
              value: department,
              items : [
                for(MapEntry<String, dynamic> item in global.departmentWithClasses.entries)
                  DropdownMenuItem(value: item.key, child: global.textWidget(item.value["full"]))
              ],
              onChanged : (val) {
                setState(() => department = val.toString());
              }
            ),

            const SizedBox(height: 25,),

            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: DropdownButton(
                    dropdownColor: Theme.of(context).buttonColor.withOpacity(0.8),
                    hint: global.textWidget("Year"),
                    isExpanded: true,
                    value: year,
                    items : [
                      for(MapEntry<String, dynamic> item in global.year.entries)
                        DropdownMenuItem(value: item.key, child: global.textWidget(item.value["full"]))
                    ],
                    onChanged : (val) {
                      setState(() => year = val.toString());
                    }
                  ),
                ),

                SizedBox(width: 20),

                Flexible(
                  child: DropdownButton(
                    hint: global.textWidget("Section"),
                    dropdownColor: Theme.of(context).buttonColor.withOpacity(0.8),
                    isExpanded: true,
                    value: section,
                    items : [
                      DropdownMenuItem(value: "a", child: global.textWidget("A")),
                      DropdownMenuItem(value: "b", child: global.textWidget("B"))                      
                    ],
                    onChanged : (val) {
                      setState(() => section = val.toString());
                    }
                  ),
                ),
              ],
            ),

            const SizedBox(height: 40),

            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 240,
                  child: toggle(
                    callback: (val) {
                      setState(() {busStudent = val;});
                      return busStudent;
                    }, 
                    text: "College Bus?",
                    icon: Icons.bus_alert_rounded,
                    color:  Theme.of(context).backgroundColor,
                    activeString: "Yes",
                    inactiveString: "No", 
                  )
                ),
                
                const SizedBox(width: 20),

                global.textField("Bus number",controller: busNo , initialText: busNo.text ,fit: FlexFit.tight, enable: busStudent, keyboardType: TextInputType.number, inputFormats: [ FilteringTextInputFormatter.digitsOnly ], maxLength: 2 )
              ],
            ),

            //const SizedBox(height: 15,),

            toggle(
              callback: (val) {
                setState( () {daysSholar = val;});
                return daysSholar;
              },
              text: "Hosteller?",
              icon: Icons.local_hotel,
              color: Theme.of(context).backgroundColor,
              activeString: "Yes",
              inactiveString: "No",
            ),


          ],
        ),
      ),
    );
  }
}
