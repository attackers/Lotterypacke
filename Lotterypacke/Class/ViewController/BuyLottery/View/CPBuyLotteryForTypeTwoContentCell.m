//
//  CPBuyLotteryForTypeTwoContentCell.m
//  lottery
//
//  Created by way on 2018/4/5.
//  Copyright © 2018年 way. All rights reserved.
//

#import "CPBuyLotteryForTypeTwoContentCell.h"
#import "CPBuyLtyContentItem.h"

@interface CPBuyLotteryForTypeTwoContentCell()
{
    
    IBOutlet CPBuyLtyContentItem *contentItem_1;
    IBOutlet CPBuyLtyContentItem *contentItem_2;
    IBOutlet CPBuyLtyContentItem *contentItem_3;
    IBOutlet CPBuyLtyContentItem *contentItem_4;
    IBOutlet CPBuyLtyContentItem *contentItem_5;
}
@property(nonatomic,retain)NSArray *contentItems;
@property(nonatomic,retain)NSArray *ltyInfos;
@property(nonatomic,retain)NSArray *selectedList;

@end

@implementation CPBuyLotteryForTypeTwoContentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setFrame:(CGRect)frame
{
    CGSize originSize = self.size;
    [super setFrame:frame];
    if (CGSizeEqualToSize(originSize, self.frame.size) == NO) {
        [self layoutSubviews];
        [self.contentView layoutSubviews];
        for (UIView *item in self.contentView.subviews) {
            [item layoutSubviews];
        }
    }
}

-(NSArray *)contentItems
{
    if (!_contentItems) {
        _contentItems = @[contentItem_1,contentItem_2,contentItem_3,contentItem_4,contentItem_5];
    }
    return _contentItems;
}

-(void)addLtyInfos:(NSArray *)infos
      selectedList:(NSArray *)selectedList
{
    self.selectedList = selectedList;
    self.ltyInfos = infos;
}

-(void)setLtyInfos:(NSArray *)ltyInfos
{
    _ltyInfos = ltyInfos;
    for (int i = 0; i<self.contentItems.count; i++) {
        CPBuyLtyContentItem *item = self.contentItems[i];
        if (_ltyInfos.count>i) {
            NSDictionary *info = _ltyInfos[i];
            NSString *playName = [info DWStringForKey:@"playName"];
//            UIColor *playNameNormalColor = [UIColor blackColor];
            UIColor *playNameNormalColor = RGBA(51, 51, 51, 1);
            UIFont *playNameFont = [UIFont systemFontOfSize:15];
            UIImage *singleImage = [self lhcBackgroundImageByNumer:playName];
            NSAttributedString *imgAtt = [[NSAttributedString alloc]initWithString:playName attributes:@{NSFontAttributeName:playNameFont,NSForegroundColorAttributeName:playNameNormalColor}];
            [item addSingleImage:singleImage attributedString:imgAtt];
            if ([[self.selectedList objectAtIndex:i]intValue]==1) {
                item.hasSelected = YES;
            }else{
                item.hasSelected = NO;
            }
            item.hidden = NO;
        }else{
            
            item.hidden = YES;
            item.hasSelected = NO;
        }
        
    }
}

- (IBAction)buttonActions:(UIButton *)sender {
    
    
    NSInteger number = sender.superview.tag-100;
    if (self.delegate) {
        [self.delegate cpBuyLtyBetContentSelectedIndexPath:self.indexPath offsetNumber:number];
    }
    
}

-(UIImage *)lhcBackgroundImageByNumer:(NSString *)number
{
    NSString *name;
    
    NSArray *redPoArray = @[@"1",@"2",@"7",@"8",@"12",@"13",@"18",@"19",@"23",@"24",@"29",@"30",@"34",@"35",@"40",@"45",@"46",@"01",@"02",@"07",@"08"];
    NSArray *bluePoArray = @[@"3",@"4",@"9",@"10",@"14",@"15",@"20",@"25",@"26",@"31",@"36",@"37",@"41",@"42",@"47",@"48",@"03",@"04",@"09"];
    NSArray *greenPoArray = @[@"5",@"6",@"11",@"16",@"17",@"21",@"22",@"27",@"28",@"32",@"33",@"35",@"38",@"39",@"43",@"44",@"47",@"49",@"05",@"06"];
    
    if ([redPoArray containsObject:number]) {
        name = @"lty_result_lhc_red";
    }else if ([bluePoArray containsObject:number]){
        name = @"lty_result_lhc_blue";
    }else if ([greenPoArray containsObject:number]){
        name = @"lty_result_lhc_green";
    }else{
        nil;
    }
    
    return [UIImage imageNamed:name];
}


@end
