//
//  ActivityListViewController.m
//  WeiNai
//
//  Created by Ji Fang on 7/15/15.
//  Copyright (c) 2015 Ji Fang. All rights reserved.
//

#import "ActivityListViewController.h"
#import "ActivityList.h"

@interface ActivityListViewController()<ActivityListDelegate, UITableViewDataSource, UITableViewDelegate> {
    ActivityList *_activityList;
    UITableView *_tableview;
}

- (void)setupUI;
- (void)configureCell:(UITableViewCell *)cell
              atIndex:(NSInteger)index;

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
    self.title = self.navigationController.tabBarItem.title;
    [self setupUI];
}

#pragma mark - helpers
- (void)setupUI {
    // table
    _tableview = [[UITableView alloc] initWithFrame:self.view.bounds
                                              style:UITableViewStylePlain];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    [self.view addSubview:_tableview];
}

- (void)configureCell:(UITableViewCell *)cell
              atIndex:(NSInteger)index {
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    NSString *dayRecordText = [_activityList dayRecordSummaryAtIndex:index];
    UILabel *label = [[UILabel alloc] initWithFrame:cell.contentView.bounds];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = dayRecordText;
    [cell.contentView addSubview:label];
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:cellIdentifier];
    }
    NSInteger index = indexPath.row;
    [self configureCell:cell atIndex:index];
    
    return cell;
}

#pragma mark - ActivityListDelegate
- (void)didActivitiesChanged:(NSArray *)activities {
    [_tableview reloadData];
}

@end
