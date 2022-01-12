//
//  MobileRTCMeetingService.h
//  MobileRTC
//
//  Created by Zoom Video Communications on 8/7/14.
//  Copyright (c) 2019 Zoom Video Communications, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MobileRTCConstants.h"
#import "MobileRTCMeetingDelegate.h"

/*!
 @brief The method provides parameters for starting meeting.
 */ 
@interface MobileRTCMeetingStartParam : NSObject
/*!
 @brief Notify if it is an App share meeting. 
 */
@property (nonatomic, assign, readwrite) BOOL  isAppShare;
/*!
 @brief Start meeting without audio. 
 */
@property (nonatomic, assign, readwrite) BOOL  noAudio;
/*!
 @brief Start meeting without video  
 */
@property (nonatomic, assign, readwrite) BOOL  noVideo;
/*!
 @brief Customer Key.
 */
@property (nullable, nonatomic, retain, readwrite) NSString * customerKey;
/*!
 @brief Meeting vanity ID, what is personal link name.
 */
@property (nullable, nonatomic, retain, readwrite) NSString * vanityID;
/*!
 @brief Meeting number.
 */
@property (nullable, nonatomic, retain, readwrite) NSString * meetingNumber;
@end

/*!
 @brief The method provides parameters for logged-in user to start meeting.
 */
@interface MobileRTCMeetingStartParam4LoginlUser : MobileRTCMeetingStartParam

@end

/*!
 @brief The method provides parameters for non-logged-in user to start meeting.
 @waring The ZAK cannot be null.
 */
@interface MobileRTCMeetingStartParam4WithoutLoginUser : MobileRTCMeetingStartParam
/*!
 @brief User type.
 */
@property (nonatomic, assign, readwrite) MobileRTCUserType userType;
/*!
 @brief User name.
 */
@property (nullable, nonatomic, retain, readwrite) NSString * userName;
/*!
 @brief User ID.
 */
@property (nonnull, nonatomic, retain, readwrite) NSString * userID;
/*!
 @brief User ZAK.
 @waring The ZAK cannot be null.
 */
@property (nonnull, nonatomic, retain, readwrite) NSString * zak;
@end


/*!
 @brief The method provides parameters for join meeting.
 */
@interface MobileRTCMeetingJoinParam : NSObject
/*!
 @brief Start meeting without audio.
 */
@property (nonatomic, assign, readwrite) BOOL  noAudio;
/*!
 @brief Start meeting without video
 */
@property (nonatomic, assign, readwrite) BOOL  noVideo;
/*!
 @brief Customer Key.
 */
@property (nullable, nonatomic, retain, readwrite) NSString * customerKey;
/*!
 @brief Meeting vanity ID, what is personal link name.
 */
@property (nullable, nonatomic, retain, readwrite) NSString * vanityID;
/*!
 @brief Meeting number.
 */
@property (nullable, nonatomic, retain, readwrite) NSString * meetingNumber;
/*!
 @brief User name.
 */
@property (nullable, nonatomic, retain, readwrite) NSString * userName;
/*!
 @brief Password.
 */
@property (nullable, nonatomic, retain, readwrite) NSString * password;
/*!
 @brief WebinarToken.
 */
@property (nullable, nonatomic, retain, readwrite) NSString * webinarToken;

/*!
 @brief User ZAK.
 */
@property (nullable, nonatomic, retain, readwrite) NSString * zak;
@end

/*!
 @brief Webinar regist legal notice content.
 */
@interface MobileRTCWebinarRegistLegalNoticeContent : NSObject
/*!
 @brief Formatted html content.
 */
@property (nullable, nonatomic, retain, readwrite) NSString * formattedHtmlContent;
/*!
 @brief Account owner url.
 */
@property (nullable, nonatomic, retain, readwrite) NSString * accountOwnerUrl;
/*!
 @brief terms url.
 */
@property (nullable, nonatomic, retain, readwrite) NSString * termsUrl;
/*!
 @brief privacy policy url.
 */
@property (nullable, nonatomic, retain, readwrite) NSString * privacyPolicyUrl;
@end

@protocol MobileRTCMeetingServiceDelegate;

/*!
 @class MobileRTCMeetingService
 @brief The method is an implementation for client to start/join a meeting.
 @warning The meeting service allows only one concurrent operation at a time, which means, only one API call is in progress at any given time.  
 */
@interface MobileRTCMeetingService : NSObject

/*!
 @brief Callback of receiving meeting events.  
 */
@property (nullable, assign, nonatomic) id<MobileRTCMeetingServiceDelegate> delegate;

/*!
 @brief Callback of receiving meeting events for custom UI. 
 */
@property (nullable, assign, nonatomic) id<MobileRTCCustomizedUIMeetingDelegate> customizedUImeetingDelegate;

/*!
 @brief Start a meeting with MobileRTCMeetingStartParam parameter.
 @warning For non-logged-in user, create an instance via MobileRTCMeetingStartParam4WithoutLoginUser to pass the parameters. For logged-in user, create an instance via MobileRTCMeetingStartParam4LoginlUser to pass the parameters.
 @param param Create an instance with right information via MobileRTCMeetingStartParam.
 @return The state of the meeting, started or failed. 
 @warning If you start a meeting with wrong parameters, it will return MobileRTCMeetError_InvalidArguments.
 */
- (MobileRTCMeetError)startMeetingWithStartParam:(nonnull MobileRTCMeetingStartParam*)param;

/*!
 @brief Use it to join a meeting with MobileRTCMeetingJoinParam parameter.
 @param param Create an instance with right information via.
 @return The state of the meeting, started or failed.
 @warning If app is in callkit mode, set parameter:userName to empty. CallKit lets you integrate your calling services with other call-related apps on the system.
 */
- (MobileRTCMeetError)joinMeetingWithJoinParam:(nonnull MobileRTCMeetingJoinParam*)param;

/*!
 @brief Start or join a ZOOM meeting with zoom web url.
 @param meetingUrl zoom web meeting url.
 @return The state of the meeting, started or failed.
 */
- (MobileRTCMeetError)handZoomWebUrl:(nonnull NSString*)meetingUrl;

/*!
 @brief Get the current meeting state.   
 @return Current meeting state.
 */
- (MobileRTCMeetingState)getMeetingState;

/*!
 @brief End/Leave the current meeting. 
 @param cmd The command for leaving the current meeting. Only host can end the meeting.
 */
- (void)leaveMeetingWithCmd:(LeaveMeetingCmd)cmd;

/*!
 @brief This method will return the view of meeting UI, which provide an access which allow customer to add their own view in the meeting UI.
 @return The view of current meeting; if there is no ongoing meeting, it will return nil.
 @warning Only valid in non-custom UI(Only valid in ZOOM meeting UI).
 */
- (UIView * _Nullable)meetingView;

/*!
 @brief Get annotation over share legal notices prompt.
 @return annotation over share legal notices prompt.
 */
- (NSString *_Nullable)getWebinarRegistrationLegalNoticesPrompt;

/*!
 @brief Get annotation over share legal notices explained.
 @return annotation over share legal notices explained.
 */
- (MobileRTCWebinarRegistLegalNoticeContent *_Nullable)getWebinarRegistrationLegalNoticesExplained;

@end
