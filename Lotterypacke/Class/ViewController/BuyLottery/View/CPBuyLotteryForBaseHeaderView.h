//
//  CPBuyLotteryForBaseHeaderView.h
//  lottery
//
//  Created by way on 2018/3/22.
//  Copyright © 2018年 way. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPBuyLotteryHeaderViewProtocol.h"

@interface CPBuyLotteryForBaseHeaderView : UIView

@property(nonatomic,assign)id<CPBuyLotteryHeaderViewProtocol>actionDelegate;

-(void)loadDataByPlayInfo:(NSDictionary *)playInfo;
-(void)loadCountTime:(NSString *)countTime;
-(void)loadBalance:(NSString *)balance;

@end
