//
//  CPBuyFastLotteryConfirmView.h
//  lottery
//
//  Created by wayne on 2017/9/19.
//  Copyright © 2017年 way. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CPBuyFastLotteryConfirmAction)(BOOL isConfirm, NSString *value);

@interface CPBuyFastLotteryConfirmView : UIView


/**
 是否是数字盘
 */
@property(nonatomic,assign)BOOL isNumberPan;

+(void)showFastLotteryConfirmViewOnView:(UIView *)supView
                               lotterys:(NSArray *)lotterys
                          numberPeriods:(NSString *)numberPeriods
                                comfirm:(CPBuyFastLotteryConfirmAction)confirm;

+(void)showFastLotteryConfirmViewOnView:(UIView *)supView
                               lotterys:(NSArray *)lotterys
                          numberPeriods:(NSString *)numberPeriods
                            specailType:(int)specailType
                                comfirm:(CPBuyFastLotteryConfirmAction)confirm;

+(void)showOfficailFastLotteryConfirmViewOnView:(UIView *)supView
                                      isSpecial:(BOOL)isSpecial
                                  officailBonus:(NSString *)officailBonus
                                   ltyDesString:(NSAttributedString *)ltyDesString
                                       betCount:(NSInteger)betCount
                                  numberPeriods:(NSString *)numberPeriods
                                        comfirm:(CPBuyFastLotteryConfirmAction)confirm;


@end
