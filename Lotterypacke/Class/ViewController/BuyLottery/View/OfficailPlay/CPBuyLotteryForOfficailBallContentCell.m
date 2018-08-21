//
//  CPBuyLotteryForContentCell.m
//  lottery
//
//  Created by way on 2018/3/24.
//  Copyright © 2018年 way. All rights reserved.
//

#import "CPBuyLotteryForOfficailBallContentCell.h"
#import "CPBuyLtyContentItem.h"


@interface CPBuyLotteryForOfficailBallContentCell()
{
    // 55 102 119
    IBOutlet CPBuyLtyContentItem *_leftView;
    IBOutlet CPBuyLtyContentItem *_centerView;
    IBOutlet CPBuyLtyContentItem *_rightView;
    
    IBOutlet UIButton *_leftButton;
    IBOutlet UIButton *_centerButton;
    IBOutlet UIButton *_rightButton;
}
@end

@implementation CPBuyLotteryForOfficailBallContentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setFrame:(CGRect)frame
{
    CGSize originSize = self.size;
    [super setFrame:frame];
    if (CGSizeEqualToSize(originSize, self.frame.size) == NO) {
        [self layoutSubviews];
        [self.contentView layoutSubviews];
    }
}

#pragma mark-

-(void)setSelectedLeftItem:(BOOL)selectedLeftItem
{
    _selectedLeftItem = selectedLeftItem;
    _leftView.hasSelected = _selectedLeftItem;
}

-(void)setSelectedCenterItem:(BOOL)selectedCenterItem
{
    _selectedCenterItem = selectedCenterItem;
    _centerView.hasSelected = _selectedCenterItem;
}

-(void)setSelectedRightItem:(BOOL)selectedRightItem
{
    _selectedRightItem = selectedRightItem;
    _rightView.hasSelected = _selectedRightItem;
}

-(void)setLeftItemPlayInfo:(NSDictionary *)leftItemPlayInfo
{
    
    if (leftItemPlayInfo && leftItemPlayInfo.allKeys.count>0) {
        //设置left的内容
        _leftButton.hidden = NO;
        [self addPlayInfo:leftItemPlayInfo onView:_leftView isSelected:_selectedLeftItem];
        
    }else{
        
        //清除left的内容
        _leftButton.hidden = YES;
        [_leftView cleanSubviews];

    }
}

-(void)setCenterItemPlayInfo:(NSDictionary *)centerItemPlayInfo
{
    if (centerItemPlayInfo && centerItemPlayInfo.allKeys.count>0) {
        //设置left的内容
        _centerButton.hidden = NO;
        [self addPlayInfo:centerItemPlayInfo onView:_centerView isSelected:_selectedCenterItem];
        
    }else{
        
        //清除left的内容
        _centerButton.hidden = YES;
        [_centerView cleanSubviews];
    }
}

-(void)setRightItemPlayInfo:(NSDictionary *)rightItemPlayInfo
{
    if (rightItemPlayInfo && rightItemPlayInfo.allKeys.count>0) {
        //设置right的内容
        _rightButton.hidden = NO;
        [self addPlayInfo:rightItemPlayInfo onView:_rightView isSelected:_selectedRightItem];
        
    }else{
        //清除right的内容
        _rightButton.hidden = YES;
        [_rightView cleanSubviews];

    }
}

- (IBAction)buttonActions:(UIButton *)sender {
    
    NSInteger number = 0;
    if (sender.tag == 77) {
        //点击中间
        number = 1;
    }else if (sender.tag == 88){
        //点击右边
        number = 2;
    }
    
    if (self.delegate) {
        [self.delegate cpBuyLtyBetContentSelectedIndexPath:self.indexPath offsetNumber:number];
    }
}


-(void)addPlayInfo:(NSDictionary *)playInfo
            onView:(CPBuyLtyContentItem *)onView
        isSelected:(BOOL)isSelected
{
//

    NSAttributedString *textAtt;
    
    NSString *playName = [playInfo DWStringForKey:@"playName"];
//    UIColor *playNameNormalColor = [UIColor blackColor];
//    UIColor *playNameSelectedColor = [UIColor whiteColor];
    UIColor *playNameNormalColor = RGBA(100, 100, 100, 1);
    UIColor *playNameSelectedColor = RGBA(11, 11, 11, 1);
    
    
    UIFont *playNameFont = [UIFont systemFontOfSize:15];
    
    NSString *string = [NSString stringWithFormat:@"%@",playName];
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc]initWithString:string];
    [attString addAttributes:@{NSFontAttributeName:playNameFont,NSForegroundColorAttributeName:isSelected?playNameSelectedColor:playNameNormalColor} range:[string rangeOfString:playName]];
    textAtt = attString;
    [onView addSingleAttributedString:textAtt];

}

@end
