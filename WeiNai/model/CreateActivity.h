//
//  CreateActivity.h
//  WeiNai
//
//  Created by Ji Fang on 7/16/15.
//  Copyright (c) 2015 Ji Fang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIMacros.h"

@protocol CreateActivityDelegate <NSObject>

@optional
- (void)didStartTimeChanged:(NSDate *)startTime;
- (void)didEndTimeChanged:(NSDate *)endTime;
- (void)didCurrentActivityTypeChanged:(EMActivityType)activityType;
- (void)didMilkTypeChanged:(EMMilkType)milkType;

@end

@class EMActivityBase;

@interface CreateActivity : NSObject

@property (nonatomic, weak) id<CreateActivityDelegate> delegate;
@property (nonatomic) EMActivityType currentActivityType;
@property (nonatomic, strong) NSDate *startTime;
@property (nonatomic, strong) NSDate *endTime;
@property (nonatomic) EMMilkType milkType;

#pragma mark - activity type helpers
- (NSUInteger)numberOfActivityTypes;
- (NSString *)activityType2String:(EMActivityType)activityType;
- (NSString *)activityTypeUnit2String:(EMActivityType)activityType;

#pragma mark - activity helpers
- (EMActivityBase *)generateActivity;

@end
