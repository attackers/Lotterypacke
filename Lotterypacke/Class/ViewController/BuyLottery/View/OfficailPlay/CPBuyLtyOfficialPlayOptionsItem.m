//
//  CPBuyLtyOfficialPlayOptionsItem.m
//  lottery
//
//  Created by way on 2018/6/26.
//  Copyright © 2018年 way. All rights reserved.
//

#import "CPBuyLtyOfficialPlayOptionsItem.h"
#import "LotteryHeader.h"

@interface CPBuyLtyOfficialPlayOptionsItem()
{
    
}

@property(nonatomic,copy)CPBuyLtyOfficialPlayOptionsItemClickAction clickAction;
@end

@implementation CPBuyLtyOfficialPlayOptionsItem


+(instancetype)buttonWithFrame:(CGRect)frame
                     titleText:(NSString *)titleText
                     titleFont:(UIFont *)titleFont
                         index:(NSInteger)index
                    isSelected:(BOOL)isSelected
                   clickAction:(CPBuyLtyOfficialPlayOptionsItemClickAction)clickAction

{
    CPBuyLtyOfficialPlayOptionsItem *button = [CPBuyLtyOfficialPlayOptionsItem buttonWithType:UIButtonTypeCustom];
    [button setTitle:titleText forState:UIControlStateNormal];
    button.tag = index;
    button.layer.cornerRadius = 2.5f;
    button.layer.masksToBounds = YES;
    button.layer.borderWidth = 1.0f;
    button.titleLabel.font = titleFont;
    [button setTitleColor:kCOLOR_R_G_B_A(137, 27, 1, 1) forState:UIControlStateSelected];
    [button setTitleColor:kCOLOR_R_G_B_A(102, 102, 102, 1) forState:UIControlStateNormal];
    button.frame = frame;
    [button addIsSelected:isSelected];
    button.clickAction = clickAction;
    return button;
}

-(void)addIsSelected:(BOOL)isSelected
{
    self.selected = isSelected;
    self.layer.borderColor = isSelected?[kCOLOR_R_G_B_A(137, 27, 1, 1) CGColor]:[kCOLOR_R_G_B_A(153, 153, 153, 1) CGColor];
}

-(void)setClickAction:(CPBuyLtyOfficialPlayOptionsItemClickAction)clickAction
{
    _clickAction = clickAction;
    [self addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
}

-(void)click
{
    if (self.clickAction
        ) {
        self.clickAction(self.tag);
    }
}

@end
