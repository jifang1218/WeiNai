//
//  EMDayRecord+Dict.m
//  WeiNai
//
//  Created by Ji Fang on 7/22/15.
//  Copyright (c) 2015 Ji Fang. All rights reserved.
//

#import "EMDayRecord+Dict.h"
#import "NSDateComponents+Dict.h"
#import "EMBreastMilk+Dict.h"
#import "EMPowderMilk+Dict.h"
#import "EMExcrement+Dict.h"
#import "EMPiss+Dict.h"
#import "EMSleep+Dict.h"

@implementation EMDayRecord (Dict)

- (NSDictionary *)toDict {
    NSDictionary *ret = nil;
    
    // handle date
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    NSDictionary *dateDict = [self.date toDict];
    [dict setObject:dateDict
             forKey:kDate];
    
    // handle milks
    NSMutableArray *milkDicts = [[NSMutableArray alloc] initWithCapacity:self.milks.count];
    for (EMMilk *milk in self.milks) {
        NSDictionary *milkDict = [milk toDict];
        [milkDicts addObject:milkDict];
    }
    [dict setObject:milkDicts
             forKey:kMilks];
    
    // handle excrements
    NSMutableArray *excrementDicts = [[NSMutableArray alloc] initWithCapacity:self.excrements.count];
    for (EMExcrement *excrement in self.excrements) {
        NSDictionary *excrementDict = [excrement toDict];
        [excrementDicts addObject:excrementDict];
    }
    [dict setObject:excrementDicts
             forKey:kExcrements];
    
    // handle pisses
    NSMutableArray *pissDicts = [[NSMutableArray alloc] initWithCapacity:self.pisses.count];
    for (EMPiss *piss in self.pisses) {
        NSDictionary *pissDict = [piss toDict];
        [pissDicts addObject:pissDict];
    }
    [dict setObject:pissDicts
             forKey:kPisses];
    
    // handle sleeps
    NSMutableArray *sleepDicts = [[NSMutableArray alloc] initWithCapacity:self.sleeps.count];
    for (EMSleep *sleep in self.sleeps) {
        NSDictionary *sleepDict = [sleep toDict];
        [sleepDicts addObject:sleepDict];
    }
    [dict setObject:sleepDicts
             forKey:kSleeps];
    
    ret = dict;
    
    return ret;
}

- (id)initWithDict:(NSDictionary *)dict {
    if (self=[super init]) {
        
        // handle date
        NSDictionary *dateDict = [dict objectForKey:kDate];
        NSDateComponents *date = [[NSDateComponents alloc] initWithDict:dateDict];
        self.date = date;
        
        // handle milks
        NSArray *milkDicts = [dict objectForKey:kMilks];
        NSMutableArray *milks = [[NSMutableArray alloc] initWithCapacity:milkDicts.count];
        for (NSDictionary *milkDict in milkDicts) {
            EMMilk *milk = nil;
            if ([milkDict objectForKey:kPerson] == nil) { // milk powder
                EMPowderMilk *milkPowder = [[EMPowderMilk alloc] initWithDict:milkDict];
                milk = milkPowder;
            } else { // milk breast
                EMBreastMilk *milkBreast = [[EMBreastMilk alloc] initWithDict:milkDict];
                milk = milkBreast;
            }
            [milks addObject:milk];
        }
        self.milks = milks;
        
        // handle excrements
        NSArray *excrementDicts = [dict objectForKey:kExcrements];
        NSMutableArray *excrements = [[NSMutableArray alloc] initWithCapacity:excrementDicts.count];
        for (NSDictionary *excrementDict in excrementDicts) {
            EMExcrement *excrement = [[EMExcrement alloc] initWithDict:excrementDict];
            [excrements addObject:excrement];
        }
        self.excrements = excrements;
        
        // handle pisses
        NSArray *pissDicts = [dict objectForKey:kPisses];
        NSMutableArray *pisses = [[NSMutableArray alloc] initWithCapacity:pissDicts.count];
        for (NSDictionary *pissDict in pissDicts) {
            EMPiss *piss = [[EMPiss alloc] initWithDict:pissDict];
            [pisses addObject:piss];
        }
        self.pisses = pisses;
        
        // handle sleeps
        NSArray *sleepDicts = [dict objectForKey:kSleeps];
        NSMutableArray *sleeps = [[NSMutableArray alloc] initWithCapacity:sleepDicts.count];
        for (NSDictionary *sleepDict in sleepDicts) {
            EMSleep *sleep = [[EMSleep alloc] initWithDict:sleepDict];
            [sleeps addObject:sleep];
        }
        self.sleeps = sleeps;
    }
    
    return self;
}

@end
