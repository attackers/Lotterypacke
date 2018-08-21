//
//  CPRechargeRightMenuView.h
//  lottery
//
//  Created by way on 2017/11/27.
//  Copyright © 2017年 way. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CPRechargeRightMenuView : UIView

+(CPRechargeRightMenuView *)showRightMenuViewOnView:(UIView *)supview
                                            originY:(CGFloat)originY
                         actionNavigationController:(UINavigationController *)nav;

-(void)dismiss;

@end
