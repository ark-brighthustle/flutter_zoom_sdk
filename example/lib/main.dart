import 'package:flutter/material.dart';
import 'meeting_screen.dart';

// for complete example see https://github.com/evilrat/flutter_zoom_sdk/tree/master/example

void main() => runApp(ExampleApp());

class ExampleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Example Zoom SDK',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      navigatorObservers: [ ],
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => MeetingWidget(),
      },
    );
  }
}
