//
//  CPJuniorOpenAccount.m
//  lottery
//
//  Created by way on 2018/4/17.
//  Copyright © 2018年 way. All rights reserved.
//

#import "CPJuniorOpenAccount.h"
#import "CPSelectedOptionsAgoView.h"
#import "DWITButton.h"
#import "CPWebViewController.h"
#import "CPAgentOddsVC.h"
#import "CPInviteCodeListCell.h"
#import "CPOpenAccountCell.h"

@interface CPJuniorOpenAccount ()<UIWebViewDelegate,UITableViewDelegate,UITableViewDataSource,CPOpenAccountCellValueProtocol>
{
    
    IBOutlet UIWebView *_webView;
    
    IBOutlet UITableView *_tableView;
    
    IBOutlet UIView *_openAccountHeaderView;
    IBOutlet UIButton *_agencyTypeButton;
    IBOutlet UIButton *_playerTypeButton;
    
    IBOutlet DWITButton *_juniorOpenAccountButton;
    IBOutlet DWITButton *_inviteCodeButton;
    
    
    IBOutlet UILabel *_openAccountHeaderMarkLabel;
    
    
    
    IBOutlet UIView *_inviteCodeSectionView;
    
    IBOutlet UIView *_lostPerHeaderView;
    
    IBOutlet UIView *_markInviteCodeFooterView;
    
    IBOutlet UIButton *_makeInviteCodeButton;
    
    
    
    NSInteger _agentType;
    NSArray *_fdList;
    NSArray *_inviteList1;
    NSArray *_inviteList2;
    
    NSDictionary *_currentInviteCodeInfo;
    
    NSMutableDictionary *_markCodeValueInfo;
    NSMutableDictionary *_markValueTextFieldInfo;
    BOOL _isAutoAddValue;
}

@property(nonatomic,assign)NSInteger selectedDateIndex;

@property(nonatomic,assign)int openAccountType;
@property(nonatomic,assign)int inviteCodeType;
@property(nonatomic,retain)NSArray *dataList;

@property(nonatomic,assign)BOOL showOpenAccountView;

@end

@implementation CPJuniorOpenAccount

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"下级开户";
    _agentType = 0;
    _inviteCodeType = 0;
    _openAccountType = 0;
    _showOpenAccountView = YES;
    _makeInviteCodeButton.layer.cornerRadius = 5.0f;
    _markInviteCodeFooterView.layer.masksToBounds = YES;
    
    _isAutoAddValue = YES;
    _markCodeValueInfo = [NSMutableDictionary new];
    _markValueTextFieldInfo = [NSMutableDictionary new];
    
    [_tableView registerNib:[UINib nibWithNibName:@"CPInviteCodeListCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([CPInviteCodeListCell class])];
    [_tableView registerNib:[UINib nibWithNibName:@"CPOpenAccountCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([CPOpenAccountCell class])];

    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self queryDownOpenInfo];
    }];
    
    [_tableView.mj_header beginRefreshing];
//    NSString *urlString = [NSString stringWithFormat:@"%@&dayType=%ld",self.baseUrlString,_selectedDateIndex+1];
//    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *urlString = request.URL.absoluteString;
    if ([urlString rangeOfString:@"agent/fdTable"].length>0) {
        [self queryCodeList];
        return NO;
    }
    return YES;
}

-(void)reloadHeaderView
{
    if (_agentType == 0) {
        _tableView.tableHeaderView = _inviteCodeSectionView;
    }else{
        
        UIView *lastView = _showOpenAccountView?_lostPerHeaderView:_inviteCodeSectionView;
        CGFloat headerViewHeight = lastView.height + _openAccountHeaderView.height;
        UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _tableView.width, headerViewHeight)];
        [headerView addSubview:_openAccountHeaderView];
        [headerView addSubview:lastView];
        _openAccountHeaderView.width = headerView.width;
        lastView.width = headerView.width;
        _tableView.tableHeaderView = headerView;
        lastView.originY = _openAccountHeaderView.bottomY;
//        _tableView.tabl
    }
    [self reloadBottomView];
}

-(void)reloadBottomView
{
    if (_showOpenAccountView) {
        _tableView.tableFooterView = _markInviteCodeFooterView;
    }else{
        _tableView.tableFooterView = nil;
    }
    
}

#pragma mark- setter && getter

-(void)setShowOpenAccountView:(BOOL)showOpenAccountView
{
    _showOpenAccountView = showOpenAccountView;
    _openAccountHeaderMarkLabel.width = self.view.width/2.0f *0.8;
    if (_showOpenAccountView) {
        [UIView animateWithDuration:0.38 animations:^{
            _openAccountHeaderMarkLabel.centerX = _juniorOpenAccountButton.centerX;
        }];
        self.openAccountType = _openAccountType;
    }else{
        [UIView animateWithDuration:0.38 animations:^{
            _openAccountHeaderMarkLabel.centerX = _inviteCodeButton.centerX;
        }];
        self.inviteCodeType = _inviteCodeType;
    }
    
    [self reloadHeaderView];
    [_tableView reloadData];
}

-(void)setOpenAccountType:(int)openAccountType
{
    _openAccountType = openAccountType;
    if (_openAccountType == 0) {
        _agencyTypeButton.selected = YES;
        _playerTypeButton.selected = NO;
    }else{
        _playerTypeButton.selected = YES;
        _agencyTypeButton.selected = NO;
    }
}

-(void)setInviteCodeType:(int)inviteCodeType
{
    _inviteCodeType = inviteCodeType;
    if (_inviteCodeType == 0) {
        _agencyTypeButton.selected = YES;
        _playerTypeButton.selected = NO;

    }else{
        _playerTypeButton.selected = YES;
        _agencyTypeButton.selected = NO;
    }
}

-(NSArray *)dataList
{
    if (_agentType == 0) {
        return _inviteList1;
    }else if (_agentType == 1){
        if (_showOpenAccountView) {
            return _fdList;
            
        }else{
            if (_inviteCodeType == 0) {
                return _inviteList1;
            }else{
                return _inviteList2;
            }
        }
       
    }else{
        return [NSArray new];
    }
}




#pragma mark- CPOpenAccountCellValueProtocol

-(void)cpOpenAccountCellAddValue:(NSString *)value isDdting:(BOOL)edting index:(NSInteger)index textField:(UITextField *)textField
{
    value = value?value:@"";
    if (edting) {
        
        if (_isAutoAddValue) {
            for (int i = 0; i<self.dataList.count; i++) {
                [_markCodeValueInfo setObject:value forKey:@(i)];
            }
            for (UITextField *tf in _markValueTextFieldInfo.allValues) {
                tf.text = value;
            }
        }
    }else{
        [_markCodeValueInfo setObject:value forKey:@(index)];
        _isAutoAddValue = NO;
    }
}

#pragma mark- tableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_agentType != 0 && _showOpenAccountView) {

        CPOpenAccountCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CPOpenAccountCell class])];
        NSString *value = [_markCodeValueInfo DWStringForKey:@(indexPath.row)];
        NSDictionary *info = self.dataList[indexPath.row];
        UITextField *tf = [cell addInfo:info perValue:value delegate:self index:indexPath.row];
        [_markValueTextFieldInfo setObject:tf forKey:@(indexPath.row)];
        return cell;
        
    }else{
        CPInviteCodeListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CPInviteCodeListCell class])];
        [cell addInfo:self.dataList[indexPath.row]];
        return cell;
    }
    return [UITableViewCell new];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_agentType != 0 && _showOpenAccountView) {
        
    }else{
        _currentInviteCodeInfo = self.dataList[indexPath.row];
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *fandianAction = [UIAlertAction actionWithTitle:@"查看返点" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self queryFandianInfoListByInviteId:[_currentInviteCodeInfo DWStringForKey:@"id"]];
        }];
        UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"删除邀请码" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self queryDeleteInfoListByInviteId:[_currentInviteCodeInfo DWStringForKey:@"id"]];

        }];
        UIAlertAction *copyAction = [UIAlertAction actionWithTitle:@"复制邀请码" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = [_currentInviteCodeInfo DWStringForKey:@"inviteCode"];
            [SVProgressHUD way_showInfoCanTouchAutoDismissWithStatus:@"复制成功"];
        }];
        [alertController addAction:cancelAction];
        [alertController addAction:fandianAction];
        [alertController addAction:deleteAction];
        [alertController addAction:copyAction];
        [self presentViewController:alertController animated:YES completion:nil];

        
    }
}

#pragma mark-

- (IBAction)buttonActions:(UIButton *)sender {
    
    switch (sender.tag) {
        case 101:
        {
            //下级开户
            self.showOpenAccountView = YES;
        }break;
        case 102:
        {
            //邀请码
            self.showOpenAccountView = NO;

            
        }break;
        case 103:
        {
            //代理类型
            if (self.showOpenAccountView) {
                self.openAccountType = 0;
            }else{
                self.inviteCodeType = 0;
            }
            if (!_showOpenAccountView) {
                [_tableView reloadData];
                if (self.dataList.count == 0) {
                    [SVProgressHUD way_showInfoCanTouchAutoDismissWithStatus:@"暂时没有相关记录"];
                }
            }
            
        }break;
        case 104:
        {
            //玩家类型
            if (self.showOpenAccountView) {
                self.openAccountType = 1;
            }else{
                self.inviteCodeType = 1;
            }
            if (!_showOpenAccountView) {
                [_tableView reloadData];
                if (self.dataList.count == 0) {
                    [SVProgressHUD way_showInfoCanTouchAutoDismissWithStatus:@"暂时没有相关记录"];
                }
            }
            
        }break;
        case 105:
        {
            //赔率对照表
            [self queryCodeList];
            
        }break;
        case 106:
        {
            //生成邀请码
            [self.view endEditing:YES];
            NSString *alertMsg = @"";
            if ([self verifyMakeCodeIsOk:&alertMsg]) {
                [self queryMake];
            }else{
                [SVProgressHUD way_showInfoCanTouchAutoDismissWithStatus:alertMsg];
            }
            
        }break;
            
        default:
            break;
    }
}

-(BOOL)verifyMakeCodeIsOk:(NSString **)alertMsg
{
    BOOL isOk = YES;
    for (int i = 0; i<_markCodeValueInfo.allKeys.count; i++) {
        NSInteger keyIndex = [_markCodeValueInfo.allKeys[i] integerValue];
        NSString *value = [_markCodeValueInfo DWStringForKey:@(keyIndex)];
        if (value.length == 0) {
            NSDictionary *info = self.dataList[keyIndex];
            NSString *name = [info DWStringForKey:@"name"];
            *alertMsg = [NSString stringWithFormat:@"%@赔率不能为空",name];
            return NO;
        }
    }
    return isOk;
}

#pragma mark- network

-(void)queryDownOpenInfo
{
    

    NSMutableDictionary *paramsDic =[[NSMutableDictionary alloc]initWithDictionary:@{@"token":[SUMUser shareUser].token}];
    [paramsDic setObject:@"2" forKey:@"deviceType"];
    
    NSString *paramsString = [NSString encryptedByGBKAES:[paramsDic JSONString]];
    [SUMRequest startWithDomainString:[CPGlobalDataManager shareGlobalData].domainUrlString
                              apiName:CPSerVerAPINameForAPIAgentAppInviteDownOpen
                               params:@{@"data":paramsString}
                         rquestMethod:YTKRequestMethodGET
           completionBlockWithSuccess:^(__kindof SUMRequest *request) {
               
               if (_tableView.mj_header.isRefreshing) {
                   [_tableView.mj_header endRefreshing];
               }
               NSString *alertMsg = @"";
               if (request.resultIsOk) {
                   
                   NSDictionary *dataInfo = [request.resultInfo DWDictionaryForKey:@"data"];
                   _agentType = [[dataInfo DWStringForKey:@"agentType"]integerValue];
                   _fdList = [dataInfo DWArrayForKey:@"fdList"];
                   _inviteList1 = [dataInfo DWArrayForKey:@"inviteList1"];
                   _inviteList2 = [dataInfo DWArrayForKey:@"inviteList2"];
                   self.showOpenAccountView = _agentType==0?NO:YES;
                   [_tableView reloadData];
                   /*
                    agentType = 1;
                    fdList =         (
                    {
                    code = e11x5;
                    fd = 10;
                    name = "11\U90095";
                    },
                    )
                    inviteList1代理邀请码
                    inviteList1 =         (
                    {
                    addTime = "May 29, 2018 5:12:46 PM";
                    id = 49;
                    inviteCode = 963249;
                    status = 0;
                    },
                    )
                    
                    inviteList2玩家邀请码

                    */
                   
               }else{
                   alertMsg = request.requestDescription;
               }
               
               [SVProgressHUD way_dismissThenShowInfoWithStatus:alertMsg];
               
           } failure:^(__kindof SUMRequest *request) {
               
               if (_tableView.mj_header.isRefreshing) {
                   [_tableView.mj_header endRefreshing];
               }
               [SVProgressHUD way_showInfoCanTouchAutoDismissWithStatus:@"网络异常"];
               
           }];
}

-(void)queryDeleteInfoListByInviteId:(NSString *)inviteId
{
    [SVProgressHUD way_showLoadingCanNotTouchClearBackground];
    NSMutableDictionary *paramsDic =[[NSMutableDictionary alloc]initWithDictionary:@{@"token":[SUMUser shareUser].token}];
    [paramsDic setObject:@"2" forKey:@"deviceType"];
    [paramsDic setObject:inviteId forKey:@"inviteId"];
    
    NSString *paramsString = [NSString encryptedByGBKAES:[paramsDic JSONString]];
    [SUMRequest startWithDomainString:[CPGlobalDataManager shareGlobalData].domainUrlString
                              apiName:CPSerVerAPINameForAPIAgentAppInviteDelInviteCode
                               params:@{@"data":paramsString}
                         rquestMethod:YTKRequestMethodGET
           completionBlockWithSuccess:^(__kindof SUMRequest *request) {
               
               NSString *alertMsg = @"";
               if (request.resultIsOk) {
                   
                   NSDictionary *dataInfo = [request.resultInfo DWDictionaryForKey:@"data"];
                   _inviteList1 = [dataInfo DWArrayForKey:@"inviteList1"];
                   _inviteList2 = [dataInfo DWArrayForKey:@"inviteList2"];
                   
                   [self reloadHeaderView];
                   [_tableView reloadData];

               }else{
                   alertMsg = request.requestDescription;
               }
               
               [SVProgressHUD way_dismissThenShowInfoWithStatus:alertMsg];
               
           } failure:^(__kindof SUMRequest *request) {
               
               [SVProgressHUD way_showInfoCanTouchAutoDismissWithStatus:@"网络异常"];
           }];
}

-(void)queryMake
{
    [SVProgressHUD way_showLoadingCanNotTouchClearBackground];
    NSMutableDictionary *paramsDic =[[NSMutableDictionary alloc]initWithDictionary:@{@"token":[SUMUser shareUser].token}];
    [paramsDic setObject:@"2" forKey:@"deviceType"];
    [paramsDic setObject:_openAccountType==0?@"1":@"2" forKey:@"type"];
    
    for (int i = 0; i<_markCodeValueInfo.allKeys.count; i++) {
        NSInteger keyIndex = [_markCodeValueInfo.allKeys[i] integerValue];
        NSString *value = [_markCodeValueInfo DWStringForKey:@(keyIndex)];
        NSDictionary *info = self.dataList[keyIndex];
        [paramsDic setObject:value forKey:[info DWStringForKey:@"code"]];
    }
    
    NSString *paramsString = [NSString encryptedByGBKAES:[paramsDic JSONString]];
    [SUMRequest startWithDomainString:[CPGlobalDataManager shareGlobalData].domainUrlString
                              apiName:CPSerVerAPINameForAPIAgentAppInviteGenInviteCode
                               params:@{@"data":paramsString}
                         rquestMethod:YTKRequestMethodGET
           completionBlockWithSuccess:^(__kindof SUMRequest *request) {
               
               NSString *alertMsg = @"";
               if (request.resultIsOk) {
                   
                   NSDictionary *dataInfo = [request.resultInfo DWDictionaryForKey:@"data"];
                   _inviteList1 = [dataInfo DWArrayForKey:@"inviteList1"];
                   _inviteList2 = [dataInfo DWArrayForKey:@"inviteList2"];
                   
                   _isAutoAddValue = YES;
                   _inviteCodeType = _openAccountType;
                   self.showOpenAccountView = NO;
                   
               }else{
                   alertMsg = request.requestDescription;
               }
               
               [SVProgressHUD way_dismissThenShowInfoWithStatus:alertMsg];
               
           } failure:^(__kindof SUMRequest *request) {
               
               [SVProgressHUD way_showInfoCanTouchAutoDismissWithStatus:@"网络异常"];
           }];
}

-(void)queryFandianInfoListByInviteId:(NSString *)inviteId
{
    [SVProgressHUD way_showLoadingCanNotTouchClearBackground];
    NSMutableDictionary *paramsDic =[[NSMutableDictionary alloc]initWithDictionary:@{@"token":[SUMUser shareUser].token}];
    [paramsDic setObject:@"2" forKey:@"deviceType"];
    [paramsDic setObject:inviteId forKey:@"inviteId"];
    
    NSString *paramsString = [NSString encryptedByGBKAES:[paramsDic JSONString]];
    [SUMRequest startWithDomainString:[CPGlobalDataManager shareGlobalData].domainUrlString
                              apiName:CPSerVerAPINameForAPIAgentAppInviteCodeView
                               params:@{@"data":paramsString}
                         rquestMethod:YTKRequestMethodGET
           completionBlockWithSuccess:^(__kindof SUMRequest *request) {
               
               NSString *alertMsg = @"";
               if (request.resultIsOk) {
                   
                   NSArray *dataList = [request.resultInfo DWArrayForKey:@"data"];
                   
                   /*
                    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
                    [CPSelectedOptionsAgoView showWithOnView:app.window title:@"返点详情" options:nil selectedIndex:-1 selected:^(NSInteger index) {
                    
                    }];
                    data =     (
                    {
                    code = e11x5;
                    fd = 10;
                    name = "11\U90095";
                    }
                    )
                    */
                   if (dataList.count>0) {
                       
                       NSMutableArray *leftContentList = [NSMutableArray new];
                       NSMutableArray *rightContentList = [NSMutableArray new];
                       for (int i = 0; i<dataList.count; i++) {
                           NSDictionary *info = dataList[i];
                           NSString *leftValue = [info DWStringForKey:@"name"];
                           NSString *rightValue = [info DWStringForKey:@"fd"];
                           [leftContentList addObject:leftValue];
                           [rightContentList addObject:rightValue];
                       }
                       
                       AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
                       [CPSelectedOptionsAgoView showFanDianListWithOnView:app.window title:@"返点详情" LeftContentList:leftContentList rightContentList:rightContentList];
                       
                   }else{
                       alertMsg = @"暂无相关记录";
                   }
                   
               }else{
                   alertMsg = request.requestDescription;
               }
               
               [SVProgressHUD way_dismissThenShowInfoWithStatus:alertMsg];
               
           } failure:^(__kindof SUMRequest *request) {
               
               [SVProgressHUD way_showInfoCanTouchAutoDismissWithStatus:@"网络异常"];
           }];
}


-(void)queryCodeList
{
    [SVProgressHUD way_showLoadingCanNotTouchBlackBackground];
    
    NSMutableDictionary *paramsDic =[[NSMutableDictionary alloc]initWithDictionary:@{@"token":[SUMUser shareUser].token}];
    [paramsDic setObject:@"2" forKey:@"deviceType"];
    NSString *paramsString = [NSString encryptedByGBKAES:[paramsDic JSONString]];
    
    [SUMRequest startWithDomainString:[CPGlobalDataManager shareGlobalData].domainUrlString
                              apiName:CPSerVerAPINameForAPILotteryBigType
                               params:@{@"data":paramsString}
                         rquestMethod:YTKRequestMethodGET
           completionBlockWithSuccess:^(__kindof SUMRequest *request) {
               
               NSString *alertMsg = @"";
               if (request.resultIsOk) {
                   
                   NSString *urlString = [[CPGlobalDataManager shareGlobalData].domainUrlString stringByAppendingPathComponent:@"api/agent/fdTable?isApp=1"];
                   CPAgentOddsVC *vc = [CPAgentOddsVC new];
                   vc.baseUrlString = urlString;
                   vc.ltyInfoList = request.businessDataArray;
                   [self.navigationController pushViewController:vc animated:YES];
                   
               }else{
                   alertMsg = request.requestDescription;
               }
               [SVProgressHUD way_dismissThenShowInfoWithStatus:alertMsg];
               
           } failure:^(__kindof SUMRequest *request) {
               
               [SVProgressHUD way_dismissThenShowInfoWithStatus:@"网络异常"];
           }];
}

@end
