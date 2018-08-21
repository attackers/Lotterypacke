//
//  CPBuyLtyDetailVC.h
//  lottery
//
//  Created by way on 2018/3/22.
//  Copyright © 2018年 way. All rights reserved.
//

#import "CPBaseViewController.h"

@interface CPBuyLtyDetailVC : CPBaseViewController

@property(nonatomic,copy)NSString *ltyName;
@property(nonatomic,copy)NSString *ltyNum;
@property(nonatomic,copy)NSString *typeCode;
/*
 playList = ({
 playId = 2;
 playName = "\U6570\U5b57\U76d8";
 });
 */
@property(nonatomic,retain)NSArray *menuPlayKindList;
@property(nonatomic,retain)NSDictionary *gfBonusListInfo;

@end
