//
//  CPBuyLtyOfficialPlayOptionsSelectedView.m
//  lottery
//
//  Created by way on 2018/6/26.
//  Copyright © 2018年 way. All rights reserved.
//

#import "CPBuyLtyOfficialPlayOptionsSelectedView.h"

@interface CPBuyLtyOfficialPlayOptionsSelectedView()
{
    IBOutlet UILabel *_titleLabel;
    IBOutlet UIScrollView *_contentScrollView;
    IBOutlet UIView *_mainContentView;
}

@property(nonatomic,assign)id<CPBuyLtyOfficialPlayOptionsSelectedViewDelegate>delegate;
@property(nonatomic,assign)NSInteger menuIndex;

@end

@implementation CPBuyLtyOfficialPlayOptionsSelectedView

- (IBAction)closeAction:(UIButton *)sender
{
    [self dismiss];
}

+(void)showOnView:(UIView *)onView
        menuIndex:(NSInteger)menuIndex
        withTitle:(NSString *)title
         dataList:(NSArray *)dataList
   selectedItemId:(NSString *)selectedItemId
         delegate:(id<CPBuyLtyOfficialPlayOptionsSelectedViewDelegate>)delegate
{
    CPBuyLtyOfficialPlayOptionsSelectedView *view = [CPBuyLtyOfficialPlayOptionsSelectedView createViewFromNib];
    view.delegate = delegate;
    view.menuIndex = menuIndex;
    [view showOnView:onView withTitle:title dataList:dataList selectedItemId:selectedItemId];
}

-(void)showOnView:(UIView *)onView
        withTitle:(NSString *)title
         dataList:(NSArray *)dataList
   selectedItemId:(NSString *)selectedItemId
{
    _titleLabel.text = title;
    self.frame = CGRectMake(0, 0, onView.width, onView.height);
    [self layoutSubviews];
    CGFloat originY = 0;
    
    //先算标题的最大长度
    NSString *maxTitle = @"";
    for (int i = 0; i<dataList.count; i++) {
        NSDictionary *dataInfo = dataList[i];

       NSString *menuTitle = [dataInfo DWStringForKey:@"name"];
        if (menuTitle.length>maxTitle.length) {
            maxTitle = menuTitle;
        }
    }
    CGFloat maxMenuTitleWidth = [maxTitle suitableFromMaxSize:CGSizeMake(MAXFLOAT, MAXFLOAT) font:[UIFont systemFontOfSize:16.0f]].width+10;
    maxMenuTitleWidth = maxMenuTitleWidth>=100?100:maxMenuTitleWidth;

    for (int i = 0; i<dataList.count; i++) {
        
        NSDictionary *dataInfo = dataList[i];
        CPBuyLtyOfficialPlayOptionsItemView *item = [CPBuyLtyOfficialPlayOptionsItemView loadWithFrame:CGRectMake(0, originY, _contentScrollView.width, 0) titleWidth:maxMenuTitleWidth dataInfo:dataInfo selectedItemId:selectedItemId isFirstItem:i==0?YES:NO isFinalItem:i==dataList.count-1?YES:NO index:i clickAction:^(NSIndexPath *clickIndexPath) {
            
            [self.delegate cpBuyLtyOfficialPlayOptionsSelectedViewSelectedIndexPath:clickIndexPath menuInex:self.menuIndex];
            [self dismiss];
        }];
        [_contentScrollView addSubview:item];
        originY = item.bottomY;
    }
    
    _contentScrollView.contentSize = CGSizeMake(_contentScrollView.width, originY);
    CGFloat contentHeight = originY + 95;
    contentHeight = contentHeight>=self.height*0.7?self.height*0.7:contentHeight;
    _mainContentView.height = contentHeight;
    _mainContentView.originY = (self.height-_mainContentView.height)/2.0f;
    _mainContentView.layer.cornerRadius = 5.0f;
    _mainContentView.layer.borderWidth = 1.0f;
    _mainContentView.layer.borderColor = kCOLOR_R_G_B_A(153, 153, 153, 1).CGColor;
//    _mainContentView.layer.masksToBounds = YES;
    [self showAnimationOnView:onView];
}

-(void)showAnimationOnView:(UIView *)onView
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
