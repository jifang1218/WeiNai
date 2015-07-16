//
//  CreateActivityViewController.m
//  WeiNai
//
//  Created by Ji Fang on 7/15/15.
//  Copyright (c) 2015 Ji Fang. All rights reserved.
//

#import "CreateActivityViewController.h"
#import "ActionSheetDatePicker.h"
#import "CreateActivity.h"

@interface CreateActivityViewController () <UITableViewDataSource, UITableViewDelegate, CreateActivityDelegate> {
    UITableView *_tableView;
    CreateActivity *_createActivity;
}

- (void)saveActivity:(UIBarButtonItem *)sender;
- (void)setupUI;

@end

@implementation CreateActivityViewController

- (id)init {
    if (self=[super init]) {
        _createActivity = [[CreateActivity alloc] init];
        _createActivity.delegate = self;
    }
    
    return self;
}

- (void)dealloc {
    _createActivity.delegate = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.title = @"新建活动";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                                                                           target:self
                                                                                           action:@selector(saveActivity:)];
    self.view.backgroundColor = [UIColor blueColor];
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
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds
                                              style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

#pragma mark - table
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    static NSString *cellIdentifier = @"CreateActivityCell";
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:cellIdentifier];
    }
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // 1. 活动类型; 2. 开始; 3. 结束; 4. 数据; 5. 备注
    NSInteger ret = 5;
    
    return ret;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger ret = 1;
    
    return ret;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *ret = nil;
    
    switch (section) {
        case 0: {
            ret = @"活动类型";
        } break;
        case 1: {
            ret = @"开始时间";
        } break;
        case 2: {
            ret = @"结束时间";
        } break;
        case 3: {
            ret = @"数值";
        } break;
        case 4: {
            ret = @"备注";
        } break;
        default: {
        } break;
    }
    
    return ret;
}

#pragma mark - actions
- (void)saveActivity:(UIBarButtonItem *)sender {
    ActionDateDoneBlock done = ^(ActionSheetDatePicker *picker, id selectedDate, id origin) {
    };
    ActionDateCancelBlock cancel = ^(ActionSheetDatePicker *picker) {
    };
    NSDate *now = [NSDate date];
    [ActionSheetDatePicker showPickerWithTitle:@"test"
                                datePickerMode:UIDatePickerModeTime
                                  selectedDate:now
                                   minimumDate:now
                                   maximumDate:now
                                     doneBlock:done
                                   cancelBlock:cancel
                                        origin:self.view];
}

@end
