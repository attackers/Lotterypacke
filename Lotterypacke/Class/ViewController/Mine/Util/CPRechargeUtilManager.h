//
//  CPRechargeUtilManager.h
//  lottery
//
//  Created by way on 2018/3/15.
//  Copyright © 2018年 way. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CPRechargeUtilManager : NSObject

@property(nonatomic,copy,readonly)NSString *amount;
@property(nonatomic,copy,readonly)NSString *rechargeTip;
@property(nonatomic,copy,readonly)NSString *code;
@property(nonatomic,copy,readonly)NSArray *rechargeTypeList;

+(CPRechargeUtilManager *)shareManager;

-(void)loadRechargeInfo:(NSDictionary *)rechargeInfo;
-(void)clearRechargeInfo;

-(void)loadRechargeTypeList:(NSArray *)rechargeTypeList;

@end
