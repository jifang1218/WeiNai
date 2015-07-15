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

@interface ActivitySummaryViewController()<ActivitySummaryDelegate> {
    ActivitySummary *_summary;
}

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
}

@end
