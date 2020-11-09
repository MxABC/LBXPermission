//
//  LBXPermissionPhotos.m
//  LBXKits
//
//  Created by lbxia on 2017/9/10.
//  Copyright © 2017年 lbx. All rights reserved.
//

#import "LBXPermissionPhotos.h"
#import <Photos/Photos.h>

#ifndef __IPHONE_14_0
    #define __IPHONE_14_0    140000
#endif


@implementation LBXPermissionPhotos

+ (BOOL)authorized
{
    return  [self authorizedReadWritePermission];
}


/**
 photo permission status

 @return
 0 :NotDetermined
 1 :Restricted
 2 :Denied
 3 :Authorized
 4 :limited
 */
+ (NSInteger)authorizationStatus
{
   
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_14_0
    if (@available(iOS 14.0, *)) {
        return  [PHPhotoLibrary authorizationStatusForAccessLevel:PHAccessLevelReadWrite];
    }
#endif
    
    //    PHAuthorizationStatusLimited 状态下也会返回 PHAuthorizationStatusAuthorized
    PHAuthorizationStatus status =  [PHPhotoLibrary authorizationStatus];
    
    return status;
}


/**
 photo permission status

 @return
 0 :NotDetermined
 1 :Restricted
 2 :Denied
 3 :Authorized
 4 :limited
 */
+ (NSInteger)authorizationStatus_OnlyWrite
{
    if (@available(iOS 14.0, *)) {
        
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_14_0

        return  [PHPhotoLibrary authorizationStatusForAccessLevel:PHAccessLevelAddOnly];
#endif
        
    }
        
    return [self authorizationStatus];

}

/// 写入权限
+ (BOOL)authorizedWritePermission
{
    if (@available(iOS 14.0, *)) {
        
        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatusForAccessLevel:PHAccessLevelAddOnly];
        return status == PHAuthorizationStatusAuthorized || status == PHAuthorizationStatusLimited;
    }
    else
    {
        PHAuthorizationStatus status =  [PHPhotoLibrary authorizationStatus];
        return status == PHAuthorizationStatusAuthorized;
    }
}

///读写权限
+ (BOOL)authorizedReadWritePermission
{
    if (@available(iOS 14.0, *)) {
        
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_14_0
        
        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatusForAccessLevel:PHAccessLevelReadWrite];
        return status == PHAuthorizationStatusAuthorized || status == PHAuthorizationStatusLimited;
#endif
        
    }
    
    PHAuthorizationStatus status =  [PHPhotoLibrary authorizationStatus];
    return status == PHAuthorizationStatusAuthorized;
    
}



+ (void)authorizeWithCompletion:(void(^)(BOOL granted,BOOL firstTime))completion
{
    if (@available(iOS 8.0, *)) {
        
        PHAuthorizationStatus status = [self authorizationStatus];
        switch (status) {
            case PHAuthorizationStatusAuthorized:
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_14_0
            case PHAuthorizationStatusLimited:
#endif
            {
                if (completion) {
                    completion(YES,NO);
                }
            }
                break;
            case PHAuthorizationStatusRestricted:
            case PHAuthorizationStatusDenied:
            {
                if (completion) {
                    completion(NO,NO);
                }
            }
                break;
            case PHAuthorizationStatusNotDetermined:
            {
                
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_14_0
                
                if (@available(iOS 14.0, *)) {
                    
                    [PHPhotoLibrary requestAuthorizationForAccessLevel:PHAccessLevelReadWrite handler:^(PHAuthorizationStatus status) {
                        
                        if (completion) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                completion(status == PHAuthorizationStatusAuthorized || status == PHAuthorizationStatusLimited ,YES);
                            });
                        }
                        
                    }];
                    break;
                }
#endif
                
                //iOS14 PHAuthorizationStatusLimited 状态下也会返回 PHAuthorizationStatusAuthorized
                [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                    if (completion) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            completion(status == PHAuthorizationStatusAuthorized,YES);
                        });
                    }
                }];
                
            }
                break;
                
            default:
            {
                
                
                if (completion) {
                    completion(NO,NO);
                }
            }
                break;
        }
        
    }
}


/// 仅仅获取写权限,iOS14+有效
/// @param completion 返回
+ (void)authorizeOnlyWriteWithCompletion:(void(^)(BOOL granted,BOOL firstTime))completion
{
    if (@available(iOS 8.0, *)) {
        
        PHAuthorizationStatus status = [self authorizationStatus_OnlyWrite];

        switch (status) {
            case PHAuthorizationStatusAuthorized:
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_14_0
            case PHAuthorizationStatusLimited:
#endif
            {
                if (completion) {
                    completion(YES,NO);
                }
            }
                break;
            case PHAuthorizationStatusRestricted:
            case PHAuthorizationStatusDenied:
            {
                if (completion) {
                    completion(NO,NO);
                }
            }
                break;
            case PHAuthorizationStatusNotDetermined:
            {
                
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_14_0
                if (@available(iOS 14.0, *)) {
                    
                    [PHPhotoLibrary requestAuthorizationForAccessLevel:PHAccessLevelAddOnly handler:^(PHAuthorizationStatus status) {
                        
                        if (completion) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                completion(status == PHAuthorizationStatusAuthorized || status == PHAuthorizationStatusLimited ,YES);
                            });
                        }
                    }];
                    break;
                }
#endif
                //iOS14 PHAuthorizationStatusLimited 状态下也会返回 PHAuthorizationStatusAuthorized
                [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                    if (completion) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            completion(status == PHAuthorizationStatusAuthorized,YES);
                        });
                    }
                }];
            }
                break;
                
            default:
            {
                if (completion) {
                    completion(NO,NO);
                }
            }
                break;
        }
        
    }
}

@end
