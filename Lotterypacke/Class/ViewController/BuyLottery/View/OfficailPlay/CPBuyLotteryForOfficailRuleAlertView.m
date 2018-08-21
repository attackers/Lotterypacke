//
//  CPBuyLotteryForOfficailRuleAlertView.m
//  lottery
//
//  Created by way on 2018/7/3.
//  Copyright © 2018年 way. All rights reserved.
//

#import "CPBuyLotteryForOfficailRuleAlertView.h"
#import "LotteryHeader.h"

@interface CPBuyLotteryForOfficailRuleAlertView()
{
    IBOutlet UIView *_contentView;
    IBOutlet UILabel *_exampleLabel;
    IBOutlet UILabel *_explainLabel;
    
    
}
@end

@implementation CPBuyLotteryForOfficailRuleAlertView

-(void)awakeFromNib
{
    [super awakeFromNib];
    _contentView.layer.cornerRadius = 5.0f;
    _contentView.layer.borderWidth = 1.0f;
    _contentView.layer.borderColor = kCOLOR_R_G_B_A(153, 153, 153, 1).CGColor;
}

-(void)showPlayExampleString:(NSString *)exampleString
               explainString:(NSString *)explainString
                      onView:(UIView *)onView
{
    self.frame = CGRectMake(0, 0, onView.width, onView.height);
    [self layoutSubviews];
    
    NSString *allExampleString = [NSString stringWithFormat:@"范例：%@",exampleString];
    NSMutableAttributedString *attExampleString = [[NSMutableAttributedString alloc] initWithString:allExampleString attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:kCOLOR_R_G_B_A(51, 51, 51, 1)}];
    
    [attExampleString addAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:15]} range:[allExampleString rangeOfString:@"范例："]];
    _exampleLabel.attributedText = attExampleString;
    _exampleLabel.height = [allExampleString suitableFromMaxSize:CGSizeMake(_exampleLabel.width, onView.height/2.5) font:[UIFont systemFontOfSize:15]].height+3;
    
    
    NSString *allExplainString = [NSString stringWithFormat:@"玩法说明：%@",explainString];
    NSMutableAttributedString *attExplainString = [[NSMutableAttributedString alloc] initWithString:allExplainString attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:kCOLOR_R_G_B_A(51, 51, 51, 1)}];
    
    [attExplainString addAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:15]} range:[allExplainString rangeOfString:@"玩法说明："]];
    _explainLabel.attributedText = attExplainString;
    _explainLabel.height = [allExplainString suitableFromMaxSize:CGSizeMake(_exampleLabel.width, onView.height/2.5) font:[UIFont systemFontOfSize:15]].height+3;
    _explainLabel.originY = _exampleLabel.bottomY+15;
    
    _contentView.height = _explainLabel.bottomY + 65;
    
    _contentView.originY = (self.height - _contentView.height)/2.0f;
    
    [self showAnimationOnView:onView];
}

- (IBAction)buttonAction:(UIButton *)sender {
    
    [self dismiss];
}

-(void)showAnimationOnView:(UIView *)onView
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
