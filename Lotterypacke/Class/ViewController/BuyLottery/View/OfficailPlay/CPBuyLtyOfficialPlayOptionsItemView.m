//
//  CPBuyLtyOfficialPlayOptionsItemView.m
//  lottery
//
//  Created by way on 2018/6/26.
//  Copyright © 2018年 way. All rights reserved.
//

#import "CPBuyLtyOfficialPlayOptionsItemView.h"

@interface CPBuyLtyOfficialPlayOptionsItemView()
{
    IBOutlet UILabel *_topLineLabel;
    IBOutlet UILabel *_bottomLineLabel;
    IBOutlet UILabel *_titleLabel;
    
}

@property(nonatomic,copy)CPBuyLtyOfficialPlayOptionsItemViewClickAction click;

@end

@implementation CPBuyLtyOfficialPlayOptionsItemView

+(instancetype)loadWithFrame:(CGRect)frame
                  titleWidth:(CGFloat)titleWidth
                    dataInfo:(NSDictionary *)dataInfo
              selectedItemId:(NSString *)selectedItemId
                 isFirstItem:(BOOL)isFirstItem
                 isFinalItem:(BOOL)isFinalItem
                       index:(NSInteger)index
                 clickAction:(CPBuyLtyOfficialPlayOptionsItemViewClickAction)click
{
    CPBuyLtyOfficialPlayOptionsItemView *view = [CPBuyLtyOfficialPlayOptionsItemView createViewFromNib];
    [view reloadWithFrame:frame titleWidth:titleWidth dataInfo:dataInfo selectedItemId:selectedItemId isFirstItem:isFirstItem isFinalItem:isFinalItem index:index clickAction:click];
    return view;
}

-(void)reloadWithFrame:(CGRect)frame
            titleWidth:(CGFloat)titleWidth
              dataInfo:(NSDictionary *)dataInfo
        selectedItemId:(NSString *)selectedItemId
           isFirstItem:(BOOL)isFirstItem
           isFinalItem:(BOOL)isFinalItem
                 index:(NSInteger)index
           clickAction:(CPBuyLtyOfficialPlayOptionsItemViewClickAction)click

{
    self.frame = frame;
    
    self.click = click;
    self.tag = index;
    _titleLabel.text = [dataInfo DWStringForKey:@"name"];
    _titleLabel.width = titleWidth;
    NSArray *playList = [dataInfo DWArrayForKey:@"play"];
    CGFloat itemGap = 10.0f;
    CGFloat itemHeight = 30.0f;
    CGFloat originX = _titleLabel.rightX + 10;
    CGFloat originY = 0;
    
    UIFont *itemTitleFont = kScreenWidth>320?[UIFont systemFontOfSize:16.0f]:[UIFont systemFontOfSize:15.0f];
    
    CGFloat sutWidth = (self.width - originX - itemGap*2) /2.0f;
    CGFloat maxWidth = self.width - originX - itemGap;

    for (int i = 0; i<playList.count; i++) {
        
        NSDictionary *info = playList[i];
        NSString * name = [info DWStringForKey:@"name"];
        CGFloat width = [name suitableFromMaxSize:CGSizeMake(self.width-_titleLabel.rightX-itemGap, 30) font:itemTitleFont].width+5;
        width = width<=sutWidth?sutWidth:maxWidth;
        
        if (self.width - originX - itemGap - width <-1) {
            originY = originY + itemGap/2.0f + itemHeight;
            originX = _titleLabel.rightX + 10;
        }
        CGRect itemFrame = CGRectMake(originX, originY, width, itemHeight);
        BOOL isSelected = [selectedItemId isEqualToString:[info DWStringForKey:@"playId"]];
        __weak typeof(self) weakSelf = self;
        CPBuyLtyOfficialPlayOptionsItem *item = [CPBuyLtyOfficialPlayOptionsItem buttonWithFrame:itemFrame titleText:[info DWStringForKey:@"name"]titleFont:itemTitleFont index:i isSelected:isSelected clickAction:^(NSInteger clickIndex) {
            if (weakSelf.click) {
                NSIndexPath *clickIndexPath = [NSIndexPath indexPathForRow:clickIndex inSection:weakSelf.tag];
                weakSelf.click(clickIndexPath);
            }
        }];
        originX = item.rightX + itemGap;
        [self addSubview:item];
    }

//    for (int r = 0; r<rowCount; r++) {
//
//        for (int l = 0; l<lineCount; l++) {
//            NSInteger valueIndex = r*lineCount+l;
//            if (valueIndex>=playList.count) {
//                break;
//            }
//            NSDictionary *info = playList[valueIndex];
//            originX = l*(itemWidth+itemGap)+_titleLabel.rightX;
//            originY = r*(itemHeight+itemGap);
//            CGRect itemFrame = CGRectMake(originX, originY, itemWidth, itemHeight);
//            BOOL isSelected = [selectedItemId isEqualToString:[info DWStringForKey:@"playId"]];
//            __weak typeof(self) weakSelf = self;
//            CPBuyLtyOfficialPlayOptionsItem *item = [CPBuyLtyOfficialPlayOptionsItem buttonWithFrame:itemFrame titleText:[info DWStringForKey:@"name"]titleFont:itemTitleFont index:valueIndex isSelected:isSelected clickAction:^(NSInteger clickIndex) {
//                if (weakSelf.click) {
//                    NSIndexPath *clickIndexPath = [NSIndexPath indexPathForRow:clickIndex inSection:weakSelf.tag];
//                    weakSelf.click(clickIndexPath);
//                }
//            }];
//            [self addSubview:item];
//        }
//
//    }
    self.height = isFinalItem?originY + itemHeight:originY + itemHeight + 15.0f;
    _topLineLabel.hidden = isFirstItem;
    _bottomLineLabel.hidden = isFinalItem;
    [self layoutSubviews];
}

@end
