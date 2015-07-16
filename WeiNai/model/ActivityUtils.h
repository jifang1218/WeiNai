//
//  ActivityUtils.h
//  WeiNai
//
//  Created by Ji Fang on 7/16/15.
//  Copyright (c) 2015 Ji Fang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIMacros.h"

@interface ActivityUtils : NSObject

+ (NSUInteger)numberOfActivityTypes;
+ (NSString *)ActivityType2String:(EMActivityType)activityType;
+ (NSString *)ActivityTypeUnit2String:(EMActivityType)activityType;

@end
