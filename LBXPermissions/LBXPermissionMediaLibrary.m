//
//  LBXPermissionMediaLibrary.m
//  ZShowPlay
//
//  Created by 张雄 on 2019/1/2.
//  Copyright © 2019 张雄. All rights reserved.
//

#import "LBXPermissionMediaLibrary.h"
#import <MediaPlayer/MediaPlayer.h>

@implementation LBXPermissionMediaLibrary

+ (BOOL)authorized {
    
    return [self authorizationStatus] == 3;
}

/**
 0: MPMediaLibraryAuthorizationStatusNotDetermined = 0,
 1: MPMediaLibraryAuthorizationStatusDenied,
 2: MPMediaLibraryAuthorizationStatusRestricted,
 3: MPMediaLibraryAuthorizationStatusAuthorized,
 */
+ (NSInteger)authorizationStatus {
    
    // if (@available(iOS 9.3, *))
    if (@available(iOS 9.3, *)) {
        
        return [MPMediaLibrary authorizationStatus];
        
    } else {
        
        return 3;
    }
    
}

+ (void)authorizeWithCompletion:(void(^)(BOOL granted, BOOL firstTime))complection {
    
    // @available(iOS 9.3, *)
    if (@available(iOS 9.3, *)) {
        
        MPMediaLibraryAuthorizationStatus status = [MPMediaLibrary authorizationStatus];
        
        switch (status) {
            case MPMediaLibraryAuthorizationStatusAuthorized:
            {
                if (complection) {
                    complection(YES, NO);
                }
                
            }
                break;
            case MPMediaLibraryAuthorizationStatusRestricted:
            case MPMediaLibraryAuthorizationStatusDenied:
            {
                if (complection) {
                    complection(NO, NO);
                }
            }
                break;
            case MPMediaLibraryAuthorizationStatusNotDetermined:
            {
                [MPMediaLibrary requestAuthorization:^(MPMediaLibraryAuthorizationStatus status) {
                    if (complection) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            complection(status == MPMediaLibraryAuthorizationStatusAuthorized, YES);
                        });
                    }
                    
                }];
            }
                break;
            default:
            {
                if (complection) {
                    complection(NO, NO);
                }
                
            }
                break;
        }

    } else {
        complection(YES, NO);
    }

}



@end
