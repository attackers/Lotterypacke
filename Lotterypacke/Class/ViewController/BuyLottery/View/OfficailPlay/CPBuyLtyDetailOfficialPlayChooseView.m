//
//  CPBuyLtyDetailOfficialPlayChooseView.m
//  lottery
//
//  Created by way on 2018/6/29.
//  Copyright © 2018年 way. All rights reserved.
//

#import "CPBuyLtyDetailOfficialPlayChooseView.h"
@interface CPBuyLtyDetailOfficialPlayChooseView()
{
    IBOutlet UIButton *_doubleFacePlayButton;
    IBOutlet UIButton *_officailPlayButton;
    
}

@property(nonatomic,assign)id<CPBuyLtyDetailOfficialPlayChooseViewDelegate>delegate;

@end

@implementation CPBuyLtyDetailOfficialPlayChooseView

- (IBAction)buttonActions:(UIButton *)sender {
    
    switch (sender.tag) {
        case 0:
        case 1:
        {
            [self.delegate cpBuyLtyDetailOfficialPlayChooseViewChooseIndex:sender.tag];
        }break;
        default:
            break;
    }
    [self dismiss];
}

-(void)showOnView:(UIView *)onView
    selectedIndex:(NSInteger)selectedIndex
         delegate:(id<CPBuyLtyDetailOfficialPlayChooseViewDelegate>)delegate
{
    self.delegate = delegate;
    self.frame = CGRectMake(0, 0, onView.width, onView.height);
    BOOL isSelectedDouble = selectedIndex==0?YES:NO;
    [self chooseButton:_doubleFacePlayButton isChoose:isSelectedDouble];
    [self chooseButton:_officailPlayButton isChoose:!isSelectedDouble];
    
    self.layer.opacity = 0;
    [onView addSubview:self];
    [self show];
}

-(void)chooseButton:(UIButton *)button
           isChoose:(BOOL)isChoose
{
    if (isChoose) {
        [button setBackgroundImage:[UIImage imageWithColor:kCOLOR_R_G_B_A(179, 32, 29, 1)] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.layer.borderWidth = 0;

    }else{
        [button setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [button setTitleColor:kCOLOR_R_G_B_A(51, 51, 51, 1) forState:UIControlStateNormal];
        button.layer.borderWidth = 1.0f;
        button.layer.borderColor = kCOLOR_R_G_B_A(153, 153, 153, 1).CGColor;

    }
    button.layer.cornerRadius = 2.5f;
    button.layer.masksToBounds = YES;
}

-(void)dismiss
{
    [UIView animateWithDuration:0.38 animations:^{
        self.layer.opacity = 0;
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

-(void)show
{
    [UIView animateWithDuration:0.38 animations:^{
        self.layer.opacity = 1;
    }];
}

@end
