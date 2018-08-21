//
//  CPRechargeMainViewController.m
//  lottery
//
//  Created by wayne on 2017/9/8.
//  Copyright © 2017年 way. All rights reserved.
//

#import "CPRechargeMainViewController.h"
#import "CPRechargeBankCell.h"
#import "CPRechargeNormalCell.h"
#import "CPRechargeNetBankCell.h"
#import "CPRechargeAddFriendCell.h"
#import "CPRechargeBankNextStepVC.h"
#import "CPRechargeThirdQRCodeVC.h"
#import "CPRechargeSelfQRCodeVC.h"
#import "CPRechargeAlipayToBankVC.h"
#import "CPRechargePayTypeButton.h"
#import "CPAddFriendRechargeVC.h"
#import "CPRechargeRightMenuView.h"
#import "CPRechargeUtilManager.h"
#import "CPRechargeNormalTitleCell.h"
@interface CPRechargeMainViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    IBOutlet UITableView *_tableView;
    
    IBOutlet UIView *_tableHeaderView;
    IBOutlet UILabel *_memberNameLabel;
    IBOutlet UILabel *_balanceLabel;
    IBOutlet UITextField *_rechargeAmountTf;
    IBOutlet UILabel *_rechargeTipLabel;

    IBOutlet UIView *_bankTopView;
    IBOutlet UILabel *_bankRechargeBankName;
    IBOutlet UILabel *_bankRechargeMemberName;
    
    IBOutlet UILabel *_bankRechargeInfo;
    
    IBOutlet CPVoiceButton *_cleanButton;
    
    IBOutlet UIView *_netBankTopView;
    
    IBOutlet UIView *_tableFooterView;
    
    
    IBOutlet UIScrollView *_payTypeScrollView;
    
    CPRechargePayTypeButton *_markSelectedButton;
    
    NSInteger _selectedPayIndex;
    
    CPRechargeRightMenuView *_rechargeRightMenuView;
    /*
     {
     "bankName": "招商银行",
     "bankAddr": "厦门",
     "accountCode": "12143242",
     "accountName": "测试",
     "payMin": 1,--最小充值金额
     "payMax": 1000,--最大充值金额
     "id": 6
     }

     */
    NSDictionary *_bankPayInfo;
    
    
    /*
     {
        addAmount = 0;
        expand =         
        {
            bankList =             
            {
                (显示值)"\U5de5\U5546\U94f6\U884c" = "ICBC|\U5de5\U5546\U94f6\U884c"（提交值）;
            };
        };
        id = 18;
        maxAmount = 100000;
        minAmount = 10;
        name = "\U667a\U4ed8\U7f51\U94f62001240101";
        payType = 4;
        payUrl = "http://pay.hmtnb.top";
        returnType = 2;
        type = 1;
     },

     */


    /*
     (
         {
             code = bank;
             name = "\U94f6\U884c\U8f6c\U8d26";
         },
         {
             code = wechat;
             name = "\U5fae\U4fe1";
         }
     }
     */
    NSArray *_payTypeList;
    
    
    IBOutlet UIView *_noPayTypeAlertView;
    IBOutlet CPVoiceButton *_nextStepActionButton;
    
    NSInteger _selectedOnlineIndex;
}


@property(nonatomic,assign)NSInteger payMax;
@property(nonatomic,assign)NSInteger payMin;

@property(nonatomic,assign)BOOL showNoSetPayType;

@end

@implementation CPRechargeMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"充值";

    [_tableView registerNib:[UINib nibWithNibName:@"CPRechargeNormalCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([CPRechargeNormalCell class])];
    [_tableView registerNib:[UINib nibWithNibName:@"CPRechargeNormalTitleCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([CPRechargeNormalTitleCell class])];

    if (self.rechargeType == CPRechargeByOnline) {
        _selectedOnlineIndex = 1;
    }
    _nextStepActionButton.layer.cornerRadius = 5.0f;
    _nextStepActionButton.layer.masksToBounds = YES;

    _cleanButton.layer.cornerRadius = 5.0f;
    _cleanButton.layer.masksToBounds = YES;
    
    _cleanButton.enabled = NO;
    [_rechargeAmountTf addTarget:self action:@selector(rechargeAmountTfChange) forControlEvents:UIControlEventEditingChanged];

    //右上角按钮点击事件
    self.navigationItem.rightBarButtonItems = [self theSameRightBarButtonItems];

    [self fillRechargeInfo];
    [self reloadDataAndRefreshDefaultSelectedIndex];

}


/**
 动态监听 - 清除按钮 - 颜色
 */
- (void)rechargeAmountTfChange {
    _cleanButton.enabled = _rechargeAmountTf.text.length ? YES : NO;
    _cleanButton.backgroundColor = _cleanButton.enabled ? RGBA(23, 170, 15, 0.8) : RGBA(227, 227, 227, 1);
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self removeRightItemView];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self removeRightItemView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}

#pragma mark-

-(void)fillRechargeInfo
{
    //填充数据
    
    _memberNameLabel.text = self.memberCode;
    NSString *balanceDes = [NSString stringWithFormat:@"账户余额:%@元",self.memberAmount];
    NSMutableAttributedString *attDes = [[NSMutableAttributedString alloc] initWithString:balanceDes attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:14],NSForegroundColorAttributeName:kCOLOR_R_G_B_A(105, 105, 105, 1)}];
    [attDes addAttributes:@{NSForegroundColorAttributeName:kMainColor} range:[balanceDes rangeOfString:self.memberAmount]];
    
    _balanceLabel.attributedText = attDes;
    _rechargeTipLabel.text = self.rechargeTip;
}

-(void)reloadDataAndRefreshDefaultSelectedIndex
{
    [_tableView reloadData];
}

-(BOOL)verifySubmitInfo
{
    NSDictionary *rechargeInfo = self.charegeTypeInfoList[_selectedPayIndex];
    int subType = [[rechargeInfo DWStringForKey:@"subType"]intValue];
    if (subType == 1) {
        return YES;
    }
    BOOL isConfirm = NO;

    NSDictionary *info = self.charegeTypeInfoList[_selectedPayIndex];
    CGFloat money = [_rechargeAmountTf.text doubleValue];
    if (money<=0) {
        [SVProgressHUD way_showInfoCanTouchAutoDismissWithStatus:@"请输入充值金额"];
        return NO;
    }
    
    CGFloat max = [[info DWStringForKey:@"payMax"]doubleValue];
    CGFloat min = [[info DWStringForKey:@"payMin"]doubleValue];
    if (money<=max && money>=min) {
        return YES;
    }else{
        [SVProgressHUD way_showInfoCanTouchAutoDismissWithStatus:[NSString stringWithFormat:@"此充值方式的充值金额为%.0f ~%.0f元",min,max]];
        return NO;
    }
    
    return isConfirm;
}

#pragma mark- creat UI

-(NSArray *)theSameRightBarButtonItems
{
    UIImage *rightItemImage = [UIImage imageNamed:@"top_you_anniu"];
    CPVoiceButton *btn = [CPVoiceButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, rightItemImage.size.width, rightItemImage.size.height);
    [btn addTarget:self action:@selector(showSortViewAction) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:rightItemImage forState:UIControlStateNormal];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    UIBarButtonItem* offsetItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    offsetItem.width = -10;
    return @[offsetItem,[[UIBarButtonItem alloc]initWithCustomView:btn]];
}

#pragma mark- tableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return _tableHeaderView.height;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return _tableHeaderView;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.rechargeType == CPRechargeByOnline) {
        return _onlineBankInfoList.count+1;
    }
    return self.charegeTypeInfoList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.rechargeType == CPRechargeByOnline && indexPath.row!=0) {
        CPRechargeNormalTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CPRechargeNormalTitleCell class])];
        NSDictionary *info = _onlineBankInfoList[indexPath.row-1];
        BOOL isSelected = (_selectedOnlineIndex == indexPath.row)?YES:NO;
        [cell addBankName:[info DWStringForKey:@"name"] selected:isSelected];
        return cell;
    }
    CPRechargeNormalCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CPRechargeNormalCell class])];
    NSDictionary *info = self.charegeTypeInfoList[indexPath.row];
    BOOL isSelected = (_selectedPayIndex == indexPath.row)?YES:NO;
    NSString *des = [info DWStringForKey:@"desc"];
    NSString *name = [info DWStringForKey:@"title"];
    if (self.rechargeType == CPRechargeByBank) {
        des = [NSString stringWithFormat:@"%@\n%@",[info DWStringForKey:@"title"],[info DWStringForKey:@"desc"]];
        name = [info DWStringForKey:@"name"];
    }
    [cell addBankName:name detailInfo:des logoImgUrlString:self.logoUrlImgString selected:isSelected];
    return cell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [CPGlobalDataManager playButtonClickVoice];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (self.rechargeType == CPRechargeByOnline && indexPath.row!=0) {
        _selectedOnlineIndex = indexPath.row;
    }else{
        _selectedPayIndex = indexPath.row;
    }
    [tableView reloadData];

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.rechargeType == CPRechargeByOnline && indexPath.row!=0) {
        return 44.0f;
    }
    return 65.0f;
}

#pragma mark- network

-(void)queryRechargeInfo
{
    NSMutableDictionary *paramsDic =[[NSMutableDictionary alloc]initWithDictionary:@{@"token":[SUMUser shareUser].token}];
    [paramsDic setObject:@"2" forKey:@"deviceType"];
    [paramsDic setObject:self.rechargeTypeString forKey:@"type"];

    NSString *paramsString = [NSString encryptedByGBKAES:[paramsDic JSONString]];
    [SUMRequest startWithDomainString:[CPGlobalDataManager shareGlobalData].domainUrlString
                              apiName:CPSerVerAPINameForAPIUserRList
                               params:@{@"data":paramsString}
                         rquestMethod:YTKRequestMethodGET
           completionBlockWithSuccess:^(__kindof SUMRequest *request) {
            
               NSString *alertMsg = @"";
               if (request.resultIsOk) {
                   NSDictionary *info = request.businessData;
                   self.memberCode = [info DWStringForKey:@"memberCode"];
                   self.memberAmount = [info DWStringForKey:@"memberAmount"];
                   self.rechargeTip = [request.businessData DWStringForKey:@"rechargeTip"];
                   [self fillRechargeInfo];
               }else{
                   alertMsg = request.requestDescription;
               }
               
               [SVProgressHUD way_dismissThenShowInfoWithStatus:alertMsg];
               
           } failure:^(__kindof SUMRequest *request) {
               
               [SVProgressHUD way_dismissThenShowInfoWithStatus:@"网络异常"];
           }];

}

-(void)queryQrcodeNextStepInfo
{
    [SVProgressHUD way_showLoadingCanNotTouchClearBackground];
    
    NSMutableDictionary *paramsDic =[[NSMutableDictionary alloc]initWithDictionary:@{@"token":[SUMUser shareUser].token}];
    NSDictionary *info = [self.charegeTypeInfoList objectAtIndex:_selectedPayIndex];
    [paramsDic setObject:@"2" forKey:@"deviceType"];
    [paramsDic setObject:_rechargeAmountTf.text forKey:@"amount"];
    [paramsDic setObject:[info DWStringForKey:@"type"] forKey:@"type"];
    [paramsDic setObject:[info DWStringForKey:@"subType"] forKey:@"subType"];
    [paramsDic setObject:[info DWStringForKey:@"id"] forKey:@"payId"];
    
    NSString *paramsString = [NSString encryptedByGBKAES:[paramsDic JSONString]];
    [SUMRequest startWithDomainString:[CPGlobalDataManager shareGlobalData].domainUrlString
                              apiName:CPSerVerAPINameForAPIUserRechargeNext
                               params:@{@"data":paramsString}
                         rquestMethod:YTKRequestMethodGET
           completionBlockWithSuccess:^(__kindof SUMRequest *request) {
               
               NSString *alertMsg = @"";
               if (request.resultIsOk) {
                   NSDictionary *info = request.businessData;
                   if ([[info DWStringForKey:@"needDown"]intValue] == 3) {
                       //跳外部
                       NSString *urlString = [info DWStringForKey:@"payUrl"];
                       [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[urlString URLEncodedString]]];
                   }else{
                       CPRechargeThirdQRCodeVC *vc = [CPRechargeThirdQRCodeVC new];
                       vc.payInfo = info;
                       dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                           vc.navigationItem.rightBarButtonItems = [self theSameRightBarButtonItems];
                       });
                       [self.navigationController pushViewController:vc animated:YES];
                   }
                   
               }else{
                   alertMsg = request.requestDescription;
               }
               
               [SVProgressHUD way_dismissThenShowInfoWithStatus:alertMsg];
               
           } failure:^(__kindof SUMRequest *request) {
               
               [SVProgressHUD way_dismissThenShowInfoWithStatus:@"网络异常"];
           }];
}

-(void)queryNextStepInfo
{
    [SVProgressHUD way_showLoadingCanNotTouchClearBackground];
    
    NSMutableDictionary *paramsDic =[[NSMutableDictionary alloc]initWithDictionary:@{@"token":[SUMUser shareUser].token}];
    NSDictionary *info = [self.charegeTypeInfoList objectAtIndex:_selectedPayIndex];
    [paramsDic setObject:@"2" forKey:@"deviceType"];
    [paramsDic setObject:_rechargeAmountTf.text forKey:@"amount"];
    [paramsDic setObject:[info DWStringForKey:@"type"] forKey:@"type"];
    [paramsDic setObject:[info DWStringForKey:@"subType"] forKey:@"subType"];
    [paramsDic setObject:[info DWStringForKey:@"id"] forKey:@"payId"];
    
    NSString *paramsString = [NSString encryptedByGBKAES:[paramsDic JSONString]];
    [SUMRequest startWithDomainString:[CPGlobalDataManager shareGlobalData].domainUrlString
                              apiName:CPSerVerAPINameForAPRechargeRNext
                               params:@{@"data":paramsString}
                         rquestMethod:YTKRequestMethodGET
           completionBlockWithSuccess:^(__kindof SUMRequest *request) {
               
               NSString *alertMsg = @"";
               if (request.resultIsOk) {
                   //0 银行转账
                   //2 平台扫码
                   //3 转银行卡
                   switch ([[info DWStringForKey:@"subType"] intValue]) {
                       case 0:
                       {
                           NSDictionary *rInfo = request.businessData;
                           CPRechargeBankNextStepVC *vc = [CPRechargeBankNextStepVC new];
                           vc.bankInfo = rInfo;
                           dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                               vc.navigationItem.rightBarButtonItems = [self theSameRightBarButtonItems];
                           });
                           [self.navigationController pushViewController:vc animated:YES];
                           
                       }break;
                       case 2:
                       {
                           NSDictionary *info = request.businessData;
                           CPRechargeSelfQRCodeVC *vc = [CPRechargeSelfQRCodeVC new];
                           vc.rechargeInfo = info;
                           NSUInteger type = self.rechargeType;
                           vc.qrCodeType = type;
                           dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                               vc.navigationItem.rightBarButtonItems = [self theSameRightBarButtonItems];
                           });
                           [self.navigationController pushViewController:vc animated:YES];
                           
                       }break;
                       case 3:
                       {
                           NSDictionary *info = request.businessData;
                           CPRechargeAlipayToBankVC *vc = [CPRechargeAlipayToBankVC new];
                           vc.type = self.rechargeType == CPRechargeByAlipay?0:1;
                           vc.rechargeInfo = info;
                           dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                               vc.navigationItem.rightBarButtonItems = [self theSameRightBarButtonItems];
                           });
                           [self.navigationController pushViewController:vc animated:YES];
                       }break;
                           
                       default:
                           break;
                   }
                   
               }else{
                   alertMsg = request.requestDescription;
               }
               
               [SVProgressHUD way_dismissThenShowInfoWithStatus:alertMsg];
               
           } failure:^(__kindof SUMRequest *request) {
               
               [SVProgressHUD way_dismissThenShowInfoWithStatus:@"网络异常"];
           }];
}





-(void)queryWebChargeOnCPWebViewControllerWithPayUrl:(NSString *)payUrl
                                                type:(NSString *)type
                                             subType:(NSString *)subType
                                               payId:(NSString *)payId
                                              amount:(NSString *)amount
                                            bankName:(NSString *)bankName
{
    NSMutableString *domainString = [[NSMutableString alloc]initWithString:[CPGlobalDataManager shareGlobalData].domainUrlString];
    
    NSString *urlString = [payUrl stringByAppendingString:[NSString stringWithFormat:@"/common/recharge/third?isH5=true&isApp=true&memberId=%@&type=%@&subType=%@&payId=%@&amount=%@%@%@&baseUrl=%@",[SUMUser shareUser].tokenInfo.memberId,type,subType,payId,amount,bankName.length>0?@"&bankName=":@"",bankName.length>0?bankName:@"",domainString]];
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[urlString URLEncodedString]]];
}


#pragma mark- action

-(void)removeRightItemView
{
    if (_rechargeRightMenuView.superview) {
        [_rechargeRightMenuView removeFromSuperview];
        _rechargeRightMenuView = nil;
    }
}

-(void)showSortViewAction
{
    @synchronized(self){
        
        if (_rechargeRightMenuView.superview) {
            [_rechargeRightMenuView removeFromSuperview];
            _rechargeRightMenuView = nil;
            
        }else{
            
            UIViewController *topVc = self.navigationController.topViewController;
            UIView *currentSupview = topVc.view;
            CGFloat originY = [currentSupview convertRect:currentSupview.bounds toView:self.navigationController.view].origin.y;
            _rechargeRightMenuView = [CPRechargeRightMenuView showRightMenuViewOnView:self.navigationController.view originY:originY actionNavigationController:self.navigationController];
        }
        
       
    }
}


- (IBAction)buttonActions:(UIButton *)sender {
    
    switch (sender.tag) {
        case 10:
        {
            //刷新
            [self queryRechargeInfo];
            
        }break;
        case 11:
        {
            //清空充值金额
            _rechargeAmountTf.text = nil;
            [self rechargeAmountTfChange];
        }break;
        case 12:
        {
            //充值100
            NSInteger money = [_rechargeAmountTf.text integerValue];
            money += 100;
            _rechargeAmountTf.text = [NSString stringWithFormat:@"%ld",money];
            [self rechargeAmountTfChange];
        }break;
        case 13:
        {
            //充值500
            NSInteger money = [_rechargeAmountTf.text integerValue];
            money += 500;
            _rechargeAmountTf.text = [NSString stringWithFormat:@"%ld",money];
            [self rechargeAmountTfChange];
        }break;
        case 14:
        {
            //充值一千
            NSInteger money = [_rechargeAmountTf.text integerValue];
            money += 1000;
            _rechargeAmountTf.text = [NSString stringWithFormat:@"%ld",money];
            [self rechargeAmountTfChange];
            
        }break;
        case 15:
        {
            //充值五千
            NSInteger money = [_rechargeAmountTf.text integerValue];
            money += 5000;
            _rechargeAmountTf.text = [NSString stringWithFormat:@"%ld",money];
            [self rechargeAmountTfChange];
            
        }break;
        case 16:
        {
            //充值一万
            NSInteger money = [_rechargeAmountTf.text integerValue];
            money += 10000;
            _rechargeAmountTf.text = [NSString stringWithFormat:@"%ld",money];
            [self rechargeAmountTfChange];
            
        }break;
        case 17:
        {
            //充值五万
            NSInteger money = [_rechargeAmountTf.text integerValue];
            money += 50000;
            _rechargeAmountTf.text = [NSString stringWithFormat:@"%ld",money];
            [self rechargeAmountTfChange];
            
        }break;
        case 23:
        {
            //下一步
            if ([self verifySubmitInfo]) {
                
                //
                NSDictionary *rechargeInfo = self.charegeTypeInfoList[_selectedPayIndex];
                int subType = [[rechargeInfo DWStringForKey:@"subType"]intValue];
                switch (subType) {
                    case 1:
                    {
                        //加好友
                        CPAddFriendRechargeVC *vc = [CPAddFriendRechargeVC new];
                        NSString *title = @"加好友";
                        NSString *accDes = @"账号";
                        NSString *aliasDes = @"昵称";
                        if (self.rechargeType == CPRechargeByAlipay) {
                            title = @"支付宝添加好友";
                            accDes = @"支付宝账号";
                            aliasDes = @"支付宝昵称";
                        }else if(self.rechargeType == CPRechargeByWechat){
                            title = @"微信添加好友";
                            accDes = @"微信账号";
                            aliasDes = @"微信昵称";
                        }
                        vc.title = title;
                        [vc addTitleText:[rechargeInfo DWStringForKey:@"title"] descText:[rechargeInfo DWStringForKey:@"desc"] detailText:[NSString stringWithFormat:@"%@:%@\n%@:%@",accDes,[rechargeInfo DWStringForKey:@"code"],aliasDes,[rechargeInfo DWStringForKey:@"name"]] imageUrlString:[[CPGlobalDataManager shareGlobalData].domainUrlString wayStringByAppendingPathComponent:[rechargeInfo DWStringForKey:@"img"]]];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            vc.navigationItem.rightBarButtonItems = [self theSameRightBarButtonItems];
                        });
                        [self.navigationController pushViewController:vc animated:YES];
                    }break;
                    case 4:
                    {
                        //第三方
                        int returnType = [[rechargeInfo DWStringForKey:@"returnType"]intValue];
                        if (returnType == 1) {
                            //二维码
                            [self queryQrcodeNextStepInfo];
                        }else if (returnType == 2) {
                            
                            //页面
                            NSString *payUrl = [rechargeInfo DWStringForKey:@"payUrl"];
                            NSString *type = [rechargeInfo DWStringForKey:@"type"];
                            NSString *subType = [rechargeInfo DWStringForKey:@"subType"];
                            NSString *payId = [rechargeInfo DWStringForKey:@"id"];
                            NSString *bankName = [rechargeInfo DWStringForKey:@"bankName"];
                            if (self.rechargeType == CPRechargeByOnline) {
                                if (!self.onlineBankInfoList.count || !self.onlineBankInfoList) {
                                    [SVProgressHUD way_dismissThenShowInfoWithStatus:@"请选择银行"];
                                    return;
                                }
                                NSDictionary *bankInfo = self.onlineBankInfoList[_selectedOnlineIndex-1];
                                bankName = [bankInfo DWStringForKey:@"id"];
                            }
                            [self queryWebChargeOnCPWebViewControllerWithPayUrl:payUrl type:type subType:subType payId:payId amount:_rechargeAmountTf.text bankName:bankName];
                        }
                    }break;
                        
                    default:
                    {
                        //0 银行转账
                        //2 平台扫码
                        //3 转银行卡
                        [self queryNextStepInfo];
                        
                    }break;
                        break;
                }
                
            }
        }
    }
    
               
}

@end
