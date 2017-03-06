//
//  AppDelegate.m
//  TyreAlliance
//
//  Created by wdx on 16/9/12.
//  Copyright © 2016年 wdx. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "LogIn.h"
#import "Guidance.h"
#import "AFNetworkReachabilityManager.h"

#import <UMSocialCore/UMSocialCore.h>

#import "XGPush.h"
#import "XGSetting.h"

#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件

#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件

#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件

//#import <BaiduMapAPI_Cloud/BMKCloudSearchComponent.h>//引入云检索功能所有的头文件

#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件

//#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>//引入计算工具所有的头文件

//#import <BaiduMapAPI_Radar/BMKRadarComponent.h>//引入周边雷达功能所有的头文件

#import <BaiduMapAPI_Map/BMKMapView.h>//只引入所需的单个头文件


#import "OrderDetail.h"
#import "MessageDeatail.h"

#import <UserNotifications/UserNotifications.h>



@interface AppDelegate ()<UIAlertViewDelegate,UNUserNotificationCenterDelegate>
@property (nonatomic,strong)NSString * oid,* type,* mess;


@property(nonatomic,strong)AlertBloc alertBlock;
@property (nonatomic,strong)BMKMapManager * mapManager;
@property (nonatomic,strong)UINavigationController * rootNavi;
@end

@implementation AppDelegate
//-(BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
//    UIViewController * lanuchController=[[UIStoryboard storyboardWithName:@"LaunchScreen" bundle:nil]instantiateViewControllerWithIdentifier:@"LaunchScreen"];
//    UIView * lanuchView=lanuchController.view;
//    [UIView animateWithDuration:1 animations:^{
//        lanuchView.transform=CGAffineTransformScale(lanuchView.transform, 2, 2);
//    }];
//    return YES;
//}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //系统配置
    [[Stockpile sharedStockpile]setAccountType:@"1"];
//    [[Stockpile sharedStockpile]setIsLogin:YES];
//    [[Stockpile sharedStockpile]setIsSign:YES];
    [self switchRootController];
    
//    请先启动BaiduMapManager
    _mapManager = [[BMKMapManager alloc]init];
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    BOOL ret = [_mapManager start:@"K4UlvwVWQq3hWlxlzxrxey0Ix78tDW9y"  generalDelegate:nil];
    if (!ret) {
        NSLog(@"manager start failed!");
    }

    


    //配置友盟
    [self setUpUMShare];
    //配置信鸽
    [XGPush handleLaunching:launchOptions];
    [self zhuce];
    // Override point for customization after application launch.
    
    
    
    if ([Stockpile sharedStockpile].isLogin) {
        [XGPush setAccount:[NSString stringWithFormat:@"TZM_%@",[Stockpile sharedStockpile].ID]];
        [self zhuce];
    }
    return YES;
}


-(void)zhuce{
    

    [XGPush startApp:2200240179 appKey:@"I77Q4I78VMNU"];
    
    NSString * sysVerS = [[UIDevice currentDevice] systemVersion];
    NSArray * sysVerA=[sysVerS componentsSeparatedByString:@"."];
    NSInteger sysVer=[[NSString stringWithFormat:@"%@",sysVerA.firstObject] integerValue];
    NSLog(@"%@",sysVerS);
    
    if(sysVer < 8){//iOS 8 以下
        [self registerPush];
    }else if(sysVer < 10){//iOS 8 以上 及 10 以下
        [self registerPushForIOS8];
    }else{//iOS 10 及以上
        [self registerPushForIOS10];
    }
}


#pragma mark -- 信鸽推送
- (void)registerPush{// iOS 8 以下的注册
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
}
// iOS 8 以上 9 以下的注册
- (void)registerPushForIOS8{
    //Types
    UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    
    //Actions
    UIMutableUserNotificationAction *acceptAction = [[UIMutableUserNotificationAction alloc] init];
    
    acceptAction.identifier = @"ACCEPT_IDENTIFIER";
    acceptAction.title = @"Accept";
    
    acceptAction.activationMode = UIUserNotificationActivationModeForeground;
    acceptAction.destructive = NO;
    acceptAction.authenticationRequired = NO;
    
    //Categories
    UIMutableUserNotificationCategory *inviteCategory = [[UIMutableUserNotificationCategory alloc] init];
    
    inviteCategory.identifier = @"INVITE_CATEGORY";
    
    [inviteCategory setActions:@[acceptAction] forContext:UIUserNotificationActionContextDefault];
    
    [inviteCategory setActions:@[acceptAction] forContext:UIUserNotificationActionContextMinimal];
    
//    [acceptAction release];
    
    NSSet *categories = [NSSet setWithObjects:inviteCategory, nil];
    
//    [inviteCategory release];
    
    
    UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:categories];
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
    
    
    [[UIApplication sharedApplication] registerForRemoteNotifications];
}
- (void)registerPushForIOS10{
//            DispatchQueue.main.async {
//                let settings = UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil)
//                UIApplication.shared().registerUserNotificationSettings(settings)
//            }
    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        UIUserNotificationSettings * settings=[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
//        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
//    });
    

    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate = self;
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error){
        if( !error ){
            [[UIApplication sharedApplication] registerForRemoteNotifications];
        }
    }];
    
}

-(void)unRegistNoti{
    [XGPush unRegisterDevice];
}
-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    //notification是发送推送时传入的字典信息
    [XGPush localNotificationAtFrontEnd:notification userInfoKey:@"clockID" userInfoValue:@"myid"];
    
    //删除推送列表中的这一条
    [XGPush delLocalNotification:notification];
    //[XGPush delLocalNotification:@"clockID" userInfoValue:@"myid"];
    
    //清空推送列表
    //[XGPush clearLocalNotifications];
}
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_

//注册UserNotification成功的回调
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    //用户已经允许接收以下类型的推送
    //UIUserNotificationType allowedTypes = [notificationSettings types];
    
}
//按钮点击事件回调
- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler{
    if([identifier isEqualToString:@"ACCEPT_IDENTIFIER"]){
        NSLog(@"ACCEPT_IDENTIFIER is clicked");
    }
    
    completionHandler();
}

#endif
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
//    NSString * deviceTokenStr = [XGPush registerDevice:deviceToken];
    
    void (^successBlock)(void) = ^(void){
        //成功之后的处理
        NSLog(@"[XGPush Demo]register successBlock");
    };
    
    void (^errorBlock)(void) = ^(void){
        //失败之后的处理
        NSLog(@"[XGPush Demo]register errorBlock");
    };
    
    
    //注册设备
    NSString * deviceTokenStr = [XGPush registerDevice:deviceToken successCallback:successBlock errorCallback:errorBlock];
    
    //如果不需要回调
    [XGPush registerDevice:deviceToken];
//    [self zhuce];
    //打印获取的deviceToken的字符串
    NSLog(@"[XGPush Demo] deviceTokenStr is %@",deviceTokenStr);
    [XGPush registerDeviceStr:deviceTokenStr];
}

//如果deviceToken获取不到会进入此事件
- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
    
    NSString *str = [NSString stringWithFormat: @"Error: %@",err];
    
    NSLog(@"      [XGPush Demo]%@                                             ",str);
    
}

- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo
{
    _oid=[NSString stringWithFormat:@"%@",userInfo[@"oid"]];
    _type=[NSString stringWithFormat:@"%@",userInfo[@"type"]];
    _mess=((NSDictionary *)userInfo[@"aps"])[@"alert"];
    
    NSLog(@"%@",@"有朋自远方来 不亦乐乎");
    
    if (application.applicationState!=UIApplicationStateActive) {//未打开
        
            [self switchRootController];
        switch (_type.integerValue) {
            case 0:
                
                break;
            case 1:{
                
                OrderDetail * orderDetail= [OrderDetail new];
                orderDetail.ziid=_oid;
                [_rootNavi pushViewController:orderDetail animated:YES];
                
            }
                break;
            case 2:
            {
                
                MessageDeatail * messDetail=[MessageDeatail new];
                [_rootNavi pushViewController:messDetail animated:YES];
            }
                break;
            default:
                break;
        }
        
        
    }else{//打开时
        
        
        switch (_type.integerValue) {
            case 0:{
                UIAlertView *alt = [[UIAlertView alloc] initWithTitle:@"通知" message:_mess  delegate:nil cancelButtonTitle:nil otherButtonTitles:@"知道了", nil];
                [alt show];
            }
                break;
            case 1:
            {
                
                UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"订单" message:_mess delegate:self cancelButtonTitle:@"忽略" otherButtonTitles:@"查看订单", nil];
                [alert show];
                
            }
                break;
            case 2:
            {
                UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"消息" message:_mess delegate:self cancelButtonTitle:@"忽略" otherButtonTitles:@"查看消息", nil];
                [alert show];
            }
                break;
            default:
                break;
        }
        

    }
//    [[UIApplication sharedApplication]setApplicationIconBadgeNumber:0];
//    completionHandler(UIBackgroundFetchResultNewData);
    
}




#pragma mark --  iOS 10 推送
// iOS 10 在前台收到通知
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler{
    
    //功能：可设置是否在应用内弹出通知
    completionHandler(UNNotificationPresentationOptionAlert);
}


// iOS 10  点击推送消息后回调 点击通知栏
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler{
    

    
    [XGPush handleReceiveNotification:response.notification.request.content.userInfo successCallback:^{
          NSLog(@"[XGDemo] Handle receive success");
    } errorCallback:^{
            NSLog(@"[XGDemo] Handle receive error");
    } completion:^{
        completionHandler();
    }];
    
    

}






-(void)switchRootController{
    
    
    BOOL isSign=(BOOL)[Stockpile sharedStockpile].isSign;
    BOOL isLogin=(BOOL)[Stockpile sharedStockpile].isLogin;
    UINavigationController * mainNavi;
    
    if (!isSign) {//新手引导页
        Guidance * guidance=[Guidance new];
        mainNavi=[[UINavigationController alloc]initWithRootViewController:guidance];
        [[Stockpile sharedStockpile] setIsSign:YES];
    }else{
        if (isLogin) {
            ViewController * viewController=[ViewController new];
            mainNavi=[[UINavigationController alloc]initWithRootViewController:viewController];
        }else{
            LogIn * login=[[LogIn alloc]initWithLogin:^(BOOL ok) {
                if (ok) {
                    [[Stockpile sharedStockpile]setIsLogin:YES];
                    [self switchRootController];
                }
            }];
            mainNavi=[[UINavigationController alloc]initWithRootViewController:login];
        }
    }
    
    self.window.rootViewController=mainNavi;
    _rootNavi=mainNavi;
    [self.window makeKeyAndVisible];
    
    
}

#pragma mark -- 友盟
-(void)setUpUMShare{
    //打开调试日志
    [[UMSocialManager defaultManager] openLog:YES];
    
    //设置友盟appkey
    [[UMSocialManager defaultManager] setUmSocialAppkey:@"57fd88b567e58efe9f003420"];
    
    // 获取友盟social版本号
    //NSLog(@"UMeng social version: %@", [UMSocialGlobal umSocialSDKVersion]);
    
    //    //设置微信的appKey和appSecret
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wx0c00583ae23400c2" appSecret:@"8fa201bb9f27d8c1a721f6bbaf7d79db" redirectURL:@"http://mobile.umeng.com/social"];
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatTimeLine appKey:@"wx0c00583ae23400c2" appSecret:@"8fa201bb9f27d8c1a721f6bbaf7d79db" redirectURL:@"http://mobile.umeng.com/social"];
    //

    
    
    //设置分享到QQ互联的appKey和appSecret
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"1105827110"  appSecret:nil redirectURL:@"http://mobile.umeng.com/social"];
    [[UMSocialManager defaultManager]setPlaform:UMSocialPlatformType_Qzone appKey:@"1105827110" appSecret:nil redirectURL:@"http://mobile.umeng.com/social"];
    
    //100424468
    
    
    

}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


-(void)ShowAlertTitle:(NSString *)title Message:(NSString *)message Delegate:(id)delegate Block:(AlertBloc)block{
    
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:title message:message delegate:delegate cancelButtonTitle:@"取消" otherButtonTitles: @"查看",nil];
    //alert.tintColor=pinkTextColor;
    [alert show];
    _alertBlock=block;
}

#pragma  mark -- alertDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex==1) {
        [self switchRootController];
        if ([_type isEqualToString:@"1"]) {
            OrderDetail * orderD=[OrderDetail new];
            orderD.ziid=_oid;
            [_rootNavi pushViewController:orderD animated:YES];
        }else{
            MessageDeatail * messDetail=[MessageDeatail new];
//            messDetail.
            [_rootNavi pushViewController:messDetail animated:YES];
        }
        

    }
}

@end
