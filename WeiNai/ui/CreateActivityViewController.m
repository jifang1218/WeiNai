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
#import "Utility.h"

#define kSetStartButtonTag   100
#define kSetEndButtonTag     101
#define kSetCurrentButtonTag 102

@interface CreateActivityViewController () <UITableViewDataSource, UITableViewDelegate, CreateActivityDelegate> {
    UITableView *_tableView;
    CreateActivity *_createActivity;
    UITableViewCell *_startCell;
    UITableViewCell *_activityTypeCell;
    UITableViewCell *_endCell;
}

- (void)saveActivity:(UIBarButtonItem *)sender;
- (void)setupUI;
- (UITableViewCell *)_configureActivityTypeCell;
- (UITableViewCell *)_configureStartCell;
- (UITableViewCell *)_configureEndCell;
- (UITableViewCell *)_configureValueCell;
- (UITableViewCell *)_configureMemoCell;
- (void)selectTime:(id)sender;

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
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.backgroundView = nil;
    [self.view addSubview:_tableView];
}

#pragma mark - table
- (UITableViewCell *)_configureActivityTypeCell {
    static NSString *cellIdentifier = @"CreateActivityTypeCell";
    UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:cellIdentifier];
        UISegmentedControl *typesSeg = [[UISegmentedControl alloc] initWithItems:
                                        @[[_createActivity activityType2String:ActivityType_Milk],
                                          [_createActivity activityType2String:ActivityType_Piss],
                                          [_createActivity activityType2String:ActivityType_Excrement],
                                          [_createActivity activityType2String:ActivityType_Sleep],
                                          ]];
        typesSeg.selectedSegmentIndex = 0;
        typesSeg.frame = cell.contentView.bounds;
        [cell.contentView addSubview:typesSeg];
        cell.backgroundColor = [UIColor clearColor];
        cell.backgroundView = nil;
    }
    _activityTypeCell = cell;
    
    return cell;
}

- (UITableViewCell *)_configureStartCell {
    static NSString *cellIdentifier = @"CreateActivityStartCell";
    UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:cellIdentifier];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [button addTarget:self
                   action:@selector(selectTime:)
         forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:@"设定"
                forState:UIControlStateNormal];
        [button sizeToFit];
        button.tag = kSetStartButtonTag;
        cell.accessoryView = button;
        cell.textLabel.text = [Utility CurrentTimeString];
    }
    _startCell = cell;
    
    return cell;
}

- (UITableViewCell *)_configureEndCell {
    static NSString *cellIdentifier = @"CreateActivityEndCell";
    UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:cellIdentifier];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [button addTarget:self
                   action:@selector(selectTime:)
         forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:@"设定"
                forState:UIControlStateNormal];
        [button sizeToFit];
        button.tag = kSetEndButtonTag;
        cell.accessoryView = button;
        cell.textLabel.text = [Utility CurrentTimeString];
    }
    _endCell = cell;;
    
    return cell;
}

- (UITableViewCell *)_configureValueCell {
    static NSString *cellIdentifier = @"ActivityValueCell";
    UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:cellIdentifier];
    }
    
    return cell;
}

- (UITableViewCell *)_configureMemoCell {
    static NSString *cellIdentifier = @"ActivityMemoCell";
    UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:cellIdentifier];
    }
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    NSInteger section = indexPath.section;
    switch (section) {
        case 0: { // 活动类型
            cell = [self _configureActivityTypeCell];
        } break;
        case 1: { // 开始时间
            cell = [self _configureStartCell];
        } break;
        case 2: { // 结束时间
            cell = [self _configureEndCell];
        } break;
        case 3: { // 数值
            cell = [self _configureValueCell];
        } break;
        case 4: { // 备注
            cell = [self _configureMemoCell];
        } break;
        default: {
        } break;
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
- (void)selectTime:(id)sender {
    UIButton *button = nil;
    if (![sender isKindOfClass:[UIButton class]]) {
        return;
    }
    button = (UIButton *)sender;
    NSInteger tag = button.tag;
    
    ActionDateDoneBlock startDone = ^(ActionSheetDatePicker *picker, id selectedDate, id origin) {
    };
    ActionDateDoneBlock endDone = ^(ActionSheetDatePicker *picker, id selectedDate, id origin) {
    };
    ActionDateDoneBlock modifyDone = ^(ActionSheetDatePicker *picker, id selectedDate, id origin) {
    };
    ActionDateCancelBlock startCancel = ^(ActionSheetDatePicker *picker) {
    };
    ActionDateCancelBlock endCancel = ^(ActionSheetDatePicker *picker) {
    };
    ActionDateCancelBlock modifyCancel = ^(ActionSheetDatePicker *picker) {
    };
    
    ActionDateDoneBlock done = nil;
    ActionDateCancelBlock cancel = nil;
    NSDate *now = [NSDate date];
    if (tag == kSetStartButtonTag) {
        done = startDone;
        cancel = startCancel;
    } else if (tag == kSetEndButtonTag) {
        done = endDone;
        cancel = endCancel;
    } else {
    }
    [ActionSheetDatePicker showPickerWithTitle:@"test"
                                datePickerMode:UIDatePickerModeTime
                                  selectedDate:now
                                   minimumDate:now
                                   maximumDate:now
                                     doneBlock:done
                                   cancelBlock:cancel
                                        origin:self.view];
}

- (void)saveActivity:(UIBarButtonItem *)sender {
}

@end
