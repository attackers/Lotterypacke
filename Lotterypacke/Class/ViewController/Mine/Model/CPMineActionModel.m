//
//  CPMineActionModel.m
//  lottery
//
//  Created by wayne on 2017/8/2.
//  Copyright © 2017年 way. All rights reserved.
//

#import "CPMineActionModel.h"

@implementation CPMineActionModel

+(instancetype)modelName:(NSString *)name
                    icon:(NSString *)icon
                identify:(int)identify
{
    CPMineActionModel *model = [CPMineActionModel new];
    model.name = name;
    model.icon = icon;
    model.identify = identify;
    return model;
}

@end
