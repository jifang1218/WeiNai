//
//  EMSleep+Dict.h
//  WeiNai
//
//  Created by Ji Fang on 7/22/15.
//  Copyright (c) 2015 Ji Fang. All rights reserved.
//

#import "EMSleep.h"
#import "EMActivityBase+Dict.h"

static NSString *kDurationInMinute = @"duration_in_minute";
static NSString *kSleepQuality = @"quality";

@interface EMSleep (Dict)

- (NSDictionary *)toDict;
- (id)initWithDict:(NSDictionary *)dict;

@end
