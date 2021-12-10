
class ZoomOptions {

  String? domain;
  String? appKey;
  String? appSecret;

  ZoomOptions({
    this.domain,
    this.appKey,
    this.appSecret,
  });
}

class ZoomMeetingOptions {

  String? userId;
  String? userPassword;
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
    this.userPassword,
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
