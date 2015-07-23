//
//  ActivityDetailViewController.m
//  WeiNai
//
//  Created by Ji Fang on 7/15/15.
//  Copyright (c) 2015 Ji Fang. All rights reserved.
//

#import "ActivityDetailViewController.h"
#import "ActivityDetail.h"
#import "EMActivityManager.h"
#import "CreateActivityViewController.h"

@interface ActivityDetailViewController()<UITableViewDataSource, UITableViewDelegate, ActivityDetailDelegate> {
    UITableView *_tableView;
    ActivityDetail *_activityDetail;
}

- (void)setupUI;
- (void)configureCell:(UITableViewCell *)cell
                index:(NSInteger)index;

- (void)addActivity:(id)sender;

@end

@implementation ActivityDetailViewController

@dynamic activities;
@dynamic activityType;

- (NSArray *)activities {
    NSArray *ret = nil;
    
    ret = _activityDetail.activities;
    
    return ret;
}

- (void)setActivities:(NSArray *)activities {
    _activityDetail.activities = activities;
}

- (EMActivityType)activityType {
    return _activityDetail.activityType;
}

- (void)setActivityType:(EMActivityType)activityType {
    _activityDetail.activityType = activityType;
}

- (id)init {
    if (self=[super init]) {
        _activityDetail = [[ActivityDetail alloc] init];
        _activityDetail.delegate = self;
    }
    
    return self;
}

- (void)dealloc {
    _activityDetail.delegate = nil;
}

- (void)viewDidLoad {
    // title
    EMActivityManager *activityMan = [EMActivityManager sharedInstance];
    NSString *strActivityType = [activityMan ActivityType2String:_activityDetail.activityType];
    self.title = [[NSString alloc] initWithFormat:@"今日明细 - %@", strActivityType];
    UIBarButtonItem *addActivityButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                       target:self
                                                                                       action:@selector(addActivity:)];
    self.navigationItem.rightBarButtonItem = addActivityButton;
    
    [self setupUI];
}

#pragma mark - helper
- (void)configureCell:(UITableViewCell *)cell
                index:(NSInteger)index {
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    UILabel *label = [[UILabel alloc] initWithFrame:cell.contentView.bounds];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = [_activityDetail activityStringAtIndex:index];
    [cell setUserInteractionEnabled:NO];
    [cell.contentView addSubview:label];
}

- (void)setupUI {
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
}

#pragma mark - actions
- (void)addActivity:(id)sender {
    CreateActivityViewController *viewController = [[CreateActivityViewController alloc] init];
    viewController.activityType = _activityDetail.activityType;
    [self.navigationController pushViewController:viewController
                                         animated:YES];
}

#pragma mark - tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger ret = 0;
    
    ret = _activityDetail.activities.count;
    
    return ret;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"ActivityDetailTableviewCell";
    NSInteger row = indexPath.row;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:cellIdentifier];
    }
    [self configureCell:cell index:row];
    
    return cell;
}

#pragma mark - ActivityDetailDelegate
- (void)didActivitiesChanged:(NSArray *)activities {
    [_tableView reloadData];
}

@end
