
#import <UIKit/UIKit.h>

@interface UIDateTimePickerSheet : UIView

@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *doneBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

- (IBAction)onDone:(id)sender;
- (IBAction)onCancel:(id)sender;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewBottomConstraint;

/*! Shows date/time or interval select action sheet
 \param pickerMode - UIDatePicker mode
 \param title - Action sheet title, can be nil, default: ""
 \param initialDate - Action sheet starts with this date (for pickerMode = UIDatePickerModeTime, UIDatePickerModeDate or UIDatePickerModeDateAndTime otherwise ignored), can be nil, default: today's date
 \param initalInterval - Action sheet starts with this interval (for pickerMode = UIDatePickerModeCountDownTimer otherwise ignored), can be nil, default: 0
 \param cancelButtonTitle - Cancel button title, can be nil, default: "Cancel"
 \param doneButtonTitle - Done button title, can be nil, default: "Done"
 \param finishSelectIntervalBlock - Block to execute on action sheet dismiss (for pickerMode = UIDatePickerModeCountDownTimer otherwise should be NULL)
 \param finishSelectDateBlock - Block to execute on action sheet dismiss (for pickerMode = UIDatePickerModeTime, UIDatePickerModeDate or UIDatePickerModeDateAndTime otherwise should be NULL)
 \param inView - Hoset view for action, can be nil
 */
+ (UIDateTimePickerSheet *)showDateTimeActionSheetWithMode:(UIDatePickerMode)pickerMode
                                                     title:(NSString *)title
                                                initialDate:(NSDate *)initialDate
                                            initalInterval:(NSTimeInterval)initalInterval
                                         cancelButtonTitle:(NSString *)cancelButtonTitle
                                           doneButtonTitle:(NSString *)doneButtonTitle
                                               minimumDate:(NSDate *)minDate
                                               maximumDate:(NSDate *)maxDate
                                 finishSelectIntervalBlock:(void (^)(BOOL success, NSTimeInterval value))finishSelectIntervalBlock
                                     finishSelectDateBlock:(void (^)(BOOL success, NSDate *value))finishSelectDateBlock
                                                    inView:(UIView *)view;

@end
