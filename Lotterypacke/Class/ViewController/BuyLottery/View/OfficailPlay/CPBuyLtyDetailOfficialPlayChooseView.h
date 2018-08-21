//
//  CPBuyLtyDetailOfficialPlayChooseView.h
//  lottery
//
//  Created by way on 2018/6/29.
//  Copyright © 2018年 way. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CPBuyLtyDetailOfficialPlayChooseViewDelegate<NSObject>

-(void)cpBuyLtyDetailOfficialPlayChooseViewChooseIndex:(NSInteger)index;

@end

@interface CPBuyLtyDetailOfficialPlayChooseView : UIView

-(void)showOnView:(UIView *)onView
    selectedIndex:(NSInteger)selectedIndex
         delegate:(id<CPBuyLtyDetailOfficialPlayChooseViewDelegate>)delegate;

-(void)dismiss;

@end
