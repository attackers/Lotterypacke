//
//  CPOpenAccountCell.m
//  lottery
//
//  Created by way on 2018/6/11.
//  Copyright © 2018年 way. All rights reserved.
//

#import "CPOpenAccountCell.h"
@interface CPOpenAccountCell()<UITextFieldDelegate>
{
    IBOutlet UITextField *_textField;
    IBOutlet UILabel *_desLabel;
    NSInteger _index;
    NSDictionary *_info;
}

@property(nonatomic,assign)id<CPOpenAccountCellValueProtocol>delegate;

@end


@implementation CPOpenAccountCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [self.delegate cpOpenAccountCellAddValue:textField.text isDdting:NO index:_index textField:textField
     ];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (string.length>0) {
        
        if ((textField.text.length<1||[textField.text rangeOfString:@"."].length>0 )&& [string isEqualToString:@"."]) {
            
            return NO;
        }else if ([textField.text rangeOfString:@"."].length>0&&textField.text.length==[textField.text rangeOfString:@"."].location +2)
        {
            return NO;
        }else if ([textField.text isEqualToString:@"0"]&&![string isEqualToString:@"."])
        {
            return NO;
        }
        
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        double per = [_textField.text doubleValue];
        double maxPer = [[_info DWStringForKey:@"fd"]doubleValue];
        if (per>maxPer) {
            _textField.text = [_info DWStringForKey:@"fd"];
        }
        [self.delegate cpOpenAccountCellAddValue:textField.text isDdting:YES index:_index textField:textField];
        
    });
    return YES;
}

-(UITextField *)addInfo:(NSDictionary *)info
               perValue:(NSString *)perValue
               delegate:(id<CPOpenAccountCellValueProtocol>)delegate
                  index:(NSInteger)index
{
    _info = info;
    self.delegate = delegate;
    _index = index;
    if (perValue.length>0) {
        _textField.text = perValue;
    }
    NSString *placeholder = [NSString stringWithFormat:@"自身赔率%.1f,可设置赔率0.0~%.1f",[[info DWStringForKey:@"fd"]doubleValue],[[info DWStringForKey:@"fd"]doubleValue]];
    _textField.placeholder = placeholder;
    _desLabel.text = [info DWStringForKey:@"name"];
    return _textField;
}

@end
