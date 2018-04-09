//
//  LBXPermissionNetwork.h
//  LBXKits
//
//  Created by lbx on 2017/12/7.
//  Copyright © 2017年 lbx. All rights reserved.
//

#import <Foundation/Foundation.h>

///data networks permission
@interface LBXPermissionData : NSObject

/**
 suggest call this method delay a few seconds after app launch
 remark: just call back data networks permission
 @param completion 回调
 */
+ (void)authorizeWithCompletion:(void(^)(BOOL granted,BOOL firstTime))completion;

@end
