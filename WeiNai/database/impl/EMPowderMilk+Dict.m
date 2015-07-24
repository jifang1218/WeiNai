//
//  EMPowderMilk+Dict.m
//  WeiNai
//
//  Created by Ji Fang on 7/22/15.
//  Copyright (c) 2015 Ji Fang. All rights reserved.
//

#import "EMPowderMilk+Dict.h"
#import "NSDateComponents+Dict.h"

@implementation EMPowderMilk (Dict)

- (NSDictionary *)toDict {
    NSDictionary *ret = nil;
    
    NSDictionary *timeDict = [self.time toDict];
    ret = @{kMilkML:[NSNumber numberWithUnsignedInteger:self.ml],
            kBrand:self.brand!=nil?self.brand:@"",
            kTime:timeDict,
            kMemo:self.memo==nil?@"":self.memo,
            kType:[NSNumber numberWithUnsignedInteger:self.type]};
    
    return ret;
}

- (id)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        self.ml = [[dict objectForKey:kMilkML] unsignedIntegerValue];
        self.brand = [dict objectForKey:kBrand];
        NSDictionary *timeDict = [dict objectForKey:kTime];
        self.time = [[NSDateComponents alloc] initWithDict:timeDict];
        self.memo = [dict objectForKey:kMemo];
        self.type = (EMActivityType)[[dict objectForKey:kType] unsignedIntegerValue];
    }
    
    return self;
}

@end
