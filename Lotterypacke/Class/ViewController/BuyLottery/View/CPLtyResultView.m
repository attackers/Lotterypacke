//
//  CPLtyResultView.m
//  lottery
//
//  Created by way on 2018/3/29.
//  Copyright © 2018年 way. All rights reserved.
//

#import "CPLtyResultView.h"

@interface CPLtyResultView()

@property(nonatomic,assign)CPLotteryResultType resultType;

@end

@implementation CPLtyResultView



-(void)showResult:(NSArray *)result
       resultType:(CPLotteryResultType)resultType
{
    self.resultType = resultType;
    [self removeAllSubviews];
    switch (resultType) {
        case CPLotteryResultForPCDD:
        {
            [self buildPcddByResult:result];
        }break;
        case CPLotteryResultForXGLHC:
        {
            [self buildxglhcByResult:result];
        }break;
        case CPLotteryResultForKLSF:
        {
            [self buildklsfByResult:result];
            
        }break;
        case CPLotteryResultForPK10:
        case CPLotteryResultForXYFT:
        {
            [self buildPkshiByResult:result];
        }break;
        case CPLotteryResultForK3:
        {
            [self buildK3ByResult:result];
        }break;
        case CPLotteryResultForP13:
        case CPLotteryResultForSSC:
        case CPLotteryResultForFC3D:
        case CPLotteryResultForSHSSL:
        case CPLotteryResultForE11X5:
        {
            [self buildsscByResult:result];
        }break;

            
        default:
            break;
    }
    
}

-(void)buildPcddByResult:(NSArray *)result
{
    NSMutableArray *mResult = [[NSMutableArray alloc]initWithArray:result];
    if (mResult.count== 4) {
        [mResult insertObject:@"=" atIndex:3];
        [mResult insertObject:@"+" atIndex:2];
        [mResult insertObject:@"+" atIndex:1];
        
        CGSize itemSize = [self pcddBackgroundImageByNumber:@"1"].size;
        CGFloat itemWidth = itemSize.width;
        CGFloat itemHeight = itemSize.height;
        CGFloat originX = 0;
        CGFloat originY = (self.height-itemHeight)/2.0f;
        result = mResult;
        for (int i = 0; i<result.count; i++) {
            NSString *text = result[i];
            if ([text isEqualToString:@"+"]||[text isEqualToString:@"="]) {
                UILabel *label = [self specialNumberWithFrmae:CGRectMake(originX, originY, 15, itemHeight) text:text];
                [self addSubview:label];
                originX = label.rightX;
                
            }else{
               
                UIButton *item = [UIButton buttonWithType:UIButtonTypeCustom];
                item.frame = CGRectMake(originX, originY, itemWidth, itemHeight);
                [item setBackgroundImage:i==result.count-1?[self pcddBackgroundImageByNumber:text]:[self pcddBackgroundImageByNumber:@"100"] forState:UIControlStateNormal];
                [item setTitle:text forState:UIControlStateNormal];
                [item setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                item.titleLabel.font = [UIFont systemFontOfSize:16.0f];
                
                [self addSubview:item];
                originX = item.rightX;

            }
            
        }
    }
}

-(void)buildxglhcByResult:(NSArray *)result
{
    NSMutableArray *mResult = [[NSMutableArray alloc]initWithArray:result];
    NSMutableArray *sxNames = [[NSMutableArray alloc]initWithArray:[CPBuyLotteryManager shareManager].currentLhcResultSxNames];
    
    if (mResult.count>= 7) {
        [mResult insertObject:@"+" atIndex:6];
        if (sxNames.count>=7) {
            [sxNames insertObject:@"+" atIndex:6];
        }
        CGSize itemSize = [self pcddBackgroundImageByNumber:@"1"].size;
        CGFloat itemWidth = itemSize.width;
        CGFloat itemHeight = itemSize.height;
        CGFloat labelWidth = 15.0f;
        CGFloat gap = 2.0f;
        CGFloat fontSize = 16.0f;
        if ((itemWidth+gap)*7+labelWidth>self.width) {
            CGFloat newItemWidth = (self.width-labelWidth)/7.0f-gap;
            itemHeight = itemHeight*newItemWidth/itemWidth;
            fontSize = fontSize*newItemWidth/itemWidth;
            gap = gap*newItemWidth/itemWidth;
            itemWidth = newItemWidth;
            
        }
        CGFloat originX = 0;
        CGFloat letterHeight = 25.0f;
        CGFloat originY = (self.height-itemHeight-letterHeight)/2.0f;
        result = mResult;
        for (int i = 0; i<result.count; i++) {
            NSString *text = result[i];
            NSString *sxName = @"";
            if (i<sxNames.count) {
                sxName = sxNames[i];
            }
            if ([text isEqualToString:@"+"]||[text isEqualToString:@"="]) {
                UILabel *label = [self specialNumberWithFrmae:CGRectMake(originX, originY, labelWidth, itemHeight) text:text];
                label.font = [UIFont systemFontOfSize:fontSize];
                label.textColor = [UIColor redColor];
                [self addSubview:label];
                originX = label.rightX+gap;
                
            }else{
                
                UIButton *item = [UIButton buttonWithType:UIButtonTypeCustom];
                item.frame = CGRectMake(originX, originY, itemWidth, itemHeight);
                [item setBackgroundImage:[self lhcBackgroundImageByNumer:text] forState:UIControlStateNormal];
                [item setTitle:text forState:UIControlStateNormal];
                [item setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                item.titleLabel.font = [UIFont systemFontOfSize:fontSize];
                
                [self addSubview:item];
                
                
                UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(originX, item.bottomY, itemWidth, letterHeight)];
                label.font = [UIFont systemFontOfSize:16.0f];
                label.textColor = [UIColor whiteColor];
                label.textAlignment = NSTextAlignmentCenter;
                label.text = sxName;
                [self addSubview:label];
                
                originX = item.rightX+gap;
                
            }
            
        }
    }
}

-(void)buildsscByResult:(NSArray *)result
{
    
    CGSize itemSize = [self jssscBackgroundImageByNumber:@"1"].size;
    CGFloat itemWidth = itemSize.width;
    CGFloat itemHeight = itemSize.height;
    CGFloat gap = 2.0f;
    CGFloat fontSize = 16.0f;
    if ((itemWidth+gap)*result.count-gap>self.width) {
        CGFloat newItemWidth = (self.width-(result.count-1)*gap)/result.count;
        itemHeight = itemHeight*newItemWidth/itemWidth;
        fontSize = fontSize*newItemWidth/itemWidth;
        gap = gap*newItemWidth/itemWidth;
        itemWidth = newItemWidth;
    }
    CGFloat originX = 0;
    CGFloat originY = (self.height-itemHeight)/2.0f;
    for (int i = 0; i<result.count; i++) {
        NSString *text = result[i];
        UIImageView *imgView = [[UIImageView alloc]initWithImage:[self jssscBackgroundImageByNumber:text]];
        imgView.frame = CGRectMake(originX, originY, itemWidth, itemHeight);
        [self addSubview:imgView];
        originX = imgView.rightX+gap;
    }
}

-(void)buildklsfByResult:(NSArray *)result
{
    
    CGSize itemSize = [self klsfBackgroundImageByNumber:@"1"].size;
    CGFloat itemWidth = itemSize.width;
    CGFloat itemHeight = itemSize.height;
    CGFloat gap = 2.0f;
    CGFloat fontSize = 16.0f;
    if ((itemWidth+gap)*result.count-gap>self.width) {
        CGFloat newItemWidth = (self.width-(result.count-1)*gap)/result.count;
        itemHeight = itemHeight*newItemWidth/itemWidth;
        fontSize = fontSize*newItemWidth/itemWidth;
        gap = gap*newItemWidth/itemWidth;
        itemWidth = newItemWidth;
    }
    CGFloat originX = 0;
    CGFloat originY = (self.height-itemHeight)/2.0f;
    for (int i = 0; i<result.count; i++) {
        NSString *text = result[i];
        UIImageView *imgView = [[UIImageView alloc]initWithImage:[self klsfBackgroundImageByNumber:text]];
        imgView.frame = CGRectMake(originX, originY, itemWidth, itemHeight);
        [self addSubview:imgView];
        originX = imgView.rightX+gap;
    }
}

-(void)buildK3ByResult:(NSArray *)result
{

    
    CGSize itemSize = [self k3BackgroundImageByNumber:@"1"].size;
    CGFloat itemWidth = itemSize.width;
    CGFloat itemHeight = itemSize.height;
    CGFloat originX = 0;
    CGFloat originY = (self.height-itemHeight)/2.0f;
    CGFloat gap = 5.0f;
    for (int i = 0; i<result.count; i++) {
        NSString *text = result[i];
        UIImageView *imgView = [[UIImageView alloc]initWithImage:[self k3BackgroundImageByNumber:text]];
        imgView.frame = CGRectMake(originX, originY, itemWidth, itemHeight);
        [self addSubview:imgView];
        originX = imgView.rightX+gap;
    }
    
}

-(void)buildPkshiByResult:(NSArray *)result
{
    
    CGSize itemSize = [self pkshiBackgroundImageByNumber:@"1"].size;
    CGFloat itemWidth = itemSize.width;
    CGFloat itemHeight = itemSize.height;
    CGFloat gap = 1.0f;
    CGFloat fontSize = 16.0f;
    CGFloat originX = 0;
    CGFloat originY = 2;
    if ((itemWidth+gap)*result.count-gap>self.width) {
        CGFloat newItemWidth = (self.width-(result.count-1)*gap)/result.count;
        itemHeight = itemHeight*newItemWidth/itemWidth;
        fontSize = fontSize*newItemWidth/itemWidth;
        gap = gap*newItemWidth/itemWidth;
        itemWidth = newItemWidth;
    }else{
        originX = self.width +gap - (itemWidth+gap)*result.count;
    }
    
    for (int i = 0; i<result.count; i++) {
        NSString *text = result[i];
        UIImageView *imgView = [[UIImageView alloc]initWithImage:[self pkshiBackgroundImageByNumber:text]];
        imgView.frame = CGRectMake(originX, originY, itemWidth, itemHeight);
        [self addSubview:imgView];
        originX = imgView.rightX+gap;
    }
}


#pragma mark-

-(UILabel *)specialNumberWithFrmae:(CGRect)frame
                              text:(NSString *)text
{
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:14.0f];
    label.text = text;
    return label;
}

#pragma mark- 获取对应的图片资源

/**
 极速、三分、重庆、天津、新疆时时
 排列3、福彩3D、上海时时乐、以及
 广东、江西、上海、山东11选5
 */
-(UIImage *)jssscBackgroundImageByNumber:(NSString *)number
{
    int num = [number intValue];
    NSString *name = [NSString stringWithFormat:@"%d_jsssc_result_num",num];
    UIImage *img = [UIImage imageNamed:name];
    return img;
}

/**
 广东快乐十分
 重庆幸运农场
 */
-(UIImage *)klsfBackgroundImageByNumber:(NSString *)number
{
    int num = [number intValue];
    NSString *name = [NSString stringWithFormat:@"%d_cqxy_result_img",num];
    UIImage *img = [UIImage imageNamed:name];
    return img;
}


/**
 pk10
 飞艇,赛车
 */
-(UIImage *)pkshiBackgroundImageByNumber:(NSString *)number
{
    int num = [number intValue];
    NSString *name = [NSString stringWithFormat:@"%d_pk10_result_num",num];
    UIImage *img = [UIImage imageNamed:name];
    return img;
}

/**
 快3
 */
-(UIImage *)k3BackgroundImageByNumber:(NSString *)number
{
    int num = [number intValue];
    NSString *name = [NSString stringWithFormat:@"%d_k3_result_img",num];
    UIImage *img = [UIImage imageNamed:name];
    return img;
}

/**
 六合
 */
-(UIImage *)lhcBackgroundImageByNumer:(NSString *)number
{
    NSString *name;
    
    NSArray *redPoArray = @[@"1",@"2",@"7",@"8",@"12",@"13",@"18",@"19",@"23",@"24",@"29",@"30",@"34",@"35",@"40",@"45",@"46",@"01",@"02",@"07",@"08"];
    NSArray *bluePoArray = @[@"3",@"4",@"9",@"10",@"14",@"15",@"20",@"25",@"26",@"31",@"36",@"37",@"41",@"42",@"47",@"48",@"03",@"04",@"09"];
    
    if ([redPoArray containsObject:number]) {
        name = @"lty_result_lhc_red";
    }else if ([bluePoArray containsObject:number]){
        name = @"lty_result_lhc_blue";
    }else{
        name = @"lty_result_lhc_green";
    }
    
    return [UIImage imageNamed:name];
}


//-(NSString *)lhcDesStringByNumer:(NSString *)number
//{
//    NSString *des = @"";
//    [[CPBuyLotteryManager shareManager]loadHlcSxNamesForNum:@""];
//    return ;
//}

/**
 pc蛋蛋
 */
-(UIImage *)pcddBackgroundImageByNumber:(NSString *)number
{
    NSString *name;
    
    NSArray *grayArray = @[@"00",@"0",@"13",@"14",@"27"];
    NSArray *greenArray = @[@"1",@"4",@"7",@"10",@"16",@"19",@"22",@"25",@"01",@"04",@"07"];
    NSArray *blueArray = @[@"2",@"5",@"8",@"11",@"17",@"20",@"23",@"26",@"02",@"05",@"08"];
    if ([grayArray containsObject:number]) {
        name = @"lty_result_lhc_gray";
    }else if ([greenArray containsObject:number]) {
        name = @"lty_result_lhc_green";
    }else if ([blueArray containsObject:number]) {
        name = @"lty_result_lhc_blue";
    }else{
        name = @"lty_result_lhc_red";
    }
    
    return [UIImage imageNamed:name];
}


@end
