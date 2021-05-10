package com.evilratt.flutter_zoom_sdk;

import android.content.Context;
import android.view.View;
import android.widget.TextView;

import java.util.Arrays;
import java.util.List;
import java.util.Map;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.platform.PlatformView;
import us.zoom.sdk.JoinMeetingOptions;
import us.zoom.sdk.JoinMeetingParams;
import us.zoom.sdk.MeetingViewsOptions;
import us.zoom.sdk.StartMeetingOptions;
import us.zoom.sdk.MeetingService;
import us.zoom.sdk.MeetingStatus;
import us.zoom.sdk.ZoomError;
import us.zoom.sdk.ZoomSDK;
import us.zoom.sdk.ZoomApiError;
import us.zoom.sdk.ZoomSDKAuthenticationListener;
import us.zoom.sdk.ZoomSDKInitParams;
import us.zoom.sdk.ZoomSDKInitializeListener;

public class ZoomView  implements PlatformView,
        MethodChannel.MethodCallHandler,
        ZoomSDKAuthenticationListener {
    private final TextView textView;
    private final MethodChannel methodChannel;
    private final Context context;
    private final EventChannel meetingStatusChannel;

    ZoomView(Context context, BinaryMessenger messenger, int id) {
        textView = new TextView(context);
        this.context = context;

        methodChannel = new MethodChannel(messenger, "com.evilratt/flutter_zoom_sdk");
        methodChannel.setMethodCallHandler(this);

        meetingStatusChannel = new EventChannel(messenger, "com.evilratt/zoom_event_stream");
    }

    @Override
    public View getView() {
        return textView;
    }

    @Override
    public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
        switch (methodCall.method) {
            case "init":
                init(methodCall, result);
                break;
            case "join":
                joinMeeting(methodCall, result);
                break;
            case "start":
                startMeeting(methodCall, result);
                break;
            case "meeting_status":
                meetingStatus(result);
                break;
            default:
                result.notImplemented();
        }

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
                MeetingService meetingService = zoomSDK.getMeetingService();
                meetingStatusChannel.setStreamHandler(new StatusStreamHandler(meetingService));
                result.success(response);
            }

            @Override
            public void onZoomAuthIdentityExpired() { }
        };
        zoomSDK.initialize(context, listener, initParams);
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
        opts.no_invite = parseBoolean(options, "disableInvite", false);
        opts.no_share = parseBoolean(options, "disableShare", false);
//        opts.no_titlebar =  parseBoolean(options, "disableTitlebar", false);
        opts.no_driving_mode = parseBoolean(options, "disableDrive", false);
        opts.no_dial_in_via_phone = parseBoolean(options, "disableDialIn", false);
        opts.no_disconnect_audio = parseBoolean(options, "noDisconnectAudio", false);
        opts.no_audio = parseBoolean(options, "noAudio", false);
        boolean view_options = parseBoolean(options, "viewOptions", false);
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
            result.success(false);
            return;
        }

        if(zoomSDK.isLoggedIn()){
            MeetingService meetingService = zoomSDK.getMeetingService();
            StartMeetingOptions opts= new StartMeetingOptions();
            meetingService.startInstantMeeting(context, opts);

            result.success(true);
        }else {
            int res = ZoomSDK.getInstance().loginWithZoom(options.get("userId"), options.get("meetingPassword"));
            if (res == ZoomApiError.ZOOM_API_ERROR_SUCCESS) {
                // Request executed, listen for result to start meeting
                //ZoomSDK.getInstance().addAuthenticationListener(authListener);
            }
        }
    }

    private boolean parseBoolean(Map<String, String> options, String property, boolean defaultValue) {
        return options.get(property) == null ? defaultValue : Boolean.parseBoolean(options.get(property));
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

    @Override
    public void dispose() {}

    @Override
    public void onZoomAuthIdentityExpired() {

    }

    @Override
    public void onZoomSDKLoginResult(long result) {
//        if (result == ZoomAuthenticationError.ZOOM_AUTH_ERROR_SUCCESS) {
//            // Once we verify that the request was successful, we may start the meeting
//            startMeeting(MainJavaActivity.this);
//        }
    }

    @Override
    public void onZoomSDKLogoutResult(long result) {

    }

    @Override
    public void onZoomIdentityExpired() {

    }
}
