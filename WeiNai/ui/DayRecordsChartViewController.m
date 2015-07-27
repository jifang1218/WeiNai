//
//  DayRecordsChartViewController.m
//  WeiNai
//
//  Created by Ji Fang on 7/27/15.
//  Copyright (c) 2015 Ji Fang. All rights reserved.
//

#import "DayRecordsChartViewController.h"
#import "DayRecordsChart.h"
#import "UUChart.h"
#import "EMActivityManager.h"


@interface DayRecordsChartViewController ()<DayRecordsChartDelegate, UUChartDataSource, UITableViewDataSource, UITableViewDelegate> {
    DayRecordsChart *_dayRecordsChart;
    UITableView *_tableview;
    UUChart *_chart;
    NSArray *_xArray;
    NSArray *_yArray;
}

- (void)setupUI;
- (UITableViewCell *)configureCellAtIndex:(NSInteger)index;
- (UITableViewCell *)configureActivitySelectorCell;
- (UITableViewCell *)configureRecordPeriodSelectorCell;
- (UITableViewCell *)configureChartCell;
- (void)activityTypeSelected:(id)sender;
- (void)periodSelected:(id)sender;

@end

@implementation DayRecordsChartViewController

@dynamic activityType;
@dynamic period;

- (id)init {
    if (self=[super init]) {
        _dayRecordsChart = [[DayRecordsChart alloc] init];
        _dayRecordsChart.delegate = self;
        _dayRecordsChart.activityType = ActivityType_Milk;
    }
    
    return self;
}

- (void)dealloc {
    _dayRecordsChart.delegate = nil;
}

- (EMActivityType)activityType {
    return _dayRecordsChart.activityType;
}

- (void)setActivityType:(EMActivityType)activityType {
    _dayRecordsChart.activityType = activityType;
}

- (void)setPeriod:(EMDayRecordsPeriod)period {
    _dayRecordsChart.period = period;
}

- (EMDayRecordsPeriod)period {
    return _dayRecordsChart.period;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self setupUI];
}

#pragma mark - actions
- (void)activityTypeSelected:(id)sender {
    if ([sender isKindOfClass:[UISegmentedControl class]]) {
        UISegmentedControl *seg = (UISegmentedControl *)sender;
        NSInteger index = seg.selectedSegmentIndex;
        switch (index) {
            case 0: {
                _dayRecordsChart.activityType = ActivityType_Milk;
            } break;
            case 1: {
                _dayRecordsChart.activityType = ActivityType_Piss;
            } break;
            case 2: {
                _dayRecordsChart.activityType = ActivityType_Excrement;
            } break;
            case 3: {
                _dayRecordsChart.activityType = ActivityType_Sleep;
            } break;
            default: {
            } break;
        }
    }
}

- (void)periodSelected:(id)sender {
    if ([sender isKindOfClass:[UISegmentedControl class]]) {
        UISegmentedControl *seg = (UISegmentedControl *)sender;
        NSInteger index = seg.selectedSegmentIndex;
        switch (index) {
            case 0: {
                _dayRecordsChart.period = DayRecordsPeriod_Week;
            } break;
            case 1: {
                _dayRecordsChart.period = DayRecordsPeriod_3Weeks;
            } break;
            case 2: {
                _dayRecordsChart.period = DayRecordsPeriod_Month;
            } break;
            case 3: {
                _dayRecordsChart.period = DayRecordsPeriod_3Month;
            } break;
            default:
                break;
        }
    }
}

#pragma mark - helpers
- (void)setupUI {
    _tableview = [[UITableView alloc] initWithFrame:self.view.bounds
                                              style:UITableViewStylePlain];
    _tableview.dataSource = self;
    _tableview.delegate = self;
    [self.view addSubview:_tableview];
}

- (UITableViewCell *)configureCellAtIndex:(NSInteger)index {
    UITableViewCell *cell = nil;
    switch (index) {
        case 0: {
            cell = [self configureActivitySelectorCell];
        } break;
        case 1: {
            cell = [self configureRecordPeriodSelectorCell];
        } break;
        case 2: {
            cell = [self configureChartCell];
        } break;
        default: {
        } break;
    }
    
    return cell;
}

- (UITableViewCell *)configureRecordPeriodSelectorCell {
    UITableViewCell *cell = nil;
    static NSString *cellIdentifier = @"DayRecordsChartCell_PeriodSelector";
    cell = [_tableview dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:cellIdentifier];
    }
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    EMActivityManager *activityman = [EMActivityManager sharedInstance];
    UISegmentedControl *periodSeg = [[UISegmentedControl alloc] initWithItems:
                                    @[[activityman PeriodType2String:DayRecordsPeriod_Week],
                                      [activityman PeriodType2String:DayRecordsPeriod_3Weeks],
                                      [activityman PeriodType2String:DayRecordsPeriod_Month],
                                      [activityman PeriodType2String:DayRecordsPeriod_3Month]
                                      ]];
    [periodSeg addTarget:self
                  action:@selector(periodSelected:)
        forControlEvents:UIControlEventValueChanged];
    switch (_dayRecordsChart.period) {
        case DayRecordsPeriod_Week: {
            periodSeg.selectedSegmentIndex = 0;
        } break;
        case DayRecordsPeriod_3Weeks: {
            periodSeg.selectedSegmentIndex = 1;
        } break;
        case DayRecordsPeriod_Month: {
            periodSeg.selectedSegmentIndex = 2;
        } break;
        case DayRecordsPeriod_3Month: {
            periodSeg.selectedSegmentIndex = 3;
        } break;
        default: {
        } break;
    }
    periodSeg.center = cell.contentView.center;
    periodSeg.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [cell.contentView addSubview:periodSeg];
    cell.backgroundColor = [UIColor clearColor];
    cell.backgroundView = nil;
    
    return cell;
}

- (UITableViewCell *)configureActivitySelectorCell {
    UITableViewCell *cell = nil;
    static NSString *cellIdentifier = @"DayRecordsChartCell_ActivitySelector";
    cell = [_tableview dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:cellIdentifier];
    }
    
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    EMActivityManager *activityman = [EMActivityManager sharedInstance];
    UISegmentedControl *typesSeg = [[UISegmentedControl alloc] initWithItems:
                                    @[[activityman ActivityType2String:ActivityType_Milk],
                                      [activityman ActivityType2String:ActivityType_Piss],
                                      [activityman ActivityType2String:ActivityType_Excrement],
                                      [activityman ActivityType2String:ActivityType_Sleep],
                                      ]];
    [typesSeg addTarget:self
                 action:@selector(activityTypeSelected:)
       forControlEvents:UIControlEventValueChanged];
    switch (_dayRecordsChart.activityType) {
        case ActivityType_Milk: {
            typesSeg.selectedSegmentIndex = 0;
        } break;
        case ActivityType_Piss: {
            typesSeg.selectedSegmentIndex = 1;
        } break;
        case ActivityType_Excrement: {
            typesSeg.selectedSegmentIndex = 2;
        } break;
        case ActivityType_Sleep: {
            typesSeg.selectedSegmentIndex = 3;
        } break;
        default: {
        } break;
    }
    typesSeg.center = cell.contentView.center;
    typesSeg.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [cell.contentView addSubview:typesSeg];
    cell.backgroundColor = [UIColor clearColor];
    cell.backgroundView = nil;
    
    return cell;
}

- (UITableViewCell *)configureChartCell {
    UITableViewCell *cell = nil;
    static NSString *cellIdentifier = @"DayRecordsChartCell_Chart";
    cell = [_tableview dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:cellIdentifier];
    }
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    CGRect frame = cell.contentView.bounds;
    frame.size.width = cell.contentView.frame.size.width - 20;
    frame.size.height = 200;
    _chart = [[UUChart alloc] initwithUUChartDataFrame:frame
                                            withSource:self
                                             withStyle:UUChartLineStyle];
    [_chart showInView:cell.contentView];
    cell.userInteractionEnabled = NO;
    
    return cell;
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

- (BOOL)UUChart:(UUChart *)chart ShowHorizonLineAtIndex:(NSInteger)index
{
    return YES;
}

#pragma makr - tableview datasource/delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger ret = 0;
    
    ret = 3; // one for period, one for activity type selector, one for chart.
    
    return ret;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    cell = [self configureCellAtIndex:indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    if (row == 2) {
        return 200;
    } else {
        return 44;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    if (row == 2) {
        return 200;
    } else {
        return 44;
    }
}

#pragma mark - DayRecordChartDelegate
- (void)didActivityTypeChanged:(EMActivityType)activityType {
}

- (void)didDayRecordsPeriodChanged:(EMDayRecordsPeriod)period {
}

- (void)didDatasourceChangedXArray:(NSArray *)xArray yArray:(NSArray *)yArray {
    _xArray = xArray;
    _yArray = yArray;
    [_tableview reloadData];
}

@end
