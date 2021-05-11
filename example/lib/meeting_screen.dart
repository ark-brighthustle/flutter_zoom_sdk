import 'dart:async';
import 'dart:io';


import 'package:flutter/material.dart';
import 'package:flutter_zoom_sdk/zoom_view.dart';
import 'package:flutter_zoom_sdk/zoom_options.dart';
class MeetingWidget extends StatelessWidget {

  ZoomOptions zoomOptions;
  ZoomMeetingOptions meetingOptions;

  Timer timer;

  MeetingWidget({Key key, meetingId, meetingPassword}) : super(key: key) {
    this.zoomOptions = new ZoomOptions(
      domain: "zoom.us",
      appKey: "apiKey",
      appSecret: "appSecret",
    );
    this.meetingOptions = new ZoomMeetingOptions(
        userId: 'username', //pass username for join meeting only
        meetingId: meetingId, //pass meeting id for join meeting only
        meetingPassword: meetingPassword, //pass meeting password for join meeting only
        disableDialIn: "true",
        disableDrive: "true",
        disableInvite: "true",
        disableShare: "true",
        disableTitlebar: "true",
        viewOptions: "true",
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

            print("initialised");
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

              controller.joinMeeting(this.meetingOptions)
                  .then((joinMeetingResult) {

                timer = Timer.periodic(new Duration(seconds: 2), (timer) {
                  controller.meetingStatus(this.meetingOptions.meetingId)
                      .then((status) {
                    print("Meeting Status Polling: " + status[0] + " - " + status[1]);
                  });
                });

              });
            }

          }).catchError((error) {

            print("Error");
            print(error);
          });
        })
      ),
    );
  }

}
