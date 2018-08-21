//
//  CPBuyLotteryForContentCell.h
//  lottery
//
//  Created by way on 2018/3/24.
//  Copyright © 2018年 way. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CPBuyLtyBetContentProtocol.h"

@interface CPBuyLotteryForContentCell : UITableViewCell

@property(nonatomic,weak)id<CPBuyLtyBetContentProtocol>delegate;

@property(nonatomic,assign)BOOL selectedLeftItem;
@property(nonatomic,assign)BOOL selectedRightItem;
@property(nonatomic,retain)NSIndexPath *indexPath;
@property(nonatomic,retain)NSDictionary *leftItemPlayInfo;
@property(nonatomic,retain)NSDictionary *rightItemPlayInfo;

@end
