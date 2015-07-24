//
//  ActivitySummary.m
//  WeiNai
//
//  Created by Ji Fang on 7/15/15.
//  Copyright (c) 2015 Ji Fang. All rights reserved.
//

#import "ActivitySummary.h"
#import "EMActivityManager.h"
#import "EMDayRecord.h"
#import "EMMilk.h"
#import "EMExcrement.h"
#import "EMPiss.h"
#import "EMSleep.h"
#import "EMActivityManager.h"
#import "Utility.h"

@interface ActivitySummary()<EMActivityManagerDelegate> {
}

@end

@implementation ActivitySummary

@synthesize delegate = _delegate;
@synthesize dayRecord = _dayRecord;

- (id)init {
    if (self=[super init]) {
        EMActivityManager *activityman = [EMActivityManager sharedInstance];
        [activityman addDelegate:self];
    }
    
    return self;
}

- (void)dealloc {
    EMActivityManager *activityman = [EMActivityManager sharedInstance];
    [activityman removeDelegate:self];
}

- (void)setDayRecord:(EMDayRecord *)dayRecord {
    _dayRecord = dayRecord;
    EMActivityManager *activityman = [EMActivityManager sharedInstance];
    _dayRecord.delegate = activityman;
}

- (NSString *)dateString {
    NSString *ret = nil;
    
    ret = [Utility dateComponentsString:_dayRecord.date];
    
    return ret;
}

- (EMMilk *)milkSummary {
    EMMilk *ret = nil;
    
    if (!_dayRecord) {
        return ret;
    }
    
    NSArray *milks = _dayRecord.milks;
    NSUInteger ml = 0;
    for (EMMilk *milk in milks) {
        ml += milk.ml;
    }
    
    ret = [[EMMilk alloc] init];
    ret.ml = ml;

    return ret;
}

- (EMExcrement *)excrementSummary {
    EMExcrement *ret = nil;
    
    if (!_dayRecord) {
        return ret;
    }
    
    NSArray *excrements = _dayRecord.excrements;
    NSUInteger g = 0;
    for (EMExcrement *excrement in excrements) {
        g += excrement.g;
    }
    
    ret = [[EMExcrement alloc] init];
    ret.g = g;
    
    return ret;
}

- (EMPiss *)pissSummary {
    EMPiss *ret = nil;
    
    if (!_dayRecord) {
        return ret;
    }
    
    NSArray *pisses = _dayRecord.pisses;
    NSUInteger ml = 0;
    for (EMPiss *piss in pisses) {
        ml += piss.ml;
    }
    
    ret = [[EMPiss alloc] init];
    ret.ml = ml;
    
    return ret;
}

- (EMSleep *)sleepSummary {
    EMSleep *ret = nil;
    
    if (!_dayRecord) {
        return ret;
    }
    
    NSArray *sleeps = _dayRecord.sleeps;
    NSUInteger duration = 0;
    for (EMSleep *sleep in sleeps) {
        duration += sleep.durationInMinutes;
    }
    
    ret = [[EMSleep alloc] init];
    ret.durationInMinutes = duration;
    
    return ret;
}

- (NSString *)activityType2String:(EMActivityType)activityType {
    NSString *ret = nil;
    
    EMActivityManager *activityMgr = [EMActivityManager sharedInstance];
    ret = [activityMgr ActivityType2String:activityType];
    
    return ret;
}

- (NSString *)activityTypeUnit2String:(EMActivityType)activityType {
    NSString *ret = nil;
    
    EMActivityManager *activityMgr = [EMActivityManager sharedInstance];
    ret = [activityMgr ActivityTypeUnit2String:activityType];
    
    return ret;
}

#pragma mark - activity manager delegate
- (void)didDayRecordChanged:(EMDayRecord *)dayRecord {
    if ([_delegate respondsToSelector:@selector(didDayRecordChanged:)]) {
        [_delegate didDayRecordChanged:dayRecord];
    }
}

@end
