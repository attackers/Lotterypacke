//
//  CPRechargeNormalCell.h
//  lottery
//
//  Created by wayne on 2017/9/10.
//  Copyright © 2017年 way. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CPRechargeNormalCell : UITableViewCell


-(void)addBankName:(NSString *)bankName
        detailInfo:(NSString *)detailInfo
  logoImgUrlString:(NSString *)logoImgUrlString
          selected:(BOOL)selected;

@end
