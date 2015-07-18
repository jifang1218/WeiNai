//
//  EMSleep.m
//  WeiNai
//
//  Created by Ji Fang on 7/14/15.
//  Copyright (c) 2015 Ji Fang. All rights reserved.
//

#import "EMSleep.h"
#import "EMActivityBase.h"

@implementation EMSleep

@synthesize durationInMinutes = _durationInMinutes;
@synthesize quality = _quality;

- (id)init {
    if (self=[super init]) {
        _durationInMinutes = 0;
        _quality = SleepQuality_Medium;
        self.type = ActivityType_Sleep;
    }
    
    return self;
}

@end
