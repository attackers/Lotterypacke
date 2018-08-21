//
//  CPAgentOddsVC.m
//  lottery
//
//  Created by way on 2018/4/17.
//  Copyright © 2018年 way. All rights reserved.
//

#import "CPAgentOddsVC.h"
#import "CPSelectedOptionsAgoView.h"
#import "DWITButton.h"

@interface CPAgentOddsVC ()<UIWebViewDelegate>
{
    
    IBOutlet UIWebView *_webView;
    
    IBOutlet DWITButton *_rightItem;
    
    NSMutableArray *_nameList;
}

@property(nonatomic,assign)NSInteger selectedDateIndex;

@end

@implementation CPAgentOddsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"赔率对照表";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_rightItem];
    _nameList = [NSMutableArray new];
    for (int i = 0; i<_ltyInfoList.count; i++) {
        NSDictionary *info = _ltyInfoList[i];
        NSString *name = [info DWStringForKey:@"name"];
        [_nameList addObject:name];
    }
    self.selectedDateIndex = 0;
    
}

- (IBAction)searchDateAction:(UIButton *)sender {
    
    [CPSelectedOptionsAgoView showWithOnView:self.navigationController.view title:@"选择查询时间" options:_nameList selectedIndex:_selectedDateIndex selected:^(NSInteger index) {
        if (index != _selectedDateIndex) {
            self.selectedDateIndex = index;
        }
    }];
}

-(void)setSelectedDateIndex:(NSInteger)selectedDateIndex
{
    _selectedDateIndex = selectedDateIndex;
    NSDictionary *info = _ltyInfoList[_selectedDateIndex];
    [_rightItem setTitle:[info DWStringForKey:@"name"] forState:UIControlStateNormal];
    [self searchAction];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)searchAction{
    
    [self.view endEditing:YES];
    NSDictionary *info = _ltyInfoList[_selectedDateIndex];
    NSString *urlString = [NSString stringWithFormat:@"%@&code=%@",self.baseUrlString,[info DWStringForKey:@"code"]];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
    
}



@end
