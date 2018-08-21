//
//  APPLocationManager.h
//  MFSC
//
//  Created by 小小恒心 on 2018/6/1.
//  Copyright © 2018年 LRG. All rights reserved.
//

#import <Foundation/Foundation.h>
#define GetMethodReturnObjc(objc) if (objc) return objc
@protocol APPLocationManagerDelegate <NSObject>
- (void)locationInfo:(NSDictionary*)info;
@end

@interface APPLocationManager : NSObject
@property (nonatomic, weak) id<APPLocationManagerDelegate>delegate;
+ (instancetype)shareInstance;

- (void)startLocation;

- (void)restartLocationWithBlock:(void(^)(NSDictionary *dict))locationBlock;

@end

