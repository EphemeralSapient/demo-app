
import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart' show SettingsGroup;
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:ngp/sub_screen/infoEdit.dart';
import 'package:ngp/sub_screen/update_ui.dart';
import 'package:ngp/ui/toggleButton.dart';
import 'package:ngp/global.dart' as global;

class settings extends StatefulWidget {
  static const darkMode = 'dark';

  const settings({Key? key}) : super(key: key);

  @override
  State<settings> createState() => _settingsState();
}

class _settingsState extends State<settings> {
  @override
  Widget build(context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton: !kIsWeb ? FloatingActionButton.extended(
        heroTag: 'uniqueTag',
        onPressed: () {
          // Update the app
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (c, a1, a2) => update_ui(),
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

        elevation: 10,
        icon: Icon(Icons.new_releases, size: 20,),
        label: Text("Update the app", style: TextStyle(fontSize: 11),),
      ) : null,
      backgroundColor: Theme.of(context).buttonColor,
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: AnimationConfiguration.toStaggeredList(
          duration: const Duration(milliseconds: 375),
          childAnimationBuilder: (widget) => SlideAnimation(
            verticalOffset: 50.0,
            child: FadeInAnimation(
              child: widget,
            ),
          ),
          children:[
            SizedBox(height: 15,),
            SettingsGroup(
              title: "GENERAL",
              children: [
                toggleButton(
                  (val) {
                    
                    global.darkMode = (val == true ? ThemeMode.dark : ThemeMode.light);
                    global.rootRefresh!();
                    global.prefs!.setBool("dark mode", val);
    
                    return val;},
                  "Dark Mode",
                  Icons.dark_mode,
                  Theme.of(context).backgroundColor,
                  global.darkMode == ThemeMode.dark ? true : false
                ),
      
                toggleButton(
                  (val) {
                    
                    global.bgImage = val;
                    global.bgRefresh!();
                    global.prefs!.setBool("bg image", val);
      
                    return val;},
                  "Background as Image",
                  Icons.image_outlined,
                  Theme.of(context).backgroundColor,
                  global.bgImage
                ),

                toggleButton(
                  (val) {
                    
                    global.customColorEnable = val;
                    global.bgRefresh!();
                    global.prefs!.setBool("customColorEnable", val);
      
                    return val;},
                  "Use Custom Background Color",
                  Icons.colorize,
                  Theme.of(context).backgroundColor,
                  global.customColorEnable
                ),

                InkWell(
                  onTap: () {
                    Color changeColor = Color(global.customColor);
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (c, a1, a2) => Scaffold(
                          backgroundColor: Colors.transparent,
                          floatingActionButton: FloatingActionButton(
                            onPressed: () {
                              global.customColor = changeColor.value;
                              global.prefs!.setInt("customColor", changeColor.value);
                              global.bgRefresh!();
                              Navigator.pop(c);
                            },
                            child: Icon(Icons.done),
                          ),
                          body: WillPopScope(
                            onWillPop: () async {
                        
                              return true;
                            },
                        
                            child: Container(
                              alignment: Alignment.center,
                              color: Theme.of(context).buttonColor,
                              child: MaterialPicker(
                                pickerColor: Color(global.customColor),
                                onColorChanged: (value) => changeColor = value,
                                enableLabel: true,
                                portraitOnly: true,
                                
                              ),
                            )
                          ),
                        ),
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
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      //mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        
                        Text(
                          "Custom Background Color",
                          style: TextStyle(
                            color: Theme.of(context).textSelectionTheme.selectionHandleColor,
                            fontFamily: "Montserrat",
                            fontSize: 12
                          ),
                        ),

                        CircleAvatar(
                          backgroundColor: Color(global.customColor),
                        )
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 20)

              ],
            ),

            // ElevatedButton(
            //   onPressed: () {
            //     global.accountType == 2 ? promptStudentsInfoEdit() : promptStaffInfoEdit();
            //   },
            //   style:
            //       ElevatedButton.styleFrom(primary: Theme.of(context).buttonColor, shadowColor: Colors.transparent),
            //   child: Text("Change your ${global.accountType == 2 ? "Student" : "Faculty"} information data",
            //       style: TextStyle(
            //           fontSize: 12,
            //           color: Theme.of(context).textSelectionTheme.selectionColor
            //     )
            //   ),
            // ),

            ElevatedButton(
              onPressed: () {
                      
                FirebaseAuth.instance.signOut();
                global.accountType = 0;
                global.updateSettingsFromStorage();
                global.restartApp();
              },
              style:
                  ElevatedButton.styleFrom(primary: Theme.of(context).buttonColor, shadowColor: Colors.transparent),
              child: Text("Sign out",
                  style: TextStyle(
                      fontSize: 20,
                      color: Theme.of(context).textSelectionTheme.selectionColor
                )
              ),
            ),
          ],
        ),
      ),
    );
  }
}
