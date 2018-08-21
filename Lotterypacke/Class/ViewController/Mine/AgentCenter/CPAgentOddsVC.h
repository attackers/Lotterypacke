
//
//  CPAgentOddsVC.h
//  lottery
//
//  Created by way on 2018/4/17.
//  Copyright © 2018年 way. All rights reserved.
//

#import "CPBaseViewController.h"

@interface CPAgentOddsVC : CPBaseViewController

@property(nonatomic,copy)NSString *baseUrlString;

/*
 {
     addBy = system;
     addTime = "Mar 16, 2018 3:55:08 PM";
     code = ssc;
     fd = 10;
     id = 1;
     name = "\U65f6\U65f6\U5f69";
     sort = 1;
     status = 1;
     updBy = system;
     updTime = "Mar 16, 2018 3:55:08 PM";
 }
 {
 }
 */
@property(nonatomic,retain)NSArray *ltyInfoList;

@end
