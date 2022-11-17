//
//  MobileRTCMeetingService+Reaction.h
//  MobileRTC
//
//  Created by Zoom Video Communications on 2020/12/3.
//  Copyright © 2020 Zoom Video Communications, Inc. All rights reserved.
//

#import <MobileRTC/MobileRTC.h>

NS_ASSUME_NONNULL_BEGIN


@interface MobileRTCMeetingService (Reaction)

/**
 * @brief Determine if the Reaction feature is enabled.
 * @return YES means Reaction feature is enable,otherwise not.
 */
- (BOOL)isEmojiReactionEnabled;

/**
 * @brief Send emoji reaction.
 * @param type The type of the emoji reaction.
 * @param skinTone The skintone of the emoji reaction
 * @return If the function succeeds, it will return MobileRTCMeetError_Success, otherwise not.
 */
- (MobileRTCMeetError)sendEmojiReaction:(MobileRTCEmojiReactionType)type reactionSkinTone:(MobileRTCEmojiReactionSkinTone)skinTone;


@end

NS_ASSUME_NONNULL_END
