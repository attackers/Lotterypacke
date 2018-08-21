//
//  CPAgentCenterVC.m
//  lottery
//
//  Created by way on 2018/4/16.
//  Copyright © 2018年 way. All rights reserved.
//

#import "CPAgentCenterVC.h"
#import "CPWebViewController.h"
#import "CPAgentCenterRightButtonItem.h"
#import "CPAgentStatementVC.h"
#import "CPJuniorStatementVC.h"
#import "CPJuniorOpenAccount.h"
#import "CPAgentBetRecordVC.h"
#import "CPAgentTradeRecordVC.h"
#import "CPMemberManagerVC.h"
#import "LotteryHeader.h"

@interface CPAgentCenterVC ()<UITableViewDelegate,UITableViewDataSource,CPAgentCenterRightButtonItemActionProtocol>
{
    IBOutlet UITableView *_tableView;
    NSArray *_dataList;
}

@property(nonatomic,retain)CPAgentCenterRightButtonItem *rightItem;

@end

@implementation CPAgentCenterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"代理中心";
    [self buildBarButtonItem];
    
    _dataList = @[@"代理说明",@"下级开户",@"代理报表",@"下级报表",@"会员管理",@"投注明细",@"交易明细"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark- build UI

-(void)buildBarButtonItem
{
    //右上角按钮点击事件
    UIImage *rightItemImage = [UIImage imageNamed:@"top_you_anniu"];
    CPVoiceButton *btn = [CPVoiceButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, rightItemImage.size.width, rightItemImage.size.height);
    [btn addTarget:self action:@selector(showSortViewAction) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:rightItemImage forState:UIControlStateNormal];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    UIBarButtonItem* offsetItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    offsetItem.width = -10;
    self.navigationItem.rightBarButtonItems = @[offsetItem,[[UIBarButtonItem alloc]initWithCustomView:btn]];
    
}

#pragma mark- setter && getter

-(CPAgentCenterRightButtonItem *)rightItem
{
    if (!_rightItem) {
        _rightItem = [CPAgentCenterRightButtonItem createViewFromNib];
        _rightItem.delegate = self;
        [self.view addSubview:_rightItem];
    }
    [self.view bringSubviewToFront:_rightItem];
    return _rightItem;
}

#pragma mark- CPAgentCenterRightButtonItemActionProtocol

-(void)cpAgentCenterButtonItemSortActionByTag:(NSInteger)tag
{
    switch (tag) {
        case 11:
        {
            //首页
            AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [app.maiTabBarController goToHomepageViewController];
            [self.navigationController popToRootViewControllerAnimated:YES];
            
        }break;
        case 12:
        {
            //客服
            //在线客服
            if ([CPGlobalDataManager shareGlobalData].kefuUrlString) {
                [self loadKefuWebView];
            }else{
                [self queryKefuUrlString];
            }
            
        }break;
            
        default:
            break;
    }
}

#pragma mark- buttonAction
//显示右上角视图
-(void)showSortViewAction
{
    self.rightItem.frame = CGRectMake(self.view.width-self.rightItem.width-10, 0, self.rightItem.width, self.rightItem.height);
    self.rightItem.hidden = self.rightItem.hidden?NO:YES;
}

-(void)loadKefuWebView
{
    CPWebViewController *toWebVC = [[CPWebViewController alloc]cpWebWithURLString:[[NSString alloc]initWithString:[CPGlobalDataManager shareGlobalData].kefuUrlString]];
    toWebVC.title = @"客服";
    toWebVC.showPageTitles = NO;
    toWebVC.showActionButton = NO;
    toWebVC.navigationButtonsHidden = YES;
    [self.navigationController pushViewController:toWebVC animated:YES];
}


#pragma mark- tableViewDelegate


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *markString = @"markString";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:markString];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:markString];
        cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
        cell.textLabel.textColor = kCOLOR_R_G_B_A(109, 109, 109, 1);
        cell.detailTextLabel.font = [UIFont systemFontOfSize:12.0f];
        cell.detailTextLabel.textColor = kCOLOR_R_G_B_A(169, 169, 169, 1);
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    NSString *title = _dataList[indexPath.row];
    cell.textLabel.text = title;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [CPGlobalDataManager playButtonClickVoice];
    NSString *title = _dataList[indexPath.row];
    //@[@"代理说明",@"代理报表",@"下级报表",@"下级开户",@"会员管理",@"投注明细",@"交易明细"];
    NSString *urlString = @"";
    if ([title isEqualToString:@"代理说明"]) {
        urlString = [[CPGlobalDataManager shareGlobalData].domainUrlString DWStringByAppendingPathComponent:@"api/agent/desc?isApp=1"];
        
    }else if ([title isEqualToString:@"代理报表"]) {
        urlString = [[CPGlobalDataManager shareGlobalData].domainUrlString DWStringByAppendingPathComponent:@"api/agent/report?isApp=1"];
        CPAgentStatementVC *vc = [CPAgentStatementVC new];
        vc.baseUrlString = urlString;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }else if ([title isEqualToString:@"下级报表"]) {
        
        urlString = [[CPGlobalDataManager shareGlobalData].domainUrlString DWStringByAppendingPathComponent:@"api/agent/downReport?isApp=1"];
        CPJuniorStatementVC *vc = [CPJuniorStatementVC new];
        vc.baseUrlString = urlString;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }else if ([title isEqualToString:@"下级开户"]) {
        urlString = [[CPGlobalDataManager shareGlobalData].domainUrlString DWStringByAppendingPathComponent:@"api/agent/downOpen?isApp=1"];
        CPJuniorOpenAccount *vc = [CPJuniorOpenAccount new];
        vc.baseUrlString = urlString;
        [self.navigationController pushViewController:vc animated:YES];
        return;
        
    }else if ([title isEqualToString:@"会员管理"]) {
        urlString = [[CPGlobalDataManager shareGlobalData].domainUrlString DWStringByAppendingPathComponent:@"api/agent/memberList?isApp=1"];
        CPMemberManagerVC *vc = [CPMemberManagerVC new];
        [self.navigationController pushViewController:vc animated:YES];
        return;

    }else if ([title isEqualToString:@"投注明细"]) {
        urlString = [[CPGlobalDataManager shareGlobalData].domainUrlString DWStringByAppendingPathComponent:@"api/agent/betList?isApp=1"];
        CPAgentBetRecordVC *vc = [CPAgentBetRecordVC new];
        vc.baseUrlString = urlString;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }else if ([title isEqualToString:@"交易明细"]) {
        urlString = [[CPGlobalDataManager shareGlobalData].domainUrlString DWStringByAppendingPathComponent:@"api/agent/accountList?isApp=1"];
        CPAgentTradeRecordVC *vc = [CPAgentTradeRecordVC new];
        vc.baseUrlString = urlString;
        [self.navigationController pushViewController:vc animated:YES];
        return;
        
    }
    
    if (urlString.length>0) {
        CPWebViewController *toWebVC = [[CPWebViewController alloc]cpWebWithURLString:urlString];
        toWebVC.title = title;
        toWebVC.showPageTitles = NO;
        toWebVC.showActionButton = NO;
        toWebVC.navigationButtonsHidden = YES;
        [self.navigationController pushViewController:toWebVC animated:YES];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20.0f;
}

#pragma mark- network

-(void)queryKefuUrlString
{
    [SVProgressHUD way_showLoadingCanNotTouchBlackBackground];
    
    NSMutableDictionary *paramsDic =[[NSMutableDictionary alloc]initWithDictionary:@{@"token":[SUMUser shareUser].token}];
    [paramsDic setObject:@"2" forKey:@"deviceType"];
    NSString *paramsString = [NSString encryptedByGBKAES:[paramsDic JSONString]];
    
    [SUMRequest startWithDomainString:[CPGlobalDataManager shareGlobalData].domainUrlString
                              apiName:CPSerVerAPINameForAPIKefu
                               params:@{@"data":paramsString}
                         rquestMethod:YTKRequestMethodGET
           completionBlockWithSuccess:^(__kindof SUMRequest *request) {
               
               NSString *alertMsg = @"";
               if (request.resultIsOk) {
                   
                   NSString *urlString = [request.resultInfo DWStringForKey:@"data"];
                   [CPGlobalDataManager shareGlobalData].kefuUrlString = urlString;
                   [self loadKefuWebView];
                   
               }else{
                   alertMsg = request.requestDescription;
               }
               [SVProgressHUD way_dismissThenShowInfoWithStatus:alertMsg];
               
               
           } failure:^(__kindof SUMRequest *request) {
               
               [SVProgressHUD way_dismissThenShowInfoWithStatus:@"网络异常"];
           }];
    
}



@end
