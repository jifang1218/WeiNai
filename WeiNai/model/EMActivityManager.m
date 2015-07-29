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
#import "EMGCDMulticastDelegate.h"

#define TEST 1

#if TEST
#import "EMSleep.h"
#import "EMBreastMilk.h"
#import "EMPowderMilk.h"
#import "EMExcrement.h"
#import "EMPiss.h"
#endif

static EMActivityManager *_sharedInstance = nil;

@interface EMActivityManager() {
    EMDayRecord *_today;
    EMGCDMulticastDelegate<EMActivityManagerDelegate> *_delegates;
    EMDBManager *_dbman;
}

#if TEST
- (void)fakedata;
#endif

@end

@implementation EMActivityManager

@synthesize settings = _settings;

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
        _delegates = (EMGCDMulticastDelegate<EMActivityManagerDelegate> *)[[EMGCDMulticastDelegate alloc] init];
        _dbman = [[EMDBManager alloc] init];
        NSDateComponents *today = [[NSDateComponents alloc] init];
        NSDate *now = [NSDate date];
        today.year = now.year;
        today.month = now.month;
        today.day = now.day;
        _today = [_dbman dayRecordAt:today];
        _settings = _dbman.settings;
    }
    
    return self;
}

- (void)addDelegate:(id<EMActivityManagerDelegate>)delegate {
    [_delegates addDelegate:delegate
              delegateQueue:dispatch_get_main_queue()];
}

- (void)removeDelegate:(id<EMActivityManagerDelegate>)delegate {
    [_delegates removeDelegate:delegate];
}

#if TEST
- (void)fakedata {
    NSDateComponents *today = [[NSDateComponents alloc] init];
    NSDate *now = [NSDate date];
    today.year = now.year;
    today.month = now.month;
    today.day = now.day;
    _today.date = today;
    
    for (int i=0; i<10; ++i) {
        // sleep
        EMSleep *sleep = [[EMSleep alloc] init];
        NSDateComponents *time = [[NSDateComponents alloc] init];
        NSDate *now = [NSDate date];
        time.year = now.year;
        time.month = now.month;
        time.day = now.day;
        time.hour = 9 + i;
        time.minute = 10;
        sleep.time = time;
        sleep.quality = SleepQuality_Medium;
        sleep.durationInMinutes = 10 + i*10;
        [_today addActivity:sleep];
        
        // milk
        EMBreastMilk *milk = [[EMBreastMilk alloc] init];
        time = [[NSDateComponents alloc] init];
        time.year = now.year;
        time.month = now.month;
        time.day = now.day;
        time.hour = 9 + i;
        time.minute = 10;
        milk.time = time;
        milk.ml = 10 + i*10;
        milk.person = @"王坤";
        [_today addActivity:milk];
        
        // piss
        EMPiss *piss = [[EMPiss alloc] init];
        time = [[NSDateComponents alloc] init];
        time.year = now.year;
        time.month = now.month;
        time.day = now.day;
        time.hour = 9 + i;
        time.minute = 10;
        piss.time = time;
        piss.ml = 10 + i*10;
        [_today addActivity:piss];
        
        // excrement
        EMExcrement *excrement = [[EMExcrement alloc] init];
        time = [[NSDateComponents alloc] init];
        time.year = now.year;
        time.month = now.month;
        time.day = now.day;
        time.hour = 9 + i;
        time.minute = 10;
        excrement.time = time;
        excrement.g = 10 + i*10;
        [_today addActivity:excrement];
    }
    [self save];
}
#endif

#pragma mark - record operations
- (EMDayRecord *)todayRecord {
    EMDayRecord *ret = nil;
    if (!_today) {
        _today = [[EMDayRecord alloc] init];
        NSDateComponents *date = [[NSDateComponents alloc] init];
        NSDate *now = [NSDate date];
        date.year = now.year;
        date.month = now.month;
        date.day = now.day;
        _today.date = date;
#if TEST
        [self fakedata];
#endif
        [self addDayRecord:_today];
    }
    ret = _today;
    
    return ret;
}

- (EMDayRecord *)dayRecordAt:(NSDateComponents *)date {
    EMDayRecord *ret = nil;
    
    ret = [_dbman dayRecordAt:date];
    
    return ret;
}

- (NSArray *)dayRecordsFrom:(NSDateComponents *)from
                         to:(NSDateComponents *)to {
    NSArray *ret = nil;
    
    ret = [_dbman dayRecordsFrom:from
                              to:to];
    
    return ret;
}

- (NSArray *)allDayRecords {
    NSArray *ret = nil;
    
    ret = [_dbman allDayRecords];
    
    return ret;
}

- (BOOL)addDayRecord:(EMDayRecord *)dayRecord {
    BOOL ret = NO;
    
    ret = [_dbman insertDayRecord:dayRecord];
    if (ret) {
        dayRecord.delegate = self;
        [_delegates didDayRecordChanged:dayRecord];
    }
    
    return ret;
}

- (BOOL)removeDayRecord:(NSDateComponents *)date {
    BOOL ret = NO;
    
    EMDayRecord *dayRecord = [_dbman dayRecordAt:date];
    ret = [_dbman deleteDayRecordAtDay:date];
    if (ret) {
        [_delegates didDayRecordChanged:dayRecord];
        dayRecord.delegate = nil;
    }
    
    
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

#pragma mark - period helpers
- (NSString *)PeriodType2String:(EMDayRecordsPeriod)period {
    NSString *ret = nil;
    
    switch (period) {
        case DayRecordsPeriod_Week: {
            ret = @"最近一周";
        } break;
        case DayRecordsPeriod_3Weeks: {
            ret = @"最近三周";
        } break;
        case DayRecordsPeriod_Month: {
            ret = @"最近一月";
        } break;
        case DayRecordsPeriod_3Month: {
            ret = @"最近三月";
        } break;
        default: {
        } break;
    }

    return ret;
}

- (BOOL)save {
    BOOL ret = NO;
    
    ret = [_dbman save];
    
    return ret;
}

#pragma mark - EMDayRecordDelegate
- (void)didActivityChanged:(EMActivityBase *)activity inDayRecord:(EMDayRecord *)dayRecord {
    [_delegates didDayRecordChanged:dayRecord];
}

@end
