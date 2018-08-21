//
//  CPBuyLtyOfficialPlayOptionsItemView.h
//  lottery
//
//  Created by way on 2018/6/26.
//  Copyright © 2018年 way. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPBuyLtyOfficialPlayOptionsItem.h"

typedef void(^CPBuyLtyOfficialPlayOptionsItemViewClickAction)(NSIndexPath *clickIndexPath);

@interface CPBuyLtyOfficialPlayOptionsItemView : UIView

+(instancetype)loadWithFrame:(CGRect)frame
                  titleWidth:(CGFloat)titleWidth
                    dataInfo:(NSDictionary *)dataInfo
              selectedItemId:(NSString *)selectedItemId
                 isFirstItem:(BOOL)isFirstItem
                 isFinalItem:(BOOL)isFinalItem
                       index:(NSInteger)index
                 clickAction:(CPBuyLtyOfficialPlayOptionsItemViewClickAction)click;

@end
