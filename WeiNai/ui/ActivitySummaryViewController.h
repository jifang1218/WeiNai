//
//  ActivitySummaryViewController.h
//  WeiNai
//
//  Created by Ji Fang on 7/15/15.
//  Copyright (c) 2015 Ji Fang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EMDayRecord;

@interface ActivitySummaryViewController : UITableViewController

@property (nonatomic, strong) EMDayRecord *dayRecord;

@end
