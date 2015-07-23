//
//  EMDayRecord.h
//  WeiNai
//
//  Created by Ji Fang on 7/14/15.
//  Copyright (c) 2015 Ji Fang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class EMActivityBase;
@class EMDayRecord;

@protocol EMDayRecordDelegate <NSObject>

@optional
- (void)didActivityChanged:(EMActivityBase *)activity inDayRecord:(EMDayRecord *)dayRecord;

@end

@interface EMDayRecord : NSObject

@property (nonatomic, strong) NSArray *milks;
@property (nonatomic, strong) NSArray *excrements;
@property (nonatomic, strong) NSArray *pisses;
@property (nonatomic, strong) NSArray *sleeps;

// valid fields: year, month, day;
@property (nonatomic, strong) NSDateComponents *date;
@property (nonatomic, weak) id<EMDayRecordDelegate> delegate;

- (BOOL)addActivity:(EMActivityBase *)activity;

@end
