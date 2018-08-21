//
//  CPAgentStatementCell.h
//  lottery
//
//  Created by way on 2018/5/27.
//  Copyright © 2018年 way. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CPAgentStatementCell : UICollectionViewCell


-(void)addImage:(UIImage *)img
        content:(NSString *)content
            des:(NSString *)des
isShowBottomLine:(BOOL)showBottomLine
isShowRightLine:(BOOL)showRightLine;

@end
