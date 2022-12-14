import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'dart:async' show Future;
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ngp/login/validate.dart';
import 'package:ngp/restartWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:drop_shadow/drop_shadow.dart' show DropShadow;
import 'package:firebase_core/firebase_core.dart' show Firebase;
import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth, FirebaseAuthException, GoogleAuthProvider, Persistence, User;
import 'package:flutter_settings_screens/flutter_settings_screens.dart' show Settings;
import 'package:ngp/routeToDash.dart';
import 'firebase_options.dart' show DefaultFirebaseOptions;
import 'global.dart' as globals;
import 'login/options.dart' show Choice;
import 'routeToDash.dart';
import 'database.dart';

Future main() async {

  await Settings.init();

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  debugPrint("running the app now");
  ErrorWidget.builder = (details) {
    var style = const TextStyle(
      color: Colors.white,
      fontSize: 12,
      
    );
    return Scaffold(
      backgroundColor: Colors.red.withOpacity(0.6),
      body: BackdropFilter(
        filter: ImageFilter.blur(sigmaX : 20, sigmaY: 20),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: AnimationConfiguration.toStaggeredList(
            duration: const Duration(milliseconds: 300),
            childAnimationBuilder: (widget) => SlideAnimation(
              verticalOffset: 50.0,
              child: FadeInAnimation(
                child: widget,
              ),
            ),
            children:[
              Icon(Icons.error_outline, color: Colors.white,size: 50),
    
              SizedBox(height: 30,),
    
              Text("Oops! An error occurred, please restart the app", style: style,),

              SizedBox(height: 30),

              Text(details.toStringShort(), style: style),

              SizedBox(height: 15),

              SizedBox(
                height: 50,
                child: SingleChildScrollView(
                  child: Text(details.stack.toString(), style: style)
                )
              )
            ],
            )
          ),
        ),
      )
      ,
    );
  };
  runApp(
    RestartWidget(
      child: const MyApp(),
    )
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  void refreshRoot(){
    setState(() {
      debugPrint("Called!");
    });
  }

  @override
  void initState(){
    globals.rootRefresh = refreshRoot;
    globals.MyAppCTX = context;
    globals.updateSettingsFromStorage();
    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    debugPrint(globals.darkMode.toString());
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        backgroundColor: Colors.white,
        splashColor: Colors.grey.shade100,
        shadowColor: const Color.fromARGB(132, 0, 0, 0),
        hintColor: Colors.grey.shade200,
        canvasColor: Colors.white,
        buttonColor: Color.fromARGB(127, 255, 255, 255),
        useMaterial3: true, 
        textSelectionTheme: const TextSelectionThemeData(
          selectionColor: Color.fromARGB(160, 0, 0, 0),
          selectionHandleColor: Color.fromARGB(120, 0, 0, 0),
          cursorColor: Color.fromARGB(255, 0, 0, 0)
        ),
        secondaryHeaderColor: Colors.grey,
        textTheme: GoogleFonts.latoTextTheme(
          Theme.of(context).textTheme,
        ),

      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.lightBlue,
        backgroundColor: Colors.grey.shade900,
        splashColor: Colors.grey.shade800,
        shadowColor: Colors.grey.shade300,
        hintColor: Colors.grey.shade800,
        canvasColor: Colors.grey.shade300,
        
        buttonColor: Color.fromARGB(158, 0, 0, 0),
        textSelectionTheme: const TextSelectionThemeData(
          selectionColor: Color.fromARGB(192, 255, 255, 255),
          selectionHandleColor: Color.fromARGB(120, 255, 255, 255),
          cursorColor: Color.fromARGB(255, 255, 255, 255)
        ),
        secondaryHeaderColor: Colors.white38,
        textTheme: GoogleFonts.latoTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      themeMode: globals.darkMode,
      initialRoute: '/',
      routes: {
        '/': (context) => const home(),
//      '/choice': (context) => const Choice()
      },
      onGenerateRoute: (settings) {
        if (settings.name == "/choice") {
          debugPrint("Choice route was called | ${StackTrace.current}");
          return PageRouteBuilder(
            settings: settings, // Pass this to make popUntil(), pushNamedAndRemoveUntil(), works
            pageBuilder: (c, a1, a2) => const Choice(),
            transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
            transitionDuration: const Duration(seconds: 1),
          );
        } else if (settings.name == "/dashboard") {
          return PageRouteBuilder(
            settings:  settings,
            pageBuilder: (c, a1, a2) => ui(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) => FadeTransition(opacity: animation, child:
              ScaleTransition(
                scale: animation.drive(
                  Tween(begin: 1.5, end: 1.0).chain(
                    CurveTween(curve: Curves.easeOutCubic)
                  )
                ),
                child: child
              )
            ),  
            transitionDuration: const Duration(seconds: 1)
          );
        }
        return null;
        // Unknown route
       //return MaterialPageRoute(builder: (_) => UnknownPage());
      },
    );
  }
}

// ignore: camel_case_types
class home extends StatefulWidget {
  const home({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return HomeImpl();
  }
}
class HomeImpl extends State<home> {

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 1),() async {
      //WidgetsFlutterBinding.ensureInitialized();

      debugPrint("Starting...");

      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      // In case of user loggined as admin but didn't enter passcode
      if((globals.accountType == 1 && globals.passcode == null) || globals.prefs!.getBool("classPending") == true) {
        debugPrint("Passcode / class data is not completed, signing out.");
        await FirebaseAuth.instance.signOut();
      }


      final FirebaseAuth auth = FirebaseAuth.instance;
      User? user = auth.currentUser;
      
      // Website version requires persistance 
      if(kIsWeb && user == null) {
        user = await FirebaseAuth.instance.authStateChanges().first;
      }
            
      debugPrint("Firebase loaded");
      globals.updateSettingsFromStorage();
      debugPrint(user.toString());

      try {
        if(user != null) await user.reload();
      } on FirebaseAuthException catch(e) {
        //user = null;
        debugPrint("Failed to login; $e");
      }

      //Retry and await till user data is not empty
      if(user == null && globals.haveSignedInBefore) {
        for(int i = 0; i<=5 && user == null; i++) {
          debugPrint("Awaited for $i seconds...");
          await Future.delayed(const Duration(seconds: 1));
        }

        if(user == null) {
          globals.alert.quickAlert(context, globals.textWidget("Previous account login were detected but unable to find the user data, please re-login"));
        }
      }

      if (user != null) {
  
        bool network = await globals.checkNetwork();

        //Checking if user data exists in cloud or banned[or removed]
        if(user.photoURL!=null && network == true){
          globals.Database = db();
          db_fetch_return checkAccountStatus = await globals.Database!.get(globals.Database!.addCollection("acc", "/acc"), user.uid);
          if(checkAccountStatus.status == db_fetch_status.nodata || checkAccountStatus.status==db_fetch_status.error){
            try{auth.signOut();} on Exception catch(e) {debugPrint("$e error occurred while signing out on non-existent account.");}
            user = null;
            globals.accountType = 0;
            globals.initGlobalVar();
            debugPrint("Account is empty??");
            Navigator.pushNamed(context, "/choice");
            return null;
            // Add if something needs to be removed on removed account

            //
          }
        }

        if(user != null && user.photoURL == null && network == true){
          GoogleSignIn signIn = GoogleSignIn();
          debugPrint("Slient sign-in on process");
          final acc = await signIn.signInSilently();

          if(acc != null){
            final auth = await acc.authentication;

            final cred = GoogleAuthProvider.credential(
              accessToken: auth.accessToken,
              idToken: auth.idToken
            );

            try {
              final Cred = await FirebaseAuth.instance.signInWithCredential(cred);
              user = Cred.user;
            } on FirebaseAuthException catch(e) {
              debugPrint(e.toString());
              return e.toString();
            }
          }
        }

        globals.isLoggedIn = true;
        globals.loggedUID = user!.uid;
        globals.account = user;
        if(user.isAnonymous != true){
          //if(globals.dashboardReached == false) debugPrint(await validate(2) ?? "Validation completed" );
          //globals.accountType = 2;
        } else globals.accountType = 3;
        Future.delayed(const Duration(seconds: 2),() => toDashbaord());
      } else if (globals.choiceRoute != true) {
        // ignore: use_build_context_synchronously
        debugPrint("choiceRoute is not true");
        Navigator.pushNamed(context, "/choice");
      }

      globals.Database = db();
      globals.initGlobalVar();
    });
  }

  @override
  Widget build(BuildContext context) {
    globals.rootCTX = context;
    return Scaffold( 
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
    );
  }
  
}