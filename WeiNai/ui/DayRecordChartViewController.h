//
//  DayRecordChartViewController.h
//  WeiNai
//
//  Created by Ji Fang on 7/25/15.
//  Copyright (c) 2015 Ji Fang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIMacros.h"

@class EMDayRecord;

@interface DayRecordChartViewController : UIViewController

@property (nonatomic, strong) EMDayRecord *dayRecord;
@property (nonatomic) EMActivityType activityType;

@end
