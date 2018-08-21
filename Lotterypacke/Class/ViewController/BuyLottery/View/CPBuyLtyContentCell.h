//
//  CPBuyLtyContentCell.h
//  lottery
//
//  Created by way on 2018/8/5.
//  Copyright © 2018年 way. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPBuyLtyCellContentItem.h"
#import "CPBuyLtyBetContentProtocol.h"

@interface CPBuyLtyContentCell : UITableViewCell

+(CGFloat)cellHeightByShape:(CPBuyLtyCellContentItemShape)shape
                 layoutType:(CPBuyLtyCellContentItemLayoutType)layoutType
               isIncludeGap:(BOOL)includeGap;

-(void)addPlayInfoList:(NSArray *)playInfoList
          selectedList:(NSArray *)selectedList
                 shape:(CPBuyLtyCellContentItemShape)shape
            layoutType:(CPBuyLtyCellContentItemLayoutType)layoutType
              delegate:(id<CPBuyLtyBetContentProtocol>)delegate
           atIndexPath:(NSIndexPath *)indexPath
    maxNumberOfSection:(NSInteger)maxNumberOfSection;


@end
