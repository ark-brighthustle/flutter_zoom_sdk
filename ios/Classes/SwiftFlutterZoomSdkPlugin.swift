import Flutter
import UIKit
import MobileRTC

public class SwiftFlutterZoomSdkPlugin: NSObject, FlutterPlugin,FlutterStreamHandler , MobileRTCMeetingServiceDelegate {

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
          case "login":
              self.login(call: call, result: result)
          case "join":
              self.joinMeeting(call: call, result: result)
          case "startNormal":
              self.startMeetingNormal(call: call, result: result)
          case "meeting_status":
              self.meetingStatus(call: call, result: result)
          case "meeting_details":
              self.meetingDetails(call: call, result: result)
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
              self.startMeetingNormal(call: call, result: result)
          case "meeting_status":
              self.meetingStatus(call: call, result: result)
          case "meeting_details":
              self.meetingDetails(call: call, result: result)
          default:
              result(FlutterMethodNotImplemented)
          }
      }

        //Initializing the Zoom SDK for iOS
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

        //Perform start meeting function with logging in to the zoom account
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
    
        //Perform start meeting function with logging in to the zoom account (Only for passed meeting id)
        public func startMeetingNormal(call: FlutterMethodCall, result: @escaping FlutterResult) {
                let authService = MobileRTC.shared().getAuthService()
                  
                if ((authService?.isLoggedIn()) == true) {
                    self.startMeetingNormalInternal(call:call, result:result);
                }else{
                    let arguments = call.arguments as! Dictionary<String, String?>
                    authService?.login(withEmail: arguments["userId"]!!, password: arguments["userPassword"]!!, rememberMe: false)
                    if ((authService?.isLoggedIn()) == true) {
                        self.startMeetingNormalInternal(call:call, result:result);
                    }
                }
        }

        //Listen to meeting status on joinning and starting the mmeting
        public func meetingStatus(call: FlutterMethodCall, result: FlutterResult) {

            let meetingService = MobileRTC.shared().getMeetingService()
            if meetingService != nil {
                let meetingState = meetingService?.getMeetingState()
                result(getStateMessage(meetingState))
            } else {
                result(["MEETING_STATUS_UNKNOWN", ""])
            }
       }
    
        //Get Meeting Details Programmatically after Starting the Meeting
        public func meetingDetails(call: FlutterMethodCall, result: FlutterResult) {

            let meetingService = MobileRTC.shared().getMeetingService()
            if meetingService != nil {
                let meetingPassword = MobileRTCInviteHelper.sharedInstance().rawMeetingPassword
                let meetingNumber = MobileRTCInviteHelper.sharedInstance().ongoingMeetingNumber
                
                result([meetingNumber, meetingPassword])
                
            } else {
                result(["MEETING_STATUS_UNKNOWN", "No status available"])
            }
        }

        //Join Meeting with passed Meeting ID and Passcode
        public func joinMeeting(call: FlutterMethodCall, result: FlutterResult) {

            let meetingService = MobileRTC.shared().getMeetingService()
            let meetingSettings = MobileRTC.shared().getMeetingSettings()

            if (meetingService != nil) {
                let arguments = call.arguments as! Dictionary<String, String?>

                //Setting up meeting settings for zoom sdk
                meetingSettings?.disableDriveMode(parseBoolean(data: arguments["disableDrive"]!, defaultValue: false))
                meetingSettings?.disableCall(in: parseBoolean(data: arguments["disableDialIn"]!, defaultValue: false))
                meetingSettings?.setAutoConnectInternetAudio(parseBoolean(data: arguments["noDisconnectAudio"]!, defaultValue: false))
                meetingSettings?.setMuteAudioWhenJoinMeeting(parseBoolean(data: arguments["noAudio"]!, defaultValue: false))
                meetingSettings?.meetingShareHidden = parseBoolean(data: arguments["disableShare"]!, defaultValue: false)
                meetingSettings?.meetingInviteHidden = parseBoolean(data: arguments["disableDrive"]!, defaultValue: false)
                meetingSettings?.meetingTitleHidden = parseBoolean(data:arguments["disableTitlebar"]!, defaultValue: false)
                let viewopts = parseBoolean(data:arguments["viewOptions"]!, defaultValue: false)
                if viewopts {
                    meetingSettings?.meetingTitleHidden = true
                    meetingSettings?.meetingPasswordHidden = true
                }
                
                //Setting up Join Meeting parameter
                let joinMeetingParameters = MobileRTCMeetingJoinParam()
                
                //Setting up Custom Join Meeting parameter
                joinMeetingParameters.userName = arguments["userId"]!!
                joinMeetingParameters.meetingNumber = arguments["meetingId"]!!

                let hasPassword = arguments["meetingPassword"]! != nil
                if hasPassword {
                    joinMeetingParameters.password = arguments["meetingPassword"]!!
                }

                //Joining the meeting and storing the response
                let response = meetingService?.joinMeeting(with: joinMeetingParameters)

                if let response = response {
                    print("Got response from join: \(response)")
                }
                result(true)
            } else {
                result(false)
            }
        }

        // Basic Start Meeting Function called on startMeeting triggered via login function
        public func startMeeting(call: FlutterMethodCall, result: FlutterResult) {

            let meetingService = MobileRTC.shared().getMeetingService()
            let meetingSettings = MobileRTC.shared().getMeetingSettings()
            let authService = MobileRTC.shared().getAuthService()
           
            if meetingService != nil{
                if ((authService?.isLoggedIn()) == true) {
                    let arguments = call.arguments as! Dictionary<String, String?>

                    //Setting up meeting settings for zoom sdk
                    meetingSettings?.disableDriveMode(parseBoolean(data: arguments["disableDrive"]!, defaultValue: false))
                    meetingSettings?.disableCall(in: parseBoolean(data: arguments["disableDialIn"]!, defaultValue: false))
                    meetingSettings?.setAutoConnectInternetAudio(parseBoolean(data: arguments["noDisconnectAudio"]!, defaultValue: false))
                    meetingSettings?.setMuteAudioWhenJoinMeeting(parseBoolean(data: arguments["noAudio"]!, defaultValue: false))
                    meetingSettings?.meetingShareHidden = parseBoolean(data: arguments["disableShare"]!, defaultValue: false)
                    meetingSettings?.meetingInviteHidden = parseBoolean(data: arguments["disableDrive"]!, defaultValue: false)
                    let viewopts = parseBoolean(data:arguments["viewOptions"]!, defaultValue: false)
                    if viewopts {
                        meetingSettings?.meetingTitleHidden = true
                        meetingSettings?.meetingPasswordHidden = true
                    }
                    
                    //Setting up Start Meeting parameter
                    let startMeetingParameters = MobileRTCMeetingStartParam4LoginlUser()
                    
                    //Starting the meeting and storing the response
                    let response = meetingService?.startMeeting(with: startMeetingParameters)

                    if let response = response {
                        print("Got response from start: \(response)")
                    }
                    result(["MEETING SUCCESS", "200"])
                }else{
                    result(["LOGIN REQUIRED", "001"])
                }
            } else {
                result(["SDK ERROR", "001"])
            }
        }
    
        // Meeting ID passed Start Meeting Function called on startMeetingNormal triggered via startMeetingNormal function
        public func startMeetingNormalInternal(call: FlutterMethodCall, result: FlutterResult) {

            let meetingService = MobileRTC.shared().getMeetingService()
            let meetingSettings = MobileRTC.shared().getMeetingSettings()
            let authService = MobileRTC.shared().getAuthService()
        
            if meetingService != nil{
                if ((authService?.isLoggedIn()) == true) {
                    let arguments = call.arguments as! Dictionary<String, String?>

                    //Setting up meeting settings for zoom sdk
                    meetingSettings?.disableDriveMode(parseBoolean(data: arguments["disableDrive"]!, defaultValue: false))
                    meetingSettings?.disableCall(in: parseBoolean(data: arguments["disableDialIn"]!, defaultValue: false))
                    meetingSettings?.setAutoConnectInternetAudio(parseBoolean(data: arguments["noDisconnectAudio"]!, defaultValue: false))
                    meetingSettings?.setMuteAudioWhenJoinMeeting(parseBoolean(data: arguments["noAudio"]!, defaultValue: false))
                    meetingSettings?.meetingShareHidden = parseBoolean(data: arguments["disableShare"]!, defaultValue: false)
                    meetingSettings?.meetingInviteHidden = parseBoolean(data: arguments["disableDrive"]!, defaultValue: false)
                    let viewopts = parseBoolean(data:arguments["viewOptions"]!, defaultValue: false)
                    if viewopts {
                        meetingSettings?.meetingTitleHidden = true
                        meetingSettings?.meetingPasswordHidden = true
                    }
                    
                    //Setting up Start Meeting parameter
                    let startMeetingParameters = MobileRTCMeetingStartParam4LoginlUser()
                    //Passing custom Meeting ID for start meeting
                    startMeetingParameters.meetingNumber = arguments["meetingId"]!!

                    //Starting the meeting and storing the response
                    let response = meetingService?.startMeeting(with: startMeetingParameters)

                    if let response = response {
                        print("Got response from start: \(response)")
                    }
                    result(["MEETING SUCCESS", "200"])
                }else{
                    result(["LOGIN REQUIRED", "001"])
                }
            } else {
                result(["SDK ERROR", "001"])
            }
        }

        //Helper Function for parsing string to boolean value
        private func parseBoolean(data: String?, defaultValue: Bool) -> Bool {
            var result: Bool

            if let unwrappeData = data {
                result = NSString(string: unwrappeData).boolValue
            } else {
               result = defaultValue
            }
            return result
        }
    
        //Helper Function for parsing string to int value
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
    
        //Listen to initializing sdk events
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
    
        //Get Meeting Status message with proper codes
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

        //Zoom SDK Authentication Listner
        public class AuthenticationDelegate: NSObject, MobileRTCAuthDelegate {

            private var result: FlutterResult?

            //Zoom SDK Authentication Listner - On Auth get result
            public func onAuth(_ result: FlutterResult?) -> AuthenticationDelegate {
                self.result = result
                return self
            }

            //Zoom SDK Authentication Listner - On MobileRTCAuth get result
            public func onMobileRTCAuthReturn(_ returnValue: MobileRTCAuthError) {

                if returnValue == .success {
                    self.result?([0, 0])
                } else {
                    self.result?([1, 0])
                }

                self.result = nil
            }
            
            //Zoom SDK Authentication Listner - On onMobileRTCLoginReturn get status
            public func onMobileRTCLoginReturn(_ returnValue: Int){

            }

            //Zoom SDK Authentication Listner - On onMobileRTCLogoutReturn get message
            public func onMobileRTCLogoutReturn(_ returnValue: Int) {

            }
            
            //Zoom SDK Authentication Listner - On getAuthErrorMessage get message
            public func getAuthErrorMessage(_ errorCode: MobileRTCAuthError) -> String {

                let message = ""

                return message
            }
        }
