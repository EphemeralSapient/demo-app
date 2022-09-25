
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:ngp/global.dart' as global;
import 'package:flutter/material.dart';


// !!!

// USE global.alert TO ACCESS THIS CLASS

class Alert {

  Future<dynamic> quickAlert(BuildContext ctx, Widget body,{Widget? title,bool dismissible = true, bool popable = false}) {
    return showGeneralDialog(
      barrierDismissible: dismissible,
      barrierLabel: '',
      
      barrierColor: Colors.black38,
      transitionDuration: const Duration(milliseconds: 500),
      pageBuilder: (ctx, anim1, anim2) => StatefulBuilder( builder: (context, StateSetter setState) {
          return WillPopScope(
            onWillPop: () async => dismissible | popable,
            child: AlertDialog(
              title: title,
              content: body,
              backgroundColor: Theme.of(context).buttonColor.withOpacity(0.9),
              actions: [
                FloatingActionButton(
                  child: global.textWidget("Okay"),
                  mini: true,
                  onPressed: () => Navigator.of(context).pop()
                )
              ]
            )
          );
      }),
    transitionBuilder: (ctx, anim1, anim2, child) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 3 * anim1.value, sigmaY: 3 * anim1.value),
            child: FadeTransition(
                opacity: anim1,
                child: child,
            ),
        ),
    context: ctx,
    );
  }

  Future<dynamic> customAlertNoAction(BuildContext context, Widget Content, Widget? Title) {
    return showGeneralDialog(
      barrierDismissible: true,
      barrierLabel: '',
      barrierColor: Colors.black38,
      transitionDuration: const Duration(milliseconds: 500),
      pageBuilder: (ctx, anim1, anim2) => StatefulBuilder( builder: (context, StateSetter setState) {
          return WillPopScope(
            onWillPop: () async => false,
            child: AlertDialog(
              title: Title,
              content: Content,
              backgroundColor: Theme.of(context).buttonColor.withOpacity(0.3),
              elevation: 10,
              
            ),
          );
      }),
    transitionBuilder: (ctx, anim1, anim2, child) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 3 * anim1.value, sigmaY: 3 * anim1.value),
            child: FadeTransition(
                opacity: anim1,
                child: child,
            ),
        ),
    context: context,
  );
  }

  Future<dynamic> customAlertNoActionWithoutPopScope(BuildContext context, Widget Content, Widget? Title, Function callbackFn, Function postCallbackFn) {
    
    WidgetsBinding.instance.addPostFrameCallback((_) => postCallbackFn());

    
    return showGeneralDialog(
      barrierDismissible: true,
      barrierLabel: '',
      barrierColor: Colors.black38,
      transitionDuration: const Duration(milliseconds: 500),
      pageBuilder: (ctx, anim1, anim2) => StatefulBuilder( builder: (context, StateSetter setState) {
          return WillPopScope(
            onWillPop: () async {
              callbackFn();
              return true;
            },
            child: AlertDialog(
              title: Title,
              content: Content,
              backgroundColor: Theme.of(context).buttonColor.withOpacity(0.3),
              elevation: 10,
              
            ),
          );
      }),
    transitionBuilder: (ctx, anim1, anim2, child) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 3 * anim1.value, sigmaY: 3 * anim1.value),
            child: FadeTransition(
                opacity: anim1,
                child: child,
            ),
        ),
    context: context,
  );
  }
}