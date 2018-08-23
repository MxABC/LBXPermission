//
//  LBXPermissionNetwork.m
//  LBXKits
//
//  Created by lbx on 2017/12/7.
//  Copyright © 2017年 lbx. All rights reserved.
//

#import "LBXPermissionData.h"
#import <CoreTelephony/CTCellularData.h>

@interface LBXPermissionData()

@property (nonatomic, strong) id cellularData;
@property (nonatomic, copy) void (^completion)(BOOL granted,BOOL firstTime);
@end

@implementation LBXPermissionData

+ (instancetype)sharedManager
{
    static LBXPermissionData* _sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[LBXPermissionData alloc] init];
        
    });
    
    return _sharedInstance;
}


+ (void)authorizeWithCompletion:(void(^)(BOOL granted,BOOL firstTime))completion
{
    if (@available(iOS 10,*)) {
        
        [LBXPermissionData sharedManager].completion = completion;
        
        if (![LBXPermissionData sharedManager].cellularData) {
            
            CTCellularData *cellularData = [[CTCellularData alloc] init];
            
            cellularData.cellularDataRestrictionDidUpdateNotifier = ^(CTCellularDataRestrictedState state)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (state == kCTCellularDataNotRestricted) {
                        //没有限制
                        [LBXPermissionData sharedManager].completion(YES,NO);
                        NSLog(@"有网络权限");
                    }
                    else if (state == kCTCellularDataRestrictedStateUnknown)
                    {
                        //                    completion(NO,NO);
                        NSLog(@"没有请求网络或正在等待用户确认权限?");
                    }
                    else{
                        //
                        [LBXPermissionData sharedManager].completion(NO,NO);
                        NSLog(@"无网络权限");
                    }
                });
            };
            
            //不存储，对象cellularData会销毁
            [LBXPermissionData sharedManager].cellularData = cellularData;
        }
    }
    else
    {
        completion(YES,NO);
    }

}

@end
