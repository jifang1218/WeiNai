//
//  DayRecordsChart.m
//  WeiNai
//
//  Created by Ji Fang on 7/27/15.
//  Copyright (c) 2015 Ji Fang. All rights reserved.
//

#import "DayRecordsChart.h"
#import "EMActivityManager.h"
#import "EMBreastMilk.h"
#import "EMPowderMilk.h"
#import "EMSleep.h"
#import "EMExcrement.h"
#import "EMPiss.h"
#import "Utility.h"
#import "NSDate+Category.h"

@interface DayRecordsChart () {
}

- (void)reloadDataPXArray:(NSArray **)pXArray
                  pYArray:(NSArray **)pYArray;

@end

@implementation DayRecordsChart

@synthesize delegate = _delegate;
@synthesize activityType = _activityType;
@synthesize period = _period;

- (id)init {
    if (self=[super init]) {
        _activityType = ActivityType_Sleep;
        _period = DayRecordsPeriod_Week;
    }
    
    return self;
}

- (void)setActivityType:(EMActivityType)activityType {
    if (_activityType != activityType) {
        _activityType = activityType;
        
        if ([_delegate respondsToSelector:@selector(didActivityTypeChanged:)]) {
            [_delegate didActivityTypeChanged:_activityType];
        }
        
        NSArray *xArray = nil;
        NSArray *yArray = nil;
        [self reloadDataPXArray:&xArray pYArray:&yArray];
        if ([_delegate respondsToSelector:@selector(didDatasourceChangedXArray:yArray:)]) {
            [_delegate didDatasourceChangedXArray:xArray yArray:yArray];
        }
    }
}

- (void)setPeriod:(EMDayRecordsPeriod)period {
    if (_period != period) {
        _period = period;
        
        if ([_delegate respondsToSelector:@selector(didDayRecordsPeriodChanged:)]) {
            [_delegate didDayRecordsPeriodChanged:_period];
        }
        
        NSArray *xArray = nil;
        NSArray *yArray = nil;
        [self reloadDataPXArray:&xArray pYArray:&yArray];
        if ([_delegate respondsToSelector:@selector(didDatasourceChangedXArray:yArray:)]) {
            [_delegate didDatasourceChangedXArray:xArray yArray:yArray];
        }
    }
}

- (void)reloadDataPXArray:(NSArray **)pXArray pYArray:(NSArray **)pYArray {
    EMActivityManager *activityman = [EMActivityManager sharedInstance];
    NSDateComponents *to = activityman.todayRecord.date;
    NSDateComponents *from = [[NSDateComponents alloc] init];
    
    NSDate *toDate = [NSDate date];
    NSDate *fromDate = nil;
    switch (_period) {
        case DayRecordsPeriod_Week: {
            fromDate = [toDate dateBySubtractingDays:7];
            from.year = fromDate.year;
            from.month = fromDate.month;
            from.day = fromDate.day;
        } break;
        case DayRecordsPeriod_3Weeks: {
            fromDate = [toDate dateBySubtractingDays:3*7];
            from.year = fromDate.year;
            from.month = fromDate.month;
            from.day = fromDate.day;
        } break;
        case DayRecordsPeriod_Month: {
            if ((to.month - 1) <= 0) {
                from.year = to.year - 1;
                from.month = to.month - 1 + 12;
            } else {
                from.year = to.year;
                from.month = to.month - 1;
            }
            from.day = to.day;
        } break;
        case DayRecordsPeriod_3Month: {
            if ((to.month - 3) <=0) {
                from.year = to.year -1;
                from.month = to.month - 3 + 12;
            } else {
                from.year = to.year;
                from.month = to.month -3;
            }
            from.day = to.day;
        } break;
        default: {
        } break;
    }
    
    NSArray *dayRecords = [activityman dayRecordsFrom:from
                                                   to:to];
    NSMutableArray *xArray = [[NSMutableArray alloc] initWithCapacity:dayRecords.count];
    NSMutableArray *yArray = [[NSMutableArray alloc] initWithCapacity:dayRecords.count];
    for (EMDayRecord *dayRecord in dayRecords) {
        NSArray *activities = nil;
        switch (_activityType) {
            case ActivityType_Milk: {
                activities = dayRecord.milks;
            } break;
            case ActivityType_Excrement: {
                activities = dayRecord.excrements;
            } break;
            case ActivityType_Piss: {
                activities = dayRecord.pisses;
            } break;
            case ActivityType_Sleep: {
                activities = dayRecord.sleeps;
            } break;
            default: {
            } break;
        }
        NSUInteger dayTotal = 0;
        switch (_activityType) {
            case ActivityType_Milk: {
                for (EMMilk *milk in activities) {
                    dayTotal += milk.ml;
                }
            } break;
            case ActivityType_Excrement: {
                for (EMExcrement *excrement in activities) {
                    dayTotal += excrement.g;
                }
            } break;
            case ActivityType_Piss: {
                for (EMPiss *piss in activities) {
                    dayTotal += piss.ml;
                }
            } break;
            case ActivityType_Sleep: {
                for (EMSleep *sleep in activities) {
                    dayTotal += sleep.durationInMinutes;
                }
            } break;
            default: {
            } break;
        }
        NSDateComponents *date = dayRecord.date;
        NSString *strDate = [Utility compactDateComponentsString:date];
        [xArray addObject:strDate];
        NSNumber *dayTotalNumber = [NSNumber numberWithUnsignedInteger:dayTotal];
        [yArray addObject:dayTotalNumber];
    }
    if (pXArray) {
        *pXArray = xArray;
    }
    if (pYArray) {
        *pYArray = yArray;
    }
}

@end
