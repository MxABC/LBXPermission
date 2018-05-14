//
//  LBXPermissionNetwork.m
//  LBXKits
//
//  Created by lbx on 2017/12/7.
//  Copyright © 2017年 lbx. All rights reserved.
//

#import "LBXPermissionData.h"
@import CoreTelephony;

@interface LBXPermissionData()

@property (nonatomic, strong) id cellularData;
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
        
        CTCellularData *cellularData = [[CTCellularData alloc] init];
        
        cellularData.cellularDataRestrictionDidUpdateNotifier = ^(CTCellularDataRestrictedState state)
        {
//            NSLog(@"state:%ld",state);
            dispatch_async(dispatch_get_main_queue(), ^{
                if (state == kCTCellularDataNotRestricted) {
                    //没有限制
                    completion(YES,NO);
                }
                else if (state == kCTCellularDataRestrictedStateUnknown)
                {
                    //没有请求网络或正在等待用户确认权限
//                    completion(NO,NO);
                }
                else{
                    //
                    completion(NO,NO);
                }
            });
        };
        
        //不存储，对象cellularData会销毁
        [LBXPermissionData sharedManager].cellularData = cellularData;
    }
    else
    {
        completion(YES,NO);
    }

}

@end
