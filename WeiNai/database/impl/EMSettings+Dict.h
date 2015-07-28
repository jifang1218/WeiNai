//
//  EMSettings+Dict.h
//  WeiNai
//
//  Created by Ji Fang on 7/28/15.
//  Copyright (c) 2015 Ji Fang. All rights reserved.
//

#import "EMSettings.h"

static NSString *kChartStyle = @"chart_style";

@interface EMSettings (Dict)

- (NSDictionary *)toDict;
- (id)initWithDict:(NSDictionary *)dict;

@end
