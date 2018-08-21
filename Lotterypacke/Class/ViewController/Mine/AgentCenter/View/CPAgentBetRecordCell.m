//
//  CPCPSignRecordCell.m
//  lottery
//
//  Created by wayne on 2017/8/26.
//  Copyright © 2017年 way. All rights reserved.
//

#import "CPAgentBetRecordCell.h"

@interface CPAgentBetRecordCell ()
{
    IBOutlet UILabel *_topLeftLabel;
    IBOutlet UILabel *_topRightLabel;
    IBOutlet UILabel *_centerLeftLabel;
    IBOutlet UILabel *_centerRightLabel;
    
    IBOutlet UILabel *_bottomLeftLabel;
    IBOutlet UILabel *_bottomRightLabel;
    
    
    
}

@end

@implementation CPAgentBetRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)addBetRecordInfo:(NSDictionary *)info
{
    _topLeftLabel.text = [NSString stringWithFormat:@"%@  第%@期",[info DWStringForKey:@"typeName"],[info DWStringForKey:@"period"]];
    int isWin = [[info DWStringForKey:@"isWin"]intValue]==1?YES:NO;

    _topRightLabel.text = [NSString stringWithFormat:@"%@元",[[info DWStringForKey:@"amount"]jdM]];
    _topRightLabel.highlighted = isWin;
    _centerLeftLabel.text = [info DWStringForKey:@"addTime"];
    
    if (isWin==1) {
        _centerRightLabel.text = @"已中奖";
    }else if (isWin == 0){
        _centerRightLabel.text = @"等待开奖";
    }else{
        _centerRightLabel.text = @"未中奖";
    }
    
    _bottomLeftLabel.text = [NSString stringWithFormat:@"玩法名称:%@",[info DWStringForKey:@"playName"]];
    _bottomRightLabel.text = [NSString stringWithFormat:@"%@",[info DWStringForKey:@"content"]];
    
}


@end
