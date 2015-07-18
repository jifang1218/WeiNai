//
//  EMExcrement.m
//  WeiNai
//
//  Created by Ji Fang on 7/14/15.
//  Copyright (c) 2015 Ji Fang. All rights reserved.
//

#import "EMExcrement.h"
#import "EMActivityBase.h"

@implementation EMExcrement

@synthesize quality = _quality;
@synthesize g = _g;

- (id)init {
    if (self=[super init]) {
        _quality = ExcrementQualityGood;
        _g = 0;
        self.type = ActivityType_Excrement;
    }
    
    return self;
}

@end
