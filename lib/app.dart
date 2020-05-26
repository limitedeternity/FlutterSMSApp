import 'package:flutter/material.dart';
import 'package:fluttersmsapp/pages/chatScreen.dart';
import 'package:fluttersmsapp/core/queryPermissions.dart';

class Application extends StatefulWidget {
  @override
  ApplicationState createState() => new ApplicationState();
}

class ApplicationState extends State<Application> {
  bool permissionsGranted = false;

  @override
  void initState() {
    super.initState();

    queryPermissions().then((bool val) {
      setState(() {
        permissionsGranted = val;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("FlutterSMSApp"),
        elevation: 0.7,
      ),
      body: permissionsGranted
          ? new ChatScreen()
          : new Center(
              child: new CircularProgressIndicator(),
            ),
    );
  }
}
