//
//  CPBuyLotteryForMenuCell.m
//  lottery
//
//  Created by way on 2018/3/23.
//  Copyright © 2018年 way. All rights reserved.
//

#import "CPBuyLotteryForMenuCell.h"
#import "LotteryHeader.h"

@interface CPBuyLotteryForMenuCell()
{
    
    IBOutlet UIButton *_actionButton;
    IBOutlet UILabel *_nameLabel;
    
}
@end

@implementation CPBuyLotteryForMenuCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [_nameLabel setHighlightedTextColor:kCOLOR_R_G_B_A(193, 38, 33, 1)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)setName:(NSString *)name
{
    _name = name;
    _nameLabel.text = name;
    NSInteger nameCount = name.length;
    _nameLabel.adjustsFontSizeToFitWidth = NO;
    if(nameCount<=4){
        _nameLabel.font = [UIFont systemFontOfSize:17.0f];
    }else if (nameCount == 5){
        _nameLabel.font = [UIFont systemFontOfSize:16.0f];
    }else if (nameCount == 6){
        _nameLabel.font = [UIFont systemFontOfSize:14.0f];
    }else{
        _nameLabel.adjustsFontSizeToFitWidth = YES;
    }
    
}

-(void)setHasSelected:(BOOL)hasSelected
{
    _hasSelected = hasSelected;
    if (hasSelected) {
        _nameLabel.highlighted = YES;
        _actionButton.selected = YES;
    }else{
        _nameLabel.highlighted = NO;
        _actionButton.selected = NO;
    }
}



@end
