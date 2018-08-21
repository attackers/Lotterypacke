//
//  CPHomePageHotLotteryItem.m
//  lottery
//
//  Created by wayne on 2017/6/12.
//  Copyright © 2017年 way. All rights reserved.
//

#import "CPHomePageHotLotteryItem.h"

@interface CPHomePageHotLotteryItem ()
{
    CPVoiceButton *_acionButton;
    UIImageView *_iconImageView;
    UILabel *_nameLabel;
    UILabel *_desLabel;
    
}
@property(nonatomic,copy)CPHomePageHotLotteryItemClickAction clickAction;
@property(nonatomic,retain)CPLotteryModel *lottery;

@property(nonatomic,retain)UILabel *bottomLine;
@property(nonatomic,retain)UILabel *rightLine;


@end

@implementation CPHomePageHotLotteryItem

-(instancetype)initWithFrame:(CGRect)frame
                     lottery:(CPLotteryModel*)lottery
                 clickAction:(CPHomePageHotLotteryItemClickAction)action
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.clickAction = action;
        self.lottery = lottery;
        [self addSubviews];
    }
    return self;
}

#pragma mark-
    
-(void)setIsZeroBottomLineOriginX:(BOOL)isZeroBottomLineOriginX
{
    self.bottomLine.originX = isZeroBottomLineOriginX?0:10;
}

-(UILabel *)bottomLine
{
    if (!_bottomLine) {
        _bottomLine = [[UILabel alloc]initWithFrame:CGRectMake(0, self.height-kGlobalLineWidth, self.width-10, kGlobalLineWidth)];
        _bottomLine.backgroundColor = kGlobalLineColor;
    }
    return _bottomLine;
}

-(UILabel *)rightLine
{
    if (!_bottomLine) {
        _bottomLine = [[UILabel alloc]initWithFrame:CGRectMake( 0,self.height-kGlobalLineWidth, self.width,kGlobalLineWidth)];
        _bottomLine.backgroundColor = kGlobalLineColor;
    }
    return _bottomLine;
}

-(void)setIsShowBottomGapLine:(BOOL)isShowBottomGapLine
{
    _isShowBottomGapLine = isShowBottomGapLine;
    _bottomLine.hidden = isShowBottomGapLine?NO:YES;
}

#pragma mark-

-(void)addSubviews
{
    _acionButton = [CPVoiceButton buttonWithType:UIButtonTypeCustom];
    _acionButton.frame = CGRectMake(0, 0, self.width, self.height);
    [_acionButton addTarget:self action:@selector(buttonClickAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_acionButton];
    
    CGSize iconSize = CGSizeMake(59, 62);
    _iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, (self.height-iconSize.height)/2.0f, iconSize.width, iconSize.height)];
    
    if ([self.lottery.num isEqualToString:@"0"]) {
        
        [_iconImageView setImage:[UIImage imageNamed:self.lottery.pic]];
        
    }else{
        
        [_iconImageView sd_setImageWithURL:[NSURL URLWithString:self.lottery.fullPicUrlString] placeholderImage:[UIImage imageNamed:@""]];
    }
    
    
    [self addSubview:_iconImageView];
    
    _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(_iconImageView.rightX+5, _iconImageView.originY, self.width-(_iconImageView.rightX+5), _iconImageView.height/2.0f)];
    _nameLabel.textAlignment = NSTextAlignmentLeft;
    _nameLabel.textColor = kCOLOR_R_G_B_A(51, 51, 51, 1);
    _nameLabel.font = [UIFont systemFontOfSize:15.0f];
    _nameLabel.numberOfLines = 0;
    _nameLabel.text = self.lottery.name;
    
    [self addSubview:_nameLabel];
    
    _desLabel = [[UILabel alloc]initWithFrame:CGRectMake(_nameLabel.originX, _nameLabel.bottomY, self.width-(_iconImageView.rightX+5), _iconImageView.height/2.0f)];
    _desLabel.textAlignment = NSTextAlignmentLeft;
    _desLabel.textColor = kCOLOR_R_G_B_A(105, 105, 105, 1);
    _desLabel.font = [UIFont systemFontOfSize:14.0f];
    _desLabel.numberOfLines = 0;
    _desLabel.text = self.lottery.desc;
    [self addSubview:_desLabel];
    
//    _desLabel
    
    [self addSubview:self.rightLine];
    [self addSubview:self.bottomLine];
        
}


-(void)buttonClickAction
{
    if (self.clickAction) {
        self.clickAction(self.lottery);
    }
}


@end
