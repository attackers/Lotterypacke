//
//  CPBuyLtyOfficialPlayOptionsSelectedView.h
//  lottery
//
//  Created by way on 2018/6/26.
//  Copyright © 2018年 way. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPBuyLtyOfficialPlayOptionsItemView.h"

@protocol CPBuyLtyOfficialPlayOptionsSelectedViewDelegate<NSObject>

-(void)cpBuyLtyOfficialPlayOptionsSelectedViewSelectedIndexPath:(NSIndexPath *)indexPath
                                                       menuInex:(NSInteger)menuIndex;

@end

@interface CPBuyLtyOfficialPlayOptionsSelectedView : UIView

+(void)showOnView:(UIView *)onView
        menuIndex:(NSInteger)menuIndex
        withTitle:(NSString *)title
         dataList:(NSArray *)dataList
   selectedItemId:(NSString *)selectedItemId
         delegate:(id<CPBuyLtyOfficialPlayOptionsSelectedViewDelegate>)delegate;

@end
