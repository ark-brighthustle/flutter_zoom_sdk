@JS()
library zoom;

import 'dart:js';

import 'package:js/js.dart';

@JS()
@anonymous // needed along with factory constructor
class InitParams {
  external factory InitParams(
      {leaveUrl,
        showMeetingHeader,
        disableInvite,
        disableCallOut,
        disableRecord,
        disableJoinAudio,
        audioPanelAlwaysOpen,
        isSupportAV,
        isSupportChat,
        isSupportQA,
        isSupportCC,
        isSupportPolling,
        isSupportBreakout,
        screenShare,
        rwcBackup,
        videoDrag,
        sharingMode,
        videoHeader,
        isLockBottom,
        isSupportNonverbal,
        isShowJoiningErrorDialog,
        disablePreview,
        disableCORP,
        inviteUrlFormat,
        disableVoIP,
        disableReport,
        meetingInfo,
        success,
        error});
  external String get leaveUrl;
}

@JS()
@anonymous // needed along with factory constructor
class JoinParams {
  external factory JoinParams(
      {meetingNumber, userName, signature, apiKey, passWord, success, error});
}

@JS()
@anonymous // needed along with factory constructor
class SignatureParams {
  external factory SignatureParams({meetingNumber, apiKey, apiSecret, role});
}

@JS()
@anonymous
class MeetingStatus {
  external factory MeetingStatus({int meetingStatus});
  external int get meetingStatus;
}

@JS()
class ZoomMtg {
  external static void setZoomJSLib(String path, String dir);
  external static final i18n;
  external static void preLoadWasm();
  external static void prepareWebSDK();
  external static void prepareJssdk();
  external static void init(InitParams initParams);
  external static void join(JoinParams joinParams);
  external static String generateSignature(SignatureParams signatureParams);
  external static dynamic checkSystemRequirements();
  external static void inMeetingServiceListener(
      String event, Function(MeetingStatus) callback);
}
