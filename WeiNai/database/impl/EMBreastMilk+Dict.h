//
//  EMBreastMilk+Dict.h
//  WeiNai
//
//  Created by Ji Fang on 7/22/15.
//  Copyright (c) 2015 Ji Fang. All rights reserved.
//

#import "EMBreastMilk.h"
#import "EMMilk+Dict.h"

static NSString *kPerson = @"person";

@interface EMBreastMilk (Dict)

- (NSDictionary *)toDict;
- (EMBreastMilk *)fromDict:(NSDictionary *)dict;

@end
