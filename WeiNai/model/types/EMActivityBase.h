//
//  EMActivityBase.h
//  WeiNai
//
//  Created by Ji Fang on 7/14/15.
//  Copyright (c) 2015 Ji Fang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EMActivityBase : NSObject

// valid fields: hour, minute, second;
@property (nonatomic, strong) NSDateComponents *time;
@property (nonatomic, strong) NSString *memo;

@end
