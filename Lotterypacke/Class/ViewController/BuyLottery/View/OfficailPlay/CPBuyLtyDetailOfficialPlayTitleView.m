//
//  CPBuyLtyDetailOfficialPlayTitleView.m
//  lottery
//
//  Created by way on 2018/6/29.
//  Copyright © 2018年 way. All rights reserved.
//

#import "CPBuyLtyDetailOfficialPlayTitleView.h"
#import "DWITButton.h"

@interface CPBuyLtyDetailOfficialPlayTitleView()
{
    IBOutlet DWITButton *_titleButton;
    IBOutlet UIButton *_actionButton;
    
}
@end

@implementation CPBuyLtyDetailOfficialPlayTitleView

-(void)addTitle:(NSString *)title
     isOfficail:(BOOL)isOfficail
{
    NSString *playMethod = isOfficail?@"官方玩法":@"双面玩法";
    NSString *fullTitle = [NSString stringWithFormat:@"%@-%@",title,playMethod];
    
    NSMutableAttributedString *attTitle = [[NSMutableAttributedString alloc] initWithString:fullTitle attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:17],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    [attTitle addAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:15]} range:[fullTitle rangeOfString:playMethod]];
    [_titleButton setAttributedTitle:attTitle forState:UIControlStateNormal];
    
}

-(void)addActionTarget:(id)target
                action:(SEL)action
{
    [_actionButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

@end
