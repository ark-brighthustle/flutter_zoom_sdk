package com.evilratt.flutter_zoom_sdk;

import android.content.Context;
import android.view.View;
import android.widget.TextView;
import android.widget.Toast;

import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.TimeZone;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.platform.PlatformView;
import us.zoom.sdk.AccountService;
import us.zoom.sdk.JoinMeetingOptions;
import us.zoom.sdk.JoinMeetingParams;
import us.zoom.sdk.MeetingItem;
import us.zoom.sdk.MeetingViewsOptions;
import us.zoom.sdk.PreMeetingError;
import us.zoom.sdk.PreMeetingService;
import us.zoom.sdk.PreMeetingServiceListener;
import us.zoom.sdk.StartMeetingOptions;
import us.zoom.sdk.MeetingService;
import us.zoom.sdk.MeetingStatus;
import us.zoom.sdk.StartMeetingParams;
import us.zoom.sdk.ZoomAuthenticationError;
import us.zoom.sdk.ZoomError;
import us.zoom.sdk.ZoomSDK;
import us.zoom.sdk.ZoomApiError;
import us.zoom.sdk.ZoomSDKAuthenticationListener;
import us.zoom.sdk.ZoomSDKInitParams;
import us.zoom.sdk.ZoomSDKInitializeListener;

public class ZoomView  implements PlatformView,
        MethodChannel.MethodCallHandler,
        PreMeetingServiceListener{
    private final TextView textView;
    private final MethodChannel methodChannel;
    private final Context context;
    private final EventChannel meetingStatusChannel;
    private Calendar mDateFrom;
    private Calendar mDateTo;
    private String mTimeZoneId;
    private AccountService mAccoutnService;
    private PreMeetingService mPreMeetingService = null;


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
            case "login":
                login(methodCall, result);
                break;
            case "join":
                joinMeeting(methodCall, result);
                break;
            case "start":
                startMeeting(methodCall, result);
                break;
            case "schedule":
                scheduleMeeting(methodCall, result);
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

    private void login(final MethodCall methodCall, final MethodChannel.Result result){
        Map<String, String> options = methodCall.arguments();

        ZoomSDK zoomSDK = ZoomSDK.getInstance();

        if(!zoomSDK.isInitialized()) {
            System.out.println("Not initialized!!!!!!");
            result.success(false);
            return;
        }

        if(zoomSDK.isLoggedIn()){
            startMeeting(methodCall, result);
        }

        ZoomSDKAuthenticationListener authenticationListener = new ZoomSDKAuthenticationListener() {

            @Override
            public void onZoomSDKLoginResult(long results) {
                if (results == ZoomAuthenticationError.ZOOM_AUTH_ERROR_SUCCESS) {
//                    Once we verify that the request was successful, we may start the meeting
                    startMeeting(methodCall, result);
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

            int res = zoomSDK.loginWithZoom(options.get("userId"), options.get("meetingPassword"));
            if (res == ZoomApiError.ZOOM_API_ERROR_SUCCESS) {
                Toast.makeText(context, "Login Success.", Toast.LENGTH_LONG).show();
                zoomSDK.addAuthenticationListener(authenticationListener);
            }
        }
    }

    private void initDateAndTime() {
        mTimeZoneId = TimeZone.getDefault().getID();
//        mTxtTimeZoneName.setText(ZmTimeZoneUtils.getFullName(mTimeZoneId));

        Date timeFrom = new Date(System.currentTimeMillis() + 3600 * 1000);
        Date timeTo = new Date(System.currentTimeMillis() + 7200 * 1000);

        mDateFrom = Calendar.getInstance();
        mDateFrom.setTime(timeFrom);
        mDateFrom.set(Calendar.MINUTE, 0);
        mDateFrom.set(Calendar.SECOND, 0);

        mDateTo = Calendar.getInstance();
        mDateTo.setTime(timeTo);
        mDateTo.set(Calendar.MINUTE, 0);
        mDateTo.set(Calendar.SECOND, 0);

        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        String dateStr = sdf.format(mDateFrom.getTime());

//        mTxtDate.setText(dateStr);
//        if (mDateFrom.get(Calendar.MINUTE) < 10) {
//            mTxtTimeFrom.setText(mDateFrom.get(Calendar.HOUR_OF_DAY) + ":0" + mDateFrom.get(Calendar.MINUTE));
//        } else {
//            mTxtTimeFrom.setText(mDateFrom.get(Calendar.HOUR_OF_DAY) + ":" + mDateFrom.get(Calendar.MINUTE));
//        }
//        if (mDateFrom.get(Calendar.MINUTE) < 10) {
//            mTxtTimeTo.setText(mDateTo.get(Calendar.HOUR_OF_DAY) + ":0" + mDateTo.get(Calendar.MINUTE));
//        } else {
//            mTxtTimeTo.setText(mDateTo.get(Calendar.HOUR_OF_DAY) + ":" + mDateTo.get(Calendar.MINUTE));
//        }
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
        opts.no_titlebar =  parseBoolean(options, "disableTitlebar", false);
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
            opts.no_invite = parseBoolean(options, "disableInvite", false);
            opts.no_share = parseBoolean(options, "disableShare", false);
            opts.no_driving_mode = parseBoolean(options, "disableDrive", false);
            opts.no_dial_in_via_phone = parseBoolean(options, "disableDialIn", false);
            opts.no_disconnect_audio = parseBoolean(options, "noDisconnectAudio", false);
            opts.no_audio = parseBoolean(options, "noAudio", false);
            opts.no_titlebar = parseBoolean(options, "disableTitlebar", false);
            boolean view_options = parseBoolean(options, "viewOptions", false);
            if(view_options){
                opts.meeting_views_options = MeetingViewsOptions.NO_TEXT_MEETING_ID + MeetingViewsOptions.NO_TEXT_PASSWORD;
            }

            meetingService.startInstantMeeting(context, opts);
            result.success(true);
        }
    }

    private void scheduleMeeting(MethodCall methodCall, MethodChannel.Result result) {
        Map<String, String> options = methodCall.arguments();

        ZoomSDK zoomSDK = ZoomSDK.getInstance();

        if(!zoomSDK.isInitialized()) {
            System.out.println("Not initialized!!!!!!");
            result.success(false);
            return;
        }

        mAccoutnService = zoomSDK.getAccountService();
        mPreMeetingService = zoomSDK.getPreMeetingService();
        if(mAccoutnService == null || mPreMeetingService == null) {
            Toast.makeText(context, "User not login.", Toast.LENGTH_LONG).show();
            result.success(false);
            return;
        }

        initDateAndTime();

        MeetingItem meetingItem = mPreMeetingService.createScheduleMeetingItem();
        meetingItem.setMeetingTopic(options.get("setMeetingTopic"));
        meetingItem.setStartTime(getBeginTime().getTime());
        meetingItem.setDurationInMinutes(getDurationInMinutes());
        meetingItem.setCanJoinBeforeHost(parseBoolean(options, "canJoinBeforeHost", false));
        meetingItem.setPassword(options.get("setPassword"));
        meetingItem.setHostVideoOff(parseBoolean(options, "setHostVideoOff", false));
        meetingItem.setAttendeeVideoOff(parseBoolean(options, "setAttendeeVideoOff", false));
        meetingItem.setEnableMeetingToPublic(parseBoolean(options, "setEnableMeetingToPublic", false));
        meetingItem.setEnableLanguageInterpretation(parseBoolean(options, "setEnableLanguageInterpretation", false));
        meetingItem.setEnableWaitingRoom(parseBoolean(options, "setEnableWaitingRoom", false));
        boolean autoRecord = parseBoolean(options, "enableAutoRecord", false);
        boolean autoLocalRecord = parseBoolean(options, "enableAutoRecord", false);
        boolean autoCloudRecord = parseBoolean(options, "enableAutoRecord", false);
        if(autoRecord){
            if(autoLocalRecord){
                meetingItem.setAutoRecordType(MeetingItem.AutoRecordType.AutoRecordType_LocalRecord);
            }else if(autoCloudRecord){
                meetingItem.setAutoRecordType(MeetingItem.AutoRecordType.AutoRecordType_CloudRecord);
            }else{
                meetingItem.setAutoRecordType(MeetingItem.AutoRecordType.AutoRecordType_Disabled);
            }
        }
        meetingItem.setTimeZoneId(mTimeZoneId);
        meetingItem.setUsePmiAsMeetingID(false);

        if (mPreMeetingService != null) {
            mPreMeetingService.addListener(this);
            PreMeetingService.ScheduleOrEditMeetingError error = mPreMeetingService.scheduleMeeting(meetingItem);

            if (error == PreMeetingService.ScheduleOrEditMeetingError.SUCCESS) {
                Toast.makeText(context, "success:- "+error.toString(), Toast.LENGTH_LONG).show();
                result.success(true);
                mPreMeetingService.listMeeting();
            } else {
                Toast.makeText(context, "error:- "+error.toString(), Toast.LENGTH_LONG).show();
                result.success(false);
            }
        }else{
            Toast.makeText(context, "User not login.", Toast.LENGTH_LONG).show();
            result.success(false);
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

    private Date getBeginTime() {
        Date date = mDateFrom.getTime();
        date.setSeconds(0);
        return date;
    }

    private int getDurationInMinutes() {
        return (int) ((mDateTo.getTimeInMillis() - mDateFrom.getTimeInMillis()) / 60000);
    }

    @Override
    public void dispose() {
        if (mPreMeetingService != null) {
            mPreMeetingService.removeListener(this);
        }
    }

    @Override
    public void onListMeeting(int i, List<Long> list) {

    }

    @Override
    public void onScheduleMeeting(int result, long meetingNumber) {
        if (result == PreMeetingError.PreMeetingError_Success) {
            Toast.makeText(context, "Schedule successfully. Meeting's unique id is " + meetingNumber, Toast.LENGTH_LONG).show();
        } else {
            Toast.makeText(context, "Schedule failed result code =" + result, Toast.LENGTH_LONG).show();
//            mBtnSchedule.setEnabled(true);
        }
    }

    @Override
    public void onUpdateMeeting(int i, long l) {

    }

    @Override
    public void onDeleteMeeting(int i) {

    }
}
