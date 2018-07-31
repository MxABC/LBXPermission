//
//  LBXPermissionNet.h
//  
//
//  Created by lbxia on 2018/7/31.
//  Copyright © 2018年 lbx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetReachability.h"

@interface LBXPermissionNet : NSObject

+ (instancetype)sharedManager;


/**
 开始监听网络状态，没有网络时自动检查网络权限
 
 @param hostName 域名或ip地址，国内可以使用www.baidu.com，系统API判断是否能连接上改地址，来返回网络状态
 @param onNetStatus 网络状态回调
 @param onNetPermission 网络权限回调，可能没有网络权限如果granted为NO
 */
- (void)startListenNetWithHostName:(NSString*)hostName
                       onNetStatus:(void(^)(NetReachWorkStatus netStatus))onNetStatus
                   onNetPermission:(void(^)(BOOL granted))onNetPermission;



@end
