//
//  APPLocationManager.m
//  MFSC
//
//  Created by 小小恒心 on 2018/6/1.
//  Copyright © 2018年 LRG. All rights reserved.
//

#import "APPLocationManager.h"
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <Toast/UIView+Toast.h>
@interface APPLocationManager ()<AMapLocationManagerDelegate,AMapSearchDelegate>

@property (nonatomic, strong) AMapLocationManager *Manager;
@property (nonatomic, strong) AMapSearchAPI *searchAPI;
@property (nonatomic, copy) void(^loactionBlock)(NSDictionary *dict);
@end

static APPLocationManager *locationManager = nil;

@implementation APPLocationManager

+ (instancetype)shareInstance{
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        locationManager = [[APPLocationManager alloc] init];
        
    });
    return locationManager;
}


-(AMapLocationManager *)Manager{
    GetMethodReturnObjc(_Manager);
    _Manager = [[AMapLocationManager alloc] init];
    [_Manager setDelegate:self];
    
    //设置不允许系统暂停定位
    [_Manager setPausesLocationUpdatesAutomatically:NO];
    //设置允许在后台定位
//    [_Manager setAllowsBackgroundLocationUpdates:YES];
    
    //    //设置允许连续定位逆地理 这些随便你想用就用
    //    [_Manager setLocatingWithReGeocode:YES];
    return _Manager;
}

-(AMapSearchAPI *)searchAPI{
    GetMethodReturnObjc(_searchAPI);
    _searchAPI = [[AMapSearchAPI alloc] init];
    _searchAPI.delegate = self;
    return _searchAPI;
}

- (void)startLocation{
    if ([CLLocationManager locationServicesEnabled] && ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways)) {
        
        //定位功能可用
        [self.Manager startUpdatingLocation];
        
    }else if ([CLLocationManager authorizationStatus] ==kCLAuthorizationStatusDenied) {
        
        //定位不能用
        [UIApplication.sharedApplication.keyWindow makeToast:@"定位功能关闭" duration:1.5 position:@"center"];
        
    }
    
}

- (void)restartLocationWithBlock:(void(^)(NSDictionary *dict))locationBlock{
    [self startLocation];
    [self setLoactionBlock:^(NSDictionary *dict) {
        locationBlock(dict);
    }];
}

#pragma mark  ------ AMapLocationManagerDelegate -------

- (void)amapLocationManager:(AMapLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"%s, amapLocationManager = %@, error = %@", __func__, [manager class], error);
}

- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode
{
    AMapReGeocodeSearchRequest *geoRequest = [[AMapReGeocodeSearchRequest alloc] init];
    geoRequest.location = [AMapGeoPoint locationWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude];
    geoRequest.radius = 1000;
    [self.searchAPI AMapReGoecodeSearch:geoRequest];
    
}

#pragma mark ---------  AMapSearchDelegate  ------------
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response{

    NSString *city = response.regeocode.addressComponent.city;
    CLLocationCoordinate2D bmlocation = [self BD09FromGCJ02:CLLocationCoordinate2DMake(request.location.latitude, request.location.longitude)];
    NSNumber *latitude = [NSNumber numberWithFloat:bmlocation.latitude];
    NSNumber *longitude = [NSNumber numberWithFloat:bmlocation.longitude];
    NSDictionary *dict = @{@"city":city, @"latitude":latitude, @"longitude":longitude, @"country":response.regeocode.addressComponent.country};
    if (city) {
        if (self.loactionBlock) self.loactionBlock(dict);
        [self.Manager stopUpdatingLocation];
    }
    
    if ([self.delegate respondsToSelector:@selector(locationInfo:)]) {
        [self.delegate locationInfo:dict];
    }
}

- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error{
    NSLog(@"%@",error);
}

#pragma mark ---坐标转换
//高德转百度
-(CLLocationCoordinate2D)BD09FromGCJ02:(CLLocationCoordinate2D)coor
{
    CLLocationDegrees x_pi = 3.14159265358979324 * 3000.0 / 180.0;
    CLLocationDegrees x = coor.longitude, y = coor.latitude;
    CLLocationDegrees z = sqrt(x * x + y * y) + 0.00002 * sin(y * x_pi);
    CLLocationDegrees theta = atan2(y, x) + 0.000003 * cos(x * x_pi);
    CLLocationDegrees bd_lon = z * cos(theta) + 0.0065;
    CLLocationDegrees bd_lat = z * sin(theta) + 0.006;
    return CLLocationCoordinate2DMake(bd_lat, bd_lon);
}


@end
