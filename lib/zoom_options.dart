
class ZoomOptions {

  String domain;
  String appKey;
  String appSecret;
  String jwtToken;

  ZoomOptions({
    this.domain,
    this.appKey,
    this.appSecret,
    this.jwtToken
  });
}

class ZoomMeetingOptions {

  String userId;
  String displayName;
  String meetingId;
  String meetingPassword;
  String disableDialIn;
  String disableDrive;
  String disableInvite;
  String disableShare;
  String disableTitlebar;
  String noDisconnectAudio;
  String viewOptions;
  String noAudio;

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
    this.noAudio
  });
}
