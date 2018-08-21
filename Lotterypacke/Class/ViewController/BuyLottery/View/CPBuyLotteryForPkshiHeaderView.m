//
//  CPBuyLotteryForPkshiHeaderView.m
//  lottery
//
//  Created by way on 2018/3/20.
//  Copyright © 2018年 way. All rights reserved.
//

#import "CPBuyLotteryForPkshiHeaderView.h"
#import "CPLtyResultView.h"
@interface CPBuyLotteryForPkshiHeaderView()
{
    
    IBOutlet UIButton *_numberButton;
    IBOutlet UILabel *_abortDateLabel;
    IBOutlet UILabel *_countOpenDateLabel;
    IBOutlet UILabel *_openDateLabel;
    IBOutlet UILabel *_balanceLabel;
    
    IBOutlet UIView *_resultView;
    IBOutlet UIView *_waitOpenView;
    
    
    IBOutlet UIImageView *_bgImgView;
    IBOutlet UIImageView *_balanceBgImgView;
    IBOutlet UIImageView *_openDateBgImgView;
    
    
    IBOutlet UIView *_feitingView;
    
    IBOutlet UIImageView *_feitingNo2ImgView;
    IBOutlet UIImageView *_feitingNo1ImgView;
    IBOutlet UIImageView *_feitingNo3ImgView;
    
    
    IBOutlet UIView *_saicheView;
    
    IBOutlet UIImageView *_saicheNo2ImgView;
    IBOutlet UIImageView *_saicheNo1ImgView;
    IBOutlet UIImageView *_saicheNo3ImgView;
    
    CPLtyResultView *_resultContentView;

}


@end

@implementation CPBuyLotteryForPkshiHeaderView

#pragma mark- setter && getter

-(void)setIsSaiche:(BOOL)isSaiche
{
    _isSaiche = isSaiche;
    if (_isSaiche) {
        _saicheView.hidden = NO;
        _feitingView.hidden = YES;
        _bgImgView.highlighted = YES;
        _balanceBgImgView.highlighted = YES;
        _openDateBgImgView.highlighted = YES;
        
    }else{
        _saicheView.hidden = YES;
        _feitingView.hidden = NO;
        _bgImgView.highlighted = NO;
        _balanceBgImgView.highlighted = NO;
        _openDateBgImgView.highlighted = NO;
        
    }
}

#pragma mark- load data

-(void)anmationViewIsHidden:(BOOL)isHidden
{
    if (_isSaiche) {
        _saicheView.hidden = isHidden;
    }else{
        _feitingView.hidden = isHidden;
    }
}

-(void)animationStartByResult:(NSArray *)result
{
    if (_isSaiche) {
        
        UIImage *imgOne = [UIImage imageNamed:[NSString stringWithFormat:@"%d_jssc_result_pic",[result[0] intValue]]];
        UIImage *imgTwo = [UIImage imageNamed:[NSString stringWithFormat:@"%d_jssc_result_pic",[result[1] intValue]]];
        UIImage *imgThree = [UIImage imageNamed:[NSString stringWithFormat:@"%d_jssc_result_pic",[result[2] intValue]]];
        [_saicheNo1ImgView setImage:imgOne];
        [_saicheNo2ImgView setImage:imgTwo];
        [_saicheNo3ImgView setImage:imgThree];
        
        _saicheNo1ImgView.transform = CGAffineTransformMakeScale(0.1, 0.1);
        _saicheNo2ImgView.transform = CGAffineTransformMakeScale(0.1, 0.1);
        _saicheNo3ImgView.transform = CGAffineTransformMakeScale(0.1, 0.1);

        [UIView animateWithDuration:2.0 animations:^{
            _saicheNo1ImgView.transform = CGAffineTransformMakeScale(1, 1);
            _saicheNo2ImgView.transform = CGAffineTransformMakeScale(1, 1);
            _saicheNo3ImgView.transform = CGAffineTransformMakeScale(1, 1);
        }];


    }else{
        
        UIImage *imgOne = [UIImage imageNamed:[NSString stringWithFormat:@"%d_jsft_result_pic",[result[0] intValue]]];
        UIImage *imgTwo = [UIImage imageNamed:[NSString stringWithFormat:@"%d_jsft_result_pic",[result[1] intValue]]];
        UIImage *imgThree = [UIImage imageNamed:[NSString stringWithFormat:@"%d_jsft_result_pic",[result[2] intValue]]];
        [_feitingNo1ImgView setImage:imgOne];
        [_feitingNo2ImgView setImage:imgTwo];
        [_feitingNo3ImgView setImage:imgThree];
        
        _feitingNo1ImgView.transform = CGAffineTransformMakeScale(0.1, 0.1);
        _feitingNo2ImgView.transform = CGAffineTransformMakeScale(0.1, 0.1);
        _feitingNo3ImgView.transform = CGAffineTransformMakeScale(0.1, 0.1);
        
        [UIView animateWithDuration:2.0 animations:^{
            _feitingNo1ImgView.transform = CGAffineTransformMakeScale(1, 1);
            _feitingNo2ImgView.transform = CGAffineTransformMakeScale(1, 1);
            _feitingNo3ImgView.transform = CGAffineTransformMakeScale(1, 1);
        }];
    }
}

-(void)loadDataByPlayInfo:(NSDictionary *)playInfo
{
    
    NSString *title = [NSString stringWithFormat:@"第%@期",[playInfo DWStringForKey:@"lastPeriod"]];
    [_numberButton setTitle:title forState:UIControlStateNormal];
    
    _openDateLabel.text =[NSString stringWithFormat:@"开奖时间:%@",[playInfo DWStringForKey:@"opentime"]];
    
    _abortDateLabel.text =[NSString stringWithFormat:@"距 %@期 截止:",[playInfo DWStringForKey:@"period"]];
    
    NSString *lastOpen = [playInfo DWStringForKey:@"lastOpen"];
    NSArray *result = [lastOpen componentsSeparatedByString:@","];
    
    if (lastOpen.length == 0) {
        _waitOpenView.hidden = NO;
        [self anmationViewIsHidden:YES];
        for (UIView *subview in _resultView.subviews) {
            if ([subview isKindOfClass:[CPLtyResultView class]]) {
                [subview removeFromSuperview];
            }
        }
        
    }else{
        _waitOpenView.hidden = YES;
        [self anmationViewIsHidden:NO];
        _resultContentView = [self buildLtyResultViewWithFrame:CGRectMake(0, 0, _resultView.width, _resultView.height)];
        [_resultContentView showResult:result resultType:[CPBuyLotteryManager shareManager].currentBuyLotteryType];
        [_resultView addSubview:_resultContentView];
        [self animationStartByResult:result];
    }
    
    
}

-(void)loadBalance:(NSString *)balance
{
    _balanceLabel.text = balance;
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

#pragma mark-

-(CPLtyResultView *)buildLtyResultViewWithFrame:(CGRect)frame
{
    CPLtyResultView *view = [[CPLtyResultView alloc]initWithFrame:frame];
    return view;
}

#pragma mark- actions
- (IBAction)buttonActions:(UIButton *)sender {
    
    if (sender.tag == 101) {
        //刷新余额
        if (self.actionDelegate && [self.actionDelegate respondsToSelector:@selector(refreshBalance)]) {
            [self.actionDelegate refreshBalance];
        }
    }
}

@end
