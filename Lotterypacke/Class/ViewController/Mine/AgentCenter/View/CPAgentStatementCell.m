//
//  CPAgentStatementCell.m
//  lottery
//
//  Created by way on 2018/5/27.
//  Copyright © 2018年 way. All rights reserved.
//

#import "CPAgentStatementCell.h"
#import "LotteryHeader.h"

@interface CPAgentStatementCell()
{
    
    IBOutlet UIImageView *_picImgView;
    IBOutlet UILabel *_contentLabel;
    IBOutlet UILabel *_desLabel;
    IBOutlet UILabel *_bottomLine;
    IBOutlet UILabel *_rightLine;
    
}
@end

@implementation CPAgentStatementCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Initialization code
}

-(void)addImage:(UIImage *)img
        content:(NSString *)content
            des:(NSString *)des
isShowBottomLine:(BOOL)showBottomLine
isShowRightLine:(BOOL)showRightLine
{
    CGPoint center = _picImgView.center;
    [_picImgView setImage:img];
    _picImgView.size = img.size;
    _picImgView.center = center;
    _contentLabel.text = content;
    _desLabel.text = des;
    _rightLine.hidden = !showRightLine;
    _bottomLine.hidden = !showBottomLine;
    _rightLine.width = 0.5;
    _rightLine.originX = self.width-0.5;
    
    _bottomLine.height = 0.5;
    _bottomLine.originY = self.height - 0.5;
    
    
}

@end
