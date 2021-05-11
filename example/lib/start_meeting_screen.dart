import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter_zoom_sdk/zoom_view.dart';
import 'package:flutter_zoom_sdk/zoom_options.dart';

import 'package:flutter/material.dart';

class StartMeetingWidget extends StatefulWidget {

  ZoomOptions zoomOptions;
  ZoomMeetingOptions loginOptions;


  StartMeetingWidget({Key key, meetingId}) : super(key: key) {
    this.zoomOptions = new ZoomOptions(
      domain: "zoom.us",
      appKey: "XKE4uWfeLwWEmh78YMbC6mqKcF8oM4YHTr9I",
      appSecret: "bT7N61pQzaLXU6VLj9TVl7eYuLbqAiB0KAdb",
    );
    this.loginOptions = new ZoomMeetingOptions(
        userId: 'yashkumar12125@gmail.com',
        meetingPassword: 'Dlinkmoderm0641',
        disableDialIn: "false",
        disableDrive: "false",
        disableInvite: "false",
        disableShare: "false",
        disableTitlebar: "false",
        viewOptions: "false",
        noAudio: "false",
        noDisconnectAudio: "false"
    );
  }

  @override
  _StartMeetingWidgetState createState() => _StartMeetingWidgetState();
}

class _StartMeetingWidgetState extends State<StartMeetingWidget> {
  Timer timer;

  bool _isMeetingEnded(String status) {
    var result = false;

    if (Platform.isAndroid)
      result = status == "MEETING_STATUS_DISCONNECTING" || status == "MEETING_STATUS_FAILED";
    else
      result = status == "MEETING_STATUS_IDLE";

    return result;
  }

  bool _isLoading = true;

  @override
  Widget build(BuildContext context) {
    // Use the Todo to create the UI.
    return Scaffold(
      appBar: AppBar(
          title: Text('Loading meeting '),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            _isLoading ? CircularProgressIndicator() : Container(),
            Expanded(
              child: ZoomView(onViewCreated: (controller) {

                print("Created the view");

                controller.initZoom(this.widget.zoomOptions)
                    .then((results) {
                  print(results);

                  if(results[0] == 0) {

                    controller.zoomStatusEvents.listen((status) {
                      print("Meeting Status Stream: " + status[0] + " - " + status[1]);
                      if (_isMeetingEnded(status[0])) {
                        Navigator.pop(context);
                        timer?.cancel();
                      }
                    });

                    print("listen on event channel");

                    controller.login(this.widget.loginOptions).then((loginResult) {
                      print("LoginResultBool :- " + loginResult.toString());
                      if(loginResult){
                        print("LoginResult :- Logged In");
                        setState(() {
                          _isLoading = false;
                        });
                      }else{
                        print("LoginResult :- Logged In Failed");
                      }
                    });
                  }

                }).catchError((error) {
                  print(error);
                });
              }),
            ),
          ],
        ),
      ),
    );
  }
}
