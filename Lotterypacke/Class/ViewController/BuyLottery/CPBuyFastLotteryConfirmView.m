//
//  CPBuyCustomLotteryConfirmView.m
//  lottery
//
//  Created by wayne on 2017/9/19.
//  Copyright © 2017年 way. All rights reserved.
//

#import "CPBuyFastLotteryConfirmView.h"

@interface CPBuyFastLotteryConfirmView ()<UITextFieldDelegate>
{
    IBOutlet UIView *_contentView;
    IBOutlet UIScrollView *_scrollView;
    
    IBOutlet UILabel *_topTitleLabel;
    IBOutlet UILabel *_titleLabel;
    IBOutlet UILabel *_contentLabel;
    
    IBOutlet UITextField *_betAmountTf;
    
    IBOutlet UIView *_betCoinView;
    
    NSString *_numberPeriods;
    NSArray *_lotterys;
    
    IBOutlet UIView *_tfBgView;
    IBOutlet UIButton *_cleanBtn;
    
    NSInteger _betCount;
    
    IBOutlet UIButton *_yuanButton;
    IBOutlet UIButton *_jiaoButton;
    
    IBOutlet UIView *_yuanJiaoBgView;

    
    
}


@property(nonatomic,copy)CPBuyFastLotteryConfirmAction confirm;
@property(nonatomic,assign)BOOL isOfficail;
@property(nonatomic,assign)BOOL isOfficailSpecial;
@property(nonatomic,assign)BOOL isUseYuan;
@property(nonatomic,copy)NSString *officailBonuds;
@property(nonatomic,assign)int specailType;
@end

@implementation CPBuyFastLotteryConfirmView

-(void)awakeFromNib
{
    [super awakeFromNib];

    _cleanBtn.layer.cornerRadius = 3.0f;
    _cleanBtn.layer.masksToBounds = YES;

    _betAmountTf.keyboardType = UIKeyboardTypeDecimalPad;
    
    _yuanJiaoBgView.layer.cornerRadius = 3.0f;
    _yuanJiaoBgView.layer.borderWidth = 1.0f;
    _yuanJiaoBgView.layer.masksToBounds = YES;
    _yuanJiaoBgView.layer.borderColor = kCOLOR_R_G_B_A(185, 27, 10, 1).CGColor;
    
    _contentView.layer.cornerRadius = 5.0f;
    _contentView.layer.borderWidth = 1.0f;
    _contentView.layer.masksToBounds = YES;
    _contentView.layer.borderColor = kCOLOR_R_G_B_A(153, 153, 153, 1).CGColor;
    
    
    _tfBgView.layer.cornerRadius = 3.0f;
    _tfBgView.layer.borderWidth = kGlobalLineWidth;
    _tfBgView.layer.masksToBounds = YES;
    _tfBgView.layer.borderColor = kCOLOR_R_G_B_A(153, 153, 153, 1).CGColor;
    
    [_yuanButton setBackgroundImage:[UIImage imageWithColor:kCOLOR_R_G_B_A(185, 27, 10, 1)] forState:UIControlStateSelected];
    [_jiaoButton setBackgroundImage:[UIImage imageWithColor:kCOLOR_R_G_B_A(185, 27, 10, 1)] forState:UIControlStateSelected];
    
    [_yuanButton setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [_jiaoButton setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    
    self.isUseYuan = YES;
}

+(void)showFastLotteryConfirmViewOnView:(UIView *)supView
                               lotterys:(NSArray *)lotterys
                          numberPeriods:(NSString *)numberPeriods
                                comfirm:(CPBuyFastLotteryConfirmAction)confirm
{
    [CPBuyFastLotteryConfirmView showFastLotteryConfirmViewOnView:supView lotterys:lotterys numberPeriods:numberPeriods specailType:0 comfirm:confirm];
}

+(void)showFastLotteryConfirmViewOnView:(UIView *)supView
                               lotterys:(NSArray *)lotterys
                          numberPeriods:(NSString *)numberPeriods
                            specailType:(int)specailType
                                comfirm:(CPBuyFastLotteryConfirmAction)confirm
{
    CPBuyFastLotteryConfirmView *view = [CPBuyFastLotteryConfirmView createViewFromNib];
    view.specailType = specailType;
    view.isOfficail = NO;
    [view showOnView:supView lotterys:lotterys numberPeriods:numberPeriods comfirm:confirm];
}

+(void)showOfficailFastLotteryConfirmViewOnView:(UIView *)supView
                                      isSpecial:(BOOL)isSpecial
                                  officailBonus:(NSString *)officailBonus
                                   ltyDesString:(NSAttributedString *)ltyDesString
                                       betCount:(NSInteger)betCount
                                  numberPeriods:(NSString *)numberPeriods
                                        comfirm:(CPBuyFastLotteryConfirmAction)confirm
{
    CPBuyFastLotteryConfirmView *view = [CPBuyFastLotteryConfirmView createViewFromNib];
    view.officailBonuds = officailBonus;
    view.isOfficail = YES;
    view.isOfficailSpecial = isSpecial;
    [view showOnView:supView ltyDesString:ltyDesString betCount:betCount numberPeriods:numberPeriods comfirm:confirm];
}


-(void)setIsUseYuan:(BOOL)isUseYuan
{
    _isUseYuan = isUseYuan;
    _jiaoButton.selected = !_isUseYuan;
    _yuanButton.selected = _isUseYuan;
    
}

#pragma mark- buttonAction


- (IBAction)buttonAction:(UIButton *)sender {
    
    if (self.confirm) {
        BOOL isConfirm = (sender.tag == 11)?NO:YES;
        if (isConfirm && [_betAmountTf.text doubleValue] <= 0) {
            [SVProgressHUD way_showInfoCanTouchAutoDismissWithStatus:@"请填写下注金额"];
            return;
        }
        double yuanValue = [_betAmountTf.text doubleValue];
        if (!self.isUseYuan) {
            yuanValue = yuanValue/10.0f;
        }
        self.confirm(isConfirm,[NSString stringWithFormat:@"%f",yuanValue]);
    }
    [self dismiss];
}

-(void)showOnView:(UIView *)onView
     ltyDesString:(NSAttributedString *)ltyDesString
         betCount:(NSInteger)betCount
    numberPeriods:(NSString *)numberPeriods
          comfirm:(CPBuyFastLotteryConfirmAction)confirm
{
    _numberPeriods = numberPeriods;
    _betCount = betCount;
    self.confirm = confirm;
    
    self.frame = CGRectMake(0, 0, onView.width, onView.height);
    [self layoutSubviews];
    
    NSString *topTitle = [NSString stringWithFormat:@"当前第%@期",numberPeriods];
    NSMutableAttributedString * topAtt = [[NSMutableAttributedString alloc]initWithString:topTitle attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:kCOLOR_R_G_B_A(102, 102, 102, 1)}];
    [topAtt addAttributes:@{NSForegroundColorAttributeName:kCOLOR_R_G_B_A(193, 38, 33, 1)} range:[topTitle rangeOfString:numberPeriods]];
    _topTitleLabel.attributedText = topAtt ;
    
    NSString *title = [NSString stringWithFormat:@"请确认当前第%@期",numberPeriods];
    NSMutableAttributedString * att = [[NSMutableAttributedString alloc]initWithString:title attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:13],NSForegroundColorAttributeName:[UIColor blackColor]}];
    [att addAttributes:@{NSForegroundColorAttributeName:kMainColor} range:[title rangeOfString:numberPeriods]];
    _titleLabel.attributedText = att;
    
    
    CGFloat originY = 0;
    
    //创建2个label（投注内容，投注注数）

    CGFloat betContentHeight = [ltyDesString.string suitableFromMaxSize:CGSizeMake(_scrollView.width, MAXFLOAT) font:[UIFont systemFontOfSize:16.0f]].height+3;
    
    UILabel *betContentLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, originY, _scrollView.width, betContentHeight)];
    betContentLabel.textAlignment = NSTextAlignmentLeft;
    betContentLabel.numberOfLines = 0;
    betContentLabel.font = [UIFont systemFontOfSize:16.0f];
    betContentLabel.attributedText = ltyDesString;
    [_scrollView addSubview:betContentLabel];
    
    originY = betContentLabel.bottomY + 15;
    
    
    CGFloat othersHeight = 245;
    CGFloat contentHeight = betContentLabel.bottomY + 10;
    CGFloat scrollHeight = (contentHeight+othersHeight>=self.height*0.7)?(self.height*0.7-othersHeight):contentHeight;
    
    _contentView.height = othersHeight+scrollHeight;
    [_contentView layoutSubviews];
    
    _contentView.centerY = (self.height-_contentView.height)/2.0f+_contentView.height/2.0f;
    _scrollView.contentSize = CGSizeMake(_scrollView.width,contentHeight);
    
    [self layoutBetCoinViewSubviews];
    [self showOnView:onView];
}

-(void)showOnView:(UIView *)onView
         lotterys:(NSArray *)lotterys
    numberPeriods:(NSString *)numberPeriods
          comfirm:(CPBuyFastLotteryConfirmAction)confirm
{
    _numberPeriods = numberPeriods;
    _lotterys = lotterys;
    self.confirm = confirm;

    self.frame = CGRectMake(0, 0, onView.width, onView.height);
    [self layoutSubviews];
    
    NSString *topTitle = [NSString stringWithFormat:@"当前第%@期",numberPeriods];
    NSMutableAttributedString * topAtt = [[NSMutableAttributedString alloc]initWithString:topTitle attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:kCOLOR_R_G_B_A(102, 102, 102, 1)}];
    [topAtt addAttributes:@{NSForegroundColorAttributeName:kCOLOR_R_G_B_A(193, 38, 33, 1)} range:[topTitle rangeOfString:numberPeriods]];
    _topTitleLabel.attributedText = topAtt ;
    
    NSString *title = [NSString stringWithFormat:@"请确认当前第%@期",numberPeriods];
    NSMutableAttributedString * att = [[NSMutableAttributedString alloc]initWithString:title attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13],NSForegroundColorAttributeName:[UIColor blackColor]}];
    [att addAttributes:@{NSForegroundColorAttributeName:kMainColor} range:[title rangeOfString:numberPeriods]];
    _titleLabel.attributedText = att;

    int line = 4;
    if (self.specailType == 2) {
        line = 2;
    }
    
    CGFloat gap = 3;
    CGFloat originX = 0;
    CGFloat originY = 0;
    CGFloat height = 40.0f;
    
    CGFloat width = (_scrollView.width - (2+line)*gap)/line;
    if (self.specailType == 1) {
        width = _scrollView.width - 2*gap;
    }else if(self.specailType == 2){
        width = (_scrollView.width - 3*gap)/2.0f;
    }
    NSInteger row = lotterys.count/line;
    row = lotterys.count%line>0?row+1:row;
    
    CGFloat contentHeight = 0;
    for (int r = 0; r<row; r++) {
        originY = gap+(gap+height)*r;
        for (int l = 0; l<line; l++) {
            originX = gap+(gap+width)*l;
            NSInteger index = r*line + l;
            if (index>=lotterys.count) {
                break;
            }
            NSDictionary *info = [lotterys objectAtIndex:index];
            NSString *sectionName = [info DWStringForKey:@"sectionName"];
            NSString *haoString = [SUMUser shareUser].buyLotteryDetailHasNumberPan?@"号":@"";
            NSString *title = [NSString stringWithFormat:@"%@%@%@",sectionName,[info DWStringForKey:@"playName"],haoString];
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(originX, originY,width,height)];
            label.text = title;
            label.font = [UIFont systemFontOfSize:14.0f];
            label.textColor = [UIColor whiteColor];
            label.textAlignment = NSTextAlignmentCenter;
            label.backgroundColor = kCOLOR_R_G_B_A(185, 27, 10, 1);
            label.numberOfLines = 0;
            label.layer.cornerRadius = 5.0f;
            label.layer.masksToBounds = YES;
            [_scrollView addSubview:label];
            contentHeight = label.bottomY;
        }
    }
    
    CGFloat othersHeight = 255;
    CGFloat scrollHeight = (contentHeight+othersHeight>=self.height*0.7)?(self.height*0.7-othersHeight):contentHeight;
    
    _contentView.height = othersHeight+scrollHeight;
    [_contentView layoutSubviews];
    
    _contentView.centerY = (self.height-_contentView.height)/2.0f+_contentView.height/2.0f;
    _scrollView.contentSize = CGSizeMake(_scrollView.width,contentHeight);
    
    [self layoutBetCoinViewSubviews];
    [self showOnView:onView];
}

-(void)layoutBetCoinViewSubviews
{
    NSArray *tags = @[@"62",@"63",@"64",@"65",@"66",@"67"];
    CGFloat width = _betCoinView.width/tags.count;
    CGFloat orginx = 0;
    CGFloat gap = 3.0f;
    for (int i=0; i<tags.count; i++) {
        NSInteger tag = [tags[i] integerValue];
        UIView *subview = [_betCoinView viewWithTag:tag];
        subview.frame = CGRectMake(orginx, 0, width, subview.height);
        orginx = subview.rightX;
        UIButton *subbtn = [subview viewWithTag:tag-50];
        CGFloat btnWidth = subview.width-2*gap;
        subbtn.frame = CGRectMake(gap, (subview.width-btnWidth)/2.0f, btnWidth, btnWidth);
    }
}


- (IBAction)buttonActions:(UIButton *)sender {
    
    switch (sender.tag) {
        case 11:
        {
            //清空充值金额
            _betAmountTf.text = nil;
        }break;
        case 12:
        {
            //充值10
            NSInteger money = [_betAmountTf.text integerValue];
            money += 10;
            _betAmountTf.text = [NSString stringWithFormat:@"%ld",(long)money];
            
        }break;
        case 13:
        {
            //充值50
            NSInteger money = [_betAmountTf.text integerValue];
            money += 50;
            _betAmountTf.text = [NSString stringWithFormat:@"%ld",(long)money];
        }break;
        case 14:
        {
            //充值100
            NSInteger money = [_betAmountTf.text integerValue];
            money += 100;
            _betAmountTf.text = [NSString stringWithFormat:@"%ld",(long)money];
            
        }break;
        case 15:
        {
            //充值500
            NSInteger money = [_betAmountTf.text integerValue];
            money += 500;
            _betAmountTf.text = [NSString stringWithFormat:@"%ld",(long)money];
            
        }break;
        case 16:
        {
            //充值1000
            NSInteger money = [_betAmountTf.text integerValue];
            money += 1000;
            _betAmountTf.text = [NSString stringWithFormat:@"%ld",(long)money];
            
        }break;
        case 17:
        {
            //充值5000
            NSInteger money = [_betAmountTf.text integerValue];
            money += 5000;
            _betAmountTf.text = [NSString stringWithFormat:@"%ld",(long)money];
            
        }break;
        case 18:
        {
            self.isUseYuan = YES;
            
        }break;
        case 19:
        {
            self.isUseYuan = NO;
        }break;
        default:
            break;
    }
    
    [self countContentLabel];

}

#pragma mark- textfieldDelegate

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    /*
    if (string.length>0 && ![self validateNumber:string]) {
        return NO;
    }else if (textField.text.length == 0 && [string intValue]==0) {
        return NO;
    }
     */
    
    if (string.length>0) {
        
        if ((textField.text.length<1||[textField.text rangeOfString:@"."].length>0 )&& [string isEqualToString:@"."]) {
            
            return NO;
        }else if ([textField.text rangeOfString:@"."].length>0&&textField.text.length==[textField.text rangeOfString:@"."].location +3)
        {
            return NO;
        }else if ([textField.text isEqualToString:@"0"]&&![string isEqualToString:@"."])
        {
            return NO;
        }
        
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self verifyBetAmount];
        [self countContentLabel];
    });
    return YES;
}

-(void)verifyBetAmount
{
    NSRange rangePoin = [_betAmountTf.text rangeOfString:@"."];
    if (rangePoin.length>0) {
        if (_betAmountTf.text.length>(rangePoin.location+rangePoin.length+2)) {
            _betAmountTf.text = [_betAmountTf.text substringToIndex:rangePoin.location+rangePoin.length+2];
        }
    }
}

- (BOOL)validateNumber:(NSString*)number {
    BOOL res =YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    int i =0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i,1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length ==0) {
            res =NO;
            break;
        }
        i++;
    }
    return res;
}

#pragma mark-

-(void)countContentLabel
{
    
    NSInteger count = _lotterys.count;
    CGFloat allPay = 0;
    CGFloat award = 0;
    CGFloat win = 0;
    double betValue = [_betAmountTf.text doubleValue];
    if (!self.isUseYuan) {
        betValue = betValue/10.0f;
    }
    double bouns = 0;
    
    if (_isOfficail) {
        
        bouns = [[_officailBonuds jdM]doubleValue];
        count = _betCount;
        
    }else{
        
        for (NSDictionary *info in _lotterys) {
            double newBouns = [[[[CPBuyLotteryManager shareManager]fetchDoubleFacePlayBounsByPlayId:[info DWStringForKey:@"playId"]]jdM]doubleValue];
            if ([[info DWStringForKey:@"useBonus"]intValue]==1) {
                newBouns = [[[info DWStringForKey:@"bonus"]jdM]doubleValue];
            }
            bouns = bouns>=newBouns?bouns:newBouns;
        }
    }
    
    allPay = betValue *count ;
    award = betValue * bouns;
    win = award - betValue;
    
    NSString *countString = [NSString stringWithFormat:@"%ld",(long)count];
    NSString *allPayString = [NSString stringWithFormat:@"%.3f",allPay];
    NSString *awardString = [NSString stringWithFormat:@"%.3f",award];
    NSString *winString = [NSString stringWithFormat:@"%.3f",win];
    
    NSString *contentString = [NSString stringWithFormat:@"%@注共%@元，若中奖，单注最高奖金%@元，单注最高盈利%@元",countString,allPayString,awardString,winString];
    
    NSMutableAttributedString * attContent = [[NSMutableAttributedString alloc]initWithString:contentString attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[UIColor blackColor]}];
    [attContent addAttributes:@{NSForegroundColorAttributeName:kMainColor} range:[contentString rangeOfString:allPayString]];
    [attContent addAttributes:@{NSForegroundColorAttributeName:kMainColor} range:[contentString rangeOfString:awardString]];
    NSRange winDesRange = [contentString rangeOfString:@"盈利"];
    [attContent addAttributes:@{NSForegroundColorAttributeName:kMainColor} range:NSMakeRange(winDesRange.location+winDesRange.length, winString.length)];
    _contentLabel.attributedText = attContent;
    
    
}

-(void)showOnView:(UIView *)onView
{
    self.layer.opacity = 0;
    [onView addSubview:self];
    [UIView animateWithDuration:0.38 animations:^{
        self.layer.opacity = 1;
    }];
    
}

-(void)dismiss
{
    [UIView animateWithDuration:0.38 animations:^{
        self.layer.opacity = 0;
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}



@end
