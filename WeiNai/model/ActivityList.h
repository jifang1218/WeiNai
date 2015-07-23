//
//  ActivityList.h
//  WeiNai
//
//  Created by Ji Fang on 7/23/15.
//  Copyright (c) 2015 Ji Fang. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ActivityListDelegate <NSObject>

@optional
- (void)didActivitiesChanged:(NSArray *)activities;

@end

@interface ActivityList : NSObject

@property (nonatomic, weak) id<ActivityListDelegate> delegate;

- (NSArray *)allDayRecords;
- (NSString *)dayRecordSummaryAtIndex:(NSInteger)index;

@end
