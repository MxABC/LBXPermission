//
//  LBXPermissionCamera.m
//  LBXKits
//
//  Created by lbxia on 2017/9/10.
//  Copyright © 2017年 lbx. All rights reserved.
//

#import "LBXPermissionTracking.h"
#import <AdSupport/AdSupport.h>

@implementation LBXPermissionTracking

+ (BOOL)authorized
{
    if (@available(iOS 14.0, *)) {
        
        ATTrackingManagerAuthorizationStatus status = [ATTrackingManager trackingAuthorizationStatus];

        return status == ATTrackingManagerAuthorizationStatusAuthorized;
    }
    else{
        
        if ([[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled]) {
            return YES;
        }
    }
    return NO;
}


+ (ATTrackingManagerAuthorizationStatus)authorizationStatus
{
    return [ATTrackingManager trackingAuthorizationStatus];
}

+ (void)authorizeWithCompletion:(void(^)(BOOL granted,BOOL firstTime))completion
{
    
    if (@available(iOS 14.0, *)) {
        
        ATTrackingManagerAuthorizationStatus status = [ATTrackingManager trackingAuthorizationStatus];
        
        switch (status) {
            case ATTrackingManagerAuthorizationStatusNotDetermined:
            {
                // 未提示用户
                [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (status == ATTrackingManagerAuthorizationStatusAuthorized) {
                            completion(YES,YES);
//                            NSString *idfa = [[ASIdentifierManager sharedManager].advertisingIdentifier UUIDString];
                        }
                        else {
                            completion(NO,YES);
    
                        }
                    });
                }];
            }
                break;
            case ATTrackingManagerAuthorizationStatusRestricted:
            case ATTrackingManagerAuthorizationStatusDenied:
            {
                completion(NO,NO);
            }
                break;
            case ATTrackingManagerAuthorizationStatusAuthorized:
            {
                completion(YES,NO);
            }
                
            default:
                break;
        }        
    }
    else {
        //iOS 14以下请求idfa权限
        // 判断在设置-隐私里用户是否打开了广告跟踪
        if ([[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled]) {
           
            completion(YES,NO);
            
//            NSString *idfa = [[ASIdentifierManager sharedManager].advertisingIdentifier UUIDString];
//            NSLog(@"%@",idfa);
            
        } else {
//            NSLog(@"请在设置-隐私-广告中打开广告跟踪功能");
            completion(NO,NO);
        }
    }
}


@end
