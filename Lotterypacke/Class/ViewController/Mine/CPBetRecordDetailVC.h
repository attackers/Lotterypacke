//
//  CPBetRecordDetailVC.h
//  lottery
//
//  Created by way on 2018/7/24.
//  Copyright © 2018年 way. All rights reserved.
//

#import "CPWebViewController.h"

@interface CPBetRecordDetailVC : CPWebViewController

/*
 {
 addTime = "2018-07-24 22:18:01";
 amount = "0.3";
 code = k3;
 content = "2|5,6,3";
 gId = 10;
 gameName = "\U6c5f\U82cf\U5feb\U4e09";
 id = 2069242;
 isWin = 0;
 period = 20180725001;
 playName = "\U4e09\U4e0d\U540c\U53f7-\U4e09\U4e0d\U540c\U53f7";
 realWinAmount = "-0.3";
 status = 0;
 winAmount = 0;
 }
 */
@property(nonatomic,retain)NSDictionary *betRecordInfo;

@end
