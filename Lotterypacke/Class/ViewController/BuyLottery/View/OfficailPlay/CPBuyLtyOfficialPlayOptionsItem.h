//
//  CPBuyLtyOfficialPlayOptionsItem.h
//  lottery
//
//  Created by way on 2018/6/26.
//  Copyright © 2018年 way. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CPBuyLtyOfficialPlayOptionsItemClickAction)(NSInteger index);

@interface CPBuyLtyOfficialPlayOptionsItem : UIButton

+(instancetype)buttonWithFrame:(CGRect)frame
                     titleText:(NSString *)titleText
                     titleFont:(UIFont *)titleFont
                         index:(NSInteger)index
                    isSelected:(BOOL)isSelected
                   clickAction:(CPBuyLtyOfficialPlayOptionsItemClickAction)clickAction;

@end
