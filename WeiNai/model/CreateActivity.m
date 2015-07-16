//
//  CreateActivity.m
//  WeiNai
//
//  Created by Ji Fang on 7/16/15.
//  Copyright (c) 2015 Ji Fang. All rights reserved.
//

#import "CreateActivity.h"
#import "ActivityUtils.h"

@implementation CreateActivity

@synthesize delegate = _delegate;

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

@end
