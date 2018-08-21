//
//  CPBuyLtyDetailOfficialPlayTitleView.h
//  lottery
//
//  Created by way on 2018/6/29.
//  Copyright © 2018年 way. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CPBuyLtyDetailOfficialPlayTitleView : UIView

-(void)addActionTarget:(id)target
                action:(SEL)action;

-(void)addTitle:(NSString *)title
     isOfficail:(BOOL)isOfficail;

@end
