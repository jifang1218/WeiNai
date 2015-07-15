//
//  MainViewController.m
//  WeiNai
//
//  Created by Ji Fang on 7/13/15.
//  Copyright (c) 2015 Ji Fang. All rights reserved.
//

#import "MainViewController.h"
#import "ActivitySummaryViewController.h"
#import "ActivityListViewController.h"
#import "StatisticsViewController.h"
#import "SettingsViewController.h"
#import "UIMacros.h"

@interface MainViewController () {
    ActivitySummaryViewController *_activitySummaryViewController;
    ActivityListViewController *_activityListViewController;
    StatisticsViewController *_statisticsViewController;
    SettingsViewController *_settingsViewController;
}

-(void)selectedTapTabBarItems:(UITabBarItem *)tabBarItem;
- (void)setupSubviews;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self setupSubviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupSubviews {
    // tabs:
    // 1. today's activity summary;
    // 2. history activity list;
    // 3. statistics
    // 4. settings
    
//    self.tabBar.backgroundImage = [[UIImage imageNamed:@"tabbarBackground"] stretchableImageWithLeftCapWidth:25
//                                                                                                topCapHeight:25];
//    self.tabBar.selectionIndicatorImage = [[UIImage imageNamed:@"tabbarSelectBg"] stretchableImageWithLeftCapWidth:25
//                                                                                                      topCapHeight:25];
    
    _activitySummaryViewController = [[ActivitySummaryViewController alloc] init];
    _activitySummaryViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"今天"
                                                                              image:nil
                                                                                tag:0];
//    [_recordListViewController.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"tabbar_chatsHL"]
//                         withFinishedUnselectedImage:[UIImage imageNamed:@"tabbar_chats"]];
//    [self unSelectedTapTabBarItems:_chatListVC.tabBarItem];
//    [self selectedTapTabBarItems:_chatListVC.tabBarItem];
    
    _activityListViewController = [[ActivityListViewController alloc] init];
    _activityListViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"所有"
                                                                           image:nil
                                                                             tag:1];
//    [_contactsVC.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"tabbar_contactsHL"]
//                         withFinishedUnselectedImage:[UIImage imageNamed:@"tabbar_contacts"]];
//    [self unSelectedTapTabBarItems:_contactsVC.tabBarItem];
//    [self selectedTapTabBarItems:_contactsVC.tabBarItem];
    
    _statisticsViewController = [[StatisticsViewController alloc] init];
    _statisticsViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"统计"
                                                                         image:nil
                                                                           tag:2];
//    [_settingsVC.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"tabbar_settingHL"]
//                         withFinishedUnselectedImage:[UIImage imageNamed:@"tabbar_setting"]];
//    _settingsVC.view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
//    [self unSelectedTapTabBarItems:_settingsVC.tabBarItem];
//    [self selectedTapTabBarItems:_settingsVC.tabBarItem];
    
    _settingsViewController = [[SettingsViewController alloc] init];
    _settingsViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"设置"
                                                                         image:nil
                                                                           tag:3];
    
    self.viewControllers = @[_activitySummaryViewController,
                             _activityListViewController,
                             _statisticsViewController,
                             _settingsViewController];
    [self selectedTapTabBarItems:_activitySummaryViewController.tabBarItem];
}

-(void)selectedTapTabBarItems:(UITabBarItem *)tabBarItem {
    [tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                        [UIFont systemFontOfSize:14],
                                        NSFontAttributeName,RGBACOLOR(0x00, 0xac, 0xff, 1),
                                        NSForegroundColorAttributeName,
                                        nil]
                              forState:UIControlStateSelected];
}

@end
