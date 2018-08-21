//
//  CPJuniorStatementVC.m
//  lottery
//
//  Created by way on 2018/4/17.
//  Copyright © 2018年 way. All rights reserved.
//

#import "CPMemberManagerVC.h"
#import "CPSelectedOptionsAgoView.h"
#import "DWITButton.h"
#import "CPJuniorStatementCell.h"
#import "CPSelectedOptionsAgoView.h"

@interface CPMemberManagerVC ()<UITableViewDelegate,UITableViewDataSource>
{
    
    
    IBOutlet UITableView *_tableView;
        
    NSMutableArray *_dataList;
    int _page;
    int _totalPage;
    
    NSDictionary *_currentMemberInfo;
    
    //默认为-1 查看下一级-1 返回上一级1
    NSString *_lookInfoType;
    
    NSDictionary *_currentInfo;
}


@end

@implementation CPMemberManagerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"会员管理";
    
    _lookInfoType = @"-1";
    [_tableView registerNib:[UINib nibWithNibName:@"CPJuniorStatementCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([CPJuniorStatementCell class])];
    
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self queryDataForReferesh];
    }];
    
    _tableView.mj_footer = [MJRefreshBackStateFooter footerWithRefreshingBlock:^{
        [self queryDataMore];
    }];
    
    [_tableView.mj_header beginRefreshing];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataList.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CPJuniorStatementCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CPJuniorStatementCell class])];
    NSDictionary *info = _dataList[indexPath.row];
    [cell addMemberManagerRecordInfo:info];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *info = _dataList[indexPath.row];

    NSString *title = [NSString stringWithFormat:@"用户名:%@",[info DWStringForKey:@"code"]];

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *fandianAction = [UIAlertAction actionWithTitle:@"查看返点" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self queryFandianInfoListByInviteId:[info DWStringForKey:@"inviteId"]];
        
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:fandianAction];
    
    if ([[info DWStringForKey:@"inviteLevel"]intValue]!=1) {
        //查看上级
        UIAlertAction *shangjiAction = [UIAlertAction actionWithTitle:@"返回上一级" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            _currentInfo = info;
            _lookInfoType = @"1";
            [_tableView.mj_header beginRefreshing];
        }];
        [alertController addAction:shangjiAction];

    }
    
    if ([[info DWStringForKey:@"status"]intValue]>0) {
        //查看下级
        UIAlertAction *xiajiAction = [UIAlertAction actionWithTitle:@"查看下一级" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            _currentInfo = info;
            _lookInfoType = @"-1";
            [_tableView.mj_header beginRefreshing];
        }];
        [alertController addAction:xiajiAction];
    }
    
    
    NSMutableAttributedString *alertControllerStr = [[NSMutableAttributedString alloc] initWithString:title];
    [alertControllerStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, title.length)];
    [alertControllerStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:NSMakeRange(0, title.length)];
    [alertController setValue:alertControllerStr forKey:@"attributedTitle"];

    [self presentViewController:alertController animated:YES completion:nil];

    
//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:<#(nullable NSString *)#> message:<#(nullable NSString *)#> preferredStyle:<#(UIAlertControllerStyle)#>
    /*
     {"type":1,"code":"test01","inviteId":1,"inviteLevel":1,"status":4,"logTime":"May 11, 2018 2:30:08 PM","id":2}
     */
}

#pragma mark- network

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

-(void)queryDataForReferesh
{
    _page = 1;
    NSMutableDictionary *paramsDic =[[NSMutableDictionary alloc]initWithDictionary:@{@"token":[SUMUser shareUser].token}];
    [paramsDic setObject:[NSString stringWithFormat:@"%d",_page] forKey:@"pageNo"];
    [paramsDic setObject:@"2" forKey:@"deviceType"];
    [paramsDic setObject:_lookInfoType forKey:@"type"];
    if (_currentInfo) {
        [paramsDic setObject:[_currentInfo DWStringForKey:@"id"] forKey:@"memberId"];
    }

    NSString *paramsString = [NSString encryptedByGBKAES:[paramsDic JSONString]];
    [SUMRequest startWithDomainString:[CPGlobalDataManager shareGlobalData].domainUrlString
                              apiName:CPSerVerAPINameForAPIAgentAppMemberList
                               params:@{@"data":paramsString}
                         rquestMethod:YTKRequestMethodGET
           completionBlockWithSuccess:^(__kindof SUMRequest *request) {
               
               [_tableView.mj_header endRefreshing];
               NSString *alertMsg = @"";
               if (request.resultIsOk) {
                   
                   NSDictionary *dataInfo = [request.resultInfo DWDictionaryForKey:@"data"];
                   NSArray *items = [dataInfo DWArrayForKey:@"items"];
                   
                   /*
                    items = @[
                    @{"type":1,"code":"test01","inviteId":1,"inviteLevel":1,"status":4,"logTime":"May 11, 2018 2:30:08 PM","id":2}
                    
                    ];
                    */
                   if (items.count>0) {
                       _dataList = [[NSMutableArray alloc]initWithArray:items];
                       [_tableView reloadData];
                       _totalPage = [[dataInfo DWStringForKey:@"totalSize"]intValue];
                       if (_totalPage>_page) {
                           _page++;
                       }
                   }else{
                       alertMsg = @"暂无相关记录";
                   }
                   
               }else{
                   alertMsg = request.requestDescription;
               }
               
               if (alertMsg.length >0) {
                   [SVProgressHUD way_showInfoCanTouchAutoDismissWithStatus:alertMsg];
               }
               
           } failure:^(__kindof SUMRequest *request) {
               
               [_tableView.mj_header endRefreshing];
               [SVProgressHUD way_showInfoCanTouchAutoDismissWithStatus:@"网络异常"];
           }];
    
    
}

-(void)queryDataMore
{
    if (_page>=_totalPage) {
        
        [_tableView.mj_footer endRefreshingWithNoMoreData];
        [SVProgressHUD way_dismissThenShowInfoWithStatus:@"无更多相关记录"];
        return;
        
    }
    NSMutableDictionary *paramsDic =[[NSMutableDictionary alloc]initWithDictionary:@{@"token":[SUMUser shareUser].token}];
    [paramsDic setObject:[NSString stringWithFormat:@"%d",_page] forKey:@"pageNo"];
    [paramsDic setObject:_lookInfoType forKey:@"type"];
    [paramsDic setObject:@"2" forKey:@"deviceType"];
    
    if (_currentInfo) {
        [paramsDic setObject:[_currentInfo DWStringForKey:@"id"] forKey:@"memberId"];
    }
    
    NSString *paramsString = [NSString encryptedByGBKAES:[paramsDic JSONString]];
    [SUMRequest startWithDomainString:[CPGlobalDataManager shareGlobalData].domainUrlString
                              apiName:CPSerVerAPINameForAPIAgentAppMemberList
                               params:@{@"data":paramsString}
                         rquestMethod:YTKRequestMethodGET
           completionBlockWithSuccess:^(__kindof SUMRequest *request) {
               
               NSString *alertMsg = @"";
               if (request.resultIsOk) {
                   
                   NSDictionary *dataInfo = [request.resultInfo DWDictionaryForKey:@"data"];
                   NSArray *items = [dataInfo DWArrayForKey:@"items"];
                   
                   _totalPage = [[dataInfo DWStringForKey:@"totalSize"]intValue];
                   if (_totalPage>_page) {
                       _page++;
                   }
                   
                   if (items.count>0) {
                       
                       [_dataList addObjectsFromArray:items];
                       [_tableView reloadData];
                       [_tableView.mj_footer endRefreshing];
                       
                   }else{
                       alertMsg = @"无更多相关记录";
                       [_tableView.mj_footer endRefreshingWithNoMoreData];
                   }
                   
               }else{
                   [_tableView.mj_footer endRefreshing];
                   alertMsg = request.requestDescription;
               }
               [SVProgressHUD way_dismissThenShowInfoWithStatus:alertMsg];
               
               
           } failure:^(__kindof SUMRequest *request) {
               
               [_tableView.mj_footer endRefreshing];
               [SVProgressHUD way_showInfoCanTouchAutoDismissWithStatus:@"网络异常"];
           }];
}



@end
