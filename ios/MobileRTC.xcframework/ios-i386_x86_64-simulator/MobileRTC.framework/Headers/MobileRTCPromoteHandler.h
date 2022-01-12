//
//  MobileRTCPromoteHandler.h
//  MobileRTC
//
//  Created by Zoom Video Communications on 2021/7/27.
//  Copyright © 2021 Zoom Video Communications, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 @brief brief promote handler.
 */
@interface MobileRTCPromoteHandler : NSObject

/*!
 @brief Stay as attendee.
 */
- (void)stayAsAttendee;

/*!
 @brief Join as panelist.
 */
- (void)joinAsPanelist;

@end

