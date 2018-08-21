//
//  NSString+WayExtension.m
//  lottery
//
//  Created by way on 2017/11/20.
//  Copyright © 2017年 way. All rights reserved.
//

#import "NSString+WayExtension.h"

@implementation NSString (WayExtension)

-(NSString *)wayStringByAppendingPathComponent:(NSString *)str
{
    NSMutableString *mString = [[NSMutableString alloc]initWithString:[self stringByAppendingPathComponent:str]];
    if ([mString rangeOfString:@"http:/"].length>0 &&[mString rangeOfString:@"http://"].length==0) {
        [mString stringByReplacingCharactersInRange:[mString rangeOfString:@"http:/"] withString:@"http://"];
    }else if ([mString rangeOfString:@"https:/"].length>0 &&[mString rangeOfString:@"https://"].length==0) {
        [mString stringByReplacingCharactersInRange:[mString rangeOfString:@"https:/"] withString:@"https://"];
    }
    
    return mString;
}

- (BOOL)isPureInt{
    NSScanner* scan = [NSScanner scannerWithString:self];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

/**
 精度处理
 */
-(NSString *)jdM
{
    NSString *doubleString = [NSString stringWithFormat:@"%lf", [self doubleValue]];
    NSDecimalNumber *decNumber    = [NSDecimalNumber decimalNumberWithString:doubleString];
    return [decNumber stringValue];
}

@end
