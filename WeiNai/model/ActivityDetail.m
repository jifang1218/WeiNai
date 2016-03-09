//
//  ActivityDetail.m
//  WeiNai
//
//  Created by Ji Fang on 7/23/15.
//  Copyright (c) 2015 Ji Fang. All rights reserved.
//

#import "ActivityDetail.h"
#import "EMActivityManager.h"
#import "EMBreastMilk.h"
#import "EMPowderMilk.h"
#import "EMSleep.h"
#import "EMPiss.h"
#import "EMExcrement.h"

@interface ActivityDetail()<EMActivityManagerDelegate> {
}

@end

@implementation ActivityDetail

@synthesize activities = _activities;
@synthesize activityType = _activityType;
@synthesize date = _date;
@synthesize delegate = _delegate;

- (id)init {
    if (self=[super init]) {
        EMActivityManager *activityMgr = [EMActivityManager sharedInstance];
        [activityMgr addDelegate:self];
    }
    
    return self;
}

- (void)dealloc {
    EMActivityManager *activityMgr = [EMActivityManager sharedInstance];
    [activityMgr removeDelegate:self];
}

- (void)setActivityType:(EMActivityType)activityType {
    if (_activityType != activityType) {
        _activityType = activityType;
        if ([_delegate respondsToSelector:@selector(didActivityTypeChanged:)]) {
            [_delegate didActivityTypeChanged:_activityType];
        }
    }
}

- (void)setActivities:(NSArray *)activities {
    if (_activities != activities) {
        _activities = activities;
        if ([_delegate respondsToSelector:@selector(didActivitiesChanged:)]) {
            [_delegate didActivitiesChanged:_activities];
        }
    }
}

- (NSString *)activityStringAtIndex:(NSInteger)index {
    NSString *ret = nil;
    
    if (_activities.count<=index) {
        ret = @"";
        return ret;
    }
    
    EMActivityManager *activityMgr = [EMActivityManager sharedInstance];
    EMActivityBase *activity = [_activities objectAtIndex:index];
    switch (_activityType) {
        case ActivityType_PersonMilk:
        case ActivityType_PowderMilk: {
            EMMilk *milk = (EMMilk *)activity;
            NSString *time = [[NSString alloc] initWithFormat:@"%lu:%lu", milk.time.hour, milk.time.minute];
            NSString *milkMethod = nil;
            NSString *strValue = [[NSString alloc] initWithFormat:@"%lu", milk.ml];
            NSString *strUnit = [activityMgr ActivityTypeUnit2String:_activityType];
            if ([milk isKindOfClass:[EMBreastMilk class]]) {
                EMBreastMilk *breastMilk = (EMBreastMilk *)milk;
                milkMethod = @"母乳";
                NSString *person = breastMilk.person;
                ret = [[NSString alloc] initWithFormat:@"%@   %@ %@   %@   %@",
                       time, strValue, strUnit, milkMethod, person];
            } else {
                EMPowderMilk *powderMilk = (EMPowderMilk *)milk;
                milkMethod = @"奶粉";
                NSString *brand = powderMilk.brand;
                ret = [[NSString alloc] initWithFormat:@"%@   %@ %@   %@   %@",
                       time, strValue, strUnit, milkMethod, brand];
            }
        } break;
        case ActivityType_Sleep: {
            EMSleep *sleep = (EMSleep *)activity;
            NSString *strUnit = [activityMgr ActivityTypeUnit2String:_activityType];
            ret = [[NSString alloc] initWithFormat:@"%lu:%lu, 共 %lu %@",
                   sleep.time.hour, sleep.time.minute, sleep.durationInMinutes, strUnit];
        } break;
        case ActivityType_Piss: {
            EMPiss *piss = (EMPiss *)activity;
            NSString *strUnit = [activityMgr ActivityTypeUnit2String:_activityType];
            ret = [[NSString alloc] initWithFormat:@"%lu:%lu   %lu %@",
                   piss.time.hour, piss.time.minute, piss.ml, strUnit];
        } break;
        case ActivityType_Excrement: {
            EMExcrement *excrement = (EMExcrement *)activity;
            NSString *strUnit = [activityMgr ActivityTypeUnit2String:_activityType];
            ret = [[NSString alloc] initWithFormat:@"%lu:%lu   %lu %@",
                   excrement.time.hour, excrement.time.minute, excrement.g, strUnit];
        } break;
        default: {
        } break;
    }
    
    return ret;
}

#pragma mark - chart
- (NSArray *)chartXArray {
    NSArray *ret = nil;
    
    NSMutableArray *xArray = [[NSMutableArray alloc] initWithCapacity:self.activities.count];
    NSArray *activities = _activities;
    for (EMActivityBase *activity in activities) {
        NSDateComponents *time = activity.time;
        NSString *x = [[NSString alloc] initWithFormat:@"%lu:%lu", time.hour, time.minute];
        [xArray addObject:x];
    }
    ret = xArray;
    
    return ret;
}

- (NSArray *)chartYArray {
    NSArray *ret = nil;
    
    NSMutableArray *yArray = [[NSMutableArray alloc] initWithCapacity:self.activities.count];
    NSArray *activities = _activities;
    switch (_activityType) {
        case ActivityType_PowderMilk:
        case ActivityType_PersonMilk: {
            for (EMMilk *milk in activities) {
                NSNumber *ml = [NSNumber numberWithUnsignedInteger:milk.ml];
                [yArray addObject:ml];
            }
        } break;
        case ActivityType_Excrement: {
            for (EMExcrement *excrement in activities) {
                NSNumber *g = [NSNumber numberWithUnsignedInteger:excrement.g];
                [yArray addObject:g];
                
            }
        } break;
        case ActivityType_Piss: {
            for (EMPiss *piss in activities) {
                NSNumber *ml = [NSNumber numberWithUnsignedInteger:piss.ml];
                [yArray addObject:ml];
            }
        } break;
        case ActivityType_Sleep: {
            for (EMSleep *sleep in activities) {
                NSNumber *minute = [NSNumber numberWithUnsignedInteger:sleep.durationInMinutes];
                [yArray addObject:minute];
            }
        } break;
        default: {
        } break;
    }
    ret = yArray;
    
    return ret;
}

#pragma mark - activity manager delegate
- (void)didDayRecordChanged:(EMDayRecord *)dayRecord {
    if ([_delegate respondsToSelector:@selector(didActivitiesChanged:)]) {
        [_delegate didActivitiesChanged:_activities];
    }
}

@end
