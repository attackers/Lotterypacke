//
//  CPBuyLtyDetailOfficialCustomPlayContentView.m
//  lottery
//
//  Created by way on 2018/6/30.
//  Copyright © 2018年 way. All rights reserved.
//

#import "CPBuyLtyDetailOfficialCustomPlayContentView.h"
#import <IQTextView.h>
@interface CPBuyLtyDetailOfficialCustomPlayContentView()
{
    
    IBOutlet UILabel *_introLabel;
    IBOutlet UILabel *_attentionDesLabel;
    IBOutlet UILabel *_attentionContentLabel;
    
    IBOutlet UIView *_tvBgView;
    IBOutlet IQTextView *_tvView;
        
}
@end

@implementation CPBuyLtyDetailOfficialCustomPlayContentView

-(void)awakeFromNib
{
    [super awakeFromNib];
    _tvBgView.layer.borderWidth = kGlobalLineWidth;
    _tvBgView.layer.borderColor = kCOLOR_R_G_B_A(227, 227, 227, 1).CGColor;

}

-(void)addIntroText:(NSString *)introText
        placeHolder:(NSString *)placeHolder
      attentionText:(NSString *)attentionText
{
 
    _tvView.text = @"";
    _tvView.placeholderTextColor = kCOLOR_R_G_B_A(153, 153, 153, 1);
    
    _introLabel.text = introText;
    _tvView.placeholder = placeHolder;
    _attentionContentLabel.text = attentionText;
    
    CGFloat gap = _introLabel.originX;
    CGFloat introHeight = [introText suitableFromMaxSize:CGSizeMake(self.width-2*gap, self.height/2.0f) font:_introLabel.font].height;
    _introLabel.size = CGSizeMake(self.width-2*gap, introHeight+2);
    
    CGFloat attentionHeight = [attentionText suitableFromMaxSize:CGSizeMake(self.width-2*gap, self.height/2.0f) font:_attentionContentLabel.font].height;
    _attentionContentLabel.size = CGSizeMake(self.width-2*gap, attentionHeight+2);
    _attentionContentLabel.originY = self.height - _attentionContentLabel.size.height - gap;
    
    _attentionDesLabel.originY = _attentionContentLabel.originY - _attentionDesLabel.height - gap;
    
    _tvBgView.originY = _introLabel.bottomY + gap;
    _tvBgView.height = _attentionDesLabel.originY - 2*gap - _tvBgView.originY;
    
}

-(NSString *)contentText
{
    return _tvView.text;
}

-(void)cleanContentText;
{
    _tvView.text = @"";
}

@end
