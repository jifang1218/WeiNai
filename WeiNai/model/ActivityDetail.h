//
//  ActivityDetail.h
//  WeiNai
//
//  Created by Ji Fang on 7/23/15.
//  Copyright (c) 2015 Ji Fang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIMacros.h"

@protocol ActivityDetailDelegate <NSObject>

@optional
- (void)didActivityTypeChanged:(EMActivityType)activityType;
- (void)didActivitiesChanged:(NSArray *)activities;

@end

@interface ActivityDetail : NSObject

@property (nonatomic, weak) id<ActivityDetailDelegate> delegate;
@property (nonatomic, weak) NSArray *activities;
@property (nonatomic) EMActivityType activityType;
@property (nonatomic, strong) NSDateComponents *date;

- (NSString *)activityStringAtIndex:(NSInteger)index;
- (NSArray *)chartXArray;
- (NSArray *)chartYArray;

@end
