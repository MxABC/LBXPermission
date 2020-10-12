//
//  PermissionTestViewController.m
//  LBXKit
//
//  Created by lbx on 2017/10/30.
//  Copyright © 2017年 lbx. All rights reserved.
//

#import "PermissionTestViewController.h"
#import "LBXPermission.h"
#import "LBXPermissionSetting.h"
#import "LBXPermissionNet.h"
#import "LBXPermissionTracking.h"
#import <PhotosUI/PhotosUI.h>


@interface PermissionTestViewController ()<PHPickerViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UISwitch *photoSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *cameraSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *locationSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *contactSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *reminderSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *calendarSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *healthSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *audioSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *mediaLibrarySwitch;
//广告
@property (weak, nonatomic) IBOutlet UISwitch *idfaSwitch;

//健康提示
@property (weak, nonatomic) IBOutlet UILabel *labelHealthTip;

//定位提示
@property (weak, nonatomic) IBOutlet UILabel *labelLocationService;

//网络状态
@property (weak, nonatomic) IBOutlet UILabel *labelNetStatus;
//网络权限
@property (weak, nonatomic) IBOutlet UILabel *labelNetPermission;


@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@end

@implementation PermissionTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.edgesForExtendedLayout = UIRectEdgeNone;

    self.title = @"权限获取测试";
    
    //健康需要 TARGETS ->Capabilities -> HealthKit里面设置
    if ([LBXPermission isDeviceSupportedWithType:LBXPermissionType_Health]) {
        _labelHealthTip.text = @"设备支持HealthKit";
    }
    else{
        _labelHealthTip.text = @"设备不支持HealthKit";
    }
    
    [self addAllTargets];
        
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addAllTargets) name:UIApplicationDidBecomeActiveNotification object:nil];

    
    [self netPermissionlisten];
  
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self netGetRequest];
}

- (void)netGetRequest
{
    
    // 组合一个搜索字符串
    NSString *urlStr = @"https://tcc.taobao.com/cc/json/mobile_tel_segment.htm?tel=15852509988";
    // 字符串转化为URL
    NSURL *url = [NSURL URLWithString:urlStr];
    
    
    // url转化为一个请求
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    // 状态请求
    NSURLResponse *response;
    // 链接一个请求
    NSData *resultData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    
    if (resultData) {
        
        // 返回数据转为字符串
        NSData *dataString = [[NSString alloc] initWithData:resultData encoding:NSUTF8StringEncoding];
        NSLog(@"%@", dataString);
    }
        
}


- (void)swithValueChange:(id)sender
{
    //取消所有switch的值变化监听
    [self clearAllTargets];
    UISwitch *_switch = sender;
    
    
    if (sender == _photoSwitch)
    {
        //相册
        [LBXPermission authorizeWithType:LBXPermissionType_Photos completion:^(BOOL granted, BOOL firstTime) {
            
            _switch.on = granted;
            [self handCompletionWithGranted:granted firstTime:firstTime];
        }];
    }
    else if (sender == _cameraSwitch)
    {
        //相机
        [LBXPermission authorizeWithType:LBXPermissionType_Camera completion:^(BOOL granted, BOOL firstTime) {
           
            _switch.on = granted;
            [self handCompletionWithGranted:granted firstTime:firstTime];
        }];
    }
    else if (sender == _locationSwitch)
    {
        if (![LBXPermission isServicesEnabledWithType:LBXPermissionType_Location])
        {
            //系统定位权限未开启
            _switch.on = NO;
            
            //增加所有switch的值变化监听
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self addAllTargets];
            });
            return;
        }
        
        //定位,模拟器不准确
        [LBXPermission authorizeWithType:LBXPermissionType_Location completion:^(BOOL granted, BOOL firstTime) {
            
            _switch.on = granted;
            [self handCompletionWithGranted:granted firstTime:firstTime];
        }];
      
    }
    else if (sender == _contactSwitch)
    {
        //通讯录
        [LBXPermission authorizeWithType:LBXPermissionType_Contacts completion:^(BOOL granted, BOOL firstTime) {
            
            _switch.on = granted;
            [self handCompletionWithGranted:granted firstTime:firstTime];
        }];
    }
    else if (sender == _reminderSwitch)
    {
        //提醒
        [LBXPermission authorizeWithType:LBXPermissionType_Reminders completion:^(BOOL granted, BOOL firstTime) {
           
            _switch.on = granted;
            [self handCompletionWithGranted:granted firstTime:firstTime];
        }];
    }
    else if (sender == _calendarSwitch)
    {
        //日历
        [LBXPermission authorizeWithType:LBXPermissionType_Calendar completion:^(BOOL granted, BOOL firstTime) {
            
            _switch.on = granted;
            [self handCompletionWithGranted:granted firstTime:firstTime];
        }];
    }
    else if (sender == _healthSwitch)
    {
        //健康,需要相关配置
        [LBXPermission authorizeWithType:LBXPermissionType_Health completion:^(BOOL granted, BOOL firstTime) {
            
            _switch.on = granted;
            [self handCompletionWithGranted:granted firstTime:firstTime];
        }];
    }
    else if (sender == _audioSwitch)
    {
        //麦克风,模拟器不准确
        [LBXPermission authorizeWithType:LBXPermissionType_Microphone completion:^(BOOL granted, BOOL firstTime) {

            _switch.on = granted;
            [self handCompletionWithGranted:granted firstTime:firstTime];
        }];
    } else if (sender == _mediaLibrarySwitch)
    {
        [LBXPermission authorizeWithType:LBXPermissionType_MediaLibrary completion:^(BOOL granted, BOOL firstTime) {
           
            _switch.on = granted;
            [self handCompletionWithGranted:granted firstTime:firstTime];
        }];
        
    }
    else if (sender == _idfaSwitch)
    {
        //系统权限，设置->隐私->跟踪  ->允许App请求跟踪 设置允许
        //系统权限开启正常，则对应App权限开启
        
        [LBXPermissionTracking authorizeWithCompletion:^(BOOL granted, BOOL firstTime) {
            
            _switch.on = granted;
            
            [self handCompletionWithGranted:granted firstTime:firstTime];
        }];
    }
}

- (void)handCompletionWithGranted:(BOOL)granted firstTime:(BOOL)firstTime
{
    //没有权限，且不是第一次获取权限
    if ( !granted && !firstTime )
    {
        [LBXPermissionSetting showAlertToDislayPrivacySettingWithTitle:@"提示" msg:@"没有 xxx 权限，是否前往设置(App跟踪权限 需要检查系统权限是否开启 设置->隐私->跟踪)" cancel:@"取消" setting:@"设置"];
    }
    
    
    //增加所有switch的值变化监听
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self addAllTargets];
        
    });    
    
}

- (void)testCode
{
    //相机
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
}


- (void)addAllTargets
{
    [self refreshStatus];
    
    [_photoSwitch addTarget:self action:@selector(swithValueChange:) forControlEvents:UIControlEventValueChanged];
    [_cameraSwitch addTarget:self action:@selector(swithValueChange:) forControlEvents:UIControlEventValueChanged];
    [_locationSwitch addTarget:self action:@selector(swithValueChange:) forControlEvents:UIControlEventValueChanged];
    [_contactSwitch addTarget:self action:@selector(swithValueChange:) forControlEvents:UIControlEventValueChanged];
    
    [_reminderSwitch addTarget:self action:@selector(swithValueChange:) forControlEvents:UIControlEventValueChanged];
    [_calendarSwitch addTarget:self action:@selector(swithValueChange:) forControlEvents:UIControlEventValueChanged];
    [_healthSwitch addTarget:self action:@selector(swithValueChange:) forControlEvents:UIControlEventValueChanged];
    [_audioSwitch addTarget:self action:@selector(swithValueChange:) forControlEvents:UIControlEventValueChanged];
    [_mediaLibrarySwitch addTarget:self action:@selector(swithValueChange:) forControlEvents:UIControlEventValueChanged];
    
    [_idfaSwitch addTarget:self action:@selector(swithValueChange:) forControlEvents:UIControlEventValueChanged];

 
}

- (void)clearAllTargets
{
    
    [_photoSwitch removeTarget:self action:@selector(swithValueChange:) forControlEvents:UIControlEventValueChanged];
    [_cameraSwitch removeTarget:self action:@selector(swithValueChange:) forControlEvents:UIControlEventValueChanged];
    [_locationSwitch removeTarget:self action:@selector(swithValueChange:) forControlEvents:UIControlEventValueChanged];
    [_contactSwitch removeTarget:self action:@selector(swithValueChange:) forControlEvents:UIControlEventValueChanged];
    
    [_reminderSwitch removeTarget:self action:@selector(swithValueChange:) forControlEvents:UIControlEventValueChanged];
    [_calendarSwitch removeTarget:self action:@selector(swithValueChange:) forControlEvents:UIControlEventValueChanged];
    [_healthSwitch removeTarget:self action:@selector(swithValueChange:) forControlEvents:UIControlEventValueChanged];
    [_audioSwitch removeTarget:self action:@selector(swithValueChange:) forControlEvents:UIControlEventValueChanged];
    [_mediaLibrarySwitch removeTarget:self action:@selector(swithValueChange:) forControlEvents:UIControlEventValueChanged];
    
    [_idfaSwitch removeTarget:self action:@selector(swithValueChange:) forControlEvents:UIControlEventValueChanged];

}


- (void)refreshStatus
{
    _photoSwitch.on         = [LBXPermission authorizedWithType:LBXPermissionType_Photos];
    _cameraSwitch.on        = [LBXPermission authorizedWithType:LBXPermissionType_Camera];
    _locationSwitch.on      = [LBXPermission authorizedWithType:LBXPermissionType_Location];
    _contactSwitch.on       = [LBXPermission authorizedWithType:LBXPermissionType_Contacts];
    _reminderSwitch.on      = [LBXPermission authorizedWithType:LBXPermissionType_Reminders];
    _calendarSwitch.on      = [LBXPermission authorizedWithType:LBXPermissionType_Calendar];
    _healthSwitch.on        = [LBXPermission authorizedWithType:LBXPermissionType_Health];
    _audioSwitch.on         = [LBXPermission authorizedWithType:LBXPermissionType_Microphone];
    _mediaLibrarySwitch.on  = [LBXPermission authorizedWithType:LBXPermissionType_MediaLibrary];
    _idfaSwitch.on = [LBXPermissionTracking authorized];
    
    _labelLocationService.text = [LBXPermission isServicesEnabledWithType:LBXPermissionType_Location]? @"系统服务开启":@"系统服务未开启";
    
    _photoSwitch.enabled = !_photoSwitch.on;
    _cameraSwitch.enabled = !_cameraSwitch.on;
    _locationSwitch.enabled = !_locationSwitch.on;
    _contactSwitch.enabled = !_contactSwitch.on;
    _reminderSwitch.enabled = !_reminderSwitch.on;
    _calendarSwitch.enabled = !_calendarSwitch.on;
    _healthSwitch.enabled = !_healthSwitch.on;
    _audioSwitch.enabled = !_audioSwitch.on;
    _mediaLibrarySwitch.enabled = !_mediaLibrarySwitch.on;
    
    _idfaSwitch.enabled = !_idfaSwitch.on;

}

#pragma mark- 网络权限设置
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
        
        __strong __typeof(self) strongSelf = weakSelf;
        if (strongSelf) {
            strongSelf.labelNetStatus.text = strNetStatus;
        }
        
    } onNetPermission:^(BOOL granted) {
        
        __strong __typeof(self) strongSelf = weakSelf;
        strongSelf.labelNetPermission.text = granted ? @"有网络权限" : @"可能没有网络权限";
    }];
}

#pragma mark- 相册
- (IBAction)pickerSelect:(id)sender
{
    [LBXPermission authorizeWithType:LBXPermissionType_Photos completion:^(BOOL granted, BOOL firstTime) {
        
        if (granted) {
            
            if (@available(iOS 14.0, *)) {
                
                PHPickerConfiguration *configuration = [[PHPickerConfiguration alloc] init];
                
        //        PHPickerFilter *imagesFilter;
        //        PHPickerFilter *videosFilter;
        //       PHPickerFilter *livePhotosFilter;
                
                configuration.filter = [PHPickerFilter imagesFilter];
                configuration.selectionLimit = 1; // 默认为1，为0时表示可多选。
                
                PHPickerViewController *picker = [[PHPickerViewController alloc] initWithConfiguration:configuration];
                picker.delegate = self;
                picker.view.backgroundColor = [UIColor whiteColor];//注意需要进行暗黑模式适配
                [self presentViewController:picker animated:YES completion:^{
                    
                }];
            }else{
                
            }
        }
       
    }];
   
}


- (void)picker:(PHPickerViewController *)picker didFinishPicking:(NSArray<PHPickerResult *> *)results API_AVAILABLE(ios(14.0))
{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    if (!results || !results.count) {
        return;
    }
    
    //测试只是允许了部分图片权限，但是仍然可以选择所有照片...
    
    for (PHPickerResult *result in results) {
        
        NSItemProvider *itemProvider = result.itemProvider;
        if ([itemProvider canLoadObjectOfClass:UIImage.class]) {
            [itemProvider loadObjectOfClass:UIImage.class completionHandler:^(__kindof id<NSItemProviderReading>  _Nullable object, NSError * _Nullable error) {
                
                if (!error) {
                    NSLog(@"返回成功");
                }
                else
                {                    
//                   NSLog(@"如果相册权限是部分允许，那边你选择了其他照片，则会报错");
                    NSLog(@"%@",error);
                    
                }
                
                if ([object isKindOfClass:UIImage.class]) {
                    NSLog(@"image");
                    
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            self.imgView.image = (UIImage*)object;
                        });
                    
                }
            }];
        }
    }
}


@end
