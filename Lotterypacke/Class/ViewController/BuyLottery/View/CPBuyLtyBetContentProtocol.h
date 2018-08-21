//
//  CPBuyLtyBetContentProtocol.h
//  lottery
//
//  Created by way on 2018/4/2.
//  Copyright © 2018年 way. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    
    CPBuyLtyBetContentItemForSingleText        = 0,
    CPBuyLtyBetContentItemForSingleImage       = 1,
    CPBuyLtyBetContentItemForImagesAndText     = 2,
    CPBuyLtyBetContentItemForImageAndText      = 3,

} CPBuyLtyBetContentItemType;

@protocol CPBuyLtyBetContentProtocol <NSObject>

-(void)cpBuyLtyBetContentSelectedIndexPath:(NSIndexPath *)indexPath
                              offsetNumber:(NSInteger)number;


@end
