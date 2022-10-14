import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ngp/global.dart' as global;
Map data = {};
void promptProfileInfo(Map userData) {
  data = userData;
  global.switchToSecondaryUi(profileInfo());
}

class profileInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body:  CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
             leading: IconButton(
              onPressed: () {
                global.switchToPrimaryUi();
              },
              icon: Icon(Icons.arrow_back, color: Theme.of(context).textSelectionTheme.selectionHandleColor,),
            ),
            pinned: true,
            snap: false,
            floating: false,
            backgroundColor: Theme.of(context).buttonColor,
            expandedHeight: 300.0,
            elevation: 10,
            centerTitle: true,
            title: global.textWidget(data["firstName"]),
            flexibleSpace: FlexibleSpaceBar(
              background:  ClipOval(
                child: data["avatar"] != null
                  ? FadeInImage.assetNetwork(placeholder: "asset/images/loading.gif", image: data["avatar"])
                  : Icon(Icons.person, color: Theme.of(context).textSelectionTheme.selectionColor!),
              ),
                                            
            ),
          ),
          // const SliverToBoxAdapter(
          //   child: SizedBox(
          //     height: 20,
          //     child: Center(
          //       child: Text('Scroll to see the SliverAppBar in effect.'),
          //     ),
          //   ),
          // ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return Container(
                  height: 1000.0,
                  child: Center(
                    child: global.textWidget("Implementing process on-going"),
                  ),
                );
              },
              childCount: 1,
            ),
          ),
        ]
      )
    ); 
  }

}