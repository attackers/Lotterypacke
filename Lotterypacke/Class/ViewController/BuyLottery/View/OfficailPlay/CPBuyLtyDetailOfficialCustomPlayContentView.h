//
//  CPBuyLtyDetailOfficialCustomPlayContentView.h
//  lottery
//
//  Created by way on 2018/6/30.
//  Copyright © 2018年 way. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CPBuyLtyDetailOfficialCustomPlayContentView : UIView

@property(nonatomic,retain)NSString *contentText;

-(void)addIntroText:(NSString *)introText
        placeHolder:(NSString *)placeHolder
      attentionText:(NSString *)attentionText;

-(void)cleanContentText;

@end
