//
//  EMPiss+Dict.h
//  WeiNai
//
//  Created by Ji Fang on 7/22/15.
//  Copyright (c) 2015 Ji Fang. All rights reserved.
//

#import "EMPiss.h"
#import "EMActivityBase+Dict.h"

static NSString *kPissML = @"ml";
static NSString *kPissColor = @"pisscolor";

@interface EMPiss (Dict)

- (NSDictionary *)toDict;
- (id)initWithDict:(NSDictionary *)dict;

@end
