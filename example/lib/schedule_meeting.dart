import 'dart:async';
import 'dart:io';


import 'package:flutter/material.dart';
import 'package:flutter_zoom_sdk/zoom_view.dart';
import 'package:flutter_zoom_sdk/zoom_options.dart';
class ScheduleMeeting extends StatelessWidget {

  ZoomOptions zoomOptions;
  ZoomScheduleOptions meetingOptions;

  Timer timer;

  ScheduleMeeting({Key key, meetingId, meetingPassword}) : super(key: key) {
    this.zoomOptions = new ZoomOptions(
      domain: "zoom.us",
      appKey: "XKE4uWfeLwWEmh78YMbC6mqKcF8oM4YHTr9I",
      appSecret: "bT7N61pQzaLXU6VLj9TVl7eYuLbqAiB0KAdb",
    );
    this.meetingOptions = new ZoomScheduleOptions(
      setMeetingTopic: "New Meeting",
      canJoinBeforeHost: "true",
      setPassword: "insanity6767",
      setHostVideoOff: "false",
      setAttendeeVideoOff: "false",
      setEnableMeetingToPublic: "false",
      setEnableLanguageInterpretation: "true",
      setEnableWaitingRoom: "true",
      enableAutoRecord: "false",
      autoLocalRecord: "false",
      autoCloudRecord: "false",
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

                controller.scheduleMeeting(this.meetingOptions)
                    .then((scheduleMeetingResult) {
                      // if(scheduleMeetingResult){
                      //   Navigator.pop(context);
                      //   print("Success Scheduled");
                      // }else{
                      //   Navigator.pop(context);
                      //   print("User not logged in");
                      // }

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
