//
//  CPBuyLtyRightButtonItemSortView.h
//  lottery
//
//  Created by way on 2018/4/7.
//  Copyright © 2018年 way. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CPAgentCenterRightButtonItemActionProtocol <NSObject>

-(void)cpAgentCenterButtonItemSortActionByTag:(NSInteger)tag;

@end

@interface CPAgentCenterRightButtonItem : UIView

@property(nonatomic,weak)id<CPAgentCenterRightButtonItemActionProtocol>delegate;

@end
