//
//  LBXPermissionCamera.h
//  LBXKits
//
//  Created by lbxia on 2017/9/10.
//  Copyright © 2017年 lbx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AppTrackingTransparency/AppTrackingTransparency.h> 


#ifndef __IPHONE_14_0
    #define __IPHONE_14_0    140000
#endif

@interface LBXPermissionTracking : NSObject

+ (BOOL)authorized;

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_14_0
+ (ATTrackingManagerAuthorizationStatus)authorizationStatus API_AVAILABLE(ios(14.0));
#endif

+ (void)authorizeWithCompletion:(void(^)(BOOL granted ,BOOL firstTime ))completion;

@end
