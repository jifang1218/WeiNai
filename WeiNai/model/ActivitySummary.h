//
//  ActivitySummary.h
//  WeiNai
//
//  Created by Ji Fang on 7/15/15.
//  Copyright (c) 2015 Ji Fang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class EMDayRecord;

@protocol ActivitySummaryDelegate <NSObject>

@optional

@end

@interface ActivitySummary : NSObject

@property (nonatomic, weak) id<ActivitySummaryDelegate> delegate;

- (EMDayRecord *)todayRecord;
- (EMDayRecord *)recordAtDay:(NSDateComponents *)day;

@end

