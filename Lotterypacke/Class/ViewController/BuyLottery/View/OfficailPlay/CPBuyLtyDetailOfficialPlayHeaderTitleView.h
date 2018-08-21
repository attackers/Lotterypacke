//
//  CPBuyLtyDetailOfficialPlayHeaderTitleView.h
//  lottery
//
//  Created by way on 2018/6/30.
//  Copyright © 2018年 way. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CPBuyLtyDetailOfficialPlayHeaderTitleView : UIView

-(void)addActionTarget:(id)target
              selector:(SEL)selector;

-(void)addTitle:(NSString *)title
           rate:(NSString *)rate
 hiddenRateView:(BOOL)hiddenRateView;

@end
