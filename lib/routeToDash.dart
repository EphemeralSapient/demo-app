// ignore_for_file: file_names, camel_case_types, use_build_context_synchronously

import 'dart:ui';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:drop_shadow/drop_shadow.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ngp/database.dart';
import 'package:ngp/screens/dashboard.dart';
import 'package:ngp/screens/message.dart';
import 'package:ngp/screens/settings.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:ngp/acc_update.dart';
import 'global.dart' as global;

final image = const NetworkImage("https://images.unsplash.com/photo-1540122995631-7c74c671ff8d?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxleHBsb3JlLWZlZWR8MXx8fGVufDB8fHx8&w=1000&q=80");

class dashboard extends StatefulWidget {

  dashboard({Key? key}) : super(key: key);

  @override
  State<dashboard> createState() => _dashboardState();
}

class _dashboardState extends State<dashboard> {
  int index = 0;
  final PageController _page = PageController();

  void refresh(){
    setState(() {
      
    });
  }

  @override
  void initState() {
    super.initState();
    global.pageControl = _page;
    global.bgRefresh = refresh;
    initUpdater(false);
  }

  @override
  void dispose() {
    _page.dispose();
    super.dispose();
  }

  @override
  Widget build(context) {
    List<Icon> items = [
      Icon(Icons.dashboard, size: 30, color: Theme.of(context).shadowColor),
      Icon(FontAwesomeIcons.facebookMessenger, size: 30,color: Theme.of(context).shadowColor),
      Icon(Icons.search, size: 30,color: Theme.of(context).shadowColor),
      Icon(Icons.settings, size: 30, color: Theme.of(context).shadowColor),
      Icon(Icons.person,size: 30, color: Theme.of(context).shadowColor),
    ];
    debugPrint("Building route for nagivation [routeToDash]");

    bool verified = (global.accountType == 2 && global.accObj!.classBelong != "pending") || (global.accountType == 1 && global.passcode != null && global.passcode != "") || global.accountType == 3;

    if(!verified) prompt(context);
    debugPrint("Passcode : ${global.passcode.toString()}");

    return WillPopScope(
      onWillPop: () async => false,
      child: (verified == false) ? Scaffold( 
      backgroundColor: Theme.of(context).backgroundColor,
      body: Center(
        child: SizedBox (
          width: MediaQuery.of(context).size.width/2.5,
          child: DropShadow(
            offset: const Offset(0, 0),
            blurRadius: 10,
            spread: .5,
            child: Image.asset("asset/images/logo-without-bg.png",)
          )
        )
      )
    ) : Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: 
      Center( child : Stack(
        children: [
          
          bg(),
      
          SizedBox.expand(
            child: PageView(
              controller: _page,

              physics: const NeverScrollableScrollPhysics(),
              //onPageChanged: (index) {
                //setState(() => _selectedIndex = index);
              //},
              children: <Widget>[
                dash(),
                messages(),
                Container(color: Colors.blueGrey,),
                settings(),
                Container(color: Colors.green,),
                Container(color: Colors.blue,),
              ],
            ),
          )
        ],
      ))
,          
      backgroundColor: Colors.lightBlue,
      bottomNavigationBar: CurvedNavigationBar(
        height: 55,
        backgroundColor: Colors.transparent,
        color: Theme.of(context).buttonColor,
        buttonBackgroundColor: Theme.of(context).hintColor,
        index: index,
        onTap: (value) {
          index = value;
          _page.animateToPage(index, duration: const Duration(milliseconds: 600), curve: Curves.easeInOutExpo);
          //items[value].color = Theme.of(context).backgroundColor;
        },
        items: items,
      ),
    ),
    );
  }
}

void toDashbaord() async {

  for(; global.account == null ;){
    await Future.delayed(const Duration(seconds: 1));
    debugPrint("Account not found, waiting...");
  }
  global.dashboardReached = true;
  global.prefs!.setBool("dashboardReached", true);
  Navigator.pushNamed(global.rootCTX!, "/dashboard");
}


List<List> classes = [
  ["Computer Science Engineering", false, "cse", 1,2,3,4],
    ["CSE - I [A]", true, "cse_ia", "cse", "i" ,"a",1],
    ["CSE - I [B]", true, "cse_ib", "cse", "i" ,"b",2],
    ["CSE - II [A]", true, "cse_iia", "cse", "ii" ,"a",3],
    ["CSE - II [B]", true, "cse_iib", "cse", "ii" ,"b",4],
    ["CSE - III [A]", true, "cse_iiia", "cse", "iii" ,"a",5],
    ["CSE - III [B]", true, "cse_iiib", "cse", "iii" ,"b",6],
    ["CSE - IV [A]", true, "cse_iva", "cse", "iv" ,"a",7],
    ["CSE - IV [B]", true, "cse_ivb", "cse", "iv" ,"b",8],
];

 InputDecoration dec(IconData? icon, String hint) {
    return InputDecoration(    
      
      contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
      prefixIcon: Icon(icon,color: Colors.deepPurpleAccent),
      prefixIconColor: Colors.red,
      prefixStyle: const TextStyle(color: Colors.deepPurpleAccent),                    
      hintText: hint,
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

bool onPrompt = false;
void prompt(BuildContext context) async {
  if(onPrompt == true || global.temp == true) return;
  onPrompt = true;
  global.temp = onPrompt;
  final RoundedLoadingButtonController btnController = RoundedLoadingButtonController();
  String str = "Submit";

  await Future.delayed(const Duration(milliseconds: 1500));

  if(global.accountType == 1) {
    // staff
        String? selected;
        TextEditingController passwordController = TextEditingController();
    global.alert.customAlertNoAction(context,
      SizedBox(
        height: 150,
        child: Column(
          children: [
            TextFormField(
              obscureText: true,
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
              onSaved: (value) {
                if(value != null) {
                  passwordController.text = value;
                  selected = value;
                }
              },
              textInputAction: TextInputAction.done,
            ),

            const SizedBox(height: 30,),
            

            RoundedLoadingButton(
              controller: btnController,
              resetAfterDuration: true,
              resetDuration: const Duration(seconds: 2),
              onPressed: () async {
                selected = passwordController.text;
                debugPrint("Selected $selected");
                
                if(selected == null) { str="Choose any one class!";btnController.error(); return;}
                debugPrint("Updating the database");
                db_fetch_return get = await global.Database!.create(global.Database!.addCollection("admin", "/admin"), global.loggedUID!, {"pass" : selected});

                if(get.status == db_fetch_status.error) { str="Error : ${get.data.toString()}";btnController.error(); return;}

                global.passcode = selected;
                global.prefs!.setString("passcode", selected!);
                btnController.success();
                onPrompt = false;
                global.temp = onPrompt;
                Navigator.pop(context);
                global.bgRefresh!();
              },
              child: Text(str, style: const TextStyle(color: Colors.white)),
            )

          ],
        ),
      )
     , global.textWidget("Enter the passcode"));

  } else {
    // student
    dynamic selected;

    global.alert.customAlertNoAction(context,
      SizedBox(
        height: 150,
        child: Column(
          children: [
            DropdownButtonFormField(
              dropdownColor: Theme.of(context).buttonColor.withOpacity(0.8),
              
              value: selected,
              onChanged:(value) {
                debugPrint(value.toString());
                selected = classes[value as int];
              },

              items: [
                for(List x in classes) DropdownMenuItem(
                  value: x[6],
                  enabled: x[1],
                  child: global.textWidgetWithBool(x[0],x[1])
                )
              ],
            ),

            const SizedBox(height: 30,),
            

            RoundedLoadingButton(
              controller: btnController,
              resetAfterDuration: true,
              resetDuration: const Duration(seconds: 2),
              onPressed: () async {
                debugPrint("Selected ${selected.toString()}");
                
                if(selected == null) { str="Choose any one class!";btnController.error(); return;}
                debugPrint("Updating the database");
                db_fetch_return get = await global.Database!.update(global.collectionMap["acc"]!, global.loggedUID!, {"class" : selected![2], "department" : selected![3], "year" : selected![4], "section" : selected![5]});

                if(get.status == db_fetch_status.error) { str="Error : ${get.data.toString()}";btnController.error(); return;}

                global.accObj!.classBelong = selected[2];
                global.accObj!.department = selected[3];
                global.accObj!.year = selected[4];
                global.accObj!.section = selected[5];
                await global.prefs!.remove("classPending");
                btnController.success();
                onPrompt = false;
                global.temp = onPrompt;
                Navigator.pop(context);
                global.bgRefresh!();
              },
              child: Text(str, style: const TextStyle(color: Colors.white)),
            )

          ],
        ),
      )
     , global.textWidget("Choose your class [REQUIRED]"));
  }

  return;
}

Widget bg() {
  if(global.bgImage == true){ 
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          isAntiAlias: true,
          image: NetworkImage("https://mobimg.b-cdn.net/v3/fetch/a0/a029a96e19a248e75762a4be139d3d36.jpeg")
        ),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX : 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(color: Colors.black.withOpacity(0.05)),
        ),
      ),
    );} else {
      return const SizedBox(
        //height: double.infinity,
        //width: double.infinity,
        //color: Color()
      );
    }
}