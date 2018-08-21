//
//  CPBuyLtyContentCell.m
//  lottery
//
//  Created by way on 2018/8/5.
//  Copyright © 2018年 way. All rights reserved.
//

#import "CPBuyLtyContentCell.h"

@interface CPBuyLtyContentCell()
{
    NSIndexPath *_indexPath;
}
@property(nonatomic,weak)id<CPBuyLtyBetContentProtocol>delegate;
@property(nonatomic,retain)NSMutableArray *itemList;
@end

@implementation CPBuyLtyContentCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(NSMutableArray *)itemList
{
    if (!_itemList) {
        _itemList = [NSMutableArray new];
    }
    return _itemList;
}

+(CGFloat)cellHeightByShape:(CPBuyLtyCellContentItemShape)shape
                 layoutType:(CPBuyLtyCellContentItemLayoutType)layoutType
               isIncludeGap:(BOOL)includeGap
{
    CGFloat height = 0;
    if (shape == CPBuyLtyCellContentItemShapeForCircle) {
        height += 40;
    }else if (shape == CPBuyLtyCellContentItemShapeForRect) {
        height += 30;
    }
    
    if (layoutType == CPBuyLtyCellContentItemLayoutContentTextAndBonusValue) {
        height += 20;
    }
    
    if (includeGap) {
        height += 10.0f;
    }
    
    return height;
}

-(void)addPlayInfoList:(NSArray *)playInfoList
          selectedList:(NSArray *)selectedList
                 shape:(CPBuyLtyCellContentItemShape)shape
            layoutType:(CPBuyLtyCellContentItemLayoutType)layoutType
              delegate:(id<CPBuyLtyBetContentProtocol>)delegate
           atIndexPath:(NSIndexPath *)indexPath
    maxNumberOfSection:(NSInteger)maxNumberOfSection
{
    self.delegate = delegate;
    _indexPath = indexPath;
    
    while (self.itemList.count<playInfoList.count) {
        CPBuyLtyCellContentItem *item = [[CPBuyLtyCellContentItem alloc]initWithActionTarget:self selector:@selector(clickActions:)];
        [self.itemList addObject:item];
        [self.contentView addSubview:item];
    }
    
    while (self.itemList.count>playInfoList.count) {
        CPBuyLtyCellContentItem *existItem = _itemList.lastObject;
        if (existItem.superview) {
            [existItem removeFromSuperview];
        }
        [self.itemList removeLastObject];
    }
    
    CGFloat gap = 15.0f;
    if (kScreenWidth<=320) {
        gap = 6;
    }else if (kScreenWidth<=375){
        gap = 10;
    }
    CGFloat itemWidth = (self.width - gap*(maxNumberOfSection+1))/maxNumberOfSection;
    CGFloat itemHeight = [CPBuyLtyContentCell cellHeightByShape:shape layoutType:layoutType isIncludeGap:NO];
    for (int i = 0; i<playInfoList.count; i++) {
        CPBuyLtyCellContentItem *item = self.itemList[i];
        BOOL hasSelected = [selectedList[i] intValue] == 1?YES:NO;
        item.markIndex = 100 + i;
        NSString *playName = @"";
        NSString *playBonus = @"";
        NSDictionary *playInfo = playInfoList[i];
        [self anlyzePlayInfo:playInfo playName:&playName playBonus:&playBonus];
        [item addFrame:CGRectMake(i*(itemWidth+gap)+gap, 0, itemWidth, itemHeight) contentText:playName bonusValue:playBonus shape:shape layoutType:layoutType hasSelected:hasSelected];
    }
    
}
-(void)anlyzePlayInfo:(NSDictionary *)playInfo
             playName:(NSString **)fPlayName
            playBonus:(NSString **)fPlayBonus
{
    NSString *playName = [playInfo DWStringForKey:@"playName"];
    NSString *bonus = [playInfo DWStringForKey:@"gfBonus"];
    if (bonus.length == 0) {
        bonus = [[[CPBuyLotteryManager shareManager]fetchDoubleFacePlayBounsByPlayId:[playInfo DWStringForKey:@"playId"]]jdM];
        if ([[playInfo DWStringForKey:@"useBonus"]intValue]==1) {
            bonus = [playInfo DWStringForKey:@"bonus"];
        }
    }
    
    NSArray *aryBonus = [bonus componentsSeparatedByString:@"."];
    if (aryBonus.count>1) {
        NSString *littleBonus = aryBonus[1];
        if (littleBonus.length>2) {
            bonus = [NSString stringWithFormat:@"%@",[bonus jdM]];
        }
    }
    
    if (![CPBuyLotteryManager shareManager].isOfficailPlay) {
        
        if ([[CPBuyLotteryManager shareManager].currentPlayKindDes isEqualToString:@"合肖"]) {
            playName = [NSString stringWithFormat:@"%@ %@",playName,bonus];
        }else if ([[CPBuyLotteryManager shareManager].currentPlayKindDes isEqualToString:@"点数"]) {
            playName = [NSString stringWithFormat:@"%@点",playName];
        }else if ([[CPBuyLotteryManager shareManager].currentPlayKindDes isEqualToString:@"数字盘"]) {
            playName = [NSString stringWithFormat:@"%@号",playName];
        }
    }
    
    *fPlayName = playName;
    *fPlayBonus = bonus;
}

- (void)clickActions:(UIButton *)sender {
    
    NSInteger number = sender.tag - 100;

    if (self.delegate) {
        [self.delegate cpBuyLtyBetContentSelectedIndexPath:_indexPath offsetNumber:number];
    }
}

@end
