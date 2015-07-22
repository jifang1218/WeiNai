//
//  EMMilkPowder+Dict.h
//  WeiNai
//
//  Created by Ji Fang on 7/22/15.
//  Copyright (c) 2015 Ji Fang. All rights reserved.
//

#import "EMMilkPowder.h"
#import "EMMilk+Dict.h"

static NSString *kBrand = @"brand";

@interface EMMilkPowder (Dict)

- (NSDictionary *)toDict;
- (id)initWithDict:(NSDictionary *)dict;

@end
