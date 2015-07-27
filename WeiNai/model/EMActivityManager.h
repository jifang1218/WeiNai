//
//  EMActivityManager.h
//  WeiNai
//
//  Created by Ji Fang on 7/18/15.
//  Copyright (c) 2015 Ji Fang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EMDayRecord.h"
#import "UIMacros.h"

@protocol EMActivityManagerDelegate <NSObject>

@optional
- (void)didDayRecordChanged:(EMDayRecord *)dayRecord;

@end

@interface EMActivityManager : NSObject<EMDayRecordDelegate>

+ (EMActivityManager *)sharedInstance;
- (void)addDelegate:(id<EMActivityManagerDelegate>)delegate;
- (void)removeDelegate:(id<EMActivityManagerDelegate>)delegate;

#pragma mark - record operations
- (EMDayRecord *)todayRecord;
- (EMDayRecord *)dayRecordAt:(NSDateComponents *)date;
- (NSArray *)dayRecordsFrom:(NSDateComponents *)from
                         to:(NSDateComponents *)to;
- (NSArray *)allDayRecords;
- (BOOL)addDayRecord:(EMDayRecord *)dayRecord;
- (BOOL)removeDayRecord:(NSDateComponents *)date;

#pragma mark - activity helpers
- (NSUInteger)numberOfActivityTypes;
- (NSString *)ActivityType2String:(EMActivityType)activityType;
- (NSString *)ActivityTypeUnit2String:(EMActivityType)activityType;

#pragma mark - period helpers
- (NSString *)PeriodType2String:(EMDayRecordsPeriod)period;

#pragma mark - db
- (BOOL)save;

@end
