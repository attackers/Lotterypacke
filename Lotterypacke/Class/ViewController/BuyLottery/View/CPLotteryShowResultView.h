//
//  CPLotteryShowResultView.h
//  lottery
//
//  Created by way on 2017/11/18.
//  Copyright © 2017年 way. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CPLotteryShowResultView : UIView


-(void)showResult:(NSArray *)result
       resultType:(CPLotteryResultType)resultType
       isWaitOpen:(BOOL)isWaitOpen;

+(CGFloat)resultViewHeightByResult:(NSArray *)result
                        resultType:(CPLotteryResultType)resultType
                  isWaitOpenResult:(BOOL)isWaitOpen
                          maxWidth:(CGFloat)maxWidth
                            isList:(BOOL)isList;

@end
