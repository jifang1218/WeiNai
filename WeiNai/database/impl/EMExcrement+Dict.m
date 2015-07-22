//
//  EMExcrement+Dict.m
//  WeiNai
//
//  Created by Ji Fang on 7/22/15.
//  Copyright (c) 2015 Ji Fang. All rights reserved.
//

#import "EMExcrement+Dict.h"
#import "NSDateComponents+Dict.h"

@implementation EMExcrement (Dict)

- (NSDictionary *)toDict {
    NSDictionary *ret = nil;
    
    NSDictionary *timeDict = [self.time toDict];
    ret = @{kG:[NSNumber numberWithUnsignedInteger:self.g],
            kExcrementQuality:[NSNumber numberWithUnsignedInteger:self.quality],
            kTime:timeDict,
            kMemo:self.memo==nil?@"":self.memo,
            kType:[NSNumber numberWithUnsignedInteger:self.type]};
    
    return ret;
}

- (EMExcrement *)fromDict:(NSDictionary *)dict {
    EMExcrement *ret = nil;
    
    if (dict) {
        self.g = [[dict objectForKey:kG] unsignedIntegerValue];
        self.quality = (EMExcrementQuality)[[dict objectForKey:kExcrementQuality] unsignedIntegerValue];
        NSDictionary *timeDict = [dict objectForKey:kTime];
        [self.time fromDict:timeDict];
        self.memo = [dict objectForKey:kMemo];
        self.type = (EMActivityType)[[dict objectForKey:kType] unsignedIntegerValue];
        ret = self;
    }
    
    return ret;
}

@end
