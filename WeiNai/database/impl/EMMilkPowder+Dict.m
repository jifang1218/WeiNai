//
//  EMMilkPowder+Dict.m
//  WeiNai
//
//  Created by Ji Fang on 7/22/15.
//  Copyright (c) 2015 Ji Fang. All rights reserved.
//

#import "EMMilkPowder+Dict.h"
#import "NSDateComponents+Dict.h"

@implementation EMMilkPowder (Dict)

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

- (EMMilkPowder *)fromDict:(NSDictionary *)dict {
    EMMilkPowder *ret = nil;
    
    if (dict) {
        self.ml = [[dict objectForKey:kMilkML] unsignedIntegerValue];
        self.brand = [dict objectForKey:kBrand];
        NSDictionary *timeDict = [dict objectForKey:kTime];
        [self.time fromDict:timeDict];
        self.memo = [dict objectForKey:kMemo];
        self.type = (EMActivityType)[[dict objectForKey:kType] unsignedIntegerValue];
        ret = self;
    }
    
    return ret;
}

@end
