//
//  ActivityList.m
//  WeiNai
//
//  Created by Ji Fang on 7/23/15.
//  Copyright (c) 2015 Ji Fang. All rights reserved.
//

#import "ActivityList.h"
#import "EMActivityManager.h"
#import "EMDayRecord.h"
#import "EMSleep.h"
#import "EMMilk.h"
#import "EMPiss.h"
#import "EMExcrement.h"

@interface ActivityList()<EMActivityManagerDelegate> {
    NSArray *_allDayRecords;
}

- (void)sortAllDayRecords;

@end

@implementation ActivityList

@synthesize delegate = _delegate;

- (id)init {
    if (self=[super init]) {
        EMActivityManager *activityman = [EMActivityManager sharedInstance];
        [activityman addDelegate:self];
        [self sortAllDayRecords];
    }
    
    return self;
}

- (void)dealloc {
    EMActivityManager *activityman = [EMActivityManager sharedInstance];
    [activityman removeDelegate:self];
}

- (void)sortAllDayRecords {
    EMActivityManager *activityman = [EMActivityManager sharedInstance];
    NSArray *all = [activityman allDayRecords];
    NSArray *sortedAll = [all sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        EMDayRecord *record1 = (EMDayRecord *)obj1;
        EMDayRecord *record2 = (EMDayRecord *)obj2;
        if (record1.date.year > record2.date.year) {
            return NSOrderedAscending;
        } else if (record1.date.year == record2.date.year) {
            if (record1.date.month > record2.date.month) {
                return NSOrderedAscending;
            } else if (record1.date.month == record2.date.month) {
                if (record1.date.day > record2.date.day) {
                    return NSOrderedAscending;
                } else if (record1.date.day == record2.date.day) {
                    return NSOrderedSame;
                } else {
                    return NSOrderedDescending;
                }
            } else {
                return NSOrderedDescending;
            }
        } else {
            return NSOrderedDescending;
        }
    }];
    _allDayRecords = sortedAll;
}

- (NSArray *)allDayRecords {
    NSArray *ret = nil;
    
    ret = _allDayRecords;
    
    return ret;
}

- (NSString *)dayRecordSummaryAtIndex:(NSInteger)index {
    NSString *ret = nil;
    
    if (index >= _allDayRecords.count) {
        return ret;
    }
    
    EMDayRecord *dayRecord = [_allDayRecords objectAtIndex:index];
    
    // handle date
    NSString *strDate = [[NSString alloc] initWithFormat:@"%lu/%lu/%lu",
                         dayRecord.date.year, dayRecord.date.month, dayRecord.date.day];
    
    EMActivityManager *activityman = [EMActivityManager sharedInstance];
    
    // handle sleep
    NSString *strSleep = [activityman ActivityType2String:ActivityType_Sleep];
    NSString *strSleepUnit = [activityman ActivityTypeUnit2String:ActivityType_Sleep];
    NSUInteger totalSleepDurations = 0;
    NSArray *sleeps = dayRecord.sleeps;
    for (EMSleep *sleep in sleeps) {
        totalSleepDurations += sleep.durationInMinutes;
    }
    
    // handle piss
    NSString *strPiss = [activityman ActivityType2String:ActivityType_Piss];
    NSString *strPissUnit = [activityman ActivityTypeUnit2String:ActivityType_Piss];
    NSUInteger totalPissMLs = 0;
    NSArray *pisses = dayRecord.pisses;
    for (EMPiss *piss in pisses) {
        totalPissMLs += piss.ml;
    }
    
    // handle excrement
    NSString *strExcrement = [activityman ActivityType2String:ActivityType_Excrement];
    NSString *strExcrementUnit = [activityman ActivityTypeUnit2String:ActivityType_Excrement];
    NSUInteger totalGs = 0;
    NSArray *excrements = dayRecord.excrements;
    for (EMExcrement *excrement in excrements) {
        totalGs += excrement.g;
    }
    
    // handle milk
    NSString *strMilk = [activityman ActivityType2String:ActivityType_Milk];
    NSString *strMilkUnit = [activityman ActivityTypeUnit2String:ActivityType_Milk];
    NSUInteger totalMilkMLs = 0;
    NSArray *milks = dayRecord.milks;
    for (EMMilk *milk in milks) {
        totalMilkMLs += milk.ml;
    }
    ret = [[NSString alloc] initWithFormat:@"%@   %@: %lu %@   %@: %lu %@   %@: %lu %@   %@: %lu %@",
           strDate,
           strSleep, totalSleepDurations, strSleepUnit,
           strPiss, totalPissMLs, strPissUnit,
           strMilk, totalMilkMLs, strMilkUnit,
           strExcrement, totalGs, strExcrementUnit];
    
    return ret;
}

- (void)didDayRecordChanged:(EMDayRecord *)dayRecord {
    if ([_delegate respondsToSelector:@selector(didActivitiesChanged:)]) {
        [self sortAllDayRecords];
        [_delegate didActivitiesChanged:_allDayRecords];
    }
}

@end
