//
//  CPJuniorStatementVC.m
//  lottery
//
//  Created by way on 2018/4/17.
//  Copyright © 2018年 way. All rights reserved.
//

#import "CPJuniorStatementVC.h"
#import "CPSelectedOptionsAgoView.h"
#import "DWITButton.h"
#import "CPJuniorStatementCell.h"
#import "LotteryHeader.h"

@interface CPJuniorStatementVC ()<UIWebViewDelegate>
{
    
    
    IBOutlet UITableView *_tableView;
    
    
    NSArray *_dateList;
    IBOutlet DWITButton *_rightItem;
    
    NSMutableArray *_dataList;
    int _page;
    int _totalPage;
}

@property(nonatomic,assign)NSInteger selectedDateIndex;

@end

@implementation CPJuniorStatementVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"下级报表";
    
    
    [_tableView registerNib:[UINib nibWithNibName:@"CPJuniorStatementCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([CPJuniorStatementCell class])];
    
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self queryDataForReferesh];
    }];
    
    _tableView.mj_footer = [MJRefreshBackStateFooter footerWithRefreshingBlock:^{
        [self queryDataMore];
    }];
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_rightItem];
    _dateList = @[@"今日",@"昨日",@"本月",@"上月"];
    self.selectedDateIndex = 0;

    
}

- (IBAction)searchDateAction:(UIButton *)sender {
    
    [CPSelectedOptionsAgoView showWithOnView:self.navigationController.view title:@"选择查询时间" options:_dateList selectedIndex:_selectedDateIndex selected:^(NSInteger index) {
        
        if (index != _selectedDateIndex) {
            self.selectedDateIndex = index;
        }
    }];
}

-(void)setSelectedDateIndex:(NSInteger)selectedDateIndex
{
    _selectedDateIndex = selectedDateIndex;
    NSString *title = _dateList[_selectedDateIndex];
    [_rightItem setTitle:title forState:UIControlStateNormal];
    [self searchAction];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)searchAction{
    
    [self.view endEditing:YES];
    [_tableView.mj_header beginRefreshing];
//    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
    
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
    [cell addRecordInfo:info];
    return cell;
}

#pragma mark- network

-(void)queryDataForReferesh
{
    _page = 1;
    NSMutableDictionary *paramsDic =[[NSMutableDictionary alloc]initWithDictionary:@{@"token":[SUMUser shareUser].token}];
    [paramsDic setObject:[NSString stringWithFormat:@"%d",_page] forKey:@"pageNo"];
    [paramsDic setObject:@(_selectedDateIndex+1) forKey:@"dayType"];

    [paramsDic setObject:@"2" forKey:@"deviceType"];
    
    NSString *paramsString = [NSString encryptedByGBKAES:[paramsDic JSONString]];
    [SUMRequest startWithDomainString:[CPGlobalDataManager shareGlobalData].domainUrlString
                              apiName:CPSerVerAPINameForAPIAgentAppDownReport
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
                    @{@"title":@"消息1",@"status":@"0",@"id":@"1",@"addTime":@"2017-07-22 10:15:21"},
                    @{@"title":@"消息2",@"status":@"1",@"id":@"2",@"addTime":@"2017-07-22 10:15:21"}
                    
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
    [paramsDic setObject:@(_selectedDateIndex+1) forKey:@"dayType"];

    [paramsDic setObject:@"2" forKey:@"deviceType"];
    NSString *paramsString = [NSString encryptedByGBKAES:[paramsDic JSONString]];
    [SUMRequest startWithDomainString:[CPGlobalDataManager shareGlobalData].domainUrlString
                              apiName:CPSerVerAPINameForAPIAgentAppDownReport
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
