//
//  CPRechargeTypeListVC.m
//  lottery
//
//  Created by way on 2018/3/13.
//  Copyright © 2018年 way. All rights reserved.
//

#import "CPRechargeTypeListVC.h"
#import "CPRechargeTypeListCell.h"
#import "CPRechargeMainViewController.h"


@interface CPRechargeTypeListVC ()<UITableViewDelegate,UITableViewDataSource>
{
    IBOutlet UITableView *_tableView;
    NSArray *_rechargeTypeList;
}
@end

@implementation CPRechargeTypeListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"充值";
    [_tableView registerNib:[UINib nibWithNibName:@"CPRechargeTypeListCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([CPRechargeTypeListCell class])];
    
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self queryRechargeInfo];
    }];
    _tableView.mj_header.backgroundColor = [UIColor clearColor]; //kCOLOR_R_G_B_A(245, 245, 245, 1);
    [_tableView.mj_header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
    
#pragma mark-

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = kCOLOR_R_G_B_A(245, 245, 245, 1);
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65.0f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CPRechargeTypeListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CPRechargeTypeListCell class])];
    NSDictionary *rechargeInfo = [_rechargeTypeList objectAtIndex:indexPath.row];
    NSString *urlString = [[CPGlobalDataManager shareGlobalData].domainUrlString stringByAppendingPathComponent:[rechargeInfo DWStringForKey:@"image"]];
    [cell addPictureImage:urlString title:[rechargeInfo DWStringForKey:@"name"] content:[rechargeInfo DWStringForKey:@"desc"]];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _rechargeTypeList.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *rechargeInfo = [_rechargeTypeList objectAtIndex:indexPath.row];
    NSString *code = [rechargeInfo DWStringForKey:@"code"];
    NSString *urlString = [[CPGlobalDataManager shareGlobalData].domainUrlString stringByAppendingPathComponent:[rechargeInfo DWStringForKey:@"image"]];
    [self queryDetailChargeInfoListByCode:code logoImageUrlString:urlString];
}

#pragma mark-

-(void)queryRechargeInfo
{
    NSMutableDictionary *paramsDic =[[NSMutableDictionary alloc]initWithDictionary:@{@"token":[SUMUser shareUser].token}];
    [paramsDic setObject:@"2" forKey:@"deviceType"];
    
    NSString *paramsString = [NSString encryptedByGBKAES:[paramsDic JSONString]];
    [SUMRequest startWithDomainString:[CPGlobalDataManager shareGlobalData].domainUrlString
                              apiName:CPSerVerAPINameForAPIUserRecharge
                               params:@{@"data":paramsString}
                         rquestMethod:YTKRequestMethodGET
           completionBlockWithSuccess:^(__kindof SUMRequest *request) {
               
               if (_tableView.mj_header.isRefreshing) {
                   [_tableView.mj_header endRefreshing];
               }
               NSString *alertMsg = @"";
               if (request.resultIsOk) {
                   _rechargeTypeList = request.businessDataArray;
                   [_tableView reloadData];
                   
               }else{
                   alertMsg = request.requestDescription;
               }
               
               [SVProgressHUD way_dismissThenShowInfoWithStatus:alertMsg];
               
           } failure:^(__kindof SUMRequest *request) {
               
               if (_tableView.mj_header.isRefreshing) {
                   [_tableView.mj_header endRefreshing];
               }
               [SVProgressHUD way_dismissThenShowInfoWithStatus:@"网络异常"];
           }];
    
}

-(void)queryDetailChargeInfoListByCode:(NSString *)code
                    logoImageUrlString:(NSString *)logoImageUrlString
{
    [SVProgressHUD way_showLoadingCanNotTouchClearBackground];
    
    NSMutableDictionary *paramsDic =[[NSMutableDictionary alloc]initWithDictionary:@{@"token":[SUMUser shareUser].token}];
    [paramsDic setObject:@"2" forKey:@"deviceType"];
    [paramsDic setObject:code forKey:@"type"];
    NSString *paramsString = [NSString encryptedByGBKAES:[paramsDic JSONString]];
    [SUMRequest startWithDomainString:[CPGlobalDataManager shareGlobalData].domainUrlString
                              apiName:CPSerVerAPINameForAPIUserRList
                               params:@{@"data":paramsString}
                         rquestMethod:YTKRequestMethodGET
           completionBlockWithSuccess:^(__kindof SUMRequest *request) {
               
               NSString *alertMsg = @"";
               if (request.resultIsOk) {
                   
                   NSArray *typeList = [request.businessData DWArrayForKey:@"typeList"];
                   if (typeList.count>0) {
                       CPRechargeMainViewController *vc = [CPRechargeMainViewController new];
                       vc.charegeTypeInfoList = typeList;
                       vc.memberAmount = [request.businessData DWStringForKey:@"memberAmount"];
                       vc.memberCode = [request.businessData DWStringForKey:@"memberCode"];
                       vc.rechargeTip = [request.businessData DWStringForKey:@"rechargeTip"];
                       vc.logoUrlImgString = logoImageUrlString;
                       vc.rechargeTypeString = code;
                       NSDictionary *info = typeList[0];
                       CPRechargeType type = [[info DWStringForKey:@"type"]integerValue];
                       
                       switch (type) {
                           case CPRechargeByBank:
                           {
                               vc.rechargeType = CPRechargeByBank;
                           }break;
                           case CPRechargeByWechat:
                           {
                               vc.rechargeType = CPRechargeByWechat;
                           }break;
                           case CPRechargeByAlipay:
                           {
                               vc.rechargeType = CPRechargeByAlipay;
                           }break;
                           case CPRechargeByOnline:
                           {
                               vc.rechargeType = CPRechargeByOnline;
                               vc.onlineBankInfoList = [request.businessData DWArrayForKey:@"bankList"];

                           }break;
                           case CPRechargeByQQPay:
                           {
                               vc.rechargeType = CPRechargeByQQPay;
                           }break;
                           default:
                           {
                               vc.rechargeType = CPRechargeByOther;
                           }break;
                       }
                       [self.navigationController pushViewController:vc animated:YES];

                   }else{
                       alertMsg = @"此充值方式暂不可用，请选择其他充值方式";
                   }
                   
               }else{
                   alertMsg = request.requestDescription;
               }
               [SVProgressHUD way_dismissThenShowInfoWithStatus:alertMsg];
               
           } failure:^(__kindof SUMRequest *request) {
               
               [SVProgressHUD way_dismissThenShowInfoWithStatus:@"网络异常"];
           }];
}

@end
