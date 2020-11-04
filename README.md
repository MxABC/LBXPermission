### LBXPermission
***
iOS常用权限获取

![1112.gif](https://upload-images.jianshu.io/upload_images/4952852-d03da06805c9bcf7.gif?imageMogr2/auto-orient/strip)

调用接口简单，易用,如下面相机和定位权限判断及获取

```
//相机权限获取，已经有权限了，仍然可通过该接口返回状态
    [LBXPermission authorizeWithType:LBXPermissionType_Camera completion:^(BOOL granted, BOOL firstTime) {
     
        if (granted) {
            //TODO
            //dosth
        }
        else if (!firstTime)
        {
            //不是第一次请求权限，那么可以弹出权限提示，用户选择设置，即跳转到设置界面，设置权限
             [LBXPermissionSetting showAlertToDislayPrivacySettingWithTitle:@"提示" msg:@"没有相机权限，是否前往设置" cancel:@"取消" setting:@"设置"];
        }
    }];
    
    
    //定位
    [LBXPermission authorizeWithType:LBXPermissionType_Location completion:^(BOOL granted, BOOL firstTime) {
        
        if (granted) {
            //TODO
            //dosth
        }
        else if (!firstTime)
        {
            //不是第一次请求权限，那么可以弹出权限提示，用户选择设置，即跳转到设置界面，设置权限
            [LBXPermissionSetting showAlertToDislayPrivacySettingWithTitle:@"提示" msg:@"没有定位权限，是否前往设置" cancel:@"取消" setting:@"设置"];
        }
    }];
```

### install by cocoapods
没有使用到的权限，不要安装，否则Appstore审核不通过

```
   pod 'LBXPermission/Base'
   pod 'LBXPermission/Camera'
   pod 'LBXPermission/Photo'
   pod 'LBXPermission/Contact'
   pod 'LBXPermission/Location'
   pod 'LBXPermission/Location'
   pod 'LBXPermission/Reminder'
   pod 'LBXPermission/Calendar'
   pod 'LBXPermission/Microphone'
   pod 'LBXPermission/Health'
   pod 'LBXPermission/Net'
   pod 'LBXPermission/Tracking'
```

### install manually
drag folder "LBXPermissions" to your project


