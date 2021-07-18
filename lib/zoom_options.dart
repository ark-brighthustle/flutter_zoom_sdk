
class ZoomOptions {

  String? domain;
  String? appKey;
  String? appSecret;
  String? jwtToken;

  ZoomOptions({
    this.domain,
    this.appKey,
    this.appSecret,
    this.jwtToken
  });
}

class ZoomMeetingOptions {

  String? userId;
  String? displayName;
  String? meetingId;
  String? meetingPassword;
  String? disableDialIn;
  String? disableDrive;
  String? disableInvite;
  String? disableShare;
  String? disableTitlebar;
  String? noDisconnectAudio;
  String? viewOptions;
  String? noAudio;
  String? jwtAPIKey;//--for web
  String? jwtSignature;//--for web

  ZoomMeetingOptions({
    this.userId,
    this.displayName,
    this.meetingId,
    this.meetingPassword,
    this.disableDialIn,
    this.disableDrive,
    this.disableInvite,
    this.disableShare,
    this.disableTitlebar,
    this.noDisconnectAudio,
    this.viewOptions,
    this.noAudio,
    this.jwtAPIKey,
    this.jwtSignature,
  });
}

class ZoomScheduleOptions {
  String? setMeetingTopic;
  String? setStartTime;
  String? durationMinute;
  String? canJoinBeforeHost;
  String? setPassword;
  String? setHostVideoOff;
  String? setAttendeeVideoOff;
  String? setTimeZoneId;
  String? setEnableMeetingToPublic;
  String? setEnableLanguageInterpretation;
  String? setEnableWaitingRoom;
  String? setUsePmiAsMeetingID;
  String? enableAutoRecord;
  String? autoLocalRecord;
  String? autoCloudRecord;

  ZoomScheduleOptions({
    this.setMeetingTopic,
    this.setStartTime,
    this.durationMinute,
    this.canJoinBeforeHost,
    this.setPassword,
    this.setHostVideoOff,
    this.setAttendeeVideoOff,
    this.setTimeZoneId,
    this.setEnableMeetingToPublic,
    this.setEnableLanguageInterpretation,
    this.setEnableWaitingRoom,
    this.setUsePmiAsMeetingID,
    this.enableAutoRecord,
    this.autoLocalRecord,
    this.autoCloudRecord
  });
}
