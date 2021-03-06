//
//  EMSleep.h
//  WeiNai
//
//  Created by Ji Fang on 7/14/15.
//  Copyright (c) 2015 Ji Fang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EMActivityBase.h"
#import "UIMacros.h"

@interface EMSleep : EMActivityBase

@property (nonatomic) NSUInteger durationInMinutes;
@property (nonatomic) EMSleepQuality quality;

@end
