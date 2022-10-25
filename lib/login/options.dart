import 'package:flutter/material.dart';
import 'package:ngp/global.dart' as global;
import 'loginRoute.dart' show route;


class Choice extends StatefulWidget {
  const Choice({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ChoiceImpl();
  }
}

class ChoiceImpl extends State<Choice> with TickerProviderStateMixin {
  List containerOpacity = [0.0,0.0,0.0];

  late final AnimationController _c1 = AnimationController(
    duration: const Duration(milliseconds: 500),
    vsync: this,
  );
  late final Animation<Offset> _offsetAnimation_1 = Tween<Offset>(
    begin: const Offset(0,0.6),
    end: Offset.zero,
  ).animate(CurvedAnimation(
    parent: _c1,
    curve: Curves.linear,
  ));

  late final AnimationController _c2 = AnimationController(
    duration: const Duration(milliseconds: 500),
    vsync: this,
  );
  late final Animation<Offset> _offsetAnimation_2 = Tween<Offset>(
    begin: const Offset(0,0.6),
    end: Offset.zero,
  ).animate(CurvedAnimation(
    parent: _c2,
    curve: Curves.linear,
  ));

    late final AnimationController _c3 = AnimationController(
    duration: const Duration(milliseconds: 500),
    vsync: this,
  );
  late final Animation<Offset> _offsetAnimation_3 = Tween<Offset>(
    begin: const Offset(0,0.6),
    end: Offset.zero,
  ).animate(CurvedAnimation(
    parent: _c3,
    curve: Curves.linear,
  ));

  late List containerAnimation = [_c1,_c2,_c3];

  @override
  void dispose() {
    _c1.dispose();
    _c2.dispose();
    _c3.dispose();
    super.dispose();
  }

  void close() {
    if(global.choiceRoute == false) return;
    global.choiceRoute = false;
    Future.delayed(const Duration(),() {
      for (int i = 2; i > -1; i--) {
        Future.delayed(Duration(milliseconds: 150 * (i-2) * -1), () => { 
          containerOpacity[i] = 0.0,
          setState(() {}),
          containerAnimation[i].reverse(),
          setState(() {})
        });
    }
    Future.delayed(const Duration(milliseconds: 400), () => {Navigator.pop(global.choiceRouteCTX!)});
    });
  }

  @override
  void initState() {
    super.initState();

    global.loginRouteCloseFn = close;
    global.choiceRoute = true;
    global.choiceRouteCTX = context;

    Future.delayed(const Duration(),() {
      for (int i = 0; i < 3; i++) {
        Future.delayed(Duration(milliseconds: 250 * i), () => { 
          containerOpacity[i] = 1.0,
          //setState(() {}),
          containerAnimation[i].forward(),
          setState(() {})
        });
    }
    });
  }

  Container slot(int i,List<Color> color, String name, String info, IconData icon) {
    return Container(
      height: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: LinearGradient(
          begin: const Alignment(-1,-1),
          end: const Alignment(1, -2),
          colors: color,
        )
      ),
      child: ElevatedButton(
        onPressed: () { route(i); },
        
        style: ElevatedButton.styleFrom(
          primary: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              //mainAxisSize: MainAxisSize.min,
              children: [
                
                const SizedBox(height:25),
                
                Text(
                  name,
                  style:  TextStyle(
                    color: Theme.of(context).canvasColor,
                    //fontFamily: "Montserrat",
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1,
                    fontSize: 25,
                  ),
                ),

                const Divider(

                  color: Colors.black,
              
                ),

                Text(
                  info,
                  style:  TextStyle(
                    color: Theme.of(context).canvasColor,
                    fontFamily: "Montserrat",
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                  ),
                ),

              ],
            ),

            Icon(
              icon,                     
              size: 100,
              color : Theme.of(context).splashColor
            )
          ],
        )
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    global.choiceRouteCTX = context;

    return WillPopScope(onWillPop: () async => false,child: Scaffold(
      backgroundColor: Theme.of(context).splashColor,
      body: Padding(
        padding : const EdgeInsets.only(left: 30, right: 30, top: 60, bottom: 30),
        child: Wrap(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width-50,
              child: Text(
                "Choose Your Role",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontFamily: "Metropolis",
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  color: Theme.of(context).textSelectionTheme.selectionColor,
                )
              ),
            ),

            const SizedBox(height: 35),

            Text(
              "You can choose any one to proceed",
              textAlign: TextAlign.left,
              style: TextStyle(
                fontFamily: "Metropolis",
                fontWeight: FontWeight.w500,
                fontSize: 15,
                color: Theme.of(context).textSelectionTheme.selectionHandleColor,
              )
            ),


            const SizedBox(height: 50),

            InkWell(
              child: AnimatedOpacity( opacity: containerOpacity[0],curve: Curves.linear ,duration: const Duration(milliseconds: 600) ,child: SlideTransition(position: _offsetAnimation_1, child:
              slot(
                1,
                [
                  Colors.deepPurple,
                  const Color.fromRGBO(230, 144, 228, 1),
                ],
                " Administrator",
                "   STAFF / FACULTY",
                Icons.admin_panel_settings
              )
                       )),
            ),
            

            const SizedBox(height: 165),

            InkWell(
              child: AnimatedOpacity( opacity: containerOpacity[1],curve: Curves.linear ,duration: const Duration(milliseconds: 600) ,child: SlideTransition(position: _offsetAnimation_2, child:
              slot(
                2,
                [
                  const Color.fromRGBO(255, 94, 203, 1),
                  const Color.fromRGBO(250, 216, 130, 1),
                ],
                " Student",
                "UG / PG STUDENT",
                Icons.school_rounded
              )
                       )),
            ),

            const SizedBox(height: 165),

            InkWell(
              child: AnimatedOpacity( opacity: containerOpacity[2], curve: Curves.linear,duration: const Duration(milliseconds: 600) ,child: SlideTransition(position: _offsetAnimation_3, child:
              slot(
                3,
                [
                  const Color.fromRGBO(16,175,233,1),
                  const Color.fromRGBO(228,240,140,1),
                ],
                "Guest      ",
                "NO LOGIN REQUIREMENT",
                Icons.account_circle_rounded
              )
                       )),
            ),

            const SizedBox(height: 30),

          ],
        )
      )
    ));
  }
}

