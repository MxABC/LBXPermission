//
//  LBXPermission.m
//  LBXKits
//
//  Created by lbx on 2017/9/7.
//  Copyright © 2017年 lbx. All rights reserved.
//

#import "LBXPermission.h"
#import <UIKit/UIKit.h>

#import "LBXPermissionCamera.h"
#import "LBXPermissionPhotos.h"
#import "LBXPermissionContacts.h"
#import "LBXPermissionLocation.h"
#import "LBXPermissionHealth.h"
#import "LBXPermissionCalendar.h"
#import "LBXPermissionReminders.h"
#import "LBXPermissionMicrophone.h"

@implementation LBXPermission


+ (BOOL)isServicesEnabledWithType:(LBXPermissionType)type
{
    if (type == LBXPermissionType_Location) {
        return [LBXPermissionLocation isServicesEnabled];
    }
    
    return YES;
}

+ (BOOL)isDeviceSupportedWithType:(LBXPermissionType)type
{
    if (type == LBXPermissionType_Health) {
        
        return  [LBXPermissionHealth isHealthDataAvailable];
    }
    
    return YES;
}

+ (BOOL)authorizedWithType:(LBXPermissionType)type
{
    switch (type) {
        case LBXPermissionType_Location:
            return [LBXPermissionLocation authorized];
            break;
        case LBXPermissionType_Camera:
            return [LBXPermissionCamera authorized];
            break;
        case LBXPermissionType_Photos:
            return [LBXPermissionPhotos authorized];
            break;
        case LBXPermissionType_Contacts:
            return [LBXPermissionContacts authorized];
            break;
        case LBXPermissionType_Reminders:
            return [LBXPermissionReminders authorized];
            break;
        case LBXPermissionType_Calendar:
            return [LBXPermissionCalendar authorized];
            break;
        case LBXPermissionType_Microphone:
            return [LBXPermissionMicrophone authorized];
            break;
        case LBXPermissionType_Health:
            return [LBXPermissionHealth authorized];
            break;
        default:
            break;
    }
    return NO;
}

+ (void)authorizeWithType:(LBXPermissionType)type completion:(void(^)(BOOL granted,BOOL firstTime))completion
{
    switch (type) {
        case LBXPermissionType_Location:
            return [LBXPermissionLocation authorizeWithCompletion:completion];
            break;
        case LBXPermissionType_Camera:
            return [LBXPermissionCamera authorizeWithCompletion:completion];
            break;
        case LBXPermissionType_Photos:
            return [LBXPermissionPhotos authorizeWithCompletion:completion];
            break;
        case LBXPermissionType_Contacts:
            return [LBXPermissionContacts authorizeWithCompletion:completion];
            break;
        case LBXPermissionType_Reminders:
            return [LBXPermissionReminders authorizeWithCompletion:completion];
            break;
        case LBXPermissionType_Calendar:
            return [LBXPermissionCalendar authorizeWithCompletion:completion];
            break;
        case LBXPermissionType_Microphone:
            return [LBXPermissionMicrophone authorizeWithCompletion:completion];
            break;
        case LBXPermissionType_Health:
            return [LBXPermissionHealth authorizeWithCompletion:completion];
            break;
        default:
            break;
    }
}

#pragma mark-  disPlayAppPrivacySetting

+ (void)displayAppPrivacySettings
{
    if (UIApplicationOpenSettingsURLString != NULL)
    {
        NSURL *appSettings = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        
        if (@available(iOS 10,*)) {
            [[UIApplication sharedApplication]openURL:appSettings options:@{} completionHandler:^(BOOL success) {
            }];
        }
        else
        {
            [[UIApplication sharedApplication]openURL:appSettings];
        }
    }
}

+ (void)showAlertToDislayPrivacySettingWithTitle:(NSString*)title msg:(NSString*)message cancel:(NSString*)cancel setting:(NSString *)setting
{
    if (@available(iOS 8,*)) {
        
        UIAlertController* alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        
        //cancel
        UIAlertAction *action = [UIAlertAction actionWithTitle:cancel style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        }];
        [alertController addAction:action];
        
        //ok
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:setting style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            [self displayAppPrivacySettings];
        }];
        [alertController addAction:okAction];
        
        [[self currentTopViewController] presentViewController:alertController animated:YES completion:nil];
    }
}

+ (UIViewController*)currentTopViewController
{
    UIViewController *currentViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
    while ([currentViewController presentedViewController])    currentViewController = [currentViewController presentedViewController];
    
    if ([currentViewController isKindOfClass:[UITabBarController class]]
        && ((UITabBarController*)currentViewController).selectedViewController != nil )
    {
        currentViewController = ((UITabBarController*)currentViewController).selectedViewController;
    }
    
    while ([currentViewController isKindOfClass:[UINavigationController class]]
           && [(UINavigationController*)currentViewController topViewController])
    {
        currentViewController = [(UINavigationController*)currentViewController topViewController];
    }
    
    return currentViewController;
}


@end
