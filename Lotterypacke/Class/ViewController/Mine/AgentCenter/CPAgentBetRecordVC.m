//
//  CPAgentBetRecordVC.m
//  lottery
//
//  Created by way on 2018/4/17.
//  Copyright © 2018年 way. All rights reserved.
//

#import "CPAgentBetRecordVC.h"
#import "DWITButton.h"

#import "CPSelectedOptionsAgoView.h"
#import "CPAgentBetRecordCell.h"
#import "CPDatePickerView.h"

@interface CPAgentBetRecordVC ()<UIWebViewDelegate,UITextViewDelegate>
{
    
    IBOutlet UIView *_tfBgView;
    IBOutlet UITextField *_textField;
    
    IBOutlet UILabel *_floatLabel;
    
    NSInteger _typeIndex;
    IBOutlet DWITButton *_rightItem;
    
    IBOutlet UITableView *_tableView;
    
    NSMutableArray *_dataList;
    int _page;
    int _totalPage;
    NSString *_searchDateString;
}

@property(nonatomic,retain)NSDate *searchDate;

@end

@implementation CPAgentBetRecordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"投注明细";
    
   
    _tfBgView.layer.cornerRadius = 5.0f;
    self.searchDate = [NSDate date];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_rightItem];
    
    [_tableView registerNib:[UINib nibWithNibName:@"CPAgentBetRecordCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([CPAgentBetRecordCell class])];
    
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self queryDataForReferesh];
    }];
    
    _tableView.mj_footer = [MJRefreshBackStateFooter footerWithRefreshingBlock:^{
        [self queryDataMore];
    }];
    
    _floatLabel.width = kScreenWidth/4.0f*0.8;
    _floatLabel.originX = kScreenWidth/4.0f*0.1;
    [self actionByTag:100];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


-(void)setSearchDate:(NSDate *)searchDate
{
    _searchDate = searchDate;
    _searchDateString = [NSString stringWithFormat:@"%ld-%ld-%ld",_searchDate.year,_searchDate.month,_searchDate.day];
    [_rightItem setTitle:[NSString stringWithFormat:@"%ld-%ld",_searchDate.month,_searchDate.day] forState:UIControlStateNormal];


}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self searchAction];
    return YES;
}

#pragma mark-

- (IBAction)buttonActions:(UIButton *)sender {
    if (sender.tag>=100) {
        [UIView animateWithDuration:0.38 animations:^{
            _floatLabel.centerX = sender.centerX;
        }];
    }
    [self actionByTag:sender.tag];
}

-(void)actionByTag:(NSInteger)tag
{
    switch (tag) {
        case 98:
        {
            //显示日期选择界面
            [CPDatePickerView showDatePickerOnView:self.navigationController.view date:self.searchDate comfirm:^(BOOL isComfirm, NSDate *selectedDate) {
                if (isComfirm) {
                    self.searchDate = selectedDate;
                    [self searchAction];
                }
            }];

            return;
            
        }break;
        case 99:
        {
            //搜索
            
        }break;
            
        default:
        {
            _typeIndex = tag -100;
            //全部，已中奖，未中奖，等待开奖
            
        }break;
    }
    [self searchAction];
    
}

-(void)searchAction
{
    [self.view endEditing:YES];
    _dataList = [NSMutableArray new];
    [_tableView reloadData];
    [_tableView.mj_header beginRefreshing];
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
    return 100.0f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CPAgentBetRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CPAgentBetRecordCell class])];
    NSDictionary *info = _dataList[indexPath.row];
    [cell addBetRecordInfo:info];
    return cell;
}

#pragma mark- network

-(void)queryDataForReferesh
{
    _page = 1;
    NSArray *typeStringList = @[@"",@"1",@"2",@"3"];
    NSMutableDictionary *paramsDic =[[NSMutableDictionary alloc]initWithDictionary:@{@"token":[SUMUser shareUser].token}];
    [paramsDic setObject:[NSString stringWithFormat:@"%d",_page] forKey:@"pageNo"];
    [paramsDic setObject:[typeStringList objectAtIndex:_typeIndex] forKey:@"type"];
    [paramsDic setObject:_searchDateString forKey:@"day"];

    
    NSString *memberCode = _textField.text;
    if (memberCode.length>0) {
        [paramsDic setObject:memberCode forKey:@"memberCode"];
    }
    [paramsDic setObject:@"2" forKey:@"deviceType"];
    
    
    NSString *paramsString = [NSString encryptedByGBKAES:[paramsDic JSONString]];
    [SUMRequest startWithDomainString:[CPGlobalDataManager shareGlobalData].domainUrlString
                              apiName:CPSerVerAPINameForAPIAgentAppBetDetail
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
    NSArray *typeStringList = @[@"",@"1",@"2",@"3"];
    NSMutableDictionary *paramsDic =[[NSMutableDictionary alloc]initWithDictionary:@{@"token":[SUMUser shareUser].token}];
    [paramsDic setObject:[NSString stringWithFormat:@"%d",_page] forKey:@"pageNo"];
    [paramsDic setObject:_searchDateString forKey:@"day"];
    [paramsDic setObject:[typeStringList objectAtIndex:_typeIndex] forKey:@"type"];
    NSString *memberCode = _textField.text;
    if (memberCode.length>0) {
        [paramsDic setObject:memberCode forKey:@"memberCode"];
    }
    [paramsDic setObject:@"2" forKey:@"deviceType"];
    NSString *paramsString = [NSString encryptedByGBKAES:[paramsDic JSONString]];
    [SUMRequest startWithDomainString:[CPGlobalDataManager shareGlobalData].domainUrlString
                              apiName:CPSerVerAPINameForAPIAgentAppBetDetail
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
