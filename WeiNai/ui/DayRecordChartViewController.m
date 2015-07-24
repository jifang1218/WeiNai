//
//  DayRecordChartViewController.m
//  WeiNai
//
//  Created by Ji Fang on 7/25/15.
//  Copyright (c) 2015 Ji Fang. All rights reserved.
//

#import "DayRecordChartViewController.h"

@interface DayRecordChartViewController () {
}

- (void)setupUI;

@end

@implementation DayRecordChartViewController

@synthesize xArray = _xArray;
@synthesize yArray = _yArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self setupUI];
}

#pragma mark - helpers
- (void)setupUI {
}

@end
