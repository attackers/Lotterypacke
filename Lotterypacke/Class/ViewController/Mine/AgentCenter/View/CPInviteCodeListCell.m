//
//  CPInviteCodeListCell.m
//  lottery
//
//  Created by way on 2018/6/11.
//  Copyright © 2018年 way. All rights reserved.
//

#import "CPInviteCodeListCell.h"
@interface CPInviteCodeListCell()
{
    
    IBOutlet UILabel *_inviteCodeLabel;
    IBOutlet UILabel *_dateLabel;
    IBOutlet UILabel *_statusLabel;
}
@end

@implementation CPInviteCodeListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)addInfo:(NSDictionary *)info
{
    _inviteCodeLabel.text = [info DWStringForKey:@"inviteCode"];
    _statusLabel.text = [NSString stringWithFormat:@"注册(%@)",[info DWStringForKey:@"status"]];
    
    NSString* timeStr = [info DWStringForKey:@"addTime"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"MMMM dd, yy hh:mm:ss aa"];//设置源时间字符串的格式
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];//设置时区
    [formatter setTimeZone:timeZone];
    NSDate* date = [formatter dateFromString:timeStr];//将源时间字符串转化为NSDate
    NSDateFormatter* toformatter = [[NSDateFormatter alloc] init];
    [toformatter setDateStyle:NSDateFormatterMediumStyle];
    [toformatter setTimeStyle:NSDateFormatterShortStyle];
    [toformatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];//设置目标时间字符串的格式
    
    
    NSString *targetTime = [toformatter stringFromDate:date];
    _dateLabel.text = targetTime;

}

@end
