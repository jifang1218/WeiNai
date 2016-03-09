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
#import "ToolboxViewController.h"
#import "SettingsViewController.h"
#import "UIMacros.h"

#import "EMActivityManager.h"

@interface MainViewController () {
    UINavigationController *_activitySummaryViewController;
    UINavigationController *_activityListViewController;
    UINavigationController *_toolboxViewController;
    UINavigationController *_settingsViewController;
}

- (void)selectedTapTabBarItems:(UITabBarItem *)tabBarItem;
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
    
    // activity summary
    ActivitySummaryViewController *activitySummaryViewController = [[ActivitySummaryViewController alloc] init];
    EMActivityManager *activityman = [EMActivityManager sharedInstance];
    EMDayRecord *dayRecord = [activityman todayRecord];
    activitySummaryViewController.dayRecord = dayRecord;
    _activitySummaryViewController = [[UINavigationController alloc] initWithRootViewController:activitySummaryViewController];
    _activitySummaryViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"今日汇总"
                                                                              image:nil
                                                                                tag:0];
    activitySummaryViewController.title = _activitySummaryViewController.tabBarItem.title;
    
    // activity list
    ActivityListViewController *activityListViewController = [[ActivityListViewController alloc] init];
    _activityListViewController = [[UINavigationController alloc] initWithRootViewController:activityListViewController];
    _activityListViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"全部记录"
                                                                           image:nil
                                                                             tag:1];
    
    // statistics
    ToolboxViewController *toolboxViewController = [[ToolboxViewController alloc] init];
    _toolboxViewController = [[UINavigationController alloc] initWithRootViewController:toolboxViewController];
    _toolboxViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"工具箱"
                                                                         image:nil
                                                                           tag:2];
    
    // settings
    SettingsViewController *settingsViewController = [[SettingsViewController alloc] init];
    _settingsViewController = [[UINavigationController alloc] initWithRootViewController:settingsViewController];
    _settingsViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"设置"
                                                                         image:nil
                                                                           tag:3];
    
    self.viewControllers = @[_activitySummaryViewController,
                             _activityListViewController,
                             _toolboxViewController,
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
