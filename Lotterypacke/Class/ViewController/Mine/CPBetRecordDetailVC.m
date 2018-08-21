//
//  CPBetRecordDetailVC.m
//  lottery
//
//  Created by way on 2018/7/24.
//  Copyright © 2018年 way. All rights reserved.
//

#import "CPBetRecordDetailVC.h"
#import "CPBuyLtyDetailVC.h"

@interface CPBetRecordDetailVC ()
{
    
}
@end

@implementation CPBetRecordDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundImage:[UIImage imageWithColor:kMainColor] forState:UIControlStateNormal];
    btn.frame =CGRectMake(0, self.view.height - 50.f, self.view.width, 50.0f);
    [btn setTitle:@"再来一注" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(addMoreOneAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    self.webView.frame = CGRectMake(0, 0, self.view.width, btn.bottomY);
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundImage:[UIImage imageWithColor:kMainColor] forState:UIControlStateNormal];
    btn.frame =CGRectMake(0, self.view.height - 50.f, self.view.width, 50.0f);
    [btn setTitle:@"再来一注" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(addMoreOneAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    self.webView.frame = CGRectMake(0, 0, self.view.width, btn.bottomY);
}

-(void)addMoreOneAction
{
    [[CPBuyLotteryManager shareManager]pushToBuyLtyDetailVCFromNav:self.navigationController ltyName:[_betRecordInfo DWStringForKey:@"gameName"] ltyCode:[_betRecordInfo DWStringForKey:@"code"] ltyNum:[_betRecordInfo DWStringForKey:@"gId"]];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        NSMutableIndexSet * mindexSet = [NSMutableIndexSet new];
        for (int i =0; i<self.navigationController.viewControllers.count; i++ ) {
            
            UIViewController * vc = self.navigationController.viewControllers[i];
            if ( ![vc isKindOfClass:[CPBuyLtyDetailVC class]] && i!=0) {
                [mindexSet addIndex:(NSInteger)i];
            }
        }
        
        NSMutableArray * aryViewControllers = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
        if (mindexSet.count>0) {
            [aryViewControllers removeObjectsAtIndexes:mindexSet];
            self.navigationController.viewControllers = aryViewControllers;
        }
     
    });
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
