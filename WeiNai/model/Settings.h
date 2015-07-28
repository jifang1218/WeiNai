//
//  Settings.h
//  WeiNai
//
//  Created by Ji Fang on 7/28/15.
//  Copyright (c) 2015 Ji Fang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIMacros.h"

@protocol SettingsDelegate <NSObject>

@optional
- (void)didChartStyleChanged:(EMChartStyle)chartStyle;

@end

@interface Settings : NSObject

@property (nonatomic, weak) id<SettingsDelegate> delegate;
@property (nonatomic) EMChartStyle chartStyle;

- (NSString *)chartStyle2String:(EMChartStyle)chartStyle;

@end
