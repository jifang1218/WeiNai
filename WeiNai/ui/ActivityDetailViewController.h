//
//  ActivityDetailViewController.h
//  WeiNai
//
//  Created by Ji Fang on 7/15/15.
//  Copyright (c) 2015 Ji Fang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIMacros.h"

@interface ActivityDetailViewController : UIViewController

@property (nonatomic, weak) NSArray *activities;
@property (nonatomic) EMActivityType activityType;
@property (nonatomic, weak) NSDateComponents *date;

@end
