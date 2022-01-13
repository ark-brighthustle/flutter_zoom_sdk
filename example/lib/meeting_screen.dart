import 'dart:async';
import 'dart:html' hide Platform;
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_sdk/flutter_zoom_web.dart';
import 'package:flutter_zoom_sdk/zoom_view.dart';

class MeetingWidget extends StatefulWidget {
  @override
  _MeetingWidgetState createState() => _MeetingWidgetState();
}

class _MeetingWidgetState extends State<MeetingWidget> {
  TextEditingController meetingIdController = TextEditingController();
  TextEditingController meetingPasswordController = TextEditingController();
  late Timer timer;

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
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: TextField(
                  controller: meetingPasswordController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                  ),
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
                      onPressed: () => {
                        if (kIsWeb)
                          {joinMeetingWeb(context)}
                        else
                          {joinMeeting(context)}
                      },
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
                      onPressed: () => {
                        if (kIsWeb)
                          {startMeetingWeb(context)}
                        else
                          {startMeeting(context)}
                      },
                      child: Text('Start Meeting'),
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
                      onPressed: () => startMeetingNormal(context),
                      child: Text('Start Meeting With Meeting ID'),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  //API KEY & SECRET is required for below methods to work
  //Join Meeting With Meeting ID & Password
  joinMeeting(BuildContext context) {
    bool _isMeetingEnded(String status) {
      var result = false;

      if (Platform.isAndroid)
        result = status == "MEETING_STATUS_DISCONNECTING" ||
            status == "MEETING_STATUS_FAILED";
      else
        result = status == "MEETING_STATUS_IDLE";

      return result;
    }

    if (meetingIdController.text.isNotEmpty &&
        meetingPasswordController.text.isNotEmpty) {
      ZoomOptions zoomOptions = new ZoomOptions(
        domain: "zoom.us",
        appKey: "XKE4uWfeLwWEmh78YMbC6mqKcF8oM4YHTr9I", //API KEY FROM ZOOM
        appSecret:
            "bT7N61pQzaLXU6VLj9TVl7eYuLbqAiB0KAdb", //API SECRET FROM ZOOM
      );
      var meetingOptions = new ZoomMeetingOptions(
          userId:
              'username', //pass username for join meeting only --- Any name eg:- EVILRATT.
          meetingId:
              meetingIdController.text, //pass meeting id for join meeting only
          meetingPassword: meetingPasswordController
              .text, //pass meeting password for join meeting only
          disableDialIn: "true",
          disableDrive: "true",
          disableInvite: "true",
          disableShare: "true",
          disableTitlebar: "false",
          viewOptions: "true",
          noAudio: "false",
          noDisconnectAudio: "false");

      var zoom = ZoomView();
      zoom.initZoom(zoomOptions).then((results) {
        if (results[0] == 0) {
          zoom.onMeetingStatus().listen((status) {
            print("[Meeting Status Stream] : " + status[0] + " - " + status[1]);
            if (_isMeetingEnded(status[0])) {
              print("[Meeting Status] :- Ended");
              timer.cancel();
            }
          });
          print("listen on event channel");
          zoom.joinMeeting(meetingOptions).then((joinMeetingResult) {
            timer = Timer.periodic(new Duration(seconds: 2), (timer) {
              zoom.meetingStatus(meetingOptions.meetingId!).then((status) {
                print("[Meeting Status Polling] : " +
                    status[0] +
                    " - " +
                    status[1]);
              });
            });
          });
        }
      }).catchError((error) {
        print("[Error Generated] : " + error);
      });
    } else {
      if (meetingIdController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Enter a valid meeting id to continue."),
        ));
      } else if (meetingPasswordController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Enter a meeting password to start."),
        ));
      }
    }
  }

  //Start Meeting With Random Meeting ID ----- Emila & Password For Zoom is required.
  startMeeting(BuildContext context) {
    bool _isMeetingEnded(String status) {
      var result = false;

      if (Platform.isAndroid)
        result = status == "MEETING_STATUS_DISCONNECTING" ||
            status == "MEETING_STATUS_FAILED";
      else
        result = status == "MEETING_STATUS_IDLE";

      return result;
    }

    ZoomOptions zoomOptions = new ZoomOptions(
      domain: "zoom.us",
      appKey: "XKE4uWfeLwWEmh78YMbC6mqKcF8oM4YHTr9I", //API KEY FROM ZOOM
      appSecret: "bT7N61pQzaLXU6VLj9TVl7eYuLbqAiB0KAdb", //API SECRET FROM ZOOM
    );
    var meetingOptions = new ZoomMeetingOptions(
        userId: 'evilrattdeveloper@gmail.com', //pass host email for zoom
        userPassword: 'Dlinkmoderm0641', //pass host password for zoom
        disableDialIn: "false",
        disableDrive: "false",
        disableInvite: "false",
        disableShare: "false",
        disableTitlebar: "false",
        viewOptions: "false",
        noAudio: "false",
        noDisconnectAudio: "false");

    var zoom = ZoomView();
    zoom.initZoom(zoomOptions).then((results) {
      if (results[0] == 0) {
        zoom.onMeetingStatus().listen((status) {
          print("[Meeting Status Stream] : " + status[0] + " - " + status[1]);
          if (_isMeetingEnded(status[0])) {
            print("[Meeting Status] :- Ended");
            timer.cancel();
          }
          if (status[0] == "MEETING_STATUS_INMEETING") {
            zoom.meetinDetails().then((meetingDetailsResult) {
              print("[MeetingDetailsResult] :- " +
                  meetingDetailsResult.toString());
            });
          }
        });
        zoom.startMeeting(meetingOptions).then((loginResult) {
          print("[LoginResult] :- " + loginResult[0] + " - " + loginResult[1]);
          if (loginResult[0] == "SDK ERROR") {
            //SDK INIT FAILED
            print((loginResult[1]).toString());
          } else if (loginResult[0] == "LOGIN ERROR") {
            //LOGIN FAILED - WITH ERROR CODES
            print((loginResult[1]).toString());
          } else {
            //LOGIN SUCCESS & MEETING STARTED - WITH SUCCESS CODE 200
            print((loginResult[0]).toString());
          }
        });
      }
    }).catchError((error) {
      print("[Error Generated] : " + error);
    });
  }

  //Start Meeting With Custom Meeting ID ----- Emila & Password For Zoom is required.
  startMeetingNormal(BuildContext context) {
    bool _isMeetingEnded(String status) {
      var result = false;

      if (Platform.isAndroid)
        result = status == "MEETING_STATUS_DISCONNECTING" ||
            status == "MEETING_STATUS_FAILED";
      else
        result = status == "MEETING_STATUS_IDLE";

      return result;
    }

    ZoomOptions zoomOptions = new ZoomOptions(
      domain: "zoom.us",
      appKey: "XKE4uWfeLwWEmh78YMbC6mqKcF8oM4YHTr9I", //API KEY FROM ZOOM
      appSecret: "bT7N61pQzaLXU6VLj9TVl7eYuLbqAiB0KAdb", //API SECRET FROM ZOOM
    );
    var meetingOptions = new ZoomMeetingOptions(
        userId: 'evilrattdeveloper@gmail.com', //pass host email for zoom
        userPassword: 'Dlinkmoderm0641', //pass host password for zoom
        meetingId: "", //
        disableDialIn: "false",
        disableDrive: "false",
        disableInvite: "false",
        disableShare: "false",
        disableTitlebar: "false",
        viewOptions: "false",
        noAudio: "false",
        noDisconnectAudio: "false");

    var zoom = ZoomView();
    zoom.initZoom(zoomOptions).then((results) {
      if (results[0] == 0) {
        zoom.onMeetingStatus().listen((status) {
          print("[Meeting Status Stream] : " + status[0] + " - " + status[1]);
          if (_isMeetingEnded(status[0])) {
            print("[Meeting Status] :- Ended");
            timer.cancel();
          }
          if (status[0] == "MEETING_STATUS_INMEETING") {
            zoom.meetinDetails().then((meetingDetailsResult) {
              print("[MeetingDetailsResult] :- " +
                  meetingDetailsResult.toString());
            });
          }
        });
        zoom.startMeetingNormal(meetingOptions).then((loginResult) {
          print("[LoginResult] :- " + loginResult.toString());
          if (loginResult[0] == "SDK ERROR") {
            //SDK INIT FAILED
            print((loginResult[1]).toString());
          } else if (loginResult[0] == "LOGIN ERROR") {
            //LOGIN FAILED - WITH ERROR CODES
            print((loginResult[1]).toString());
          } else {
            //LOGIN SUCCESS & MEETING STARTED - WITH SUCCESS CODE 200
            print((loginResult[0]).toString());
          }
        });
      }
    }).catchError((error) {
      print("[Error Generated] : " + error);
    });
  }

  // WEB Example

  //API KEY & SECRET is required for below methods to work
  //Join Meeting With Meeting ID & Password For Web Only  ----- JWT is required for web to work
  //To get jwt credentials go to this link https://marketplace.zoom.us/develop/create and under Jwt click create to get jwt credentials
  joinMeetingWeb(BuildContext context) {
    if (meetingIdController.text.isNotEmpty &&
        meetingPasswordController.text.isNotEmpty) {
      ZoomOptions zoomOptions = new ZoomOptions(
          domain: "zoom.us",
          appKey: "LAyezanZSziuhe8Yxt5IQQ", //API KEY FROM ZOOM - Jwt API Key
          appSecret:
              "iSFZ47c5mZ2U7GcpwrL4PutzQbcxXNagdSxQ", //API SECRET FROM ZOOM - Jwt API Secret
          language: "en-US", // Optional - For Web
          showMeetingHeader: true, // Optional - For Web
          disableInvite: false, // Optional - For Web
          disableCallOut: false, // Optional - For Web
          disableRecord: false, // Optional - For Web
          disableJoinAudio: false, // Optional - For Web
          audioPanelAlwaysOpen: false, // Optional - For Web
          isSupportAV: true, // Optional - For Web
          isSupportChat: true, // Optional - For Web
          isSupportQA: true, // Optional - For Web
          isSupportCC: true, // Optional - For Web
          isSupportPolling: true, // Optional - For Web
          isSupportBreakout: true, // Optional - For Web
          screenShare: true, // Optional - For Web
          rwcBackup: '', // Optional - For Web
          videoDrag: true, // Optional - For Web
          sharingMode: 'both', // Optional - For Web
          videoHeader: true, // Optional - For Web
          isLockBottom: true, // Optional - For Web
          isSupportNonverbal: true, // Optional - For Web
          isShowJoiningErrorDialog: true, // Optional - For Web
          disablePreview: false, // Optional - For Web
          disableCORP: true, // Optional - For Web
          inviteUrlFormat: '', // Optional - For Web
          disableVOIP: false, // Optional - For Web
          disableReport: false, // Optional - For Web
          meetingInfo: const [
            // Optional - For Web
            'topic',
            'host',
            'mn',
            'pwd',
            'telPwd',
            'invite',
            'participant',
            'dc',
            'enctype',
            'report'
          ]);
      var meetingOptions = new ZoomMeetingOptions(
        userId:
            'EvilRAT Technologies', //pass username for join meeting only --- Any name eg:- EVILRATT.
        meetingId:
            meetingIdController.text, //pass meeting id for join meeting only
        meetingPassword: meetingPasswordController
            .text, //pass meeting password for join meeting only
      );

      var zoom = ZoomViewWeb();
      zoom.initZoom(zoomOptions).then((results) {
        if (results[0] == 0) {
          var zr = window.document.getElementById("zmmtg-root");
          querySelector('body')?.append(zr!);
          zoom.onMeetingStatus().listen((status) {
            print("[Meeting Status Stream] : " + status[0] + " - " + status[1]);
          });
          final signature = zoom.generateSignature(
              zoomOptions.appKey.toString(),
              zoomOptions.appSecret.toString(),
              meetingIdController.text,
              0);
          meetingOptions.jwtAPIKey = zoomOptions.appKey.toString();
          meetingOptions.jwtSignature = signature;
          zoom.joinMeeting(meetingOptions).then((joinMeetingResult) {
            print("[Meeting Status Polling] : " + joinMeetingResult.toString());
            timer = Timer.periodic(new Duration(seconds: 2), (timer) {
              zoom.meetingStatus(meetingOptions.meetingId!).then((status) {
                print("[Meeting Status Polling] : " +
                    status[0] +
                    " - " +
                    status[1]);
              });
            });
          });
        }
      }).catchError((error) {
        print("[Error Generated] : " + error);
      });
    } else {
      if (meetingIdController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Enter a valid meeting id to continue."),
        ));
      } else if (meetingPasswordController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Enter a meeting password to start."),
        ));
      }
    }
  }

  //Start Meeting With Meeting ID and Passcode ----- Jwt Credentials is required
  //To get jwt credentials go to this link https://marketplace.zoom.us/develop/create and under Jwt click create to get jwt credentials
  startMeetingWeb(BuildContext context) {
    if (meetingIdController.text.isNotEmpty &&
        meetingPasswordController.text.isNotEmpty) {
      ZoomOptions zoomOptions = new ZoomOptions(
          domain: "zoom.us",
          appKey: "LAyezanZSziuhe8Yxt5IQQ", //API KEY FROM ZOOM - Jwt API Key
          appSecret:
              "iSFZ47c5mZ2U7GcpwrL4PutzQbcxXNagdSxQ", //API SECRET FROM ZOOM - Jwt API Secret
          language: "en-US", // Optional - For Web
          showMeetingHeader: true, // Optional - For Web
          disableInvite: false, // Optional - For Web
          disableCallOut: false, // Optional - For Web
          disableRecord: false, // Optional - For Web
          disableJoinAudio: false, // Optional - For Web
          audioPanelAlwaysOpen: false, // Optional - For Web
          isSupportAV: true, // Optional - For Web
          isSupportChat: true, // Optional - For Web
          isSupportQA: true, // Optional - For Web
          isSupportCC: true, // Optional - For Web
          isSupportPolling: true, // Optional - For Web
          isSupportBreakout: true, // Optional - For Web
          screenShare: true, // Optional - For Web
          rwcBackup: '', // Optional - For Web
          videoDrag: true, // Optional - For Web
          sharingMode: 'both', // Optional - For Web
          videoHeader: true, // Optional - For Web
          isLockBottom: true, // Optional - For Web
          isSupportNonverbal: true, // Optional - For Web
          isShowJoiningErrorDialog: true, // Optional - For Web
          disablePreview: false, // Optional - For Web
          disableCORP: true, // Optional - For Web
          inviteUrlFormat: '', // Optional - For Web
          disableVOIP: false, // Optional - For Web
          disableReport: false, // Optional - For Web
          meetingInfo: const [
            // Optional - For Web
            'topic',
            'host',
            'mn',
            'pwd',
            'telPwd',
            'invite',
            'participant',
            'dc',
            'enctype',
            'report'
          ]);
      var meetingOptions = new ZoomMeetingOptions(
        userId: 'EvilRAT Technologies', //pass host email for zoom
        meetingId: meetingIdController
            .text, //Personal meeting id for start meeting required
        meetingPassword: meetingPasswordController
            .text, //Personal meeting passcode for start meeting required
        //To get personal meeting id and passcode follow https://zoom.us/meeting#/ and novigate to Personal Room tab
      );

      var zoom = ZoomViewWeb();
      zoom.initZoom(zoomOptions).then((results) {
        if (results[0] == 0) {
          var zr = window.document.getElementById("zmmtg-root");
          querySelector('body')?.append(zr!);
          zoom.onMeetingStatus().listen((status) {
            print("[Meeting Status Stream] : " + status[0] + " - " + status[1]);
          });
          final signature = zoom.generateSignature(
              zoomOptions.appKey.toString(),
              zoomOptions.appSecret.toString(),
              meetingIdController.text,
              1);
          meetingOptions.jwtAPIKey = zoomOptions.appKey.toString();
          meetingOptions.jwtSignature = signature;
          zoom.startMeeting(meetingOptions).then((startMeetingResult) {
            print("[Meeting Status Polling] : " +
                startMeetingResult[0] +
                " - " +
                startMeetingResult[1]);
            timer = Timer.periodic(new Duration(seconds: 2), (timer) {
              zoom.meetingStatus(meetingOptions.meetingId!).then((status) {
                print("[Meeting Status Polling] : " +
                    status[0] +
                    " - " +
                    status[1]);
              });
            });
          });
        }
      }).catchError((error) {
        print("[Error Generated] : " + error);
      });
    } else {
      if (meetingIdController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Enter a valid personal meeting id to continue."),
        ));
      } else if (meetingPasswordController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Enter a meeting passcode to start."),
        ));
      }
    }
  }
}
