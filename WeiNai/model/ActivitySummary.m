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
#import "ActivityUtils.h"

@interface ActivitySummary() {
    EMDayRecord *_record;
}

@end

@implementation ActivitySummary

@synthesize delegate;

- (EMDayRecord *)todayRecord {
    EMDayRecord *ret = nil;
    
    EMActivityManager *activityMan = [EMActivityManager sharedInstance];
    ret = [activityMan todayRecord];
    _record = ret;
    
    return ret;
}

- (EMDayRecord *)recordAtDay:(NSDateComponents *)day {
    EMDayRecord *ret = nil;
    
    // validation
    if (!day.year || !day.month || !day.day) {
        return ret;
    }
    
    EMActivityManager *activityMan = [EMActivityManager sharedInstance];
    ret = [activityMan dayRecordAt:day];
    _record = ret;
    
    return ret;
}

- (EMMilk *)milkSummary {
    EMMilk *ret = nil;
    
    if (!_record) {
        return ret;
    }
    
    NSArray *milks = _record.milks;
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
    
    if (!_record) {
        return ret;
    }
    
    NSArray *excrements = _record.excrements;
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
    
    if (!_record) {
        return ret;
    }
    
    NSArray *pisses = _record.pisses;
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
    
    if (!_record) {
        return ret;
    }
    
    NSArray *sleeps = _record.sleeps;
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
    
    ret = [ActivityUtils ActivityType2String:activityType];
    
    return ret;
}

- (NSString *)activityTypeUnit2String:(EMActivityType)activityType {
    NSString *ret = nil;
    
    ret = [ActivityUtils ActivityTypeUnit2String:activityType];
    
    return ret;
}

@end
