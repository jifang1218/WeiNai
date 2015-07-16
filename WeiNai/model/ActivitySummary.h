//
//  ActivitySummary.h
//  WeiNai
//
//  Created by Ji Fang on 7/15/15.
//  Copyright (c) 2015 Ji Fang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIMacros.h"

@class EMDayRecord;
@class EMMilk;
@class EMExcrement;
@class EMPiss;
@class EMSleep;

@protocol ActivitySummaryDelegate <NSObject>

@optional

@end

@interface ActivitySummary : NSObject

@property (nonatomic, weak) id<ActivitySummaryDelegate> delegate;

- (EMDayRecord *)todayRecord;
- (EMDayRecord *)recordAtDay:(NSDateComponents *)day;

- (EMMilk *)milkSummary;
- (EMExcrement *)excrementSummary;
- (EMPiss *)pissSummary;
- (EMSleep *)sleepSummary;

- (NSString *)activityType2String:(EMActivityType)activityType;
- (NSString *)activityTypeUnit2String:(EMActivityType)activityType;

@end

