import 'package:flutter/material.dart';
import 'package:ngp/acc_update.dart';
import 'package:ngp/global.dart' as global;
class RestartWidget extends StatefulWidget {
  RestartWidget({this.child});

  final Widget? child;

  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_RestartWidgetState>()!.restartApp();
  }

  @override
  _RestartWidgetState createState() => _RestartWidgetState();
}

class _RestartWidgetState extends State<RestartWidget> {
  Key key = UniqueKey();

  void restartApp() {
    releaseLockAccUpdate();
    setState(() {
      key = UniqueKey();
    });
  }

  @override
  void initState() {
    global.restartApp = restartApp;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: key,
      child: widget.child!,
    );
  }
}
