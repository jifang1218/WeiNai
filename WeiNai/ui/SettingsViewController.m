//
//  SettingsViewController.m
//  WeiNai
//
//  Created by Ji Fang on 7/15/15.
//  Copyright (c) 2015 Ji Fang. All rights reserved.
//

#import "SettingsViewController.h"
#import "Settings.h"

@interface SettingsViewController ()<UITableViewDataSource, UITableViewDelegate, SettingsDelegate> {
    UITableView *_tableview;
    Settings *_settings;
}

- (void)setupUI;
- (UITableViewCell *)configureChartStyleCell;
- (void)changeChartStyle:(id)sender;

@end

@implementation SettingsViewController

- (id)init {
    if (self=[super init]) {
        _settings = [[Settings alloc] init];
        _settings.delegate = self;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.title = self.navigationController.tabBarItem.title;
    
    [self setupUI];
}

#pragma mark - ui helpers
- (void)setupUI {
    _tableview = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    [self.view addSubview:_tableview];
}

- (UITableViewCell *)configureChartStyleCell {
    UITableViewCell *cell = nil;
    static NSString *identifier = @"SettingsCell_ChartStyle";
    cell = [_tableview dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:identifier];
    }
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    NSArray *segItems = @[[_settings chartStyle2String:ChartStyle_Line],
                          [_settings chartStyle2String:ChartStyle_Bar]];
    UISegmentedControl *chartStyleSeg = [[UISegmentedControl alloc] initWithItems:segItems];
    [chartStyleSeg addTarget:self
                      action:@selector(changeChartStyle:)
            forControlEvents:UIControlEventValueChanged];
    NSInteger index = 0;
    EMChartStyle chartStyle = [_settings chartStyle];
    switch (chartStyle) {
        case ChartStyle_Line: {
            index = 0;
        } break;
        case ChartStyle_Bar: {
            index = 1;
        } break;
        default: {
        } break;
    }
    chartStyleSeg.selectedSegmentIndex = index;
    cell.accessoryView = chartStyleSeg;
    cell.textLabel.text = [[NSString alloc] initWithFormat:@"使用 %@ 显示数据", [_settings chartStyle2String:chartStyle]];
    
    return cell;
}

#pragma mark - tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger ret = 1;
    
    return ret;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *ret = nil;
    switch (section) {
        case 0: {
            ret = @"图表样式";
        } break;
        default: {
        } break;
    }
    
    return ret;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == 0 && row == 0) {
        cell = [self configureChartStyleCell];
    }
    
    return cell;
}

#pragma mark - actions
- (void)changeChartStyle:(id)sender {
    if ([sender isKindOfClass:[UISegmentedControl class]]) {
        UISegmentedControl *seg = (UISegmentedControl *)sender;
        NSInteger index = seg.selectedSegmentIndex;
        switch (index) {
            case 0: {
                _settings.chartStyle = ChartStyle_Line;
            } break;
            case 1: {
                _settings.chartStyle = ChartStyle_Bar;
            } break;
            default: {
            } break;
        }
    }
}

#pragma mark - settings delegate
- (void)didChartStyleChanged:(EMChartStyle)chartStyle {
    [_tableview reloadData];
}

@end
