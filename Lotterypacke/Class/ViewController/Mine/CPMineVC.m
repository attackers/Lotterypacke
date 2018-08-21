//
//  CPMineVC.m
//  lottery
//
//  Created by wayne on 17/1/19.
//  Copyright © 2017年 way. All rights reserved.
//

#import "CPMineVC.h"
#import "CPMineActionModel.h"

#import "CPMyRecommendVC.h"
#import "CPSignVC.h"
#import "CPSignRecordVC.h"
#import "CPPersonalMessageVC.h"
#import "CPBetRecordVC.h"
#import "CPAccountRecordVC.h"
#import "CPRechargeRecordVC.h"
#import "CPWithdrawRecordVC.h"
#import "CPSettingVC.h"
#import "CPBusinessControllerManager.h"
#import "CPRechargeTypeListVC.h"
#import "CPAgentCenterVC.h"
#import "DWITButton.h"


@interface CPMineVC ()<UITableViewDelegate,UITableViewDataSource>
{
    
    IBOutlet UIView *_tableHeaderView;
    IBOutlet UITableView *_tableView;
    
    IBOutlet UILabel *_nameLabel;
    IBOutlet UILabel *_balanceLabel;
    IBOutlet UIView *_itemView;
    
    IBOutlet UIView *_rechargeView;
    IBOutlet UIView *_withdrawView;
    IBOutlet UIView *_signView;
    NSArray *_modelList;
    IBOutlet UIButton *_kefuButton;
    
    IBOutlet UIButton *_refreshBalanceButton;
    IBOutlet UIView *_balanceView;
}

@property(nonatomic,copy)NSString *balance;
@property(nonatomic,assign)int unReadCount;
@property(nonatomic,retain)UILabel *unreadCountLabel;
@property(nonatomic,assign)BOOL isShowHongbao;
@end

@implementation CPMineVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"个人中心";

    UIButton *btnRight = [UIButton buttonWithType:UIButtonTypeCustom];
    btnRight.frame = CGRectMake(0, 0, 44, 44);
    [btnRight setImage:[UIImage imageNamed:@"setting"] forState:UIControlStateNormal];
    [btnRight setImageEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 0)];
    [btnRight addTarget:self action:@selector(settingAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnRight];
//    320/184
    
//    _tableHeaderView.size = CGSizeMake(kScreenWidth, kScreenWidth*175/320);
    _isShowHongbao = NO;
    
    [self reloadDataList];
    [self reloadTopItem];

    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];

    _tableView.tableHeaderView = _tableHeaderView;
    _tableView.tableFooterView = [UIView new];
    
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self queryMineInfo];
    }];
    [_tableView.mj_header beginRefreshing];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!_tableView.mj_header.isRefreshing) {
        [self queryMineInfo];
    }
    _nameLabel.text = [SUMUser shareUser].tokenInfo.memberName;
}

-(void)settingAction
{
    [CPGlobalDataManager playButtonClickVoice];
    CPSettingVC *vc = [[CPSettingVC alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self reloadDataList];
    [self reloadTopItem];
}

-(void)reloadTopItem
{
    NSInteger count = [SUMUser shareUser].isShowDailiItem?5:4;
    NSArray *imgs = @[@"mine_recharge",@"mine_withdraw",@"mine_sign",@"mine_service"];
    NSArray *titles = @[@"充值",@"提现",@"签到",@"客服"];
    NSArray *tags = @[@"21",@"22",@"23",@"24"];
    if (count == 5) {
        imgs = @[@"mine_recharge",@"mine_withdraw",@"mine_xiaxian",@"mine_sign",@"mine_service"];
        titles = @[@"充值",@"提现",@"发展下线",@"签到",@"客服"];
        tags = @[@"21",@"22",@"25",@"23",@"24"];
    }
    
    for (UIView *subview in _itemView.subviews) {
        if ([subview isKindOfClass:[DWITButton class]]) {
            [subview removeFromSuperview];
        }
    }
    
    CGFloat width = kScreenWidth/count;
    for (int i = 0; i<count; i++) {
        
        NSString *title = titles[i];
        NSString *img = imgs[i];
        NSInteger tag = [tags[i] integerValue];
        
        DWITButton *btn = [DWITButton buttonWithType:UIButtonTypeCustom];
        btn.tiGap = 10.0f;
        btn.layoutType = 3;
        [btn addTarget:self action:@selector(buttonActions:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setTitleColor:kCOLOR_R_G_B_A(202, 42, 36, 1) forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:13.0f];
        [btn setImage:[UIImage imageNamed:img] forState:UIControlStateNormal];
        btn.tag = tag;
        btn.frame = CGRectMake(i*width, 0, width, _itemView.height);
        if (tag == 25) {
            btn.frame = CGRectMake(i*width-width*0.5, 0, width*2, _itemView.height);
        }
        [_itemView addSubview:btn];
        if ([btn.currentTitle isEqualToString:@"发展下线"]) {
            [_itemView insertSubview:btn atIndex:0];
        }
    }
    
}

-(void)reloadDataList
{
    _modelList = @[
                   [CPMineActionModel modelName:@"系统公告" icon:@"geren_tubiao_06_goucai_mine" identify:2],
                   [CPMineActionModel modelName:@"投注记录" icon:@"geren_tubiao_13_goucai_mine" identify:3],
                   [CPMineActionModel modelName:@"中奖记录" icon:@"geren_tubiao_24_goucai_mine" identify:4],
                   [CPMineActionModel modelName:@"账户明细" icon:@"geren_tubiao_26_goucai_mine" identify:5],
                   [CPMineActionModel modelName:@"充值记录" icon:@"geren_tubiao_04_goucai_mine" identify:6],
                   [CPMineActionModel modelName:@"提款记录" icon:@"geren_tubiao_13_goucai_mine" identify:7],
                   [CPMineActionModel modelName:@"签到记录" icon:@"user_qiandao" identify:8],
                   [CPMineActionModel modelName:@"个人消息" icon:@"geren_tubiao_06_goucai_mine" identify:9]
                   ];
    
    if (self.isShowHongbao) {
        NSMutableArray *list = [[NSMutableArray alloc]initWithArray:_modelList];
        [list insertObject:[CPMineActionModel modelName:@"我的红包" icon:@"geren_tubiao_hb_goucai_mine" identify:10] atIndex:list.count-1];
        _modelList = list;
    }
    [_tableView reloadData];
}

#pragma mark- business method

-(void)loadKefuWebView
{
    CPWebViewController *toWebVC = [[CPWebViewController alloc]cpWebWithURLString:[[NSString alloc]initWithString:[CPGlobalDataManager shareGlobalData].kefuUrlString]];
    toWebVC.title = @"客服";
    toWebVC.showPageTitles = NO;
    toWebVC.showActionButton = NO;
    toWebVC.navigationButtonsHidden = YES;
    toWebVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:toWebVC animated:YES];
}

#pragma mark- setter && getter

-(void)setIsShowHongbao:(BOOL)isShowHongbao
{
    _isShowHongbao = isShowHongbao;
    [self reloadDataList];
}

-(void)setBalance:(NSString *)balance
{
    _balance = balance?balance:@"";
    _balanceLabel.text = [NSString stringWithFormat:@"%@",[_balance jdM]];
    CGFloat balanceWidth = [_balanceLabel.text suitableFromMaxSize:CGSizeMake(_tableHeaderView.width-_balanceLabel.originX-5-_refreshBalanceButton.width, _balanceLabel.height) font:_balanceLabel.font].width;
    _balanceLabel.width = balanceWidth;
    
    _refreshBalanceButton.originX = _balanceLabel.rightX +5;
}

-(void)setUnReadCount:(int)unReadCount
{
    _unReadCount = unReadCount;
    if (_unReadCount>0) {
        self.unreadCountLabel.hidden = NO;
    }else{
        self.unreadCountLabel.hidden = YES;
    }
    [_tableView reloadData];
}

-(UILabel *)unreadCountLabel
{
    if (!_unreadCountLabel) {
        CGFloat width = 10;
        _unreadCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(_tableView.width - 50, (44-width)/2.0f, width, width)];
        _unreadCountLabel.textColor = [UIColor whiteColor];
        _unreadCountLabel.backgroundColor = kMainColor;
        _unreadCountLabel.textAlignment = NSTextAlignmentCenter;
        _unreadCountLabel.font = [UIFont systemFontOfSize:13.0f];
        _unreadCountLabel.layer.cornerRadius = _unreadCountLabel.width/2.0f;
        _unreadCountLabel.layer.masksToBounds = YES;
        _unreadCountLabel.tag = 999;
        _unreadCountLabel.hidden = YES;

    }
    return _unreadCountLabel;
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


-(void)queryMineInfo
{
    NSMutableDictionary *paramsDic =[[NSMutableDictionary alloc]initWithDictionary:@{@"type":@"0"}];

    [paramsDic setObject:[SUMUser shareUser].token forKey:@"token"];
    [paramsDic setObject:@"2" forKey:@"deviceType"];

    NSString *paramsString = [NSString encryptedByGBKAES:[paramsDic JSONString]];
    [SUMRequest startWithDomainString:[CPGlobalDataManager shareGlobalData].domainUrlString
                              apiName:CPSerVerAPINameForAPIUserAmount
                               params:@{@"data":paramsString}
                         rquestMethod:YTKRequestMethodGET
           completionBlockWithSuccess:^(__kindof SUMRequest *request) {
               
               if (_tableView.mj_header.isRefreshing) {
                   [_tableView.mj_header endRefreshing];
               }
               if (request.resultIsOk) {
                   NSDictionary *dataInfo = [request.resultInfo DWDictionaryForKey:@"data"];
                   self.balance = [dataInfo DWStringForKey:@"balance"];
                   self.unReadCount = [[dataInfo DWStringForKey:@"unReadCount"]intValue];
                   self.isShowHongbao = [[dataInfo DWStringForKey:@"hongBao"]intValue]==1?YES:NO;
                
               }else{
                   [SVProgressHUD way_showInfoCanTouchAutoDismissWithStatus:request.requestDescription];
               }
               
               
           } failure:^(__kindof SUMRequest *request) {
               
               if (_tableView.mj_header.isRefreshing) {
                   [_tableView.mj_header endRefreshing];
               }
               [SVProgressHUD way_showInfoCanTouchAutoDismissWithStatus:@"网络异常"];
           }];
}

-(void)queryBalanceInfo
{
    NSMutableDictionary *paramsDic =[[NSMutableDictionary alloc]initWithDictionary:@{@"type":@"0"}];
    [paramsDic setObject:@"2" forKey:@"deviceType"];
    [paramsDic setObject:[SUMUser shareUser].token forKey:@"token"];
    
    NSString *paramsString = [NSString encryptedByGBKAES:[paramsDic JSONString]];
    [SUMRequest startWithDomainString:[CPGlobalDataManager shareGlobalData].domainUrlString
                              apiName:CPSerVerAPINameForAPIUserAmount
                               params:@{@"data":paramsString}
                         rquestMethod:YTKRequestMethodGET
           completionBlockWithSuccess:^(__kindof SUMRequest *request) {
               
               if (request.resultIsOk) {
                   
                   NSDictionary *dataInfo = [request.resultInfo DWDictionaryForKey:@"data"];
                   self.balance = [dataInfo DWStringForKey:@"balance"];
                   self.unReadCount = [[dataInfo DWStringForKey:@"unReadCount"]intValue];
               }
           } failure:^(__kindof SUMRequest *request) {
            
           }];
}

#pragma mark- tableViewDelegate

//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 0.01f;
//}
//
//-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 0.01f;
//}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _modelList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CPMineActionModel *model = [_modelList objectAtIndex:indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
    cell.textLabel.text = model.name;
    cell.imageView.image = [UIImage imageNamed:model.icon];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.font = [UIFont systemFontOfSize:16.0f];
    if ([model.name isEqualToString:@"个人消息"]) {
        [cell.contentView addSubview:self.unreadCountLabel];
        if (self.unReadCount>0) {
            cell.textLabel.text = [NSString stringWithFormat:@"%@(%d)",model.name,self.unReadCount];
        }else{
            cell.textLabel.text = model.name;
        }
    }else{
        UIView *subView = [cell.contentView viewWithTag:999];
        if (subView) {
            [subView removeFromSuperview];
        }
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [CPGlobalDataManager playButtonClickVoice];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CPMineActionModel *model = [_modelList objectAtIndex:indexPath.row];
    switch (model.identify) {
        case 1:
        {
            
        }break;
        case 2:
        {
            //系统公告
            NSString *urlString = [[CPGlobalDataManager shareGlobalData].domainUrlString wayStringByAppendingPathComponent:@"/api/systemNotice"];
            CPWebViewController *toWebVC = [[CPWebViewController alloc]cpWebWithURLString:urlString];
            toWebVC.title = @"公告";
            toWebVC.showPageTitles = NO;
            toWebVC.showActionButton = NO;
            toWebVC.navigationButtonsHidden = YES;
            toWebVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:toWebVC animated:YES];
            
        }break;
        case 3:
        {
            //投注记录
            CPBetRecordVC *vc = [CPBetRecordVC new];
            vc.hidesBottomBarWhenPushed = YES;
            vc.onlyShowWinRecord = NO;
            [self.navigationController pushViewController:vc animated:YES];
            
        }break;
        case 4:
        {
            //中奖记录
            CPBetRecordVC *vc = [CPBetRecordVC new];
            vc.hidesBottomBarWhenPushed = YES;
            vc.onlyShowWinRecord = YES;
            [self.navigationController pushViewController:vc animated:YES];
            
            
        }break;
        case 5:
        {
            //账户明细
            CPAccountRecordVC *vc = [CPAccountRecordVC new];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            
        }break;
        case 6:
        {
            //充值记录
            CPRechargeRecordVC *vc = [CPRechargeRecordVC new];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            
        }break;
        case 7:
        {
            //提款记录
            CPWithdrawRecordVC *vc = [CPWithdrawRecordVC new];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            
        }break;
        case 8:
        {
            //签到记录
            CPSignRecordVC *vc = [CPSignRecordVC new];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }break;
        case 9:
        {
            //个人消息
            CPPersonalMessageVC *vc = [CPPersonalMessageVC new];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }break;
        case 10:
        {
            //我的红包
            NSString *urlString = [[CPGlobalDataManager shareGlobalData].domainUrlString wayStringByAppendingPathComponent:@"/api/user/hbList"];
            CPWebViewController *toWebVC = [[CPWebViewController alloc]cpWebWithURLString:urlString];
            toWebVC.title = @"我的红包";
            toWebVC.showPageTitles = NO;
            toWebVC.showActionButton = NO;
            toWebVC.navigationButtonsHidden = YES;
            
            toWebVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:toWebVC animated:YES];
        }break;
            
        default:
            break;
    }
}

#pragma mark- actions

- (IBAction)buttonActions:(UIButton *)sender {
    
    switch (sender.tag) {
        case 101:
        {
            //刷新余额
            [self queryBalanceInfo];
            
        }break;
        case 24:
        {
            //在线客服
            if ([CPGlobalDataManager shareGlobalData].kefuUrlString) {
                [self loadKefuWebView];
            }else{
                [self queryKefuUrlString];
            }
        }break;
        case 21:
        {
            //充值
            if ([SUMUser shareUser].isTryPlay) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"抱歉，试玩账号不能进行存取款操作！" message:@"" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alert show];
                return;
            }
            CPRechargeTypeListVC *vc = [CPRechargeTypeListVC new];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];

        }break;
        case 22:
        {
            //提现
            if ([SUMUser shareUser].isTryPlay) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"抱歉，试玩账号不能进行存取款操作！" message:@"" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alert show];
                return;
            }
            [CPBusinessControllerManager pushToWithdrawControllerOnViewController:self];
        }break;
        case 23:
        {
            //签到
            if ([SUMUser shareUser].isTryPlay) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"抱歉，试玩账号不能进行签到操作！" message:@"" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alert show];
                return;
            }
            CPSignVC *signVC = [CPSignVC new];
            signVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:signVC animated:YES];
            
        }break;
        case 25:
        {
            //代理中心
            CPAgentCenterVC *vc = [CPAgentCenterVC new];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            
        }break;
            
        default:
            break;
    }
}


@end
