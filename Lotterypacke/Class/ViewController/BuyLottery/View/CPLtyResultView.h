//
//  CPLtyResultView.h
//  lottery
//
//  Created by way on 2018/3/29.
//  Copyright © 2018年 way. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LotteryHeader.h"

@interface CPLtyResultView : UIView

-(void)showResult:(NSArray *)result
       resultType:(CPLotteryResultType)resultType;

@end
