//
//  EMDayRecord.m
//  WeiNai
//
//  Created by Ji Fang on 7/14/15.
//  Copyright (c) 2015 Ji Fang. All rights reserved.
//

#import "EMDayRecord.h"

@interface EMDayRecord() {
    NSMutableArray *_milks;
    NSMutableArray *_excrements;
    NSMutableArray *_pisses;
    NSMutableArray *_sleeps;
}

@end

@implementation EMDayRecord

@synthesize milks = _milks;
@synthesize excrements = _excrements;
@synthesize pisses = _pisses;
@synthesize sleeps = _sleeps;

@synthesize date = _date;

- (BOOL)addMilk:(EMMilk *)milk {
    BOOL ret = NO;
    
    if (milk) {
        if (![_milks containsObject:milk]) {
            [_milks addObject:milk];
        }
    }
    
    return ret;
}

- (BOOL)addExcrement:(EMExcrement *)excrement {
    BOOL ret = NO;
    
    if (excrement) {
        if (![_excrements containsObject:excrement]) {
            [_excrements addObject:excrement];
        }
    }
    
    return ret;
}

- (BOOL)addPiss:(EMPiss *)piss {
    BOOL ret = NO;
    
    if (piss) {
        if (![_pisses containsObject:piss]) {
            [_pisses addObject:piss];
        }
    }
    
    return ret;
}

- (BOOL)addSleep:(EMSleep *)sleep {
    BOOL ret = NO;
    
    if (sleep) {
        if (![_sleeps containsObject:sleep]) {
            [_sleeps addObject:sleep];
        }
    }
    
    return ret;
}

@end
