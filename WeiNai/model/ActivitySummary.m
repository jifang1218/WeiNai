//
//  ActivitySummary.m
//  WeiNai
//
//  Created by Ji Fang on 7/15/15.
//  Copyright (c) 2015 Ji Fang. All rights reserved.
//

#import "ActivitySummary.h"
#import "EMDBManager.h"

@implementation ActivitySummary

@synthesize delegate;

- (EMDayRecord *)todayRecord {
    EMDayRecord *ret = nil;
    
    EMDBManager *dbman = [EMDBManager sharedInstance];
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    comps = [calendar components:unitFlags fromDate:date];
    ret = [dbman dayRecordAt:comps];
    
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
    
    return ret;
}

@end
