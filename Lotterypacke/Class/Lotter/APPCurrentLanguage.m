//
//  APPCurrentLanguage.m
//  APPDateCatgory
//
//  Created by OS X10_12_6 on 2018/8/10.
//  Copyright © 2018年 OS X10_12_6. All rights reserved.
//

#import "APPCurrentLanguage.h"

@implementation APPCurrentLanguage
+ (BOOL)getPreferredLanguage {
    NSArray *languages = [NSUserDefaults.standardUserDefaults objectForKey:@"AppleLanguages"];
    NSString *preferredLand = [languages firstObject];
    if ([preferredLand containsString:@"zh"]) {
        return YES;
    } else {
        return  NO;
    }
    
}
@end
