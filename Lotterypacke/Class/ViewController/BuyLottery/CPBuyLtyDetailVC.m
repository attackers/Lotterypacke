//
//  CPBuyLtyDetailVC.m
//  lottery
//
//  Created by way on 2018/3/22.
//  Copyright © 2018年 way. All rights reserved.
//

#import "CPBuyLtyDetailVC.h"
#import "CPBuyLotteryForJssscHeaderView.h"
#import "CPBuyLotteryForPkshiHeaderView.h"
#import "CPBuyLotteryForMenuCell.h"

#import "CPBuyLotteryForContentSectionHeaderView.h"
#import "CPBuyLotteryForContentCell.h"
#import "CPBuyLotteryForTypeTwoContentCell.h"
#import "CPBuyLtyRightButtonItemSortView.h"
#import "CPBetRecordVC.h"
#import "CPLotteryResultDetailWebVC.h"
#import "CPBuyFastLotteryConfirmView.h"
#import "CPRechargeTypeListVC.h"
#import "CPBuyLtyOfficialPlayOptionsSelectedView.h"

#import "CPBuyLtyDetailOfficialPlayTitleView.h"
#import "CPBuyLtyDetailOfficialPlayChooseView.h"
#import "CPBuyLotteryForOfficailBallContentCell.h"

#import "CPBuyLtyDetailOfficialPlayHeaderTitleView.h"
#import "CPBuyLtyDetailOfficialCustomPlayContentView.h"

#import "CPBuyLotteryForOfficailRuleAlertView.h"
#import "CPBuyLtyContentCell.h"

@interface CPBuyLtyDetailVC ()<CPBuyLotteryHeaderViewProtocol,UITableViewDelegate,UITableViewDataSource,CPBuyLtyBetContentProtocol,CPBuyLtyRightButtonItemSortActionProtocol,CPBuyLtyOfficialPlayOptionsSelectedViewDelegate,CPBuyLtyDetailOfficialPlayChooseViewDelegate>
{
    CPBuyLotteryForBaseHeaderView *_headerView;
    
    UITableView *_menuTableView;
    UITableView *_contentTableView;
    
    
    UIView *_bottomView;
    
    UIImageView *_contentBgView;
    UIView *_contentTbHeaderView;
    //
    
    
    //本地时间跟北京时间的差
    NSTimeInterval _beijingTiemDistance;
    
    //是否正在刷新数据
    BOOL _isQueryInfoIng;
    
    
    //余额
    NSString *_balance;
    
    //标记选中的选项
    NSMutableDictionary *_selectedIndexPathMarkDic;
    
    //投注信息
    NSMutableArray *_betInfos;
    
    
    //投注金额
    NSString *_betAmount;
    
    BOOL _isOfficailPlay;
    
    NSArray *_gfNameList;
    NSDictionary *_gfPlayListInfo;
    
    NSDictionary *_chooseGfPlayInfo;
    
    UIImageView *_gfGuideView;
    
    
    //计算一行排几个、要用圆形还是矩形、需不需要赔率
    NSInteger _numberOfRowsInSection;
    CPBuyLtyCellContentItemLayoutType _currentCellLayoutType;
    CPBuyLtyCellContentItemShape _currentItemShape;
    
}

//开奖倒计时定时器
@property(nonatomic,retain)NSTimer *openDateTimer;

//开奖
@property(nonatomic,retain)NSTimer *reloadOpenResultTimer;


@property(nonatomic,assign)CPLotteryResultType currentLtyResultType;
@property(nonatomic,assign)NSInteger selectedMenuIndex;
@property(nonatomic,retain)CPBuyLtyRightButtonItemSortView *rightBarItemSortView;


/**
 投注选项内容
 */
@property(nonatomic,retain)NSArray *playDetailList;

/**
 合肖
 */
@property(nonatomic,retain)NSArray *heXiaoPlayDetailList;


/**
 自选不中
 */
@property(nonatomic,retain)NSArray *zxbzPlayDetailList;


/**
 连码
 */
@property(nonatomic,retain)NSMutableArray *lianMaPlayDetailList;

@property(nonatomic,retain)NSArray *lhcNumberPlayInfoList;

@property(nonatomic,assign)NSInteger numberOfLineInRow;
/*
 playDetailList = (
 {
 list =  ({bonus = "9.800000000000001";
 playId = "2-1-10";
 playName = 0;});
 name = "\U4e07\U4f4d";
 }
 )
 */
@property(nonatomic,retain)NSArray *contentPlayDetailList;

@property(nonatomic,retain)NSDictionary *headInfo;


/**
 导航栏上面选择是否官方玩法的titleView
 */
@property(nonatomic,retain)CPBuyLtyDetailOfficialPlayTitleView *officailPlayTitleView;

@property(nonatomic,retain)CPBuyLtyDetailOfficialPlayChooseView *officailPlayChooseView;


/**
 选择官方玩法的具体玩法标记
 */
@property(nonatomic,retain)NSIndexPath *chooseGfPlayIndexPath;

@property(nonatomic,retain)CPBuyLtyDetailOfficialPlayHeaderTitleView *officailPlayHeaderView;

@property(nonatomic,retain)CPBuyLtyDetailOfficialCustomPlayContentView *officialCustomPlayContentView;


@property(nonatomic,retain)CPBuyLotteryForOfficailRuleAlertView *officailRuleAlertView;

@end

@implementation CPBuyLtyDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //设置初始是否为官方玩法
    _isOfficailPlay = NO;
    if (self.gfBonusListInfo.allKeys.count>0) {
        _isOfficailPlay = [SUMUser shareUser].tokenInfo.isDefaultGfPlay;
        
        self.navigationItem.titleView = self.officailPlayTitleView;
        [self.officailPlayTitleView addTitle:self.ltyName isOfficail:_isOfficailPlay];
        
        NSArray *gfNameList = [NSArray new];
        NSDictionary *gfPlayListInfo = [NSDictionary new];
        
        [[CPBuyLotteryManager shareManager]loadGfInfoByLtyCode:self.typeCode nameList:&gfNameList playListInfo:&gfPlayListInfo];
        _gfNameList = gfNameList;
        _gfPlayListInfo = gfPlayListInfo;
        
        
    }else{
        self.title = self.ltyName;
    }
    
    
    //判断是否要显示引导
    if (_isOfficailPlay) {
        NSString *value = [[NSUserDefaults standardUserDefaults]objectForKey:@"showButLtyGuideView"];
        if (!value) {
            [[NSUserDefaults standardUserDefaults]setObject:@"showed" forKey:@"showButLtyGuideView"];
            [self showGfGuideView];
        }
    }
    
    _headInfo = _headInfo?_headInfo:[NSDictionary new];
    //设置全局属性
    [CPBuyLotteryManager shareManager].currentBuyLotteryType = self.currentLtyResultType;
    [CPBuyLotteryManager shareManager].isOfficailPlay = _isOfficailPlay;
    [CPBuyLotteryManager shareManager].currentBuyLotteryTypeString = [NSString stringWithFormat:@"%@",self.typeCode];
    [CPBuyLotteryManager shareManager].currentLotteryName = [NSString stringWithFormat:@"%@",self.ltyName];
    [CPBuyLotteryManager shareManager].currentLtyGid = [NSString stringWithFormat:@"%@",self.ltyNum];
    //初始化属性
    _selectedIndexPathMarkDic = [NSMutableDictionary new];
    _isQueryInfoIng = NO;
    
    
    //
    [self reloadCellUITypeAndData];
    
    //创建导航栏的rightButtonItem
    [self buildBarButtonItem];
    
    //创建底部视图
    [self buildBottomView];
    
    //创建头部视图
    [self buildHeaderView];
    
    //创建中间内容视图
    [self buildContentView];
    
    
    //初始化menu选择
    [self loadMenuTableViewInitStatus];
    
    //初始化投注内容视图
    [self loadContentTableViewInitStatus];
    
    
    //更新开奖倒计时时间
    [self reloadOpenDate];
    self.openDateTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(reloadOpenDate) userInfo:nil repeats:YES];
    
    //获取北京时间
    [self reloadBeiJingTime];
    
    
    //监听刷新余额
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(queryBalanceInfo) name:kNotificationNameForLoginSucceed object:nil];
    
    //刷新头部信息
    [self queryLtyResult];
    
    //刷新余额
    [self queryBalanceInfo];
    
    //定时刷新开奖结果
    self.reloadOpenResultTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(reloadQueryOpenResult) userInfo:nil repeats:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.reloadOpenResultTimer.isValid == NO) {
        self.reloadOpenResultTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(reloadQueryOpenResult) userInfo:nil repeats:YES];
    }
    if (self.openDateTimer.isValid == NO) {
        self.openDateTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(reloadOpenDate) userInfo:nil repeats:YES];
    }
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (self.reloadOpenResultTimer.isValid) {
        [_reloadOpenResultTimer invalidate];
        _reloadOpenResultTimer = nil;
    }
    if (self.openDateTimer.isValid) {
        [_openDateTimer invalidate];
        _openDateTimer = nil;
    }
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

#pragma mark- Init

//初始化menu选择
-(void)loadMenuTableViewInitStatus
{
    self.selectedMenuIndex = 0;
}

//初始化投注内容视图
-(void)loadContentTableViewInitStatus
{
    [self reloadCellUITypeAndData];
    [_contentTableView reloadData];
    [self reloadTableHeaderView];
    [self reloadBottonView];
    
}

#pragma mark- Business

-(void)showGfGuideView
{
    if (_gfGuideView.superview) {
        [_gfGuideView removeFromSuperview];
        _gfGuideView = nil;
    }
    
    
    _gfGuideView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    _gfGuideView.userInteractionEnabled = YES;
    
    NSString *imgName = @"";
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    if (screenHeight == 480.0) {
        imgName = @"iphone4s_buylty_guide";
        
    }else if (screenHeight == 568.0) {
        imgName = @"iphone5s_buylty_guide";
        
    }else if (screenHeight == 667.0) {
        imgName = @"iphone6_buylty_guide";
        
    }else if (screenHeight == 736.0) {
        imgName = @"iphone6Plus_buylty_guide";
        
    }else{
        imgName = @"iphoneX_buylty_guide";
    }
    
    [_gfGuideView setImage:[UIImage imageNamed:imgName]];
    [[UIApplication sharedApplication].keyWindow addSubview:_gfGuideView];
    
    UIButton *dismissBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    dismissBtn.frame = CGRectMake(0, 0, _gfGuideView.width, _gfGuideView.height);
    [dismissBtn addTarget:self action:@selector(dismissBuyLtyGuideView) forControlEvents:UIControlEventTouchUpInside];
    [_gfGuideView addSubview:dismissBtn];
}

-(void)dismissBuyLtyGuideView
{
    if (_gfGuideView.superview) {
        [UIView animateWithDuration:0.2 animations:^{
            _gfGuideView.layer.opacity = 0;
        }completion:^(BOOL finished) {
            [_gfGuideView removeFromSuperview];
            _gfGuideView = nil;
        }];
    }
    
}

-(NSString *)allOfficailPlayBonusByPlayId:(NSString *)playId
{
    NSString *bonus = @"";
    NSString *bonusValue = [self.gfBonusListInfo DWStringForKey:playId];
    if ([bonusValue rangeOfString:@"|"].length>0) {
        bonus = bonusValue;
    }else{
        bonus = [bonusValue jdM];
    }
    
    return bonus;
}

-(NSString *)officailPlayBonusByPlayId:(NSString *)playId
{
    NSString *bonus = @"";
    NSString *bonusValue = [self.gfBonusListInfo DWStringForKey:playId];
    if ([bonusValue rangeOfString:@"|"].length>0) {
        NSArray *list = [bonusValue componentsSeparatedByString:@"|"];
        for (int i = 0; i<list.count; i++) {
            NSString *value = [list[i] jdM];
            if ([bonus doubleValue]<[value doubleValue]) {
                bonus = value;
            }
        }
    }else{
        bonus = [bonusValue jdM];
    }
    
    return bonus;
}

-(NSArray *)gfPlayDetailInfoListByIndex:(NSInteger)index
                               playName:(NSString **)playName
{
    NSDictionary *nameInfo = _gfNameList[index];
    NSString *key = [NSString stringWithFormat:@"n%@",[nameInfo DWStringForKey:@"playId"]];
    NSString *name = [nameInfo DWStringForKey:@"name"];
    if (playName!=NULL) {
        *playName = name;
    }
    NSArray *list = [_gfPlayListInfo DWArrayForKey:key];
    return list;
}

//清除投注选项
-(void)cleanSelectedBetRecord
{
    _selectedIndexPathMarkDic = [NSMutableDictionary new];
    [_contentTableView reloadData];
}

//刷新头部视图
-(void)reloadHeaderViewInfo
{
    [_headerView loadDataByPlayInfo:self.headInfo];
}

//刷新余额
-(void)reloadBalanceLabel
{
    if ([SUMUser shareUser].isLogin) {
        NSString *text = [NSString stringWithFormat:@"%@",[_balance jdM]];
        [_headerView loadBalance:text];
        
    }else{
        [_headerView loadBalance:@"0.00"];
    }
}

//刷新开奖结果
-(void)reloadQueryOpenResult
{
    NSString *lastOpen = [self.headInfo DWStringForKey:@"lastOpen"];
    if (lastOpen.length == 0) {
        [self queryLtyResult];
    }
    [self queryBalanceInfo];
}

//
-(void)reloadCellUITypeAndData
{
    
    if (_isOfficailPlay) {
        
        NSString *type =  [_chooseGfPlayInfo DWStringForKey:@"type"];
        if ([type isEqualToString:@"ball"]) {
            _currentItemShape = CPBuyLtyCellContentItemShapeForCircle;
            _currentCellLayoutType = CPBuyLtyCellContentItemLayoutOnlyContentText;
            _numberOfRowsInSection = 4;
            
        }else if ([type isEqualToString:@"singleball"]){
            
            _currentCellLayoutType = CPBuyLtyCellContentItemLayoutContentTextAndBonusValue;
            NSInteger maxNameLength = 0;
            NSArray *display = [_chooseGfPlayInfo DWArrayForKey:@"display"];
            for (NSDictionary *info in display) {
                NSArray *list = [info DWArrayForKey:@"single"];
                for (NSDictionary *playInfo in list) {
                    NSString *name = [playInfo DWStringForKey:@"name"];
                    maxNameLength = name.length>maxNameLength?name.length:maxNameLength;
                }
            }
            if (maxNameLength<=2) {
                _currentItemShape = CPBuyLtyCellContentItemShapeForCircle;
                _numberOfRowsInSection = 4;
            }else{
                _currentItemShape = CPBuyLtyCellContentItemShapeForRect;
                if (maxNameLength>=4) {
                    _numberOfRowsInSection = 2;
                }else{
                    _numberOfRowsInSection = 3;
                }
            }
            
        }else{
            _numberOfRowsInSection = 0;
        }
        
    }else{
        
        NSInteger maxNameLength = 0;
        for (NSDictionary *playDetailInfo in self.contentPlayDetailList) {
            NSArray *list = [playDetailInfo DWArrayForKey:@"list"];
            for (NSDictionary *playInfo in list) {
                NSString *name = [playInfo DWStringForKey:@"playName"];
                maxNameLength = name.length>maxNameLength?name.length:maxNameLength;
            }
        }
        if (maxNameLength<=2) {
            _currentItemShape = CPBuyLtyCellContentItemShapeForCircle;
            _numberOfRowsInSection = 4;
        }else{
            _currentItemShape = CPBuyLtyCellContentItemShapeForRect;
            if (maxNameLength>4) {
                _numberOfRowsInSection = 2;
            }else{
                _numberOfRowsInSection = 3;
            }
        }
        
        if([[CPBuyLotteryManager shareManager].currentPlayKindDes isEqualToString:@"自选不中"]||[[CPBuyLotteryManager shareManager].currentPlayKindDes isEqualToString:@"连码"]||[[CPBuyLotteryManager shareManager].currentPlayKindDes isEqualToString:@"合肖"]){
            _currentCellLayoutType = CPBuyLtyCellContentItemLayoutOnlyContentText;
            if ([[CPBuyLotteryManager shareManager].currentPlayKindDes isEqualToString:@"合肖"]) {
                _currentItemShape = CPBuyLtyCellContentItemShapeForRect;
                _numberOfRowsInSection = 2;
                if (kScreenWidth<=375) {
                    _numberOfRowsInSection = 1;
                }
                
            }
        }else{
            _currentCellLayoutType = CPBuyLtyCellContentItemLayoutContentTextAndBonusValue;
        }
        
        
    }
}



#pragma mark 开奖时间倒计时相关逻辑

-(void)reloadOpenDate
{
    NSTimeInterval distance = [[self.headInfo DWStringForKey:@"endTime"]doubleValue]/1000 -([[NSDate date] timeIntervalSince1970]-_beijingTiemDistance);
    NSTimeInterval our = distance/(60*60);
    NSInteger intOur = our;
    NSTimeInterval min = (distance - intOur*60*60)/60;
    NSInteger intMin = min;
    NSTimeInterval second = distance - intOur*60*60 - intMin*60;
    NSInteger intSecond = second;
    
    NSString *ourString = intOur>9?[NSString stringWithFormat:@"%ld",intOur]:[NSString stringWithFormat:@"0%ld",intOur];
    NSString *minString = intMin>9?[NSString stringWithFormat:@"%ld",intMin]:[NSString stringWithFormat:@"0%ld",intMin];
    NSString *secondString = intSecond>9?[NSString stringWithFormat:@"%ld",intSecond]:[NSString stringWithFormat:@"0%ld",intSecond];
    
    NSString *countTime = @"";
    if (intOur<=0 && intMin<=0 && intSecond<=0) {
        countTime = @"00:00:00";
        [self queryLtyResult];
        
    }else{
        countTime = [NSString stringWithFormat:@"%@:%@:%@",ourString,minString,secondString];
    }
    
    //刷新倒计时时间
    [_headerView loadCountTime:countTime];
    
}

//刷新北京时间
-(void)reloadBeiJingTime
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSDate *beijingDate = [self getInternetDate];
        if (beijingDate) {
            NSDate *nowDate = [NSDate date];
            NSTimeInterval nowTimeInterval = [nowDate timeIntervalSince1970];
            NSTimeInterval beiJingTimeInterval = [beijingDate timeIntervalSince1970];
            _beijingTiemDistance =nowTimeInterval - beiJingTimeInterval;
        }
        
    });
}


#pragma mark- 标记选中的个数限制

-(BOOL)hasConformToRuleSelectedIndexPathMaxCountOfSection:(NSInteger)section
                                           atPlayKindName:(NSString *)playKindName
                                              alertString:(NSString **)alertString
{
    BOOL hasConform = YES;
    NSInteger count = [self numberOfSelectedIndexPathOfSection:section];
    if ([playKindName isEqualToString:@"自选不中"]) {
        //选择6-11个
        if (count>11||count<6) {
            hasConform = NO;
            *alertString = @"自选不中下注号码为6-11个";
        }
    }else if ([playKindName isEqualToString:@"连码"]) {
        //3中2:3-7 , 3全中:3-10 , 2全中:2-7 , 2中特:2-7 ,特串:2-7
        NSDictionary *playDetailInfo = self.contentPlayDetailList[section];
        NSString *playName = [playDetailInfo DWStringForKey:@"playName"];
        NSInteger maxCount = [[playDetailInfo DWStringForKey:@"maxCount"] integerValue];
        NSInteger minCount = [[playDetailInfo DWStringForKey:@"minCount"] integerValue];
        if ((count>maxCount||count<minCount)&&count!=0) {
            hasConform = NO;
            *alertString = [NSString stringWithFormat:@"%@下注号码为%ld-%ld个",playName,minCount,maxCount];
        }
        
    }else if ([playKindName isEqualToString:@"合肖"]) {
        //选择6-11个
        if (count>11||count<2) {
            hasConform = NO;
            *alertString = @"合肖下注号码为2-11个";
        }
    }else if ([playKindName isEqualToString:@"连肖连尾"]) {
        
        NSDictionary *playDetailInfo = self.contentPlayDetailList[section];
        NSString *name = [playDetailInfo DWStringForKey:@"name"];
        if ([name rangeOfString:@"二连"].length>0) {
            if (count<2&&count!=0) {
                hasConform = NO;
                if ([name rangeOfString:@"尾"].length>0) {
                    *alertString = @"二连尾下注号码至少2个";
                }else{
                    *alertString = @"二连肖下注号码至少2个";
                }
            }
        }else if ([name rangeOfString:@"三连"].length>0) {
            if (count<3&&count!=0) {
                hasConform = NO;
                if ([name rangeOfString:@"尾"].length>0) {
                    *alertString = @"三连尾下注号码至少3个";
                }else{
                    *alertString = @"三连肖下注号码至少3个";
                }
            }
        }else if ([name rangeOfString:@"四连"].length>0) {
            if (count<4&&count!=0) {
                hasConform = NO;
                if ([name rangeOfString:@"尾"].length>0) {
                    *alertString = @"四连尾下注号码至少4个";
                }else{
                    *alertString = @"四连肖下注号码至少4个";
                }
            }
        }else if ([name rangeOfString:@"五连"].length>0) {
            if (count<5&&count!=0) {
                hasConform = NO;
                if ([name rangeOfString:@"尾"].length>0) {
                    *alertString = @"五连尾下注号码至少5个";
                }else{
                    *alertString = @"五连肖下注号码至少5个";
                }
            }
        }
    }
    
    return hasConform;
}

-(BOOL)hasOverSelectedIndexPathMaxCountOfSection:(NSInteger)section
                                  atPlayKindName:(NSString *)playKindName
{
    BOOL hasOver = NO;
    NSInteger count = [self numberOfSelectedIndexPathOfSection:section];
    if ([playKindName isEqualToString:@"自选不中"]&&count>=11) {
        //选择6-11个
        hasOver = YES;
    }else if ([playKindName isEqualToString:@"连码"]) {
        //3中2:3-7 , 3全中:3-10 , 2全中:2-7 , 2中特:2-7 ,特串:2-7
        NSDictionary *playDetailInfo = self.contentPlayDetailList[section];
        NSInteger maxCount = [[playDetailInfo DWStringForKey:@"maxCount"] integerValue];
        if (count>=maxCount) {
            hasOver = YES;
        }
        
    }else if ([playKindName isEqualToString:@"合肖"]&&count>=11) {
        //选择6-11个
        hasOver = YES;
    }
    return hasOver;
}

#pragma mark- 判断投注内容是否符合投注规则

-(BOOL)hasBetAnyone
{
    BOOL hasBet = NO;
    NSArray *keys = [_selectedIndexPathMarkDic allKeys];
    for (NSString *key in keys) {
        NSString * markString = [_selectedIndexPathMarkDic DWStringForKey:key];
        if (markString.length>0) {
            hasBet = YES;
            break;
        }
    }
    return hasBet;
}

-(BOOL)betContentHasVerifyBetRule:(NSString **)alertString
{
    BOOL hasVerify = YES;
    NSArray *keys = [_selectedIndexPathMarkDic allKeys];
    NSDictionary *playInfo = self.menuPlayKindList[_selectedMenuIndex];
    NSString *playKindName = [playInfo DWStringForKey:@"playName"];
    for (NSString *key in keys) {
        hasVerify = [self hasConformToRuleSelectedIndexPathMaxCountOfSection:[key integerValue] atPlayKindName:playKindName alertString:&*alertString];
        if (hasVerify == NO) {
            break;
        }
    }
    return hasVerify;
}

#pragma mark- 标记选中选项相关逻辑

-(void)removeFirstSelectedOfSection:(NSInteger)section
{
    NSString *key = [NSString stringWithFormat:@"%ld",section];
    NSMutableString *markString =  [[NSMutableString alloc]initWithString:[_selectedIndexPathMarkDic DWStringForKey:key]];
    [markString deleteCharactersInRange:NSMakeRange(0, 1)];
    while (![markString hasPrefix:@"*"]) {
        [markString deleteCharactersInRange:NSMakeRange(0, 1)];
    }
    [markString deleteCharactersInRange:NSMakeRange(0, 1)];
    [_selectedIndexPathMarkDic setObject:markString forKey:key];
}

-(NSInteger)numberOfSelectedIndexPathOfSection:(NSInteger)section
{
    NSString *key = [NSString stringWithFormat:@"%ld",section];
    NSMutableString *markString =  [[NSMutableString alloc]initWithString:[_selectedIndexPathMarkDic DWStringForKey:key]];
    NSArray *list = [self selectedIndexPathComponentsSeparatedByString:markString];
    return list.count;
}

-(NSArray *)selectedIndexPathComponentsSeparatedByString:(NSString *)markString
{
    NSMutableString *mString = [[NSMutableString alloc]initWithString:markString];
    if (mString.length>1) {
        [mString deleteCharactersInRange:NSMakeRange(0, 1)];
        [mString deleteCharactersInRange:NSMakeRange(mString.length-1, 1)];
        NSRange range = [mString rangeOfString:@"**"];
        if (range.length>0) {
            return [mString componentsSeparatedByString:@"**"];
        }else{
            return @[mString];
        }
    }
    return [NSArray new];
}

-(NSDictionary *)selectedAllIndexsInfo
{
    NSArray *allkeys = [_selectedIndexPathMarkDic allKeys];
    if (allkeys.count>0) {
        
        NSMutableDictionary *allIndexs = [NSMutableDictionary new];
        for (int i = 0; i<allkeys.count; i++) {
            NSString *value = [_selectedIndexPathMarkDic objectForKey:allkeys[i]];
            NSArray *indexs = [self selectedIndexPathComponentsSeparatedByString:value];
            if (indexs.count>0) {
                [allIndexs setObject:indexs forKey:allkeys[i]];
            }
        }
        return allIndexs;
    }
    return [NSDictionary new];
}

-(void)addSelectedIndexPathToMarkSelectdString:(NSIndexPath *)indexPath
                                  offsetNumber:(NSInteger)number
{
    NSString *key = [NSString stringWithFormat:@"%ld",indexPath.section];
    NSMutableString *alreadyString =  [[NSMutableString alloc]initWithString:[_selectedIndexPathMarkDic DWStringForKey:key]];
    NSString *markString = [self convertIndexPathToMarkSelectedString:indexPath offsetNumber:number];
    [alreadyString appendString:markString];
    [_selectedIndexPathMarkDic setObject:alreadyString forKey:key];
}

-(void)deleteSelectedIndexPathToMarkSelectdString:(NSIndexPath *)indexPath
                                     offsetNumber:(NSInteger)number
{
    NSString *key = [NSString stringWithFormat:@"%ld",indexPath.section];
    NSMutableString *alreadyString =  [[NSMutableString alloc]initWithString:[_selectedIndexPathMarkDic DWStringForKey:key]];
    NSString *markString = [self convertIndexPathToMarkSelectedString:indexPath offsetNumber:number];
    NSRange range = [alreadyString rangeOfString:markString];
    if (range.length>0) {
        [alreadyString deleteCharactersInRange:range];
        [_selectedIndexPathMarkDic setObject:alreadyString forKey:key];
    }
}

-(NSString *)convertIndexPathToMarkSelectedString:(NSIndexPath *)indexPath
                                     offsetNumber:(NSInteger)number
{
    NSInteger index = indexPath.row*self.numberOfLineInRow+number;
    NSString *stringMark = [NSString stringWithFormat:@"*%ld*",index];
    return stringMark;
}

-(BOOL)hasSelectedIndexPath:(NSIndexPath *)indexPath
               offsetNumber:(NSInteger)number
{
    NSString *key = [NSString stringWithFormat:@"%ld",indexPath.section];
    NSString *alreadyString = [_selectedIndexPathMarkDic DWStringForKey:key];
    if (alreadyString.length == 0) {
        return NO;
    }else{
        
        NSString *markString = [self convertIndexPathToMarkSelectedString:indexPath offsetNumber:number];
        NSRange range = [alreadyString rangeOfString:markString];
        if (range.length>0) {
            return YES;
        }else{
            return NO;
        }
    }
}

#pragma mark- 处理投注确认界面和下注的信息



- (void)combine:(int)n index:(int)k temp:(NSString *)str selectedLetters:(NSArray *)selectedLetters baseBetInfo:(NSDictionary *)baseBetInfo betInfos:(NSMutableArray *)betInfos
{
    for(int i = n; i >= k; i--)
    {
        if(k > 1)
        {
            [self combine:i-1 index:k-1 temp:[NSString stringWithFormat:@"%@%@&",str,[selectedLetters objectAtIndex:selectedLetters.count-i]] selectedLetters:selectedLetters baseBetInfo:baseBetInfo betInfos:betInfos];
        }
        else
        {
            NSString *values = [NSString stringWithFormat:@"%@%@",str,[selectedLetters objectAtIndex:selectedLetters.count-i]];
            NSMutableDictionary *info = [[NSMutableDictionary alloc]initWithDictionary:baseBetInfo];
            [info setObject:values forKey:@"playNameValue"];
            [info setObject:[NSString stringWithFormat:@"%@:%@",[baseBetInfo DWStringForKey:@"playName"],values] forKey:@"playName"];
            [betInfos addObject:info];
        }
    }
}

#pragma mark- setter && getter

-(CPBuyLotteryForOfficailRuleAlertView *)officailRuleAlertView
{
    if (!_officailRuleAlertView) {
        _officailRuleAlertView = [CPBuyLotteryForOfficailRuleAlertView createViewFromNib];
    }
    return _officailRuleAlertView;
}

-(CPBuyLtyDetailOfficialPlayHeaderTitleView *)officailPlayHeaderView
{
    if (!_officailPlayHeaderView) {
        _officailPlayHeaderView = [CPBuyLtyDetailOfficialPlayHeaderTitleView createViewFromNib];
        [_officailPlayHeaderView addActionTarget:self selector:@selector(officailPlayHeaderViewAction)];
    }
    return _officailPlayHeaderView;
}

-(CPBuyLtyDetailOfficialCustomPlayContentView *)officialCustomPlayContentView
{
    if (!_officialCustomPlayContentView) {
        _officialCustomPlayContentView = [CPBuyLtyDetailOfficialCustomPlayContentView createViewFromNib];
    }
    return _officialCustomPlayContentView;
}

-(void)setChooseGfPlayIndexPath:(NSIndexPath *)chooseGfPlayIndexPath
{
    _chooseGfPlayIndexPath = chooseGfPlayIndexPath;
    NSArray *gfPlayDetailInfoList = [self gfPlayDetailInfoListByIndex:_selectedMenuIndex playName:NULL];
    NSDictionary *playDetailInfo = gfPlayDetailInfoList[_chooseGfPlayIndexPath.section];
    NSArray *gfMinPlayInfoList = [playDetailInfo DWArrayForKey:@"play"];
    NSDictionary *gfMinPlayInfo = gfMinPlayInfoList[_chooseGfPlayIndexPath.row];
    _chooseGfPlayInfo = gfMinPlayInfo;
    [CPBuyLotteryManager shareManager].currentOfficailPlayType = [_chooseGfPlayInfo DWStringForKey:@"type"];
    [self cleanChooseAction];
    
    //刷新界面
    [_menuTableView reloadData];
    [self reloadCellUITypeAndData];
    [_contentTableView reloadData];
    [self reloadTableHeaderView];
    [self reloadBottonView];
    
}

-(CPBuyLtyDetailOfficialPlayTitleView *)officailPlayTitleView
{
    if (!_officailPlayTitleView) {
        _officailPlayTitleView = [CPBuyLtyDetailOfficialPlayTitleView createViewFromNib];
        [_officailPlayTitleView addActionTarget:self action:@selector(officailPlayTitleViewClickAction)];
    }
    return _officailPlayTitleView;
}

-(CPBuyLtyDetailOfficialPlayChooseView *)officailPlayChooseView
{
    if (!_officailPlayChooseView) {
        _officailPlayChooseView = [CPBuyLtyDetailOfficialPlayChooseView createViewFromNib];
    }
    return _officailPlayChooseView;
}

-(CPBuyLtyRightButtonItemSortView *)rightBarItemSortView
{
    if (!_rightBarItemSortView) {
        _rightBarItemSortView = [CPBuyLtyRightButtonItemSortView createViewFromNib];
        _rightBarItemSortView.delegate = self;
        [self.view addSubview: _rightBarItemSortView];
    }
    [self.view bringSubviewToFront:_rightBarItemSortView];
    return _rightBarItemSortView;
}

-(NSArray *)lhcNumberPlayInfoList
{
    if (!_lhcNumberPlayInfoList) {
        NSMutableArray *mtList = [NSMutableArray new];
        for (int i = 1; i<50; i++) {
            NSMutableDictionary *info = [NSMutableDictionary new];
            [info setObject:[NSString stringWithFormat:@"%d",i] forKey:@"playName"];
            [mtList addObject:info];
        }
        _lhcNumberPlayInfoList = mtList;
    }
    return _lhcNumberPlayInfoList;
}

-(NSInteger)numberOfLineInRow
{
    
    return _numberOfRowsInSection==0?1:_numberOfRowsInSection;
}

-(void)setSelectedMenuIndex:(NSInteger)selectedMenuIndex
{
    _selectedMenuIndex = selectedMenuIndex;
    if (_isOfficailPlay) {
        //选择官方玩法
        self.chooseGfPlayIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [CPBuyLotteryManager shareManager].currentPlayKindDes = @"";
    }else{
        
        NSDictionary *playInfo = self.menuPlayKindList[_selectedMenuIndex];
        self.playDetailList = [[CPBuyLotteryManager shareManager]loadBuyLtyCurrentPlayDetailListByPlayId:[playInfo DWStringForKey:@"playId"]];
        [CPBuyLotteryManager shareManager].currentPlayKindDes = [playInfo DWStringForKey:@"playName"];
        
        [_menuTableView reloadData];
        [self reloadCellUITypeAndData];
        [_contentTableView reloadData];
        [self reloadTableHeaderView];
        [self reloadBottonView];
    }
    
    
}
-(NSArray *)contentPlayDetailList
{
    if ([[CPBuyLotteryManager shareManager].currentPlayKindDes rangeOfString:@"合肖"].length > 0) {
        return self.heXiaoPlayDetailList;
    }else if ([[CPBuyLotteryManager shareManager].currentPlayKindDes rangeOfString:@"自选不中"].length > 0){
        return self.zxbzPlayDetailList;
    }else if ([[CPBuyLotteryManager shareManager].currentPlayKindDes rangeOfString:@"连码"].length > 0){
        return self.lianMaPlayDetailList;
    }
    
    return self.playDetailList;
}


-(NSArray *)heXiaoPlayDetailList
{
    
    if (!_heXiaoPlayDetailList) {
        
        NSMutableDictionary *heXiaoLotteryInfo = [NSMutableDictionary new];
        [heXiaoLotteryInfo setObject:@"合肖" forKey:@"name"];
        NSMutableArray *infos  =[NSMutableArray new];
        NSDictionary *sxNames = [[CPBuyLotteryManager shareManager]loadHlcSxNamesForNum:self.ltyNum];
        for (int i=0; i<sxNames.allKeys.count; i++) {
            NSString *key = sxNames.allKeys[i];
            NSString *name = [sxNames objectForKey:key];
            name = [name stringByReplacingOccurrencesOfString:@"," withString:@" "];
            NSMutableDictionary *info = [NSMutableDictionary new];
            [info setObject:key forKey:@"playName"];
            [info setObject:name forKey:@"bonus"];
            [info setObject:@"1" forKey:@"useBonus"];
            [infos addObject:info];
        }
        
        [heXiaoLotteryInfo setObject:infos forKey:@"list"];
        _heXiaoPlayDetailList = @[heXiaoLotteryInfo];
    }
    return _heXiaoPlayDetailList;
}

-(NSArray *)zxbzPlayDetailList
{
    if (!_zxbzPlayDetailList) {
        //选择6-11个
        NSMutableDictionary *zxbzLotteryInfo = [NSMutableDictionary new];
        [zxbzLotteryInfo setObject:@"自选不中" forKey:@"name"];
        NSArray *infos  = [[NSArray alloc]initWithArray:self.lhcNumberPlayInfoList];
        [zxbzLotteryInfo setObject:infos forKey:@"list"];
        _zxbzPlayDetailList = @[zxbzLotteryInfo];
    }
    return _zxbzPlayDetailList;
}

-(NSMutableArray *)lianMaPlayDetailList
{
    if (!_lianMaPlayDetailList) {
        //3中2:3-7 , 3全中:3-10 , 2全中:2-7 , 2中特:2-7 ,特串:2-7
        self.lianMaPlayDetailList = [NSMutableArray new];
        NSArray *playDetailList = self.playDetailList;
        
        for (int i = 0; i<playDetailList.count; i++) {
            NSDictionary *playInfo = playDetailList[i];
            NSString *name = [playInfo DWStringForKey:@"name"];
            NSArray *playList = [playInfo DWArrayForKey:@"list"];
            NSMutableDictionary *newPlayInfo = [NSMutableDictionary new];
            NSMutableString *newName = [[NSMutableString alloc]initWithString:[NSString stringWithFormat:@"%@(",name]];
            for (NSDictionary *info in playList) {
                NSString *bonus = [[[CPBuyLotteryManager shareManager]fetchDoubleFacePlayBounsByPlayId:[info DWStringForKey:@"playId"]]jdM];
                NSString *playId = [info DWStringForKey:@"playId"];
                if ([[[[CPBuyLotteryManager shareManager]fetchDoubleFacePlayBounsByPlayId:[newPlayInfo DWStringForKey:@"playId"]]jdM]doubleValue]<[bonus doubleValue]) {
                    [newPlayInfo setObject:bonus forKey:@"bonus"];
                    [newPlayInfo setObject:playId forKey:@"playId"];
                }
                [newName appendString:[NSString stringWithFormat:@"%@/",bonus]];
            }
            [newName deleteCharactersInRange:NSMakeRange(newName.length-1, 1)];
            [newName appendString:@")"];
            [newPlayInfo setObject:newName forKey:@"name"];
            [newPlayInfo setObject:name forKey:@"playName"];
            [newPlayInfo setObject:self.lhcNumberPlayInfoList forKey:@"list"];
            if ([name rangeOfString:@"三中二"].length>0) {
                [newPlayInfo setObject:@"3" forKey:@"minCount"];
                [newPlayInfo setObject:@"10" forKey:@"maxCount"];
            }else if ([name rangeOfString:@"三全中"].length>0) {
                [newPlayInfo setObject:@"3" forKey:@"minCount"];
                [newPlayInfo setObject:@"10" forKey:@"maxCount"];
            }else if ([name rangeOfString:@"二全中"].length>0||[name rangeOfString:@"二中特"].length>0||[name rangeOfString:@"特串"].length>0) {
                [newPlayInfo setObject:@"2" forKey:@"minCount"];
                [newPlayInfo setObject:@"7" forKey:@"maxCount"];
            }
            [self.lianMaPlayDetailList addObject:newPlayInfo];
        }
    }
    return _lianMaPlayDetailList;
}



-(CPLotteryResultType)currentLtyResultType
{
    NSString *resultTypeString = self.typeCode;
    CPLotteryResultType resultType = CPLotteryResultTypeByTypeString(resultTypeString);
    return resultType;
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


-(void)buildBottomView
{
    CGFloat bottomViewHeight = 40.0f;
    _bottomView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:_bottomView];
    kWeakSelf
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        kStrongSelf
        make.bottom.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.mas_equalTo(bottomViewHeight);
    }];
    
    [self reloadBottonView];
}

-(void)reloadBottonView
{
    [_bottomView removeAllSubviews];
    CGFloat itemWidth = _isOfficailPlay?kScreenWidth/3.0f:kScreenWidth/2.0f;
    
    UIButton *cleanChooseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cleanChooseButton setBackgroundImage:[UIImage imageWithColor:kCOLOR_R_G_B_A(20, 28, 44, 1)] forState:UIControlStateNormal];
    [cleanChooseButton setBackgroundImage:[UIImage imageWithColor:kCOLOR_R_G_B_A(26, 62, 95, 1)] forState:UIControlStateHighlighted];
    [cleanChooseButton setTitle:@"清空选项" forState:UIControlStateNormal];
    cleanChooseButton.titleLabel.font = [UIFont systemFontOfSize:18.0f];
    [cleanChooseButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cleanChooseButton addTarget:self action:@selector(cleanChooseAction) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:cleanChooseButton];
    
    UILabel *cleanBtnLine = [[UILabel alloc]init];
    cleanBtnLine.backgroundColor = kCOLOR_R_G_B_A(204, 204, 204, 1);
    [cleanChooseButton addSubview:cleanBtnLine];
    
    [cleanChooseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_bottomView);
        make.left.equalTo(_bottomView);
        make.top.equalTo(_bottomView);
        make.width.mas_equalTo(itemWidth);
    }];
    [cleanBtnLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(cleanChooseButton);
        make.right.equalTo(cleanChooseButton);
        make.top.equalTo(cleanChooseButton);
        make.width.mas_equalTo(kGlobalLineWidth);
    }];
    
    if (_isOfficailPlay) {
        
        UIButton *officailRuleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [officailRuleButton setBackgroundImage:[UIImage imageWithColor:kCOLOR_R_G_B_A(20, 28, 44, 1)] forState:UIControlStateNormal];
        [officailRuleButton setBackgroundImage:[UIImage imageWithColor:kCOLOR_R_G_B_A(26, 62, 95, 1)] forState:UIControlStateHighlighted];
        [officailRuleButton setTitle:@"玩法说明" forState:UIControlStateNormal];
        officailRuleButton.titleLabel.font = [UIFont systemFontOfSize:18.0f];
        [officailRuleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [officailRuleButton addTarget:self action:@selector(officailRuleButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:officailRuleButton];
        
        UILabel *officailBtnLine = [[UILabel alloc]init];
        officailBtnLine.backgroundColor = kCOLOR_R_G_B_A(204, 204, 204, 1);
        [officailRuleButton addSubview:officailBtnLine];
        
        
        [officailRuleButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_bottomView);
            make.left.equalTo(cleanChooseButton.mas_right);
            make.top.equalTo(_bottomView);
            make.width.mas_equalTo(itemWidth);
        }];
        
        [officailBtnLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(officailRuleButton);
            make.right.equalTo(officailRuleButton);
            make.top.equalTo(officailRuleButton);
            make.width.mas_equalTo(kGlobalLineWidth);
        }];
    }
    
    
    UIButton *betButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [betButton setBackgroundImage:[UIImage imageWithColor:kCOLOR_R_G_B_A(193, 38, 33, 1)] forState:UIControlStateNormal];
    [betButton setBackgroundImage:[UIImage imageWithColor:kCOLOR_R_G_B_A(249, 53, 47, 1)] forState:UIControlStateHighlighted];
    [betButton setTitle:@"投注" forState:UIControlStateNormal];
    betButton.titleLabel.font = [UIFont systemFontOfSize:18.0f];
    [betButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [betButton addTarget:self action:@selector(betAction) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:betButton];
    
    [betButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_bottomView);
        make.right.equalTo(_bottomView);
        make.top.equalTo(_bottomView);
        make.width.mas_equalTo(itemWidth);
        
    }];
    
}


-(void)buildHeaderView
{
    
    if (self.currentLtyResultType == CPLotteryResultForPK10 || self.currentLtyResultType == CPLotteryResultForXYFT) {
        
        _headerView = [CPBuyLotteryForPkshiHeaderView createViewFromNib];
        CPBuyLotteryForPkshiHeaderView *scheaderView = (CPBuyLotteryForPkshiHeaderView*)_headerView;
        scheaderView.isSaiche = [self.ltyName rangeOfString:@"飞艇"].length>0?NO:YES;
        
    }else{
        
        _headerView = [CPBuyLotteryForJssscHeaderView createViewFromNib];
    }
    
    _headerView.actionDelegate = self;
    _headerView.frame = CGRectMake(0, 0, self.view.width, (self.view.width*150.0f)/375.0f);
    [self.view addSubview:_headerView];
    [_headerView loadDataByPlayInfo:self.headInfo];
    
}



-(void)buildContentView
{
    
    _contentBgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"buylty_content_bg_all"]];
    _contentBgView.userInteractionEnabled = YES;
    [self.view addSubview:_contentBgView];
    
    [_contentBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_bottomView.mas_top);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(_headerView.mas_bottom);
    }];
    
    
    _menuTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    _menuTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _menuTableView.delegate = self;
    _menuTableView.dataSource = self;
    _menuTableView.backgroundColor = kCOLOR_R_G_B_A(243, 243, 243, 1);
    _menuTableView.estimatedSectionFooterHeight = 0.0f;
    [_menuTableView registerNib:[UINib nibWithNibName:NSStringFromClass([CPBuyLotteryForMenuCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([CPBuyLotteryForMenuCell class])];
    [_contentBgView addSubview:_menuTableView];
    
    [_menuTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_contentBgView.mas_top);
        make.bottom.equalTo(_contentBgView.mas_bottom);
        make.left.equalTo(_contentBgView.mas_left);
        make.width.mas_equalTo(108);
    }];
    
    
    _contentTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _contentTableView.backgroundColor = [UIColor whiteColor];
    _contentTableView.delegate = self;
    _contentTableView.dataSource = self;
    _contentTableView.estimatedSectionFooterHeight = 0.0f;
    
    [_contentBgView addSubview:_contentTableView];
    
    [_contentTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_contentBgView.mas_top);
        make.bottom.equalTo(_contentBgView.mas_bottom);
        make.right.equalTo(_contentBgView.mas_right);
        make.left.equalTo(_menuTableView.mas_right);
    }];
    _contentTbHeaderView = [[UIView alloc]init];
    _contentTbHeaderView.backgroundColor = [UIColor clearColor];
    _contentTableView.tableHeaderView = _contentTbHeaderView;
    _contentTableView.autoresizesSubviews = YES;
    
    
    [_contentTableView registerClass:[CPBuyLotteryForContentSectionHeaderView class] forHeaderFooterViewReuseIdentifier:NSStringFromClass([CPBuyLotteryForContentSectionHeaderView class])];
    
    
    
    [_contentTableView registerNib:[UINib nibWithNibName:NSStringFromClass([CPBuyLotteryForOfficailBallContentCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([CPBuyLotteryForOfficailBallContentCell class])];
    
    [_contentTableView registerClass:[CPBuyLtyContentCell class] forCellReuseIdentifier:NSStringFromClass([CPBuyLtyContentCell class])];
    
    
    [_contentTableView registerNib:[UINib nibWithNibName:NSStringFromClass([CPBuyLotteryForContentCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([CPBuyLotteryForContentCell class])];
    
    [_contentTableView registerNib:[UINib nibWithNibName:NSStringFromClass([CPBuyLotteryForTypeTwoContentCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([CPBuyLotteryForTypeTwoContentCell class])];
    kWeakSelf
    _contentTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        kStrongSelf
        [self queryLtyResult];
        [self queryBalanceInfo];
    }];
    
}

-(void)changeContentTableViewHeaerView:(UIView *)tableViewHeaderView
{
    [_contentTbHeaderView removeAllSubviews];
    if (tableViewHeaderView) {
        
        _contentTbHeaderView.frame = CGRectMake(0, 0, _contentTableView.width, tableViewHeaderView.height);
        tableViewHeaderView.width = _contentTbHeaderView.width;
        [_contentTbHeaderView addSubview:tableViewHeaderView];
        [_contentTableView setTableHeaderView:_contentTbHeaderView];
        
    }else{
        
        _contentTbHeaderView.frame = CGRectMake(0, 0, _contentTableView.width, 0.1);
        [_contentTableView setTableHeaderView:_contentTbHeaderView];
    }
    
    for (UIView *view in _contentTbHeaderView.subviews) {
        NSLog(@"%@",view);
    }
}

-(void)reloadTableHeaderView
{
    //officailPlayHeaderView
    if (_isOfficailPlay) {
        NSString *type =  [_chooseGfPlayInfo DWStringForKey:@"type"];
        NSString *name = [_chooseGfPlayInfo DWStringForKey:@"name"];
        NSString *bonus = [self allOfficailPlayBonusByPlayId:[_chooseGfPlayInfo DWStringForKey:@"playId"]];
        
        if ([type isEqualToString:@"ball"]) {
            [self.officailPlayHeaderView addTitle:name rate:bonus hiddenRateView:NO];
            [self changeContentTableViewHeaerView:self.officailPlayHeaderView];
            
        }else if ([type isEqualToString:@"singleball"]) {
            [self.officailPlayHeaderView addTitle:name rate:bonus hiddenRateView:YES];
            [self changeContentTableViewHeaerView:self.officailPlayHeaderView];
            
        }else if ([type isEqualToString:@"input"]) {
            if (self.officailPlayHeaderView.superview) {
                [self.officailPlayHeaderView removeFromSuperview];
            }
            UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _contentTableView.width, _contentTableView.height)];
            [self.officailPlayHeaderView addTitle:name rate:bonus hiddenRateView:NO];
            self.officailPlayHeaderView.frame = CGRectMake(0, 0, headerView.width, self.officailPlayHeaderView.height);
            self.officialCustomPlayContentView.frame = CGRectMake(0, self.officailPlayHeaderView.bottomY, headerView.width, headerView.height -self.officailPlayHeaderView.bottomY);
            
            [headerView addSubview:self.officailPlayHeaderView];
            [headerView addSubview:self.officialCustomPlayContentView];
            
            NSDictionary *remark = [_chooseGfPlayInfo DWDictionaryForKey:@"remark"];
            
            [self.officialCustomPlayContentView addIntroText:[remark DWStringForKey:@"intro"] placeHolder:[remark DWStringForKey:@"placeholder"] attentionText:[remark DWStringForKey:@"warn"]];
            
            [self changeContentTableViewHeaerView:headerView];
            
            
        }else{
            
            [self changeContentTableViewHeaerView:nil];
            
        }
    }else{
        
        
        [self changeContentTableViewHeaerView:nil];
    }
}

#pragma mark-

-(NSInteger)officailPlayNumberOfSection
{
    NSString *type =  [_chooseGfPlayInfo DWStringForKey:@"type"];
    if ([type isEqualToString:@"ball"]) {
        return  [_chooseGfPlayInfo DWArrayForKey:@"display"].count;
    }else if ([type isEqualToString:@"input"]){
        return 0;
    }else if ([type isEqualToString:@"singleball"]){
        return [_chooseGfPlayInfo DWArrayForKey:@"display"].count;
    }
    return 0;
}

-(NSInteger)officailPlayNumberOfRowsInSection:(NSInteger)section
{
    NSString *type =  [_chooseGfPlayInfo DWStringForKey:@"type"];
    if ([type isEqualToString:@"ball"]) {
        NSArray *display = [_chooseGfPlayInfo DWArrayForKey:@"display"];
        NSDictionary *info = display[section];
        NSInteger rows = [[info DWStringForKey:@"max"]intValue]-[[info DWStringForKey:@"min"]intValue]+1;
        NSInteger count = rows/self.numberOfLineInRow;
        count = rows%self.numberOfLineInRow==0?count:count+1;
        return count;
    }else if ([type isEqualToString:@"input"]){
        return 0;
    }else if ([type isEqualToString:@"singleball"]){
        NSArray *display = [_chooseGfPlayInfo DWArrayForKey:@"display"];
        NSDictionary *info = display[section];
        NSArray *single = [info DWArrayForKey:@"single"];
        NSInteger count = single.count/self.numberOfLineInRow;
        count = single.count%self.numberOfLineInRow==0?count:count+1;
        return count;
    }
    return 0;
}

#pragma mark- UITableViewDelegate && Datasource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _menuTableView) {
        return _isOfficailPlay?_gfNameList.count:self.menuPlayKindList.count;
    }
    if (_isOfficailPlay) {
        return [self officailPlayNumberOfRowsInSection:section];
    }
    NSDictionary *playDetailInfo = self.contentPlayDetailList[section];
    NSArray *playDetailList = [playDetailInfo DWArrayForKey:@"list"];
    NSInteger count = playDetailList.count%self.numberOfLineInRow==0?playDetailList.count/self.numberOfLineInRow:playDetailList.count/self.numberOfLineInRow+1;
    return count;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == _menuTableView) {
        return 1;
    }
    if (_isOfficailPlay) {
        return [self officailPlayNumberOfSection];
    }
    return self.contentPlayDetailList.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _menuTableView) {
        return 50.0f;
    }
    CGFloat height = [CPBuyLtyContentCell cellHeightByShape:_currentItemShape layoutType:_currentCellLayoutType isIncludeGap:YES];
    return height;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == _menuTableView) {
        return 7.0f;
    }
    return 30.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _menuTableView) {
        
        CPBuyLotteryForMenuCell *cell = [tableView dequeueReusableCellWithIdentifier: NSStringFromClass([CPBuyLotteryForMenuCell class])];
        NSString *name = @"";
        if (_isOfficailPlay) {
            NSDictionary *playInfo = _gfNameList[indexPath.row];
            name = [playInfo DWStringForKey:@"name"];
            
        }else{
            
            NSDictionary *playInfo = self.menuPlayKindList[indexPath.row];
            name = [playInfo DWStringForKey:@"playName"];
        }
        cell.name = name;
        cell.hasSelected = _selectedMenuIndex == indexPath.row?YES:NO;
        return cell;
    }else{
        
        CPBuyLtyContentCell *cell = [tableView dequeueReusableCellWithIdentifier: NSStringFromClass([CPBuyLtyContentCell class])];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.width = tableView.width;
        if (_isOfficailPlay) {
            NSString *type =  [_chooseGfPlayInfo DWStringForKey:@"type"];
            if ([type isEqualToString:@"ball"]){
                
                NSArray *display = [_chooseGfPlayInfo DWArrayForKey:@"display"];
                NSDictionary *info = display[indexPath.section];
                NSInteger initIndex = indexPath.row*self.numberOfLineInRow+[[info DWStringForKey:@"min"]integerValue];
                NSInteger maxValue = [[info DWStringForKey:@"max"]intValue];
                NSInteger finalMaxValue = initIndex+self.numberOfLineInRow-1;
                finalMaxValue = finalMaxValue>maxValue?maxValue:finalMaxValue;
                NSMutableArray *playInfoList = [NSMutableArray new];
                NSMutableArray *selectedList = [NSMutableArray new];
                int index = 0;
                for (NSInteger i = initIndex; i<=finalMaxValue; i++) {
                    NSDictionary *info = [NSDictionary dictionaryWithObject:@(i) forKey:@"playName"];
                    NSString *selected = [self hasSelectedIndexPath:indexPath offsetNumber:index]?@"1":@"0";
                    [playInfoList addObject:info];
                    [selectedList addObject:selected];
                    index += 1;
                }
                [cell addPlayInfoList:playInfoList selectedList:selectedList shape:_currentItemShape layoutType:_currentCellLayoutType delegate:self atIndexPath:indexPath maxNumberOfSection:self.numberOfLineInRow];
            }else if ([type isEqualToString:@"singleball"]){
                
                NSInteger initIndex = indexPath.row*self.numberOfLineInRow;
                NSArray *display = [_chooseGfPlayInfo DWArrayForKey:@"display"];
                NSDictionary *info = display[indexPath.section];
                NSArray *single = [info DWArrayForKey:@"single"];
                
                NSInteger finalMaxValue = initIndex+self.numberOfLineInRow-1;
                finalMaxValue = finalMaxValue>=(single.count-1)?single.count-1:finalMaxValue;
                NSMutableArray *playInfoList = [NSMutableArray new];
                NSMutableArray *selectedList = [NSMutableArray new];
                int index = 0;
                for (NSInteger i = initIndex; i<=finalMaxValue; i++) {
                    NSDictionary *existInfo = single[i];
                    
                    NSDictionary *info = [NSDictionary dictionaryWithObjectsAndKeys:[existInfo DWStringForKey:@"name"],@"playName",[self officailPlayBonusByPlayId:[existInfo DWStringForKey:@"number"]],@"gfBonus",[existInfo DWStringForKey:@"number"],@"playId", nil];
                    NSString *selected = [self hasSelectedIndexPath:indexPath offsetNumber:index]?@"1":@"0";
                    [playInfoList addObject:info];
                    [selectedList addObject:selected];
                    index += 1;
                }
                
                [cell addPlayInfoList:playInfoList selectedList:selectedList shape:_currentItemShape layoutType:_currentCellLayoutType delegate:self atIndexPath:indexPath maxNumberOfSection:self.numberOfLineInRow];
                
            }
            
            
        }else{
            
            NSDictionary *playDetailInfo = self.contentPlayDetailList[indexPath.section];
            NSArray *playDetailList = [playDetailInfo DWArrayForKey:@"list"];
            NSMutableArray *lisInfos = [NSMutableArray new];
            NSMutableArray *hasSelectedList = [NSMutableArray new];
            NSInteger startIndex = indexPath.row*self.numberOfLineInRow;
            for (int i =0; i<self.numberOfLineInRow; i++) {
                NSInteger currentIndex= startIndex +i;
                if (playDetailList.count>currentIndex) {
                    NSDictionary *playInfo = [playDetailList objectAtIndex:currentIndex];
                    [lisInfos addObject:playInfo];
                    NSString *hasSelected = [self hasSelectedIndexPath:indexPath offsetNumber:i]?@"1":@"0";
                    [hasSelectedList addObject:hasSelected];
                }
            }
            [cell addPlayInfoList:lisInfos selectedList:hasSelectedList shape:_currentItemShape layoutType:_currentCellLayoutType delegate:self atIndexPath:indexPath maxNumberOfSection:self.numberOfLineInRow];
            
        }
        return cell;
        
        if (_isOfficailPlay) {
            
            NSString *type =  [_chooseGfPlayInfo DWStringForKey:@"type"];
            if ([type isEqualToString:@"ball"]) {
                
                NSArray *display = [_chooseGfPlayInfo DWArrayForKey:@"display"];
                NSDictionary *info = display[indexPath.section];
                NSInteger initIndex = indexPath.row*self.numberOfLineInRow+[[info DWStringForKey:@"min"]integerValue];
                NSInteger maxValue = [[info DWStringForKey:@"max"]intValue];
                CPBuyLotteryForOfficailBallContentCell *cell = [tableView dequeueReusableCellWithIdentifier: NSStringFromClass([CPBuyLotteryForOfficailBallContentCell class])];
                cell.width = tableView.width;
                
                cell.indexPath = indexPath;
                cell.selectedLeftItem = [self hasSelectedIndexPath:indexPath offsetNumber:0];
                cell.selectedCenterItem = [self hasSelectedIndexPath:indexPath offsetNumber:1];
                cell.selectedRightItem = [self hasSelectedIndexPath:indexPath offsetNumber:2];
                NSDictionary *leftInfo = [NSDictionary dictionaryWithObject:@(initIndex) forKey:@"playName"];
                NSDictionary *centerInfo = [NSDictionary dictionaryWithObject:@(initIndex+1) forKey:@"playName"];
                NSDictionary *rightInfo = [NSDictionary dictionaryWithObject:@(initIndex+2) forKey:@"playName"];
                cell.leftItemPlayInfo = leftInfo;
                cell.centerItemPlayInfo = initIndex+1>maxValue?nil:centerInfo;
                cell.rightItemPlayInfo = initIndex+2>maxValue?nil:rightInfo;
                cell.delegate = self;
                return cell;
                
            }else if ([type isEqualToString:@"singleball"]){
                CPBuyLotteryForContentCell *cell = [tableView dequeueReusableCellWithIdentifier: NSStringFromClass([CPBuyLotteryForContentCell class])];
                cell.width = tableView.width;
                NSInteger initIndex = indexPath.row*self.numberOfLineInRow;
                
                NSArray *display = [_chooseGfPlayInfo DWArrayForKey:@"display"];
                NSDictionary *info = display[indexPath.section];
                NSArray *single = [info DWArrayForKey:@"single"];
                NSDictionary *leftSingleInfo = single[initIndex];
                NSDictionary *rightSingleInfo = single.count>initIndex+1?single[initIndex+1]:nil;
                NSDictionary *leftInfo = [NSDictionary dictionaryWithObjectsAndKeys:[leftSingleInfo DWStringForKey:@"name"],@"playName",[self officailPlayBonusByPlayId:[leftSingleInfo DWStringForKey:@"number"]],@"gfBonus",[leftSingleInfo DWStringForKey:@"number"],@"playId", nil];
                NSDictionary *rightInfo = rightSingleInfo?[NSDictionary dictionaryWithObjectsAndKeys:[rightSingleInfo DWStringForKey:@"name"],@"playName",[self officailPlayBonusByPlayId:[rightSingleInfo DWStringForKey:@"number"]],@"gfBonus",[leftSingleInfo DWStringForKey:@"number"],@"playId",nil]:nil;
                cell.selectedLeftItem = [self hasSelectedIndexPath:indexPath offsetNumber:0];
                cell.selectedRightItem = [self hasSelectedIndexPath:indexPath offsetNumber:1];
                cell.leftItemPlayInfo = leftInfo;
                cell.rightItemPlayInfo = rightInfo;
                cell.indexPath = indexPath;
                cell.delegate =self;
                
                //                NSString *playName = [playInfo DWStringForKey:@"playName"];
                //                NSString *bonus = [[playInfo DWStringForKey:@"bonus"]jdM];
                
                return cell;
            }
            return [UITableViewCell new];
        }
        if ([[CPBuyLotteryManager shareManager].currentPlayKindDes isEqualToString:@"自选不中"]||[[CPBuyLotteryManager shareManager].currentPlayKindDes isEqualToString:@"连码"]) {
            CPBuyLotteryForTypeTwoContentCell *cell = [tableView dequeueReusableCellWithIdentifier: NSStringFromClass([CPBuyLotteryForTypeTwoContentCell class])];
            cell.width = tableView.width;
            cell.delegate = self;
            cell.indexPath = indexPath;
            NSDictionary *playDetailInfo = self.contentPlayDetailList[indexPath.section];
            NSArray *playDetailList = [playDetailInfo DWArrayForKey:@"list"];
            NSMutableArray *lisInfos = [NSMutableArray new];
            NSMutableArray *hasSelectedList = [NSMutableArray new];
            NSInteger startIndex = indexPath.row*self.numberOfLineInRow;
            for (int i =0; i<self.numberOfLineInRow; i++) {
                NSInteger currentIndex= startIndex +i;
                if (playDetailList.count>currentIndex) {
                    NSDictionary *playInfo = [playDetailList objectAtIndex:currentIndex];
                    [lisInfos addObject:playInfo];
                    NSString *hasSelected = [self hasSelectedIndexPath:indexPath offsetNumber:i]?@"1":@"0";
                    [hasSelectedList addObject:hasSelected];
                }
            }
            
            [cell addLtyInfos:lisInfos selectedList:hasSelectedList];
            return cell;
            
        }else{
            
            CPBuyLotteryForContentCell *cell = [tableView dequeueReusableCellWithIdentifier: NSStringFromClass([CPBuyLotteryForContentCell class])];
            cell.width = tableView.width;
            NSDictionary *playDetailInfo = self.contentPlayDetailList[indexPath.section];
            NSArray *playDetailList = [playDetailInfo DWArrayForKey:@"list"];
            NSInteger leftItemIndex = indexPath.row*2;
            NSDictionary *leftLryInfo = [playDetailList objectAtIndex:leftItemIndex];
            NSInteger rightItemIndex = leftItemIndex+1;
            NSDictionary *rightLryInfo = playDetailList.count>rightItemIndex?[playDetailList objectAtIndex:rightItemIndex]:nil;
            cell.selectedLeftItem = [self hasSelectedIndexPath:indexPath offsetNumber:0];
            cell.selectedRightItem = [self hasSelectedIndexPath:indexPath offsetNumber:1];
            cell.leftItemPlayInfo = leftLryInfo;
            cell.rightItemPlayInfo = rightLryInfo;
            cell.indexPath = indexPath;
            cell.delegate =self;
            return cell;
        }
        
    }
    return nil;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView == _menuTableView) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.width, 0)];
        view.backgroundColor = kCOLOR_R_G_B_A(243, 243, 243, 1);
        return view;
    }
    CPBuyLotteryForContentSectionHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([CPBuyLotteryForContentSectionHeaderView class])];
    headerView.backgroundColor = [UIColor clearColor];
    
    NSString *name = @"";
    if (_isOfficailPlay) {
        NSString *type =  [_chooseGfPlayInfo DWStringForKey:@"type"];
        if ([type isEqualToString:@"ball"]||[type isEqualToString:@"singleball"]) {
            
            NSArray *display = [_chooseGfPlayInfo DWArrayForKey:@"display"];
            NSDictionary *info = display[section];
            name = [info DWStringForKey:@"name"];
            
        }else{
            
            return nil;
        }
    }else{
        NSDictionary *playDetailInfo = self.contentPlayDetailList[section];
        name = [playDetailInfo DWStringForKey:@"name"];
    }
    headerView.name = name;
    headerView.isShowTopLine = section==0?YES:NO;
    return headerView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _menuTableView) {
        if (_isOfficailPlay) {
            
            
            if (self.selectedMenuIndex!=indexPath.row) {
                [self cleanSelectedBetRecord];
                self.selectedMenuIndex = indexPath.row;
                
            }else{
                NSString *name = [NSString new];
                NSArray *gfPlayDetailInfoList = [self gfPlayDetailInfoListByIndex:indexPath.row playName:&name];
                [CPBuyLtyOfficialPlayOptionsSelectedView showOnView:self.navigationController.view menuIndex:indexPath.row withTitle:name dataList:gfPlayDetailInfoList selectedItemId:[_chooseGfPlayInfo DWStringForKey:@"playId"] delegate:self];
            }
            
        }else{
            
            if (indexPath.row != _selectedMenuIndex) {
                [self cleanSelectedBetRecord];
                self.selectedMenuIndex = indexPath.row;
            }
        }
        
        
    }
}

#pragma mark- CPBuyLtyBetContentProtocol

-(void)cpBuyLtyBetContentSelectedIndexPath:(NSIndexPath *)indexPath
                              offsetNumber:(NSInteger)number
{
    
    
    if ([self hasSelectedIndexPath:indexPath offsetNumber:number]) {
        [self deleteSelectedIndexPathToMarkSelectdString:indexPath offsetNumber:number];
    }else{
        if (_isOfficailPlay) {
            
            [self officailCheckSelectedIndexPath:indexPath offsetNumber:number];
            [self addSelectedIndexPathToMarkSelectdString:indexPath offsetNumber:number];
            
        }else{
            
            NSDictionary *playInfo = self.menuPlayKindList[_selectedMenuIndex];
            NSString *playKindName = [playInfo DWStringForKey:@"playName"];
            if ([self hasOverSelectedIndexPathMaxCountOfSection:indexPath.section atPlayKindName:playKindName]) {
                [self removeFirstSelectedOfSection:indexPath.section];
            }
            [self addSelectedIndexPathToMarkSelectdString:indexPath offsetNumber:number];
        }
        
    }
    [_contentTableView reloadData];
    
}

-(void)officailCheckSelectedIndexPath:(NSIndexPath *)indexPath
                         offsetNumber:(NSInteger)number
{
    CPLotteryResultType resultType = CPLotteryResultTypeByTypeString(self.typeCode);
    
    if (resultType == CPLotteryResultForSSC) {
        if ([[_chooseGfPlayInfo DWStringForKey:@"name"]isEqualToString:@"组选包胆"]) {
            _selectedIndexPathMarkDic = [NSMutableDictionary new];
        }
    }else if (resultType == CPLotteryResultForK3){
        NSString *playName = [_chooseGfPlayInfo DWStringForKey:@"name"];
        
        if ([playName isEqualToString:@"三不同号"]) {
            if (indexPath.section == 0) {
                //胆码
                if ([self numberOfSelectedIndexPathOfSection:indexPath.section]==2) {
                    [self removeFirstSelectedOfSection:indexPath.section];
                }
                NSIndexPath *otherIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:1];
                if ([self hasSelectedIndexPath:otherIndexPath offsetNumber:number]) {
                    [self deleteSelectedIndexPathToMarkSelectdString:otherIndexPath offsetNumber:number];
                }
                
            }else if(indexPath.section == 1) {
                NSIndexPath *otherIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:0];
                if ([self hasSelectedIndexPath:otherIndexPath offsetNumber:number]) {
                    [self deleteSelectedIndexPathToMarkSelectdString:otherIndexPath offsetNumber:number];
                }
            }
        }else if ([playName isEqualToString:@"二不同号"]){
            if (indexPath.section == 0) {
                //胆码
                if ([self numberOfSelectedIndexPathOfSection:indexPath.section]==1) {
                    [self removeFirstSelectedOfSection:indexPath.section];
                }
                NSIndexPath *otherIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:1];
                if ([self hasSelectedIndexPath:otherIndexPath offsetNumber:number]) {
                    [self deleteSelectedIndexPathToMarkSelectdString:otherIndexPath offsetNumber:number];
                }
                
            }else if(indexPath.section == 1) {
                NSIndexPath *otherIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:0];
                if ([self hasSelectedIndexPath:otherIndexPath offsetNumber:number]) {
                    [self deleteSelectedIndexPathToMarkSelectdString:otherIndexPath offsetNumber:number];
                }
            }
        }
    }else if(resultType == CPLotteryResultForE11X5){
        
        NSDictionary *playInfo = _gfNameList[_selectedMenuIndex];
        NSString *name = [playInfo DWStringForKey:@"name"];
        if ([name isEqualToString:@"三码"]||[name isEqualToString:@"二码"]||[name isEqualToString:@"任选胆拖"]) {
            NSString *playName = [_chooseGfPlayInfo DWStringForKey:@"name"];
            if ([playName isEqualToString:@"组选胆拖"]||[name isEqualToString:@"任选胆拖"]){
                
                if (indexPath.section == 0) {
                    //胆码
                    NSArray *display = [_chooseGfPlayInfo DWArrayForKey:@"display"];
                    NSDictionary *info = display[indexPath.section];
                    NSString *sectionName = [info DWStringForKey:@"name"];
                    NSInteger maxCount = 1;
                    NSArray *sectionNameList = [sectionName componentsSeparatedByString:@"|"];
                    if (sectionNameList.count>1) {
                        maxCount = [sectionNameList[1] integerValue];
                    }
                    if ([self numberOfSelectedIndexPathOfSection:indexPath.section]==maxCount) {
                        [self removeFirstSelectedOfSection:indexPath.section];
                    }
                    NSIndexPath *otherIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:1];
                    if ([self hasSelectedIndexPath:otherIndexPath offsetNumber:number]) {
                        [self deleteSelectedIndexPathToMarkSelectdString:otherIndexPath offsetNumber:number];
                    }
                    
                }else if(indexPath.section == 1) {
                    NSIndexPath *otherIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:0];
                    if ([self hasSelectedIndexPath:otherIndexPath offsetNumber:number]) {
                        [self deleteSelectedIndexPathToMarkSelectdString:otherIndexPath offsetNumber:number];
                    }
                }
            }
        }
    }
}

-(NSInteger)countOfficailPlaySelectedBetCount
{
    
    NSString *type =  [_chooseGfPlayInfo DWStringForKey:@"type"];
    NSMutableDictionary *selectedInfo = [NSMutableDictionary new];
    
    if([type isEqualToString:@"input"]){
        
        NSString *contentText = self.officialCustomPlayContentView.contentText;
        if (contentText.length>0) {
            [selectedInfo setObject:contentText forKey:@"value"];
            
        }else{
            return 0;
        }
        
    }else{
        selectedInfo = [self officailSelectedBetValueInfo];
        
    }
    
    if (selectedInfo.allValues.count>0) {
        
        NSDictionary *playInfo = _gfNameList[_selectedMenuIndex];
        NSInteger count =  [[CPBuyLotteryManager shareManager]officailPlayBetCountByTypeCode:self.typeCode menuPlayName:[playInfo DWStringForKey:@"name"] detailPlayName:[_chooseGfPlayInfo DWStringForKey:@"name"] betInfo:selectedInfo];
        return count;
    }
    return 0;
}

-(double)officailSelectedSingleBallAllBonus
{
    double allBouns = 0;
    
    for (NSString *key in _selectedIndexPathMarkDic.allKeys) {
        NSArray *display = [_chooseGfPlayInfo DWArrayForKey:@"display"];
        
        NSString *markIndexPathString = [_selectedIndexPathMarkDic DWStringForKey:key];
        if (markIndexPathString.length>0) {
            NSArray *rowList = [self selectedIndexPathComponentsSeparatedByString:markIndexPathString];
            for (NSString *row in rowList) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[row integerValue] inSection:[key integerValue]];
                NSDictionary *info = display[indexPath.section];
                NSArray *single = [info DWArrayForKey:@"single"];
                NSDictionary *singleInfo = single[indexPath.row];
                double bouns = [[[self officailPlayBonusByPlayId:[singleInfo DWStringForKey:@"number"]]jdM]doubleValue];
                allBouns = allBouns>=bouns?allBouns:bouns;
                
            }
        }
    }
    
    return allBouns;
}

-(NSString *)officailSelectedSingleBallAllPlayIdString
{
    NSMutableString *allPlayIdString = [NSMutableString new];
    
    for (NSString *key in _selectedIndexPathMarkDic.allKeys) {
        NSArray *display = [_chooseGfPlayInfo DWArrayForKey:@"display"];
        
        NSString *markIndexPathString = [_selectedIndexPathMarkDic DWStringForKey:key];
        if (markIndexPathString.length>0) {
            NSArray *rowList = [self selectedIndexPathComponentsSeparatedByString:markIndexPathString];
            for (NSString *row in rowList) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[row integerValue] inSection:[key integerValue]];
                NSDictionary *info = display[indexPath.section];
                NSArray *single = [info DWArrayForKey:@"single"];
                NSDictionary *singleInfo = single[indexPath.row];
                NSString *playId = [singleInfo DWStringForKey:@"number"];
                [allPlayIdString appendFormat:@"%@,",playId];
            }
        }
    }
    if (allPlayIdString.length>0) {
        [allPlayIdString deleteCharactersInRange:NSMakeRange(allPlayIdString.length-1, 1)];
    }
    return allPlayIdString;
}

-(NSString *)officailPlayValueByIndexPath:(NSIndexPath *)indexPath
{
    NSString *value = @"";
    NSString *type =  [_chooseGfPlayInfo DWStringForKey:@"type"];
    
    if ([type isEqualToString:@"ball"]) {
        
        NSArray *display = [_chooseGfPlayInfo DWArrayForKey:@"display"];
        NSDictionary *info = display[indexPath.section];
        NSInteger minValue = [[info DWStringForKey:@"min"]integerValue];
        value = [NSString stringWithFormat:@"%ld",minValue+indexPath.row];
        
    }else if ([type isEqualToString:@"singleball"]){
        
        NSArray *display = [_chooseGfPlayInfo DWArrayForKey:@"display"];
        NSDictionary *info = display[indexPath.section];
        NSArray *single = [info DWArrayForKey:@"single"];
        NSDictionary *singleInfo = single[indexPath.row];
        value = [singleInfo DWStringForKey:@"name"];
    }
    
    return value;
}

#pragma mark- CPBuyLtyRightButtonItemSortActionProtocol

-(void)cpBuyLtyRightButtonItemSortActionByTag:(NSInteger)tag
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
            //投注记录
            [self showSortViewAction];
            
            if (![SUMUser shareUser].isLogin) {
                AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
                [app.maiTabBarController goToLoginViewController];
            }else{
                CPBetRecordVC *vc = [CPBetRecordVC new];
                vc.onlyShowWinRecord = NO;
                [self.navigationController pushViewController:vc animated:YES];
            }
            
        }break;
        case 13:
        {
            //最近开奖
            [self showSortViewAction];
            
            NSString *gid = self.ltyNum;
            NSString *urlString = [[CPGlobalDataManager shareGlobalData].domainUrlString wayStringByAppendingPathComponent: [NSString stringWithFormat:@"/api/draw/single?gid=%@",gid]];
            CPLotteryResultDetailWebVC *vc = [[CPLotteryResultDetailWebVC alloc]init];
            vc.urlString = urlString;
            vc.dayType = 99;
            [self.navigationController pushViewController:vc animated:YES];
            
        }break;
        case 14:
        {
            //玩法说明
            [self showSortViewAction];
            
            if (_isOfficailPlay) {
                [self officailRuleButtonAction];
                return;
            }
            NSString *gid = self.ltyNum;
            NSString *urlString = [[CPGlobalDataManager shareGlobalData].domainUrlString wayStringByAppendingPathComponent:[NSString stringWithFormat:@"/api/help?gid=%@",gid]];
            CPWebViewController *toWebVC = [[CPWebViewController alloc]cpWebWithURLString:urlString];
            toWebVC.hasNoWebBack = YES;
            toWebVC.title = @"玩法说明";
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

#pragma mark- CPBuyLotteryHeaderViewProtocol

-(void)refreshBalance
{
    //刷新余额
    [self queryBalanceInfo];
}

#pragma mark- CPBuyLtyOfficialPlayOptionsSelectedViewDelegate

-(void)cpBuyLtyOfficialPlayOptionsSelectedViewSelectedIndexPath:(NSIndexPath *)indexPath
                                                       menuInex:(NSInteger)menuIndex
{
    if (indexPath.row!=_chooseGfPlayIndexPath.row || indexPath.section!=_chooseGfPlayIndexPath.section ||menuIndex!=_selectedMenuIndex) {
        _selectedMenuIndex = menuIndex;
        self.chooseGfPlayIndexPath = indexPath;
    }
}

#pragma mark- CPBuyLtyDetailOfficialPlayChooseViewDelegate

-(void)cpBuyLtyDetailOfficialPlayChooseViewChooseIndex:(NSInteger)index
{
    BOOL isOfficail = index == 1?YES:NO;
    if (_isOfficailPlay!=isOfficail) {
        _isOfficailPlay = isOfficail;
        [CPBuyLotteryManager shareManager].isOfficailPlay = _isOfficailPlay;
        if (_isOfficailPlay){
            //选择官方
        }else{
            //选择双面
            //            [self cleanSelectedBetRecord];
        }
        [self cleanSelectedBetRecord];
        [self.officailPlayTitleView addTitle:self.ltyName isOfficail:isOfficail];
        self.selectedMenuIndex = 0;
    }
}

#pragma mark- 官方玩法相关的业务处理逻辑


-(NSMutableDictionary *)officailSelectedBetValueInfo
{
    NSMutableDictionary * selectedInfo = [NSMutableDictionary new];
    for (NSString *key in _selectedIndexPathMarkDic.allKeys) {
        NSArray *display = [_chooseGfPlayInfo DWArrayForKey:@"display"];
        NSDictionary *info = display[[key intValue]];
        NSString *name = [info DWStringForKey:@"name"];
        NSString *markIndexPathString = [_selectedIndexPathMarkDic DWStringForKey:key];
        if (markIndexPathString.length>0) {
            NSArray *rowList = [self selectedIndexPathComponentsSeparatedByString:markIndexPathString];
            NSMutableArray *valueList = [NSMutableArray new];
            for (NSString *row in rowList) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[row integerValue] inSection:[key integerValue]];
                NSString *value = [self officailPlayValueByIndexPath:indexPath];
                [valueList addObject:value];
            }
            [selectedInfo setObject:valueList forKey:name];
        }
    }
    return selectedInfo;
}

#pragma mark- buttonAction

-(void)officailPlayHeaderViewAction
{
    NSString *name = [NSString new];
    NSArray *gfPlayDetailInfoList = [self gfPlayDetailInfoListByIndex:_selectedMenuIndex playName:&name];
    [CPBuyLtyOfficialPlayOptionsSelectedView showOnView:self.navigationController.view menuIndex:_selectedMenuIndex withTitle:name dataList:gfPlayDetailInfoList selectedItemId:[_chooseGfPlayInfo DWStringForKey:@"playId"] delegate:self];
}

//选择官方玩法还是双面玩法
-(void)officailPlayTitleViewClickAction
{
    if (!self.officailPlayChooseView.superview) {
        [self.officailPlayChooseView showOnView:self.view selectedIndex:_isOfficailPlay?1:0 delegate:self];
    }else{
        [self.officailPlayChooseView dismiss];
    }
}

//显示右上角视图
-(void)showSortViewAction
{
    self.rightBarItemSortView.frame = CGRectMake(self.view.width-self.rightBarItemSortView.width-10, 0, self.rightBarItemSortView.width, self.rightBarItemSortView.height);
    self.rightBarItemSortView.hidden = self.rightBarItemSortView.hidden?NO:YES;
    
}

//清除选项
-(void)cleanChooseAction
{
    [self cleanSelectedBetRecord];
}

-(void)officailRuleButtonAction
{
    if (_isOfficailPlay && [_chooseGfPlayInfo DWDictionaryForKey:@"intro"].allValues.count>0) {
        NSDictionary *intro = [_chooseGfPlayInfo DWDictionaryForKey:@"intro"];
        [self.officailRuleAlertView showPlayExampleString:[intro DWStringForKey:@"award"] explainString:[intro DWStringForKey:@"desc"] onView:self.navigationController.view];
        return;
    }
}


-(void)betAction
{
    //投注按钮
    
    //1.判断是否登录
    if (![SUMUser shareUser].isLogin) {
        [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationNameForPushToLoginViewController object:nil];
        return ;
    }
    
    //1.1 判断是不是官方玩法
    if (_isOfficailPlay) {
        
        //以下为官方玩法的逻辑
        
        //1.1.1 判断是否有有效下注单数
        NSInteger betCount = [self countOfficailPlaySelectedBetCount];
        if (betCount == 0) {
            [SVProgressHUD way_showInfoCanTouchAutoDismissWithStatus:@"请选择有效下注号码"];
            return;
        }
        
        //1.1.2
        //1.记录当前期数
        [CPBuyLotteryManager shareManager].currentBetPeriod = [self.headInfo DWStringForKey:@"period"];
        NSString *bonus = [self officailPlayBonusByPlayId:[_chooseGfPlayInfo DWStringForKey:@"playId"]];
        
        NSString *type =  [_chooseGfPlayInfo DWStringForKey:@"type"];
        NSMutableDictionary *selectedInfo = [self officailSelectedBetValueInfo];
        
        if([type isEqualToString:@"input"]){
            
            NSArray *finalValueList = [[CPBuyLotteryManager shareManager]officailPlayBetCustomFinalValidValueList];
            NSMutableString * betListString = [NSMutableString new];
            [betListString appendString:@"("];
            for (int i = 0; i<finalValueList.count; i++) {
                NSArray *valueList = finalValueList[i];
                for (int x = 0; x<valueList.count; x++) {
                    NSString *valueString = valueList[x];
                    [betListString appendString:valueString];
                    if (x<valueList.count-1) {
                        [betListString appendString:@" "];
                    }
                }
                if (i<finalValueList.count-1) {
                    [betListString appendString:@","];
                }
            }
            [betListString appendString:@")"];
            UIColor *lightColor = kCOLOR_R_G_B_A(1,53,66, 1);
            NSAttributedString *att = [[NSAttributedString alloc]initWithString:betListString attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:lightColor}];
            [CPBuyFastLotteryConfirmView showOfficailFastLotteryConfirmViewOnView:self.navigationController.view isSpecial:NO officailBonus:bonus ltyDesString:att betCount:betCount numberPeriods:[CPBuyLotteryManager shareManager].currentBetPeriod comfirm:^(BOOL isConfirm, NSString *value) {
                
                
                
                if (isConfirm&&[value doubleValue]>0) {
                    NSArray *finalValueList = [[CPBuyLotteryManager shareManager]officailPlayBetCustomFinalValidValueList];
                    NSMutableString * betListString = [NSMutableString new];
                    
                    for (int i = 0; i<finalValueList.count; i++) {
                        NSArray *valueList = finalValueList[i];
                        for (int x = 0; x<valueList.count; x++) {
                            NSString *valueString = valueList[x];
                            [betListString appendString:valueString];
                            if (x<valueList.count-1) {
                                [betListString appendString:@","];
                            }
                        }
                        if (i<finalValueList.count-1) {
                            [betListString appendString:@"|"];
                        }
                    }
                    _betAmount = value;
                    [self queryBetWithBetList:betListString playId:[_chooseGfPlayInfo DWStringForKey:@"playId"] isOfficailBet:YES];
                }
                
            }];
            
        }else if ([type isEqualToString:@"ball"]) {
            NSMutableAttributedString *mAtt = [NSMutableAttributedString new];
            UIColor *lightColor = kCOLOR_R_G_B_A(1,53,66, 1);
            UIColor *darkColor = kCOLOR_R_G_B_A(0,0,0, 1);
            NSArray *display = [_chooseGfPlayInfo DWArrayForKey:@"display"];
            NSMutableString *betString = [NSMutableString new];
            for (int i = 0; i<display.count; i++) {
                NSDictionary *info = display[i];
                NSString *sectionName = [info DWStringForKey:@"name"];
                NSArray *valueList = [selectedInfo DWArrayForKey:sectionName];
                if (valueList.count>0) {
                    NSArray *sortValueList = [valueList sortedArrayUsingComparator:^NSComparisonResult(id _Nonnull obj1, id _Nonnull obj2) {
                        return [obj1 compare:obj2];//升序
                    }];
                    [mAtt appendAttributedString:[[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@(",sectionName] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:lightColor}]];
                    for (int x = 0; x<sortValueList.count; x++) {
                        NSString *value = sortValueList[x];
                        [betString appendString:value];
                        [mAtt appendAttributedString:[[NSAttributedString alloc]initWithString:value attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:darkColor}]];
                        if (x<sortValueList.count-1) {
                            [mAtt appendAttributedString:[[NSAttributedString alloc]initWithString:@"," attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:lightColor}]];
                            [betString appendString:@","];
                            
                        }
                    }
                    [mAtt appendAttributedString:[[NSAttributedString alloc]initWithString:@")" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:lightColor}]];
                }
                if (i<display.count-1) {
                    [betString appendString:@"|"];
                }
            }
            [CPBuyFastLotteryConfirmView showOfficailFastLotteryConfirmViewOnView:self.navigationController.view isSpecial:NO officailBonus:bonus ltyDesString:mAtt betCount:betCount numberPeriods:[CPBuyLotteryManager shareManager].currentBetPeriod comfirm:^(BOOL isConfirm, NSString *value) {
                
                if (isConfirm&&[value doubleValue]>0) {
                    _betAmount = value;
                    [self queryBetWithBetList:betString playId:[_chooseGfPlayInfo DWStringForKey:@"playId"] isOfficailBet:YES];
                }
            }];
            
        }else if ([type isEqualToString:@"singleball"]){
            
            NSMutableArray *valueList = [NSMutableArray new];
            for (NSArray *list in selectedInfo.allValues) {
                if (list.count>0) {
                    [valueList addObjectsFromArray:list];
                }
            }
            NSMutableAttributedString *mAtt = [NSMutableAttributedString new];
            UIColor *lightColor = kCOLOR_R_G_B_A(1,53,66, 1);
            UIColor *darkColor = kCOLOR_R_G_B_A(0,0,0, 1);
            
            [mAtt appendAttributedString:[[NSAttributedString alloc]initWithString:@"特殊号(" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:lightColor}]];
            for (int i=0; i<valueList.count; i++) {
                NSString *value = valueList[i];
                [mAtt appendAttributedString:[[NSAttributedString alloc]initWithString:value attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:darkColor}]];
                if (i<valueList.count-1) {
                    [mAtt appendAttributedString:[[NSAttributedString alloc]initWithString:@"," attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:lightColor}]];
                    
                }
                
            }
            [mAtt appendAttributedString:[[NSAttributedString alloc]initWithString:@")" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:lightColor}]];
            
            double allBounus = [self officailSelectedSingleBallAllBonus];
            NSString *singleBallAllBouns = [NSString stringWithFormat:@"%f",allBounus];
            [CPBuyFastLotteryConfirmView showOfficailFastLotteryConfirmViewOnView:self.navigationController.view isSpecial:YES officailBonus:singleBallAllBouns ltyDesString:mAtt betCount:betCount numberPeriods:[CPBuyLotteryManager shareManager].currentBetPeriod comfirm:^(BOOL isConfirm, NSString *value) {
                
                NSString *betString = [self officailSelectedSingleBallAllPlayIdString];
                if (isConfirm&&[value doubleValue]>0) {
                    _betAmount = value;
                    [self queryBetWithBetList:betString playId:[_chooseGfPlayInfo DWStringForKey:@"playId"] isOfficailBet:YES];
                }
            }];
        }
        
        return;
    }
    
    
    //以下为双面玩法的逻辑
    //2.判断是否有下注
    if (![self hasBetAnyone]) {
        [SVProgressHUD way_showInfoCanTouchAutoDismissWithStatus:@"请选择下注的内容"];
        return;
    }
    
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    //3.判断投注选项是否符合
    NSString *alertMsg = @"";
    if (![self betContentHasVerifyBetRule:&alertMsg]) {
        alertMsg = alertMsg.length>0?alertMsg:@"下注号码有误";
        [SVProgressHUD way_showInfoCanTouchAutoDismissWithStatus:alertMsg];
        return;
    }
    
    //显示投注确认界面
    //1.记录当前期数
    [CPBuyLotteryManager shareManager].currentBetPeriod = [self.headInfo DWStringForKey:@"period"];
    
    //2.取到选中的indexs
    NSDictionary *allIndexsInfo = [self selectedAllIndexsInfo];
    NSArray *allkeys = [allIndexsInfo allKeys];
    NSArray *sortedKeys = [allkeys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSInteger result = [obj1 integerValue]-[obj2 integerValue];
        if (result>0) {
            return NSOrderedDescending;
        }
        return NSOrderedAscending;
    }];
    
    NSDictionary *playInfo = self.menuPlayKindList[_selectedMenuIndex];
    NSString *playKindName = [playInfo DWStringForKey:@"playName"];
    
    _betInfos = [NSMutableArray new];
    if ([playKindName rangeOfString:@"合肖"].length>0) {
        NSArray *indexInfos = [[allIndexsInfo allValues]firstObject];
        NSMutableDictionary *betInfo = [NSMutableDictionary new];
        NSArray *orgPlayDetailList = self.playDetailList;
        NSDictionary *orgPlayInfo = [orgPlayDetailList firstObject];
        NSArray *orgPlayInfoList = [orgPlayInfo DWArrayForKey:@"list"];
        NSDictionary *orgPlayDetailInfo = [orgPlayInfoList objectAtIndex:indexInfos.count-2];
        [betInfo setObject:[[[CPBuyLotteryManager shareManager]fetchDoubleFacePlayBounsByPlayId:[orgPlayDetailInfo DWStringForKey:@"playId"]]jdM] forKey:@"bonus"];
        [betInfo setObject:@"1" forKey:@"useBonus"];
        
        NSMutableString *playName = [[NSMutableString alloc]initWithString:@"合肖:"];
        NSMutableString *playNameValue = [[NSMutableString alloc]init];
        NSArray *heXiaoPlayDetailList = [[self.heXiaoPlayDetailList firstObject] DWArrayForKey:@"list"];
        for (int i = 0; i<indexInfos.count; i++) {
            NSInteger index = [indexInfos[i] integerValue];
            NSDictionary *heXiaoInfo = heXiaoPlayDetailList[index];
            [playName appendFormat:@"%@&",[heXiaoInfo DWStringForKey:@"playName"]];
            [playNameValue appendFormat:@"%@&",[heXiaoInfo DWStringForKey:@"playName"]];
        }
        [playName deleteCharactersInRange:NSMakeRange(playName.length-1, 1)];
        if (playNameValue.length>0) {
            [playNameValue deleteCharactersInRange:NSMakeRange(playNameValue.length-1, 1)];
        }
        [betInfo setObject:playName forKey:@"playName"];
        [_betInfos addObject:betInfo];
        NSString *betHeXiaoPlayId = [orgPlayDetailInfo DWStringForKey:@"playId"];
        kWeakSelf;
        [CPBuyFastLotteryConfirmView showFastLotteryConfirmViewOnView:self.navigationController.view lotterys:_betInfos numberPeriods:[CPBuyLotteryManager shareManager].currentBetPeriod specailType:1 comfirm:^(BOOL isConfirm, NSString *value) {
            kStrongSelf;
            self.navigationController.interactivePopGestureRecognizer.enabled = YES;
            
            if (isConfirm) {
                NSString *betString = [NSString stringWithFormat:@"%@|%@;",betHeXiaoPlayId,playNameValue];
                _betAmount = value;
                [self queryBetWithBetList:betString];
            }
        }];
    }else if ([playKindName rangeOfString:@"自选不中"].length>0) {
        NSArray *indexInfos = [[allIndexsInfo allValues]firstObject];
        NSMutableDictionary *betInfo = [NSMutableDictionary new];
        NSArray *orgPlayDetailList = self.playDetailList;
        NSDictionary *orgPlayInfo = [orgPlayDetailList firstObject];
        NSArray *orgPlayInfoList = [orgPlayInfo DWArrayForKey:@"list"];
        NSDictionary *orgPlayDetailInfo = [orgPlayInfoList objectAtIndex:indexInfos.count-6];
        [betInfo setObject:[[[CPBuyLotteryManager shareManager]fetchDoubleFacePlayBounsByPlayId:[orgPlayDetailInfo DWStringForKey:@"playId"]]jdM] forKey:@"bonus"];
        [betInfo setObject:@"1" forKey:@"useBonus"];
        NSMutableString *playName = [[NSMutableString alloc]initWithFormat:@"%@:",[orgPlayDetailInfo DWStringForKey:@"playName"]];
        NSMutableString *playNameValue = [[NSMutableString alloc]init];
        NSArray *zxbzPlayDetailList = [[self.zxbzPlayDetailList firstObject] DWArrayForKey:@"list"];
        for (int i = 0; i<indexInfos.count; i++) {
            NSInteger index = [indexInfos[i] integerValue];
            NSDictionary *zxbzInfo = zxbzPlayDetailList[index];
            [playName appendFormat:@"%@&",[zxbzInfo DWStringForKey:@"playName"]];
            [playNameValue appendFormat:@"%@&",[zxbzInfo DWStringForKey:@"playName"]];
        }
        [playName deleteCharactersInRange:NSMakeRange(playName.length-1, 1)];
        if (playNameValue.length>0) {
            [playNameValue deleteCharactersInRange:NSMakeRange(playNameValue.length-1, 1)];
        }
        [betInfo setObject:playName forKey:@"playName"];
        [_betInfos addObject:betInfo];
        NSString *betZxbzPlayId = [orgPlayDetailInfo DWStringForKey:@"playId"];
        kWeakSelf;
        [CPBuyFastLotteryConfirmView showFastLotteryConfirmViewOnView:self.navigationController.view lotterys:_betInfos numberPeriods:[CPBuyLotteryManager shareManager].currentBetPeriod specailType:1 comfirm:^(BOOL isConfirm, NSString *value) {
            self.navigationController.interactivePopGestureRecognizer.enabled = YES;
            
            kStrongSelf;
            if (isConfirm) {
                
                NSString *betString = [NSString stringWithFormat:@"%@|%@;",betZxbzPlayId,playNameValue];
                _betAmount = value;
                [self queryBetWithBetList:betString];
            }
        }];
    }else if ([playKindName rangeOfString:@"连码"].length>0) {
        
        for (int i = 0; i<sortedKeys.count; i++) {
            NSInteger index = [sortedKeys[i] integerValue];
            NSArray *values = [allIndexsInfo DWArrayForKey:sortedKeys[i]];
            NSMutableArray *selectedLetters = [NSMutableArray new];
            NSDictionary *baseInfo = self.lianMaPlayDetailList[index];
            NSArray *letterList = [baseInfo DWArrayForKey:@"list"];
            NSInteger minCount = [[baseInfo DWStringForKey:@"minCount"]integerValue];
            for (int n = 0; n<values.count; n++) {
                NSDictionary *letterInfo = [letterList objectAtIndex:[values[n] integerValue]];
                NSString *letter = [letterInfo DWStringForKey:@"playName"];
                [selectedLetters addObject:letter];
            }
            [self combine:(int)selectedLetters.count index:(int)minCount temp:@"" selectedLetters:selectedLetters baseBetInfo:baseInfo betInfos:_betInfos];
        }
        kWeakSelf;
        [CPBuyFastLotteryConfirmView showFastLotteryConfirmViewOnView:self.navigationController.view lotterys:_betInfos numberPeriods:[CPBuyLotteryManager shareManager].currentBetPeriod specailType:2 comfirm:^(BOOL isConfirm, NSString *value) {
            self.navigationController.interactivePopGestureRecognizer.enabled = YES;
            
            kStrongSelf;
            if (isConfirm) {
                
                NSMutableString *betList = [NSMutableString new];
                for (NSDictionary *info in _betInfos) {
                    NSString *playName = [info DWStringForKey:@"playNameValue"];
                    NSString *playId = [info DWStringForKey:@"playId"];
                    
                    NSString *betString = [NSString stringWithFormat:@"%@|%@;",playId,playName];
                    [betList appendString:betString];
                    
                }
                _betAmount = value;
                [self queryBetWithBetList:betList];
            }
        }];
        
    }else if ([playKindName rangeOfString:@"连肖连尾"].length>0) {
        
        for (int i = 0; i<sortedKeys.count; i++) {
            NSInteger index = [sortedKeys[i] integerValue];
            NSArray *values = [allIndexsInfo DWArrayForKey:sortedKeys[i]];
            NSMutableArray *selectedLetters = [NSMutableArray new];
            NSMutableDictionary *baseInfo = [[NSMutableDictionary alloc]initWithDictionary:self.contentPlayDetailList[index]];
            [baseInfo setObject:[baseInfo DWStringForKey:@"name"] forKey:@"playName"];
            NSArray *letterList = [baseInfo DWArrayForKey:@"list"];
            NSString *name = [baseInfo DWStringForKey:@"name"];
            NSInteger minCount = 1;
            if ([name rangeOfString:@"二"].length>0) {
                minCount = 2;
            }else if ([name rangeOfString:@"三"].length>0) {
                minCount = 3;
            }else if ([name rangeOfString:@"四"].length>0) {
                minCount = 4;
            }else if ([name rangeOfString:@"五"].length>0) {
                minCount = 5;
            }
            for (int n = 0; n<values.count; n++) {
                NSDictionary *letterInfo = [letterList objectAtIndex:[values[n] integerValue]];
                NSString *letter = [letterInfo DWStringForKey:@"playName"];
                [selectedLetters addObject:letter];
                if (n==0) {
                    [baseInfo setObject:[[[CPBuyLotteryManager shareManager]fetchDoubleFacePlayBounsByPlayId:[letterInfo DWStringForKey:@"playId"]]jdM] forKey:@"bonus"];
                    [baseInfo setObject:[letterInfo DWStringForKey:@"playId"] forKey:@"playId"];
                    
                }
            }
            [self combine:(int)selectedLetters.count index:(int)minCount temp:@"" selectedLetters:selectedLetters baseBetInfo:baseInfo betInfos:_betInfos];
        }
        kWeakSelf;
        [CPBuyFastLotteryConfirmView showFastLotteryConfirmViewOnView:self.navigationController.view lotterys:_betInfos numberPeriods:[CPBuyLotteryManager shareManager].currentBetPeriod specailType:2 comfirm:^(BOOL isConfirm, NSString *value) {
            self.navigationController.interactivePopGestureRecognizer.enabled = YES;
            
            kStrongSelf;
            if (isConfirm) {
                
                NSMutableString *betList = [NSMutableString new];
                for (NSDictionary *info in _betInfos) {
                    NSString *playName = [info DWStringForKey:@"playNameValue"];
                    NSString *playId = [info DWStringForKey:@"playId"];
                    NSString *betString = [NSString stringWithFormat:@"%@|%@;",playId,playName];
                    [betList appendString:betString];
                }
                _betAmount = value;
                [self queryBetWithBetList:betList];
            }
        }];
        
    }else{
        
        for (int i = 0; i<sortedKeys.count; i++) {
            
            NSArray *indexs = [allIndexsInfo objectForKey:sortedKeys[i]];
            NSDictionary *sectionInfo = self.contentPlayDetailList[[sortedKeys[i] integerValue]];
            NSString *sectionName = [sectionInfo DWStringForKey:@"name"];
            NSArray *detailInfos = [sectionInfo DWArrayForKey:@"list"];
            for (int n = 0; n<indexs.count; n++) {
                NSInteger detailIndex = [indexs[n] integerValue];
                NSMutableDictionary *detailInfo = [[NSMutableDictionary alloc]initWithDictionary:detailInfos[detailIndex]];
                [detailInfo setObject:sectionName forKey:@"sectionName"];
                [_betInfos addObject:detailInfo];
            }
        }
        kWeakSelf;
        [CPBuyFastLotteryConfirmView showFastLotteryConfirmViewOnView:self.navigationController.view lotterys:_betInfos numberPeriods:[CPBuyLotteryManager shareManager].currentBetPeriod comfirm:^(BOOL isConfirm, NSString *value) {
            self.navigationController.interactivePopGestureRecognizer.enabled = YES;
            
            kStrongSelf;
            if (isConfirm) {
                
                NSMutableString *betList = [NSMutableString new];
                for (NSDictionary *info in _betInfos) {
                    NSString *playName = [info DWStringForKey:@"playName"];
                    NSString *playId = [info DWStringForKey:@"playId"];
                    
                    NSString *betString = [NSString stringWithFormat:@"%@|%@;",playId,playName];
                    [betList appendString:betString];
                    
                }
                _betAmount = value;
                [self queryBetWithBetList:betList];
            }
        }];
    }
    
    
}

#pragma mark- network

-(void)queryLtyResult
{
    @synchronized (self) {
        
        if (_isQueryInfoIng == NO) {
            
            _isQueryInfoIng = YES;
            NSString *gid = [CPBuyLotteryManager shareManager].currentLtyGid;
            NSMutableDictionary *paramsDic =[[NSMutableDictionary alloc]initWithDictionary:@{@"token":[SUMUser shareUser].token}];
            [paramsDic setObject:@"2" forKey:@"deviceType"];
            [paramsDic setObject:gid forKey:@"gid"];
            
            NSString *paramsString = [NSString encryptedByGBKAES:[paramsDic JSONString]];
            kWeakSelf
            [SUMRequest startWithDomainString:[CPGlobalDataManager shareGlobalData].domainUrlString
                                      apiName:CPSerVerAPINameForAPIHallSingle
                                       params:@{@"data":paramsString}
                                 rquestMethod:YTKRequestMethodGET
                   completionBlockWithSuccess:^(__kindof SUMRequest *request) {
                       kStrongSelf
                       
                       if (request.resultIsOk) {
                           self.headInfo = request.businessData;
                           NSArray *sxNames = [[self.headInfo DWStringForKey:@"lastOpenSx"]componentsSeparatedByString:@","];
                           if (sxNames.count>0) {
                               [CPBuyLotteryManager shareManager].currentLhcResultSxNames = sxNames;
                           }
                           
                           [self reloadHeaderViewInfo];
                           
                       }else{
                           if (_contentTableView.mj_header.isRefreshing) {
                               [SVProgressHUD way_dismissThenShowInfoWithStatus:@"网络异常"];
                           }
                       }
                       
                       if (_contentTableView.mj_header.isRefreshing) {
                           [_contentTableView.mj_header endRefreshing];
                       }
                       _isQueryInfoIng = NO;
                   } failure:^(__kindof SUMRequest *request) {
                       [SVProgressHUD way_dismissThenShowInfoWithStatus:request.requestDescription];
                       if (_contentTableView.mj_header.isRefreshing) {
                           [_contentTableView.mj_header endRefreshing];
                       }
                       _isQueryInfoIng = NO;
                   }];
        }
    }
    
}

-(void)queryBetWithBetList:(NSString *)betList
                    playId:(NSString *)playId
             isOfficailBet:(BOOL)isOfficailBet
{
    NSString *gid = self.ltyNum;
    NSString *issue = [CPBuyLotteryManager shareManager].currentBetPeriod;
    
    NSMutableDictionary *paramsDic =[[NSMutableDictionary alloc]initWithDictionary:@{@"token":[SUMUser shareUser].token}];
    [paramsDic setObject:@"2" forKey:@"deviceType"];
    
    [paramsDic setObject:gid forKey:@"gid"];
    [paramsDic setObject:issue forKey:@"issue"];
    if (isOfficailBet) {
        [paramsDic setObject:betList forKey:@"gfBetList"];
        [paramsDic setObject:playId forKey:@"playId"];
        
    }else{
        [paramsDic setObject:betList forKey:@"betList"];
    }
    [paramsDic setObject:_betAmount forKey:@"amount"];
    
    
    NSString *paramsString = [NSString encryptedByGBKAES:[paramsDic JSONString]];
    
    kWeakSelf
    [SUMRequest startWithDomainString:[CPGlobalDataManager shareGlobalData].domainUrlString
                              apiName:CPSerVerAPINameForAPIBetSubmit
                               params:@{@"data":paramsString}
                         rquestMethod:YTKRequestMethodGET
           completionBlockWithSuccess:^(__kindof SUMRequest *request) {
               kStrongSelf
               if (request.resultIsOk) {
                   if (isOfficailBet) {
                       if (self.officialCustomPlayContentView.contentText.length>0) {
                           [self.officialCustomPlayContentView cleanContentText];
                       }
                   }
                   [self queryBalanceInfo];
                   [self reloadBalanceLabel];
                   [self cleanSelectedBetRecord];
                   [SVProgressHUD way_dismissThenShowInfoWithStatus:@"投注成功"];
               }else{
                   
                   
                   if ([request.requestDescription rangeOfString:@"余额不足"].length>0 && ![SUMUser shareUser].isTryPlay) {
                       [SVProgressHUD way_dismissThenShowInfoWithStatus:@""];
                       UIAlertController *alerVC = [UIAlertController alertControllerWithTitle:@"提醒" message:@"余额不足，请先充值" preferredStyle:UIAlertControllerStyleAlert];
                       
                       [alerVC addAction:[UIAlertAction actionWithTitle:@"去充值" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                           CPRechargeTypeListVC *vc = [CPRechargeTypeListVC new];
                           vc.hidesBottomBarWhenPushed = YES;
                           [self.navigationController pushViewController:vc animated:YES];
                       }]];
                       
                       [alerVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
                       
                       [self presentViewController:alerVC animated:YES completion:^{
                           
                       }];
                       
                   }else{
                       [SVProgressHUD way_dismissThenShowInfoWithStatus:request.requestDescription];
                   }
               }
               
           } failure:^(__kindof SUMRequest *request) {
               [SVProgressHUD way_dismissThenShowInfoWithStatus:request.requestDescription];
           }];
}

-(void)queryBetWithBetList:(NSString *)betList
{
    [self queryBetWithBetList:betList playId:@"" isOfficailBet:NO];
}

-(void)queryBalanceInfo
{
    if (![SUMUser shareUser].isLogin) {
        return;
    }
    
    NSMutableDictionary *paramsDic =[[NSMutableDictionary alloc]initWithDictionary:@{@"type":@"1",@"deviceType":@"2"}];
    [paramsDic setObject:[SUMUser shareUser].token forKey:@"token"];
    
    NSString *paramsString = [NSString encryptedByGBKAES:[paramsDic JSONString]];
    kWeakSelf
    [SUMRequest startWithDomainString:[CPGlobalDataManager shareGlobalData].domainUrlString
                              apiName:CPSerVerAPINameForAPIUserAmount
                               params:@{@"data":paramsString}
                         rquestMethod:YTKRequestMethodGET
           completionBlockWithSuccess:^(__kindof SUMRequest *request) {
               kStrongSelf
               if (request.resultIsOk) {
                   
                   NSDictionary *dataInfo = [request.resultInfo DWDictionaryForKey:@"data"];
                   _balance = [dataInfo DWStringForKey:@"balance"];
                   [self reloadBalanceLabel];
               }
           } failure:^(__kindof SUMRequest *request) {
               
           }];
}

- (NSDate *)getInternetDate
{
    NSString *urlString = @"http://m.baidu.com";
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString: urlString]];
    [request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
    [request setTimeoutInterval: 10];
    [request setHTTPShouldHandleCookies:FALSE];
    [request setHTTPMethod:@"GET"];
    NSHTTPURLResponse *response;
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    
    NSString *date = [[response allHeaderFields] objectForKey:@"Date"];
    date = [date substringFromIndex:5];
    date = [date substringToIndex:[date length]-4];
    NSDateFormatter *dMatter = [[NSDateFormatter alloc] init];
    dMatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [dMatter setDateFormat:@"dd MMM yyyy HH:mm:ss"];
    NSDate *netDate = [dMatter dateFromString:date];
    
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: netDate];
    NSDate *localeDate = [netDate  dateByAddingTimeInterval: interval];
    return localeDate;
}

@end
