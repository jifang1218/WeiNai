
#import "UIDateTimePickerSheet.h"

#define ANIMATION_INTERVAL 0.5

@interface UIDateTimePickerSheet ()

@property (nonatomic, copy) void (^finishSelectInterval)(BOOL success, NSTimeInterval value);
@property (nonatomic, copy) void (^finishSelectDate)(BOOL success, NSDate *value);

@end

@implementation UIDateTimePickerSheet

#pragma mark - Construction

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    //Custom initialize
}

#pragma mark - Layout

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.titleLabel.preferredMaxLayoutWidth = self.titleLabel.bounds.size.width;
}

#pragma mark - Animattions

- (void)showAnimated
{
    UIColor *backgroundColor = self.backgroundColor;
    CGFloat contentHeight = [self.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    
    self.backgroundColor = [UIColor clearColor];
    self.contentViewBottomConstraint.constant = -contentHeight;
    [self layoutIfNeeded];
    
    self.contentViewBottomConstraint.constant = 0;
    
    [UIView animateWithDuration:ANIMATION_INTERVAL animations:
    ^{
        self.backgroundColor = backgroundColor;
        [self layoutIfNeeded];
    }];
}

- (void)dismissAnimated
{
    CGFloat contentHeight = [self.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    
    self.contentViewBottomConstraint.constant = -contentHeight;
    
    [UIView animateWithDuration:ANIMATION_INTERVAL animations:
    ^{
        self.backgroundColor = [UIColor clearColor];
        [self layoutIfNeeded];
    }
    completion:
    ^(BOOL finished)
    {
        [self removeFromSuperview];
    }];
}

#pragma mark - Action

- (void)onFinish:(BOOL)success
{
    switch (self.datePicker.datePickerMode)
    {
        case UIDatePickerModeCountDownTimer:
        {
            if (self.finishSelectInterval)
                self.finishSelectInterval(success, self.datePicker.countDownDuration);
            break;
        }
            
        case UIDatePickerModeDate:
        case UIDatePickerModeDateAndTime:
        case UIDatePickerModeTime:
        {
            if (self.finishSelectDate)
                self.finishSelectDate(success, self.datePicker.date);
            break;
        }
    }
    
    [self dismissAnimated];
}

- (IBAction)onDone:(id)sender
{
    [self onFinish:YES];
}

- (IBAction)onCancel:(id)sender
{
    [self onFinish:NO];
}

#pragma mark - Class methods

+ (UIDateTimePickerSheet *)dateTimeActionSheetWithMode:(UIDatePickerMode)pickerMode
                                                 title:(NSString *)title
                                            initialDate:(NSDate *)initialDate
                                        initalInterval:(NSTimeInterval)initalInterval
                                     cancelButtonTitle:(NSString *)cancelButtonTitle
                                       doneButtonTitle:(NSString *)doneButtonTitle
                                           minimumDate:(NSDate *)minDate
                                           maximumDate:(NSDate *)maxDate
                             finishSelectIntervalBlock:(void (^)(BOOL success, NSTimeInterval value))finishSelectIntervalBlock
                                 finishSelectDateBlock:(void (^)(BOOL success, NSDate *value))finishSelectDateBlock
{
    UIDateTimePickerSheet *result = (UIDateTimePickerSheet *)[[[NSBundle mainBundle] loadNibNamed:@"UIDateTimePickerSheet" owner:nil options:nil] lastObject];
    
    result.datePicker.datePickerMode = pickerMode;
    
    if (title)
        result.titleLabel.text = title;
    
    if (initialDate)
        result.datePicker.date = initialDate;
    
    result.datePicker.countDownDuration = initalInterval;
    
    if (cancelButtonTitle)
        [result.cancelBtn setTitle:cancelButtonTitle forState:UIControlStateNormal];
    
    if (doneButtonTitle)
        [result.doneBtn setTitle:doneButtonTitle forState:UIControlStateNormal];
    
    result.finishSelectDate = finishSelectDateBlock;
    result.finishSelectInterval = finishSelectIntervalBlock;
    
    return result;
}

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
                                                    inView:(UIView *)view
{
    UIDateTimePickerSheet *result = [UIDateTimePickerSheet dateTimeActionSheetWithMode:pickerMode
                                                                                title:title
                                                                            initialDate:initialDate initalInterval:initalInterval
                                                                     cancelButtonTitle:cancelButtonTitle
                                                                       doneButtonTitle:doneButtonTitle
                                                                           minimumDate:minDate
                                                                           maximumDate:maxDate
                                                             finishSelectIntervalBlock:finishSelectIntervalBlock
                                                                 finishSelectDateBlock:finishSelectDateBlock];
    
    result.translatesAutoresizingMaskIntoConstraints = NO;
    
    if (!view)
        view = [[UIApplication sharedApplication] keyWindow];
    
    
    [view addSubview:result];
    
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[picker]-0-|" options:0 metrics:nil views:@{@"picker": result}]];
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[picker]-0-|" options:0 metrics:nil views:@{@"picker": result}]];
    
    if (initialDate) {
        result.datePicker.date = initialDate;
    } else {
        result.datePicker.date = [NSDate date];
    }
    
    result.datePicker.minimumDate = minDate;
    result.datePicker.maximumDate = maxDate;
    [result showAnimated];
    
    return result;
}

@end
