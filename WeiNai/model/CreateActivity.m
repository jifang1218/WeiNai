//
//  CreateActivity.m
//  WeiNai
//
//  Created by Ji Fang on 7/16/15.
//  Copyright (c) 2015 Ji Fang. All rights reserved.
//

#import "CreateActivity.h"
#import "ActivityUtils.h"

@interface CreateActivity () {
}

@end

@implementation CreateActivity

@synthesize delegate = _delegate;
@synthesize currentActivityType = _currentActivityType;
@synthesize endTime = _endTime;
@synthesize startTime = _startTime;

- (id)init {
    if (self=[super init]) {
        _currentActivityType = ActivityType_Milk;
    }
    
    return self;
}

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

@end
