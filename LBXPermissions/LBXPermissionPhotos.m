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
    return [self authorizationStatus] == 3;
}


/**
 photo permission status

 @return
 0 :NotDetermined
 1 :Restricted
 2 :Denied
 3 :Authorized
 */
+ (NSInteger)authorizationStatus
{
//    PHAuthorizationStatusLimited 状态下也会返回 PHAuthorizationStatusAuthorized
    
    if (@available(iOS 14.0, *)) {
        
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_14_0

        return  [PHPhotoLibrary authorizationStatusForAccessLevel:PHAccessLevelReadWrite];
#endif
    }
    
    PHAuthorizationStatus status =  [PHPhotoLibrary authorizationStatus];
    
    return status;
    
}

+ (NSInteger)authorizationStatus_AddOnly
{
    if (@available(iOS 14.0, *)) {
        
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_14_0

        return  [PHPhotoLibrary authorizationStatusForAccessLevel:PHAccessLevelAddOnly];
#endif
        
    }
        
    return [self authorizationStatus];

}

+ (void)authorizeWithCompletion:(void(^)(BOOL granted,BOOL firstTime))completion
{
    if (@available(iOS 8.0, *)) {
        
        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
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
//              iOS14 PHAuthorizationStatusLimited 状态下也会返回 PHAuthorizationStatusAuthorized
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
