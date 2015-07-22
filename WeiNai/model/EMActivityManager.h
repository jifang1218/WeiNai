//
//  EMActivityManager.h
//  WeiNai
//
//  Created by Ji Fang on 7/18/15.
//  Copyright (c) 2015 Ji Fang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIMacros.h"

@class EMDayRecord;

@interface EMActivityManager : NSObject

+ (EMActivityManager *)sharedInstance;

#pragma mark - record operations
- (EMDayRecord *)todayRecord;
- (EMDayRecord *)dayRecordAt:(NSDateComponents *)date;
- (EMDayRecord *)dayRecordsFrom:(NSDateComponents *)from
                             to:(NSDateComponents *)to;
- (BOOL)addDayRecord:(EMDayRecord *)dayRecord;
- (BOOL)removeDayRecord:(NSDateComponents *)date;
- (EMDayRecord *)createEmptyDayRecord;

#pragma mark - activity helpers
- (NSUInteger)numberOfActivityTypes;
- (NSString *)ActivityType2String:(EMActivityType)activityType;
- (NSString *)ActivityTypeUnit2String:(EMActivityType)activityType;

#pragma mark - db
- (BOOL)save;

@end
