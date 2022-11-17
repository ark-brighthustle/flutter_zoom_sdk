//
//  MobileRTCMeetingDelegate.h
//  MobileRTC
//
//  Created by Robust on 2017/11/14.
//  Copyright © 2019年 Zoom Video Communications, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MobileRTCVideoRawData.h"
#import "MobileRTCAudioRawData.h"
#import "MobileRTCBORole.h"
#import "MobileRTCReturnToMainSessionHandler.h"
#import "MobileRTCPreProcessRawData.h"
#import "MobileRTCVideoSender.h"
#import "MobileRTCShareSender.h"
#import "MobileRTCVideoCapabilityItem.h"
#import "MobileRTCLiveTranscriptionLanguage.h"

@class MobileRTCInterpretationLanguage;
@class MobileRTCMeetingParameter;
#pragma mark - MobileRTCMeetingServiceDelegate
/*!
 @protocol MobileRTCMeetingServiceDelegate
 @brief The Meeting Service will issue the following values when the meeting state changes.
 */  
@protocol MobileRTCMeetingServiceDelegate <NSObject>

@optional
/*!
 @brief Specified Meeting Errors.
 @param error Internal error code.
 @param message The message for meeting errors.
 */
- (void)onMeetingError:(MobileRTCMeetError)error message:(NSString * _Nullable)message;

/*!
 @brief Notify the user that the meeting status changes. 
 @param state The meeting status changes.
 */
- (void)onMeetingStateChange:(MobileRTCMeetingState)state;

/*!
 @brief Meeting parameter notification callback.
 @param meetingParam meetingParam Meeting parameter.
 */
- (void)onMeetingParameterNotification:(MobileRTCMeetingParameter *_Nullable)meetingParam;

/*!
 @brief Notify the user that the requirement to join meeting is confirmed.
 */
- (void)onJoinMeetingConfirmed;

/*!
 @brief The meeting is ready.
 */
- (void)onMeetingReady;

/*!
 @brief Join a meeting without host, you can show/hide the custom JBH waiting UI.
 @param cmd Show/Hide JBH command.
 */
- (void)onJBHWaitingWithCmd:(JBHCmd)cmd;

/*!
 @brief Determine if the current user has the cloud recording privilege.  
 @param result The result of checking CMR privilege.
 */
- (void)onCheckCMRPrivilege:(MobileRTCCMRError)result;

/*!
 @brief Cloud recording status notify callback.
 @param status recording status.
 */
- (void)onRecordingStatus:(MobileRTCRecordingStatus)status;

/*!
 @brief Local recording status notify callback.
 @param userId Specify the user ID whose status changes.
 @param status recording status.
 */
- (void)onLocalRecordingStatus:(NSInteger)userId status:(MobileRTCRecordingStatus)status;

/*!
 @brief Meeting is ended by some reasons.
 @param reason The reason why meeting is ended.
 */
- (void)onMeetingEndedReason:(MobileRTCMeetingEndReason)reason;

/*!
 @brief Meeting without host will be ended after some-awhile.
 @param minutes The minutes remaining to end the meeting.
 */
- (void)onNoHostMeetingWillTerminate:(NSUInteger)minutes;

/*!
 @brief Notify user the issues of microphone.
 */
- (void)onMicrophoneStatusError:(MobileRTCMicrophoneError)error;

/*!
 @brief Notify user to provide join meeting information: screen name or meeting password.
 @param displayName User needs to provide screen name to join a meeting.
 @param password User needs to provide meeting password to join a meeting.
 @param cancel Once the user cancels to provide screen name or meeting password, it is canceled to join the meeting.
 */
- (void)onJoinMeetingInfo:(MobileRTCJoinMeetingInfo)info
               completion:(void (^_Nonnull)(NSString * _Nonnull displayName, NSString * _Nonnull password, BOOL cancel))completion;

/*!
 @brief Set to ask user to provide proxy information: username and password.
 @param host Proxy host.
 @param port Proxy port.
 @param completion SDK will ask user to input proxy information once it detects the information changes. 
 */
- (void)onProxyAuth:(NSString*_Nonnull)host
               port:(NSUInteger)port
         completion:(void (^_Nonnull)(NSString * _Nonnull host, NSUInteger port, NSString *_Nonnull username, NSString * _Nonnull password, BOOL cancel))completion;

/*!
 @brief Set if user needs to end another ongoing meeting.
 @param completion Ask user to end another ongoing meeting or not.
 */
- (void)onAskToEndOtherMeeting:(void (^_Nonnull)(BOOL cancel))completion;

/*!
 @brief Notify user that microphone access permission is denied.  
 */
- (void)onMicrophoneNoPrivilege;

/*!
 @brief Notify user that camera access permission is denied. 
 */
- (void)onCameraNoPrivilege;

/*!
 @brief Inform user that free meeting will be ended in 10 minutes.
 @param host YES means the original host of the current meeting, otherwise not.
 @param freeUpgrade YES means the current free meeting will be upgraded. Once upgraded, the current meeting can last for more than 40 minutes.
 @param first and second time, meeting is no limit, from third time, will end meeting at 40 mins.
 @param completion MobileRTC will call the module to upgrade the current meeting once the parameter UPGRADE is YES.
 */
- (void)onFreeMeetingReminder:(BOOL)host
               canFreeUpgrade:(BOOL)freeUpgrade
                  isFirstGift:(BOOL)first
                   completion:(void (^_Nonnull)(BOOL upgrade))completion DEPRECATED_ATTRIBUTE;

/*!
 @brief The result of upgrading free meeting.
 @param result ZERO(0) means the upgrade was successful, otherwise it failed.
 */
- (void)onUpgradeFreeMeetingResult:(NSUInteger)result;

/**
 * @brief Designated for notify the free meeting need upgrade.
 * @param type The enumeration of FreeMeetingNeedUpgradeType, if the type is FreeMeetingNeedUpgradeType_BY_GIFTURL, user can upgrade free meeting through url. if the type is FreeMeetingNeedUpgradeType_BY_ADMIN, user can ask admin user to upgrade the meeting.
 * @param giftURL User can upgrade the free meeting through the url.
 */
- (void)onFreeMeetingNeedToUpgrade:(FreeMeetingNeedUpgradeType)type giftUpgradeURL:(NSString*_Nullable)giftURL;

/**
 * @brief Designated for notify the free meeting which has been upgraded to free trail meeting has started.
 */
- (void)onFreeMeetingUpgradeToGiftFreeTrialStart;

/**
 * @brief Designated for notify the free meeting which has been upgraded to free trail meeting has stoped.
 */
- (void)onFreeMeetingUpgradeToGiftFreeTrialStop;

/**
 * @brief Designated for notify the free meeting has been upgraded to professional meeting.
 */
- (void)onFreeMeetingUpgradedToProMeeting;

/*!
 @brief Customize the invitation event.
 @param parentVC Parent viewcontroller to present custom Invite UI. 
 @param array <MobileRTCMeetingInviteActionItem *>Add custom InviteActionItem to Invite ActionSheet.
 @return NO: User don't want to customer the invite view themself, will using default action sheet UI, but can add some item in the action sheet via #array#. YES: will handled by Customer, Zoom will take no action after button clicked.
 */
- (BOOL)onClickedInviteButton:(UIViewController * _Nonnull)parentVC addInviteActionItem:(NSMutableArray * _Nullable)array;

/*!
 @brief Customize the audio button clicked event.
 @param parentVC Parent viewcontroller to present custom Invite UI.
 @return YES if user wants to custom the audio button clicked event, Otherwise NO, will use the default method.
 */
- (BOOL)onClickedAudioButton:(UIViewController * _Nonnull)parentVC;

/*!
 @brief Custom the UI of Participants management.
 @param parentVC Parent viewcontroller to present custom Participants UI. 
 */
- (BOOL)onClickedParticipantsButton:(UIViewController * _Nonnull)parentVC;

/*!
 @brief User needs to click the SHARE button in meeting.
 @return NO if user wants to custom Share Action Item, add items to Share ActionSheet via MobileRTCMeetingShareActionItem. Otherwise YES, user will use the default UI.
 */
- (BOOL)onClickedShareButton:(UIViewController * _Nonnull)parentVC addShareActionItem:(NSMutableArray * _Nonnull)array;

/*!
 @brief Custom the UI of Leave Meeting Alert.
 @param parentVC Parent viewcontroller to present custom Participants UI.
 @param endButton The endButton.
 */
- (BOOL)onClickedEndButton:(UIViewController * _Nonnull)parentVC endButton:(UIButton * _Nonnull)endButton;

/*!
 @brief Notify users that there is no sharing for the moment.
 */
- (void)onOngoingShareStopped;

/*!
 @brief Customize outgoing call interface.
 @param parentVC Parent viewcontroller to present outgoing call UI.
 @param me YES means to CALL ME; NO means INVITE BY PHONE.
 */
- (void)onClickedDialOut:(UIViewController * _Nonnull)parentVC isCallMe:(BOOL)me;

/*!
 @brief Callback event that outgoing call status changes.  
 @param status Notify user the outgoing call status.
 */
- (void)onDialOutStatusChanged:(DialOutStatus)status;

/*!
 @brief Callback event while calling H.323 device, and you should input the pairing code.
 @param state ZERO(0) means pairing successfully, otherwise failed.
 @param meetingNumber The meetng number
 */
- (void)onSendPairingCodeStateChanged:(MobileRTCH323ParingStatus)state MeetingNumber:(unsigned long long)meetingNumber;

/*!
 @brief Callback event when Room Device state changes. 
 @param state Notify user the status of calling Room Device.
 */
- (void)onCallRoomDeviceStateChanged:(H323CallOutStatus)state;

/*!
 @brief Callback event of new message.
 @param messageID The message ID.
 */
- (void)onInMeetingChat:(NSString * _Nonnull)messageID;

/*!
 @brief Chat message be deleted callback. This function is used to inform the user host/myself the message be deleted.
 @param msgID is the id of the deleted message.
 @param deleteBy Indicates by whom the message was deleted.
 */
- (void)onChatMsgDeleteNotification:(NSString *_Nonnull)msgID deleteBy:(MobileRTCChatMessageDeleteType)deleteBy;

/*!
 @brief Callback event that live stream status changes. 
 */
- (void)onLiveStreamStatusChange:(MobileRTCLiveStreamStatus)liveStreamStatus;

/*!
 @brief Callback event that ZAK expired.
 */
- (void)onZoomIdentityExpired;

/*!
 @brief Callback event that user clicks the sharing screen.
 @param parentVC Parent viewcontroller to present the view of Sharing Screen Usage Guide.
 @waring Application will present Share Screen Usage Guide.
 */
- (void)onClickShareScreen:(UIViewController * _Nonnull)parentVC;

/*!
 @brief Callback event that user receives the Closed Caption. If the meeting support multi language transcription and host set meeting manual caption is true, attendees must set translation language id to -1 to receive closed caption messages.
 @param message the message of closed caption
 @param speakerID the speakerID of the closed caption
 @param msgTime the time of the close caption
 */
- (void)onClosedCaptionReceived:(NSString * _Nonnull)message speakerId:(NSUInteger)speakerID msgTime:(NSDate *_Nullable)msgTime;

/*!
 @brief Callback event that waiting room status changes. 
 */
- (void)onWaitingRoomStatusChange:(BOOL)needWaiting;

/*!
@brief The function will be invoked when the chat privilege of attendees changes.
@param currentPrivilege The chat privilege of the current attendee.
@warning only normal meeting(non webinar meeting) can get the callback.
*/
- (void)onSinkAttendeeChatPriviledgeChanged:(MobileRTCMeetingChatPriviledgeType)currentPrivilege;

/*!
@brief The function will be invoked when the chat privilege of panelist changes.
@param privilege The chat privilege of the current panelist.
@warning only webinar meeting can get the callback.
*/
- (void)onSinkPanelistChatPrivilegeChanged:(MobileRTCPanelistChatPrivilegeType)privilege;

/*!
@brief Callback when subscribe fail.
@param errorCode errorCode.
@param size subscribe size.
@param userId subscribe userId.
@warning the call back only for Custom UI Mode.
*/
- (void)onSubscribeUserFail:(MobileRTCSubscribeFailReason)errorCode size:(NSInteger)size userId:(NSUInteger)userId;

@end

#pragma mark - MobileRTCAudioServiceDelegate
/*!
 @protocol MobileRTCAudioServiceDelegate
 @brief An Audio Service will issue the following values when the meeting audio changes.
 */
@protocol MobileRTCAudioServiceDelegate <MobileRTCMeetingServiceDelegate>

/*!
 @brief Callback event that the participant's audio status changes. 
 @param UserID The ID of user whose audio status changes.
 */
- (void)onSinkMeetingAudioStatusChange:(NSUInteger)userID;

/*!
 @brief Callback event that the audio type of the current user changes. 
 */
- (void)onSinkMeetingMyAudioTypeChange;

/*!
 @brief Callback event that the audio type of user changes.
 @param UserID The ID of user whose audio type changes.
 */
- (void)onSinkMeetingAudioTypeChange:(NSUInteger)userID;

/*!
@brief Callback event that the participant's audio status changes(include myself).
@param UserID The ID of user whose audio status changes.
@param audioStatus The audio status of user whose audio status changes.
*/
- (void)onSinkMeetingAudioStatusChange:(NSUInteger)userID audioStatus:(MobileRTC_AudioStatus)audioStatus;

/*!
 @brief Callback event that the output type of the current user's audio source changes. 
 */
- (void)onAudioOutputChange;

/*!
 @brief Callback event that the audio state of the current user changes.
 */
- (void)onMyAudioStateChange;

/*!
 @brief Callback event that the host require meeting attendants to enable microphone.
 */
- (void)onSinkMeetingAudioRequestUnmuteByHost;
@end

#pragma mark - MobileRTCVideoServiceDelegate
/*!
 @protocol MobileRTCVideoServiceDelegate
 @brief A video service will issue the following values when the meeting video changes.
 */
@protocol MobileRTCVideoServiceDelegate <MobileRTCMeetingServiceDelegate>

/*!
 @brief The function will be invoked once the active video status changes. 
 @param userID The ID of user whose video is active at present.
 */
- (void)onSinkMeetingActiveVideo:(NSUInteger)userID;

/*!
 @brief The function will be invoked once the participant's video status changes.
 @param userID The ID of user whose video status changes.
 */
- (void)onSinkMeetingVideoStatusChange:(NSUInteger)userID;

/*!
 @brief Callback event that my video state changes. 
 */
- (void)onMyVideoStateChange;

/*!
@brief The function will be invoked once the participant's video status changes(include myself).
@param userID The ID of user whose video status changes.
@param videoStatus The video status of user whose video status changes.
*/
- (void)onSinkMeetingVideoStatusChange:(NSUInteger)userID videoStatus:(MobileRTC_VideoStatus)videoStatus;

/*!
 @brief Callback event that the video status of spotlight user changes. Spotlight user means that the view will show only the specified user and won't change even other speaks.
 @param on YES means spotlight hotspot; NO means spotlight falloff.
 */
- (void)onSpotlightVideoChange:(BOOL)on;

/*!
 @brief Callback event that the video spotlight user list changes. Spotlight user means that the view will show only the specified user and won't change even other speaks.
 @param spotlightedUserList spot light user list.
 */
- (void)onSpotlightVideoUserChange:(NSArray <NSNumber *>* _Nonnull)spotlightedUserList;

/*!
 @brief Notify user that preview video is stopped by SDK. Usually the video will show the user himself when there is no other user joins.
 @waring The method MobileRTCPreviewVideoView will stop render, and App will adjust UI. Remove MobileRTCPreviewVideoView instance if it is necessary.
 */
- (void)onSinkMeetingPreviewStopped;

/*!
 @brief Callback event of active video changes when there is a new speaker. 
 @param userID UserID of new speaker.
 */
- (void)onSinkMeetingActiveVideoForDeck:(NSUInteger)userID;

/*!
 @brief Notify that user's video quality changes.
 @param qality The quality of the video.
 @param userID The ID of user whose video is active at present.
 */
- (void)onSinkMeetingVideoQualityChanged:(MobileRTCVideoQuality)qality userID:(NSUInteger)userID;

/*!
 @brief Callback event that host requests to unmute the user's video. 
 */
- (void)onSinkMeetingVideoRequestUnmuteByHost:(void (^_Nonnull)(BOOL Accept))completion;

/*!
 @brief Callback event that show minimize meeting or back zoom UI.
 @param state The state of minimizeMeeting or ZoomUIMeeting.
 @warning The call back only for ZoomUI, Custom UI will not be executed.
 */
- (void)onSinkMeetingShowMinimizeMeetingOrBackZoomUI:(MobileRTCMinimizeMeetingState)state;

/*!
 @brief Callback event of the video order changes.
 @param orderArr The video order array contains the user ID of listed users.
 */
- (void)onHostVideoOrderUpdated:(NSArray <NSNumber *>* _Nullable)orderArr;

/*!
 @brief Callback event of the local video order changes.
 @param localOrderArr The lcoal video order list contains the user ID of listed users.
 */
- (void)onLocalVideoOrderUpdated:(NSArray <NSNumber *>* _Nullable)localOrderArr;

/*!
 @brief Notification the status of following host's video order changed.
 @param follow Yes means the option of following host's video order is on, otherwise not.
 */
- (void)onFollowHostVideoOrderChanged:(BOOL)follow;

@end


#pragma mark - MobileRTCUserServiceDelegate
/*!
 @protocol MobileRTCUserServiceDelegate
 @brief Callback event when the attendee's status changes. 
 */
@protocol MobileRTCUserServiceDelegate <MobileRTCMeetingServiceDelegate>

/*!
 @brief Callback event that the current user's hand state changes.
 */
- (void)onMyHandStateChange;

/*!
 @brief Callback event that the user state is updated in meeting.
 */
- (void)onInMeetingUserUpdated;

/*!
 @brief The function will be invoked once the user joins the meeting.
 @param userID The ID of user who joins the meeting.
 */
- (void)onSinkMeetingUserJoin:(NSUInteger)userID;

/*!
 @brief The function will be invoked once the user leaves the meeting.
 @param userID The ID of user who leaves the meeting.
 */
- (void)onSinkMeetingUserLeft:(NSUInteger)userID;

/*!
 @brief The function will be invoked once user raises hand.
 @param userID The ID of user who raises hand.
 */
- (void)onSinkMeetingUserRaiseHand:(NSUInteger)userID;

/*!
 @brief The function will be invoked once user lowers hand.
 @param userID The ID of user who lowers hand.
 */
- (void)onSinkMeetingUserLowerHand:(NSUInteger)userID;

/*!
 @brief Callback event of host or cohost lower all hands.
 */
- (void)onSinkLowerAllHands;

/*!
 @brief The function will be invoked once user change the screen name.
 @param userID Specify the user ID whose user name changes.
 @param userName New screen name displayed.
 */
- (void)onSinkUserNameChanged:(NSUInteger)userID userName:(NSString *_Nonnull)userName DEPRECATED_ATTRIBUTE;

/*!
 @brief The function will be invoked once user change the screen name.
 @param userNameChangedArr Specify the user IDs whose user name changes.
 @warning The old interface virtual void '-(void)onSinkUserNameChanged:userName:' will be marked as deprecated, and will use this new callbacks. This is because in a webinar, when the host renamed an attendee, only the attendee could receive the old callback, and the host/cohost/panlist is not able to receive it, which leads to the developer not being able to update the UI.
 */
- (void)onSinkUserNameChanged:(NSArray <NSNumber *>* _Nullable)userNameChangedArr;

/*!
 @brief Notify user that meeting host changes.
 @param hostId The user ID of host.
 */
- (void)onMeetingHostChange:(NSUInteger)hostId;

/*!
 @brief Callback event that co-host changes.
 @param userID The user ID of co-host.
 @param isCoHost indicate the user(userID) be assigned to cohost or be remove cohost.
 */
- (void)onMeetingCoHostChange:(NSUInteger)userID isCoHost:(BOOL)isCoHost;

/*!
 @brief Callback event that user claims the host.
 */
- (void)onClaimHostResult:(MobileRTCClaimHostError)error;
@end

#pragma mark - MobileRTCShareServiceDelegate
/*!
 @protocol MobileRTCShareServiceDelegate
 @brief Callback event when the meeting sharing status changes.
 */
@protocol MobileRTCShareServiceDelegate <MobileRTCMeetingServiceDelegate>

/*!
 @brief Callback event of starting a meeting by sharing.
 */
- (void)onAppShareSplash;

/*!
 @brief Callback event when the share starts.
 @param userID The user ID of presenter.
 @warning userID == 0, which means that the user stopped sharing.
 @deprecated replace with {@link onSinkSharingStatus:userID:}
 */
- (void)onSinkMeetingActiveShare:(NSUInteger)userID DEPRECATED_ATTRIBUTE;

/*!
 @brief Callback event when the sharing content changes.
 @param userID The user ID of presenter.
 @deprecated replace with {@link onSinkSharingStatus:userID:}
 */
- (void)onSinkMeetingShareReceiving:(NSUInteger)userID DEPRECATED_ATTRIBUTE;

/*!
 @brief Callback event when the share status changed.
 @param status Sharing status.
 @param userID Specify the user ID whose share status changes.
*/
- (void)onSinkSharingStatus:(MobileRTCSharingStatus)status userID:(NSUInteger)userID;

/*!
 @brief Callback event when the sharing settings changes.
 @param shareSettingType The share setting type of current meeting.
 */
- (void)onSinkShareSettingTypeChanged:(MobileRTCShareSettingType)shareSettingType;


/*!
 @brief Callback event when presenter resizes the sharing content. 
 @param userID New size of the shared content and UserID
 */
- (void)onSinkShareSizeChange:(NSUInteger)userID;

@end

#pragma mark - MobileRTCInterpretationServiceDelegate
/*!
 @protocol MobileRTCInterpretationServiceDelegate
 @brief Callback event when the Interpretaion status change.
 */
@protocol MobileRTCInterpretationServiceDelegate <MobileRTCMeetingServiceDelegate>

@optional

/*!
 @brief interpretation start callback. This function is used to inform the user interpretation has been started, and all users in meeting can get the event.
*/
- (void)onInterpretationStart;

/*!
 @brief interpretation stop callback. This function is used to inform the user interpretation has been stopped, and all users in meeting can get the event.
*/
- (void)onInterpretationStop;

/*!
 @brief interpreter list changed callback. when some interpreter leave meeting or preset interpreter join meeting, and only host can get the event.
*/
- (void)onInterpreterListChanged;

/*!
 @brief interpreter role changed callback. when a user's role changed(participant <-> interpreter), and all users in meeting can get the event.
 @param userID Specify the user ID whose status changed.
 @param isInterpreter Specify the user's role is interpreter or not.
*/
- (void)onInterpreterRoleChanged:(NSUInteger)userID isInterpreter:(BOOL)isInterpreter;

/*!
 @brief interpreter active language changed callback. when a interpreter's active language changed, and all users in meeting can get the event.
 @param userID Specify the user ID whose active language changed.
 @param activeLanID Specify the interpreter current active language id.
*/
- (void)onInterpreterActiveLanguageChanged:(NSInteger)userID activeLanguageId:(NSInteger)activeLanID;

/*!
 @brief interpreter languages changed callback. when a interpreter's languages changed, and only the interpreter can get the event.
 @param lanID1 Specify the new language ID1.
 @param lanID2 Specify the new language ID2.
*/
- (void)onInterpreterLanguageChanged:(NSInteger)lanID1 andLanguage2:(NSInteger)lanID2;

/*!
 @brief available languages changed callback. when available languages in meeting are changed, all non interpreter users in meeting can get the event.
 @param availableLanguageList Specify the available languages list.
*/
- (void)onAvailableLanguageListUpdated:(NSArray <MobileRTCInterpretationLanguage *> *_Nullable)availableLanguageList;

/*!
 @brief Callback to indicate that the list of available languages that interpreters can hear has changed.When the list of available languages that interpreters can hear in a meeting is changed, all interpreters in the meeting can get this event.
 @param interpreterAvailableListenLanList The list of available languages that interpreters can hear.
*/
- (void)onInterpreterLanguagesUpdated:(NSArray <MobileRTCInterpretationLanguage *> *_Nullable)availableLanguages;

@end

#pragma mark - MobileRTCWebinarServiceDelegate
/*!
 @protocol MobileRTCWebinarServiceDelegate
 @brief Callback event when the Webinar changes.
 */
@protocol MobileRTCWebinarServiceDelegate <MobileRTCMeetingServiceDelegate>

/*!
 @brief Callback event when Question and Answer(Q&A) conneAnswerction starts.
 */
- (void)onSinkQAConnectStarted;

/*!
 @brief Callback event when Q&A is connected/disconnected.
 @param connected The flag of Q&A is connected/disconnected.
 */
- (void)onSinkQAConnected:(BOOL)connected;

/*!
 @brief Callback event when the open-ended question changes.
 @param count The amount of open-ended questions.
 */
- (void)onSinkQAOpenQuestionChanged:(NSInteger)count;

/*!
 @brief Callback event when add a new question.
 @param questionID question id.
 @param success success or not.
 */
- (void)onSinkQAAddQuestion:(NSString *_Nonnull)questionID success:(BOOL)success;

/*!
 @brief Callback event when add a new answer.
 @param answerID answer user id.
 @param success success or not.
 */
- (void)onSinkQAAddAnswer:(NSString *_Nonnull)answerID success:(BOOL)success;

/*!
 @brief Callback event when the new question is marked as dismissed.
 @param questionID The question ID.
 */
- (void)onSinkQuestionMarkedAsDismissed:(NSString *_Nonnull)questionID;

/*!
 @brief Callback event when the question is opened.
 @param questionID The question ID.
 */
- (void)onSinkReopenQuestion:(NSString *_Nonnull)questionID;

/*!
 @brief Callback event when a new question is received.
 @param questionID The question ID.
 */
- (void)onSinkReceiveQuestion:(NSString *_Nonnull)questionID;

/*!
 @brief Callback event when a new answer is received.
 @param questionID The question ID.
 */
- (void)onSinkReceiveAnswer:(NSString *_Nonnull)answerID;

/*!
 @brief Callback event when the question is living reply.
 @param questionID The question ID.
 */
- (void)onSinkUserLivingReply:(NSString *_Nonnull)questionID;

/*!
 @brief Callback event when the question end living reply.
 @param questionID The question ID.
 */
- (void)onSinkUserEndLiving:(NSString *_Nonnull)questionID;

/*!
 @brief Callback event when the question is upvote.
 @param questionID The question ID.
 @param order_changed order change
 */
- (void)onSinkVoteupQuestion:(NSString *_Nonnull)questionID orderChanged:(BOOL)orderChanged;

/*!
 @brief Callback event when the question is revoke upvote.
 @param questionID The question ID.
 @param order_changed order change
 */
- (void)onSinkRevokeVoteupQuestion:(NSString *_Nonnull)questionID orderChanged:(BOOL)orderChanged;

/*!
@brief Callback event when delete question.
@param questionIDArray The questionIDs.
*/
- (void)onSinkDeleteQuestion:(NSArray *_Nonnull)questionIDArray;

/*!
@brief Callback event when delete answer.
@param answerIDArray The answerIDs.
*/
- (void)onSinkDeleteAnswer:(NSArray *_Nonnull)answerIDArray;

/*!
 @brief Callback event of the permission that user is allowed to ask questions anonymously is changed.
 @param beAllowed YES means that user can ask question anonymously, otherwise not.
 */
- (void)onSinkQAAllowAskQuestionAnonymouslyNotification:(BOOL)beAllowed;

/*!
 @brief Callback event of the permission that attendee is allowed to view all questions is changed.
 @param beAllowed YES means that user can view all questions, otherwise not.
 */
- (void)onSinkQAAllowAttendeeViewAllQuestionNotification:(BOOL)beAllowed;

/*!
 @brief Callback event of the permission that attendee is allowed to submit questions is changed.
 @param beAllowed YES means that the user can submit questions, otherwise not.
 */
- (void)onSinkQAAllowAttendeeUpVoteQuestionNotification:(BOOL)beAllowed;

/*!
 @brief Callback event of the permission that user is allowed to answer questions is changed.
 @param beAllowed YES means that user can answer question, otherwise not.
 */
- (void)onSinkQAAllowAttendeeAnswerQuestionNotification:(BOOL)beAllowed;

/*!
 @brief Callback event that user joins a webinar which requires manual approval.
 @param registerURL The register URL.
 */
- (void)onSinkWebinarNeedRegister:(NSString * _Nonnull)registerURL;

/*!
 @brief Callback event that user joins a webinar which requires username and email.
 @param completion User needs to provide username and email to join meeting or cancel the join action.
 @warning In ZoomUI mode, user can implement this method to avoid Zoom's UI shown. Not implement this method, will shown the Zoom's UI.
 */
- (void)onSinkJoinWebinarNeedUserNameAndEmailWithCompletion:(BOOL (^_Nonnull)(NSString * _Nonnull username, NSString * _Nonnull email, BOOL cancel))completion;

/*!
 @brief The function will be invoked once the amount of panelist exceed the upper limit.
 */
- (void)onSinkPanelistCapacityExceed;

/*!
 @brief The function will be invoked once the amount of the attendee is promoted successfully from attendee to panelist.
 @param errorCode Promotion successful or error type.
 @warning Only meeting host/co-host can get the callback.
 */
- (void)onSinkPromptAttendee2PanelistResult:(MobileRTCWebinarPromoteorDepromoteError)errorCode;

/*!
 @brief The function will be invoked when panelist is demoted successfully from panelist to attendee.
 @param errorCode Demotion successful or error type.
 @warning Only meeting host/co-host can get the callback.
 */
- (void)onSinkDePromptPanelist2AttendeeResult:(MobileRTCWebinarPromoteorDepromoteError)errorCode;

/*!
 @brief The function will be invoked when the chat privilege of attendees changes.
 @param currentPrivilege The chat privilege of the current attendee.
 @warning only webinar meeting can get the callback.
 */
- (void)onSinkAllowAttendeeChatNotification:(MobileRTCChatAllowAttendeeChat)currentPrivilege;

/*!
 @brief When attendee agree or decline the promote invitation, host will receive this callback.
 @param agree, if attendee agree return true, otherwise false.
 @param userid, The attendee user id.
 */
- (void)onSinkAttendeePromoteConfirmResult:(BOOL)agree userId:(NSUInteger)userId;

/*!
@brief The function will be invoked when attendde allow to talk.
*/
- (void)onSinkSelfAllowTalkNotification;

/*!
@brief The function will be invoked when attendde disallow to talk.
*/
- (void)onSinkSelfDisallowTalkNotification;
@end

/*!
@brief The function will be invoked when attendde disallow to talk.
*/
@protocol MobileRTCLiveTranscriptionServiceDelegate <MobileRTCMeetingServiceDelegate>

@optional
/*!
@brief Sink the event of live transcription status.
@param status the live transcription status. For more details, see MobileRTCLiveTranscriptionStatus
*/
- (void)onSinkLiveTranscriptionStatus:(MobileRTCLiveTranscriptionStatus)status;

/*!
@brief Sink the event of receive the live transcription msg.
@param msg the received live transcription msg.
@param speakerId the speaker id of the received live transcription msg.
@param type the live transcription operation type, For more details, see MobileRTCLiveTranscriptionOperationType.
*/
- (void)onSinkLiveTranscriptionMsgReceived:(NSString *_Nonnull)msg speakerId:(NSUInteger)speakerId type:(MobileRTCLiveTranscriptionOperationType)type;

/*!
 @brief translation message error callback.
 @param speakingLanguage: an object of the speak message language.
 @param translationLanguage: an object of the message language you want to translate.
 */
- (void)onLiveTranscriptionMsgError:(MobileRTCLiveTranscriptionLanguage * _Nullable)speakLanguage
                 transcriptLanguage:(MobileRTCLiveTranscriptionLanguage * _Nullable)transcriptLanguage;

/*!
@brief Sink the event of request for start the live transcription. Only The HOST can retrieve this callback. You can aprrove request call start live transcription, or decline as do nothing.
@param requesterUserId the userid of the request from. If bAnonymous is TRUE, requesterUserId has no meanings.
@param bAnonymous TRUE means the request is anonymous.
*/
- (void)onSinkRequestForLiveTranscriptReceived:(NSUInteger)requesterUserId bAnonymous:(BOOL)bAnonymous;

@end

#pragma mark - MobileRTCCustomizedUIMeetingDelegate
/*!
 @protocol MobileRTCCustomizedUIMeetingDelegate
 @brief The class that conform to the MobileRTCCustomizedUIMeetingDelegate protocol can provide
        methods for tracking the In-Meeting Event and determining policy for each Event.
 @discussion The MobileRTCCustomizedUIMeetingDelegate protocol is required in the custom meeting UI view.
 */ 
@protocol MobileRTCCustomizedUIMeetingDelegate <NSObject>

@required
/*!
 @brief Notify user to create a custom in-meeting UI. 
 */
- (void)onInitMeetingView;

/*!
 @brief Notify user to destroy the custom in-meeting UI. 
 */
- (void)onDestroyMeetingView;

@end

#pragma mark - MobileRTCVideoRawDataDelegate
@class MobileRTCRenderer;
/*!
 @protocol MobileRTCVideoRawDataDelegate
 @brief This class is used to receive video raw data.
 @discussion The MobileRTCVideoRawDataDelegate protocol is required in the custom meeting UI view.
 */
@protocol MobileRTCVideoRawDataDelegate <NSObject>

@optional

/*!
 @brief This method is used to receive video's NV12 data(CVPixelBufferRef).
 @param pixelBuffer Video's CVPixelBufferRef data.
 @param renderer The MobileRTCRenderer’s object.
 */
- (void)onMobileRTCRender:(MobileRTCRenderer *_Nonnull)renderer
        framePixelBuffer:(CVPixelBufferRef _Nullable )pixelBuffer
                rotation:(MobileRTCVideoRawDataRotation)rotation;

/*!
 @brief This method is used to receive video's YUV420 data.
 @param rawData Video's YUV420 data.
 @param renderer The MobileRTCRenderer’s object.
 */
- (void)onMobileRTCRender:(MobileRTCRenderer *_Nonnull)renderer
            frameRawData:(MobileRTCVideoRawData *_Nonnull)rawData;

/*!
 @brief Callback event when the sender stop/start to sending raw data.
 @param renderer The MobileRTCRenderer’s object.
 @param on Raw data is sending or not.
 */
- (void)onMobileRTCRender:(MobileRTCRenderer *_Nonnull)renderer
          rawDataSending:(BOOL)on;

@end

#pragma mark - MobileRTCAudioRawDataDelegate
/*!
 @protocol MobileRTCAudioRawDataDelegate
 @brief This class is used to receive audio raw data.
 @discussion The MobileRTCAudioRawDataDelegate protocol is required in the custom meeting UI view.
 */
@protocol MobileRTCAudioRawDataDelegate <NSObject>

@optional

/*!
 @brief This method is used to receive audio mixed raw data.
 @param rawData Audio's raw data.
 */
- (void)onMobileRTCMixedAudioRawData:(MobileRTCAudioRawData *_Nonnull)rawData;

/*!
 @brief This method is used to receive each road user audio raw data.
 @param rawData Audio's raw data.
 */
- (void)onMobileRTCOneWayAudioAudioRawData:(MobileRTCAudioRawData *_Nonnull)rawData userId:(NSUInteger)userId;
@end

#pragma mark - MobileRTCPreProcessorDelegate
/*!
@protocol MobileRTCPreProcessorDelegate
@brief This class is used to preprocess rawdata data before rendering.
@discussion The MobileRTCPreProcessorDelegate protocol is required in the custom meeting UI view.
*/
@protocol MobileRTCPreProcessorDelegate <NSObject>

@optional
/*!
@brief This callback is used to preprocess video's YUV420 data before rendering receive.
@param rawData Video's YUV420 data.
*/
- (void)onPreProcessRawData:(MobileRTCPreProcessRawData *_Nonnull)rawData;

@end

#pragma mark - MobileRTCVideoSourceDelegate
/*!
@protocol MobileRTCVideoSourceDelegate
@brief This class is used to send your own video rawdata.
@discussion The MobileRTCVideoSourceDelegate protocol is required in the custom meeting UI view.
*/
@protocol MobileRTCVideoSourceDelegate <NSObject>

@optional
/*!
@brief This callback is used to send data for initialization.
@param rawDataSender please See MobileRTCVideoSender.
@param supportCapabilityArray support capability list.
@param suggestCapabilityItem suggest capability.
*/
- (void)onInitialize:(MobileRTCVideoSender *_Nonnull)rawDataSender supportCapabilityArray:(NSArray *_Nonnull)supportCapabilityArray suggestCapabilityItem:(MobileRTCVideoCapabilityItem *_Nonnull)suggestCapabilityItem;

/*!
@brief This callback is used to send data for initialization.
@param rawDataSender please See MobileRTCVideoSender.
@param supportCapabilityArray support capability list.
@param suggestCapabilityItem suggest capability.
*/
- (void)onPropertyChange:(NSArray *_Nonnull)supportCapabilityArray suggestCapabilityItem:(MobileRTCVideoCapabilityItem *_Nonnull)suggestCapabilityItem;

/*!
@brief This callback is used to start send data.
*/
- (void)onStartSend;

/*!
@brief This callback is used to stop send data.
*/
- (void)onStopSend;

/*!
@brief This callback is used to uninitialize send data.
*/
- (void)onUninitialized;

@end

#pragma mark - MobileRTCVideoSourceDelegate
/*!
@protocol MobileRTCVideoSourceDelegate
@brief This class is used to send your own share rawdata.
*/
@protocol MobileRTCShareSourceDelegate <NSObject>

@optional
/**
 * @brief Notify to start send share source.
 * @param sender The object of MobileRTCShareSender to send share source.
 */
- (void)onStartSend:(MobileRTCShareSender *_Nonnull)sender;

/**
 * @brief Notify to stop send share source.
 */
- (void)onStopSend;

@end

#pragma mark - MobileRTCAudioRawDataDelegate

@class MobileRTCRealNameCountryInfo;
@class MobileRTCRetrieveSMSHandler;
@class MobileRTCVerifySMSHandler;

/*!
 @protocol MobileRTCSMSServiceDelegate
 @brief This class is use to retrive and verify SMS.
 */
@protocol MobileRTCSMSServiceDelegate <NSObject>
@optional

/*!
 @brief This method will notify support country list for send SMS, privacy url, send SMS handle.
 @param supportCountryList, privacyUrl, retrieveHandle
 */
- (void)onNeedRealNameAuth:(NSArray<MobileRTCRealNameCountryInfo *> * _Nonnull)supportCountryList privacyURL:(NSString * _Nonnull)privacyUrl retrieveHandle:(MobileRTCRetrieveSMSHandler * _Nonnull)handle;

/*!
 @brief This method will notify the result of send SMS, and verify SMS handle.
 @param result, verifyHandle
 */
- (void)onRetrieveSMSVerificationCodeResultNotification:(MobileRTCSMSRetrieveResult)result verifyHandle:(MobileRTCVerifySMSHandler * _Nonnull)handler;

/*!
 @brief This method will notify the result verify SMS.
 @param result of verify SMS.
 */
- (void)onVerifySMSVerificationCodeResultNotification:(MobileRTCSMSVerifyResult)result;

@end

#pragma mark - MobileRTCBOServiceDelegate
@protocol MobileRTCBOServiceDelegate <MobileRTCMeetingServiceDelegate>

@optional
/*!
@brief This method will notify the creator role gived.
@param creator the creator role gived.
*/
- (void)onHasCreatorRightsNotification:(MobileRTCBOCreator *_Nonnull)creator;

/*!
@brief This method will notify the admin role gived.
@param admin the admin role gived.
*/
- (void)onHasAdminRightsNotification:(MobileRTCBOAdmin * _Nonnull)admin;

/*!
@brief This method will notify the assistent role gived.
@param assistant the assistant role gived.
*/
- (void)onHasAssistantRightsNotification:(MobileRTCBOAssistant * _Nonnull)assistant;

/*!
@brief This method will notify the attendee role gived.
@param attendee the attendee role gived.
*/
- (void)onHasAttendeeRightsNotification:(MobileRTCBOAttendee * _Nonnull)attendee;

/*!
@brief This method will notify the data helper role gived.
@param dataHelper the data helper role gived.
*/
- (void)onHasDataHelperRightsNotification:(MobileRTCBOData * _Nonnull)dataHelper;

/*!
@brief This method will notify that lost creator role.
*/
- (void)onLostCreatorRightsNotification;

/*!
@brief This method will notify that lost admin role.
*/
- (void)onLostAdminRightsNotification;

/*!
@brief This method will notify that lost assistant role.
*/
- (void)onLostAssistantRightsNotification;

/*!
@brief This method will notify that lost attendee role.
*/
- (void)onLostAttendeeRightsNotification;

/*!
@brief This method will notify that lost data helper role.
*/
- (void)onLostDataHelperRightsNotification;

/*!
@brief This method will notify that broadcast message.
@param broadcastMsg the broadcast message received from host.
@param senderID the SenderID.
*/
- (void)onNewBroadcastMessageReceived:(NSString *_Nullable)broadcastMsg senderID:(NSUInteger)senderID;

/*!
@brief When BOOption.countdownSeconds != MobileRTCBOStopCountDown_Not_CountDown, host stop BO and all users receive the event.
@param seconds, the countdown seconds.
@warning Please leaveBO when the countdown ends.
*/
- (void)onBOStopCountDown:(NSUInteger)seconds;

/*!
@brief When you are in BO, host invite you return to main session, you will receive the event.
@param hostName the host name.
@param replyHandler the handler to reply for the main session invitation.
*/
- (void)onHostInviteReturnToMainSession:(NSString *_Nullable)hostName replyHandler:(MobileRTCReturnToMainSessionHandler *_Nullable)replyHandler;

/*!
@brief When host change the BO status, all users receive the event.
@param status current status of BO.
*/
- (void)onBOStatusChanged:(MobileRTCBOStatus)status;
@end

#pragma mark - MobileRTCReactionServiceDelegate
@protocol MobileRTCReactionServiceDelegate <MobileRTCMeetingServiceDelegate>

@optional
/**
 * @brief Notify receive the emoji reaction.
 * @param userId The user id of the send emoji racetion.
 * @param type The send emoji racetion type.
 * @param skinTone The send emoji racetion skinstone.
 */
- (void)onEmojiReactionReceived:(NSUInteger)userId reactionType:(MobileRTCEmojiReactionType)type reactionSkinTone:(MobileRTCEmojiReactionSkinTone)skinTone;

/**
 * @brief Emoji reaction callback. This callback notifies the user when an emoji is received in the webinar.
 * @param type Specify the type of the received reaction.
 */
- (void)onEmojiReactionReceivedInWebinar:(MobileRTCEmojiReactionType)type;

@end


#pragma mark - MobileRTCBOServiceDelegate
@protocol MobileRTCBODataDelegate <MobileRTCMeetingServiceDelegate>
/*!
@brief The bo meeting information updated.
@param boId the identifier for the bo meeting.
*/
- (void)onBOInfoUpdated:(NSString *_Nullable)boId;

/*!
@brief The un-assigned user update.
*/
- (void)onUnAssignedUserUpdated;

@end

#pragma mark - MobileRTCBOServiceDelegate
@protocol MobileRTCBOAdminDelegate <MobileRTCMeetingServiceDelegate>

/*!
@brief admin received help request from userID
@param strUserID the identifier of the bo meeting user.
*/
- (void)onHelpRequestReceived:(NSString *_Nullable)strUserID;

/*!
@brief admin received error when start BO failed
@param errType the error type defail of the failure.
*/
- (void)onStartBOError:(MobileRTCBOControllerError)errType;

/*!
 @brief if it's timer BO, after start BO, you will receive the event.
 @param remaining remaining time,
 @param isTimesUpNotice true: when time is up, auto stop BO. false: don't auto stop BO.
 */
- (void)onBOEndTimerUpdated:(NSUInteger)remaining isTimesUpNotice:(BOOL)isTimesUpNotice;

@end

#pragma mark - MobileRTCBOServiceDelegate
@protocol MobileRTCBOAttendeeDelegate <MobileRTCMeetingServiceDelegate>

/*!
@brief received the result of sending help request
@param eResult the response result for the help request.
*/
- (void)onHelpRequestHandleResultReceived:(MobileRTCBOHelpReply)eResult;

/*!
@brief host join current bo meeting.
*/
- (void)onHostJoinedThisBOMeeting;

/*!
@brief host left current bo meeting.
*/
- (void)onHostLeaveThisBOMeeting;

@end

#pragma mark - MobileRTCBOServiceDelegate
@protocol MobileRTCBOCreatorDelegate <MobileRTCMeetingServiceDelegate>

/*!
@brief creator received BO identifier when create BO success
@param BOID the identifier of the created bo.
*/
- (void)onBOCreateSuccess:(NSString *_Nullable)BOID;

@end
