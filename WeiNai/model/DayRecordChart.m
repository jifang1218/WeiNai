//
//  DayRecordChart.m
//  WeiNai
//
//  Created by Ji Fang on 7/26/15.
//  Copyright (c) 2015 Ji Fang. All rights reserved.
//

#import "DayRecordChart.h"
#import "EMDayRecord.h"
#import "EMExcrement.h"
#import "EMSleep.h"
#import "EMMilk.h"
#import "EMPiss.h"
#import "Utility.h"

@interface DayRecordChart () {
}

@end

@implementation DayRecordChart

@synthesize delegate = _delegate;
@synthesize activityType = _activityType;
@synthesize dayRecord = _dayRecord;
@synthesize xArray = _xArray;
@synthesize yArray = _yArray;

#pragma mark - properties
- (void)setActivityType:(EMActivityType)activityType {
    if (_activityType != activityType) {
        _activityType = activityType;
        NSArray *activities = nil;
        NSMutableArray *xArray = [[NSMutableArray alloc] init];
        NSMutableArray *yArray = [[NSMutableArray alloc] init];
        switch (_activityType) {
            case ActivityType_Excrement: {
                activities = _dayRecord.excrements;
                for (EMExcrement *excrement in activities) {
                    NSString *time = [Utility timeComponentsString:excrement.time];
                    [xArray addObject:time];
                    NSNumber *g = [NSNumber numberWithUnsignedInteger:excrement.g];
                    [yArray addObject:g];
                }
            } break;
            case ActivityType_PowderMilk: {
                activities = _dayRecord.milks;
                for (EMMilk *milk in activities) {
                    NSString *time = [Utility timeComponentsString:milk.time];
                    [xArray addObject:time];
                    NSNumber *ml = [NSNumber numberWithUnsignedInteger:milk.ml];
                    [yArray addObject:ml];
                }
            } break;
            case ActivityType_Piss: {
                activities = _dayRecord.pisses;
                for (EMPiss *piss in activities) {
                    NSString *time = [Utility timeComponentsString:piss.time];
                    [xArray addObject:time];
                    NSNumber *ml = [NSNumber numberWithUnsignedInteger:piss.ml];
                    [yArray addObject:ml];
                }
            } break;
            case ActivityType_Sleep: {
                activities = _dayRecord.sleeps;
                for (EMSleep *sleep in activities) {
                    NSString *time = [Utility timeComponentsString:sleep.time];
                    [xArray addObject:time];
                    NSNumber *duration = [NSNumber numberWithUnsignedInteger:sleep.durationInMinutes];
                    [yArray addObject:duration];
                }
            } break;
            default: {
            } break;
        }
        _xArray = xArray;
        _yArray = yArray;
        if ([_delegate respondsToSelector:@selector(didDatasourceChangedXArray:yArray:)]) {
            [_delegate didDatasourceChangedXArray:_xArray
                                           yArray:_yArray];
        }
        if ([_delegate respondsToSelector:@selector(didActivityTypeChanged:)]) {
            [_delegate didActivityTypeChanged:_activityType];
        }
    }
}

- (void)setDayRecord:(EMDayRecord *)dayRecord {
    if (_dayRecord != dayRecord) {
        _dayRecord = dayRecord;
        if ([_delegate respondsToSelector:@selector(didDatasourceChangedXArray:yArray:)]) {
            NSArray *activities = nil;
            NSMutableArray *xArray = [[NSMutableArray alloc] init];
            NSMutableArray *yArray = [[NSMutableArray alloc] init];
            switch (_activityType) {
                case ActivityType_Excrement: {
                    activities = _dayRecord.excrements;
                    for (EMExcrement *excrement in activities) {
                        NSString *time = [Utility timeComponentsString:excrement.time];
                        [xArray addObject:time];
                        NSNumber *g = [NSNumber numberWithUnsignedInteger:excrement.g];
                        [yArray addObject:g];
                    }
                } break;
                case ActivityType_PowderMilk: {
                    activities = _dayRecord.milks;
                    for (EMMilk *milk in activities) {
                        NSString *time = [Utility timeComponentsString:milk.time];
                        [xArray addObject:time];
                        NSNumber *ml = [NSNumber numberWithUnsignedInteger:milk.ml];
                        [yArray addObject:ml];
                    }
                } break;
                case ActivityType_Piss: {
                    activities = _dayRecord.pisses;
                    for (EMPiss *piss in activities) {
                        NSString *time = [Utility timeComponentsString:piss.time];
                        [xArray addObject:time];
                        NSNumber *ml = [NSNumber numberWithUnsignedInteger:piss.ml];
                        [yArray addObject:ml];
                    }
                } break;
                case ActivityType_Sleep: {
                    activities = _dayRecord.sleeps;
                    for (EMSleep *sleep in activities) {
                        NSString *time = [Utility timeComponentsString:sleep.time];
                        [xArray addObject:time];
                        NSNumber *duration = [NSNumber numberWithUnsignedInteger:sleep.durationInMinutes];
                        [yArray addObject:duration];
                    }
                } break;
                default: {
                } break;
            }
            _xArray = xArray;
            _yArray = yArray;
            [_delegate didDatasourceChangedXArray:_xArray
                                           yArray:_yArray];
        }
    }
}

@end
