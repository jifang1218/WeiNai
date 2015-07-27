//
//  DayRecordsChart.h
//  WeiNai
//
//  Created by Ji Fang on 7/27/15.
//  Copyright (c) 2015 Ji Fang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIMacros.h"

@protocol DayRecordsChartDelegate <NSObject>

@optional

@end

@interface DayRecordsChart : NSObject

@property (nonatomic, weak) id<DayRecordsChartDelegate> delegate;
@property (nonatomic, strong) NSArray *historicalDayRecords;
@property (nonatomic) EMActivityType activityType;
@property (nonatomic) EMDayRecordsPeriod period;

@end
