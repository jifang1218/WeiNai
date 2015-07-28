//
//  ActivityChartViewController.m
//  WeiNai
//
//  Created by Ji Fang on 7/24/15.
//  Copyright (c) 2015 Ji Fang. All rights reserved.
//

#import "ActivityChartViewController.h"
#import "UUChart.h"
#import "EMActivityManager.h"
#import "UIMacros.h"
#import "EMSettings.h"

@interface ActivityChartViewController ()<UUChartDataSource> {
    UUChart *_chart;
}

- (void)setupUI;

@end

@implementation ActivityChartViewController

@synthesize xArray = _xArray;
@synthesize yArray = _yArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self setupUI];
}

#pragma mark - helpers
- (void)setupUI {
    CGRect frame = self.view.bounds;
    frame = self.view.frame;
    frame.size.height -= 130;
    frame.size.width -= 20;
    EMActivityManager *activityman = [EMActivityManager sharedInstance];
    EMSettings *settings = activityman.settings;
    UUChartStyle chartStyle = UUChartLineStyle;
    if (settings.chartStyle == ChartStyle_Bar) {
        chartStyle = UUChartBarStyle;
    }
    _chart = [[UUChart alloc] initwithUUChartDataFrame:frame
                                            withSource:self
                                             withStyle:chartStyle];
    _chart.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [_chart showInView:self.view];
}

#pragma mark - UUChartDataSource
- (NSArray *)UUChart_xLabelArray:(UUChart *)chart {
    NSArray *ret = nil;
    
    ret = _xArray;
    
    return ret;
}

- (NSArray *)UUChart_yValueArray:(UUChart *)chart {
    NSArray *ret = nil;
    
    ret = @[_yArray];
    
    return ret;
}

//- (CGRange)UUChartMarkRangeInLineChart:(UUChart *)chart
//{
//    if (path.row==2) {
//        return CGRangeMake(25, 75);
//    }
//    return CGRangeZero;
//}

//判断显示横线条
- (BOOL)UUChart:(UUChart *)chart ShowHorizonLineAtIndex:(NSInteger)index
{
    return YES;
}

//判断显示最大最小值
//- (BOOL)UUChart:(UUChart *)chart ShowMaxMinAtIndex:(NSInteger)index
//{
//    return path.row==2;
//}

@end
