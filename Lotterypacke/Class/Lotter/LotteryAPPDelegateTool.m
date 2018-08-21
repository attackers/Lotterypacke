//
//  LotteryAPPDelegateTool.m
//  TestLottery
//
//  Created by OS X10_12_6 on 2018/8/20.
//  Copyright © 2018年 OS X10_12_6. All rights reserved.
//


#import "LotteryAPPDelegateTool.h"


@interface LotteryAPPDelegateTool()

@end
@implementation LotteryAPPDelegateTool
+ (void)registJPush:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSString *J_SDK_Key = @"b8089acc0aa83519bf5ad014";
    BOOL isProduction = YES;
    /**
     * 极光统计
     */
    JANALYTICSLaunchConfig * config = [[JANALYTICSLaunchConfig alloc] init];
    config.appKey = J_SDK_Key;
    config.channel = isProduction?@"95C-Production":@"95C-Debug";
    [JANALYTICSService setupWithConfig:config];
    [JANALYTICSService crashLogON];
    /*
     极光推送
     */
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义categories
        /**/
        
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    [JPUSHService setupWithOption:launchOptions appKey:J_SDK_Key
                          channel:isProduction?@"95C-Production":@"95C-Debug"
                 apsForProduction:isProduction
            advertisingIdentifier:nil];
    
    //iOS10必须加下面这段代码。
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate=self;
    UNAuthorizationOptions types10 = UNAuthorizationOptionBadge|  UNAuthorizationOptionAlert|UNAuthorizationOptionSound;
    [center requestAuthorizationWithOptions:types10
                          completionHandler:^(BOOL granted, NSError * _Nullable error) {
                              if (granted) {
                                  //点击允许
                                  //这里可以添加一些自己的逻辑
                              } else {
                                  //点击不允许
                                  //这里可以添加一些自己的逻辑
                              }
                          
                          }];
}
+ (void)initKeyBoardManager {
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    //    manager.enableAutoToolbar =;
    manager.toolbarDoneBarButtonItemText = @"完成";
}
+ (void)customAppearence
{
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageWithColor:kMainColor] forBarMetrics:UIBarMetricsDefault];
    
    UIImage *backButtonImage = [[UIImage imageNamed:@"back_navi"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UINavigationBar appearance]setBackIndicatorImage:backButtonImage];
    [[UINavigationBar appearance]setBackIndicatorTransitionMaskImage:backButtonImage];
    [[UINavigationBar appearance]setTintColor:[UIColor clearColor]];
    
    if (@available(iOS 11.0, *)) {
        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
        // 去掉iOS11系统默认开启的self-sizing
        [UITableView appearance].estimatedRowHeight = 0;
        [UITableView appearance].estimatedSectionHeaderHeight = 0;
        [UITableView appearance].estimatedSectionFooterHeight = 0;
        [UIScrollView appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    [[UINavigationBar appearance] setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor whiteColor],
      NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:20.0f],NSFontAttributeName,
      nil]];
    
    [[UITabBar appearance]setTintColor:kMainColor];
    
}
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {

    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler();  // 系统要求执行这个方法
}

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}
- (void)onResp:(BaseResp *)resp
{
    if ([resp isKindOfClass:[SendAuthResp class]]) {
        SendAuthResp *temp = (SendAuthResp *)resp;
        [self queryWechatUnionid:temp.code];
        //temp.code
    }
}

- (void)queryWechatUnionid:(NSString *)code
{
    [SVProgressHUD way_showLoadingCanNotTouchClearBackground];
    
    NSString *url =[NSString stringWithFormat:
                    @"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",
                    @"wx5525912ec3511b13",@"17578bee42800d5608d3f30e148d9c12",code];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *zoneUrl = [NSURL URLWithString:url];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (data)
            {
                /*
                 {
                 "access_token" = "VZpnWzT9ufPUF2iBUNjKukFViYgrIN1ysMfGJDaC21M2HZHqwB26bNWlz0WyXRKUzxqnXgW1kYo4yyDtdwJEE4Zo-eNQUV56R9wf8degtzQ";
                 "expires_in" = 7200;
                 openid = oKZpQ01Rq75rCbeWnbKwXqdQ8PnE;
                 "refresh_token" = YFMsMI0Kcyh8lO2RuaRAtHNurp1CSjCYXvu4tjraAQi4VfMEXSG1T3A4IgNLZ7kahvRxdP6nM9PQJ1WXpoqoKbwd8qS9285fuPjpNXNP3nI;
                 scope = "snsapi_userinfo";
                 unionid = "oas-J0mszbdm089Jk9gIHhFOankg";
                 }
                 */
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data
                                                                    options:NSJSONReadingMutableContainers error:nil];
                
                NSString *unionid = [dic DWStringForKey:@"unionid"];
                NSString *access_token = [dic DWStringForKey:@"access_token"];
                NSString *openid = [dic DWStringForKey:@"openid"];
                NSString *refresh_token = [dic DWStringForKey:@"refresh_token"];
                
                [self getWechatUserInfoWithAccessToken:access_token openId:openid];
                
                if (unionid.length>0) {
                    [SVProgressHUD dismiss];
                }else{
                }
                
                
            }else{
                
            }
            
        });
    });
}

- (void)getWechatUserInfoWithAccessToken:(NSString *)accessToken openId:(NSString *)openId
{
    NSString *url =[NSString stringWithFormat:
                    @"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",accessToken,openId];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *zoneUrl = [NSURL URLWithString:url];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (data)
            {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data
                                                                    options:NSJSONReadingMutableContainers error:nil];
                
                if ([dic isKindOfClass:[NSDictionary class]]) {
                    NSString *headimgurl = [dic DWStringForKey:@"headimgurl"];
                    NSString *nickname = [dic DWStringForKey:@"nickname"];
                    if (headimgurl.length>0 && nickname.length>0) {
                    }
                }
                
                
            }
        });
        
    });
}

@end
