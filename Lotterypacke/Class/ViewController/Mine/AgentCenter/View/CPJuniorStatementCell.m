//
//  CPJuniorStatementCell.m
//  lottery
//
//  Created by way on 2018/5/28.
//  Copyright © 2018年 way. All rights reserved.
//

#import "CPJuniorStatementCell.h"
@interface CPJuniorStatementCell()
{
    IBOutlet UILabel *_nameLabel;
    IBOutlet UILabel *_typeLabel;
    IBOutlet UILabel *_numberLabel;
    IBOutlet UILabel *_winCountLabel;
    
}
@end

@implementation CPJuniorStatementCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    //type =1 代理
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


#pragma mark-

-(void)addRecordInfo:(NSDictionary *)info
{
    //{"inviteLevel":1,"reportNum":"0","code":"test02","type":2,"winAmount":"0"}
    NSString *typeDes = [[info DWStringForKey:@"type"]intValue]==1?@"代理":@"玩家";
    _nameLabel.text = [info DWStringForKey:@"code"];
    _typeLabel.text =  [NSString stringWithFormat:@"%@级%@",[info DWStringForKey:@"inviteLevel"],typeDes];
    _numberLabel.text = [info DWStringForKey:@"reportNum"];
    _winCountLabel.text = [info DWStringForKey:@"winAmount"];

}

-(void)addMemberManagerRecordInfo:(NSDictionary *)info
{
    
//    @{"type":1,"code":"test01","inviteId":1,"inviteLevel":1,"status":4,"logTime":"May 11, 2018 2:30:08 PM","id":2}
    NSString *typeDes = [[info DWStringForKey:@"type"]intValue]==1?@"代理":@"玩家";
    _nameLabel.text = [info DWStringForKey:@"code"];
    _typeLabel.text =  [NSString stringWithFormat:@"%@级%@",[info DWStringForKey:@"inviteLevel"],typeDes];
    _winCountLabel.text = [info DWStringForKey:@"status"];

    NSString* timeStr = [info DWStringForKey:@"logTime"];
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
    [toformatter setDateFormat:@"yyyy-MM-dd"];//设置目标时间字符串的格式
    
    
    NSString *targetTime = [toformatter stringFromDate:date];
    _numberLabel.text = targetTime;

}


@end
