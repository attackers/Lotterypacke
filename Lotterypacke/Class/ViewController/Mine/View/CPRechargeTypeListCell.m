//
//  CPRechargeTypeListCell.m
//  lottery
//
//  Created by way on 2018/3/14.
//  Copyright © 2018年 way. All rights reserved.
//

#import "CPRechargeTypeListCell.h"

@interface CPRechargeTypeListCell()
{
    
    IBOutlet UIView *_infoView;
    IBOutlet UIImageView *_pictureImageView;
    IBOutlet UILabel *_titleLabel;
    IBOutlet UILabel *_infoLabel;
    
}
@end

@implementation CPRechargeTypeListCell
    
-(void)addPictureImage:(NSString *)imageUrlString
                 title:(NSString *)title
               content:(NSString *)content
{
    [_pictureImageView sd_setImageWithURL:[NSURL URLWithString:imageUrlString]
                         placeholderImage:nil
                                  options:SDWebImageRetryFailed];
    _titleLabel.text = title;
    _infoLabel.text = content;
    
}
    
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _infoView.layer.cornerRadius = 5.0f;
    _infoView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
