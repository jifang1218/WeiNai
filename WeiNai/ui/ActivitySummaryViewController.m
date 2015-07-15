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

@end

@implementation ActivitySummaryViewController

//- (id)initWithCoder:(NSCoder *)aDecoder {
//    if (self=[super initWithCoder:aDecoder]) {
//        _summary = [[ActivitySummary alloc] init];
//        _summary.delegate = self;
//    }
//    
//    return self;
//}

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
    
    self.title = @"今日汇总";
}

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
    NSString *kgText = [[NSString alloc] initWithFormat:@"共 %g 公斤", _excrementSummary.kg];
    cell.detailTextLabel.text = kgText;
}

- (void)decorateCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath {
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    NSInteger row = indexPath.row;
    switch (row) {
        case 0: {
            [self decorateMilkCell:cell];
        } break;
        case 1: {
            [self decorateSleepCell:cell];
        } break;
        case 2: {
            [self decoratePissCell:cell];
        } break;
        case 3: {
            [self decorateExcrementCell:cell];
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                      reuseIdentifier:cellIdentifier];
        [self decorateCell:cell indexPath:indexPath];
    }
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger ret = 1;
    
    return ret;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // 1. milk, 2. excrement, 3. piss, 4. sleep
    NSInteger ret = 4;
    
    return ret;
}

@end
