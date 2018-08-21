//
//  CPDatePickerView.m
//  lottery
//
//  Created by way on 2018/7/22.
//  Copyright © 2018年 way. All rights reserved.
//

#import "CPDatePickerView.h"
@interface CPDatePickerView()
{

    IBOutlet UIDatePicker *_datePicker;
    
}

@property(nonatomic,copy)CPDatePickerViewSelectedDateAction confirmAction;
@property(nonatomic,retain)NSDate *originDate;

@end

@implementation CPDatePickerView

+(void)showDatePickerOnView:(UIView *)supView
                       date:(NSDate *)date
                    comfirm:(CPDatePickerViewSelectedDateAction)confirm;
{
    CPDatePickerView *pickerView = [CPDatePickerView createViewFromNib];
    pickerView.frame = CGRectMake(0, 0, supView.width, supView.height);
    [pickerView layoutSubviews];
    pickerView.confirmAction = confirm;
    pickerView.originDate = date;
    [pickerView showOnView:supView];
    
}

-(void)setOriginDate:(NSDate *)originDate
{
    _originDate = originDate;
    _datePicker.date = _originDate;
}

- (IBAction)comfirmAction:(UIButton *)sender {
    NSDate *date = _datePicker.date;
    if (self.confirmAction) {
        self.confirmAction(YES, date);
    }
    [self dismiss];
}

- (IBAction)cancelAction:(UIButton *)sender {
    [self dismiss];
}

-(void)showOnView:(UIView *)onView
{
    self.layer.opacity = 0;
    [onView addSubview:self];
    [UIView animateWithDuration:0.38 animations:^{
        self.layer.opacity = 1;
    }];
    
}

-(void)dismiss
{
    [UIView animateWithDuration:0.38 animations:^{
        self.layer.opacity = 0;
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


@end
