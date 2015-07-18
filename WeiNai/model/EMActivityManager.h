//
//  EMActivityManager.h
//  WeiNai
//
//  Created by Ji Fang on 7/18/15.
//  Copyright (c) 2015 Ji Fang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class EMDayRecord;

@interface EMActivityManager : NSObject

+ (EMActivityManager *)sharedInstance;

- (EMDayRecord *)todayRecord;
- (EMDayRecord *)dayRecordAt:(NSDateComponents *)date;
- (EMDayRecord *)dayRecordsFrom:(NSDateComponents *)from
                             to:(NSDateComponents *)to;

@end
