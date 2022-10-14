// ignore_for_file: file_names, camel_case_types, use_build_context_synchronously

import 'dart:ui';

import 'package:another_transformer_page_view/another_transformer_page_view.dart';
import 'package:ngp/buildin_transformers.dart';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:drop_shadow/drop_shadow.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ngp/database.dart';
import 'package:ngp/screens/classroom.dart';
import 'package:ngp/screens/dashboard.dart';
import 'package:ngp/screens/profile.dart';
import 'package:ngp/screens/search.dart';
import 'package:ngp/screens/settings.dart';
import 'package:ngp/sub_screen/infoEdit.dart';
import 'package:ngp/acc_update.dart';
import 'global.dart' as global;

final image = const NetworkImage("https://images.unsplash.com/photo-1540122995631-7c74c671ff8d?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxleHBsb3JlLWZlZWR8MXx8fGVufDB8fHx8&w=1000&q=80");

class ui extends StatefulWidget{
  @override
  State<ui> createState() => _uiState();
}

class _uiState extends State<ui> {
  final IndexController _page = IndexController();
  int index = 0;


  void refresh(){
    setState(() {
    });
  }

  @override
  void initState() {
    super.initState();
    global.bgRefresh = refresh;
    global.uiPageControl = _page;
  }

  @override
  void dispose() {
    super.dispose();
    _page.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var page_1 = ClipRect(child: dashboard());
    var page_2 = ClipRect(child: global.uiSecondaryWidget());
    return WillPopScope(
      onWillPop: () async {
        if(_page.index == 1) {
          _page.move(0);// (0, duration: Duration(seconds: 1), curve: Curves.easeInOutExpo);
        }
        return false;
      },
      child: Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.transparent,
    
        body: Stack(
          children: [bg(), TransformerPageView(
            scrollDirection: Axis.vertical,
            physics: global.uiSecondaryScrollPhysics,
            controller: _page,
            itemCount: 2,
            transformer: ZoomOutWithoutOpacPageTransformer(),
            itemBuilder: (context, index) {
              return index==0 ? page_1 : page_2 ;
            } //[
              //dashboard(),
              //global.uiSecondaryWidget(),
            //],
          ),]
        )
      ),
    );
  }
}

class dashboard extends StatefulWidget {

  dashboard({Key? key}) : super(key: key);

  @override
  State<dashboard> createState() => _dashboardState();
}

int index = 0;
class _dashboardState extends State<dashboard> {
  final PageController _page = PageController(initialPage: index);

  void refresh(){
    setState(() {
      
    });
  }

  @override
  void initState() {
    super.initState();
    global.pageControl = _page;
    //global.bgRefresh = refresh;
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
      Icon(Icons.dashboard, size: 23, color: Theme.of(context).shadowColor),
      if(global.accountType != 3)
       Icon(Icons.class_rounded, size: 23,color: Theme.of(context).shadowColor),
      Icon(Icons.search, size: 23,color: Theme.of(context).shadowColor),
      Icon(Icons.settings, size: 23, color: Theme.of(context).shadowColor),
      if(global.accountType != 3)
        Icon(Icons.person,size: 23, color: Theme.of(context).shadowColor),
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
      Center( child : PageView(
        controller: _page,

        physics: const NeverScrollableScrollPhysics(),
        //onPageChanged: (index) {
          //setState(() => _selectedIndex = index);
        //},
        children: <Widget>[
          dash(),
          if(global.accountType != 3)
            classroom(),
          search(),
          const settings(),
          if(global.accountType != 3)
            profile(),
          Container(color: Colors.blue,),
        ],
      ))
,          
      backgroundColor: Colors.transparent,
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
  context = global.rootCTX!;
  global.temp = onPrompt;
  String str = "Submit";

  await Future.delayed(const Duration(milliseconds: 1500));

  if(global.accountType == 1) {
    // staff
    global.temp = () {
      // What to addd here hmm
    };
    Navigator.push(
      context,
      MaterialPageRoute(builder: (ctx) => staffs_info()),
    );
  } else {
    // student
    global.temp = () {
      global.restartApp();
    };
    Navigator.push(
      context,
      MaterialPageRoute(builder: (ctx) => students_info()),
    );
  }
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
      return Container(
        height: double.infinity,
        width: double.infinity,
        color: global.customColorEnable ? Color(global.customColor) : global.uiBackgroundColor
      );
    }
}