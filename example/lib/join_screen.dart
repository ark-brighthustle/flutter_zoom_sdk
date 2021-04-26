import 'dart:async';


import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_sdk_example/start_meeting_screen.dart';

import 'meeting_screen.dart';

class JoinWidget extends StatefulWidget {
  @override
  _JoinWidgetState createState() => _JoinWidgetState();
}

class _JoinWidgetState extends State<JoinWidget> {

  TextEditingController meetingIdController = TextEditingController();
  TextEditingController meetingPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // new page needs scaffolding!
    return Scaffold(
      appBar: AppBar(
        title: Text('Join meeting'),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 8.0,
            horizontal: 32.0,
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: TextField(
                    controller: meetingIdController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Meeting ID',
                  ),),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: TextField(
                    controller: meetingPasswordController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                  ),),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Builder(
                  builder: (context) {
                    // The basic Material Design action button.
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue, // background
                        onPrimary: Colors.white, // foreground
                      ),
                      onPressed: () => joinMeeting(context),
                      child: Text('Join'),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Builder(
                  builder: (context) {
                    // The basic Material Design action button.
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue, // background
                        onPrimary: Colors.white, // foreground
                      ),
                      onPressed: () => startMeeting(context),
                      child: Text('Start Meeting'),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  joinMeeting(BuildContext context) {
    if(meetingIdController.text.isNotEmpty && meetingPasswordController.text.isNotEmpty){
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            return MeetingWidget(meetingId: meetingIdController.text, meetingPassword: meetingPasswordController.text);
          },
        ),
      );
    }else{
      if(meetingIdController.text.isEmpty){
        Flushbar(
          message: "Enter a valid meeting id to continue.",
          icon: Icon(
            Icons.info_outline,
            size: 28.0,
            color: Colors.blue[300],
          ),
          duration: Duration(seconds: 3),
          leftBarIndicatorColor: Colors.red[300],
        )..show(context);
      }
      else if(meetingPasswordController.text.isEmpty){
        Flushbar(
          message: "Enter a meeting password to start.",
          icon: Icon(
            Icons.info_outline,
            size: 28.0,
            color: Colors.blue[300],
          ),
          duration: Duration(seconds: 3),
          leftBarIndicatorColor: Colors.red[300],
        )..show(context);
      }
    }

  }

  startMeeting(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return StartMeetingWidget(meetingId: meetingIdController.text);
        },
      ),
    );
  }
}