//
//  LotteryAPPDelegateTool.h
//  TestLottery
//
//  Created by OS X10_12_6 on 2018/8/20.
//  Copyright © 2018年 OS X10_12_6. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WXApi.h"
#import "IQKeyboardManager.h"
#import "JPUSHService.h"
#import "JANALYTICSService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
@interface LotteryAPPDelegateTool : NSObject <UNUserNotificationCenterDelegate,JPUSHRegisterDelegate,WXApiDelegate>
+ (void)registJPush:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;
+ (void)initKeyBoardManager;
+ (void)customAppearence;
@end
