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
#import "NSDate+Category.h"
#import "DayRecordChartViewController.h"

@interface ActivitySummaryViewController()<ActivitySummaryDelegate> {
    ActivitySummary *_summary;
    EMMilk *_milkSummary;
    EMExcrement *_excrementSummary;
    EMPiss *_pissSummary;
    EMSleep *_sleepSummary;
}

- (UITableViewCell *)decorateMilkCell;
- (UITableViewCell *)decorateSleepCell;
- (UITableViewCell *)decoratePissCell;
- (UITableViewCell *)decorateExcrementCell;
- (UITableViewCell *)decorateCellAtIndex:(NSInteger)index;
- (UITableViewCell *)decorateDateCell;

- (void)addActivity:(UIBarButtonItem *)sender;
- (void)showChart:(id)sender;

@end

@implementation ActivitySummaryViewController

@dynamic dayRecord;

- (id)init {
    if (self=[super init]) {
        _summary = [[ActivitySummary alloc] init];
        _summary.delegate = self;
    }
    
    return self;
}

- (EMDayRecord *)dayRecord {
    EMDayRecord *ret = nil;
    
    ret = _summary.dayRecord;
    
    return ret;
}

- (void)setDayRecord:(EMDayRecord *)dayRecord {
    _summary.dayRecord = dayRecord;
}

- (void)viewDidLoad {    
    // get summaries
    _milkSummary = [_summary milkSummary];
    _excrementSummary = [_summary excrementSummary];
    _pissSummary = [_summary pissSummary];
    _sleepSummary = [_summary sleepSummary];
    
    NSMutableArray *rightButtons = [[NSMutableArray alloc] init];
    UIBarButtonItem *chartButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                                                 target:self
                                                                                 action:@selector(showChart:)];
    [rightButtons addObject:chartButton];
    
    // only available for today
    NSDateComponents *recordDate = _summary.dayRecord.date;
    NSDate *today = [NSDate date];
    if ((recordDate.year == today.year) &&
        (recordDate.month == today.month) &&
        (recordDate.day == today.day)) {
        UIBarButtonItem *addActivityButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                           target:self
                                                                                           action:@selector(addActivity:)];
        [rightButtons addObject:addActivityButton];
    }
    self.navigationItem.rightBarButtonItems = rightButtons;
}

#pragma mark - table
- (UITableViewCell *)decorateMilkCell {
    UITableViewCell *cell = nil;
    static NSString *cellIdentifier = @"ActivitySummaryCell_Milk";
    cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                      reuseIdentifier:cellIdentifier];
    }
    NSString *text = [_summary activityType2String:ActivityType_Milk];
    NSString *unit = [_summary activityTypeUnit2String:ActivityType_Milk];
    cell.textLabel.text = text;
    NSString *mlText = [[NSString alloc] initWithFormat:@"共 %lu %@", _milkSummary.ml, unit];
    cell.detailTextLabel.text = mlText;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (UITableViewCell *)decorateSleepCell {
    UITableViewCell *cell = nil;
    static NSString *cellIdentifier = @"ActivitySummaryCell_Sleep";
    cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                      reuseIdentifier:cellIdentifier];
    }
    NSString *text = [_summary activityType2String:ActivityType_Sleep];
    NSString *unit = [_summary activityTypeUnit2String:ActivityType_Sleep];
    cell.textLabel.text = text;
    NSString *durationText = [[NSString alloc] initWithFormat:@"共 %lu %@", _sleepSummary.durationInMinutes, unit];
    cell.detailTextLabel.text = durationText;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (UITableViewCell *)decoratePissCell {
    UITableViewCell *cell = nil;
    static NSString *cellIdentifier = @"ActivitySummaryCell_Piss";
    cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                      reuseIdentifier:cellIdentifier];
    }
    NSString *text = [_summary activityType2String:ActivityType_Piss];
    NSString *unit = [_summary activityTypeUnit2String:ActivityType_Piss];
    cell.textLabel.text = text;
    NSString *mlText = [[NSString alloc] initWithFormat:@"共 %lu %@", _pissSummary.ml, unit];
    cell.detailTextLabel.text = mlText;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (UITableViewCell *)decorateExcrementCell {
    UITableViewCell *cell = nil;
    static NSString *cellIdentifier = @"ActivitySummaryCell_Excrement";
    cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                      reuseIdentifier:cellIdentifier];
    }
    NSString *text = [_summary activityType2String:ActivityType_Excrement];
    NSString *unit = [_summary activityTypeUnit2String:ActivityType_Excrement];
    cell.textLabel.text = text;
    NSString *gText = [[NSString alloc] initWithFormat:@"共 %lu %@", _excrementSummary.g, unit];
    cell.detailTextLabel.text = gText;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (UITableViewCell *)decorateDateCell {
    UITableViewCell *cell = nil;
    static NSString *cellIdentifier = @"ActivitySummaryCell_Date";
    cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = [_summary dateString];
    [cell setUserInteractionEnabled:NO];
    
    return cell;
}

- (UITableViewCell *)decorateCellAtIndex:(NSInteger)index {
    UITableViewCell *cell = nil;
    switch (index) {
        case 0: {
            cell = [self decorateDateCell];
        } break;
        case 1: {
            cell = [self decorateMilkCell];
        } break;
        case 2: {
            cell = [self decorateSleepCell];
        } break;
        case 3: {
            cell = [self decoratePissCell];
        } break;
        case 4: {
            cell = [self decorateExcrementCell];
        } break;
        default: {
        } break;
    }
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    cell = [self decorateCellAtIndex:indexPath.row];
    
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
    
    ActivityDetailViewController *detailViewController = nil;
    NSArray *activities = nil;
    EMActivityType activityType = ActivityType_Milk;
    
    if (row!=0) {
        detailViewController = [[ActivityDetailViewController alloc] init];
    } else {
        [tableView deselectRowAtIndexPath:indexPath
                                 animated:NO];
    }
    
    switch (row) {
        case 0: {
        } break;
        case 1: {
            activities = _summary.dayRecord.milks;
        } break;
        case 2: {
            activities = _summary.dayRecord.sleeps;
            activityType = ActivityType_Sleep;
        } break;
        case 3: {
            activities = _summary.dayRecord.pisses;
            activityType = ActivityType_Piss;
        } break;
        case 4: {
            activities = _summary.dayRecord.excrements;
            activityType = ActivityType_Excrement;
        } break;
        default: {
            [tableView deselectRowAtIndexPath:indexPath
                                     animated:NO];
        } break;
    }
    
    if (row!=0) {
        [tableView deselectRowAtIndexPath:indexPath
                                 animated:YES];
        detailViewController.activityType = activityType;
        detailViewController.activities = activities;
        detailViewController.date = _summary.dayRecord.date;
        [self.navigationController pushViewController:detailViewController
                                             animated:YES];
    } else {
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

- (void)showChart:(id)sender {
    DayRecordChartViewController *chartViewController = [[DayRecordChartViewController alloc] init];
    chartViewController.dayRecord = _summary.dayRecord;
    chartViewController.activityType = ActivityType_Milk;
    [self.navigationController pushViewController:chartViewController animated:YES];
}

@end
