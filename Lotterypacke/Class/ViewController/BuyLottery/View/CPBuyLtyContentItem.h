//
//  CPBuyLtyContentItem.h
//  lottery
//
//  Created by way on 2018/4/2.
//  Copyright © 2018年 way. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CPBuyLtyContentItem : UIView

@property(nonatomic,assign)BOOL hasSelected;

-(void)cleanSubviews;

-(void)addSingleAttributedString:(NSAttributedString *)att;

-(void)addSingleImage:(UIImage *)image
     attributedString:(NSAttributedString *)att;

-(void)addImage:(UIImage *)image
imgAttributedString:(NSAttributedString *)imgAtt
           font:(UIFont *)font
      textColor:(UIColor *)textColor
           text:(NSString *)text;

-(void)addImages:(NSArray *)images
            font:(UIFont *)font
       textColor:(UIColor *)textColor
            text:(NSString *)text;
@end
