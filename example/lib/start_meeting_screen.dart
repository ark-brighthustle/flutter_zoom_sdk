import 'dart:async';
import 'dart:io';

import 'package:flutter_zoom_sdk/zoom_view.dart';
import 'package:flutter_zoom_sdk/zoom_options.dart';

import 'package:flutter/material.dart';

class StartMeetingWidget extends StatelessWidget {

  ZoomOptions zoomOptions;
  ZoomMeetingOptions meetingOptions;

  Timer timer;

  StartMeetingWidget({Key key, meetingId}) : super(key: key) {
    this.zoomOptions = new ZoomOptions(
      domain: "zoom.us",
      appKey: "XKE4uWfeLwWEmh78YMbC6mqKcF8oM4YHTr9I",
      appSecret: "bT7N61pQzaLXU6VLj9TVl7eYuLbqAiB0KAdb",
    );
    this.meetingOptions = new ZoomMeetingOptions(
        userId: '<zoom_user_id>',
        displayName: 'Kumar',
        meetingId: meetingId,
        zoomAccessToken: "<User zak>",
        zoomToken: "<user_token>",
        disableDialIn: "true",
        disableDrive: "true",
        disableInvite: "true",
        disableShare: "true",
        noAudio: "false",
        noDisconnectAudio: "false"
    );
  }

  bool _isMeetingEnded(String status) {
    var result = false;

    if (Platform.isAndroid)
      result = status == "MEETING_STATUS_DISCONNECTING" || status == "MEETING_STATUS_FAILED";
    else
      result = status == "MEETING_STATUS_IDLE";

    return result;
  }

  @override
  Widget build(BuildContext context) {
    // Use the Todo to create the UI.
    return Scaffold(
      appBar: AppBar(
          title: Text('Loading meeting '),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ZoomView(onViewCreated: (controller) {

          print("Created the view");

          controller.initZoom(this.zoomOptions)
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

              controller.startMeeting(this.meetingOptions)
                  .then((joinMeetingResult) {

                timer = Timer.periodic(new Duration(seconds: 2), (timer) {
                  controller.meetingStatus(this.meetingOptions.meetingId)
                      .then((status) {
                    print("Meeting Status : " + status[0] + " - " + status[1]);
                  });
                });

              });
            }

          }).catchError((error) {
            print(error);
          });
        })
      ),
    );
  }

}
