//
//  CPVoiceButton.m
//  lottery
//
//  Created by wayne on 2017/6/17.
//  Copyright © 2017年 way. All rights reserved.
//

#import "CPVoiceButton.h"

@interface CPVoiceButton ()
@end

@implementation CPVoiceButton

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent*)event
{
    [super touchesBegan:touches withEvent:event];
    [CPGlobalDataManager playButtonClickVoice];
    
}

@end
