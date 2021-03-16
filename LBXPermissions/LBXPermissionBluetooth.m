//
//  LBXPermissionBluetooth.m
//  Demo
//
//  Created by lbxia on 2021/3/15.
//  Copyright © 2021 lbx. All rights reserved.
//

#import "LBXPermissionBluetooth.h"
#import <CoreBluetooth/CoreBluetooth.h>



//@interface LBXPermissionBluetooth()<CBPeripheralManagerDelegate,CBCentralManagerDelegate>
@interface LBXPermissionBluetooth()<CBPeripheralManagerDelegate>
@property (nonatomic, strong) CBPeripheralManager *bluetoothManager;
//@property (nonatomic, strong) CBCentralManager *bluetoothCenter;
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
    
    
//    self.bluetoothCenter = [[CBCentralManager alloc] initWithDelegate:self queue:dispatch_get_main_queue() options:@{CBCentralManagerOptionShowPowerAlertKey: @(NO)}];
////
////
//    [self.bluetoothCenter scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:@"1819"],[CBUUID UUIDWithString:@"1820"]] options:nil];

}

+ (BOOL)authorized
{
    if (@available(iOS 13.0, *)) {
        
        if (@available(iOS 13.1, *)) {
            return CBManager.authorization == CBManagerAuthorizationAllowedAlways;
        }else{
            return [[CBPeripheralManager alloc]init].authorization == CBManagerAuthorizationAllowedAlways;
        }
    }
    else
    {
        return YES;
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
    if (@available(iOS 13.0, *)) {
        
        if (@available(iOS 13.1, *)) {
            return CBManager.authorization;
        }else{
            return [[CBPeripheralManager alloc]init].authorization;
        }
    }
    else
    {
        return 3;
        //        CBPeripheralManagerAuthorizationStatus status = [CBPeripheralManager authorizationStatus];
        //        return status;
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
/// state: 1: 控制中心/系统 开启  2:控制中心/系统 关闭  3:设备不支持  0:其他
+ (void)authorizeWithShowPowerAlertKey:(BOOL)show completionState:(void(^)(BOOL granted,NSInteger state,BOOL firstTime))completion
{
    [LBXPermissionBluetooth sharedManager].onComletion = nil;
    
    /*
     0:未确定
     1:限制
     2:拒绝
     3:允许
    */
    switch ([self authorizationStatus]) {
        case 2:
        {
            completion(NO,0,NO);
            return;
        }
            break;
        default:
            break;
    }
    [LBXPermissionBluetooth sharedManager].onCompletionState = completion;
    [[LBXPermissionBluetooth sharedManager]startBluetootch:show];
}

+ (void)authorizeMonitorWithState:(void(^)(BOOL granted,NSInteger state))onState
{
    if (onState)
    {
        [LBXPermissionBluetooth sharedManager].onState = onState;
        
        [LBXPermissionBluetooth sharedManager].bluetoothMonitor =  [[CBPeripheralManager alloc]initWithDelegate:[LBXPermissionBluetooth sharedManager] queue:nil options:@{CBCentralManagerOptionShowPowerAlertKey:@(false)}];
    }
    else if( [LBXPermissionBluetooth sharedManager].bluetoothMonitor )
    {
        [LBXPermissionBluetooth sharedManager].bluetoothMonitor = nil;
    }
}

+ (void)authorizeWithCompletion:(void(^)(BOOL granted,BOOL firstTime))completion
{

    [LBXPermissionBluetooth sharedManager].onCompletionState = nil;
    /*
     0:未确定
     1:限制
     2:拒绝
     3:允许
    */
    switch ([self authorizationStatus]) {
        case 1:
        case 2:
        {
            completion(NO,NO);
            return;
        }
            break;
        case 3:
        {
            completion(YES,NO);
            return;
        }
            break;
        default:
            break;
    }
    
    [LBXPermissionBluetooth sharedManager].onComletion = completion;
    [[LBXPermissionBluetooth sharedManager]startBluetootch:NO];
}

- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral
{
    NSInteger state = 0;
    BOOL granted;
    BOOL firstTime = YES;
    
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
        
        NSLog(@"peripheral.state = %ld", (long)peripheral.state);

        switch (peripheral.state) {
            case CBManagerStateUnsupported:
            {
                granted = NO;
                state = 3;
            }
                break;
            case CBManagerStateUnknown:
            case CBManagerStateUnauthorized:{
                granted = NO;
            }
                break;
            case CBManagerStateResetting:
            case CBManagerStatePoweredOff:{
                state = 2;
                granted = YES;
            }
                break;
            case CBManagerStatePoweredOn:{
                granted = YES;
                state = 1;
            }
                break;
            default:
                break;
        }
    }
    else
    {
        granted = YES;
        state = 1;
    }
      
    /*
    if (@available(iOS 13.1, *)) {
     
//        NSLog(@"%ld",(long)CBManager.authorization);
        
        granted = CBManager.authorization == CBManagerAuthorizationAllowedAlways;
        firstTime = CBManagerAuthorizationNotDetermined == CBManager.authorization;
        
    }
    else
    {
        //低版本状态不正确，通过CBPeripheralManager.state判断即可
        
        CBPeripheralManagerAuthorizationStatus status = [CBPeripheralManager authorizationStatus];

        granted = status == CBPeripheralManagerAuthorizationStatusAuthorized;
        firstTime = status == CBPeripheralManagerAuthorizationStatusNotDetermined;
    }
    */
  
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
    
//    if (_bluetoothCenter) {
//        [_bluetoothCenter stopScan];
//        self.bluetoothCenter = nil;
//    }
}

//- (void)centralManagerDidUpdateState:(CBCentralManager *)central
//{
////    [central stopScan];
//    
//    NSLog(@"centralManagerDidUpdateState");    
//}

@end
