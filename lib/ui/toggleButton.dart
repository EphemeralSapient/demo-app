import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_switch/flutter_switch.dart';

class toggleButton extends StatefulWidget {

  late Function callback;
  late IconData icon;
  late Color color;
  late String text;
  late bool enable;
  

  toggleButton(this.callback,this.text,this.icon,this.color, this.enable , {Key? key}) : super(key: key);

  @override
  State<toggleButton> createState() => _toggleButtonState(enable);
}

class _toggleButtonState extends State<toggleButton> {

  late bool status;

  _toggleButtonState(this.status) : super();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(context) {
    return SizedBox(
      width: double.infinity,
      height: 75,
      child: Padding(
        padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
        child: Row(

          mainAxisAlignment: MainAxisAlignment.spaceAround,
      
          children: [
            
            Icon(widget.icon, color: Theme.of(context).textSelectionTheme.selectionColor),
            
            const SizedBox(height: 10, width: 25,),
            Expanded(child: Text(
              widget.text,
              style: TextStyle(
                color: Theme.of(context).textSelectionTheme.selectionHandleColor,
                fontFamily: "Montserrat",
                fontSize: 16
              ),
            )),
            FlutterSwitch(
              value: status,
              showOnOff: true,
              padding: 10,
              onToggle: (val) {
                setState(() {status = widget.callback(val);});
              },
            )            
          ],          
        )
      )
    );
  }
}