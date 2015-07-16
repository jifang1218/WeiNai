//
//  CreateActivityViewController.m
//  WeiNai
//
//  Created by Ji Fang on 7/15/15.
//  Copyright (c) 2015 Ji Fang. All rights reserved.
//

#import "CreateActivityViewController.h"

@interface CreateActivityViewController () {
}

- (void)saveActivity:(UIBarButtonItem *)sender;
- (void)setupUI;

@end

@implementation CreateActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"新建活动";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                                                                           target:self
                                                                                           action:@selector(saveActivity:)];
//    self.view.backgroundColor = [UIColor whiteColor];
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)setupUI {
    CGFloat nextY = 0;
    // 1. place start picker
    UILabel *startLabel = [[UILabel alloc] init];
    startLabel.text = @"开始时间";
    [startLabel sizeToFit];
    CGRect frame;
    frame = startLabel.frame;
    frame.origin.x = (self.view.frame.size.width - frame.size.width) / 2.0;
    frame.origin.y = nextY;
    startLabel.frame = frame;
    [self.view addSubview:startLabel];
    nextY += frame.size.height;
    return;
    
    
    UIDatePicker *startPicker = [[UIDatePicker alloc] init];
    frame = startPicker.frame;
    frame.origin.y = startLabel.frame.origin.y + startLabel.frame.size.height;
    startPicker.frame = frame;
    [self.view addSubview:startPicker];
    
    // 2. place end picker and end button
    UILabel *endLabel = [[UILabel alloc] init];
    endLabel.text = @"结束时间";
    [endLabel sizeToFit];
    frame = endLabel.frame;
    frame.origin.x = (self.view.frame.size.width - frame.size.width) / 2.0;
    frame.origin.y = startPicker.frame.origin.y + startPicker.frame.size.height;
    endLabel.frame = frame;
    [self.view addSubview:endLabel];
    
    UIDatePicker *endPicker = [[UIDatePicker alloc] init];
    frame = endPicker.frame;
    frame.origin.y = endLabel.frame.origin.y + endLabel.frame.size.height;
    endPicker.frame = frame;
    [self.view addSubview:endPicker];
}

#pragma mark - actions
- (void)saveActivity:(UIBarButtonItem *)sender {
}

@end
