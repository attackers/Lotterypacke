//
//  CPRechargeMainViewController.h
//  lottery
//
//  Created by wayne on 2017/9/8.
//  Copyright © 2017年 way. All rights reserved.
//

#import "CPBaseViewController.h"
#import "CPRechargeHeader.h"

@interface CPRechargeMainViewController : CPBaseViewController

@property(nonatomic,assign)CPRechargeType rechargeType;

@property(nonatomic,retain)NSArray *charegeTypeInfoList;
@property(nonatomic,copy)NSString *memberAmount;
@property(nonatomic,copy)NSString *memberCode;
@property(nonatomic,copy)NSString *rechargeTip;
@property(nonatomic,copy)NSString *rechargeTypeString;

@property(nonatomic,copy)NSString *logoUrlImgString;
@property(nonatomic,retain)NSArray *onlineBankInfoList;



@end
