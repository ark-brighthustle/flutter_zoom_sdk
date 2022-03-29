# Flutter Zoom SDK

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[![pub package](https://img.shields.io/badge/pub-v1.1.0%2B4-brightgreen)](https://pub.dev/packages/flutter_zoom_sdk)

A Flutter plugin for the Zoom SDK With all features and null safety support.

*Note*: This plugin is still under active development, and some Zoom features might not be available yet. We are working to add more features.
Feedback, Pull Requests are always welcome.

*Note*: For Android and iOS Build import.
```shell script
import 'package:flutter_zoom_sdk/zoom_options.dart';
```

*Note*: For Web Build import.
```shell script
import 'package:flutter_zoom_sdk/flutter_zoom_web.dart';
```

## Features

- [x] Updated Zoom SDK to latest.
- [x] Null Safety.
- [x] Stream meeting status.
- [x] Join meeting.
- [x] Start an instant meeting for Login user.
- [x] Start an meeting for Login user with Meeeting ID.
- [x] Login Error with proper Error codes.
- [x] Hide Title bar or Hide Meeting info (Useful for e-learning platform).
- [x] Change Meeting Notification App Name & Zoom Notification Icon Removed.
- [x] iOS Support.
- [x] Web Support.

## Zoom SDK Versions

*Note*: Updated to new sdk with new features.

## Installation

First, add `flutter_zoom_sdk: ^1.1.0+4` as a [dependency in your pubspec.yaml file](https://flutter.io/using-packages/).

After running pub get, you must run the follow script to get Zoom SDK for the first time:
```shell script
flutter pub run flutter_zoom_sdk:unzip_zoom_sdk
```

### iOS

*Note*: correct login ID and Password needed at first attempt or need to reload app.
*Note*: There is no error message for login failure like android.

Add two rows to the `ios/Runner/Info.plist`:

- one with the key `Privacy - Camera Usage Description` and a usage description.
- and one with the key `Privacy - Microphone Usage Description` and a usage description.

Or in text format add the key:

```xml
<key>NSCameraUsageDescription</key>
<string>Need to use the camera for call</string>
<key>NSMicrophoneUsageDescription</key>
<string>Need to use the microphone for call</string>
```


Disable BITCODE in the `ios/Podfile`:

```
post_install do |installer|
  installer.pods_project.targets.each do |target|
    flutter_additional_ios_build_settings(target)
    target.build_configurations.each do |config|
      config.build_settings['ENABLE_BITCODE'] = 'NO'
    end
  end
end
```

**NOTE for testing on the iOS simulator**

If you want to use the iOS Simulator to test your app, you will need to ensure you have the iOS Dev Zoom SDK as a dependency.

To use the Dev Zoom SDK, run the following
```shell script
flutter pub run flutter_zoom_sdk:unzip_zoom_sdk dev
```

To switch back to the normal Zoom SDK, simply run

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
**NOTE ZoomError class has all the codes for comparison**

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

### Web

**NOTE for using on Web**

You cannot get meeting ID and Password after start meeting
Only user whose JWT credentials is provided inside the app can start the meeting

Add stylesheet to the head of index.html
```html
<link type="text/css" rel="stylesheet" href="https://source.zoom.us/1.9.9/css/bootstrap.css" />
<link type="text/css" rel="stylesheet" href="https://source.zoom.us/1.9.9/css/react-select.css" />
```
Import ZoomMtg dependencies to the body of index.html
```html
<!-- import ZoomMtg dependencies -->
   <script src="https://source.zoom.us/1.9.9/lib/vendor/react.min.js"></script>
   <script src="https://source.zoom.us/1.9.9/lib/vendor/react-dom.min.js"></script>
   <script src="https://source.zoom.us/1.9.9/lib/vendor/redux.min.js"></script>
   <script src="https://source.zoom.us/1.9.9/lib/vendor/redux-thunk.min.js"></script>
   <script src="https://source.zoom.us/1.9.9/lib/vendor/lodash.min.js"></script>
   <script src="https://source.zoom.us/1.9.9/lib/av/1502_js_media.min.js"></script>

   <!-- import ZoomMtg -->
   <script src="https://source.zoom.us/zoom-meeting-1.9.9.min.js"></script>

   <script src="main.dart.js" type="application/javascript"></script>
```
You need to obtain the User Token and Zoom Access Token (ZAK) in order to start meetings for a web user. They are unique authentication tokens required to host a meeting on behalf of another user.

Example of getting User Token and ZAK [here](https://marketplace.zoom.us/docs/sdk/native-sdks/android/mastering-zoom-sdk/start-join-meeting/api-user/authentication)

More info about the User Token and Zoom Access Token [here](https://marketplace.zoom.us/docs/sdk/native-sdks/credentials).

To get personal meeting id and passcode follow https://zoom.us/meeting#/ and navigate to Personal Room tab

## Examples

### Meeting status

There are 2 ways to obtains the Zoom meeting status
- Listen to Zoom Status Event stream, or
- Polling the Zoom status using a `Timer`


The plugin emits the following Zoom meeting events:

For iOS:
- `MEETING_STATUS_IDLE`
- `MEETING_STATUS_CONNECTING`
- `MEETING_STATUS_INMEETING`
- `MEETING_STATUS_WEBINAR_PROMOTE`
- `MEETING_STATUS_WEBINAR_DEPROMOTE`
- `MEETING_STATUS_UNKNOWN`

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
        appKey: "", //API KEY FROM ZOOM - Sdk API Key
        appSecret: "", //API SECRET FROM ZOOM - Sdk API Secret
      );
      var meetingOptions = new ZoomMeetingOptions(
          userId: 'username', //pass username for join meeting only --- Any name eg:- EVILRATT.
          meetingId: '', //pass meeting id for join meeting only
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

### Join Meeting - For Web (JWT Required)

1. Pass the Jwt API Key as api key for web & Jwt API Secret as appSecret
2. Role must be passed as 0 inside generateSignature for join a meeting

```dart
joinMeetingWeb(BuildContext context) {
      ZoomOptions zoomOptions = new ZoomOptions(
        domain: "zoom.us",
        appKey: "", //API KEY FROM ZOOM - Jwt API Key
        appSecret: "", //API SECRET FROM ZOOM - Jwt API Secret
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
        ]
      );
      var meetingOptions = new ZoomMeetingOptions(
          userId: 'username', //pass username for join meeting only --- Any name eg:- EVILRATT.
          meetingId: meetingIdController.text, //Personal meeting id for start meeting required
          meetingPassword: meetingPasswordController.text, //Personal meeting passcode for start meeting required
          //To get personal meeting id and passcode follow https://zoom.us/meeting#/ and novigate to Personal Room tab
      );

      var zoom = ZoomViewWeb();
      zoom.initZoom(zoomOptions).then((results) {
        if(results[0] == 0) {
          var zr = window.document.getElementById("zmmtg-root");
          querySelector('body')?.append(zr!);
          zoom.onMeetingStatus().listen((status) {
            print("[Meeting Status Stream] : " + status[0] + " - " + status[1]);
          });
          final signature = zoom.generateSignature(zoomOptions.appKey.toString(), zoomOptions.appSecret.toString(), meetingIdController.text, 0);
          meetingOptions.jwtAPIKey = zoomOptions.appKey.toString();
          meetingOptions.jwtSignature = signature;
          zoom.joinMeeting(meetingOptions).then((joinMeetingResult) {
            print("[Meeting Status Polling] : " + joinMeetingResult[0] + " - " + joinMeetingResult[1]);
          });
        }
      }).catchError((error) {
        print("[Error Generated] : " + error);
      });
  }
```

### Start a Meeting - For Web (JWT Required)

1. Pass the Jwt API Key as api key for web & Jwt API Secret as appSecret
2. Role must be passed as 1 inside generateSignature for start a meeting
3. Pass your Personal meeting ID and Passcode to staty the meeting (Meeeting ID and Passcode must belong to same user account as JWT credentials)

```dart
startMeetingWeb(BuildContext context) {
    ZoomOptions zoomOptions = new ZoomOptions(
        domain: "zoom.us",
        appKey: "", //API KEY FROM ZOOM - Jwt API Key
        appSecret: "", //API SECRET FROM ZOOM - Jwt API Secret
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
            ]
        );
    var meetingOptions = new ZoomMeetingOptions(
        userId: '', //pass host username for zoom
        meetingId: meetingIdController.text, //Personal meeting id for start meeting required
        meetingPassword: meetingPasswordController.text, //Personal meeting passcode for start meeting required
        //To get personal meeting id and passcode follow https://zoom.us/meeting#/ and navigate to Personal Room tab
    );

    var zoom = ZoomViewWeb();
    zoom.initZoom(zoomOptions).then((results) {
      if(results[0] == 0) {
        var zr = window.document.getElementById("zmmtg-root");
        querySelector('body')?.append(zr!);
        zoom.onMeetingStatus().listen((status) {
          print("[Meeting Status Stream] : " + status[0] + " - " + status[1]);
        });
        final signature = zoom.generateSignature(zoomOptions.appKey.toString(), zoomOptions.appSecret.toString(), meetingIdController.text, 1);
        meetingOptions.jwtAPIKey = zoomOptions.appKey.toString();
        meetingOptions.jwtSignature = signature;
        zoom.startMeeting(meetingOptions).then((startMeetingResult) {
          print("[Meeting Status Polling] : " + startMeetingResult[0] + " - " + startMeetingResult[1]);
        });
      }
    }).catchError((error) {
      print("[Error Generated] : " + error);
    });
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
      appKey: "", //API KEY FROM ZOOM - Sdk API Key
      appSecret: "", //API SECRET FROM ZOOM - Sdk API Secret
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
            if (loginResult[1] ==
                ZoomError.ZOOM_AUTH_ERROR_WRONG_ACCOUNTLOCKED) {
              print("Multiple Failed Login Attempts");
            }
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

### ZoomView(onViewCreated: (controller) {}) --- Replaced with

```
     var zoom = ZoomView();
     // Initializing Zoom SDK
     zoom.initZoom(zoomOptions).then((results) {}

```
### controller.zoomStatusEvents.listen((status) {}) -- Replaced With

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
    controller.login(this.widget.loginOptions).then((loginResult) {})

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
