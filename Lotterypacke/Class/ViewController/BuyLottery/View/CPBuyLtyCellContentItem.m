//
//  CPBuyLtyCellContentItem.m
//  lottery
//
//  Created by way on 2018/8/4.
//  Copyright © 2018年 way. All rights reserved.
//

#import "CPBuyLtyCellContentItem.h"
#import "UIView+LotteryBaseView.h"

@interface CPBuyLtyCellContentItem()
{
    UIButton *_contentButton;
    UILabel *_bonusLabel;
    
    CPBuyLtyCellContentItemShape _shape;
    
    UIFont *_contentButtonFont;
    UIFont *_bonusLabelFont;

}


@property(nonatomic,assign)CPBuyLtyCellContentItemShape shape;
@property(nonatomic,assign)CPBuyLtyCellContentItemLayoutType layoutType;

@property(nonatomic,assign)BOOL hasSelected;

@end

@implementation CPBuyLtyCellContentItem

-(instancetype)initWithActionTarget:(id)target
                           selector:(SEL)selector
{
    self = [super init];
    if (self) {
        
        [self buildSubviews];
        [_contentButton addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}

-(void)buildSubviews
{
    _contentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_contentButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [_contentButton setTitleColor:kCOLOR_R_G_B_A(193, 38, 33, 1) forState:UIControlStateNormal];

    [_contentButton setBackgroundImage:[UIImage imageWithColor:kCOLOR_R_G_B_A(193, 38, 33, 1)] forState:UIControlStateSelected];
    _contentButton.layer.borderWidth = kGlobalLineWidth;
    _contentButton.layer.masksToBounds = YES;
    [self addSubview:_contentButton];
    
    _bonusLabel = [[UILabel alloc]init];
    _bonusLabel.textColor = kCOLOR_R_G_B_A(102, 102, 102, 1);
    _bonusLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_bonusLabel];
    
    [_bonusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.mas_bottom);
        make.left.mas_equalTo(self.mas_left);
        make.top.mas_equalTo(_contentButton.mas_bottom);
        make.right.mas_equalTo(self.mas_right);
    }];
    
    if (kScreenWidth<=320) {
        _contentButtonFont = [UIFont systemFontOfSize:15.0f];
        _bonusLabelFont = [UIFont systemFontOfSize:13.0f];
       
    }else{
        _contentButtonFont = [UIFont systemFontOfSize:16.0f];
        _bonusLabelFont = [UIFont systemFontOfSize:14.0f];
    }
    _contentButton.titleLabel.font = _contentButtonFont;
    _bonusLabel.font = _bonusLabelFont;
}

-(void)addFrame:(CGRect)frame
    contentText:(NSString *)contentText
     bonusValue:(NSString *)bonusValue
          shape:(CPBuyLtyCellContentItemShape)shape
     layoutType:(CPBuyLtyCellContentItemLayoutType)layoutType
    hasSelected:(BOOL)hasSelected
{
    
    if (!CGSizeEqualToSize(frame.size, self.frame.size)) {
        self.frame = frame;
    }
    [_contentButton setTitle:contentText forState:UIControlStateNormal];
    _contentButton.tag = self.markIndex;
    _bonusLabel.text = bonusValue;
    self.shape = shape;
    self.layoutType = layoutType;
    self.hasSelected = hasSelected;
    
}

-(void)setShape:(CPBuyLtyCellContentItemShape)shape
{
    if (shape != _shape) {
        _shape = shape;
    }

    if (_shape == CPBuyLtyCellContentItemShapeForRect) {
        _contentButton.layer.cornerRadius = 5.0f;
        [_contentButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(30);
            make.left.mas_equalTo(self.mas_left);
            make.top.mas_equalTo(self.mas_top);
            make.right.mas_equalTo(self.mas_right);
        }];
    }else if (_shape == CPBuyLtyCellContentItemShapeForCircle){
        _contentButton.layer.cornerRadius = 40/2.0f;
        //            _contentButton.frame = CGRectMake(self.width-40/2.0f, 0, 40, 40);
        [_contentButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(40, 40));
            make.centerX.equalTo(self);
            make.top.mas_equalTo(self.mas_top);
        }];
    }
}

-(void)setLayoutType:(CPBuyLtyCellContentItemLayoutType)layoutType
{
    if (_layoutType !=layoutType) {
        _layoutType = layoutType;
        if (_layoutType == CPBuyLtyCellContentItemLayoutOnlyContentText) {
            _bonusLabel.hidden = YES;
        }else if (_layoutType == CPBuyLtyCellContentItemLayoutContentTextAndBonusValue){
            _bonusLabel.hidden = NO;
        }
    }
}

-(void)setHasSelected:(BOOL)hasSelected
{
    _hasSelected = hasSelected;
    _contentButton.selected = _hasSelected;
    if (_hasSelected) {
        _contentButton.layer.borderColor = [UIColor clearColor].CGColor;

    }else{
        _contentButton.layer.borderColor = kCOLOR_R_G_B_A(204, 204, 204, 1).CGColor;
    }
}

@end
