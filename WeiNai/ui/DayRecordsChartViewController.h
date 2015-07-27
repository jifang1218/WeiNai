//
//  DayRecordsChartViewController.h
//  WeiNai
//
//  Created by Ji Fang on 7/27/15.
//  Copyright (c) 2015 Ji Fang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIMacros.h"

@interface DayRecordsChartViewController : UIViewController

@property (nonatomic, strong) NSArray *historicalDayRecords;
@property (nonatomic) EMActivityType activityType;
@property (nonatomic) EMDayRecordsPeriod period;

@end
