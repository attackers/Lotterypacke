//
//  CPBuyLotteryForTypeTwoContentCell.h
//  lottery
//
//  Created by way on 2018/4/5.
//  Copyright © 2018年 way. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPBuyLtyBetContentProtocol.h"

@interface CPBuyLotteryForTypeTwoContentCell : UITableViewCell

@property(nonatomic,weak)id<CPBuyLtyBetContentProtocol>delegate;

@property(nonatomic,retain)NSIndexPath *indexPath;


-(void)addLtyInfos:(NSArray *)infos
      selectedList:(NSArray *)selectedList;

@end
