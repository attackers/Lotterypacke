//
//  CPBuyLotteryForContentCell.m
//  lottery
//
//  Created by way on 2018/3/24.
//  Copyright © 2018年 way. All rights reserved.
//

#import "CPBuyLotteryForContentCell.h"
#import "CPBuyLtyContentItem.h"


@interface CPBuyLotteryForContentCell()
{
    // 55 102 119
    IBOutlet CPBuyLtyContentItem *_leftView;
    IBOutlet CPBuyLtyContentItem *_rightView;
    
    IBOutlet UIButton *_leftButton;
    IBOutlet UIButton *_rightButton;
}
@end

@implementation CPBuyLotteryForContentCell

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
    }
}

#pragma mark-

-(void)setSelectedLeftItem:(BOOL)selectedLeftItem
{
    _selectedLeftItem = selectedLeftItem;
    _leftView.hasSelected = _selectedLeftItem;
}

-(void)setSelectedRightItem:(BOOL)selectedRightItem
{
    _selectedRightItem = selectedRightItem;
    _rightView.hasSelected = _selectedRightItem;
}

-(void)setLeftItemPlayInfo:(NSDictionary *)leftItemPlayInfo
{
    
    if (leftItemPlayInfo && leftItemPlayInfo.allKeys.count>0) {
        //设置left的内容
        _leftView.hidden = NO;
        _leftButton.hidden = NO;
        [self addPlayInfo:leftItemPlayInfo onView:_leftView isSelected:_selectedLeftItem];
        
    }else{
        
        //清除left的内容
        _leftView.hidden = YES;
        _leftButton.hidden = YES;
    }
}

-(void)setRightItemPlayInfo:(NSDictionary *)rightItemPlayInfo
{
    if (rightItemPlayInfo && rightItemPlayInfo.allKeys.count>0) {
        //设置right的内容
        _rightView.hidden = NO;
        _rightButton.hidden = NO;
        [self addPlayInfo:rightItemPlayInfo onView:_rightView isSelected:_selectedRightItem];
        
    }else{
        //清除right的内容
        _rightView.hidden = YES;
        _rightButton.hidden = YES;
    }
}

-(void)addPlayInfo:(NSDictionary *)playInfo
            onView:(CPBuyLtyContentItem *)onView
        isSelected:(BOOL)isSelected
{
//
    CPBuyLtyBetContentItemType itemType = CPBuyLtyBetContentItemForSingleText;
    UIImage *singleImage;
    NSArray *images;
    NSAttributedString *textAtt;
    UIFont *font;
    NSString *singleText;
    UIColor *singleTextColor;
    NSAttributedString *imgAtt;
    
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
//    UIColor *playNameNormalColor = [UIColor blackColor];
//    UIColor *playNameSelectedColor = [UIColor whiteColor];
    UIColor *playNameNormalColor = RGBA(61, 61, 61, 1);
    UIColor *playNameSelectedColor = RGBA(11, 11, 11, 1);
    
//    UIColor *bonusNormalColor = kCOLOR_R_G_B_A(19, 75, 89, 1);
//    UIColor *bonusSelectedColor = kCOLOR_R_G_B_A(138, 216, 236, 1);
    UIColor *bonusNormalColor = RGBA(61, 61, 61, 1);
    UIColor *bonusSelectedColor = RGBA(11, 11, 11, 1);
    
    UIFont *playNameFont = [UIFont systemFontOfSize:15];
    UIFont *bonusFont = [UIFont systemFontOfSize:14];

    BOOL imageHasNeedTitle = YES;
    if ([CPBuyLotteryManager shareManager].isOfficailPlay) {
        
        if ([[CPBuyLotteryManager shareManager].currentOfficailPlayType isEqualToString:@"display"]) {
            itemType = CPBuyLtyBetContentItemForSingleText;
        }
    }else{
        
        switch ([CPBuyLotteryManager shareManager].currentBuyLotteryType) {
            case CPLotteryResultForPCDD:
            {
                singleImage = [self pcddBackgroundImageByNumber:playName];
                if (singleImage) {
                    itemType = CPBuyLtyBetContentItemForImageAndText;
                    //图片跟文字
                    
                }else{
                    //文字
                    itemType = CPBuyLtyBetContentItemForSingleText;
                }
                
            }break;
            case CPLotteryResultForXGLHC:
            {
                singleImage = [self lhcBackgroundImageByNumer:playName];
                if (singleImage) {
                    itemType = CPBuyLtyBetContentItemForImageAndText;
                    //图片跟文字
                    
                }else{
                    //文字
                    itemType = CPBuyLtyBetContentItemForSingleText;
                }
            }break;
            case CPLotteryResultForK3:
            {
                if ([[CPBuyLotteryManager shareManager].currentPlayKindDes isEqualToString:@"点数"]) {
                    itemType = CPBuyLtyBetContentItemForSingleText;
                    playName = [NSString stringWithFormat:@"%@点",playName];
                }else{
                    
                    if (playName.length>1) {
                        NSMutableArray *imgs = [NSMutableArray new];
                        for (int i = 0; i<playName.length; i++) {
                            NSRange range = NSMakeRange(i, 1);
                            UIImage *image = [self k3BackgroundImageByNumber:[playName substringWithRange:range]];
                            if (image) {
                                [imgs addObject:image];
                            }
                        }
                        images = imgs;
                        if (images.count>0) {
                            itemType = CPBuyLtyBetContentItemForImagesAndText;
                        }
                    }
                    if (itemType!=CPBuyLtyBetContentItemForImagesAndText) {
                        
                        singleImage = [self k3BackgroundImageByNumber:playName];
                        if (singleImage) {
                            itemType = CPBuyLtyBetContentItemForImageAndText;
                            imageHasNeedTitle = NO;
                        }else{
                            itemType = CPBuyLtyBetContentItemForSingleText;
                        }
                    }
                }
                
                
                
            }break;
            default:{
                
            }
                break;
        }
        if ([[CPBuyLotteryManager shareManager].currentPlayKindDes isEqualToString:@"数字盘"]) {
            playName = [NSString stringWithFormat:@"%@号",playName];
        }
    }
    

    switch (itemType) {
        case CPBuyLtyBetContentItemForSingleText:
        {
            NSString *string = [NSString stringWithFormat:@"%@ %@",playName,bonus];
            NSMutableAttributedString *attString = [[NSMutableAttributedString alloc]initWithString:string];
            [attString addAttributes:@{NSFontAttributeName:playNameFont,NSForegroundColorAttributeName:isSelected?playNameSelectedColor:playNameNormalColor} range:[string rangeOfString:playName]];
            [attString addAttributes:@{NSFontAttributeName:bonusFont,NSForegroundColorAttributeName:isSelected?bonusSelectedColor:bonusNormalColor} range:[string rangeOfString:[NSString stringWithFormat:@" %@",bonus]]];
            textAtt = attString;
            [onView addSingleAttributedString:textAtt];
            
        }break;
        case CPBuyLtyBetContentItemForSingleImage:
        {
            imgAtt = [[NSAttributedString alloc]initWithString:playName attributes:@{NSFontAttributeName:playNameFont,NSForegroundColorAttributeName:playNameNormalColor}];
            [onView addSingleImage:singleImage attributedString:imgAtt];
            
        }break;
        case CPBuyLtyBetContentItemForImagesAndText:
        {
            singleText = bonus;
            font = bonusFont;
            singleTextColor = isSelected?bonusSelectedColor:bonusNormalColor;
            [onView addImages:images font:font textColor:singleTextColor text:singleText];
        }break;
        case CPBuyLtyBetContentItemForImageAndText:
        {
            imgAtt = imageHasNeedTitle? [[NSAttributedString alloc]initWithString:playName attributes:@{NSFontAttributeName:playNameFont,NSForegroundColorAttributeName:playNameNormalColor}]:nil;
            singleText = bonus;
            font = bonusFont;
            singleTextColor = isSelected?bonusSelectedColor:bonusNormalColor;
            [onView addImage:singleImage imgAttributedString:imgAtt font:font textColor:singleTextColor text:singleText];
            
        }break;
        default:
            break;
    }
}

- (IBAction)buttonActions:(UIButton *)sender {
    
    NSInteger number = 0;
    if (sender.tag == 77) {
        //点击右边
        number = 1;
    }
    
    if (self.delegate) {
        [self.delegate cpBuyLtyBetContentSelectedIndexPath:self.indexPath offsetNumber:number];
    }
}

#pragma mark- getImages

/**
 六合
 */
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

/**
 pc蛋蛋
 */
-(UIImage *)pcddBackgroundImageByNumber:(NSString *)number
{
    NSString *name;
    
    NSArray *grayArray = @[@"00",@"0",@"13",@"14",@"27"];
    NSArray *greenArray = @[@"1",@"4",@"7",@"10",@"16",@"19",@"22",@"25",@"01",@"04",@"07"];
    NSArray *blueArray = @[@"2",@"5",@"8",@"11",@"17",@"20",@"23",@"26",@"02",@"05",@"08"];
    NSArray *redArray = @[@"3",@"6",@"9",@"12",@"15",@"18",@"21",@"24",@"03",@"06",@"09"];

    if ([grayArray containsObject:number]) {
        name = @"lty_result_lhc_gray";
    }else if ([greenArray containsObject:number]) {
        name = @"lty_result_lhc_green";
    }else if ([blueArray containsObject:number]) {
        name = @"lty_result_lhc_blue";
    }else if ([redArray containsObject:number]) {
        name = @"lty_result_lhc_red";
    }else{
        return nil;
    }
    
    return [UIImage imageNamed:name];
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

@end
