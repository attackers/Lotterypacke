//
//  DWITButton.m
//  XYSProject
//
//  Created by wayne on 2017/9/22.
//  Copyright © 2017年 未来健康. All rights reserved.
//

#import "DWITButton.h"

@implementation DWITButton


- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    CGSize imageSize = self.imageView.frame.size;
    CGSize titleSize = self.titleLabel.frame.size;
    CGSize selfSize = self.frame.size;
    CGRect imgRect = self.imageView.frame;
    CGRect titleRect = self.titleLabel.frame;
    switch (self.layoutType) {
        case DWITButtonlayoutNone:
        {
            
        }break;
        case DWITButtonlayoutLeft:
        {
            
            imgRect = CGRectMake((selfSize.width-imageSize.width-titleSize.width-self.tiGap)/2.0f, (selfSize.height-imageSize.height)/2.0f, imageSize.width, imageSize.height);
            titleRect = CGRectMake(imgRect.origin.x + imgRect.size.width+self.tiGap, (selfSize.height-titleSize.height)/2.0f, titleSize.width, titleSize.height);
            
        }break;
        case DWITButtonlayoutRight:
        {
            
            titleRect = CGRectMake((selfSize.width-imageSize.width-titleSize.width-self.tiGap)/2.0f, (selfSize.height-titleSize.height)/2.0f, titleSize.width, titleSize.height);
            imgRect = CGRectMake(titleRect.origin.x + titleRect.size.width+self.tiGap, (selfSize.height-imageSize.height)/2.0f, imageSize.width, imageSize.height);
            
        }break;
        case DWITButtonlayoutTop:
        {
            imgRect = CGRectMake((selfSize.width-imageSize.width)/2.0f, (selfSize.height-imageSize.height-titleSize.height-self.tiGap)/2.0f, imageSize.width, imageSize.height);
            titleRect = CGRectMake((selfSize.width-titleSize.width)/2.0f, imgRect.origin.y+imgRect.size.height+self.tiGap, titleSize.width, titleSize.height);
        }break;
        default:
            break;
    }
    self.titleLabel.frame = titleRect;
    self.imageView.frame = imgRect;
    
}

-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    if (self.isIB_DESIGNABLE) {
        [self layoutSubviews];
    }
}

@end
