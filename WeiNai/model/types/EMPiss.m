//
//  EMPiss.m
//  WeiNai
//
//  Created by Ji Fang on 7/14/15.
//  Copyright (c) 2015 Ji Fang. All rights reserved.
//

#import "EMPiss.h"
#import "EMActivityBase.h"

@implementation EMPiss

@synthesize ml = _ml;
@synthesize color = _color;

- (id)init {
    if (self=[super init]) {
        _ml = 0;
        _color = PissColor_White;
        self.type = ActivityType_Piss;
    }
    
    return self;
}

@end
