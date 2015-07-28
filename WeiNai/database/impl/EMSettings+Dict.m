//
//  EMSettings+Dict.m
//  WeiNai
//
//  Created by Ji Fang on 7/28/15.
//  Copyright (c) 2015 Ji Fang. All rights reserved.
//

#import "EMSettings+Dict.h"

@implementation EMSettings (Dict)

- (NSDictionary *)toDict {
    NSMutableDictionary *ret = [[NSMutableDictionary alloc] init];
    [ret setObject:[NSNumber numberWithUnsignedInteger:self.chartStyle]
            forKey:kChartStyle];
    
    return ret;
}

- (id)initWithDict:(NSDictionary *)dict {
    if (self=[super init]) {
        EMChartStyle chartStyle = (EMChartStyle)[[dict objectForKey:kChartStyle] unsignedIntegerValue];
        self.chartStyle = chartStyle;
    }
    
    return self;
}

@end
