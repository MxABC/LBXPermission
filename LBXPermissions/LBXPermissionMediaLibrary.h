//
//  LBXPermissionMediaLibrary.h
//  ZShowPlay
//
//  Created by 张雄 on 2019/1/2.
//  Copyright © 2019 张雄. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LBXPermissionMediaLibrary : NSObject

+ (BOOL)authorized;

/**
 MediaLibrary permission status
 
 @reture
 0: NotDetermined = 0,
 1: Denied,
 2: Restricted,
 3: Authorized,
 */
+ (NSInteger)authorizationStatus;

+ (void)authorizeWithCompletion:(void(^)(BOOL granted, BOOL firstTime))complection;

@end


