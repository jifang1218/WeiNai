//
//  Settings.m
//  WeiNai
//
//  Created by Ji Fang on 7/28/15.
//  Copyright (c) 2015 Ji Fang. All rights reserved.
//

#import "Settings.h"
#import "EMActivityManager.h"
#import "EMSettings.h"

@implementation Settings

@synthesize delegate = _delegate;
@synthesize chartStyle = _chartStyle;

- (id)init {
    if (self=[super init]) {
        EMActivityManager *activityman = [EMActivityManager sharedInstance];
        EMSettings *settings = activityman.settings;
        _chartStyle = settings.chartStyle;
    }
    
    return self;
}

- (NSString *)chartStyle2String:(EMChartStyle)chartStyle {
    NSString *ret = nil;
    
    switch (chartStyle) {
        case ChartStyle_Line: {
            ret = @"曲线图";
        } break;
        case ChartStyle_Bar: {
            ret = @"柱状图";
        } break;
        default: {
        } break;
    }
    
    return ret;
}

- (EMChartStyle)chartStyle {    
    EMChartStyle ret = _chartStyle;
    
    return ret;
}

- (void)setChartStyle:(EMChartStyle)chartStyle {
    if (_chartStyle != chartStyle) {
        _chartStyle = chartStyle;
        
        EMActivityManager *activityman = [EMActivityManager sharedInstance];
        EMSettings *settings = activityman.settings;
        settings.chartStyle = _chartStyle;
        [activityman save];
        
        if ([_delegate respondsToSelector:@selector(didChartStyleChanged:)]) {
            [_delegate didChartStyleChanged:_chartStyle];
        }
    }
}

@end
