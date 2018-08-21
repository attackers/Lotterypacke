//
//  CPBuyLtyCellContentItem.h
//  lottery
//
//  Created by way on 2018/8/4.
//  Copyright © 2018年 way. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    
    CPBuyLtyCellContentItemShapeForNone         = 0,
    CPBuyLtyCellContentItemShapeForCircle       = 1,
    CPBuyLtyCellContentItemShapeForRect         = 2
    
} CPBuyLtyCellContentItemShape;

typedef enum : NSUInteger {
    
    CPBuyLtyCellContentItemLayoutNone                           = 0,
    CPBuyLtyCellContentItemLayoutOnlyContentText                = 1,
    CPBuyLtyCellContentItemLayoutContentTextAndBonusValue       = 2
    
} CPBuyLtyCellContentItemLayoutType;

@interface CPBuyLtyCellContentItem : UIView

@property(nonatomic,assign)NSInteger markIndex;

-(instancetype)initWithActionTarget:(id)target
                           selector:(SEL)selector;

-(void)addFrame:(CGRect)frame
    contentText:(NSString *)contentText
     bonusValue:(NSString *)bonusValue
          shape:(CPBuyLtyCellContentItemShape)shape
     layoutType:(CPBuyLtyCellContentItemLayoutType)layoutType
    hasSelected:(BOOL)hasSelected;

@end
