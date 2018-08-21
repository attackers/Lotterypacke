//
//  CPBuyLotteryForJssscHeaderView.m
//  lottery
//
//  Created by way on 2018/3/20.
//  Copyright © 2018年 way. All rights reserved.
//

#import "CPBuyLotteryForJssscHeaderView.h"
#import "CPLtyResultView.h"
#import "LotteryHeader.h"

@interface CPBuyLotteryForJssscHeaderView()
{
    
    IBOutlet UILabel *_titleLabel;
    IBOutlet UILabel *_abortDateLabel;
    IBOutlet UILabel *_countOpenDateLabel;
    IBOutlet UILabel *_openDateLabel;
    IBOutlet UILabel *_balanceLabel;
    
    IBOutlet UIView *_resultView;
    IBOutlet UIView *_waitOpenView;
    
    CPLtyResultView *_resultContentView;
}
@end

@implementation CPBuyLotteryForJssscHeaderView

-(void)awakeFromNib
{
    [super awakeFromNib];
}


- (IBAction)buttonActions:(UIButton *)sender {
    
    if (sender.tag == 101) {
        //刷新余额
        if (self.actionDelegate && [self.actionDelegate respondsToSelector:@selector(refreshBalance)]) {
            [self.actionDelegate refreshBalance];
        }
    }
}

-(void)loadDataByPlayInfo:(NSDictionary *)playInfo
{
    NSString *title = [NSString stringWithFormat:@"%@ %@期",[CPBuyLotteryManager shareManager].currentLotteryName,[playInfo DWStringForKey:@"lastPeriod"]];
    NSMutableAttributedString * att = [[NSMutableAttributedString alloc]initWithString:title attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [att addAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} range:[title rangeOfString:[playInfo DWStringForKey:@"lastPeriod"]]];
    _titleLabel.attributedText = att;
    
    _openDateLabel.text =[NSString stringWithFormat:@"开奖时间:%@",[playInfo DWStringForKey:@"opentime"]];
    
    _abortDateLabel.text =[NSString stringWithFormat:@"%@期 截止",[playInfo DWStringForKey:@"period"]];
    
    NSString *lastOpen = [playInfo DWStringForKey:@"lastOpen"];
    NSArray *result = [lastOpen componentsSeparatedByString:@","];
    
    if (lastOpen.length == 0) {
        _waitOpenView.hidden = NO;
        for (UIView *subview in _resultView.subviews) {
            if ([subview isKindOfClass:[CPLtyResultView class]]) {
                [subview removeFromSuperview];
            }
        }
        
    }else{

        _waitOpenView.hidden = YES;
        _resultContentView = [self buildLtyResultViewWithFrame:CGRectMake(0, 0, _resultView.width, _resultView.height)];
        [_resultContentView showResult:result resultType:[CPBuyLotteryManager shareManager].currentBuyLotteryType];
        [_resultView addSubview:_resultContentView];
    }
    
}

-(void)loadCountTime:(NSString *)countTime
{
    NSMutableAttributedString *att = [NSMutableAttributedString new];
    NSArray *stringAry = [countTime componentsSeparatedByString:@":"];
    for (int i = 0; i<stringAry.count; i++) {
        NSString *text = stringAry[i];
        NSAttributedString *attTextString = [[NSAttributedString alloc]initWithString:text attributes:@{NSFontAttributeName:[UIFont fontWithName:@"DB LCD Temp" size:20.0f],NSForegroundColorAttributeName:[UIColor whiteColor]}];
        [att insertAttributedString:attTextString atIndex:att.length];
        if (i<=stringAry.count-2) {
            
            NSAttributedString *attTextStringMark = [[NSAttributedString alloc]initWithString:@"∶" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20.0f],NSForegroundColorAttributeName:[UIColor whiteColor]}];
            [att insertAttributedString:attTextStringMark atIndex:att.length];

        }
    }

    _countOpenDateLabel.attributedText = att;
    
}

-(void)loadBalance:(NSString *)balance
{
    _balanceLabel.text = balance;
}

#pragma mark-

-(CPLtyResultView *)buildLtyResultViewWithFrame:(CGRect)frame
{
    CPLtyResultView *view = [[CPLtyResultView alloc]initWithFrame:frame];
    return view;
}


@end
