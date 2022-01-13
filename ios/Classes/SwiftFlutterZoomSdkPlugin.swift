import Flutter
import UIKit
import MobileRTC

public class SwiftFlutterZoomSdkPlugin: NSObject, FlutterPlugin,FlutterStreamHandler , MobileRTCMeetingServiceDelegate {

    struct MeetingViewOptions {
        static let NO_BUTTON_AUDIO = 2
        static let NO_BUTTON_LEAVE = 128
        static let NO_BUTTON_MORE = 16
        static let NO_BUTTON_PARTICIPANTS = 8
        static let NO_BUTTON_SHARE = 4
        static let NO_BUTTON_SWITCH_AUDIO_SOURCE = 512
        static let NO_BUTTON_SWITCH_CAMERA = 256
        static let NO_BUTTON_VIDEO = 1
        static let NO_TEXT_MEETING_ID = 32
        static let NO_TEXT_PASSWORD = 64
  }

  var authenticationDelegate: AuthenticationDelegate
  var eventSink: FlutterEventSink?

  public static func register(with registrar: FlutterPluginRegistrar) {
    let messenger = registrar.messenger()
    let channel = FlutterMethodChannel(name: "com.evilratt/zoom_sdk", binaryMessenger: messenger)
    let instance = SwiftFlutterZoomSdkPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)

    let eventChannel = FlutterEventChannel(name: "com.evilratt/zoom_sdk_event_stream", binaryMessenger: messenger)
    eventChannel.setStreamHandler(instance)
  }

  override init(){
      authenticationDelegate = AuthenticationDelegate()
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
          switch call.method {
          case "init":
              self.initZoom(call: call, result: result)
          case "join":
              self.joinMeeting(call: call, result: result)
          case "start":
              self.startMeeting(call: call, result: result)
          case "meeting_status":
              self.meetingStatus(call: call, result: result)
          default:
              result(FlutterMethodNotImplemented)
          }
  }

  public func onMethodCall(call: FlutterMethodCall, result: @escaping FlutterResult) {

          switch call.method {
          case "init":
              self.initZoom(call: call, result: result)
          case "login":
              self.login(call: call, result: result)
          case "join":
              self.joinMeeting(call: call, result: result)
          case "start":
              self.startMeeting(call: call, result: result)
          case "meeting_status":
              self.meetingStatus(call: call, result: result)
          default:
              result(FlutterMethodNotImplemented)
          }
      }

      public func initZoom(call: FlutterMethodCall, result: @escaping FlutterResult)  {

           let pluginBundle = Bundle(for: type(of: self))
           let pluginBundlePath = pluginBundle.bundlePath
           let arguments = call.arguments as! Dictionary<String, String>

           let context = MobileRTCSDKInitContext()
           context.domain = arguments["domain"]!
           context.enableLog = true
           context.bundleResPath = pluginBundlePath
           MobileRTC.shared().initialize(context)

           let auth = MobileRTC.shared().getAuthService()
           auth?.delegate = self.authenticationDelegate.onAuth(result)
           if let appKey = arguments["appKey"] {
               auth?.clientKey = appKey
           }
           if let appSecret = arguments["appSecret"] {
               auth?.clientSecret = appSecret
           }

           auth?.sdkAuth()
      }

      public func login(call: FlutterMethodCall, result: @escaping FlutterResult) {
              let authService = MobileRTC.shared().getAuthService()
                
              if ((authService?.isLoggedIn()) == true) {
                  self.startMeeting(call:call, result:result);
              }else{
                  let arguments = call.arguments as! Dictionary<String, String?>
                  authService?.login(withEmail: arguments["userId"]!!, password: arguments["userPassword"]!!, rememberMe: false)
                  if ((authService?.isLoggedIn()) == true) {
                      self.startMeeting(call:call, result:result);
                  }
              }
      }

       public func meetingStatus(call: FlutterMethodCall, result: FlutterResult) {

           let meetingService = MobileRTC.shared().getMeetingService()
           if meetingService != nil {
               let meetingState = meetingService?.getMeetingState()
               result(getStateMessage(meetingState))
           } else {
               result(["MEETING_STATUS_UNKNOWN", ""])
           }
       }

       public func joinMeeting(call: FlutterMethodCall, result: FlutterResult) {

           let meetingService = MobileRTC.shared().getMeetingService()
           let meetingSettings = MobileRTC.shared().getMeetingSettings()

           if (meetingService != nil) {
               let arguments = call.arguments as! Dictionary<String, String?>

               meetingSettings?.disableDriveMode(parseBoolean(data: arguments["disableDrive"]!, defaultValue: false))
               meetingSettings?.disableCall(in: parseBoolean(data: arguments["disableDialIn"]!, defaultValue: false))
               meetingSettings?.setAutoConnectInternetAudio(parseBoolean(data: arguments["noDisconnectAudio"]!, defaultValue: false))
               meetingSettings?.setMuteAudioWhenJoinMeeting(parseBoolean(data: arguments["noAudio"]!, defaultValue: false))
               meetingSettings?.meetingShareHidden = parseBoolean(data: arguments["disableShare"]!, defaultValue: false)
               meetingSettings?.meetingInviteHidden = parseBoolean(data: arguments["disableDrive"]!, defaultValue: false)
               meetingSettings?.meetingTitleHidden = parseBoolean(data:arguments["disableTitlebar"]!, defaultValue: false)
               let viewopts = parseBoolean(data:arguments["viewOptions"]!, defaultValue: false)
               if(viewopts){
                    meetingSettings?.meetingTitleHidden = true
                    meetingSettings?.meetingPasswordHidden = true
               }
               let joinMeetingParameters = MobileRTCMeetingJoinParam()
               joinMeetingParameters.userName = arguments["userId"]!!
               joinMeetingParameters.meetingNumber = arguments["meetingId"]!!


               let hasPassword = arguments["meetingPassword"]! != nil
               if hasPassword {
                   joinMeetingParameters.password = arguments["meetingPassword"]!!
               }

               let response = meetingService?.joinMeeting(with: joinMeetingParameters)

               if let response = response {
                   print("Got response from join: \(response)")
               }
               result(true)
           } else {
               result(false)
           }
       }

       public func startMeeting(call: FlutterMethodCall, result: FlutterResult) {

           let meetingService = MobileRTC.shared().getMeetingService()
           let meetingSettings = MobileRTC.shared().getMeetingSettings()
           let authService = MobileRTC.shared().getAuthService()
           
           if meetingService != nil{
               if ((authService?.isLoggedIn()) == true) {
                   let arguments = call.arguments as! Dictionary<String, String?>

                   meetingSettings?.disableDriveMode(parseBoolean(data: arguments["disableDrive"]!, defaultValue: false))
                   meetingSettings?.disableCall(in: parseBoolean(data: arguments["disableDialIn"]!, defaultValue: false))
                   meetingSettings?.setAutoConnectInternetAudio(parseBoolean(data: arguments["noDisconnectAudio"]!, defaultValue: false))
                   meetingSettings?.setMuteAudioWhenJoinMeeting(parseBoolean(data: arguments["noAudio"]!, defaultValue: false))
                   meetingSettings?.meetingShareHidden = parseBoolean(data: arguments["disableShare"]!, defaultValue: false)
                   meetingSettings?.meetingInviteHidden = parseBoolean(data: arguments["disableDrive"]!, defaultValue: false)
                   let viewopts = parseBoolean(data:arguments["viewOptions"]!, defaultValue: false)
                   if(viewopts){
                        meetingSettings?.meetingTitleHidden = true
                        meetingSettings?.meetingPasswordHidden = true
                   }
                   let startMeetingParameters = MobileRTCMeetingStartParam4LoginlUser()

                   //user.userType = .apiUser
                   //user.meetingNumber = arguments["meetingId"]!!
                   //user.userName = arguments["displayName"]!!
                  // user.userToken = arguments["zoomToken"]!!
                   //user.userID = arguments["userId"]!!
                   //user.zak = arguments["zoomAccessToken"]!!

                   //let param: MobileRTCMeetingStartParam = user

                   let response = meetingService?.startMeeting(with: startMeetingParameters)

                   if let response = response {
                       print("Got response from start: \(response)")
                   }
                   result(true)
               }else{
                   result(false)
               }
           } else {
               result(false)
           }
       }

       private func parseBoolean(data: String?, defaultValue: Bool) -> Bool {
           var result: Bool

           if let unwrappeData = data {
               result = NSString(string: unwrappeData).boolValue
           } else {
               result = defaultValue
           }
           return result
       }

       private func parseInt(data: String?, defaultValue: Int) -> Int {
           var result: Int

           if let unwrappeData = data {
               result = NSString(string: unwrappeData).integerValue
           } else {
               result = defaultValue
           }
           return result
       }


       public func onMeetingError(_ error: MobileRTCMeetError, message: String?) {

       }

       public func getMeetErrorMessage(_ errorCode: MobileRTCMeetError) -> String {

           let message = ""
           return message
       }

       public func onMeetingStateChange(_ state: MobileRTCMeetingState) {

           guard let eventSink = eventSink else {
               return
           }

           eventSink(getStateMessage(state))
       }

       public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
           self.eventSink = events

           let meetingService = MobileRTC.shared().getMeetingService()
           if meetingService == nil {
               return FlutterError(code: "Zoom SDK error", message: "ZoomSDK is not initialized", details: nil)
           }
           meetingService?.delegate = self

           return nil
       }

       public func onCancel(withArguments arguments: Any?) -> FlutterError? {
           eventSink = nil
           return nil
       }
       private func getStateMessage(_ state: MobileRTCMeetingState?) -> [String] {

               var message: [String]
               switch state {
               case  .idle:
                   message = ["MEETING_STATUS_IDLE", "No meeting is running"]
                   break
               case .connecting:
                   message = ["MEETING_STATUS_CONNECTING", "Connect to the meeting server"]
                   break
               case .inMeeting:
                   message = ["MEETING_STATUS_INMEETING", "Meeting is ready and in process"]
                   break
               case .webinarPromote:
                   message = ["MEETING_STATUS_WEBINAR_PROMOTE", "Upgrade the attendees to panelist in webinar"]
                   break
               case .webinarDePromote:
                   message = ["MEETING_STATUS_WEBINAR_DEPROMOTE", "Demote the attendees from the panelist"]
                   break
               case .disconnecting:
                   message = ["MEETING_STATUS_DISCONNECTING", "Disconnect the meeting server, leave meeting status"]
                   break;
               case .ended:
                   message = ["MEETING_STATUS_ENDED", "Meeting ends"]
                   break;
               case .failed:
                   message = ["MEETING_STATUS_FAILED", "Failed to connect the meeting server"]
                   break;
               case .reconnecting:
                   message = ["MEETING_STATUS_RECONNECTING", "Reconnecting meeting server status"]
                   break;
               case .waitingForHost:
                   message = ["MEETING_STATUS_WAITINGFORHOST", "Waiting for the host to start the meeting"]
                   break;
               case .inWaitingRoom:
                   message = ["MEETING_STATUS_IN_WAITING_ROOM", "Participants who join the meeting before the start are in the waiting room"]
                   break;
               default:
                   message = ["MEETING_STATUS_UNKNOWN", "'(state?.rawValue ?? 9999)'"]
               }

               return message
           }
}

public class AuthenticationDelegate: NSObject, MobileRTCAuthDelegate {

    private var result: FlutterResult?


    public func onAuth(_ result: FlutterResult?) -> AuthenticationDelegate {
        self.result = result
        return self
    }


    public func onMobileRTCAuthReturn(_ returnValue: MobileRTCAuthError) {

        if returnValue == .success {
            self.result?([0, 0])
        } else {
            self.result?([1, 0])
        }

        self.result = nil
    }

    public func onMobileRTCLoginReturn(_ returnValue: Int){

    }

    public func onMobileRTCLogoutReturn(_ returnValue: Int) {

    }

    public func getAuthErrorMessage(_ errorCode: MobileRTCAuthError) -> String {

        let message = ""

        return message
    }
}
