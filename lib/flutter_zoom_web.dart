import 'dart:async';
import 'dart:convert';
import 'dart:js';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:flutter_zoom_sdk/webSupport/zoom_js.dart';
import 'package:flutter_zoom_sdk/zoom_platform_view.dart';

import 'webSupport/js_interop.dart';
export 'package:flutter_zoom_sdk/zoom_platform_view.dart'
    show ZoomOptions, ZoomMeetingOptions;

/// Web Function For Zoom Sdk for Flutter Web Implementation
class ZoomViewWeb extends ZoomPlatform {
  StreamController<dynamic>? streamController;

  static void registerWith(Registrar registrar) {
    ZoomPlatform.instance = ZoomViewWeb();
  }

  /// Initialize Zoom SDK For Web
  @override
  Future<List> initZoom(ZoomOptions options) async {
    final Completer<List> completer = Completer();
    var sus = ZoomMtg.checkSystemRequirements();
    var susmap = convertToDart(sus);
    if (kDebugMode) {
      print(susmap);
    }

    ZoomMtg.i18n.load(options.language);
    ZoomMtg.preLoadWasm();
    ZoomMtg.prepareWebSDK();
    ZoomMtg.init(InitParams(
        leaveUrl: "/index.html",
        showMeetingHeader: options.showMeetingHeader,
        disableInvite: options.disableInvite,
        disableCallOut: options.disableCallOut,
        disableRecord: options.disableRecord,
        disableJoinAudio: options.disableJoinAudio,
        audioPanelAlwaysOpen: options.audioPanelAlwaysOpen,
        isSupportAV: options.isSupportAV,
        isSupportChat: options.isSupportChat,
        isSupportQA: options.isSupportQA,
        isSupportCC: options.isSupportCC,
        isSupportPolling: options.isSupportPolling,
        isSupportBreakout: options.isSupportBreakout,
        screenShare: options.screenShare,
        rwcBackup: options.rwcBackup,
        videoDrag: options.videoDrag,
        sharingMode: options.sharingMode,
        videoHeader: options.videoHeader,
        isLockBottom: options.isLockBottom,
        isSupportNonverbal: options.isSupportNonverbal,
        isShowJoiningErrorDialog: options.isShowJoiningErrorDialog,
        disablePreview: options.disablePreview,
        disableCORP: options.disableCORP,
        inviteUrlFormat: options.inviteUrlFormat,
        disableVoIP: options.disableVOIP,
        disableReport: options.disableReport,
        meetingInfo: options.meetingInfo,
        success: allowInterop((var res) {
          completer.complete([0, 0]);
        }),
        error: allowInterop((var res) {
          completer.complete([1, 0]);
        })));
    return completer.future;
  }

  /// Generate Signatue for zoom signate required to perform join and start functions
  String generateSignature(
      String apiKey, String apiSecret, String meetingNumber, int role) {
    final timestamp = DateTime.now().millisecondsSinceEpoch - 30000;
    var str = '$apiKey$meetingNumber$timestamp$role';
    var bytes = utf8.encode(str);
    final msg = base64.encode(bytes);

    final key = utf8.encode(apiSecret);
    final hmacSha256 = Hmac(sha256, key); // HMAC-SHA256
    final digest = hmacSha256.convert(utf8.encode(msg));
    final hash = base64.encode(digest.bytes);

    str = '$apiKey.$meetingNumber.$timestamp.$role.$hash';
    bytes = utf8.encode(str);
    final signature = base64.encode(bytes);
    return signature.replaceAll(RegExp("="), "");
  }

  /// Start Meeting Function for Zoom Web
  @override
  Future<List> startMeeting(ZoomMeetingOptions options) async {
    final Completer<List> completer = Completer();
    ZoomMtg.join(JoinParams(
        meetingNumber: options.meetingId,
        userName: options.displayName ?? options.userId,
        signature: options.jwtSignature!,
        apiKey: options.jwtAPIKey!,
        passWord: options.meetingPassword,
        success: allowInterop((var res) {
          completer.complete(["MEETING STATUS", "SUCCESS"]);
        }),
        error: allowInterop((var res) {
          completer.complete(["MEETING STATUS", "FAILED"]);
        })));
    return completer.future;
  }

  /// Join Meeting Function for Zoom Web
  @override
  Future<bool> joinMeeting(ZoomMeetingOptions options) async {
    final Completer<bool> completer = Completer();
    ZoomMtg.join(JoinParams(
        meetingNumber: options.meetingId,
        userName: options.displayName ?? options.userId,
        signature: options.jwtSignature!,
        apiKey: options.jwtAPIKey!,
        passWord: options.meetingPassword,
        success: allowInterop((var res) {
          completer.complete(true);
        }),
        error: allowInterop((var res) {
          completer.complete(false);
        })));
    return completer.future;
  }

  /// Listen to Ongoing Meeting Function for Zoom Web
  @override
  Future<List> meetingStatus(String meetingId) async {
    return ["a", "b"];
  }

  /// Meeting Status Response Function for Zoom Web
  @override
  Stream<dynamic> onMeetingStatus() {
    streamController?.close();
    streamController = StreamController<dynamic>();
    ZoomMtg.inMeetingServiceListener('onMeetingStatus', allowInterop((status) {
      var r = List<String>.filled(2, "");

      /// 1(connecting), 2(connected), 3(disconnected), 4(reconnecting)
      switch (status.meetingStatus) {
        case 1:
          r[0] = "MEETING_STATUS_CONNECTING";
          break;
        case 2:
          r[0] = "MEETING_STATUS_INMEETING";
          break;
        case 3:
          r[0] = "MEETING_STATUS_DISCONNECTING";
          break;
        case 4:
          r[0] = "MEETING_STATUS_INMEETING";
          break;
        default:
          r[0] = status.meetingStatus.toString();
          break;
      }
      streamController!.add(r);
    }));
    return streamController!.stream;
  }
}
