//
//  Utility.h
//  WeiNai
//
//  Created by Ji Fang on 7/16/15.
//  Copyright (c) 2015 Ji Fang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utility : NSObject

+ (NSString *)CurrentDateString;
+ (NSString *)CurrentTimeString;

+ (NSString *)dateString:(NSDate *)date;
+ (NSString *)dateComponentsString:(NSDateComponents *)date;
+ (NSString *)compactDateComponentsString:(NSDateComponents *)date;
+ (NSString *)timeString:(NSDate *)time;
+ (NSString *)timeComponentsString:(NSDateComponents *)time;

@end
