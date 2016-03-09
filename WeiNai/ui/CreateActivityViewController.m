//
//  CreateActivityViewController.m
//  WeiNai
//
//  Created by Ji Fang on 7/15/15.
//  Copyright (c) 2015 Ji Fang. All rights reserved.
//

#import "CreateActivityViewController.h"
#import "ActionSheetDatePicker.h"
#import "UIDateTimePickerSheet.h"
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
    NSUInteger _activityValues[ActivityType_NumberOfActivityTypes];
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

@dynamic activityType;

- (id)init {
    if (self=[super init]) {
        _createActivity = [[CreateActivity alloc] init];
        _createActivity.delegate = self;
        for (NSUInteger i=0; i<ActivityType_NumberOfActivityTypes; ++i) {
            _activityValues[i] = 0;
        }
    }
    
    return self;
}

- (void)dealloc {
    _createActivity.delegate = nil;
}

- (EMActivityType)activityType {
    return _createActivity.activityType;
}

- (void)setActivityType:(EMActivityType)activityType {
    _createActivity.activityType = activityType;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    // Do any additional setup after loading the view.

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
    if (_createActivity.activityType == ActivityType_PowderMilk) {
        _breastMilkSwitch.hidden = NO;
        _valueCell.detailTextLabel.text = @"是母乳吗?";
        _breastMilkSwitch.on = (_createActivity.milkType == MilkType_BreastMilk);
    } else {
        _breastMilkSwitch.hidden = YES;
        _valueCell.detailTextLabel.text = @"";
    }
}

- (void)updateSleepValue {
    if (_createActivity.activityType == ActivityType_Sleep) {
        NSTimeInterval seconds = [_createActivity.endTime timeIntervalSinceDate:_createActivity.startTime];
        NSInteger minutes = (NSInteger)(seconds / 60.0 + 0.5);
        NSString *strMinutes = [[NSString alloc] initWithFormat:@"%lu", minutes];
        _valueField.text = strMinutes;
    }
}

#pragma mark - table
- (UITableViewCell *)_configureActivityTypeCell {
    static NSString *cellIdentifier = @"CreateActivityCell_Type";
    UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:cellIdentifier];
        UISegmentedControl *typesSeg = [[UISegmentedControl alloc] initWithItems:
                                        @[[_createActivity activityType2String:ActivityType_PowderMilk],
                                          [_createActivity activityType2String:ActivityType_Piss],
                                          [_createActivity activityType2String:ActivityType_Excrement],
                                          [_createActivity activityType2String:ActivityType_Sleep],
                                          ]];
        [typesSeg addTarget:self
                     action:@selector(activityTypeSelected:)
           forControlEvents:UIControlEventValueChanged];
        NSInteger segIndex = 0;
        switch (_createActivity.activityType) {
            case ActivityType_PowderMilk: {
                segIndex = 0;
            } break;
            case ActivityType_Excrement: {
                segIndex = 2;
            } break;
            case ActivityType_Piss: {
                segIndex = 1;
            } break;
            case ActivityType_Sleep: {
                segIndex = 3;
            } break;
            default: {
            } break;
        }
        typesSeg.selectedSegmentIndex = segIndex;
        typesSeg.center = cell.contentView.center;
//        CGRect frame = typesSeg.frame;
//        frame.origin.x = (cell.contentView.frame.size.width - frame.size.width) / 2.0;
//        frame.origin.y = (cell.contentView.frame.size.height - frame.size.height) / 2.0;
//        typesSeg.frame = frame;
        typesSeg.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        [cell.contentView addSubview:typesSeg];
        cell.backgroundColor = [UIColor clearColor];
        cell.backgroundView = nil;
    }
    _activityTypeCell = cell;
    
    return cell;
}

- (UITableViewCell *)_configureStartCell {
    static NSString *cellIdentifier = @"CreateActivityCell_Start";
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
    static NSString *cellIdentifier = @"CreateActivityCell_End";
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
        button.center = cell.contentView.center;
        button.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        [cell.contentView addSubview:button];
    }
    _endCell = cell;;
    
    return cell;
}

- (UITableViewCell *)_configureValueCell {
    static NSString *cellIdentifier = @"CreateActivityCell_Value";
    UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                      reuseIdentifier:cellIdentifier];
    }
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
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
    _valueField = valueField; // updateSleepValue needs it. 
    if (_createActivity.activityType == ActivityType_Sleep) {
        [self updateSleepValue]; // it calculates the time duration set by date picker(start & end time from model).
    } else { // sleep value is got from updateSleepValue, not from _activityValues array.
        NSUInteger value = _activityValues[_createActivity.activityType];
        valueField.text = [[NSString alloc] initWithFormat:@"%lu", value];
    }
    valueField.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [cell.contentView addSubview:valueField];
    
    // unit label
    UILabel *unit = [[UILabel alloc] init];
    EMActivityManager *activityMgr = [EMActivityManager sharedInstance];
    unit.text = [activityMgr ActivityTypeUnit2String:_createActivity.activityType];
    [unit sizeToFit];
    frame = unit.frame;
    frame.origin.x = valueField.frame.origin.x + valueField.frame.size.width + 20;
    frame.origin.y = (cell.frame.size.height - frame.size.height) / 2.0;
    unit.frame = frame;
    unit.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
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
    _valueCell = cell;
    
    return cell;
}

- (UITableViewCell *)_configureMemoCell {
    static NSString *cellIdentifier = @"CreateActivityCell_Memo";
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
    if (_createActivity.activityType == ActivityType_Sleep) {
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
    } else {
        switch (section) {
            case 0: { // 活动类型
                cell = [self _configureActivityTypeCell];
            } break;
            case 1: { // 开始时间
                cell = [self _configureStartCell];
            } break;
            case 2: { // 数值
                cell = [self _configureValueCell];
            } break;
            case 3: { // 备注
                cell = [self _configureMemoCell];
            } break;
            default: {
            } break;
        }
    }
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // 1. 活动类型; 2. 开始; 3. 结束; 4. 数据; 5. 备注
    NSInteger ret = 4;
    if (_createActivity.activityType == ActivityType_Sleep) {
        ret += 1; // 除去sleep, 别的都没有结束时间.
    }
    
    return ret;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger ret = 1;
    
    return ret;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *ret = nil;
    
    if (_createActivity.activityType == ActivityType_Sleep) {
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
    } else {
        switch (section) {
            case 0: {
                ret = @"活动类型";
            } break;
            case 1: {
                ret = @"开始时间";
            } break;
            case 2: {
                ret = @"数值";
            } break;
            case 3: {
                ret = @"备注";
            } break;
            default: {
            } break;
        }
    }
    
    return ret;
}

#pragma mark - DoneCancelNumberPadToolbarDelegate
-(void)doneCancelNumberPadToolbarDelegate:(DoneCancelNumberPadToolbar *)controller
                             didClickDone:(UITextField *)textField {
    _activityValues[_createActivity.activityType] = (NSUInteger)[textField.text integerValue];
    _createActivity.activityValue = _activityValues[_createActivity.activityType];
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

- (void)didActivityTypeChanged:(EMActivityType)activityType {
    switch (_createActivity.activityType) {
        case ActivityType_PowderMilk: {
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
    
    [_tableView reloadData];
    
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
        EMActivityType activityType = ActivityType_PowderMilk;
        switch (index) {
            case 0: {
                activityType = ActivityType_PowderMilk;
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
        _createActivity.activityType = activityType;
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
    
    if (IS_IPAD_RUNTIME) { // for iPad
        NSString *title = nil;
        NSDate *minDate = nil;
        if (tag == kSetStartButtonTag) {
            title = @"请选择开始时间";
            minDate = [[NSDate date] dateAtStartOfDay];
        } else {
            title = @"请选择结束时间";
            minDate = _createActivity.startTime;
        }
        
        [UIDateTimePickerSheet showDateTimeActionSheetWithMode:UIDatePickerModeTime
                                                         title:title
                                                    initialDate:nil
                                                initalInterval:0
                                             cancelButtonTitle:@"取消"
                                               doneButtonTitle:@"完成"
                                                   minimumDate:minDate
                                                   maximumDate:[NSDate dateTomorrow]
                                     finishSelectIntervalBlock:NULL
                                         finishSelectDateBlock:^(BOOL success, NSDate *value) {
                                             NSLog(@"date, %d", (int)success);
                                             if (!success) {
                                                 return;
                                             }
                                             if (tag == kSetStartButtonTag) {
                                                 NSDate *date = value;
                                                 _createActivity.startTime = date;
                                                 if ([_createActivity.startTime isLaterThanDate:_createActivity.endTime]) {
                                                     _createActivity.endTime = _createActivity.startTime;
                                                 }
                                             } else if (tag == kSetEndButtonTag) {
                                                 NSDate *date = value;
                                                 _createActivity.endTime = date;
                                                 if ([_createActivity.endTime isEarlierThanDate:_createActivity.startTime]) {
                                                     _createActivity.endTime = _createActivity.startTime;
                                                 }
                                             }
                                         }
                                                        inView:self.view];
    } else { // for iPhone
        ActionDateDoneBlock startDone = ^(ActionSheetDatePicker *picker, id selectedDate, id origin) {
            NSDate *date = (NSDate *)selectedDate;
            _createActivity.startTime = date;
            if ([_createActivity.startTime isLaterThanDate:_createActivity.endTime]) {
                _createActivity.endTime = _createActivity.startTime;
            }
        };
        ActionDateDoneBlock endDone = ^(ActionSheetDatePicker *picker, id selectedDate, id origin) {
            NSDate *date = (NSDate *)selectedDate;
            _createActivity.endTime = date;
            if ([_createActivity.endTime isEarlierThanDate:_createActivity.startTime]) {
                _createActivity.endTime = _createActivity.startTime;
            }
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
}

- (void)saveActivity:(UIBarButtonItem *)sender {
    if ([_createActivity saveTodayActivity]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
