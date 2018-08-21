//
//  DWITButton.h
//  XYSProject
//
//  Created by wayne on 2017/9/22.
//  Copyright © 2017年 未来健康. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    
    DWITButtonlayoutNone    = 0,
    
    //图片在左边，文字在右边
    DWITButtonlayoutLeft    = 1,
    
    //图片在右边，文字在左边
    DWITButtonlayoutRight   = 2,
    
    //图片在上面
    DWITButtonlayoutTop     = 3
    
} DWITButtonlayoutType;

IB_DESIGNABLE
@interface DWITButton : UIButton

/**
 图片跟文字的间距
 */
@property (nonatomic, assign) IBInspectable CGFloat tiGap;

/**
 排布的类型
 */
@property (nonatomic, assign) IBInspectable NSInteger layoutType;



/**
 是否在xib上面查看效果
 */
@property (nonatomic, assign) IBInspectable BOOL isIB_DESIGNABLE;




@end
