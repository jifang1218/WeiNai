//
//  EMExcrement+Dict.h
//  WeiNai
//
//  Created by Ji Fang on 7/22/15.
//  Copyright (c) 2015 Ji Fang. All rights reserved.
//

#import "EMExcrement.h"
#import "EMActivityBase+Dict.h"

static NSString *kG = @"g";
static NSString *kExcrementQuality = @"quality";

@interface EMExcrement (Dict)

- (NSDictionary *)toDict;
- (EMExcrement *)fromDict:(NSDictionary *)dict;

@end
