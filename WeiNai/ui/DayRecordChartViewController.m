//
//  DayRecordChartViewController.m
//  WeiNai
//
//  Created by Ji Fang on 7/25/15.
//  Copyright (c) 2015 Ji Fang. All rights reserved.
//

#import "DayRecordChartViewController.h"
#import "UUChart.h"
#import "EMActivityManager.h"
#import "EMDayRecord.h"
#import "DayRecordChart.h"

@interface DayRecordChartViewController ()<UUChartDataSource, UITableViewDataSource, UITableViewDelegate, DayRecordChartDelegate> {
    UITableView *_tableview;
    DayRecordChart *_dayRecordChart;
    UUChart *_chart;
    NSArray *_xArray;
    NSArray *_yArray;
}

- (void)setupUI;
- (void)configureCell:(UITableViewCell *)cell index:(NSInteger)index;
- (void)configureActivitySelectorCell:(UITableViewCell *)cell;
- (void)configureChartCell:(UITableViewCell *)cell;
- (void)activityTypeSelected:(id)sender;

@end

@implementation DayRecordChartViewController

@dynamic activityType;
@dynamic dayRecord;

- (EMDayRecord *)dayRecord {
    return _dayRecordChart.dayRecord;
}

- (void)setDayRecord:(EMDayRecord *)dayRecord {
    _dayRecordChart.dayRecord = dayRecord;
}

- (void)setActivityType:(EMActivityType)activityType {
    _dayRecordChart.activityType = activityType;
}

- (EMActivityType)activityType {
    return _dayRecordChart.activityType;
}

- (id)init {
    if (self=[super init]) {
        _dayRecordChart = [[DayRecordChart alloc] init];
        _dayRecordChart.delegate = self;
    }
    
    return self;
}

- (void)dealloc {
    _dayRecordChart.delegate = nil;
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

- (UITableViewCell *)configureCellAtIndex:(NSInteger)index {
    UITableViewCell *cell = nil;
    switch (index) {
        case 0: {
            cell = [self configureActivitySelectorCell];
        } break;
        case 1: {
            cell = [self configureChartCell];
        } break;
        default: {
        } break;
    }
    
    return cell;
}

- (UITableViewCell *)configureActivitySelectorCell {
    UITableViewCell *cell = nil;
    static NSString *cellIdentifier = @"DayRecordChartCell_ActivitySelector";
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
    
    return cell;
}

- (UITableViewCell *)configureChartCell {
    UITableViewCell *cell = nil;
    static NSString *cellIdentifier = @"DayRecordChartCell_Chart";
    cell = [_tableview dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:cellIdentifier];
    }
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    CGRect frame = cell.contentView.bounds;
    frame.origin.x -= 10;
    frame.size.height = 200;
    _chart = [[UUChart alloc] initwithUUChartDataFrame:frame
                                            withSource:self
                                             withStyle:UUChartLineStyle];
    [_chart showInView:cell.contentView];
    
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
    
    ret = 2; // one for activity type selector, one for chart.
    
    return ret;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    
    cell = [self configureCellAtIndex:indexPath.row];
    
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
    [_tableview reloadData];
}

#pragma mark - actions
- (void)activityTypeSelected:(id)sender {
    if ([sender isKindOfClass:[UISegmentedControl class]]) {
        UISegmentedControl *seg = (UISegmentedControl *)sender;
        NSInteger index = seg.selectedSegmentIndex;
        switch (index) {
            case 0: {
                _dayRecordChart.activityType = ActivityType_Milk;
            } break;
            case 1: {
                _dayRecordChart.activityType = ActivityType_Piss;
            } break;
            case 2: {
                _dayRecordChart.activityType = ActivityType_Excrement;
            } break;
            case 3: {
                _dayRecordChart.activityType = ActivityType_Sleep;
            } break;
            default: {
            } break;
        }
    }
}

//- (void)

@end
