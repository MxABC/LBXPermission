//
//  LBXPermissionBluetooth.h
//  
//
//  Created by lbxia on 2021/3/15.
//  Copyright © 2021 lbx. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface LBXPermissionBluetooth : NSObject


+ (BOOL)authorized;
/*
 0:未确定
 1:限制
 2:拒绝
 3:允许
*/
+ (NSInteger)authorizationStatus;

+ (void)authorizeWithCompletion:(void(^)(BOOL granted,BOOL firstTime))completion;


/// 权限
/// @param show 系统未开启或控制中心未开启，自动弹框提示
/// @param completion
/// granted:app是否有权限
/// granted为 YES时  state: 1: 控制中心/系统 开启  2:控制中心/系统 关闭
+ (void)authorizeWithShowPowerAlertKey:(BOOL)show completionState:(void(^)(BOOL granted,NSInteger state,BOOL firstTime))completion;




/// 实时监听权限状态变化，参数值看上面
/// @param onState onState description
/// granted: app是否有权限
/// granted为 YES时  state: 1: 控制中心/系统 开启  2:控制中心/系统 关闭
+ (void)authorizeMonitorWithState:(void(^)(BOOL granted,NSInteger state))onState;

@end


