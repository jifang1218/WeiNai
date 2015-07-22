//
//  EMSleep+Dict.m
//  WeiNai
//
//  Created by Ji Fang on 7/22/15.
//  Copyright (c) 2015 Ji Fang. All rights reserved.
//

#import "EMSleep+Dict.h"
#import "NSDateComponents+Dict.h"

@implementation EMSleep (Dict)

- (NSDictionary *)toDict {
    NSDictionary *ret = nil;
    
    NSDictionary *timeDict = [self.time toDict];
    ret = @{kDurationInMinute:[NSNumber numberWithUnsignedInteger:self.durationInMinutes],
            kSleepQuality:[NSNumber numberWithUnsignedInteger:self.quality],
            kTime:timeDict,
            kMemo:self.memo==nil?@"":self.memo,
            kType:[NSNumber numberWithUnsignedInteger:self.type]};
    
    return ret;
}

- (EMSleep *)fromDict:(NSDictionary *)dict {
    EMSleep *ret = nil;
    
    if (dict) {
        self.durationInMinutes = [[dict objectForKey:kDurationInMinute] unsignedIntegerValue];
        self.quality = (EMSleepQuality)[[dict objectForKey:kSleepQuality] unsignedIntegerValue];
        NSDictionary *timeDict = [dict objectForKey:kTime];
        [self.time fromDict:timeDict];
        self.memo = [dict objectForKey:kMemo];
        self.type = (EMActivityType)[[dict objectForKey:kType] unsignedIntegerValue];
        ret = self;
    }
    
    return ret;
}

@end
