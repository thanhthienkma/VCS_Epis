import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:utils/utils.dart';
import 'package:utils/dialog/downloaddialog/DownloadDialog.dart';
import 'package:utils/screens/camera/UtilCameraScreen.dart';
import 'package:utils/screens/selectphotos/UtilSelectPhotosScreen.dart';

//void main() => runApp(MyApp());
//
//class MyApp extends StatefulWidget {
//  @override
//  _MyAppState createState() => _MyAppState();
//}
//
//class _MyAppState extends State<MyApp> {
//  String _platformVersion = 'Unknown';
//
//  @override
//  void initState() {
//    super.initState();
//    initPlatformState();
//  }
//
//  // Platform messages are asynchronous, so we initialize in an async method.
//  Future<void> initPlatformState() async {
////    String platformVersion;
////    // Platform messages may fail, so we use a try/catch PlatformException.
////    try {
////      platformVersion = await Utils.platformVersion;
////    } on PlatformException {
////      platformVersion = 'Failed to get platform version.';
////    }
//
//    // If the widget was removed from the tree while the asynchronous platform
//    // message was in flight, we want to discard the reply rather than calling
//    // setState to update our non-existent appearance.
////    if (!mounted) return;
////
////    setState(() {
////      _platformVersion = platformVersion;
////    });
//  }
//
//  @override
//  Widget build(BuildContext context) {
////    final size = MediaQuery.of(context).size;
//    return MaterialApp(
//      home: Scaffold(
//        appBar: AppBar(
//          title: const Text('Plugin example app'),
//        ),
//        body: Center(
//          child: InkWell(
//              onTap: () {
//                Utils.requestPermissionLibraryAndCamera(() async {
//                  List cameras = await Utils.getAvailableCamera();
//                  Map args = Map();
//                  args[CAMERAS] = cameras;
////                  args[SIZE] = MediaQuery.of(context).size;
//                  args[LIMIT] = 10;
//                  Navigator.push(
//                      context,
//                      MaterialPageRoute(
//                          builder: (context) =>
//                              UtilCameraScreen(arguments: args)));
//                });
//              },
//              child: Text('Running on: $_platformVersion\n')),
//        ),
//      ),
//    );
//  }
//}
//class HomeScreen extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return new Scaffold(
//      appBar: new AppBar(
//        title: new Text("Title"),
//      ),
//      body: new Center(child: new Text("Click Me")),
//      floatingActionButton: new FloatingActionButton(
//        child: new Icon(Icons.add),
//        backgroundColor: Colors.orange,
//        onPressed: () {
//          print("Clicked");
//          Navigator.push(
//            context,
//            new MaterialPageRoute(builder: (context) => new AddTaskScreen()),
//          );
//        },
//      ),
//    );
//  }
//}

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> values = ['Element 1', 'Element 2'];

  int _counter = 2;

  void _incrementCounter() async {
      Utils.requestPermissionLibraryAndCamera(() async {
        List cameras = await Utils.getAvailableCamera();
        Map args = Map();
        args[UtilCameraConstant.CAMERAS] = cameras;
        args[UtilCameraConstant.SIZE] = MediaQuery.of(context).size;
        args[UtilCameraConstant.LIMIT] = 10;
        args[UtilCameraConstant.IS_ONE_BACK] = true;
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => UtilCameraScreen(arguments: args)));
      });

//    Utils.requestPermissionLibrary(() async {
////      List cameras = await Utils.getAvailableCamera();
//      Map args = Map();
////      args[UtilCameraConstant.CAMERAS] = cameras;
//      args[UtilSelectPhotosConstant.SIZE] = MediaQuery.of(context).size;
//      args[UtilSelectPhotosConstant.LIMIT] = 10;
//      Navigator.push(
//          context,
//          MaterialPageRoute(
//              builder: (context) => UtilSelectPhotosScreen(arguments: args)));
//    });

//    Utils.requestPermissionLibrary(() async {
////      List cameras = await Utils.getAvailableCamera();
////      Map args = Map();
////      args[UtilSelectPhotosConstant.SIZE] = MediaQuery.of(context).size;
////      args[UtilSelectPhotosConstant.LIMIT] = 10;
////      Navigator.push(
////          context,
////          MaterialPageRoute(
////              builder: (context) => UtilSelectPhotosScreen(arguments: args)));
//
//      DownloadDialog.instance.showDownloadDialog(context, 'name', 'url', 10000);
//    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
//      body: ListView(
//        children: values.map((String value) {
//          return ItemWidget(value);
//        }).toList(),
//      ),
    body: Text('Hello'),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
