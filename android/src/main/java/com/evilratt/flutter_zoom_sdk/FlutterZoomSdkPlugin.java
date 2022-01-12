package com.evilratt.flutter_zoom_sdk;

import android.content.Context;
import android.content.Intent;
import android.util.Log;
import androidx.annotation.NonNull;
import java.util.Arrays;
import java.util.List;
import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import us.zoom.sdk.CustomizedNotificationData;
import us.zoom.sdk.InMeetingNotificationHandle;
import us.zoom.sdk.InMeetingService;
import us.zoom.sdk.JoinMeetingOptions;
import us.zoom.sdk.JoinMeetingParams;
import us.zoom.sdk.MeetingService;
import us.zoom.sdk.MeetingStatus;
import us.zoom.sdk.MeetingViewsOptions;
import us.zoom.sdk.StartMeetingOptions;
import us.zoom.sdk.StartMeetingParams4NormalUser;
import us.zoom.sdk.ZoomAuthenticationError;
import us.zoom.sdk.ZoomError;
import us.zoom.sdk.ZoomSDK;
import us.zoom.sdk.ZoomSDKAuthenticationListener;
import us.zoom.sdk.ZoomSDKInitParams;
import us.zoom.sdk.ZoomSDKInitializeListener;

/** FlutterZoomPlugin */
public class FlutterZoomSdkPlugin implements FlutterPlugin, MethodChannel.MethodCallHandler, ActivityAware {

  private MethodChannel methodChannel;
  private Context context;
  private EventChannel meetingStatusChannel;
  private InMeetingService inMeetingService;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    context = flutterPluginBinding.getApplicationContext();
    methodChannel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "com.evilratt/zoom_sdk");
    methodChannel.setMethodCallHandler(this);

    meetingStatusChannel = new EventChannel(flutterPluginBinding.getBinaryMessenger(), "com.evilratt/zoom_sdk_event_stream");
  }

  @Override
  public void onMethodCall(@NonNull MethodCall methodCall, @NonNull MethodChannel.Result result) {
    switch (methodCall.method) {
      case "init":
        init(methodCall, result);
        break;
      case "login":
        login(methodCall, result);
        break;
      case "logout":
        logout();
        break;
      case "join":
        joinMeeting(methodCall, result);
        break;
      case "startNormal":
        startMeetingNormal(methodCall, result);
        break;
      case "meeting_status":
        meetingStatus(result);
        break;
      case "meeting_details":
        meetingDetails(result);
        break;
      default:
        result.notImplemented();
    }

  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    methodChannel.setMethodCallHandler(null);
  }

  private void init(final MethodCall methodCall, final MethodChannel.Result result) {

    Map<String, String> options = methodCall.arguments();

    ZoomSDK zoomSDK = ZoomSDK.getInstance();

    if(zoomSDK.isInitialized()) {
      List<Integer> response = Arrays.asList(0, 0);
      result.success(response);
      return;
    }

    ZoomSDKInitParams initParams = new ZoomSDKInitParams();
    initParams.appKey = options.get("appKey");
    initParams.appSecret = options.get("appSecret");
    initParams.domain = options.get("domain");
    initParams.enableLog = true;

    final InMeetingNotificationHandle handle=new InMeetingNotificationHandle() {

      @Override
      public boolean handleReturnToConfNotify(Context context, Intent intent) {
        intent = new Intent(context, FlutterZoomSdkPlugin.class);
        intent.addFlags(Intent.FLAG_ACTIVITY_REORDER_TO_FRONT);
        if(context == null) {
          intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        }
        intent.setAction(InMeetingNotificationHandle.ACTION_RETURN_TO_CONF);
        assert context != null;
        context.startActivity(intent);
        return true;
      }
    };


    final CustomizedNotificationData data = new CustomizedNotificationData();
    data.setContentTitleId(R.string.app_name_zoom_local);
    data.setLargeIconId(R.drawable.zm_mm_type_emoji);
    data.setSmallIconId(R.drawable.zm_mm_type_emoji);
    data.setSmallIconForLorLaterId(R.drawable.zm_mm_type_emoji);

    ZoomSDKInitializeListener listener = new ZoomSDKInitializeListener() {
      /**
       * @param errorCode {@link us.zoom.sdk.ZoomError#ZOOM_ERROR_SUCCESS} if the SDK has been initialized successfully.
       */
      @Override
      public void onZoomSDKInitializeResult(int errorCode, int internalErrorCode) {
        List<Integer> response = Arrays.asList(errorCode, internalErrorCode);

        if (errorCode != ZoomError.ZOOM_ERROR_SUCCESS) {
          System.out.println("Failed to initialize Zoom SDK");
          result.success(response);
          return;
        }

        ZoomSDK zoomSDK = ZoomSDK.getInstance();
        ZoomSDK.getInstance().getMeetingSettingsHelper().enableShowMyMeetingElapseTime(true);
        ZoomSDK.getInstance().getMeetingSettingsHelper().setCustomizedNotificationData(data, handle);

        MeetingService meetingService = zoomSDK.getMeetingService();
        meetingStatusChannel.setStreamHandler(new StatusStreamHandler(meetingService));
        result.success(response);
      }

      @Override
      public void onZoomAuthIdentityExpired() { }
    };
    zoomSDK.initialize(context, listener, initParams);
  }

  private void login(final MethodCall methodCall, final MethodChannel.Result result){
    Map<String, String> options = methodCall.arguments();

    ZoomSDK zoomSDK = ZoomSDK.getInstance();

    if(!zoomSDK.isInitialized()) {
      System.out.println("Not initialized!!!!!!");
      result.success(Arrays.asList("SDK ERROR", "001"));
      return;
    }

    if(zoomSDK.isLoggedIn()){
      startMeeting(methodCall, result);
    }

    ZoomSDKAuthenticationListener authenticationListener = new ZoomSDKAuthenticationListener() {

      @Override
      public void onZoomSDKLoginResult(long results) {
        Log.d("Zoom Flutter", String.format("[onLoginError] : %s", results));
        if (results == ZoomAuthenticationError.ZOOM_AUTH_ERROR_SUCCESS) {
          //Once we verify that the request was successful, we may start the meeting
          startMeeting(methodCall, result);
        }else{
          result.success(Arrays.asList("LOGIN ERROR", String.valueOf(results)));
        }
      }

      @Override
      public void onZoomSDKLogoutResult(long l) {

      }

      @Override
      public void onZoomIdentityExpired() {

      }

      @Override
      public void onZoomAuthIdentityExpired() {

      }
    };
    if(!zoomSDK.isLoggedIn()){
      zoomSDK.loginWithZoom(options.get("userId"), options.get("userPassword"));
      zoomSDK.addAuthenticationListener(authenticationListener);
    }
  }


  private void joinMeeting(MethodCall methodCall, MethodChannel.Result result) {

    Map<String, String> options = methodCall.arguments();

    ZoomSDK zoomSDK = ZoomSDK.getInstance();

    if(!zoomSDK.isInitialized()) {
      System.out.println("Not initialized!!!!!!");
      result.success(false);
      return;
    }

    MeetingService meetingService = zoomSDK.getMeetingService();

    JoinMeetingOptions opts = new JoinMeetingOptions();
    opts.no_invite = parseBoolean(options, "disableInvite");
    opts.no_share = parseBoolean(options, "disableShare");
    opts.no_titlebar =  parseBoolean(options, "disableTitlebar");
    opts.no_driving_mode = parseBoolean(options, "disableDrive");
    opts.no_dial_in_via_phone = parseBoolean(options, "disableDialIn");
    opts.no_disconnect_audio = parseBoolean(options, "noDisconnectAudio");
    opts.no_audio = parseBoolean(options, "noAudio");
    boolean view_options = parseBoolean(options, "viewOptions");
    if(view_options){
      opts.meeting_views_options = MeetingViewsOptions.NO_TEXT_MEETING_ID + MeetingViewsOptions.NO_TEXT_PASSWORD;
    }

    JoinMeetingParams params = new JoinMeetingParams();

    params.displayName = options.get("userId");
    params.meetingNo = options.get("meetingId");
    params.password = options.get("meetingPassword");

    meetingService.joinMeetingWithParams(context, params, opts);

    result.success(true);
  }

  private void startMeeting(MethodCall methodCall, MethodChannel.Result result) {

    Map<String, String> options = methodCall.arguments();

    ZoomSDK zoomSDK = ZoomSDK.getInstance();

    if(!zoomSDK.isInitialized()) {
      System.out.println("Not initialized!!!!!!");
      result.success(Arrays.asList("SDK ERROR", "001"));
      return;
    }

    if(zoomSDK.isLoggedIn()){
      MeetingService meetingService = zoomSDK.getMeetingService();
      StartMeetingOptions opts= new StartMeetingOptions();
      opts.no_invite = parseBoolean(options, "disableInvite");
      opts.no_share = parseBoolean(options, "disableShare");
      opts.no_driving_mode = parseBoolean(options, "disableDrive");
      opts.no_dial_in_via_phone = parseBoolean(options, "disableDialIn");
      opts.no_disconnect_audio = parseBoolean(options, "noDisconnectAudio");
      opts.no_audio = parseBoolean(options, "noAudio");
      opts.no_titlebar = parseBoolean(options, "disableTitlebar");
      boolean view_options = parseBoolean(options, "viewOptions");
      if(view_options){
        opts.meeting_views_options = MeetingViewsOptions.NO_TEXT_MEETING_ID + MeetingViewsOptions.NO_TEXT_PASSWORD;
      }

      meetingService.startInstantMeeting(context, opts);
      inMeetingService = zoomSDK.getInMeetingService();
      result.success(Arrays.asList("MEETING SUCCESS", "200"));
    }else{
      System.out.println("Not LoggedIn!!!!!!");
      result.success(Arrays.asList("LOGIN REQUIRED", "001"));
      return;
    }
  }

  private void startMeetingNormal(final MethodCall methodCall, final MethodChannel.Result result) {

    Map<String, String> options = methodCall.arguments();

    ZoomSDK zoomSDK = ZoomSDK.getInstance();

    if(!zoomSDK.isInitialized()) {
      System.out.println("Not initialized!!!!!!");
      result.success(Arrays.asList("SDK ERROR", "001"));
      return;
    }

    if(zoomSDK.isLoggedIn()){
      startMeetingNormalInternal(methodCall, result);
    }

    ZoomSDKAuthenticationListener authenticationListener = new ZoomSDKAuthenticationListener() {

      @Override
      public void onZoomSDKLoginResult(long results) {
        Log.d("Zoom Flutter", String.format("[onLoginError] : %s", results));
        if (results == ZoomAuthenticationError.ZOOM_AUTH_ERROR_SUCCESS) {
          //Once we verify that the request was successful, we may start the meeting
          startMeetingNormalInternal(methodCall, result);
        }else{
          result.success(Arrays.asList("LOGIN ERROR", String.valueOf(results)));
        }
      }

      @Override
      public void onZoomSDKLogoutResult(long l) {

      }

      @Override
      public void onZoomIdentityExpired() {

      }

      @Override
      public void onZoomAuthIdentityExpired() {

      }
    };

    if(!zoomSDK.isLoggedIn()){
      zoomSDK.loginWithZoom(options.get("userId"), options.get("userPassword"));
      zoomSDK.addAuthenticationListener(authenticationListener);
    }
  }

  private void startMeetingNormalInternal(MethodCall methodCall, MethodChannel.Result result) {
    Map<String, String> options = methodCall.arguments();

    ZoomSDK zoomSDK = ZoomSDK.getInstance();

    if(!zoomSDK.isInitialized()) {
      System.out.println("Not initialized!!!!!!");
      result.success(Arrays.asList("SDK ERROR", "001"));
      return;
    }

    if(zoomSDK.isLoggedIn()) {
      MeetingService meetingService = zoomSDK.getMeetingService();
      StartMeetingOptions opts = new StartMeetingOptions();
      opts.no_invite = parseBoolean(options, "disableInvite");
      opts.no_share = parseBoolean(options, "disableShare");
      opts.no_driving_mode = parseBoolean(options, "disableDrive");
      opts.no_dial_in_via_phone = parseBoolean(options, "disableDialIn");
      opts.no_disconnect_audio = parseBoolean(options, "noDisconnectAudio");
      opts.no_audio = parseBoolean(options, "noAudio");
      opts.no_titlebar = parseBoolean(options, "disableTitlebar");
      boolean view_options = parseBoolean(options, "viewOptions");
      if (view_options) {
        opts.meeting_views_options = MeetingViewsOptions.NO_TEXT_MEETING_ID + MeetingViewsOptions.NO_TEXT_PASSWORD;
      }

      StartMeetingParams4NormalUser params = new StartMeetingParams4NormalUser();
      Log.d("Zooom Flutter SDk", String.format("[Zoom MeetingID]: %s ", options.get("meetingId")));
      params.meetingNo = options.get("meetingId");

      meetingService.startMeetingWithParams(context, params, opts);
      inMeetingService = zoomSDK.getInMeetingService();
      result.success(Arrays.asList("MEETING SUCCESS", "200"));
    }
  }

  private boolean parseBoolean(Map<String, String> options, String property) {
    return options.get(property) != null && Boolean.parseBoolean(options.get(property));
  }

  private void meetingDetails(MethodChannel.Result result)  {
    ZoomSDK zoomSDK = ZoomSDK.getInstance();

    if(!zoomSDK.isInitialized()) {
      System.out.println("Not initialized!!!!!!");
      result.success(Arrays.asList("MEETING_STATUS_UNKNOWN", "SDK not initialized"));
      return;
    }
    MeetingService meetingService = zoomSDK.getMeetingService();

    if(meetingService == null) {
      result.success(Arrays.asList("MEETING_STATUS_UNKNOWN", "No status available"));
      return;
    }
    MeetingStatus status = meetingService.getMeetingStatus();

    result.success(status != null ? Arrays.asList(inMeetingService.getCurrentMeetingNumber(), inMeetingService.getMeetingPassword()) :  Arrays.asList("MEETING_STATUS_UNKNOWN", "No status available"));
  }

  private void meetingStatus(MethodChannel.Result result) {

    ZoomSDK zoomSDK = ZoomSDK.getInstance();

    if(!zoomSDK.isInitialized()) {
      System.out.println("Not initialized!!!!!!");
      result.success(Arrays.asList("MEETING_STATUS_UNKNOWN", "SDK not initialized"));
      return;
    }
    MeetingService meetingService = zoomSDK.getMeetingService();

    if(meetingService == null) {
      result.success(Arrays.asList("MEETING_STATUS_UNKNOWN", "No status available"));
      return;
    }

    MeetingStatus status = meetingService.getMeetingStatus();
    result.success(status != null ? Arrays.asList(status.name(), "") :  Arrays.asList("MEETING_STATUS_UNKNOWN", "No status available"));
  }

  public void logout() {
    ZoomSDK zoomSDK = ZoomSDK.getInstance();
    zoomSDK.logoutZoom();
  }

  @Override
  public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {

  }

  @Override
  public void onDetachedFromActivityForConfigChanges() {

  }

  @Override
  public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {

  }

  @Override
  public void onDetachedFromActivity() {

  }
}
