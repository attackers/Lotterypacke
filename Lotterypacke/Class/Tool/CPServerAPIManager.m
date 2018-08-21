//
//  CPServerAPIManager.m
//  lottery
//
//  Created by wayne on 2017/8/9.
//  Copyright © 2017年 way. All rights reserved.
//

#import "CPServerAPIManager.h"

// FIXME: 修改要链接的服务器接口地址
NSString * const CPSerVerAPINameForAPIMain              = @"https://api.cph8896asdios.com/ios2";



NSString * const CPSerVerAPINameForAPIHall              = @"/api/hall";
NSString * const CPSerVerAPINameForAPIHallSingle        = @"/api/hall/single";
NSString * const CPSerVerAPINameForAPIIndex             = @"/api/index";
NSString * const CPSerVerAPINameForAPILoginSubmit       = @"/api/login/submit";

NSString * const CPSerVerAPINameForAPINoticeNoTip       = @"/api/notice/noTip";

NSString * const CPSerVerAPINameForAPILotteryBonus      = @"/api/lottery/bonus";
NSString * const CPSerVerAPINameForAPILotteryNewBonus      = @"api/lottery/newBonus";


NSString * const CPSerVerAPINameForAPILotteryBigType    = @"/api/lottery/bigType";


NSString * const CPSerVerAPINameForAPIDraw              = @"/api/draw";
NSString * const CPSerVerAPINameForAPIRegistPreInfo     = @"/api/reg/pre";
NSString * const CPSerVerAPINameForAPIKefu              = @"/api/kefu";
NSString * const CPSerVerAPINameForAPIRegLaw            = @"/api/reg/law";
NSString * const CPSerVerAPINameForAPIRegist            = @"/api/reg/submit";
NSString * const CPSerVerAPINameForAPIFreeUserCode      = @"/api/free/userCode";
NSString * const CPSerVerAPINameForAPIFreeUserSubmit    = @"/api/free/submit";
NSString * const CPSerVerAPINameForAPIPasswordVerify    = @"/api/password/verify";
NSString * const CPSerVerAPINameForAPIPasswordReset     = @"/api/password/reset";

//type:0余额+未读消息数 1余额
NSString * const CPSerVerAPINameForAPIUserAmount        = @"/api/user/amount";
NSString * const CPSerVerAPINameForAPIUserSpread        = @"/api/user/spread";
NSString * const CPSerVerAPINameForAPIUserSpreadList    = @"/api/user/spreadList";


NSString * const CPSerVerAPINameForAPIUserCheckin       = @"/api/user/checkin";
NSString * const CPSerVerAPINameForAPIUserCheckinList   = @"/api/user/checkinList";
NSString * const CPSerVerAPINameForAPIUsercheckinSubmit       = @"/api/user/checkinSubmit";

NSString * const CPSerVerAPINameForAPIUserMsg       = @"/api/user/msg";
NSString * const CPSerVerAPINameForAPIUserMsgDetail       = @"/api/user/msgDetail";


NSString * const CPSerVerAPINameForAPIUserBetList       = @"/api/user/betList";
NSString * const CPSerVerAPINameForAPIUserBetDetail       = @"/api/user/betDetail";

NSString * const CPSerVerAPINameForAPIUserAccountList       = @"/api/user/accountList";

NSString * const CPSerVerAPINameForAPIUserRechargeList      = @"/api/user/rechargeList";
NSString * const CPSerVerAPINameForAPIUserRechargeDetail      = @"/api/user/rechargeDetail";


NSString * const CPSerVerAPINameForAPIUserWithdrawList      = @"/api/user/withdrawList";
NSString * const CPSerVerAPINameForAPIUserWithdrawDetail     = @"/api/user/withdrawDetail";

NSString * const CPSerVerAPINameForAPISetting     = @"/api/setting";


NSString * const CPSerVerAPINameForAPISettingLoginPasswd     = @"/api/setting/loginPasswd";
NSString * const CPSerVerAPINameForAPISettingOpenCloseOrg     = @"/api/setting/openCloseOrg";

NSString * const CPSerVerAPINameForAPISettingAboutUs     = @"/api/setting/aboutUs";

NSString * const CPSerVerAPINameForAPILogout     = @"/api/logout";


NSString * const CPSerVerAPINameForAPISettingGetQa     = @"/api/setting/getQa";
NSString * const CPSerVerAPINameForAPISettingQaSubmit     = @"/api/setting/qaSubmit";


NSString * const CPSerVerAPINameForAPISettingIsWithdrawPasswdSet     = @"/api/setting/isWithdrawPasswdSet";
NSString * const CPSerVerAPINameForAPISettingWithdrawPasswd     = @"/api/setting/withdrawPasswd";


NSString * const CPSerVerAPINameForAPISettingGetBank    = @"/api/setting/getBank";
NSString * const CPSerVerAPINameForAPISettingBindBank     = @"/api/setting/bindBank";


NSString * const CPSerVerAPINameForAPITrendTypeList     = @"/api/trend/typeList";


NSString * const CPSerVerAPINameForAPIUserWithdraw     = @"/api/user/withdraw";
NSString * const CPSerVerAPINameForAPIUserWithdrawSubmit     = @"/api/user/withdrawSubmit";

NSString * const CPSerVerAPINameForAPIUserRecharge     = @"/api/user/recharge";

NSString * const CPSerVerAPINameForAPIUserRList     = @"/api/user/rList";

NSString * const CPSerVerAPINameForAPIUserRbankList     = @"/api/user/rbankList";

NSString * const CPSerVerAPINameForAPIUserRonlineList     = @"/api/user/ronlineList";
NSString * const CPSerVerAPINameForAPIUserRqqpayList     = @"/api/user/rqqpayList";
NSString * const CPSerVerAPINameForAPIUserRotherList     = @"/api/user/rotherList";

NSString * const CPSerVerAPINameForAPIUserRwechatList     = @"/api/user/rwechatList";
NSString * const CPSerVerAPINameForAPIUserRalipayList     = @"/api/user/ralipayList";

NSString * const CPSerVerAPINameForAPIUserRbankNext     = @"/api/user/rbankNext";
NSString * const CPSerVerAPINameForAPIUserRbankSubmit     = @"/api/user/rbankSubmit";

NSString * const CPSerVerAPINameForAPIUserRechargeNext     = @"/api/user/recharge/next";
NSString * const CPSerVerAPINameForAPRechargeRNext     = @"/api/recharge/rNext";


NSString * const CPSerVerAPINameForAPIUserRqqpayNext     = @"/api/user/recharge/qqpayNext";
NSString * const CPSerVerAPINameForAPIUserRotherNext     = @"/api/user/recharge/otherNext";

NSString * const CPSerVerAPINameForAPIUserRwechatScanNext     = @"/api/user/rwechatScanNext";
NSString * const CPSerVerAPINameForAPIUserRalipayScanNext     = @"/api/user/ralipayScanNext";

NSString * const CPSerVerAPINameForAPIUserWechatNext     = @"/api/user/recharge/wechatNext";
NSString * const CPSerVerAPINameForAPIUserAlipayNext     = @"/api/user/recharge/alipayNext";


NSString * const CPSerVerAPINameForAPIUserRalipayBankNext     = @"/api/user/ralipayBankNext";
NSString * const CPSerVerAPINameForAPIUserWechatBankNext     = @"/api/user/rwechatBankNext";

NSString * const CPSerVerAPINameForAPIUserRechargeSubmit     = @"/api/recharge/submit";


NSString * const CPSerVerAPINameForAPIUserRalipayBankSubmit     = @"/api/user/ralipayBankSubmit";
NSString * const CPSerVerAPINameForAPIUserWechatBankSubmit     = @"/api/user/rwechatBankSubmit";


NSString * const CPSerVerAPINameForAPIUserRwechatScanSubmit     = @"/api/user/rwechatScanSubmit";
NSString * const CPSerVerAPINameForAPIUserRalipayScanSubmit     = @"/api/user/ralipayScanSubmit";


NSString * const CPSerVerAPINameForAPIBuy               = @"/api/buy";

NSString * const CPSerVerAPINameForAPIBetSubmit         = @"/api/bet/submit";

NSString * const CPSerVerAPINameForAPISendMessageCode       = @"/api/send/messageCode";
NSString * const CPSerVerAPINameForAPISendSubmit            = @"/api/send/submit";


#pragma mark- 代理中心

//代理报表
NSString * const CPSerVerAPINameForAPIAgentAppReport                = @"/api/agentApp/report";
NSString * const CPSerVerAPINameForAPIAgentAppBetDetail             = @"/api/agentApp/betDetail";
NSString * const CPSerVerAPINameForAPIAgentAppTradeDetail           = @"/api/agentApp/tradeDetail";
NSString * const CPSerVerAPINameForAPIAgentAppDownReport            = @"/api/agentApp/downReport";
NSString * const CPSerVerAPINameForAPIAgentAppMemberList            = @"/api/agentApp/memberList";
NSString * const CPSerVerAPINameForAPIAgentAppInviteCodeView        = @"/api/agentApp/inviteCodeView";
NSString * const CPSerVerAPINameForAPIAgentAppInviteDownOpen        = @"/api/agentApp/downOpen";
NSString * const CPSerVerAPINameForAPIAgentAppInviteDelInviteCode   = @"/api/agentApp/delInviteCode";
NSString * const CPSerVerAPINameForAPIAgentAppInviteGenInviteCode   = @"/api/agentApp/genInviteCode";


//ronlineList
//rqqpayList
//rwechatList
//ralipayList


@implementation CPServerAPIManager

@end
