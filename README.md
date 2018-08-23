### LBXPermission
***
iOS常用权限获取

![image](https://gitee.com/lbxia/imageSource/raw/master/Permission.gif)



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

```
   pod 'LBXPermission', '~> 1.0.3'
```

### install manually
drag folder "LBXPermissions" to your project


### 备注
demo界面待修改
