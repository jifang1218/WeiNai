//
//  EMActivityManager.m
//  WeiNai
//
//  Created by Ji Fang on 7/18/15.
//  Copyright (c) 2015 Ji Fang. All rights reserved.
//

#import "EMActivityManager.h"
#import "EMDayRecord.h"
#import "EMDBManager.h"
#import "NSDate+Category.h"

static EMActivityManager *_sharedInstance = nil;

@interface EMActivityManager() {
    EMDayRecord *_today;
}

@end

@implementation EMActivityManager

+ (EMActivityManager *)sharedInstance {
    if (_sharedInstance == nil) {
        @synchronized(self) {
            _sharedInstance = [[EMActivityManager alloc] init];
        }
    }
    
    return _sharedInstance;
}

- (id)init {
    if (self=[super init]) {
        EMDBManager *dbman = [EMDBManager sharedInstance];
        NSDateComponents *today = [[NSDateComponents alloc] init];
        NSDate *now = [NSDate date];
        today.year = now.year;
        today.month = now.month;
        today.day = now.day;
        
        _today = [dbman dayRecordAt:today];
    }
    
    return self;
}

#pragma mark - record operations
- (EMDayRecord *)todayRecord {
    EMDayRecord *ret = nil;
    
    ret = _today;
    
    return ret;
}

- (EMDayRecord *)dayRecordAt:(NSDateComponents *)date {
    EMDayRecord *ret = nil;
    
    EMDBManager *dbman = [EMDBManager sharedInstance];
    ret = [dbman dayRecordAt:date];
    
    return ret;
}

- (NSArray *)dayRecordsFrom:(NSDateComponents *)from
                         to:(NSDateComponents *)to {
    NSArray *ret = nil;
    
    EMDBManager *dbman = [EMDBManager sharedInstance];
    ret = [dbman dayRecordsFrom:from to:to];
    
    return ret;
}

- (BOOL)addDayRecord:(EMDayRecord *)dayRecord {
    BOOL ret = NO;
    
    EMDBManager *dbman = [EMDBManager sharedInstance];
    ret = [dbman insertDayRecord:dayRecord];
    
    return ret;
}

- (BOOL)removeDayRecord:(NSDateComponents *)date {
    BOOL ret = NO;
    
    EMDBManager *dbman = [EMDBManager sharedInstance];
    ret = [dbman deleteDayRecordAtDay:date];
    
    return ret;
}

- (EMDayRecord *)createEmptyDayRecord {
    EMDayRecord *ret = nil;
    
    ret = [[EMDayRecord alloc] init];
    [self addDayRecord:ret];
    
    return ret;
}

#pragma mark - activity helpers
- (NSUInteger)numberOfActivityTypes {
    return ActivityType_NumberOfActivityTypes;
}

- (NSString *)ActivityType2String:(EMActivityType)activityType {
    NSString *ret = nil;
    switch (activityType) {
        case ActivityType_Excrement: {
            ret = @"便便";
        } break;
        case ActivityType_Milk: {
            ret = @"喂奶";
        } break;
        case ActivityType_Piss: {
            ret = @"尿尿";
        } break;
        case ActivityType_Sleep: {
            ret = @"睡觉";
        } break;
        default: {
        } break;
    }
    
    return ret;
}

- (NSString *)ActivityTypeUnit2String:(EMActivityType)activityType {
    NSString *ret = nil;
    switch (activityType) {
        case ActivityType_Excrement: {
            ret = @"克";
        } break;
        case ActivityType_Milk: {
            ret = @"毫升";
        } break;
        case ActivityType_Piss: {
            ret = @"毫升";
        } break;
        case ActivityType_Sleep: {
            ret = @"分钟";
        } break;
        default: {
        } break;
    }
    
    return ret;
}

- (BOOL)save {
    BOOL ret = NO;
    
    EMDBManager *dbman = [EMDBManager sharedInstance];
    ret = [dbman save];
    
    return ret;
}

@end
