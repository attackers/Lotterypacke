//
//  CPOpenAccountCell.h
//  lottery
//
//  Created by way on 2018/6/11.
//  Copyright © 2018年 way. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CPOpenAccountCellValueProtocol<NSObject>

-(void)cpOpenAccountCellAddValue:(NSString *)value
                        isDdting:(BOOL)edting
                           index:(NSInteger)index
                       textField:(UITextField *)textField;

@end

@interface CPOpenAccountCell : UITableViewCell

-(UITextField *)addInfo:(NSDictionary *)info
               perValue:(NSString *)perValue
               delegate:(id<CPOpenAccountCellValueProtocol>)delegate
                  index:(NSInteger)index;

@end
