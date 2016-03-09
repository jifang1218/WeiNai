//
//  EMMilk.m
//  WeiNai
//
//  Created by Ji Fang on 7/15/15.
//  Copyright (c) 2015 Ji Fang. All rights reserved.
//

#import "EMMilk.h"

@implementation EMMilk

@synthesize ml = _ml;

- (id)init {
    if (self=[super init]) {
        _ml = 0;
        self.type = ActivityType_PowderMilk;
    }
    
    return self;
}

@end
