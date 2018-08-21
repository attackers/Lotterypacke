//
//  UIViewController+CPViewControllerExtension.h
//  lottery
//
//  Created by wayne on 2017/9/15.
//  Copyright © 2017年 way. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (CPViewControllerExtension)<UIActionSheetDelegate>


-(void)removeSelfFromNavigationControllerViewControllers;
-(void)cp_AddLongPressShotScreenAction;
-(void)cp_ScreenShotWithView:(UIView *)view;

@end
