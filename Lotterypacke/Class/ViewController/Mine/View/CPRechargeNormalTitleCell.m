//
//  CPRechargeNormalCell.m
//  lottery
//
//  Created by wayne on 2017/9/10.
//  Copyright © 2017年 way. All rights reserved.
//


#import "CPRechargeNormalTitleCell.h"

@interface CPRechargeNormalTitleCell ()
{
    IBOutlet UILabel *_nameLabel;
    IBOutlet UIButton *_selectedImageView;
    IBOutlet UIView *_contentBgView;
}

@end

@implementation CPRechargeNormalTitleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [_selectedImageView setImage:[UIImage imageNamed:@"cz_01"] forState:UIControlStateNormal];
    [_selectedImageView setImage:[UIImage imageNamed:@"cz_02"] forState:UIControlStateSelected];
    _contentBgView.layer.cornerRadius = 5.0f;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


-(void)addBankName:(NSString *)bankName
          selected:(BOOL)selected
{
    _nameLabel.text = bankName;
    [_selectedImageView setSelected:selected];
    
}

@end
