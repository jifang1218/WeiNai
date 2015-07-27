//
//  DayRecordChart.h
//  WeiNai
//
//  Created by Ji Fang on 7/26/15.
//  Copyright (c) 2015 Ji Fang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIMacros.h"

@protocol DayRecordChartDelegate <NSObject>

@optional
- (void)didActivityTypeChanged:(EMActivityType)activityType;
- (void)didDatasourceChangedXArray:(NSArray *)xArray
                            yArray:(NSArray *)yArray;

@end

@class EMDayRecord;

@interface DayRecordChart : NSObject

@property (nonatomic, weak) id<DayRecordChartDelegate> delegate;
@property (nonatomic) EMActivityType activityType;
@property (nonatomic, strong) NSArray *xArray;
@property (nonatomic, strong) NSArray *yArray;
@property (nonatomic, strong) EMDayRecord *dayRecord;

@end
