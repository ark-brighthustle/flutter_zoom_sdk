//
//  MobileRTCMeetingService+RawArchiving.h
//  MobileRTC
//
//  Created by Zoom Video Communications on 2022/7/25.
//  Copyright © 2022 Zoom Video Communications, Inc. All rights reserved.
//

#import <MobileRTC/MobileRTC.h>

@interface MobileRTCMeetingService (RawArchiving)

/**
 * @brief start raw archiving,call this method can get rawdata receive previlege.
 * @return If the function succeeds, the return value is YES. Otherwise failed.
 */
- (BOOL)startRawArchiving;

/**
 * @brief stop raw archiving, call this method reclaim rawdata receive previlege.
 * @return If the function succeeds, the return value is YES. Otherwise failed.
 */
- (BOOL)stopRawArchiving;

@end

