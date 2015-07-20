//
//  EMDayRecord.m
//  WeiNai
//
//  Created by Ji Fang on 7/14/15.
//  Copyright (c) 2015 Ji Fang. All rights reserved.
//

#import "EMDayRecord.h"
#import "NSDate+Category.h"
#import "UIMacros.h"
#import "EMActivityBase.h"

@class EMMilk;
@class EMExcrement;
@class EMPiss;
@class EMSleep;

@interface EMDayRecord() {
    NSMutableArray *_milks;
    NSMutableArray *_excrements;
    NSMutableArray *_pisses;
    NSMutableArray *_sleeps;
}

- (BOOL)addMilk:(EMMilk *)milk;
- (BOOL)addExcrement:(EMExcrement *)excrement;
- (BOOL)addPiss:(EMPiss *)piss;
- (BOOL)addSleep:(EMSleep *)sleep;

@end

@implementation EMDayRecord

@synthesize milks = _milks;
@synthesize excrements = _excrements;
@synthesize pisses = _pisses;
@synthesize sleeps = _sleeps;

@synthesize date = _date;

- (id)init {
    if (self=[super init]) {
        _milks = [[NSMutableArray alloc] init];
        _excrements = [[NSMutableArray alloc] init];
        _pisses = [[NSMutableArray alloc] init];
        _sleeps = [[NSMutableArray alloc] init];
        
        NSDate *now = [NSDate date];
        _date = [[NSDateComponents alloc] init];
        _date.year = now.year;
        _date.month = now.month;
        _date.day = now.day;
        _date.hour = now.hour;
        _date.minute = now.minute;
        _date.second = now.seconds;
    }
    
    return self;
}

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

- (BOOL)addActivity:(EMActivityBase *)activity {
    BOOL ret = NO;
    
    EMActivityType type = activity.type;
    switch (type) {
        case ActivityType_Excrement: {
            EMExcrement *excrement = (EMExcrement *)activity;
            ret = [self addExcrement:excrement];
        } break;
        case ActivityType_Milk: {
            EMMilk *milk = (EMMilk *)activity;
            ret = [self addMilk:milk];
        } break;
        case ActivityType_Piss: {
            EMPiss *piss = (EMPiss *)activity;
            ret = [self addPiss:piss];
        } break;
        case ActivityType_Sleep: {
            EMSleep *sleep = (EMSleep *)activity;
            ret = [self addSleep:sleep];
        } break;
        default: {
        } break;
    }
    
    return ret;
}

@end
