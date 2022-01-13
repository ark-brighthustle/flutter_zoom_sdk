
import 'dart:async';
import 'package:flutter_zoom_sdk/zoom_options.dart';
import 'package:flutter_zoom_sdk/zoom_view.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
export 'zoom_options.dart';

abstract class ZoomPlatform extends PlatformInterface {
  ZoomPlatform() : super(token: _token);
  static final Object _token = Object();
  static ZoomPlatform _instance = ZoomView();
  static ZoomPlatform get instance => _instance;
  static set instance(ZoomPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }
  Future<List> initZoom(ZoomOptions options) async {
    throw UnimplementedError('initZoom() has not been implemented.');
  }

  Future<List> startMeeting(ZoomMeetingOptions options) async {
    throw UnimplementedError('startMeetingLogin() has not been implemented.');
  }

  Future<List> startMeetingNormal(ZoomMeetingOptions options) async {
    throw UnimplementedError('startMeetingNormal() has not been implemented.');
  }

  Future<bool> joinMeeting(ZoomMeetingOptions options) async {
    throw UnimplementedError('joinMeeting() has not been implemented.');
  }

  Future<List> meetingStatus(String meetingId) async {
    throw UnimplementedError('meetingStatus() has not been implemented.');
  }

  Stream<dynamic> onMeetingStatus(){
    throw UnimplementedError('onMeetingStatus() has not been implemented.');
  }

  Future<List> meetinDetails() async{
    throw UnimplementedError('meetingDetails() has not been implemented.');
  }
}