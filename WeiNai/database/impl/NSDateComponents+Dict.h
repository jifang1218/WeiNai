//
//  NSDateComponents+Dict.h
//  WeiNai
//
//  Created by Ji Fang on 7/22/15.
//  Copyright (c) 2015 Ji Fang. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *kDateComponentYear = @"year";
static NSString *kDateComponentMonth = @"month";
static NSString *kDateComponentDay = @"day";
static NSString *kDateComponentHour = @"hour";
static NSString *kDateComponentMinute = @"minute";
static NSString *kDateComponentSecond = @"second";

@interface NSDateComponents (Dict)

- (NSDictionary *)toDict;
- (id)initWithDict:(NSDictionary *)dict;

@end
