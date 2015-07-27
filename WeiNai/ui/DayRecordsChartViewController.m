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



@interface DayRecordsChartViewController ()<DayRecordsChartDelegate, UUChartDataSource, UITableViewDataSource, UITableViewDelegate> {
    DayRecordsChart *_dayRecordsChart;
    UITableView *_tableview;
    UUChart *_chart;
    NSArray *_xArray;
    NSArray *_yArray;
}

- (void)setupUI;
- (void)configureCell:(UITableViewCell *)cell index:(NSInteger)index;
- (void)configureActivitySelectorCell:(UITableViewCell *)cell;
- (void)configureRecordPeriodSelectorCell:(UITableViewCell *)cell;
- (void)configureChartCell:(UITableViewCell *)cell;
- (void)activityTypeSelected:(id)sender;

@end

@implementation DayRecordsChartViewController

#if 0

@dynamic historicalDayRecords;
@dynamic activityType;
@dynamic period;

- (id)init {
    if (self=[super init]) {
        _dayRecordsChart = [[DayRecordsChart alloc] init];
        _dayRecordsChart.delegate = self;
    }
    
    return self;
}

- (void)dealloc {
    _dayRecordsChart.delegate = nil;
}

- (NSArray *)historicalDayRecords {
    return _dayRecordsChart.historicalDayRecords;
}

- (void)setHistoricalDayRecords:(NSArray *)historicalDayRecords {
    _dayRecordsChart.historicalDayRecords = historicalDayRecords;
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

#pragma mark - helpers
- (void)setupUI {
    _tableview = [[UITableView alloc] initWithFrame:self.view.bounds
                                              style:UITableViewStylePlain];
    _tableview.dataSource = self;
    _tableview.delegate = self;
    [self.view addSubview:_tableview];
}

- (void)configureCell:(UITableViewCell *)cell
                index:(NSInteger)index {
    switch (index) {
        case 0: {
            [self configureActivitySelectorCell:cell];
        } break;
        case 1: {
            [self configureRecordPeriodSelectorCell:cell];
        } break;
        case 2: {
            [self configureChartCell:cell];
        } break;
        default: {
        } break;
    }
}

- (void)configureRecordPeriodSelectorCell:(UITableViewCell *)cell {
}

- (void)configureActivitySelectorCell:(UITableViewCell *)cell {
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
    switch (_dayRecordChart.activityType) {
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
}

- (void)configureChartCell:(UITableViewCell *)cell {
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    CGRect frame = cell.contentView.bounds;
    frame.origin.x -= 10;
    frame.size.height *= 4;
    _chart = [[UUChart alloc] initwithUUChartDataFrame:frame
                                            withSource:self
                                             withStyle:UUChartLineStyle];
    [_chart showInView:cell.contentView];
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
    
    ret = 2; // one for activity type selector, one for chart.
    
    return ret;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"DayRecordCell";
    NSInteger row = indexPath.row;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:cellIdentifier];
    }
    [self configureCell:cell index:row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    if (row == 1) {
        return 200;
    } else {
        return 44;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    if (row == 1) {
        return 200;
    } else {
        return 44;
    }
}

#pragma mark - DayRecordChartDelegate
- (void)didActivityTypeChanged:(EMActivityType)activityType {
}

- (void)didDatasourceChangedXArray:(NSArray *)xArray yArray:(NSArray *)yArray {
    _xArray = xArray;
    _yArray = yArray;
    [_chart strokeChart];
}

#endif

@end
