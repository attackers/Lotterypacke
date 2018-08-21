//
//  CPRechargeSelfQRCodeVC.h
//  lottery
//
//  Created by wayne on 2017/9/11.
//  Copyright © 2017年 way. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    CPRechargeQRCodeTypeAliPay          = 2,
    CPRechargeQRCodeTypeWechatPay       = 1,
    CPRechargeQRCodeTypeQQPay           = 7,
    
} CPRechargeQRCodeType;

@interface CPRechargeSelfQRCodeVC : UIViewController

@property(nonatomic,assign)CPRechargeQRCodeType qrCodeType;
@property(nonatomic,strong)NSDictionary *rechargeInfo;

@end
