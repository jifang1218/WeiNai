//
//  ActivityUtils.m
//  WeiNai
//
//  Created by Ji Fang on 7/16/15.
//  Copyright (c) 2015 Ji Fang. All rights reserved.
//

#import "ActivityUtils.h"

@implementation ActivityUtils

+ (NSUInteger)numberOfActivityTypes {
    return ActivityType_NumberOfActivityTypes;
}

+ (NSString *)ActivityType2String:(EMActivityType)activityType {
    NSString *ret = nil;
    switch (activityType) {
        case ActivityType_Excrement: {
            ret = @"便便";
        } break;
        case ActivityType_Milk: {
            ret = @"喂奶";
        } break;
        case ActivityType_Piss: {
            ret = @"尿尿";
        } break;
        case ActivityType_Sleep: {
            ret = @"睡觉";
        } break;
        default: {
        } break;
    }
    
    return ret;
}

+ (NSString *)ActivityTypeUnit2String:(EMActivityType)activityType {
    NSString *ret = nil;
    switch (activityType) {
        case ActivityType_Excrement: {
            ret = @"克";
        } break;
        case ActivityType_Milk: {
            ret = @"毫升";
        } break;
        case ActivityType_Piss: {
            ret = @"毫升";
        } break;
        case ActivityType_Sleep: {
            ret = @"分钟";
        } break;
        default: {
        } break;
    }
    
    return ret;
}

@end
