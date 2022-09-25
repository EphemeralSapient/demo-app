import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ngp/database.dart';
import 'package:ngp/global.dart' as global;
import 'package:ngp/sub_screen/infoEdit.dart';
import 'package:ota_update/ota_update.dart';

class _profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(), () async {
      db_fetch_return fetch = await global.Database!
          .get(global.collectionMap["acc"]!, global.loggedUID!);
      Map<String, dynamic> data = fetch.data as dynamic;
      debugPrint(data.toString());

      data["test"] = Timestamp.now();

      fetch = await global.Database!
          .update(global.collectionMap["acc"]!, global.loggedUID!, data);
      debugPrint(fetch.status.toString());
    });
    debugPrint(" >>>> Done");
    return SizedBox(height:120, width: 80, child: ElevatedButton(onPressed: () {promptStaffInfoEdit();},child: global.textWidgetWithHeavyFont("click me")));
  }
}

class profile extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return OTAApp();
  }
}



class OTAApp extends StatefulWidget {
  const OTAApp({super.key});

  @override
  _OTAAppState createState() => _OTAAppState();
}

class _OTAAppState extends State<OTAApp> {
  OtaEvent? currentEvent;
  String? error;

  @override
  void initState() {
    super.initState();
    getPackageInfo();
  }

  Future<void> getPackageInfo() async {
    setState(() {});
  }

  Future<void> tryOtaUpdate() async {
    try {
      //LINK CONTAINS APK OF FLUTTER HELLO WORLD FROM FLUTTER SDK EXAMPLES
      OtaUpdate()
          .execute(
        'https://408e-34-172-187-101.ngrok.io/app-release.apk',
        destinationFilename: 'app-release.apk',
        //FOR NOW ANDROID ONLY - ABILITY TO VALIDATE CHECKSUM OF FILE:
        //sha256checksum: 'd6da28451a1e15cf7a75f2c3f151befad3b80ad0bb232ab15c20897e54f21478',
      )
          .listen(
        (OtaEvent event) {
          setState(() => currentEvent = event);
        },
      );
    } catch (e) {
      error = e.toString();
      debugPrint('Failed to make OTA update. Details: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: ListView(
          children: [
            ListTile(
              title: const Text('OTA State'),
              trailing: Text(currentEvent?.status.toString() ?? '-'),
            ),
            ListTile(
              title: const Text('OTA Percent'),
              trailing: Text(currentEvent?.value ?? '-'),
            ),
            ElevatedButton(
              onPressed: tryOtaUpdate,
              child: const Text('Update App'),
            ),
            Text(error ?? '')
          ],
        ),
      ),
    );
  }
}