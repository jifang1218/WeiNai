//
//  ActivityListViewController.m
//  WeiNai
//
//  Created by Ji Fang on 7/15/15.
//  Copyright (c) 2015 Ji Fang. All rights reserved.
//

#import "ActivityListViewController.h"
#import "ActivityList.h"
#import "ActivitySummaryViewController.h"

@interface ActivityListViewController()<ActivityListDelegate, UITableViewDataSource, UITableViewDelegate> {
    ActivityList *_activityList;
    UITableView *_tableview;
}

- (void)setupUI;
- (void)configureCell:(UITableViewCell *)cell
              atIndex:(NSInteger)index;
- (void)showChart:(id)sender;

@end

@implementation ActivityListViewController

- (id)init {
    if (self=[super init]) {
        _activityList = [[ActivityList alloc] init];
        _activityList.delegate = self;
    }
    
    return self;
}

- (void)dealloc {
    _activityList.delegate = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;

    self.title = self.navigationController.tabBarItem.title;
    [self setupUI];
}

#pragma mark - actions
- (void)showChart:(id)sender {
}

#pragma mark - helpers
- (void)setupUI {
    // right button
    NSMutableArray *rightButtons = [[NSMutableArray alloc] init];
    UIBarButtonItem *showChartButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                                                     target:self
                                                                                     action:@selector(showChart:)];
    [rightButtons addObject:showChartButton];
    self.navigationItem.rightBarButtonItems = rightButtons;
    
    // table
    _tableview = [[UITableView alloc] initWithFrame:self.view.bounds
                                              style:UITableViewStylePlain];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    [self.view addSubview:_tableview];
}

- (void)configureCell:(UITableViewCell *)cell
              atIndex:(NSInteger)index {
    NSString *dayRecordTime = [_activityList dayRecordTimeTextAtIndex:index];
    cell.textLabel.text = dayRecordTime;
    NSString *dayRecordText = [_activityList dayRecordSummaryTextAtIndex:index];
    cell.detailTextLabel.text = dayRecordText;
    cell.detailTextLabel.font = [UIFont fontWithName:nil size:10];
}

#pragma mark - tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    NSInteger ret = 0;
    
    NSArray *allDayRecords = [_activityList allDayRecords];
    ret = allDayRecords.count;
    
    return ret;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"ActivityListCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:cellIdentifier];
    }
    NSInteger index = indexPath.row;
    [self configureCell:cell atIndex:index];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger row = indexPath.row;
    EMDayRecord *dayRecord = [_activityList dayRecordAtIndex:row];
    ActivitySummaryViewController *activitySummaryViewController = [[ActivitySummaryViewController alloc] init];
    activitySummaryViewController.dayRecord = dayRecord;
    activitySummaryViewController.title = @"单日记录";
    [self.navigationController pushViewController:activitySummaryViewController
                                         animated:YES];
}

#pragma mark - ActivityListDelegate
- (void)didActivitiesChanged:(NSArray *)activities {
    [_tableview reloadData];
}

@end
