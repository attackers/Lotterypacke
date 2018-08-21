//
//  CPBuyLotteryManager.h
//  lottery
//
//  Created by way on 2017/11/26.
//  Copyright © 2017年 way. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CPLotteryModel.h"

/*
 e11x5  11选5
 xglhc  六合彩
 ssc    时时彩
 shssl  上海时时乐
 pl3    排列三
 pk10   PK10
 pcdd   PC蛋蛋
 klsf   快乐十分
 k3     快三
 fc3d   福彩3D
 xyft   幸运飞艇
 */
typedef enum : NSUInteger {
    
    CPLotteryResultForE11X5     = 0,
    CPLotteryResultForXGLHC     = 1,
    CPLotteryResultForSSC       = 2,
    CPLotteryResultForSHSSL     = 3,
    CPLotteryResultForP13       = 4,
    CPLotteryResultForPK10      = 5,
    CPLotteryResultForPCDD      = 6,
    CPLotteryResultForKLSF      = 7,
    CPLotteryResultForK3        = 8,
    CPLotteryResultForFC3D      = 9,
    CPLotteryResultForXYFT      = 10
    
} CPLotteryResultType;


#define CPLotteryResultTypeByTypeString(typeString)\
[@[@"e11x5",@"lhc",@"ssc",@"shssl",@"pl3",@"pk10",@"pcdd",@"klsf",@"k3",@"fc3d",@"xyft"] indexOfObject:typeString]

@interface CPBuyLotteryManager : NSObject


+(instancetype)shareManager;



/**
 当前的购买彩种的类型
 */
@property(nonatomic,assign)CPLotteryResultType currentBuyLotteryType;


/**
 当前最新一期lhc的开奖生肖
 */
@property(nonatomic,retain)NSArray *currentLhcResultSxNames;


/**
 是否官方玩法
 */
@property(nonatomic,assign)BOOL isOfficailPlay;


/**
 当前选择的官方玩法的类型
 */
@property(nonatomic,copy)NSString *currentOfficailPlayType;


@property(nonatomic,copy)NSString *currentBuyLotteryTypeString;

/**
 当前的彩种类型
 */
@property(nonatomic,copy)NSString *currentLotteryName;

/**
 当前的玩法名称
 */
@property(nonatomic,copy)NSString *currentPlayKindDes;


/*
 当前投注期数
 */
@property(nonatomic,copy)NSString *currentBetPeriod;


/*
 当前彩种类型的gid
 */
@property(nonatomic,copy)NSString *currentLtyGid;


/**
 跳到下注界面
 */
-(void)pushToBuyLtyDetailVCFromNav:(UINavigationController *)fromNav
                           ltyName:(NSString *)ltyName
                           ltyCode:(NSString *)ltyCode
                            ltyNum:(NSString *)ltyNum;

/**
 判断是否已有投注内容
 */
-(BOOL)hasExistBuyLtyBigInfoByVersion:(NSString *)version;



/**
 根据玩法返回投注信息内容
 */
-(NSArray *)loadBuyLtyCurrentPlayDetailListByPlayId:(NSString *)playId;


/**
 根据玩法id获取当前双面玩法的具体赔率
 */
-(NSString *)fetchDoubleFacePlayBounsByPlayId:(NSString *)playId;

/**
 获取LHC的sxNames
 */
-(NSDictionary *)loadHlcSxNamesForNum:(NSString *)num;

/**
 获取投注的内容信息
 */
-(void)queryLtyBigInfoCompleted:(void(^)(BOOL isSucceed))completed;

/**
 获取快3类型的图片

 @param number 数字
 */
+(UIImage *)k3BackgroundImageByNumber:(NSString *)number;



-(void)loadGfInfoByLtyCode:(NSString *)ltyCode
                  nameList:(NSArray **)nameList
              playListInfo:(NSDictionary **)playListInfo;



/**
 计算官方玩法的投注注单个数

 @param typeCode 彩种类型
 @param menuPlayName 玩法menu
 @param detailPlayName 具体玩法
 @param betInfo 下注信息
 @return 注单个数
 */
-(NSInteger)officailPlayBetCountByTypeCode:(NSString *)typeCode
                              menuPlayName:(NSString *)menuPlayName
                            detailPlayName:(NSString *)detailPlayName
                                   betInfo:(NSDictionary *)betInfo;

-(NSArray *)officailPlayBetCustomFinalValidValueList;


@end
