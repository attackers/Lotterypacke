//
//  CPFixedValueButton.m
//  lottery
//
//  Created by wayne on 2017/9/19.
//  Copyright © 2017年 way. All rights reserved.
//

#import "CPFixedValueButton.h"

@implementation CPFixedValueButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent*)event
{
    [super touchesBegan:touches withEvent:event];
    [CPGlobalDataManager playButtonClickVoice];
}


-(void)awakeFromNib
{
    [super awakeFromNib];
    self.layer.borderColor = kCOLOR_R_G_B_A(227, 227, 227, 1).CGColor;
    self.layer.borderWidth = kGlobalLineWidth;
    self.layer.cornerRadius = 5.0f;
}

@end
