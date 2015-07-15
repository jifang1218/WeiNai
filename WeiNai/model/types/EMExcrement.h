//
//  EMExcrement.h
//  WeiNai
//
//  Created by Ji Fang on 7/14/15.
//  Copyright (c) 2015 Ji Fang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EMActivityBase.h"

typedef enum _EMExcrementQuality {
    ExcrementQualityGood = 0,
    ExcrementQualityBad
} EMExcrementQuality;

@interface EMExcrement : EMActivityBase

@property (nonatomic) float kg;
@property (nonatomic) EMExcrementQuality quality;

@end
