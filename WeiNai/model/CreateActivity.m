//
//  CreateActivity.m
//  WeiNai
//
//  Created by Ji Fang on 7/16/15.
//  Copyright (c) 2015 Ji Fang. All rights reserved.
//

#import "CreateActivity.h"
#import "ActivityUtils.h"
#import "NSDate+Category.h"
#import "EMMilkPowder.h"
#import "EMBreastMilk.h"
#import "EMExcrement.h"
#import "EMPiss.h"
#import "EMSleep.h"

@interface CreateActivity () {
}

- (EMActivityBase *)generateActivity;
- (EMActivityBase *)makeSleepActivity;
- (EMActivityBase *)makePissActivity;
- (EMActivityBase *)makeExcrementActivity;
- (EMActivityBase *)makeMilkActivity;

@end

@implementation CreateActivity

@synthesize delegate = _delegate;
@synthesize currentActivityType = _currentActivityType;
@synthesize endTime = _endTime;
@synthesize startTime = _startTime;
@synthesize milkType = _milkType;
@synthesize activityValue = _activityValue;

- (id)init {
    if (self=[super init]) {
        _currentActivityType = ActivityType_Milk;
    }
    
    return self;
}

#pragma mark - activity type helpers
- (NSUInteger)numberOfActivityTypes {
    return [ActivityUtils numberOfActivityTypes];
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

#pragma mark - property setters
- (void)setStartTime:(NSDate *)startTime {
    if (_startTime != startTime) {
        _startTime = startTime;
        if ([_delegate respondsToSelector:@selector(didStartTimeChanged:)]) {
            [_delegate didStartTimeChanged:startTime];
        }
    }
}

- (void)setEndTime:(NSDate *)endTime {
    if (_endTime != endTime) {
        _endTime = endTime;
        if ([_delegate respondsToSelector:@selector(didEndTimeChanged:)]) {
            [_delegate didEndTimeChanged:endTime];
        }
    }
}

- (void)setCurrentActivityType:(EMActivityType)currentActivityType {
    if (_currentActivityType != currentActivityType) {
        _currentActivityType = currentActivityType;
        if ([_delegate respondsToSelector:@selector(didCurrentActivityTypeChanged:)]) {
            [_delegate didCurrentActivityTypeChanged:currentActivityType];
        }
    }
}

- (void)setMilkType:(EMMilkType)milkType {
    if (milkType != _milkType) {
        _milkType = milkType;
        if ([_delegate respondsToSelector:@selector(didMilkTypeChanged:)]) {
            [_delegate didMilkTypeChanged:milkType];
        }
    }
}

- (void)setActivityValue:(NSUInteger)activityValue {
    if (_activityValue != activityValue) {
        _activityValue = activityValue;
        if ([_delegate respondsToSelector:@selector(didActivityValueChanged:)]) {
            [_delegate didActivityValueChanged:_activityValue];
        }
    }
}

#pragma mark - activity helpers
- (EMActivityBase *)generateActivity {
    EMActivityBase *ret = nil;
    
    switch (_currentActivityType) {
        case ActivityType_Milk: {
            ret = [self makeMilkActivity];
        } break;
        case ActivityType_Excrement: {
            ret = [self makeExcrementActivity];
        } break;
        case ActivityType_Piss: {
            ret = [self makePissActivity];
        } break;
        case ActivityType_Sleep: {
            ret = [self makeSleepActivity];
        } break;
        default: {
        } break;
    }
    
    return ret;
}

- (EMActivityBase *)makeMilkActivity {
    EMActivityBase *ret = nil;
    
    EMMilkType milkType = _milkType;
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.year = _startTime.year;
    dateComponents.month = _startTime.month;
    dateComponents.day = _startTime.day;
    dateComponents.hour = _startTime.hour;
    dateComponents.minute = _startTime.minute;
    dateComponents.second = _startTime.seconds;
    
    EMMilk *milk = nil;
    switch (milkType) {
        case MilkType_BreastMilk: {
            EMBreastMilk *breastMilk = [[EMBreastMilk alloc] init];
            breastMilk.person = @"王坤";
            milk = breastMilk;
        } break;
        case MilkType_PowderMilk: {
            EMMilkPowder *powder = [[EMMilkPowder alloc] init];
            powder.brand = @"Aptamil";
            milk = powder;
        } break;
        default: {
        } break;
    }
    milk.time = dateComponents;
    milk.ml = _activityValue;
    
    ret = milk;
    
    return ret;
}

- (EMActivityBase *)makeExcrementActivity {
    EMActivityBase *ret = nil;
    
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.year = _startTime.year;
    dateComponents.month = _startTime.month;
    dateComponents.day = _startTime.day;
    dateComponents.hour = _startTime.hour;
    dateComponents.minute = _startTime.minute;
    dateComponents.second = _startTime.seconds;
    
    EMExcrement *excrement = [[EMExcrement alloc] init];
    excrement.time = dateComponents;
    excrement.quality = ExcrementQualityGood;
    excrement.g = _activityValue;
    
    ret = excrement;
    
    return ret;
}

- (EMActivityBase *)makePissActivity {
    EMActivityBase *ret = nil;
    
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.year = _startTime.year;
    dateComponents.month = _startTime.month;
    dateComponents.day = _startTime.day;
    dateComponents.hour = _startTime.hour;
    dateComponents.minute = _startTime.minute;
    dateComponents.second = _startTime.seconds;
    
    EMPiss *piss = [[EMPiss alloc] init];
    piss.time = dateComponents;
    piss.ml = _activityValue;
    piss.color = PissColor_White;
    
    ret = piss;
    
    return ret;
}

- (EMActivityBase *)makeSleepActivity {
    EMActivityBase *ret = nil;
    
    NSDateComponents *startTime = [[NSDateComponents alloc] init];
    startTime.year = _startTime.year;
    startTime.month = _startTime.month;
    startTime.day = _startTime.day;
    startTime.hour = _startTime.hour;
    startTime.minute = _startTime.minute;
    startTime.second = _startTime.seconds;
    
    NSTimeInterval durationInSeconds = [_endTime timeIntervalSinceDate:_startTime];
    NSUInteger durationInMinutes = (NSUInteger)(durationInSeconds / 60.0 + 0.5);
    
    EMSleep *sleep = [[EMSleep alloc] init];
    sleep.time = startTime;
    sleep.quality = SleepQuality_Deep;
    sleep.durationInMinutes = durationInMinutes;
    
    ret = sleep;
    
    return ret;
}

@end
