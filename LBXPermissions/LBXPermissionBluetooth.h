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


/// 权限获取，系统是否开启未知
/// @param completion completion description
+ (void)authorizeWithCompletion:(void(^)(BOOL granted,BOOL firstTime))completion;


/// 权限
/// @param show 系统未开启或控制中心未开启，自动弹框提示
/// @param completion
/// granted:app是否有权限
/// state: 1: 控制中心/系统 开启  2:控制中心/系统 关闭  3:设备不支持  0:其他
+ (void)authorizeWithShowPowerAlertKey:(BOOL)show completionState:(void(^)(BOOL granted,NSInteger state,BOOL firstTime))completion;




/// 实时监听权限状态变化，不触发权限请求
/// @param onState onState 传nil表示结束监听
/// granted: app是否有权限
/// state: 1: 控制中心/系统 开启  2:控制中心/系统 关闭 3:设备不支持  0:其他
+ (void)authorizeMonitorWithState:(void(^)(BOOL granted,NSInteger state))onState;

@end


