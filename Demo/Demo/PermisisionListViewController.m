//
//  PermisisionListViewController.m
//  Demo
//
//  Created by 夏利兵 on 2020/10/10.
//  Copyright © 2020 lbx. All rights reserved.
//

#import "PermisisionListViewController.h"
#import "PermissionTableViewCell.h"
#import "LBXPermission.h"
#import "LBXPermissionPhotos.h"
#import "LBXPermissionCamera.h"
#import "LBXPermissionLocation.h"
#import "LBXPermissionMicrophone.h"
#import "LBXPermissionNet.h"
#import "LBXPermissionTracking.h"
#import "LBXPermissionMediaLibrary.h"
#import "LBXPermissionContacts.h"
#import "LBXPermissionReminders.h"
#import "LBXPermissionCalendar.h"
#import "LBXPermissionHealth.h"
#import "LBXPermissionNotification.h"
#import "LBXPermissionSetting.h"
#import "LBXPermissionBluetooth.h"


@interface PermisisionListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *listView;

@property (nonatomic, strong) NSArray *listContent;

@property (nonatomic, copy) NSString *strNetStatus;
@property (nonatomic, assign) BOOL netAuthorized;

//bluetooth system open
@property (nonatomic, assign) BOOL bluetoothSysOpen;

@end

@implementation PermisisionListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"权限获取测试";
    
//    bool ret = [LBXPermissionNotification authorized];
//
//    [LBXPermissionNotification authorizeWithCompletion:^(BOOL granted, BOOL firstTime) {
//
//    }];

    // Do any additional setup after loading the view from its nib.
    _listView.delegate = self;
    _listView.dataSource = self;
    
    self.netAuthorized = NO;
    
        
    self.bluetoothSysOpen = YES;
    //当前蓝牙权限及系统蓝牙开启状态监听
    [LBXPermissionBluetooth authorizeMonitorWithState:^(BOOL granted, NSInteger state) {

        NSLog(@"monitor:%d,%ld",granted,(long)state);
        //            state: 1: 控制中心/系统 开启  2:控制中心/系统 关闭
        self.bluetoothSysOpen = (state == 1);
        NSLog(@"bluetoothSysOpen:%d",self.bluetoothSysOpen);
        [self.listView reloadData];
    }];
    
    
    self.listContent = @[
        @{@"name":@"相册",@"type":@(LBXPermissionType_Photos),@"img":@"photo"},
        @{@"name":@"相机",@"type":@(LBXPermissionType_Camera),@"img":@"camera"},
        @{@"name":@"位置",@"type":@(LBXPermissionType_Location),@"img":@"location"},
        @{@"name":@"麦克风",@"type":@(LBXPermissionType_Microphone),@"img":@"microphone"},
        @{@"name":@"网络",@"type":@(LBXPermissionType_DataNetwork),@"img":@"net"},
        @{@"name":@"推送",@"type":@(LBXPermissionType_Notification),@"img":@"push"},
        @{@"name":@"广告跟踪",@"type":@(LBXPermissionType_Tracking),@"img":@"advertising"},
        @{@"name":@"媒体库",@"type":@(LBXPermissionType_MediaLibrary),@"img":@"media"},
        @{@"name":@"联系人",@"type":@(LBXPermissionType_Contacts),@"img":@"contact"},
        @{@"name":@"提醒事项",@"type":@(LBXPermissionType_Reminders),@"img":@"reminder"},
        @{@"name":@"日历",@"type":@(LBXPermissionType_Calendar),@"img":@"calendar"},
        @{@"name":@"健康",@"type":@(LBXPermissionType_Health),@"img":@"health"},
        @{@"name":@"蓝牙",@"type":@(LBXPermissionType_Bluetooth),@"img":@"bluetooth"}
    ];

    
    [_listView registerNib:[UINib nibWithNibName:@"PermissionTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    [_listView reloadData];
    
    
    //监听网络权限
    [self netPermissionlisten];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self.listView selector:@selector(reloadData) name:UIApplicationDidBecomeActiveNotification object:nil];

    
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
//    [LBXPermissionBluetooth authorizeWithShowPowerAlertKey:NO completionState:^(BOOL granted, NSInteger state, BOOL firstTime) {
//
//        NSLog(@"blue:%d,%ld,%d",granted,(long)state,firstTime);
//    }];
//
//    [LBXPermissionBluetooth authorizeMonitorWithState:^(BOOL granted, NSInteger state) {
//
//        NSLog(@"monitor:%d,%ld",granted,(long)state);
//
//    }];
     
     
//     complex:^(BOOL granted,NSInteger state, BOOL firstTime) {
//
//        NSLog(@"blue:%d,%d",granted,firstTime);
//    }];
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //#warning Incomplete implementation, return the number of rows
    return self.listContent.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PermissionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.enableLabel.layer.borderColor = [UIColor blueColor].CGColor;
    cell.enableLabel.layer.borderWidth = 1;

    NSDictionary *content = self.listContent[indexPath.row];
    
    
    NSNumber *numType = content[@"type"];
    
    cell.topLable.text = content[@"name"];
    cell.leftImageView.image = [UIImage imageNamed:content[@"img"]];
    cell.rightImageView.hidden = YES;
    cell.enableLabel.hidden = YES;

    
    //可统一接口获取权限状态
//    BOOL authorized = [LBXPermission authorizedWithType:numType.integerValue];
//    BOOL enabled = [LBXPermission isServicesEnabledWithType:LBXPermissionType_Location];
    
    
    LBXPermissionType type = numType.integerValue;
    NSString *strPermission = @"";
    BOOL permissionEnabled = NO;
    switch (type) {
        case LBXPermissionType_Photos:
        {
            
            switch ([LBXPermissionPhotos authorizationStatus]) {
                case 0:
                    strPermission = @"权限未确定";
                    break;
                case 1:
                    strPermission = @"权限受到限制";
                    break;
                case 2:
                    strPermission = @"没有权限";
                    break;
                case 3:
                    strPermission = @"读写权限都已经获取";
                    permissionEnabled = YES;
                    break;
                case 4:
                    strPermission = @"读写权限已经获取:部分图片获取权限";
                    permissionEnabled = YES;
                    break;
                default:
                    break;
            }
            if (!permissionEnabled) {
                
                switch ([LBXPermissionPhotos authorizationStatus_OnlyWrite]) {
                    case 0:
                        strPermission = @"权限未确定";
                        break;
                    case 1:
                        strPermission = @"权限受到限制";
                        break;
                    case 2:
                        strPermission = @"没有权限";
                        break;
                    case 3:
                        strPermission = @"写入权限已经获取";
                        permissionEnabled = YES;
                        break;
                    case 4:
                        strPermission = @"权限已经获取:写入权限";
                        permissionEnabled = YES;
                        break;
                    default:
                        break;
                }
            }
        }
            break;
        case LBXPermissionType_Camera:
        {
            switch ([LBXPermissionCamera authorizationStatus]) {
                case AVAuthorizationStatusNotDetermined:
                    strPermission = @"权限未确定";
                    break;
                case AVAuthorizationStatusRestricted:
                    strPermission = @"权限受到限制";
                    break;
                case AVAuthorizationStatusDenied:
                    strPermission = @"没有权限";

                    break;
                case AVAuthorizationStatusAuthorized:
                    strPermission = @"权限已经获取";
                    permissionEnabled = YES;
                    break;
                default:
                    break;
            }
            
        }
            break;
        case LBXPermissionType_Location:
        {
            if ([LBXPermissionLocation isServicesEnabled]) {
                
                switch ([LBXPermissionLocation authorizationStatus]) {
                    case kCLAuthorizationStatusNotDetermined:
                        strPermission = @"权限未确定";
                        break;
                    case kCLAuthorizationStatusRestricted:
                        strPermission = @"权限受到限制";
                        break;
                    case kCLAuthorizationStatusDenied:
                        strPermission = @"没有权限";
                        break;
                    case kCLAuthorizationStatusAuthorizedAlways:
                        strPermission = @"拥有一直使用位置权限";
                        permissionEnabled = YES;

                        break;
                    case kCLAuthorizationStatusAuthorizedWhenInUse:
                        strPermission = @"拥有使用时获取位置权限";
                        permissionEnabled = YES;

                        break;
                        
                    default:
                        break;
                }
            }
            else
            {
                strPermission = @"系统定位未开启,请在 设置->定位服务 开启";
            }
            
           
        }
            break;
        case LBXPermissionType_Microphone:
        {
            switch ([LBXPermissionMicrophone authorizationStatus]) {
                case 0:
                    strPermission = @"权限未确定";
                    break;
                case 1:
                    strPermission = @"没有权限";
                    break;
              
                case 2:
                    strPermission = @"权限已经获取";
                    permissionEnabled = YES;
                    break;
               
                default:
                    break;
            }
        }
            break;
        case LBXPermissionType_DataNetwork:
        {
            strPermission = _strNetStatus;
            permissionEnabled = _netAuthorized;
        }
            break;
        case LBXPermissionType_Tracking:
        {
            
            if (@available(iOS 14.0, *)) {
                
#ifndef __IPHONE_14_0
#define __IPHONE_14_0    140000
#endif
                
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_14_0
                
                
                switch ([LBXPermissionTracking authorizationStatus]) {
                    case ATTrackingManagerAuthorizationStatusNotDetermined:
                        strPermission = @"权限未确定";
                        break;
                    case ATTrackingManagerAuthorizationStatusRestricted:
                        strPermission = @"权限受到限制";
                        break;
                    case ATTrackingManagerAuthorizationStatusDenied:
                        strPermission = @"没有权限,检查系统 设置->隐私->跟踪";
                        break;
                    case ATTrackingManagerAuthorizationStatusAuthorized:
                        strPermission = @"权限已经获取";
                        permissionEnabled = YES;
                        break;
                }
#endif
                
            }else{
                
                if ([LBXPermissionTracking authorized]) {
                    
                    strPermission = @"权限已经获取";
                    permissionEnabled = YES;
                }
                else{
                    
                    strPermission = @"没有权限，请检查系统设置(当前系统低于iOS14)";
                }
            }
           
        }
            break;
        case LBXPermissionType_MediaLibrary:
        {
            switch ([LBXPermissionMediaLibrary authorizationStatus]) {
                case 0:
                    strPermission = @"权限未确定";
                    break;
                case 1:
                    strPermission = @"权限受到限制";
                    break;
                case 2:
                    strPermission = @"没有权限";
                    break;
                case 3:
                    strPermission = @"权限已经获取";
                    permissionEnabled = YES;
                    break;
            }
        }
            break;
        case LBXPermissionType_Contacts:
        {
            
            switch ([LBXPermissionContacts authorizationStatus]) {
                case 0:
                    strPermission = @"权限未确定";
                    break;
                case 1:
                    strPermission = @"权限受到限制";
                    break;
                case 2:
                    strPermission = @"没有权限";
                    break;
                case 3:
                    strPermission = @"权限已经获取";
                    permissionEnabled = YES;
                    break;
            }
        }
            break;
        case LBXPermissionType_Reminders:
        {
            switch ([LBXPermissionReminders authorizationStatus]) {
                case 0:
                    strPermission = @"权限未确定";
                    break;
                case 1:
                    strPermission = @"权限受到限制";
                    break;
                case 2:
                    strPermission = @"没有权限";
                    break;
                case 3:
                    strPermission = @"权限已经获取";
                    permissionEnabled = YES;
                    break;
            }
        }
            break;
        case LBXPermissionType_Calendar:
        {
            switch ([LBXPermissionCalendar authorizationStatus]) {
                case 0:
                    strPermission = @"权限未确定";
                    break;
                case 1:
                    strPermission = @"权限受到限制";
                    break;
                case 2:
                    strPermission = @"没有权限";
                    break;
                case 3:
                    strPermission = @"权限已经获取";
                    permissionEnabled = YES;
                    break;
            }
        }
            break;
        case LBXPermissionType_Health:
        {
            if ([LBXPermissionHealth isHealthDataAvailable]) {
                
                switch ([LBXPermissionHealth authorizationStatus]) {
                    case 0:
                        strPermission = @"权限未确定";
                        break;
                    case 1:
                        strPermission = @"没有权限";
                        break;
                    case 2:
                        strPermission = @"权限已经获取";
                        permissionEnabled = YES;
                        break;
                    case 3:
                        strPermission = @"系统不支持";
                        break;
                }
            }
            else
            {
                strPermission = @"设备不支持";
            }
            strPermission = [NSString stringWithFormat:@"%@-注意:健康权限需要证书增加配置",strPermission];
        }
            break;
        case LBXPermissionType_Notification:
        {
            /**
             access authorizationStatus
             0: NotDetermined
             1: denied
             2: authorized
             3: 不影响用户操作的通知
             4: clips：临时允许
             */
            switch ( [LBXPermissionNotification authorizationStatus] ) {
                case 0:
                    strPermission = @"权限未确定";
                    break;
                case 1:
                    strPermission = @"没有权限";
                    break;
                case 2:
                    strPermission = @"权限已经获取";
                    permissionEnabled = YES;
                    break;
                case 3:
                    strPermission = @"权限已经获取:不影响用户操作的通知权限";
                    permissionEnabled = YES;
                    break;
                case 4:
                    strPermission = @"clips权限临时权限已获取";
                    permissionEnabled = YES;

                    break;
                default:
                    break;
            }
        }
            break;
        case LBXPermissionType_Bluetooth:
        {
            /*
             0:未确定
             1:限制
             2:拒绝
             3:允许
            */
            switch ([LBXPermissionBluetooth authorizationStatus]) {
                case 0:
                {
                    strPermission = @"权限未确定";

                }
                    break;
                case 1:
                {
                    strPermission = @"权限限制";

                }
                    break;
                case 2:
                {
                    strPermission = @"权限拒绝";

                }
                    break;
                case 3:
                {
                    strPermission = @"权限已获取";
                    permissionEnabled = YES;

                }
                    break;
                default:
                    break;
            }
            
            strPermission = [NSString stringWithFormat:@"%@,%@",strPermission,self.bluetoothSysOpen ? @"系统开启":@"系统未开启"];
        }
            break;
        default:
            break;
    }
    
    cell.bottomLabel.text = strPermission;
    
    if (permissionEnabled) {
        cell.rightImageView.hidden = NO;
    }
    else
        cell.enableLabel.hidden = NO;

    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *content = self.listContent[indexPath.row];
    NSNumber *numType = content[@"type"];
    
    LBXPermissionType type = numType.integerValue;
    
    if (type == LBXPermissionType_Location) {
        
        if (![LBXPermissionLocation isServicesEnabled]) {
            
            [LBXPermissionSetting showAlertWithTitle:@"提示" msg:@"请在系统 设置->隐私->定位服务 开启" ok:@"知道了"];
            
            return;
        }
    }
    else if(type == LBXPermissionType_DataNetwork)
    {
        return;
    }
    else if (type == LBXPermissionType_Photos)
    {
        
        [self choosePhotoSheet:^(BOOL writePermission) {
            
            if (writePermission) {
                
                //获取写权限
                [LBXPermissionPhotos authorizeOnlyWriteWithCompletion:^(BOOL granted, BOOL firstTime) {
                    
                    if (granted) {
                        [self.listView reloadData];
                    }
                    else if (!firstTime)
                    {
                        [LBXPermissionSetting showAlertToDislayPrivacySettingWithTitle:@"提示" msg:@"是否前往设置修改权限" cancel:@"取消" setting:@"设置"];
                    }
                }];
            }
            else
            {
                //获取读写权限
                [LBXPermissionPhotos authorizeWithCompletion:^(BOOL granted, BOOL firstTime) {
                    
                    if (granted) {
                        [self.listView reloadData];
                    }
                    else if (!firstTime)
                    {
                        [LBXPermissionSetting showAlertToDislayPrivacySettingWithTitle:@"提示" msg:@"是否前往设置修改权限" cancel:@"取消" setting:@"设置"];
                    }
                }];
            }
            
        }];
        
        return;
    }
    
    
    [LBXPermission authorizeWithType:numType.integerValue completion:^(BOOL granted, BOOL firstTime) {
            
        [self.listView reloadData];
        
        if ( !granted && !firstTime )
        {
            NSString *msg = @"没有 xxx 权限，是否前往设置";
            if (numType.integerValue == LBXPermissionType_Tracking) {
                
                if (@available(iOS 14.0, *)) {
                    
                    msg = @"没有广告权限,是否前往设置(App跟踪权限 需要检查系统权限是否开启 设置->隐私->跟踪)";
                    
                }else{
                    
                    msg = @"没有广告权限,需要检查系统权限是否开启 设置->隐私->广告->限制广告跟踪)";
                    [LBXPermissionSetting showAlertWithTitle:@"提示" msg:msg ok:@"知道了"];
                    return;
                }
            }
            
            [LBXPermissionSetting showAlertToDislayPrivacySettingWithTitle:@"提示" msg:msg cancel:@"取消" setting:@"设置"];
        }
        else if(granted && !firstTime)
        {
            [LBXPermissionSetting showAlertToDislayPrivacySettingWithTitle:@"提示" msg:@"是否前往设置修改权限" cancel:@"取消" setting:@"设置"];
        }
    }];
   
}

#pragma mark- 网络请求
- (void)netGetRequest
{
    //1，创建请求地址
    NSString *urlString = @"https://tcc.taobao.com/cc/json/mobile_tel_segment.htm?tel=15852509988";
    //对字符进行处理
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    //2.创建请求类
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    //3.创建会话（单例）
    NSURLSession *sharedSession = [NSURLSession sharedSession];
    
    //4.根据会话创建任务
    NSURLSessionDataTask *dataTask = [sharedSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSLog(@"%@",data);
    }];
    
    //5.启动任务
    [dataTask resume];
}

- (void)netPermissionlisten
{
    __weak __typeof(self) weakSelf = self;
    
    NSString *hostName = @"www.baidu.com";//or @"202.108.22.5"
    [[LBXPermissionNet sharedManager]startListenNetWithHostName:hostName onNetStatus:^(NetReachWorkStatus netStatus) {
        

        NSLog(@"netstatus:%ld",netStatus);
        NSString *strNetStatus = @"";
        switch (netStatus) {
            case NetReachWorkNotReachable:
                NSLog(@"网络不可用");
                strNetStatus = @"网络不可用";
                break;
            case NetReachWorkStatusUnknown:
                NSLog(@"未知网络");
                strNetStatus = @"未知网络";
                break;
            case NetReachWorkStatusWWAN2G:
                NSLog(@"2G网络");
                strNetStatus = @"2G网络";
                break;
            case NetReachWorkStatusWWAN3G:
                strNetStatus = @"3G网络";
                break;
            case NetReachWorkStatusWWAN4G:
                NSLog(@"4G网络");
                strNetStatus = @"4G网络";

                break;
            case NetReachWorkStatusWiFi:
                NSLog(@"WiFi");
                strNetStatus = @"WiFi";

                break;
            default:
                break;
        }
        
       
        
    } onNetPermission:^(BOOL granted) {
        
        __strong __typeof(self) strongSelf = weakSelf;
        
        strongSelf.netAuthorized = granted;
        strongSelf.strNetStatus = granted ? @"有网络权限" : @"可能没有网络权限或系统网络关闭了";
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [strongSelf.listView reloadData];
        });
        
    }];
}


#pragma mark- 选择

- (void)choosePhotoSheet:(void(^)(BOOL writePermission))completion
{
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"选择获取相册权限类型" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    
    //        UIAlertActionStyle style =  (0 == i)? UIAlertActionStyleCancel: UIAlertActionStyleDefault;
    UIAlertActionStyle style =  UIAlertActionStyleCancel;
    
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:style handler:^(UIAlertAction *action) {
        
    }];
    [alertController addAction:cancelAction];
    
    
    
    style =  UIAlertActionStyleDefault;
    // Create the actions.
    UIAlertAction *writeAction = [UIAlertAction actionWithTitle:@"仅仅写权限" style:style handler:^(UIAlertAction *action) {
        
        completion(YES);
    }];
    [alertController addAction:writeAction];
    
    

    UIAlertAction *writeReadAction = [UIAlertAction actionWithTitle:@"读写权限" style:style handler:^(UIAlertAction *action) {
        completion(NO);

    }];
    [alertController addAction:writeReadAction];
    
    
    UIAlertAction *writeAlbumAction = [UIAlertAction actionWithTitle:@"图片写入相册测试" style:style handler:^(UIAlertAction *action) {

        [self writeAlbum];
    }];
    [alertController addAction:writeAlbumAction];
    
    
    UIAlertAction *permission = [UIAlertAction actionWithTitle:@"前往设置权限" style:style handler:^(UIAlertAction *action) {

        [LBXPermissionSetting showAlertToDislayPrivacySettingWithTitle:@"提示" msg:@"是否前往设置修改权限" cancel:@"取消" setting:@"设置"];
    }];
    [alertController addAction:permission];
    
    
    [self presentViewController:alertController animated:YES completion:nil];

}

- (void)writeAlbum
{
    UIImage* image = [UIImage imageNamed:@"123"];
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
}

@end
