//
//  CPRechargeUtilManager.m
//  lottery
//
//  Created by way on 2018/3/15.
//  Copyright © 2018年 way. All rights reserved.
//

#import "CPRechargeUtilManager.h"

@interface CPRechargeUtilManager()

@property(nonatomic,retain)NSDictionary *rechargeInfo;

@end

@implementation CPRechargeUtilManager

static CPRechargeUtilManager *shareManager;

+(CPRechargeUtilManager *)shareManager{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        shareManager = [CPRechargeUtilManager new];
    });
    return shareManager;
}

-(void)loadRechargeInfo:(NSDictionary *)rechargeInfo;
{
    _rechargeInfo = rechargeInfo;
}

-(void)clearRechargeInfo
{
    _rechargeInfo = [NSDictionary new];
}

-(void)loadRechargeTypeList:(NSArray *)rechargeTypeList
{
     
}

#pragma mark- setter && getter

-(NSDictionary *)rechargeInfo
{
    if (!_rechargeInfo || ![_rechargeInfo isKindOfClass:[NSDictionary class]]) {
        _rechargeInfo = [NSDictionary new];
    }
    return _rechargeInfo;
}

-(NSString *)amount
{
    NSString *amount = [self.rechargeInfo DWStringForKey:@"amount"];
    return amount;
}

-(NSString *)code
{
    NSString *code = [self.rechargeInfo DWStringForKey:@"code"];
    return code;
}

-(NSString *)rechargeTip
{
    NSString *rechargeTip = [self.rechargeInfo DWStringForKey:@"rechargeTip"];
    return rechargeTip;
}

-(NSArray *)rechargeTypeList
{
    NSArray *rechargeTypeList = [self.rechargeInfo DWArrayForKey:@"payTypeList"];
    return rechargeTypeList;
}

@end
