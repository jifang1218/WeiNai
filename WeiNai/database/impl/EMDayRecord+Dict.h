//
//  EMDayRecord+Dict.h
//  WeiNai
//
//  Created by Ji Fang on 7/22/15.
//  Copyright (c) 2015 Ji Fang. All rights reserved.
//

#import "EMDayRecord.h"

static NSString *kDate = @"date";
static NSString *kMilks = @"milks";
static NSString *kExcrements = @"excrements";
static NSString *kPisses = @"pisses";
static NSString *kSleeps = @"sleeps";

@interface EMDayRecord (Dict)

- (NSDictionary *)toDict;
- (id)initWithDict:(NSDictionary *)dict;

@end
