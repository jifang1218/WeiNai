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
#import "EMActivityManager.h"
#import "NSDate+Category.h"
#import "DoneCancelNumberPadToolbar.h"
#import "EMActivityBase.h"

#define kSetStartButtonTag   100
#define kSetEndButtonTag     101
#define kSetCurrentButtonTag 102

@interface CreateActivityViewController () <UITableViewDataSource, UITableViewDelegate,
                                            CreateActivityDelegate, DoneCancelNumberPadToolbarDelegate> {
    UITableView *_tableView;
    CreateActivity *_createActivity;
    UITableViewCell *_startCell;
    UITableViewCell *_activityTypeCell;
    UITableViewCell *_endCell;
    UITableViewCell *_valueCell;
    UILabel *_valueUnitLabel;
    UITextField *_valueField;
    UISwitch *_breastMilkSwitch;
}

- (void)saveActivity:(UIBarButtonItem *)sender;
- (void)setupUI;
- (UITableViewCell *)_configureActivityTypeCell;
- (UITableViewCell *)_configureStartCell;
- (UITableViewCell *)_configureEndCell;
- (UITableViewCell *)_configureValueCell;
- (UITableViewCell *)_configureMemoCell;
- (void)selectTime:(id)sender;
- (void)updateSleepValue;
- (void)updateMilkSwitch;

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
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
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

#pragma mark - helper
- (void)updateMilkSwitch {
    if (_createActivity.currentActivityType == ActivityType_Milk) {
        _breastMilkSwitch.hidden = NO;
        _valueCell.detailTextLabel.text = @"是母乳吗?";
        _breastMilkSwitch.on = (_createActivity.milkType == MilkType_BreastMilk);
    } else {
        _breastMilkSwitch.hidden = YES;
        _valueCell.detailTextLabel.text = @"";
    }
}

- (void)updateSleepValue {
    if (_createActivity.currentActivityType == ActivityType_Sleep) {
        NSTimeInterval seconds = [_createActivity.endTime timeIntervalSinceDate:_createActivity.startTime];
        NSInteger minutes = (NSInteger)(seconds / 60.0 + 0.5);
        _valueField.text = [[NSString alloc] initWithFormat:@"%lu", minutes];
    }
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
        [typesSeg addTarget:self
                     action:@selector(activityTypeSelected:)
           forControlEvents:UIControlEventValueChanged];
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
        _createActivity.startTime = [NSDate date];
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
        _createActivity.endTime = [NSDate date];
        
        // add current time.
        button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [button addTarget:self
                   action:@selector(makeCurrentTime:)
         forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:@"设置为当前时间"
                forState:UIControlStateNormal];
        [button sizeToFit];
        button.tag = kSetCurrentButtonTag;
        CGRect frame = button.frame;
        frame.origin.x = (cell.frame.size.width - button.frame.size.width) / 2.0;
        frame.origin.y = (cell.frame.size.height - button.frame.size.height) / 2.0;
        button.frame = frame;
        [cell.contentView addSubview:button];
    }
    _endCell = cell;;
    
    return cell;
}

- (UITableViewCell *)_configureValueCell {
    static NSString *cellIdentifier = @"CreateActivityValueCell";
    UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                      reuseIdentifier:cellIdentifier];
        // value field
        UITextField *valueField = [[UITextField alloc] init];
        valueField.keyboardType = UIKeyboardTypeNumberPad;
        valueField.placeholder = @"请输入...";
        DoneCancelNumberPadToolbar *toolbar = [[DoneCancelNumberPadToolbar alloc] initWithTextField:valueField];
        toolbar.numberPadDelegate = self;
        valueField.inputAccessoryView = toolbar;
        [valueField sizeToFit];
        CGRect frame = valueField.bounds;
        frame.origin.x = 20;
        frame.origin.y = (cell.frame.size.height - frame.size.height) / 2.0;
        valueField.frame = frame;
        [self updateSleepValue];
        [cell.contentView addSubview:valueField];
        _valueField = valueField;
        
        // unit label
        UILabel *unit = [[UILabel alloc] init];
        EMActivityManager *activityMgr = [EMActivityManager sharedInstance];
        unit.text = [activityMgr ActivityTypeUnit2String:_createActivity.currentActivityType];
        [unit sizeToFit];
        frame = unit.frame;
        frame.origin.x = valueField.frame.origin.x + valueField.frame.size.width + 20;
        frame.origin.y = (cell.frame.size.height - frame.size.height) / 2.0;
        unit.frame = frame;
        [cell.contentView addSubview:unit];
        _valueUnitLabel = unit;
        _valueCell = cell; // updateMilkSwitch needs it. 
        
        // is breast milk switch
        UISwitch *breastMilk = [[UISwitch alloc] init];
        [breastMilk addTarget:self
                       action:@selector(milkTypeChanged:)
             forControlEvents:UIControlEventValueChanged];
        [breastMilk sizeToFit];
        breastMilk.hidden = YES;
        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
        cell.accessoryView = breastMilk;
        _breastMilkSwitch = breastMilk;
        [self updateMilkSwitch];
    }
    _valueCell = cell;
    
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

#pragma mark - DoneCancelNumberPadToolbarDelegate
-(void)doneCancelNumberPadToolbarDelegate:(DoneCancelNumberPadToolbar *)controller
                             didClickDone:(UITextField *)textField {
    _createActivity.activityValue = (NSUInteger)[textField.text integerValue];
}

-(void)doneCancelNumberPadToolbarDelegate:(DoneCancelNumberPadToolbar *)controller
                           didClickCancel:(UITextField *)textField {
    NSLog(@"%@ -- %@", NSStringFromSelector(_cmd), [textField description]);
}

#pragma mark - CreateActivityDelegate
- (void)didMilkTypeChanged:(EMMilkType)milkType {
    //
}

- (void)didActivityValueChanged:(NSUInteger)activityValue {
    //
}

- (void)didEndTimeChanged:(NSDate *)endTime {
    _endCell.textLabel.text = [Utility timeString:endTime];
    
    [self updateSleepValue];
}

- (void)didStartTimeChanged:(NSDate *)startTime {
    _startCell.textLabel.text = [Utility timeString:startTime];
    
    [self updateSleepValue];
}

- (void)didCurrentActivityTypeChanged:(EMActivityType)activityType {
    switch (_createActivity.currentActivityType) {
        case ActivityType_Milk: {
            _valueUnitLabel.text = @"毫升";
        } break;
        case ActivityType_Excrement: {
            _valueUnitLabel.text = @"克";
        } break;
        case ActivityType_Piss: {
            _valueUnitLabel.text = @"毫升";
        } break;
        case ActivityType_Sleep: {
            _valueUnitLabel.text = @"分钟";
        } break;
        default: {
        } break;
    }
    
    [self updateSleepValue];
    [self updateMilkSwitch];
}

- (void)didSleepQualityChanged:(EMSleepQuality)sleepQuality {
    //
}

- (void)didPissColorChanged:(EMPissColor)pissColor {
    //
}

- (void)didPowderMilkBrandChanged:(NSString *)powderMilkBrand {
    //
}

- (void)didBreastMilkPersonChanged:(NSString *)breastMilkPerson {
    //
}

#pragma mark - actions
- (void)milkTypeChanged:(id)sender {
    if ([sender isKindOfClass:[UISwitch class]]) {
        UISwitch *milkSwitch = (UISwitch *)sender;
        _createActivity.milkType = milkSwitch.isOn?MilkType_BreastMilk:MilkType_PowderMilk;
    }
}

- (void)activityTypeSelected:(id)sender {
    if ([sender isKindOfClass:[UISegmentedControl class]]) {
        UISegmentedControl *seg = (UISegmentedControl *)sender;
        NSInteger index = seg.selectedSegmentIndex;
        EMActivityType activityType = ActivityType_Milk;
        switch (index) {
            case 0: {
                activityType = ActivityType_Milk;
            } break;
            case 1: {
                activityType = ActivityType_Piss;
            } break;
            case 2: {
                activityType = ActivityType_Excrement;
            } break;
            case 3: {
                activityType = ActivityType_Sleep;
            } break;
            default: {
            } break;
        }
        _createActivity.currentActivityType = activityType;
    }
}

- (void)makeCurrentTime:(id)sender {
    _createActivity.endTime = [NSDate date];
    
    [self updateSleepValue];
}

- (void)selectTime:(id)sender {
    UIButton *button = nil;
    if (![sender isKindOfClass:[UIButton class]]) {
        return;
    }
    button = (UIButton *)sender;
    NSInteger tag = button.tag;
    
    ActionDateDoneBlock startDone = ^(ActionSheetDatePicker *picker, id selectedDate, id origin) {
        NSDate *date = (NSDate *)selectedDate;
        _createActivity.startTime = date;
    };
    ActionDateDoneBlock endDone = ^(ActionSheetDatePicker *picker, id selectedDate, id origin) {
        NSDate *date = (NSDate *)selectedDate;
        _createActivity.endTime = date;
    };
    ActionDateCancelBlock startCancel = ^(ActionSheetDatePicker *picker) {
    };
    ActionDateCancelBlock endCancel = ^(ActionSheetDatePicker *picker) {
    };
    
    ActionDateDoneBlock done = nil;
    ActionDateCancelBlock cancel = nil;
    NSDate *now = [NSDate date];
    NSDate *min = now;
    if (tag == kSetStartButtonTag) {
        done = startDone;
        cancel = startCancel;
        min = [now dateAtStartOfDay];
        [ActionSheetDatePicker showPickerWithTitle:@"请选择开始时间"
                                    datePickerMode:UIDatePickerModeTime
                                      selectedDate:now
                                       minimumDate:min
                                       maximumDate:[NSDate dateTomorrow]
                                         doneBlock:done
                                       cancelBlock:cancel
                                            origin:self.view];
    } else if (tag == kSetEndButtonTag) {
        done = endDone;
        cancel = endCancel;
        [ActionSheetDatePicker showPickerWithTitle:@"请选择结束时间"
                                    datePickerMode:UIDatePickerModeTime
                                      selectedDate:now
                                       minimumDate:_createActivity.startTime
                                       maximumDate:[NSDate dateTomorrow]
                                         doneBlock:done
                                       cancelBlock:cancel
                                            origin:self.view];
    } else {
    }
}

- (void)saveActivity:(UIBarButtonItem *)sender {
    [_createActivity saveTodayActivity];
}

@end
