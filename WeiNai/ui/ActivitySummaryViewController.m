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
    cell.textLabel.text = @"喂奶";
    NSString *mlText = [[NSString alloc] initWithFormat:@"共 %lu 毫升", (unsigned long)_milkSummary.ml];
    cell.detailTextLabel.text = mlText;
}

- (void)decorateSleepCell:(UITableViewCell *)cell {
    cell.textLabel.text = @"睡觉";
    NSString *durationText = [[NSString alloc] initWithFormat:@"共 %lu 分钟", (unsigned long)_sleepSummary.durationInMinutes];
    cell.detailTextLabel.text = durationText;
}

- (void)decoratePissCell:(UITableViewCell *)cell {
    cell.textLabel.text = @"尿尿";
    NSString *mlText = [[NSString alloc] initWithFormat:@"共 %lu 毫升", (unsigned long)_pissSummary.ml];
    cell.detailTextLabel.text = mlText;
}

- (void)decorateExcrementCell:(UITableViewCell *)cell {
    cell.textLabel.text = @"大便";
    NSString *kgText = [[NSString alloc] initWithFormat:@"共 %g 克", _excrementSummary.kg * 1000];
    cell.detailTextLabel.text = kgText;
}

- (void)decorateDateCell:(UITableViewCell *)cell {
    NSDateFormatter*formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *localeString=[formatter stringFromDate: [NSDate date]];
    cell.textLabel.text = localeString;
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
        [self decorateCell:cell indexPath:indexPath];
    }
    
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

#pragma mark - action
- (void)addActivity:(UIBarButtonItem *)sender {
    CreateActivityViewController *viewController = [[CreateActivityViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
