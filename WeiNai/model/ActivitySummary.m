//
//  ActivitySummary.m
//  WeiNai
//
//  Created by Ji Fang on 7/15/15.
//  Copyright (c) 2015 Ji Fang. All rights reserved.
//

#import "ActivitySummary.h"
#import "EMDBManager.h"
#import "EMDayRecord.h"
#import "EMMilk.h"
#import "EMExcrement.h"
#import "EMPiss.h"
#import "EMSleep.h"

@interface ActivitySummary() {
    EMDayRecord *_record;
}

@end

@implementation ActivitySummary

@synthesize delegate;

- (EMDayRecord *)todayRecord {
    EMDayRecord *ret = nil;
    
    EMDBManager *dbman = [EMDBManager sharedInstance];
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    comps = [calendar components:unitFlags
                        fromDate:date];
    ret = [dbman dayRecordAt:comps];
    _record = ret;
    
    return ret;
}

- (EMDayRecord *)recordAtDay:(NSDateComponents *)day {
    EMDayRecord *ret = nil;
    
    // validation
    if (!day.year || !day.month || !day.day) {
        return ret;
    }
    
    EMDBManager *dbman = [EMDBManager sharedInstance];
    ret = [dbman dayRecordAt:day];
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
    float kg = 0;
    for (EMExcrement *excrement in excrements) {
        kg += excrement.kg;
    }
    
    ret = [[EMExcrement alloc] init];
    ret.kg = kg;
    
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

@end
