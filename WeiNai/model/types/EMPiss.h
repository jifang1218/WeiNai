//
//  EMPiss.h
//  WeiNai
//
//  Created by Ji Fang on 7/14/15.
//  Copyright (c) 2015 Ji Fang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EMActivityBase.h"

typedef enum _EMPissColor {
    PissColor_White = 0,
    PissColor_Yellow
}EMPissColor;

@interface EMPiss : EMActivityBase

@property (nonatomic) NSUInteger ml;
@property (nonatomic) EMPissColor color;

@end
