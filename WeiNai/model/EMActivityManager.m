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

@end
