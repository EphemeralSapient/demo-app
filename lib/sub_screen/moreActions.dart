import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ngp/global.dart' as global;
import 'package:flutter/widgets.dart';
import 'package:ngp/sub_screen/infoEdit.dart';
import 'package:ngp/ui/leaveForm.dart';

class moreActionsShort extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    
    List<Widget> childrens = [];

    // Admin tools 
    if(global.accountType == 1) {
    
    childrens.add(
      ElevatedButton.icon(
        icon: Icon(Icons.text_snippet, color: Theme.of(context).textSelectionTheme.cursorColor,),
        label: global.textWidget("Leave Application"),

        onPressed: () {
          debugPrint("Go to leave form page");
          leaveFormPrompt(context);
        },
        style: ElevatedButton.styleFrom(
              shadowColor: Colors.transparent,
              primary: Colors.transparent,
              surfaceTintColor: Colors.transparent,
              onPrimary: Theme.of(context).buttonColor
            )
      )
    );

    childrens.add(
      ElevatedButton.icon(
        icon: Icon(Icons.edit, color: Theme.of(context).textSelectionTheme.cursorColor,),
        label: global.textWidget("Edit your faculty information"),

        onPressed: () {
          promptStaffInfoEdit();
        },
        style: ElevatedButton.styleFrom(
              shadowColor: Colors.transparent,
              primary: Colors.transparent,
              surfaceTintColor: Colors.transparent,
              onPrimary: Theme.of(context).buttonColor
            )
      )
    );

    // Student tools

    } else if (global.accountType == 2) {


    childrens.add(
      ElevatedButton.icon(
        icon: Icon(Icons.text_snippet, color: Theme.of(context).textSelectionTheme.cursorColor,),
        label: global.textWidget("Leave Application"),

        onPressed: () {
          debugPrint("Go to leave form page");
          leaveFormPrompt(context);
        },
        style: ElevatedButton.styleFrom(
              shadowColor: Colors.transparent,
              primary: Colors.transparent,
              surfaceTintColor: Colors.transparent,
              onPrimary: Theme.of(context).buttonColor
            )
      )
    );

    childrens.add(
      ElevatedButton.icon(
        icon: Icon(Icons.edit, color: Theme.of(context).textSelectionTheme.cursorColor,),
        label: global.textWidget("Edit your student information"),

        onPressed: () {
          promptStudentsInfoEdit();
        },
        style: ElevatedButton.styleFrom(
              shadowColor: Colors.transparent,
              primary: Colors.transparent,
              surfaceTintColor: Colors.transparent,
              onPrimary: Theme.of(context).buttonColor
            )
      )
    );

    } else {

    }

    // Common for all tools

    // --

    // Tool appending ended

    final scrollViewWidget = SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                //padding: EdgeInsets.all(10),
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Wrap(
                    runSpacing: 1,
                    spacing: 5,
                    children: childrens,
                  ),
                ),
              );

    return SizedBox(
      height: 180,
      child: Column(
        children: [
          ElevatedButton(
            onPressed : () {
              debugPrint("Routing to more actions page");
            },
            style: ElevatedButton.styleFrom(
              shadowColor: Colors.transparent,
              primary: Colors.transparent,
              surfaceTintColor: Colors.transparent,
              onPrimary: Theme.of(context).buttonColor
            ),
            child: Row(
              children: [
                Text(
                  "ACTIONS ",
                  style: TextStyle(color: Theme.of(context).textSelectionTheme.selectionColor, fontWeight: FontWeight.w500, letterSpacing: 2, fontFamily: "Montserrat", fontSize: 12),
                ),

                Icon(Icons.arrow_forward_ios_outlined,color: Theme.of(context).textSelectionTheme.cursorColor,size: 12)
              ]
            )
          ),

          SizedBox(height: 5,),

          Container(

            decoration: BoxDecoration(
              color: Theme.of(context).buttonColor,
              borderRadius: BorderRadius.circular(10),
            ),

            child: !kIsWeb ? ShaderMask(
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
                ).createShader(Offset.zero & rect.size);
              },
              blendMode: BlendMode.dstOut,
              child: scrollViewWidget
            ) : scrollViewWidget,
          )          

        ],
      ),
    );
  }
}