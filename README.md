# Flutter Zoom SDK

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

A Flutter plugin for the Zoom SDK With all features and null safety support.

*Note*: This plugin is still under active development, and some Zoom features might not be available yet. We are working to add more features.
Feedback and iOS Version currently under development, Pull Requests are always welcome.

## Features

- [x] Updated Zoom SDK.
- [x] Null Safety.
- [x] Stream meeting status.
- [x] Join meeting.
- [x] Start an instant meeting for Login user.
- [x] Start an meeting for Login user with Meeeting ID.
- [x] Login Error with proper Error codes.
- [x] Hide Title bar or Hide Meeting info (Useful for e-learning platform).
- [x] Change Meeting Notification App Name & Zoom Notification Icon Removed.
- [ ] iOS Support (Coming Soon by 25th December 2021).
- [ ] Web Support 
- [ ] Schedule Meeting.
- [ ] List, Delete & Update Scheduled Meeting.
- [ ] Share Screen using Sharing key or Meeting ID directly.

## Zoom SDK Versions

*Note*: Updated to new sdk with new features.

## Installation

First, add `flutter_zoom_sdk: ^0.0.7` as a [dependency in your pubspec.yaml file](https://flutter.io/using-packages/).

After running pub get, you must run the follow script to get Zoom SDK for the first time:
```shell script
flutter pub run flutter_zoom_sdk:unzip_zoom_sdk
```

### Android

Change the minimum Android sdk version to at the minimum 21 in your `android/app/build.gradle` file.

```
minSdkVersion 21
```

To Change the Notification name copy the below code to `android/app/src/main/res/values/strings.xml` file

```
<string name="app_name_zoom_local" >Your App Name</string> // Put your app name in here for notification.
```

Disable shrinkResources for release buid
```
   buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig signingConfigs.debug
            shrinkResources false
            minifyEnabled false
        }
    }
```


## Error Codes

| Error Response        | Error Reference                       |
| :-------------------- |:-------------------------------------:|
|  LOGIN ERROR - 1      | EMAIL_LOGIN_DISABLE                   |
|  LOGIN ERROR - 2      | ERROR_USER_NOT_EXIST                  |
|  LOGIN ERROR - 3      | ERROR_WRONG_PASSWORD                  |
|  LOGIN ERROR - 4      | ERROR_WRONG_ACCOUNTLOCKED             |
|  LOGIN ERROR - 5      | ERROR_WRONG_SDKNEEDUPDATE             |
|  LOGIN ERROR - 6      | ERROR_WRONG_TOOMANY_FAILED_ATTEMPTS   |
|  LOGIN ERROR - 7      | ERROR_WRONG_SMSCODEERROR              |
|  LOGIN ERROR - 8      | ERROR_WRONG_SMSCODEEXPIRED            |
|  LOGIN ERROR - 9      | ERROR_WRONG_PHONENUMBERFORMATINVALID  |
|  LOGIN ERROR - 10     | ERROR_LOGINTOKENINVALID               |
|  LOGIN ERROR - 11     | ERROR_UserDisagreeLoginDisclaimer     |
|  LOGIN ERROR - 100    | ERROR_WRONG_OTHER_ISSUE               |
|  SDK ERROR - 001      | ERROR_SDK_NOT_INITIALIZED             |

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

### Join Meeting

```dart
joinMeeting(BuildContext context) {
    bool _isMeetingEnded(String status) {
      var result = false;

      if (Platform.isAndroid)
        result = status == "MEETING_STATUS_DISCONNECTING" || status == "MEETING_STATUS_FAILED";
      else
        result = status == "MEETING_STATUS_IDLE";

      return result;
    }
    if(meetingIdController.text.isNotEmpty && meetingPasswordController.text.isNotEmpty){
      ZoomOptions zoomOptions = new ZoomOptions(
        domain: "zoom.us",
        appKey: "", //API KEY FROM ZOOM
        appSecret: "", //API SECRET FROM ZOOM
      );
      var meetingOptions = new ZoomMeetingOptions(
          userId: 'username', //pass username for join meeting only --- Any name eg:- EVILRATT.
          meetingId: ', //pass meeting id for join meeting only
          meetingPassword: '', //pass meeting password for join meeting only
          disableDialIn: "true",
          disableDrive: "true",
          disableInvite: "true",
          disableShare: "true",
          disableTitlebar: "false",
          viewOptions: "true",
          noAudio: "false",
          noDisconnectAudio: "false"
      );

      var zoom = ZoomView();
      zoom.initZoom(zoomOptions).then((results) {
        if(results[0] == 0) {
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
              zoom.meetingStatus(meetingOptions.meetingId!)
                  .then((status) {
                print("[Meeting Status Polling] : " + status[0] + " - " + status[1]);
              });
            });
          });
        }
      }).catchError((error) {
        print("[Error Generated] : " + error);
      });
    }else{
      if(meetingIdController.text.isEmpty){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Enter a valid meeting id to continue."),
        ));
      }
      else if(meetingPasswordController.text.isEmpty){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Enter a meeting password to start."),
        ));
      }
    }

  }
```

### Start a Meeting - Login user

1. Pass the Zoom user email and password to the plugin.

```dart
startMeeting(BuildContext context) {
    bool _isMeetingEnded(String status) {
      var result = false;

      if (Platform.isAndroid)
        result = status == "MEETING_STATUS_DISCONNECTING" || status == "MEETING_STATUS_FAILED";
      else
        result = status == "MEETING_STATUS_IDLE";

      return result;
    }
    ZoomOptions zoomOptions = new ZoomOptions(
      domain: "zoom.us",
      appKey: "", //API KEY FROM ZOOM
      appSecret: "", //API SECRET FROM ZOOM
    );
    var meetingOptions = new ZoomMeetingOptions(
        userId: '', //pass host email for zoom
        userPassword: '', //pass host password for zoom
        disableDialIn: "false",
        disableDrive: "false",
        disableInvite: "false",
        disableShare: "false",
        disableTitlebar: "false",
        viewOptions: "false",
        noAudio: "false",
        noDisconnectAudio: "false"
    );

    var zoom = ZoomView();
    zoom.initZoom(zoomOptions).then((results) {
      if(results[0] == 0) {
        zoom.onMeetingStatus().listen((status) {
          print("[Meeting Status Stream] : " + status[0] + " - " + status[1]);
          if (_isMeetingEnded(status[0])) {
            print("[Meeting Status] :- Ended");
            timer.cancel();
          }
          if(status[0] == "MEETING_STATUS_INMEETING"){
            zoom.meetinDetails().then((meetingDetailsResult) {
              print("[MeetingDetailsResult] :- " + meetingDetailsResult.toString());
            });
          }
        });
        zoom.startMeeting(meetingOptions).then((loginResult) {
          print("[LoginResult] :- " + loginResult[0] + " - " + loginResult[1]);
          if(loginResult[0] == "SDK ERROR"){
            //SDK INIT FAILED
            print((loginResult[1]).toString());
          }else if(loginResult[0] == "LOGIN ERROR"){
            //LOGIN FAILED - WITH ERROR CODES
            print((loginResult[1]).toString());
          }else{
            //LOGIN SUCCESS & MEETING STARTED - WITH SUCCESS CODE 200
            print((loginResult[0]).toString());
          }
        });
      }
    }).catchError((error) {
      print("[Error Generated] : " + error);
    });
  }
```

## Migration Guide

### Start a Meeting - Login user

```
    var meetingOptions = new ZoomMeetingOptions(
        userId: '', //pass host email for zoom
        userPassword: '', // replace 'meetingPassword' with userPassword
        disableDialIn: "false",
        disableDrive: "false",
        disableInvite: "false",
        disableShare: "false",
        disableTitlebar: "false",
        viewOptions: "false",
        noAudio: "false",
        noDisconnectAudio: "false"
    );
```

### ZoomView(onViewCreated: (controller) {} --- Replaced with

```
     var zoom = ZoomView();
     // Initializing Zoom SDK
     zoom.initZoom(zoomOptions).then((results) {}

```
### controller.zoomStatusEvents.listen((status) {} -- Replaced With

```
    var zoom = ZoomView();
    zoom.initZoom(zoomOptions).then((results) {
        if(results[0] == 0){
            zoom.onMeetingStatus().listen((status) {
                //Some Statement
                //Log for meeting status
            }
        }
    }

```

### Start meetion function chaged :-

```
    controller.login(this.widget.loginOptions).then((loginResult) {}

```

```
    var zoom = ZoomView();
    zoom.initZoom(zoomOptions).then((results) {
        if(results[0] == 0){
            zoom.onMeetingStatus().listen((status) {
                //Some Statement
                //Log for meeting status
            }
            zoom.startMeeting(meetingOptions).then((loginResult) {
                print("[LoginResult] :- " + loginResult[0] + " - " + loginResult[1]);
                if(loginResult[0] == "SDK ERROR"){
                    //SDK INIT FAILED
                    print((loginResult[1]).toString());
                }else if(loginResult[0] == "LOGIN ERROR"){
                    //LOGIN FAILED - WITH ERROR CODES
                    print((loginResult[1]).toString());
                }else{
                    //LOGIN SUCCESS & MEETING STARTED - WITH SUCCESS CODE 200
                    print((loginResult[0]).toString());
                }
            });
        }
    }

```
