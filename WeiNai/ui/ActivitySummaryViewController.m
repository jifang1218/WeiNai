//
//  ActivitySummaryViewController.m
//  WeiNai
//
//  Created by Ji Fang on 7/15/15.
//  Copyright (c) 2015 Ji Fang. All rights reserved.
//

#import "ActivitySummaryViewController.h"
#import "ActivitySummary.h"
#import "EMDayRecord.h"
#import "EMMilk.h"
#import "EMExcrement.h"
#import "EMPiss.h"
#import "EMSleep.h"
#import "CreateActivityViewController.h"
#import "UIMacros.h"
#import "Utility.h"
#import "ActivityDetailViewController.h"

@interface ActivitySummaryViewController()<ActivitySummaryDelegate> {
    ActivitySummary *_summary;
    EMMilk *_milkSummary;
    EMExcrement *_excrementSummary;
    EMPiss *_pissSummary;
    EMSleep *_sleepSummary;
}

- (void)decorateMilkCell:(UITableViewCell *)cell;
- (void)decorateSleepCell:(UITableViewCell *)cell;
- (void)decoratePissCell:(UITableViewCell *)cell;
- (void)decorateExcrementCell:(UITableViewCell *)cell;
- (void)decorateCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath;
- (void)decorateDateCell:(UITableViewCell *)cell;

- (void)addActivity:(UIBarButtonItem *)sender;

@end

@implementation ActivitySummaryViewController

- (id)init {
    if (self=[super init]) {
        _summary = [[ActivitySummary alloc] init];
        _summary.delegate = self;
    }
    
    return self;
}

- (void)viewDidLoad {
    EMDayRecord *record = nil;
    record = [_summary todayRecord];
    
    // get summaries
    _milkSummary = [_summary milkSummary];
    _excrementSummary = [_summary excrementSummary];
    _pissSummary = [_summary pissSummary];
    _sleepSummary = [_summary sleepSummary];
    
    UIBarButtonItem *addActivityButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                       target:self
                                                                                       action:@selector(addActivity:)];
    self.navigationItem.rightBarButtonItem = addActivityButton;
    
    self.title = self.navigationController.tabBarItem.title;
}

#pragma mark - table
- (void)decorateMilkCell:(UITableViewCell *)cell {
    NSString *text = [_summary activityType2String:ActivityType_Milk];
    NSString *unit = [_summary activityTypeUnit2String:ActivityType_Milk];
    cell.textLabel.text = text;
    NSString *mlText = [[NSString alloc] initWithFormat:@"共 %lu %@", _milkSummary.ml, unit];
    cell.detailTextLabel.text = mlText;
}

- (void)decorateSleepCell:(UITableViewCell *)cell {
    NSString *text = [_summary activityType2String:ActivityType_Sleep];
    NSString *unit = [_summary activityTypeUnit2String:ActivityType_Sleep];
    cell.textLabel.text = text;
    NSString *durationText = [[NSString alloc] initWithFormat:@"共 %lu %@", _sleepSummary.durationInMinutes, unit];
    cell.detailTextLabel.text = durationText;
}

- (void)decoratePissCell:(UITableViewCell *)cell {
    NSString *text = [_summary activityType2String:ActivityType_Piss];
    NSString *unit = [_summary activityTypeUnit2String:ActivityType_Piss];
    cell.textLabel.text = text;
    NSString *mlText = [[NSString alloc] initWithFormat:@"共 %lu %@", _pissSummary.ml, unit];
    cell.detailTextLabel.text = mlText;
}

- (void)decorateExcrementCell:(UITableViewCell *)cell {
    NSString *text = [_summary activityType2String:ActivityType_Excrement];
    NSString *unit = [_summary activityTypeUnit2String:ActivityType_Excrement];
    cell.textLabel.text = text;
    NSString *gText = [[NSString alloc] initWithFormat:@"共 %lu %@", _excrementSummary.g, unit];
    cell.detailTextLabel.text = gText;
}

- (void)decorateDateCell:(UITableViewCell *)cell {
    cell.textLabel.text = [Utility CurrentDateString];;
    [cell setUserInteractionEnabled:NO];
}

- (void)decorateCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    switch (row) {
        case 0: {
            [self decorateDateCell:cell];
        } break;
        case 1: {
            [self decorateMilkCell:cell];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        } break;
        case 2: {
            [self decorateSleepCell:cell];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        } break;
        case 3: {
            [self decoratePissCell:cell];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        } break;
        case 4: {
            [self decorateExcrementCell:cell];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        } break;
        default: {
        } break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    static NSString *cellIdentifier = @"SummaryCell";
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        if (indexPath.row != 0) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                          reuseIdentifier:cellIdentifier];
        } else {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:cellIdentifier];
        }
    }
    [self decorateCell:cell indexPath:indexPath];
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger ret = 1;
    
    return ret;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // 1. milk, 2. excrement, 3. piss, 4. sleep, plus date
    NSInteger ret = 4 + 1;
    
    return ret;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    
    switch (row) {
        case 0: {
            [tableView deselectRowAtIndexPath:indexPath
                                     animated:NO];
        } break;
        case 1: {
            [tableView deselectRowAtIndexPath:indexPath
                                     animated:YES];
            NSArray *milks = _summary.todayRecord.milks;
            ActivityDetailViewController *detailViewController = [[ActivityDetailViewController alloc] init];
            detailViewController.activities = milks;
            detailViewController.activityType = ActivityType_Milk;
            [self.navigationController pushViewController:detailViewController
                                                 animated:YES];
        } break;
        case 2: {
            [tableView deselectRowAtIndexPath:indexPath
                                     animated:YES];
            NSArray *sleeps = _summary.todayRecord.sleeps;
            ActivityDetailViewController *detailViewController = [[ActivityDetailViewController alloc] init];
            detailViewController.activities = sleeps;
            detailViewController.activityType = ActivityType_Sleep;
            [self.navigationController pushViewController:detailViewController
                                                 animated:YES];
        } break;
        case 3: {
            [tableView deselectRowAtIndexPath:indexPath
                                     animated:YES];
            NSArray *pisses = _summary.todayRecord.pisses;
            ActivityDetailViewController *detailViewController = [[ActivityDetailViewController alloc] init];
            detailViewController.activities = pisses;
            detailViewController.activityType = ActivityType_Piss;
            [self.navigationController pushViewController:detailViewController
                                                 animated:YES];
        } break;
        case 4: {
            [tableView deselectRowAtIndexPath:indexPath
                                     animated:YES];
            NSArray *excrements = _summary.todayRecord.excrements;
            ActivityDetailViewController *detailViewController = [[ActivityDetailViewController alloc] init];
            detailViewController.activities = excrements;
            detailViewController.activityType = ActivityType_Excrement;
            [self.navigationController pushViewController:detailViewController
                                                 animated:YES];
        } break;
        default: {
            [tableView deselectRowAtIndexPath:indexPath
                                     animated:NO];
        } break;
    }
}

#pragma mark - model delegate
- (void)didDayRecordChanged:(EMDayRecord *)dayRecord {
    // get summaries
    _milkSummary = [_summary milkSummary];
    _excrementSummary = [_summary excrementSummary];
    _pissSummary = [_summary pissSummary];
    _sleepSummary = [_summary sleepSummary];
    [self.tableView reloadData];
}

#pragma mark - action
- (void)addActivity:(UIBarButtonItem *)sender {
    CreateActivityViewController *viewController = [[CreateActivityViewController alloc] init];
    viewController.activityType = ActivityType_Milk;
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
