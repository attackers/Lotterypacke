//
//  CPBuyLtyRightButtonItemSortView.m
//  lottery
//
//  Created by way on 2018/4/7.
//  Copyright © 2018年 way. All rights reserved.
//

#import "CPBuyLtyRightButtonItemSortView.h"

@implementation CPBuyLtyRightButtonItemSortView

- (IBAction)buttonActions:(UIButton *)sender {
    if (self.delegate) {
        [self.delegate cpBuyLtyRightButtonItemSortActionByTag:sender.tag];
    }
}


@end
