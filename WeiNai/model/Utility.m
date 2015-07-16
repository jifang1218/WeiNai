//
//  Utility.m
//  WeiNai
//
//  Created by Ji Fang on 7/16/15.
//  Copyright (c) 2015 Ji Fang. All rights reserved.
//

#import "Utility.h"

@implementation Utility

+ (NSString *)CurrentDateString {
    NSString *ret = nil;
    
    ret = [Utility dateString:[NSDate date]];
    
    return ret;
}

+ (NSString *)CurrentTimeString {
    NSString *ret = nil;
    
    ret = [Utility timeString:[NSDate date]];
    
    return ret;
}

+ (NSString *)dateString:(NSDate *)date {
    NSString *ret = nil;
    
    NSDateFormatter*formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    ret = [formatter stringFromDate:date];
    
    return ret;
}

+ (NSString *)timeString:(NSDate *)time {
    NSString *ret = nil;
    
    NSDateFormatter*formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    ret = [formatter stringFromDate:time];
    
    return ret;
}

@end
