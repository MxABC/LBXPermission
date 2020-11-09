//
//  LBXPermissionPhotos.h
//  LBXKits
//
//  Created by lbxia on 2017/9/10.
//  Copyright © 2017年 lbx. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface LBXPermissionPhotos : NSObject

+ (BOOL)authorized;


/// 写入权限
+ (BOOL)authorizedWritePermission;

///读写权限
+ (BOOL)authorizedReadWritePermission;


/**
 photo permission status
 
 @return
 0 :NotDetermined
 1 :Restricted
 2 :Denied
 3 :Authorized
 */
+ (NSInteger)authorizationStatus;


/**
 photo only write permission status

 @return
 0 :NotDetermined
 1 :Restricted
 2 :Denied
 3 :Authorized
 4 :limited
 */
+ (NSInteger)authorizationStatus_OnlyWrite;




/// 获取读，写权限
/// @param completion 返回结果
+ (void)authorizeWithCompletion:(void(^)(BOOL granted,BOOL firstTime))completion;


/// 仅仅获取写权限,iOS14+有效,<iOS14,获取的还是写和读权限
/// @param completion 返回结果
+ (void)authorizeOnlyWriteWithCompletion:(void(^)(BOOL granted,BOOL firstTime))completion;

@end
