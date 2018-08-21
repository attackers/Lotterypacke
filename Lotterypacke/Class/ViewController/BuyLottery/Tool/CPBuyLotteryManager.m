//
//  CPBuyLotteryManager.m
//  lottery
//
//  Created by way on 2017/11/26.
//  Copyright © 2017年 way. All rights reserved.
//

#import "CPBuyLotteryManager.h"
#import "CPBuyLtyDetailVC.h"

@interface CPBuyLotteryManager()

@property(nonatomic,assign)BOOL isQueryInfoIng;
@property(nonatomic,retain)NSMutableDictionary *doubleFaceBounsInfo;
@property(nonatomic,retain)NSMutableDictionary *doubleFacePlayInfo;
@property(nonatomic,retain)NSDictionary *currentDoubleFaceDetailPlayInfo;

@property(nonatomic,retain)NSDictionary *currentPlayInfo;
@property(nonatomic,assign)NSInteger officailBetCount;

@property(nonatomic,retain)NSArray *officailCustomBetFianlValidValueList;


@end

@implementation CPBuyLotteryManager

static CPBuyLotteryManager *manager;

+(instancetype)shareManager{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [CPBuyLotteryManager new];
        manager.isQueryInfoIng = NO;
    });
    return manager;
}


+(UIImage *)k3BackgroundImageByNumber:(NSString *)number
{
    int index = [number intValue]-1;
    NSArray *images = @[@"touzi_01_k3",@"touzi_02_k3",@"touzi_03_k3",@"touzi_04_k3",@"touzi_05_k3",@"touzi_06_k3",];
    UIImage *img = [UIImage imageNamed:images[index]];
    return img;
}

#pragma mark- setter && getter

-(void)setCurrentBuyLotteryTypeString:(NSString *)currentBuyLotteryTypeString
{
    if (![_currentBuyLotteryTypeString isEqualToString:currentBuyLotteryTypeString]||!self.currentPlayInfo) {
        NSArray *playInfoList = [self.doubleFacePlayInfo DWArrayForKey:@"bonusList"];
        for (NSDictionary *bonusInfo in playInfoList) {
            NSString *code = [bonusInfo DWStringForKey:@"code"];
            if ([code isEqualToString:currentBuyLotteryTypeString]) {
                self.currentPlayInfo = bonusInfo;
                break;
            }
        }
        
    }
    
    NSArray *bonusList = [self.doubleFaceBounsInfo DWArrayForKey:@"bonusList"];
    for (NSDictionary *bonusInfo in bonusList) {
        NSString *code = [bonusInfo DWStringForKey:@"code"];
        if ([code isEqualToString:currentBuyLotteryTypeString]) {
            self.currentDoubleFaceDetailPlayInfo = [bonusInfo DWDictionaryForKey:@"playDetailList"];
            break;
        }
    }
    _currentBuyLotteryTypeString = currentBuyLotteryTypeString;
}



#pragma mark- bigInfo 相关操作

-(NSArray *)loadBuyLtyCurrentPlayDetailListByPlayId:(NSString *)playId
{
    NSArray *playDetailList = [NSArray new];
    NSArray *playDetailListInfo = [self.currentPlayInfo DWArrayForKey:@"playDetailList"];
    for (NSDictionary *playDetailInfo in playDetailListInfo) {
        NSString *detailId = [playDetailInfo DWStringForKey:@"id"];
        if ([detailId isEqualToString:playId]) {
            playDetailList = [playDetailInfo DWArrayForKey:@"idList"];
            break;
        }
    }
    return playDetailList;
}

-(NSString *)fetchDoubleFacePlayBounsByPlayId:(NSString *)playId
{
    
    if (self.currentDoubleFaceDetailPlayInfo) {
        NSString *value = [self.currentDoubleFaceDetailPlayInfo DWStringForKey:playId];
        return value;
    }
    return @"";
}

#pragma mark 跳到下注界面

-(void)pushToBuyLtyDetailVCFromNav:(UINavigationController *)fromNav
                           ltyName:(NSString *)ltyName
                           ltyCode:(NSString *)ltyCode
                            ltyNum:(NSString *)ltyNum
{
    
    if (![SUMUser shareUser].isLogin) {
        
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [app.maiTabBarController goToLoginViewController];
        
    }else{
        
        if ([self hasExistBuyLtyBigInfoByVersion:[SUMUser shareUser].plVersion]) {
            
            NSArray *playList = [NSArray new];
            NSDictionary *gfListInfo = [NSDictionary new];
            [self loadBuyLtyInfoByTypeCode:ltyCode playList:&playList gfListInfo:&gfListInfo];
            CPBuyLtyDetailVC *vc = [CPBuyLtyDetailVC new];
            vc.menuPlayKindList = playList;
            vc.gfBonusListInfo = gfListInfo;
            vc.typeCode = ltyCode;
            vc.ltyName = ltyName;
            vc.ltyNum = ltyNum;
            vc.hidesBottomBarWhenPushed = YES;
            [fromNav pushViewController:vc animated:YES];
            
        }else{
            
            [SVProgressHUD way_showLoadingCanNotTouchBlackBackground];
            [self queryLtyBigInfoCompleted:^(BOOL isSucceed) {
                NSString *alertMsg = @"";
                if (isSucceed) {
                    
                    NSArray *playList = [NSArray new];
                    NSDictionary *gfListInfo = [NSDictionary new];
                    [self loadBuyLtyInfoByTypeCode:ltyCode playList:&playList gfListInfo:&gfListInfo];
                    CPBuyLtyDetailVC *vc = [CPBuyLtyDetailVC new];
                    vc.menuPlayKindList = playList;
                    vc.gfBonusListInfo = gfListInfo;
                    vc.typeCode = ltyCode;
                    vc.ltyName = ltyName;
                    vc.ltyNum = ltyNum;
                    vc.hidesBottomBarWhenPushed = YES;
                    [fromNav pushViewController:vc animated:YES];
                    
                }else{
                    alertMsg = @"网络异常";
                }
                [SVProgressHUD way_dismissThenShowInfoWithStatus:alertMsg];
            }];
        }
    }
}

#pragma mark 判断是否有缓存的bigInfo
-(BOOL)hasExistBuyLtyBigInfoByVersion:(NSString *)version
{
    BOOL exist = NO;
    if ([[self.doubleFaceBounsInfo DWStringForKey:@"version"] isEqualToString:version]) {
        exist = YES;
    }
    return exist;
}

#pragma mark 初始化bigInfo
-(NSMutableDictionary *)doubleFaceBounsInfo
{
    if (!_doubleFaceBounsInfo) {
        NSMutableDictionary *existInfo = [[NSMutableDictionary alloc]initWithContentsOfFile:[self loadBuyLtyBigInfoFullPath]];
        if (existInfo) {
            _doubleFaceBounsInfo = existInfo;
        }else{
            return [NSMutableDictionary new];
        }
    }
    return _doubleFaceBounsInfo;
}

-(NSMutableDictionary *)doubleFacePlayInfo
{
    if (!_doubleFacePlayInfo) {
        NSMutableDictionary *existInfo = [[NSMutableDictionary alloc]initWithContentsOfFile:[self loadDoubleFaceBuyLtyBigInfoFullPath]];
        if (existInfo) {
            _doubleFacePlayInfo = existInfo;
        }else{
            return [NSMutableDictionary new];
        }
    }
    return _doubleFacePlayInfo;
}

#pragma mark 获取bigInfo的playlist

-(void)loadBuyLtyInfoByTypeCode:(NSString *)typeCode
                       playList:(NSArray **)playList
                     gfListInfo:(NSDictionary **)gfListInfo
{
    
    NSArray *bonusList = [self.doubleFaceBounsInfo DWArrayForKey:@"bonusList"];
    for (NSDictionary *bonusInfo in bonusList) {
        NSString *code = [bonusInfo DWStringForKey:@"code"];
        if ([typeCode isEqualToString:code]) {
            if (*gfListInfo) {
                *gfListInfo = [bonusInfo DWDictionaryForKey:@"gfList"];
            }
            break;
        }
    }
    
    NSArray *existBonusList = [self.doubleFacePlayInfo DWArrayForKey:@"bonusList"];
    for (NSDictionary *bonusInfo in existBonusList) {
        NSString *code = [bonusInfo DWStringForKey:@"code"];
        if ([typeCode isEqualToString:code]) {
            if (*playList) {
                *playList = [bonusInfo DWArrayForKey:@"playList"];
            }
            break;
        }
    }
}

#pragma mark 获取bigInfo的playlist和playdetailList
-(NSDictionary *)loadHlcSxNamesForNum:(NSString *)num
{
    NSDictionary *sxNames = [num intValue]==18?[self.doubleFaceBounsInfo DWDictionaryForKey:@"xglhcSxNames"]:[self.doubleFaceBounsInfo DWDictionaryForKey:@"jslhcSxNames"];
    return sxNames;
}

#pragma mark 持久化bigInfo
-(void)saveBuyLtyBigInfo
{
    NSString *path = [self loadBuyLtyBigInfoFullPath];
    if (self.doubleFaceBounsInfo) {
        BOOL isSucceed = [self.doubleFaceBounsInfo writeToFile:path atomically:YES];
        NSLog(@"%d",isSucceed);
    }
}

-(NSString *)loadBuyLtyBigInfoName
{
    return @"buyltybiginfo";
}

-(NSString *)loadBuyLtyBigInfoFullPath
{
    return [[(NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES)) lastObject]stringByAppendingPathComponent:[self loadBuyLtyBigInfoName]];
}

-(NSString *)loadDoubleFaceBuyLtyBigInfoFullPath
{
    NSString *fileName = [[NSBundle mainBundle] pathForResource:@"doubleFacePlayInfo" ofType:@"plist"];
    return fileName;
}

#pragma mark 请求bigInfo

-(void)queryLtyBigInfoCompleted:(void(^)(BOOL isSucceed))completed
{
    @synchronized (self) {
        
        //        if (self.isQueryInfoIng) {
        //            return;
        //        }
        self.isQueryInfoIng = YES;
        NSMutableDictionary *paramsDic =[[NSMutableDictionary alloc]initWithDictionary:@{@"token":[SUMUser shareUser].token}];
        [paramsDic setObject:@"2" forKey:@"deviceType"];
        
        NSString *paramsString = [NSString encryptedByGBKAES:[paramsDic JSONString]];
        
        [SUMRequest startWithDomainString:[CPGlobalDataManager shareGlobalData].domainUrlString
                                  apiName:CPSerVerAPINameForAPILotteryNewBonus
                                   params:@{@"data":paramsString}
                             rquestMethod:YTKRequestMethodGET
               completionBlockWithSuccess:^(__kindof SUMRequest *request) {
                   
                   BOOL isSucceed = NO;
                   if (request.resultIsOk) {
                       NSDictionary *info = request.businessData;
                       self.doubleFaceBounsInfo = [[NSMutableDictionary alloc]initWithDictionary:info];
                       [self.doubleFaceBounsInfo setObject:[request.resultInfo DWStringForKey:@"plVersion"] forKey:@"version"];
                       [self saveBuyLtyBigInfo];
                       if (_currentBuyLotteryTypeString) {
                           self.currentBuyLotteryTypeString = _currentBuyLotteryTypeString;
                       }
                       isSucceed = YES;
                   }
                   
                   self.isQueryInfoIng = NO;
                   if (completed) {
                       completed(isSucceed);
                   }
               } failure:^(__kindof SUMRequest *request) {
                   self.isQueryInfoIng = NO;
                   if (completed) {
                       completed(NO);
                   }
               }];
        
    }
}

#pragma mark- 官方玩法的相关操作

#pragma mark 获取对应官方玩法的信息

-(void)loadGfInfoByLtyCode:(NSString *)ltyCode
                  nameList:(NSArray **)nameList
              playListInfo:(NSDictionary **)playListInfo
{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"officailPlay" ofType:@"plist"];
    NSDictionary *gfInfo = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    NSDictionary *gfDetailInfo = [gfInfo objectForKey:ltyCode];
    if (gfDetailInfo) {
        if ([gfDetailInfo isKindOfClass:[NSDictionary class]]) {
            *nameList = [gfDetailInfo DWArrayForKey:@"nameList"];
            *playListInfo = [gfDetailInfo DWDictionaryForKey:@"bonusList"];
        }
    }
}

#pragma mark 获取直选单式的最终有效注数的注码
-(NSArray *)officailPlayBetCustomFinalValidValueList;
{
    return self.officailCustomBetFianlValidValueList?self.officailCustomBetFianlValidValueList:[NSArray new];
}

#pragma mark 官方玩法的投注注单量计算

-(NSInteger)officailPlayBetCountByTypeCode:(NSString *)typeCode
                              menuPlayName:(NSString *)menuPlayName
                            detailPlayName:(NSString *)detailPlayName
                                   betInfo:(NSDictionary *)betInfo
{
    if ([typeCode isEqualToString:@"ssc"]) {
        return [self sscOfficailPlayBetCountByMenuPlayName:menuPlayName detailPlayName:detailPlayName betInfo:betInfo];
        
    }else if ([typeCode isEqualToString:@"pk10"]){
        return [self pk10OfficailPlayBetCountByMenuPlayName:menuPlayName detailPlayName:detailPlayName betInfo:betInfo];
        
    }else if ([typeCode isEqualToString:@"e11x5"]){
        return [self e11x5OfficailPlayBetCountByMenuPlayName:menuPlayName detailPlayName:detailPlayName betInfo:betInfo];
        
    }else if ([typeCode isEqualToString:@"k3"]){
        return [self k3OfficailPlayBetCountByMenuPlayName:menuPlayName detailPlayName:detailPlayName betInfo:betInfo];
        
    }else if ([typeCode isEqualToString:@"fc3d"]){
        return [self fc3dOfficailPlayBetCountByMenuPlayName:menuPlayName detailPlayName:detailPlayName betInfo:betInfo];
        
    }
    
    return 0;
}

-(NSInteger)sscOfficailPlayBetCountByMenuPlayName:(NSString *)menuPlayName
                                   detailPlayName:(NSString *)detailPlayName
                                          betInfo:(NSDictionary *)betInfo

{
    NSArray *allBetValueList = betInfo.allValues;
    if (allBetValueList.count == 0) {
        return 0;
    }
    
    if ([detailPlayName isEqualToString:@"特殊号"]){
        NSArray *valueList = [allBetValueList firstObject];
        return valueList.count;
    }
    
    self.officailBetCount = 0;
    if ([menuPlayName isEqualToString:@"五星"]) {
        
        
        if ([detailPlayName isEqualToString:@"直选复式"]) {
            
            if (allBetValueList.count<5) {
                return 0;
            }
            NSInteger allCount = 0;
            for (NSArray *valueList in allBetValueList) {
                if (valueList.count ==0) {
                    return 0;
                }
                allCount = allCount>0?allCount * valueList.count:valueList.count;
            }
            return allCount;
            
        }else if ([detailPlayName isEqualToString:@"直选单式"]){
            NSString *customValue = [allBetValueList firstObject];
            NSArray *valueList = [self officalPlayCustomBetTransform:customValue];
            NSInteger count = [self officailPlayCustomBetCount:valueList minNumber:0 maxNumber:9 betValueCount:5];
            return count;
        }else if ([detailPlayName isEqualToString:@"组选120"]){
            
            NSArray *valueList = [allBetValueList firstObject];
            if (valueList.count<5) {
                return 0;
            }
            [self combine:(int)valueList.count index:5];
            return self.officailBetCount;
            
        }else if ([detailPlayName isEqualToString:@"组选60"]){
            if (allBetValueList.count!=2) {
                return 0;
            }
            NSMutableArray *doubleNumList = [[NSMutableArray alloc]initWithArray:[betInfo DWArrayForKey:@"二重号"]];
            NSMutableArray *singleNumList = [[NSMutableArray alloc]initWithArray:[betInfo DWArrayForKey:@"单号"]];
            if (doubleNumList.count<1 || singleNumList.count<3) {
                return 0;
            }
            for (NSString *doubleValue in doubleNumList) {
                singleNumList = [[NSMutableArray alloc]initWithArray:[betInfo DWArrayForKey:@"单号"]];
                for (NSString *singleValue in singleNumList) {
                    if ([singleValue isEqualToString:doubleValue]) {
                        [singleNumList removeObject:singleValue];
                        break;
                    }
                }
                if (singleNumList.count>=3) {
                    [self combine:(int)singleNumList.count index:3];
                }
            }
            return self.officailBetCount;
            
        }else if ([detailPlayName isEqualToString:@"组选30"]){
            if (allBetValueList.count!=2) {
                return 0;
            }
            NSMutableArray *doubleNumList = [[NSMutableArray alloc]initWithArray:[betInfo DWArrayForKey:@"二重号"]];
            NSMutableArray *singleNumList = [[NSMutableArray alloc]initWithArray:[betInfo DWArrayForKey:@"单号"]];
            if (doubleNumList.count<2 || singleNumList.count<1) {
                return 0;
            }
            for (NSString *singleValue in singleNumList) {
                doubleNumList = [[NSMutableArray alloc]initWithArray:[betInfo DWArrayForKey:@"二重号"]];
                for (NSString *doubleValue in doubleNumList) {
                    if ([singleValue isEqualToString:doubleValue]) {
                        [doubleNumList removeObject:doubleValue];
                        break;
                    }
                }
                if (doubleNumList.count>=2) {
                    [self combine:(int)doubleNumList.count index:2];
                }
            }
            return self.officailBetCount;
            
        }else if ([detailPlayName isEqualToString:@"组选20"]){
            if (allBetValueList.count!=2) {
                return 0;
            }
            NSMutableArray *doubleNumList = [[NSMutableArray alloc]initWithArray:[betInfo DWArrayForKey:@"三重号"]];
            NSMutableArray *singleNumList = [[NSMutableArray alloc]initWithArray:[betInfo DWArrayForKey:@"单号"]];
            if (doubleNumList.count<1 || singleNumList.count<2) {
                return 0;
            }
            for (NSString *doubleValue in doubleNumList) {
                singleNumList = [[NSMutableArray alloc]initWithArray:[betInfo DWArrayForKey:@"单号"]];
                for (NSString *singleValue in singleNumList) {
                    if ([singleValue isEqualToString:doubleValue]) {
                        [singleNumList removeObject:singleValue];
                        break;
                    }
                }
                if (singleNumList.count>=2) {
                    [self combine:(int)singleNumList.count index:2];
                }
            }
            return self.officailBetCount;
            
        }else if ([detailPlayName isEqualToString:@"组选10"]){
            if (allBetValueList.count!=2) {
                return 0;
            }
            NSMutableArray *doubleNumList = [[NSMutableArray alloc]initWithArray:[betInfo DWArrayForKey:@"三重号"]];
            NSMutableArray *singleNumList = [[NSMutableArray alloc]initWithArray:[betInfo DWArrayForKey:@"二重号"]];
            if (doubleNumList.count<1 || singleNumList.count<1) {
                return 0;
            }
            for (NSString *doubleValue in doubleNumList) {
                singleNumList = [[NSMutableArray alloc]initWithArray:[betInfo DWArrayForKey:@"二重号"]];
                for (NSString *singleValue in singleNumList) {
                    if ([singleValue isEqualToString:doubleValue]) {
                        [singleNumList removeObject:singleValue];
                        break;
                    }
                }
                if (singleNumList.count>=1) {
                    [self combine:(int)singleNumList.count index:1];
                }
            }
            return self.officailBetCount;
            
        }else if ([detailPlayName isEqualToString:@"组选5"]){
            if (allBetValueList.count!=2) {
                return 0;
            }
            NSMutableArray *doubleNumList = [[NSMutableArray alloc]initWithArray:[betInfo DWArrayForKey:@"四重号"]];
            NSMutableArray *singleNumList = [[NSMutableArray alloc]initWithArray:[betInfo DWArrayForKey:@"单号"]];
            if (doubleNumList.count<1 || singleNumList.count<1) {
                return 0;
            }
            for (NSString *doubleValue in doubleNumList) {
                singleNumList = [[NSMutableArray alloc]initWithArray:[betInfo DWArrayForKey:@"单号"]];
                for (NSString *singleValue in singleNumList) {
                    if ([singleValue isEqualToString:doubleValue]) {
                        [singleNumList removeObject:singleValue];
                        break;
                    }
                }
                if (singleNumList.count>=1) {
                    [self combine:(int)singleNumList.count index:1];
                }
            }
            return self.officailBetCount;
        }
        
        
    }else if ([menuPlayName isEqualToString:@"四星"]) {
        
        if ([detailPlayName isEqualToString:@"直选复式"]||[detailPlayName rangeOfString:@"四组合"].length>0) {
            
            if (allBetValueList.count<4) {
                return 0;
            }
            NSInteger allCount = 0;
            for (NSArray *valueList in allBetValueList) {
                if (valueList.count ==0) {
                    return 0;
                }
                allCount = allCount>0?allCount * valueList.count:valueList.count;
            }
            return [detailPlayName rangeOfString:@"四组合"].length>0?allCount*4:allCount;
            
        }else if ([detailPlayName isEqualToString:@"直选单式"]){
            NSString *customValue = [allBetValueList firstObject];
            NSArray *valueList = [self officalPlayCustomBetTransform:customValue];
            NSInteger count = [self officailPlayCustomBetCount:valueList minNumber:0 maxNumber:9 betValueCount:4];
            return count;
        }else if ([detailPlayName isEqualToString:@"组选24"]){
            
            NSArray *valueList = [allBetValueList firstObject];
            if (valueList.count<4) {
                return 0;
            }
            [self combine:(int)valueList.count index:4];
            return self.officailBetCount;
            
        }else if ([detailPlayName isEqualToString:@"组选12"]){
            if (allBetValueList.count!=2) {
                return 0;
            }
            NSMutableArray *doubleNumList = [[NSMutableArray alloc]initWithArray:[betInfo DWArrayForKey:@"二重号"]];
            NSMutableArray *singleNumList = [[NSMutableArray alloc]initWithArray:[betInfo DWArrayForKey:@"单号"]];
            if (doubleNumList.count<1 || singleNumList.count<2) {
                return 0;
            }
            for (NSString *doubleValue in doubleNumList) {
                singleNumList = [[NSMutableArray alloc]initWithArray:[betInfo DWArrayForKey:@"单号"]];
                for (NSString *singleValue in singleNumList) {
                    if ([singleValue isEqualToString:doubleValue]) {
                        [singleNumList removeObject:singleValue];
                        break;
                    }
                }
                if (singleNumList.count>=2) {
                    [self combine:(int)singleNumList.count index:2];
                }
            }
            return self.officailBetCount;
            
        }else if ([detailPlayName isEqualToString:@"组选6"]){
            
            NSArray *valueList = [allBetValueList firstObject];
            if (valueList.count<2) {
                return 0;
            }
            [self combine:(int)valueList.count index:2];
            return self.officailBetCount;
            
        }else if ([detailPlayName isEqualToString:@"组选4"]){
            if (allBetValueList.count!=2) {
                return 0;
            }
            NSMutableArray *doubleNumList = [[NSMutableArray alloc]initWithArray:[betInfo DWArrayForKey:@"三重号"]];
            NSMutableArray *singleNumList = [[NSMutableArray alloc]initWithArray:[betInfo DWArrayForKey:@"单号"]];
            if (doubleNumList.count<1 || singleNumList.count<1) {
                return 0;
            }
            for (NSString *doubleValue in doubleNumList) {
                singleNumList = [[NSMutableArray alloc]initWithArray:[betInfo DWArrayForKey:@"单号"]];
                for (NSString *singleValue in singleNumList) {
                    if ([singleValue isEqualToString:doubleValue]) {
                        [singleNumList removeObject:singleValue];
                        break;
                    }
                }
                if (singleNumList.count>=1) {
                    [self combine:(int)singleNumList.count index:1];
                }
            }
            return self.officailBetCount;
            
        }
        
    }else if ([menuPlayName isEqualToString:@"三星"]) {
        
        if ([detailPlayName isEqualToString:@"直选复式"]||[detailPlayName rangeOfString:@"三组合"].length>0) {
            
            if (allBetValueList.count<3) {
                return 0;
            }
            NSInteger allCount = 0;
            for (NSArray *valueList in allBetValueList) {
                if (valueList.count ==0) {
                    return 0;
                }
                allCount = allCount>0?allCount * valueList.count:valueList.count;
            }
            return [detailPlayName rangeOfString:@"三组合"].length>0?allCount*3:allCount;
            
        }else if ([detailPlayName isEqualToString:@"直选单式"]){
            NSString *customValue = [allBetValueList firstObject];
            NSArray *valueList = [self officalPlayCustomBetTransform:customValue];
            NSInteger count = [self officailPlayCustomBetCount:valueList minNumber:0 maxNumber:9 betValueCount:3];
            return count;
        }else if ([detailPlayName isEqualToString:@"和值尾数"]){
            NSArray *valueList = [allBetValueList firstObject];
            return valueList.count;
        }else if ([detailPlayName isEqualToString:@"直选跨度"]){
            NSInteger count = 0;
            NSMutableString *valueString = [NSMutableString new];
            for (NSArray *values in allBetValueList) {
                for (NSString *value in values) {
                    [valueString appendFormat:@"|%@|",value];
                }
            }
            for (int x = 0; x<10; x++) {
                for (int y = 0; y<10; y++) {
                    for (int z = 0; z<10; z++) {
                        
                        NSString *value = [NSString stringWithFormat:@"|%d|",[self officailPlayTransformMaxDistanceFromValueA:x valueB:y valueC:z]];
                        if ([valueString rangeOfString:value].length>0) {
                            count = count+1;
                        }
                    }
                }
            }
            return count;
            
            
        }else if ([detailPlayName isEqualToString:@"直选和值"]){
            NSInteger count = 0;
            NSMutableString *valueString = [NSMutableString new];
            for (NSArray *values in allBetValueList) {
                for (NSString *value in values) {
                    [valueString appendFormat:@"|%@|",value];
                }
            }
            for (int x = 0; x<10; x++) {
                for (int y = 0; y<10; y++) {
                    for (int z = 0; z<10; z++) {
                        NSString *value = [NSString stringWithFormat:@"|%d|",x+y+z];
                        if ([valueString rangeOfString:value].length>0) {
                            count = count+1;
                        }
                    }
                }
            }
            return count;
            
            
        }else if ([detailPlayName isEqualToString:@"组三复式"]){
            NSArray *valueList = [allBetValueList firstObject];
            if (valueList.count<2) {
                return 0;
            }
            [self combine:(int)valueList.count index:2];
            return self.officailBetCount*2;
        }else if ([detailPlayName isEqualToString:@"组三单式"]){
            NSString *customValue = [allBetValueList firstObject];
            NSArray *valueList = [self officalPlayCustomBetTransform:customValue];
            valueList = [self officailPlayCustomTransform221Form:valueList minValue:0 maxValue:9];
            NSInteger count = [self officailPlayCustomBetCount:valueList minNumber:0 maxNumber:9 betValueCount:3];
            return count;
        }else if ([detailPlayName isEqualToString:@"组六复式"]){
            NSArray *valueList = [allBetValueList firstObject];
            if (valueList.count<3) {
                return 0;
            }
            [self combine:(int)valueList.count index:3];
            return self.officailBetCount;
        }else if ([detailPlayName isEqualToString:@"组六单式"]){
            NSString *customValue = [allBetValueList firstObject];
            NSArray *valueList = [self officalPlayCustomBetTransform:customValue];
            valueList = [self officailPlayCustomTransform123Form:valueList minValue:0 maxValue:9];
            NSInteger count = [self officailPlayCustomBetCount:valueList minNumber:0 maxNumber:9 betValueCount:3];
            return count;
        }else if ([detailPlayName isEqualToString:@"组选包胆"]){
            return 54;
        }
        
    }else if ([menuPlayName isEqualToString:@"后二"]||[menuPlayName isEqualToString:@"前二"]) {
        if ([detailPlayName isEqualToString:@"直选复式"]) {
            
            if (allBetValueList.count<2) {
                return 0;
            }
            NSInteger allCount = 0;
            for (NSArray *valueList in allBetValueList) {
                if (valueList.count ==0) {
                    return 0;
                }
                allCount = allCount>0?allCount * valueList.count:valueList.count;
            }
            return allCount;
            
        }else if ([detailPlayName isEqualToString:@"直选单式"]){
            
            NSString *customValue = [allBetValueList firstObject];
            NSArray *valueList = [self officalPlayCustomBetTransform:customValue];
            NSInteger count = [self officailPlayCustomBetCount:valueList minNumber:0 maxNumber:9 betValueCount:2];
            return count;
        }else if ([detailPlayName isEqualToString:@"直选跨度"]){
            NSInteger count = 0;
            NSMutableString *valueString = [NSMutableString new];
            for (NSArray *values in allBetValueList) {
                for (NSString *value in values) {
                    [valueString appendFormat:@"|%@|",value];
                }
            }
            for (int x = 0; x<10; x++) {
                for (int y = 0; y<10; y++) {
                    int distance = x-y;
                    distance = distance>0?distance:-distance;
                    NSString *value = [NSString stringWithFormat:@"|%d|",distance];
                    if ([valueString rangeOfString:value].length>0) {
                        count = count+1;
                    }
                }
            }
            return count;
            
            
        }else if ([detailPlayName isEqualToString:@"直选和值"]){
            NSInteger count = 0;
            NSMutableString *valueString = [NSMutableString new];
            for (NSArray *values in allBetValueList) {
                for (NSString *value in values) {
                    [valueString appendFormat:@"|%@|",value];
                }
            }
            for (int x = 0; x<10; x++) {
                for (int y = 0; y<10; y++) {
                    NSString *value = [NSString stringWithFormat:@"|%d|",x+y];
                    if ([valueString rangeOfString:value].length>0) {
                        count = count+1;
                    }
                }
            }
            return count;
            
        }else if ([detailPlayName isEqualToString:@"组选复式"]){
            NSArray *valueList = [allBetValueList firstObject];
            if (valueList.count<2) {
                return 0;
            }
            [self combine:(int)valueList.count index:2];
            return self.officailBetCount;
        }else if ([detailPlayName isEqualToString:@"组选单式"]){
            NSString *customValue = [allBetValueList firstObject];
            NSArray *valueList = [self officalPlayCustomBetTransform:customValue];
            valueList = [self officailPlayCustomTransform12Form:valueList minValue:0 maxValue:9];
            NSInteger count = [self officailPlayCustomBetCount:valueList minNumber:0 maxNumber:9 betValueCount:2];
            return count;
        }else if ([detailPlayName isEqualToString:@"组选包胆"]){
            return 9;
        }else if ([detailPlayName isEqualToString:@"组选和值"]){
            NSInteger count = 0;
            NSMutableString *valueString = [NSMutableString new];
            for (NSArray *values in allBetValueList) {
                for (NSString *value in values) {
                    [valueString appendFormat:@"|%@|",value];
                }
            }
            for (int x = 0; x<10; x++) {
                for (int y = 0; y<10; y++) {
                    NSString *value = [NSString stringWithFormat:@"|%d|",x+y];
                    if ([valueString rangeOfString:value].length>0 && x!=y) {
                        count = count+1;
                    }
                }
            }
            return count/2;
        }
        
    }else if ([menuPlayName isEqualToString:@"不定位"]) {
        if ([detailPlayName rangeOfString:@"一码"].length>0){
            NSArray *valueList = [allBetValueList firstObject];
            return valueList.count;
        }else if ([detailPlayName rangeOfString:@"二码"].length>0){
            NSArray *valueList = [allBetValueList firstObject];
            if (valueList.count<2) {
                return 0;
            }
            [self combine:(int)valueList.count index:2];
            return self.officailBetCount;
        }else if ([detailPlayName rangeOfString:@"三码"].length>0){
            NSArray *valueList = [allBetValueList firstObject];
            if (valueList.count<3) {
                return 0;
            }
            [self combine:(int)valueList.count index:3];
            return self.officailBetCount;
        }
    }else if ([menuPlayName isEqualToString:@"定位胆"]){
        
        if ([detailPlayName isEqualToString:@"定位胆"]){
            NSInteger count = 0;
            for (NSArray *list in allBetValueList) {
                count = list.count + count;
            }
            return count;
        }
        
    }
    return 0;
}

-(NSInteger)pk10OfficailPlayBetCountByMenuPlayName:(NSString *)menuPlayName
                                    detailPlayName:(NSString *)detailPlayName
                                           betInfo:(NSDictionary *)betInfo

{
    NSArray *allBetValueList = betInfo.allValues;
    if (allBetValueList.count == 0) {
        return 0;
    }
    
    self.officailBetCount = 0;
    if ([menuPlayName isEqualToString:@"前一"]) {
        
        if ([detailPlayName isEqualToString:@"直选复式"]) {
            NSArray *valueList = [allBetValueList firstObject];
            return valueList.count;
        }
    }else if ([menuPlayName isEqualToString:@"前二"]) {
        
        if ([detailPlayName isEqualToString:@"直选复式"]) {
            if (allBetValueList.count!=2) {
                return 0;
            }
            NSMutableArray *numOneList = [[NSMutableArray alloc]initWithArray:[betInfo DWArrayForKey:@"冠军"]];
            NSMutableArray *numTwoList = [[NSMutableArray alloc]initWithArray:[betInfo DWArrayForKey:@"亚军"]];
            if (numOneList.count<1 || numTwoList.count<1) {
                return 0;
            }
            for (NSString *oneValue in numOneList) {
                numTwoList = [[NSMutableArray alloc]initWithArray:[betInfo DWArrayForKey:@"亚军"]];
                for (NSString *twoValue in numTwoList) {
                    if ([twoValue isEqualToString:oneValue]) {
                        [numTwoList removeObject:twoValue];
                        break;
                    }
                }
                if (numTwoList.count>=1) {
                    [self combine:(int)numTwoList.count index:1];
                }
            }
            return self.officailBetCount;
            
        }else if ([detailPlayName isEqualToString:@"直选单式"]) {
            NSString *customValue = [allBetValueList firstObject];
            NSArray *valueList = [self officalPlayCustomBetTransform:customValue];
            valueList = [self officailPlayCustomTransform12Form:valueList minValue:1 maxValue:10];
            NSInteger count = [self officailPlayCustomBetCount:valueList minNumber:1 maxNumber:10 betValueCount:2];
            return count;
        }
        
    }else if ([menuPlayName isEqualToString:@"前三"]) {
        
        if ([detailPlayName isEqualToString:@"直选复式"]) {
            if (allBetValueList.count!=3) {
                return 0;
            }
            NSMutableArray *numOneList = [[NSMutableArray alloc]initWithArray:[betInfo DWArrayForKey:@"冠军"]];
            NSMutableArray *numTwoList = [[NSMutableArray alloc]initWithArray:[betInfo DWArrayForKey:@"亚军"]];
            NSMutableArray *numThreeList = [[NSMutableArray alloc]initWithArray:[betInfo DWArrayForKey:@"季军"]];
            
            if (numOneList.count<1 || numTwoList.count<1 || numThreeList.count<1) {
                return 0;
            }
            for (NSString *oneValue in numOneList) {
                numTwoList = [[NSMutableArray alloc]initWithArray:[betInfo DWArrayForKey:@"亚军"]];
                for (NSString *twoValue in numTwoList) {
                    if (![twoValue isEqualToString:oneValue]) {
                        numThreeList = [[NSMutableArray alloc]initWithArray:[betInfo DWArrayForKey:@"季军"]];
                        NSMutableIndexSet *indexSet = [NSMutableIndexSet new];
                        for (int i = 0;i<numThreeList.count;i++) {
                            NSString *threeValue = numThreeList[i];
                            if ([threeValue isEqualToString:twoValue] || [threeValue isEqualToString:oneValue]) {
                                [indexSet addIndex:i];
                            }
                        }
                        [numThreeList removeObjectsAtIndexes:indexSet];
                        if (numThreeList.count>=1) {
                            [self combine:(int)numThreeList.count index:1];
                        }
                        
                    }
                }
                
            }
            return self.officailBetCount;
            
        }else if ([detailPlayName isEqualToString:@"直选单式"]) {
            NSString *customValue = [allBetValueList firstObject];
            NSArray *valueList = [self officalPlayCustomBetTransform:customValue];
            valueList = [self officailPlayCustomTransform123Form:valueList minValue:1 maxValue:10];
            NSInteger count = [self officailPlayCustomBetCount:valueList minNumber:1 maxNumber:10 betValueCount:3];
            return count;
        }
        
    }else if ([menuPlayName isEqualToString:@"定位胆"]){
        
        if ([detailPlayName isEqualToString:@"定位胆"]){
            NSInteger count = 0;
            for (NSArray *list in allBetValueList) {
                count = list.count + count;
            }
            return count;
        }
        
    }
    return 0;
}

-(NSInteger)fc3dOfficailPlayBetCountByMenuPlayName:(NSString *)menuPlayName
                                    detailPlayName:(NSString *)detailPlayName
                                           betInfo:(NSDictionary *)betInfo

{
    NSArray *allBetValueList = betInfo.allValues;
    if (allBetValueList.count == 0) {
        return 0;
    }
    self.officailBetCount = 0;
    
    if ([menuPlayName isEqualToString:@"三星"]) {
        
        if ([detailPlayName isEqualToString:@"直选复式"]) {
            
            if (allBetValueList.count<3) {
                return 0;
            }
            NSInteger allCount = 0;
            for (NSArray *valueList in allBetValueList) {
                if (valueList.count ==0) {
                    return 0;
                }
                allCount = allCount>0?allCount * valueList.count:valueList.count;
            }
            return allCount;
            
        }else if ([detailPlayName isEqualToString:@"组三和值"]||[detailPlayName isEqualToString:@"组六和值"]||[detailPlayName isEqualToString:@"直选和值"]) {
            
            NSArray *valueList = [allBetValueList firstObject];
            return valueList.count;
            
        }else if ([detailPlayName isEqualToString:@"直选单式"]){
            NSString *customValue = [allBetValueList firstObject];
            NSArray *valueList = [self officalPlayCustomBetTransform:customValue];
            NSInteger count = [self officailPlayCustomBetCount:valueList minNumber:0 maxNumber:9 betValueCount:3];
            return count;
        }else if ([detailPlayName isEqualToString:@"组三复式"]){
            NSArray *valueList = [allBetValueList firstObject];
            if (valueList.count<2) {
                return 0;
            }
            [self combine:(int)valueList.count index:2];
            return self.officailBetCount*2;
        }else if ([detailPlayName isEqualToString:@"组六复式"]){
            NSArray *valueList = [allBetValueList firstObject];
            if (valueList.count<3) {
                return 0;
            }
            [self combine:(int)valueList.count index:3];
            return self.officailBetCount;
        }
        
        
    }else if ([menuPlayName isEqualToString:@"二星"]) {
        
        if ([detailPlayName isEqualToString:@"前二直选复式"]||[detailPlayName isEqualToString:@"后二直选复式"]) {
            
            if (allBetValueList.count<2) {
                return 0;
            }
            NSInteger allCount = 0;
            for (NSArray *valueList in allBetValueList) {
                if (valueList.count ==0) {
                    return 0;
                }
                allCount = allCount>0?allCount * valueList.count:valueList.count;
            }
            return allCount;
            
        }else if ([detailPlayName isEqualToString:@"前二组选复式"]||[detailPlayName isEqualToString:@"后二组选复式"]){
            NSArray *valueList = [allBetValueList firstObject];
            if (valueList.count<2) {
                return 0;
            }
            [self combine:(int)valueList.count index:2];
            return self.officailBetCount;
        }
    }else if ([menuPlayName isEqualToString:@"不定位"]){
        
        if ([detailPlayName isEqualToString:@"一码不定位"]) {
            
            NSArray *valueList = [allBetValueList firstObject];
            return valueList.count;
            
        }else if ([detailPlayName isEqualToString:@"二码不定位"]){
            NSArray *valueList = [allBetValueList firstObject];
            if (valueList.count<2) {
                return 0;
            }
            [self combine:(int)valueList.count index:2];
            return self.officailBetCount;
        }
    }
    
    return 0;
}

-(NSInteger)k3OfficailPlayBetCountByMenuPlayName:(NSString *)menuPlayName
                                  detailPlayName:(NSString *)detailPlayName
                                         betInfo:(NSDictionary *)betInfo

{
    NSArray *allBetValueList = betInfo.allValues;
    if (allBetValueList.count == 0) {
        return 0;
    }
    self.officailBetCount = 0;
    if ([menuPlayName isEqualToString:@"和值"]||[menuPlayName isEqualToString:@"二同号"]||[menuPlayName isEqualToString:@"三同号"]){
        NSInteger count = 0;
        for (NSArray *list in allBetValueList) {
            count = count+ list.count;
        }
        return count;
    }else if ([menuPlayName isEqualToString:@"三不同号"]){
        
        if (allBetValueList.count!=2) {
            return 0;
        }
        NSMutableArray *numOneList = [[NSMutableArray alloc]initWithArray:[betInfo DWArrayForKey:@"胆码"]];
        NSMutableArray *numTwoList = [[NSMutableArray alloc]initWithArray:[betInfo DWArrayForKey:@"拖码"]];
        if (numOneList.count<1 || numTwoList.count<1) {
            return 0;
        }
        if (numOneList.count==2) {
            return numTwoList.count;
        }else if (numOneList.count == 1){
            [self combine:(int)numTwoList.count index:2];
            return self.officailBetCount;
        }
    }else if ([menuPlayName isEqualToString:@"二不同号"]){
        if (allBetValueList.count!=2) {
            return 0;
        }
        NSMutableArray *numOneList = [[NSMutableArray alloc]initWithArray:[betInfo DWArrayForKey:@"胆码"]];
        NSMutableArray *numTwoList = [[NSMutableArray alloc]initWithArray:[betInfo DWArrayForKey:@"拖码"]];
        if (numOneList.count<1 || numTwoList.count<1) {
            return 0;
        }
        return numTwoList.count;
    }
    
    return 0;
}

-(NSInteger)e11x5OfficailPlayBetCountByMenuPlayName:(NSString *)menuPlayName
                                     detailPlayName:(NSString *)detailPlayName
                                            betInfo:(NSDictionary *)betInfo

{
    NSArray *allBetValueList = betInfo.allValues;
    if (allBetValueList.count == 0) {
        return 0;
    }
    self.officailBetCount = 0;
    
    if ([menuPlayName isEqualToString:@"三码"]){
        
        if ([detailPlayName isEqualToString:@"直选复式"]) {
            
            if (allBetValueList.count!=3) {
                return 0;
            }
            NSMutableArray *numOneList = [[NSMutableArray alloc]initWithArray:allBetValueList[0]];
            NSMutableArray *numTwoList = [[NSMutableArray alloc]initWithArray:allBetValueList[1]];
            NSMutableArray *numThreeList = [[NSMutableArray alloc]initWithArray:allBetValueList[2]];
            
            for (NSString *oneValue in numOneList) {
                numTwoList = [[NSMutableArray alloc]initWithArray:allBetValueList[1]];
                for (NSString *twoValue in numTwoList) {
                    if (![twoValue isEqualToString:oneValue]) {
                        numThreeList = [[NSMutableArray alloc]initWithArray:allBetValueList[2]];
                        NSMutableIndexSet *indexSet = [NSMutableIndexSet new];
                        for (int i = 0;i<numThreeList.count;i++) {
                            NSString *threeValue = numThreeList[i];
                            if ([threeValue isEqualToString:twoValue] || [threeValue isEqualToString:oneValue]) {
                                [indexSet addIndex:i];
                            }
                        }
                        [numThreeList removeObjectsAtIndexes:indexSet];
                        if (numThreeList.count>=1) {
                            [self combine:(int)numThreeList.count index:1];
                        }
                        
                    }
                }
                
            }
            return self.officailBetCount;
            
        }else if ([detailPlayName isEqualToString:@"直选单式"]){
            NSString *customValue = [allBetValueList firstObject];
            NSArray *valueList = [self officalPlayCustomBetTransform:customValue];
            valueList = [self officailPlayCustomTransform123Form:valueList minValue:1 maxValue:11];
            NSInteger count = [self officailPlayCustomBetCount:valueList minNumber:1 maxNumber:11 betValueCount:3];
            return count;
        }else if ([detailPlayName isEqualToString:@"组选复式"]){
            NSArray *valueList = [allBetValueList firstObject];
            if (valueList.count<3) {
                return 0;
            }
            [self combine:(int)valueList.count index:3];
            return self.officailBetCount;
        }else if ([detailPlayName isEqualToString:@"组选单式"]){
            NSString *customValue = [allBetValueList firstObject];
            NSArray *valueList = [self officalPlayCustomBetTransform:customValue];
            valueList = [self officailPlayCustomTransform123Form:valueList minValue:1 maxValue:11];
            NSInteger count = [self officailPlayCustomBetCount:valueList minNumber:1 maxNumber:11 betValueCount:3];
            return count;
        }else if ([detailPlayName isEqualToString:@"组选胆拖"]){
            if (allBetValueList.count!=2) {
                return 0;
            }
            NSMutableArray *numOneList = [[NSMutableArray alloc]initWithArray:[betInfo DWArrayForKey:@"胆码|2"]];
            NSMutableArray *numTwoList = [[NSMutableArray alloc]initWithArray:[betInfo DWArrayForKey:@"拖码"]];
            if (numOneList.count<1 || numTwoList.count<1) {
                return 0;
            }
            if (numOneList.count==2) {
                return numTwoList.count;
            }else if (numOneList.count == 1){
                [self combine:(int)numTwoList.count index:2];
                return self.officailBetCount;
            }
        }
    }else if ([menuPlayName isEqualToString:@"二码"]){
        
        if ([detailPlayName isEqualToString:@"直选复式"]) {
            
            if (allBetValueList.count!=2) {
                return 0;
            }
            NSMutableArray *numOneList = [[NSMutableArray alloc]initWithArray:allBetValueList[0]];
            NSMutableArray *numTwoList = [[NSMutableArray alloc]initWithArray:allBetValueList[1]];
            if (numOneList.count<1 || numTwoList.count<1) {
                return 0;
            }
            for (NSString *oneValue in numOneList) {
                numTwoList = [[NSMutableArray alloc]initWithArray:allBetValueList[1]];
                for (NSString *twoValue in numTwoList) {
                    if ([twoValue isEqualToString:oneValue]) {
                        [numTwoList removeObject:twoValue];
                        break;
                    }
                }
                if (numTwoList.count>=1) {
                    [self combine:(int)numTwoList.count index:1];
                }
            }
            return self.officailBetCount;
            
        }else if ([detailPlayName isEqualToString:@"直选单式"]){
            NSString *customValue = [allBetValueList firstObject];
            NSArray *valueList = [self officalPlayCustomBetTransform:customValue];
            valueList = [self officailPlayCustomTransform12Form:valueList minValue:1 maxValue:11];
            NSInteger count = [self officailPlayCustomBetCount:valueList minNumber:1 maxNumber:11 betValueCount:2];
            return count;
        }else if ([detailPlayName isEqualToString:@"组选复式"]){
            NSArray *valueList = [allBetValueList firstObject];
            if (valueList.count<2) {
                return 0;
            }
            [self combine:(int)valueList.count index:2];
            return self.officailBetCount;
        }else if ([detailPlayName isEqualToString:@"组选单式"]){
            NSString *customValue = [allBetValueList firstObject];
            NSArray *valueList = [self officalPlayCustomBetTransform:customValue];
            valueList = [self officailPlayCustomTransform12Form:valueList minValue:1 maxValue:11];
            NSInteger count = [self officailPlayCustomBetCount:valueList minNumber:1 maxNumber:11 betValueCount:2];
            return count;
        }else if ([detailPlayName isEqualToString:@"组选胆拖"]){
            if (allBetValueList.count!=2) {
                return 0;
            }
            NSMutableArray *numOneList = [[NSMutableArray alloc]initWithArray:[betInfo DWArrayForKey:@"胆码|1"]];
            NSMutableArray *numTwoList = [[NSMutableArray alloc]initWithArray:[betInfo DWArrayForKey:@"拖码"]];
            if (numOneList.count<1 || numTwoList.count<1) {
                return 0;
            }
            return numTwoList.count;
        }
    }else if ([menuPlayName isEqualToString:@"不定位"]){
        
        if ([detailPlayName rangeOfString:@"三位"].length>0) {
            NSArray *valueList = [allBetValueList firstObject];
            return valueList.count;
        }
    }else if ([menuPlayName isEqualToString:@"定位胆"]){
        
        if ([detailPlayName isEqualToString:@"定位胆"]){
            NSInteger count = 0;
            for (NSArray *list in allBetValueList) {
                count = list.count + count;
            }
            return count;
        }
        
    }else if ([menuPlayName isEqualToString:@"任选复式"]){
        
        if ([detailPlayName isEqualToString:@"一中一"]){
            
            NSArray *valueList = [allBetValueList firstObject];
            if (valueList.count<1) {
                return 0;
            }
            [self combine:(int)valueList.count index:1];
            return self.officailBetCount;
        }else if ([detailPlayName isEqualToString:@"二中二"]){
            
            NSArray *valueList = [allBetValueList firstObject];
            if (valueList.count<2) {
                return 0;
            }
            [self combine:(int)valueList.count index:2];
            return self.officailBetCount;
        }else if ([detailPlayName isEqualToString:@"四中四"]){
            
            NSArray *valueList = [allBetValueList firstObject];
            if (valueList.count<4) {
                return 0;
            }
            [self combine:(int)valueList.count index:4];
            return self.officailBetCount;
            
        }else if ([detailPlayName isEqualToString:@"五中五"]){
            
            NSArray *valueList = [allBetValueList firstObject];
            if (valueList.count<5) {
                return 0;
            }
            [self combine:(int)valueList.count index:5];
            return self.officailBetCount;
        }else if ([detailPlayName isEqualToString:@"六中五"]){
            
            NSArray *valueList = [allBetValueList firstObject];
            if (valueList.count<6) {
                return 0;
            }
            [self combine:(int)valueList.count index:6];
            return self.officailBetCount;
        }else if ([detailPlayName isEqualToString:@"七中五"]){
            
            NSArray *valueList = [allBetValueList firstObject];
            if (valueList.count<7) {
                return 0;
            }
            [self combine:(int)valueList.count index:7];
            return self.officailBetCount;
        }else if ([detailPlayName isEqualToString:@"八中五"]){
            
            NSArray *valueList = [allBetValueList firstObject];
            if (valueList.count<8) {
                return 0;
            }
            [self combine:(int)valueList.count index:8];
            return self.officailBetCount;
        }
        
    }else if ([menuPlayName isEqualToString:@"任选单式"]){
        
        if ([detailPlayName isEqualToString:@"一中一"]){
            
            NSString *customValue = [allBetValueList firstObject];
            NSArray *valueList = [self officalPlayCustomBetTransform:customValue];
            valueList = [self officailPlayCustomTransformDifferentForm:valueList minValue:1 maxValue:11 betCount:1];
            return valueList.count;
            
        }else if ([detailPlayName isEqualToString:@"二中二"]){
            
            NSString *customValue = [allBetValueList firstObject];
            NSArray *valueList = [self officalPlayCustomBetTransform:customValue];
            valueList = [self officailPlayCustomTransformDifferentForm:valueList minValue:1 maxValue:11 betCount:2];
            return valueList.count;
            
        }else if ([detailPlayName isEqualToString:@"三中三"]){
            
            NSString *customValue = [allBetValueList firstObject];
            NSArray *valueList = [self officalPlayCustomBetTransform:customValue];
            valueList = [self officailPlayCustomTransformDifferentForm:valueList minValue:1 maxValue:11 betCount:3];
            return valueList.count;
            
        }else if ([detailPlayName isEqualToString:@"四中四"]){
            
            NSString *customValue = [allBetValueList firstObject];
            NSArray *valueList = [self officalPlayCustomBetTransform:customValue];
            valueList = [self officailPlayCustomTransformDifferentForm:valueList minValue:1 maxValue:11 betCount:4];
            return valueList.count;
            
        }else if ([detailPlayName isEqualToString:@"五中五"]){
            
            NSString *customValue = [allBetValueList firstObject];
            NSArray *valueList = [self officalPlayCustomBetTransform:customValue];
            valueList = [self officailPlayCustomTransformDifferentForm:valueList minValue:1 maxValue:11 betCount:5];
            return valueList.count;
            
        }else if ([detailPlayName isEqualToString:@"六中五"]){
            
            NSString *customValue = [allBetValueList firstObject];
            NSArray *valueList = [self officalPlayCustomBetTransform:customValue];
            valueList = [self officailPlayCustomTransformDifferentForm:valueList minValue:1 maxValue:11 betCount:6];
            return valueList.count;
            
        }else if ([detailPlayName isEqualToString:@"七中五"]){
            
            NSString *customValue = [allBetValueList firstObject];
            NSArray *valueList = [self officalPlayCustomBetTransform:customValue];
            valueList = [self officailPlayCustomTransformDifferentForm:valueList minValue:1 maxValue:11 betCount:7];
            return valueList.count;
            
        }else if ([detailPlayName isEqualToString:@"八中五"]){
            
            NSString *customValue = [allBetValueList firstObject];
            NSArray *valueList = [self officalPlayCustomBetTransform:customValue];
            valueList = [self officailPlayCustomTransformDifferentForm:valueList minValue:1 maxValue:11 betCount:8];
            return valueList.count;
        }
        
    }else if ([menuPlayName isEqualToString:@"任选胆拖"]){
        if (allBetValueList.count!=2) {
            return 0;
        }
        NSArray *keys = [betInfo allKeys];
        NSString *danMakey = @"";
        for (NSString *key in keys) {
            if ([key rangeOfString:@"胆码"].length>0) {
                danMakey = key;
                break;
            }
        }
        NSMutableArray *numOneList = [[NSMutableArray alloc]initWithArray:[betInfo DWArrayForKey:danMakey]];
        NSMutableArray *numTwoList = [[NSMutableArray alloc]initWithArray:[betInfo DWArrayForKey:@"拖码"]];
        NSInteger maxDanMaCount = 1;
        NSArray *danMaKeyList = [danMakey componentsSeparatedByString:@"|"];
        if (danMaKeyList.count>1) {
            maxDanMaCount = [danMaKeyList[1] integerValue];
        }
        
        if (numOneList.count<1 || numTwoList.count<=maxDanMaCount-numOneList.count) {
            return 0;
        }
        NSInteger minIndex = maxDanMaCount-numOneList.count+1;
        if (minIndex>0) {
            [self combine:(int)numTwoList.count index:(int)minIndex];
            return self.officailBetCount;
        }
        return 0;
        
    }
    
    self.officailBetCount = 0;
    return 0;
}


#pragma mark 排列组合计算

- (void)combine:(int)n index:(int)min
{
    for(int i = n; i >= min; i--)
    {
        if(min > 1)
        {
            [self combine:i-1 index:min-1];
        }
        else
        {
            self.officailBetCount += 1;
        }
    }
}

#pragma mark 直选单式转化注数

-(NSArray *)officalPlayCustomBetTransform:(NSString *)customBetString
{
    NSMutableArray *allValueList = [NSMutableArray new];
    if (customBetString.length>0) {
        NSArray *valueList = [customBetString componentsSeparatedByString:@","];
        NSSet *setList = [NSSet setWithArray:valueList];
        valueList = [[NSArray alloc]initWithArray:setList.allObjects];
        if (valueList.count>0) {
            for (NSString *value in valueList) {
                NSArray *list = [value componentsSeparatedByString:@" "];
                if (list.count>0) {
                    [allValueList addObject:list];
                }
            }
        }
    }
    return allValueList;
}

-(NSInteger)officailPlayCustomBetCount:(NSArray *)valueList
                             minNumber:(NSInteger)minNumber
                             maxNumber:(NSInteger)maxNumber
                         betValueCount:(NSInteger)betValueCount
{
    NSInteger count = valueList.count;
    NSMutableArray *finalValueList = [NSMutableArray new];
    for (NSArray *list in valueList) {
        
        if (list.count == betValueCount) {
            BOOL valid = YES;
            for (NSString *value in list) {
                NSInteger valueNumber = [value integerValue];
                if (!(valueNumber>=minNumber && valueNumber<=maxNumber)) {
                    count = count -1;
                    valid = NO;
                    break;
                }
            }
            if (valid) {
                [finalValueList addObject:list];
            }
        }else{
            count = count -1;
        }
        
    }
    self.officailCustomBetFianlValidValueList = finalValueList;
    return count;
}

#pragma mark 特殊下注形式转化

-(NSArray *)officailPlayCustomTransform221Form:(NSArray *)valueList
                                      minValue:(NSInteger)minValue
                                      maxValue:(NSInteger)maxValue
{
    NSMutableArray *finalValueList = [NSMutableArray new];
    for (NSArray *list in valueList) {
        
        if (list.count ==3) {
            if ([list[0]intValue]==[list[1]intValue]&&[list[0]intValue]!=[list[2]intValue]) {
                if (([list[0]intValue]>=minValue&&[list[0]intValue]<=maxValue)&&([list[1]intValue]>=minValue&&[list[1]intValue]<=maxValue)&&([list[2]intValue]>=minValue&&[list[2]intValue]<=maxValue)) {
                    [finalValueList addObject:list];
                    
                }
            }else if ([list[0]intValue]==[list[2]intValue]&&[list[0]intValue]!=[list[1]intValue]){
                if (([list[0]intValue]>=minValue&&[list[0]intValue]<=maxValue)&&([list[1]intValue]>=minValue&&[list[1]intValue]<=maxValue)&&([list[2]intValue]>=minValue&&[list[2]intValue]<=maxValue)) {
                    [finalValueList addObject:list];
                    
                }
                
            }else if ([list[1]intValue]==[list[2]intValue]&&[list[0]intValue]!=[list[1]intValue]){
                if (([list[0]intValue]>=minValue&&[list[0]intValue]<=maxValue)&&([list[1]intValue]>=minValue&&[list[1]intValue]<=maxValue)&&([list[2]intValue]>=minValue&&[list[2]intValue]<=maxValue)) {
                    [finalValueList addObject:list];
                    
                }
            }
        }
        
    }
    return finalValueList;
}

-(NSArray *)officailPlayCustomTransform123Form:(NSArray *)valueList
                                      minValue:(NSInteger)minValue
                                      maxValue:(NSInteger)maxValue
{
    NSMutableArray *finalValueList = [NSMutableArray new];
    for (NSArray *list in valueList) {
        
        if (list.count ==3) {
            if ([list[0]intValue]!=[list[1]intValue]&&[list[0]intValue]!=[list[2]intValue]&&[list[2]intValue]!=[list[1]intValue]) {
                if (([list[0]intValue]>=minValue&&[list[0]intValue]<=maxValue)&&([list[1]intValue]>=minValue&&[list[1]intValue]<=maxValue)&&([list[2]intValue]>=minValue&&[list[2]intValue]<=maxValue)) {
                    [finalValueList addObject:list];
                    
                }
                
            }
        }
        
    }
    return finalValueList;
}



-(NSArray *)officailPlayCustomTransform12Form:(NSArray *)valueList
                                     minValue:(NSInteger)minValue
                                     maxValue:(NSInteger)maxValue
{
    NSMutableArray *finalValueList = [NSMutableArray new];
    for (NSArray *list in valueList) {
        
        if (list.count ==2) {
            if ([list[0]intValue]!=[list[1]intValue]) {
                if (([list[0]intValue]>=minValue&&[list[0]intValue]<=maxValue)&&([list[1]intValue]>=minValue&&[list[1]intValue]<=maxValue)) {
                    [finalValueList addObject:list];
                    
                }
                
            }
        }
        
    }
    return finalValueList;
}

-(NSArray *)officailPlayCustomTransformDifferentForm:(NSArray *)valueList
                                            minValue:(NSInteger)minValue
                                            maxValue:(NSInteger)maxValue
                                            betCount:(NSInteger)betCount
{
    NSMutableArray *finalValueList = [NSMutableArray new];
    for (NSArray *list in valueList) {
        
        NSSet *set = [NSSet setWithArray:list];
        if (set.count == list.count && list.count == betCount) {
            BOOL verify = YES;
            for (NSString *value in set) {
                if ([value intValue]<minValue||[value intValue]>maxValue){
                    verify = NO;
                    break;
                }
            }
            if (verify) {
                [finalValueList addObject:list];
            }
        }
    }
    self.officailCustomBetFianlValidValueList = finalValueList;
    return finalValueList;
}

-(int)officailPlayTransformMaxDistanceFromValueA:(int)a
                                          valueB:(int)b
                                          valueC:(int)c
{
    int max = 0;
    int min = 0;
    if (a>=b) {
        if (a>=c) {
            max = a;
            if (b>=c) {
                min = c;
            }else{
                min = b;
            }
        }else{
            min = b;
            max = c;
        }
    }else{
        if (a<=c) {
            min = a;
            if (c>=b) {
                max = c;
            }else{
                max = b;
            }
        }else{
            min = c;
            max = b;
        }
    }
    
    return max-min;
}

@end

