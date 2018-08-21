//
//  CPAgentStatementVC.m
//  lottery
//
//  Created by way on 2018/4/17.
//  Copyright © 2018年 way. All rights reserved.
//

#import "CPAgentStatementVC.h"
#import "CPSelectedOptionsAgoView.h"
#import "DWITButton.h"
#import "CPAgentStatementCell.h"

@interface CPAgentStatementVC ()<UITextFieldDelegate,UIWebViewDelegate>
{
    IBOutlet UITextField *_textField;
    IBOutlet UIView *_tfBgView;
    
    IBOutlet UIWebView *_webView;
    
    NSArray *_dateList;
    IBOutlet DWITButton *_rightItem;
    
    NSArray *_infoList;
    NSArray *_desList;
    NSArray *_imgsList;
    IBOutlet UICollectionView *_collectionView;
    
    
}

@property(nonatomic,assign)NSInteger selectedDateIndex;

@end

@implementation CPAgentStatementVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"代理报表";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_rightItem];
    
    _tfBgView.layer.cornerRadius = 5.0f;
    _dateList = @[@"今日",@"昨日",@"本月",@"上月"];
    _desList = @[@"投注人数",@"投注金额",@"中奖金额",@"注册人数",@"团队盈利",@"团队余额",@"首充人数",@"充值金额",@"提现金额",@"下级人数",@"投注返点",@"赔率返点",];
    _imgsList = @[@"agent_statement_tzrs",@"agent_statement_tzje",@"agent_statement_zjje",@"agent_statement_zcrs",@"agent_statement_tdyl",@"agent_statement_tdye",@"agent_statement_scrs",@"agent_statement_czje",@"agent_statement_txje",@"agent_statement_xjrs",@"agent_statement_tzfd",@"agent_statement_plfd",];

    [_collectionView registerNib:[UINib nibWithNibName:@"CPAgentStatementCell" bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([CPAgentStatementCell class])];
     
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
    [self searchAction:nil];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self searchAction:nil];
    return YES;
}

- (IBAction)searchAction:(UIButton *)sender {
    
    [self.view endEditing:YES];
//
//    NSString *urlString = [NSString stringWithFormat:@"%@&dayType=%ld&memberCode=%@",self.baseUrlString,_selectedDateIndex+1,_textField.text?_textField.text:@""];
//    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
    [self queryAgentStatementInfo];
}

#pragma mark- collectionView Delegate

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _desList.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CPAgentStatementCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([CPAgentStatementCell class]) forIndexPath:indexPath];
    NSString *des = [_desList objectAtIndex:indexPath.row];
    NSString *imgName = [_imgsList objectAtIndex:indexPath.row];
    UIImage *img = [UIImage imageNamed:imgName];
    NSString *content = _infoList.count>indexPath.row?_infoList[indexPath.row]:@"";
    BOOL showRight = YES;
    if ((indexPath.row+1)%3==0) {
        showRight = NO;
    }
    BOOL showBottom = YES;
    if (indexPath.row+1>9) {
        showBottom = NO;
    }
    [cell addImage:img content:[content jdM] des:des isShowBottomLine:showBottom isShowRightLine:showRight];
    return cell;
    
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    CGSize size = CGSizeMake((_collectionView.width)/3.0f, (_collectionView.width)/3.0f);
    return size;
}
#pragma mark-

-(void)queryAgentStatementInfo
{
    NSMutableDictionary *paramsDic =[[NSMutableDictionary alloc]initWithDictionary:@{@"token":[SUMUser shareUser].token}];
    [paramsDic setObject:@"2" forKey:@"deviceType"];
    [paramsDic setObject:@(_selectedDateIndex+1) forKey:@"dayType"];
    NSString *agentCode = _textField.text;
    if (agentCode.length>0) {
        [paramsDic setObject:agentCode forKey:@"agentCode"];
    }

    NSString *paramsString = [NSString encryptedByGBKAES:[paramsDic JSONString]];
    [SUMRequest startWithDomainString:[CPGlobalDataManager shareGlobalData].domainUrlString
                              apiName:CPSerVerAPINameForAPIAgentAppReport
                               params:@{@"data":paramsString}
                         rquestMethod:YTKRequestMethodGET
           completionBlockWithSuccess:^(__kindof SUMRequest *request) {
               
              
               NSString *alertMsg = @"";
               if (request.resultIsOk) {
                   NSDictionary *info = request.businessData;
                   NSMutableArray *list = [NSMutableArray new];
                   [list addObject:[info DWStringForKey:@"tzrs"]];
                   [list addObject:[info DWStringForKey:@"tzje"]];
                   [list addObject:[info DWStringForKey:@"zjje"]];
                   
                   [list addObject:[info DWStringForKey:@"zcrs"]];
                   [list addObject:[info DWStringForKey:@"tdyl"]];
                   [list addObject:[info DWStringForKey:@"tdye"]];
                   
                   [list addObject:[info DWStringForKey:@"scrs"]];
                   [list addObject:[info DWStringForKey:@"czje"]];
                   [list addObject:[info DWStringForKey:@"txje"]];
                   
                   [list addObject:[info DWStringForKey:@"xjrs"]];
                   [list addObject:[info DWStringForKey:@"tdfd"]];
                   [list addObject:[info DWStringForKey:@"dlfd"]];

                   /*
                    {
                    czje = 1054;
                    dlfd = 0;
                    hdlj = 0;
                    id = 1;
                    scrs = 0;
                    tdfd = 0;
                    tdye = "190323.233";
                    tdyl = "-56.6";
                    txje = 800;
                    tzje = 6309;
                    tzrs = 4;
                    xjrs = 44;
                    zcrs = 3;
                    zjje = "6252.4";
                    */
                   _infoList = list;
                   [_collectionView reloadData];
               }else{
                   alertMsg = request.requestDescription;
               }
            
               [SVProgressHUD way_showInfoCanTouchWithStatus:alertMsg dismissAfterInterval:1.3 onView:self.view];

           } failure:^(__kindof SUMRequest *request) {
               
               [SVProgressHUD way_showInfoCanTouchWithStatus:@"网络异常" dismissAfterInterval:1.3 onView:self.view];
           }];
    
}


@end
