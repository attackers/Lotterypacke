//
//  CPRechargeHeader.h
//  lottery
//
//  Created by wayne on 2017/9/8.
//  Copyright © 2017年 way. All rights reserved.
//

#ifndef CPRechargeHeader_h
#define CPRechargeHeader_h

typedef enum : NSUInteger {
    
    CPRechargeByBank        =0,
    CPRechargeByWechat      =1,
    CPRechargeByAlipay      =2,
    CPRechargeByQQPay       =7,
    CPRechargeByOnline      =4,
    CPRechargeByOther       =99,
} CPRechargeType;


#endif /* CPRechargeHeader_h */
