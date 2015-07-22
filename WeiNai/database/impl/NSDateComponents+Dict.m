//
//  NSDateComponents+Dict.m
//  WeiNai
//
//  Created by Ji Fang on 7/22/15.
//  Copyright (c) 2015 Ji Fang. All rights reserved.
//

#import "NSDateComponents+Dict.h"

@implementation NSDateComponents (Dict)

- (NSDictionary *)toDict {
    NSDictionary *ret = nil;
    
    NSUInteger year, month, day, hour, minute, second;
    year = self.year;
    month = self.month;
    day = self.day;
    hour = self.hour;
    minute = self.minute;
    second = self.second;
    
    ret = @{kDateComponentYear:[NSNumber numberWithUnsignedInteger:year],
            kDateComponentMonth:[NSNumber numberWithUnsignedInteger:month],
            kDateComponentDay:[NSNumber numberWithUnsignedInteger:day],
            kDateComponentHour:[NSNumber numberWithUnsignedInteger:hour],
            kDateComponentMinute:[NSNumber numberWithUnsignedInteger:minute],
            kDateComponentSecond:[NSNumber numberWithUnsignedInteger:second]};
    
    return ret;
}

- (id)initWithDict:(NSDictionary *)dict {
    if (self=[super init]) {
        self.year = [[dict objectForKey:kDateComponentYear] unsignedIntegerValue];
        self.month = [[dict objectForKey:kDateComponentMonth] unsignedIntegerValue];
        self.day = [[dict objectForKey:kDateComponentDay] unsignedIntegerValue];
        self.hour = [[dict objectForKey:kDateComponentHour] unsignedIntegerValue];
        self.minute = [[dict objectForKey:kDateComponentMinute] unsignedIntegerValue];
        self.second = [[dict objectForKey:kDateComponentSecond] unsignedIntegerValue];
    }
    
    return self;
}

@end
