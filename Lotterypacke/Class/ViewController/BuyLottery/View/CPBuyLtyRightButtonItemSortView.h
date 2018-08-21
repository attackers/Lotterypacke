//
//  CPBuyLtyRightButtonItemSortView.h
//  lottery
//
//  Created by way on 2018/4/7.
//  Copyright © 2018年 way. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CPBuyLtyRightButtonItemSortActionProtocol <NSObject>

-(void)cpBuyLtyRightButtonItemSortActionByTag:(NSInteger)tag;

@end

@interface CPBuyLtyRightButtonItemSortView : UIView

@property(nonatomic,weak)id<CPBuyLtyRightButtonItemSortActionProtocol>delegate;

@end
