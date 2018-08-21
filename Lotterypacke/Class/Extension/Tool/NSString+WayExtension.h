//
//  NSString+WayExtension.h
//  lottery
//
//  Created by way on 2017/11/20.
//  Copyright © 2017年 way. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (WayExtension)

-(NSString *)wayStringByAppendingPathComponent:(NSString *)str;
-(BOOL)isPureInt;


/**
 精度处理
 */
-(NSString *)jdM;


@end
