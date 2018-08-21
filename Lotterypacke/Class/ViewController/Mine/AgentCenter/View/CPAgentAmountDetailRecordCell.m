//
//  CPCPSignRecordCell.m
//  lottery
//
//  Created by wayne on 2017/8/26.
//  Copyright © 2017年 way. All rights reserved.
//

#import "CPAgentAmountDetailRecordCell.h"

@interface CPAgentAmountDetailRecordCell ()
{
    IBOutlet UILabel *_topLeftLabel;
    IBOutlet UILabel *_topRightLabel;
    IBOutlet UILabel *_centerLeftLabel;
    IBOutlet UILabel *_centerRightLabel;
    
}

@end

@implementation CPAgentAmountDetailRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)addBetRecordInfo:(NSDictionary *)info
{
    _topLeftLabel.text = [NSString stringWithFormat:@"%@(%@)",[info DWStringForKey:@"type"],[info DWStringForKey:@"memberCode"]];
    _topRightLabel.text = [NSString stringWithFormat:@"%@元",[info DWStringForKey:@"amount"]];
    _centerLeftLabel.text = [NSString stringWithFormat:@"%@",[info DWStringForKey:@"orderNo"]];
    _centerRightLabel.text = [NSString stringWithFormat:@"%@",[info DWStringForKey:@"opsTime"]];

}


@end
