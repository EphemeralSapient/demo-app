import 'package:flutter/material.dart';
import 'package:ngp/global.dart' as global;
import 'package:ngp/ui/dragUi.dart';
import 'package:ngp/ui/searchButton.dart';
import 'package:string_similarity/string_similarity.dart';

Color bgColor = Colors.transparent;
TextEditingController textController = TextEditingController();

class search extends StatefulWidget {
  @override
  State<search> createState() => _searchState();
}

class _searchState extends State<search> {

  List<Map<String, dynamic>> accounts = [];
  List<Map<String, dynamic>> searchSorted = [];

  @override
  void initState() {
    for(var x in global.accountsInDatabase.entries) {
      if(x.value["phoneNo"] != null) {
        
        if(x.value["isStudent"] == true) {
          accounts.add({
            "avatar" : x.value["avatar"],
            "name" : "${x.value["firstName"]} ${x.value["lastName"]}",
            "nextToName" : "Student",
            "id" : x.key,
            "title" : "${x.value["department"].toString().toUpperCase()}-${x.value["section"].toString().toUpperCase()} ${x.value["year"].toString().toUpperCase()} Year",
          });
        } else {
          accounts.add({
            "avatar" : x.value["avatar"],
            "name" : "${x.value["title"]} ${x.value["firstName"]} ${x.value["lastName"]}",
            "nextToName" : "Faculty",
            "id" : x.key,
            "title" : x.value["position"]            
          });
        }
      }

      searchSorted = accounts;
    }
    
    super.initState();
      bgColor = Theme.of(global.rootCTX!).buttonColor;
    

  }
  
  @override
  Widget build(BuildContext context) {

    debugPrint("Building searchbar screen");

    Widget searchBar = Material(
      color: Colors.transparent,
      child: AnimSearchBar(
        width: 300,
        //rtl: global.dragUiPosition != null ? (global.dragUiPosition!.dx > MediaQuery.of(context).size.width/2 ? true : false) : false,
        rtl: true,
        textController: textController,
        onSuffixTap: () {
          textController.clear();
        },
        color: Theme.of(context).buttonColor,
        closeSearchOnSuffixTap: true,
        style: TextStyle(
          //fontSize: 12
          color: Theme.of(context).textSelectionTheme.selectionColor,
          fontFamily: "Metropolis",
          fontWeight: FontWeight.normal,
          fontSize: 17
        ),
        helpText: "Tap here to search!",
        onInputChanged: (value) {
          if(value == "" || value == null) {
            searchSorted = accounts;
          } else {
            List newList = [];
            Map<int, List> matches = {};

            matches = {1:[], 2:[], 3:[], 4:[], 5:[],6 : [], 7: [], 8: [], 9: [], 10: []};
            for(var x in accounts) {
              double rating = StringSimilarity.compareTwoStrings(value.toString().toLowerCase(), x["name"].toString().toLowerCase());
              int matching = (rating*10).toInt();

              if(matching >= 1) {
                matches[matching]?.add(x);
              }
            }
            for(int i = 10; i>=1; i--) {
              for(var x in matches[i]!) {
                newList.add(x);
              }
            }

            matches = {1:[], 2:[], 3:[], 4:[], 5:[],6 : [], 7: [], 8: [], 9: [], 10: []};
            for(var x in accounts) {
              double rating = StringSimilarity.compareTwoStrings(value.toString().toLowerCase(), x["title"].toString().toLowerCase());
              int matching = (rating*10).toInt();

              if(matching >= 1) {
                matches[matching]?.add(x);
              }
            }
            for(int i = 10; i>=1; i--) {
              for(var x in matches[i]!) {
                if(newList.contains(x) == false) {
                  newList.add(x);
                }
              }
            }
      
            searchSorted = List.from(newList);
            newList.clear();
          }

          setState(() {});
        },
      ),
    );


    return AnimatedContainer(
      duration: Duration(seconds: 1),
      color: searchSorted.isEmpty ? Colors.red.withOpacity(0.5) : bgColor,
      padding: EdgeInsets.only(top: 10, right: 10, left: 10, bottom: 60),

      child: Stack(
        children: [
          
          SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 40,),

                for(Map x in searchSorted) 
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Card(
                      surfaceTintColor: Colors.transparent,
                      color: Theme.of(context).buttonColor,
                      elevation: 0,
                      clipBehavior: Clip.antiAlias,

                      child: InkWell(
                        onTap: () {

                        },
                        child: SizedBox(
                          height: 75,
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Wrap(
                              alignment: WrapAlignment.start,
                              runAlignment: WrapAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(3),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: Colors.transparent,
                                    border: Border.all(
                                      width: 1.1,
                                      color: Colors.red,
                                    ),
                                  ),
                                  width: 50,
                                  height: 50,
                                  child: ClipOval(
                                    child: x["avatar"] != null
                                        ? FadeInImage.assetNetwork(placeholder: "asset/images/loading.gif", image: x["avatar"])
                                        : Icon(Icons.person, color: Theme.of(context).textSelectionTheme.selectionColor!),
                                  ),
                                ),
                      
                                SizedBox(width: 10),
                      
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    global.textDoubleSpanWiget("${x["name"]}   ", x["nextToName"]),
                      
                                    SizedBox(height: 10,),
                      
                                    global.textWidget(x["title"] ?? "")
                                  ],
                                )
                              ],
                            )
                          ),
                        ),
                      ),
                    ),
                  ) 
              ],
            ),
          ),
          
          
          StatefulDragArea(
            callback: () {
              searchSorted = accounts;
              setState(() {});
            },
            child: searchBar,
          )
        ],
      ),
    );
  }
}