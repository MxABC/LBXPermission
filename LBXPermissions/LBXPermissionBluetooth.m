//
//  LBXPermissionBluetooth.m
//  Demo
//
//  Created by lbxia on 2021/3/15.
//  Copyright © 2021 lbx. All rights reserved.
//

#import "LBXPermissionBluetooth.h"
#import <CoreBluetooth/CoreBluetooth.h>



@interface LBXPermissionBluetooth()<CBPeripheralManagerDelegate>
@property (nonatomic, strong) CBPeripheralManager *bluetoothManager;
@property (nonatomic, strong) CBManager *cbManage API_AVAILABLE(ios(10.0));
@property (nonatomic, copy) void (^onComletion)(BOOL granted,BOOL firstTime);
@property (nonatomic, copy) void (^onCompletionState)(BOOL granted,NSInteger state,BOOL firstTime);

//持续监控
@property (nonatomic, strong) CBPeripheralManager *bluetoothMonitor;
@property (nonatomic, copy) void (^onState)(BOOL granted,NSInteger state);
@end

@implementation LBXPermissionBluetooth

+ (instancetype)sharedManager
{
    static LBXPermissionBluetooth* _sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[LBXPermissionBluetooth alloc] init];
        
    });
    
    return _sharedInstance;
}

- (void)startBluetootch:(BOOL)showPowerAlertKey
{
    self.bluetoothManager = [[CBPeripheralManager alloc]initWithDelegate:self queue:nil options:@{CBCentralManagerOptionShowPowerAlertKey:@(showPowerAlertKey)}];
}

+ (BOOL)authorized
{
    if (@available(iOS 13.1, *)) {
        BOOL ret = CBManager.authorization == CBManagerAuthorizationAllowedAlways;
        return  ret;
    }
    else
    {
        CBPeripheralManagerAuthorizationStatus status = [CBPeripheralManager authorizationStatus];
        return status == CBPeripheralManagerAuthorizationStatusAuthorized;
    }
}


/*
 0:未确定
 1:限制
 2:拒绝
 3:允许
*/
+ (NSInteger)authorizationStatus
{
    if (@available(iOS 13.1, *)) {
        
        return CBManager.authorization;
    }
    else
    {
        CBPeripheralManagerAuthorizationStatus status = [CBPeripheralManager authorizationStatus];
        return status;
    }
}



/// 权限请求
/// @param completion
/// granted:app是否有权限
/// state: 1: 控制中心开启  2:控制中心关闭
///


/// 权限
/// @param show 系统未开启或控制中心未开启，自动弹框提示
/// @param completion
/// granted:app是否有权限
/// granted为 YES时  state: 1: 控制中心/系统 开启  2:控制中心/系统 关闭
+ (void)authorizeWithShowPowerAlertKey:(BOOL)show completionState:(void(^)(BOOL granted,NSInteger state,BOOL firstTime))completion
{
    [LBXPermissionBluetooth sharedManager].onComletion = nil;
    
    [self authorized];
    
    [LBXPermissionBluetooth sharedManager].onCompletionState = completion;
    [[LBXPermissionBluetooth sharedManager]startBluetootch:show];

}


+ (void)authorizeMonitorWithState:(void(^)(BOOL granted,NSInteger state))onState
{
    if (onState) {
    
        [LBXPermissionBluetooth sharedManager].onState = onState;
        
        [LBXPermissionBluetooth sharedManager].bluetoothMonitor =  [[CBPeripheralManager alloc]initWithDelegate:[LBXPermissionBluetooth sharedManager] queue:nil options:@{CBCentralManagerOptionShowPowerAlertKey:@(false)}];
        
    }else{
        
        if( [LBXPermissionBluetooth sharedManager].bluetoothMonitor )
        {
            [LBXPermissionBluetooth sharedManager].bluetoothMonitor = nil;
        }
    }
}


+ (void)authorizeWithCompletion:(void(^)(BOOL granted,BOOL firstTime))completion
{
    [LBXPermissionBluetooth sharedManager].onCompletionState = nil;
    
    if ([self authorized])
    {
        completion(YES,NO);
        return;
    }
    
    [LBXPermissionBluetooth sharedManager].onComletion = completion;
    
    [[LBXPermissionBluetooth sharedManager]startBluetootch:NO];
}

- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral
{
    //            typedef NS_ENUM(NSInteger, CBManagerState) {
    //                CBManagerStateUnknown = 0,
    //                CBManagerStateResetting,
    //                CBManagerStateUnsupported,
    //                CBManagerStateUnauthorized,
    //                CBManagerStatePoweredOff,//当前app有权限，但是控制中心关闭了
    //                CBManagerStatePoweredOn,
    //            } NS_ENUM_AVAILABLE(10_13, 10_0);
//    NSLog(@"%d", peripheral.state);
      

    BOOL granted;
    BOOL firstTime;
    if (@available(iOS 13.1, *)) {
     
//        NSLog(@"%ld",(long)CBManager.authorization);
        
        granted = CBManager.authorization == CBManagerAuthorizationAllowedAlways;
        firstTime = CBManagerAuthorizationNotDetermined == CBManager.authorization;
    }
    else
    {
        CBPeripheralManagerAuthorizationStatus status = [CBPeripheralManager authorizationStatus];

        granted = status == CBPeripheralManagerAuthorizationStatusAuthorized;
        firstTime = status == CBPeripheralManagerAuthorizationStatusNotDetermined;
    }
    
    
    NSInteger state = 0;
    
    //            typedef NS_ENUM(NSInteger, CBManagerState) {
    //                CBManagerStateUnknown = 0,
    //                CBManagerStateResetting,
    //                CBManagerStateUnsupported,
    //                CBManagerStateUnauthorized,
    //                CBManagerStatePoweredOff,//当前app有权限，但是控制中心关闭了
    //                CBManagerStatePoweredOn,
    //            } NS_ENUM_AVAILABLE(10_13, 10_0);
//    NSLog(@"%ld", (long)peripheral.state);
    if (@available(iOS 10.0, *)) {
        
        switch (peripheral.state) {
            case CBManagerStateUnknown:
            case CBManagerStateResetting:
            case CBManagerStateUnsupported:
            case CBManagerStateUnauthorized:
            case CBManagerStatePoweredOff:
                state = 2;
                break;
            case CBManagerStatePoweredOn:
                state = 1;
                break;
                
            default:
                break;
        }
    }
    
    
    if(_bluetoothMonitor == peripheral)
    {
        //监听状态
        if(_onState){
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                self.onState(granted, state);
            });
        }
        return;
    }
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if(self.onComletion){
            self.onComletion(granted, firstTime);
        }
        else if(self.onCompletionState){
            self.onCompletionState(granted, state,firstTime);
        }
    });
        
       self.bluetoothManager = nil;
}

@end
