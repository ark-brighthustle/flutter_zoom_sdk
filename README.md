# Flutter Zoom SDK

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

A Flutter plugin for the Zoom SDK With all features and null safety support.

*Note*: This plugin is still under active development, and some Zoom features might not be available yet. We are working to add more features.
Feedback and IOS Version currently under development, Pull Requests are always welcome.

## Features

- [x] Updated Zoom SDK.
- [x] Null Safety.
- [x] Stream meeting status.
- [x] Join meeting.
- [x] Start an instant meeting for Login user.
- [x] Hide Title bar or Hide Meeting info (Useful for e-learning platform).
- [x] Change Meeting Notification App Name & Zoom Notification Icon Removed.
- [ ] IOS Support (Coming Soon by first week of Aug).
- [ ] Web Support 
- [ ] Schedule Meeting.
- [ ] List, Delete & Update Scheduled Meeting.
- [ ] Share Screen using Sharing key or Meeting ID directly.

## Zoom SDK Versions

*Note*: Updated to new sdk with new features.

## Installation

First, add `flutter_zoom_sdk: ^0.0.6` as a [dependency in your pubspec.yaml file](https://flutter.io/using-packages/).

### Android

Change the minimum Android sdk version to at the minimum 21 in your `android/app/build.gradle` file.

```
minSdkVersion 21
```

To Change the Notification name copy the below code to `android/app/src/main/res/values/strings.xml` file

```
<string name="app_name_zoom_local" >Your App Name</string>
```

Add the zoom proguard content to your android project: https://github.com/zoom/zoom-sdk-android/blob/master/proguard.cfg

```
-keep class us.zoom.{*;}
-keep class com.zipow.{;}
-keep class us.zipow.**{;}
-keep class org.webrtc.{*;}
-keep class us.google.protobuf.{;}
-keep class com.google.crypto.tink.**{;}
-keep class androidx.security.crypto.**{*;}
```
## Examples

### Meeting status

There are 2 ways to obtains the Zoom meeting status
- Listen to Zoom Status Event stream, or
- Polling the Zoom status using a `Timer`


The plugin emits the following Zoom meeting events:

For Android:
- `MEETING_STATUS_IDLE`
- `MEETING_STATUS_CONNECTING`
- `MEETING_STATUS_INMEETING`
- `MEETING_STATUS_WEBINAR_PROMOTE`
- `MEETING_STATUS_WEBINAR_DEPROMOTE`
- `MEETING_STATUS_UNKNOWN`
- `MEETING_STATUS_DISCONNECTING`
- `MEETING_STATUS_FAILED`
- `MEETING_STATUS_IN_WAITING_ROOM`
- `MEETING_STATUS_RECONNECTING`
- `MEETING_STATUS_WAITINGFORHOST`

| Left-Aligned  | Center Aligned  |
| :------------ |:---------------:|
| ERROR- 0      | some wordy text |
| ERROR- 0      | centered        |
| ERROR- 0      | are neat        |

### Join Meeting

```dart
class MeetingWidget extends StatelessWidget {

  ZoomOptions zoomOptions;
  ZoomMeetingOptions meetingOptions;

  Timer timer;

  MeetingWidget({Key key, meetingId, meetingPassword}) : super(key: key) {
    // Setting up the Zoom credentials
    this.zoomOptions = new ZoomOptions(
      domain: "zoom.us",
      appKey: "appKey", // Replace with with key got from the Zoom Marketplace
      appSecret: "appSecret", // Replace with with secret got from the Zoom Marketplace
    );

    // Setting Zoom meeting options (default to false if not set)
    this.meetingOptions = new ZoomMeetingOptions(
        userId: 'example', //pass username for join meeting only
        meetingId: meetingId, //pass meeting id for join meeting only
        meetingPassword: meetingPassword, //pass meeting password for join meeting only
        disableDialIn: "true",
        disableDrive: "true",
        disableInvite: "true",
        disableShare: "true",
        noAudio: "false",
        disableTitlebar: "false", //Make it true for disabling titlebar
        viewOptions: "false", //Make it true for hiding zoom icon on meeting ui which shows meeting id and password
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
    return Scaffold(
      appBar: AppBar(
          title: Text('Initializing meeting '),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ZoomView(onViewCreated: (controller) {

          print("Created the view");

          controller.initZoom(this.zoomOptions)
              .then((results) {

            if(results[0] == 0) {

              // Listening on the Zoom status stream (1)
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

                    // Polling the Zoom status (2)
                timer = Timer.periodic(new Duration(seconds: 2), (timer) {
                  controller.meetingStatus(this.meetingOptions.meetingId)
                      .then((status) {
                    print("Meeting Status Polling: " + status[0] + " - " + status[1]);
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
```

### Start a Meeting - Login user

1. Pass the Zoom user ID or user email and password to the plugin.

```dart
class StartMeetingWidget extends StatefulWidget {

  ZoomOptions zoomOptions;
  ZoomMeetingOptions loginOptions;


  StartMeetingWidget({Key key, meetingId}) : super(key: key) {
    this.zoomOptions = new ZoomOptions(
      domain: "zoom.us",
      appKey: "apiKey", // Replace with with key got from the Zoom Marketplace ZOOM SDK Section
      appSecret: "appSecret", // Replace with with key got from the Zoom Marketplace ZOOM SDK Section
    );
    this.loginOptions = new ZoomMeetingOptions(
        userId: 'useremail', // Replace with the user email or Zoom user ID of host for start meeting only.
        meetingPassword: 'password', // Replace with the user password for your Zoom ID of host for start meeting only.
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
```
