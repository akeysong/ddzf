//
//  AppDelegate.m
//  DDZF
//
//  Created by 王健超 on 15/11/30.
//  Copyright (c) 2015年 wjc. All rights reserved.
//

#import "AppDelegate.h"
#import "FirstUseViewController.h"
#import "LoginViewController.h"
#import "WXApi.h"
#import "PostAsynClass.h"
#import "User.h"
#import "Header.h"
#import <ShareSDK/ShareSDK.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "APService.h"
@interface AppDelegate ()
{
    NSString *_URL;
}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [application setStatusBarHidden:NO];
    [application setStatusBarStyle:UIStatusBarStyleLightContent];
    //设置引导页;设置根控制器
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"everLaunched"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everLaunched"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
    }
    else{
        
        [[NSUserDefaults standardUserDefaults] setBool:NO
                                                forKey:@"firstLaunch"];
    }
    //如果是第一次使用APP,直接进入引导页
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"firstLaunch"]) {
        
        //初始化引导页,设置成主页面
        FirstUseViewController * firstVC =[[FirstUseViewController alloc]init];
        self.window.rootViewController = firstVC;
        
    }else
    {
        //如果不是第一次使用APP,直接进入登陆页面
        //开机画面停留时间
        [NSThread sleepForTimeInterval:1.0];
        [_window makeKeyAndVisible];
        
        LoginViewController *log=[[LoginViewController alloc] init];
        UINavigationController *nav=[[UINavigationController alloc] initWithRootViewController:log];
        self.window.rootViewController=nav;
        
    }
    // mob官网申请
    [ShareSDK registerApp:@"cd3b36e14528"];
    
    [ShareSDK connectWeChatWithAppId:@"wx37af0956ee5a4a08"   //微信APPID
                           appSecret:@"1e4ee31a4caaf8bdc83a2aef75c27577"  //微信APPSecret
                           wechatCls:[WXApi class]];
    [ShareSDK connectQQWithAppId:@"1105014924" qqApiCls:[QQApiInterface class]];
    [ShareSDK connectQQWithQZoneAppKey:@"1105014924"
                     qqApiInterfaceCls:[QQApiInterface class]
                       tencentOAuthCls:[TencentOAuth class]];    [ShareSDK connectSMS];
    
    User *user=[User currentUser];
    //版本更新代码********************************************************
//    NSMutableURLRequest *rever =[PostAsynClass postAsynWithURL:url1 andInterface:url25 andKeyArr:@[@"agentId",@"appType"]andValueArr:@[can,@"ios"]];
//    //
//    NSData *receive = [NSURLConnection sendSynchronousRequest:rever returningResponse:nil error:nil];
//    
//    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
//    
//    
//    //NSString *string=[receive stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    
//    NSString  *str = [[NSString alloc] initWithData:receive encoding:enc];
//    
//    NSData *ata = [NSData alloc];
//    
//    ata = [str dataUsingEncoding:NSUTF8StringEncoding];
//    
//    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:ata options:NSJSONReadingMutableLeaves error:nil];
//    _URL=[dic objectForKey:@"appUrl"];
//    user.URL=_URL;
//    user.banBen=[dic objectForKey:@"versionId"];
//    
//    NSLog(@"6767676767676%@",dic);
//    
//    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"listFileName" ofType:@"plist"];
//    NSDictionary *dictionary = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
//    NSLog(@"%@%@",plistPath,dictionary);
//    
//    NSString *path = [[NSBundle mainBundle] bundlePath];
//    NSString *finalPath = [path stringByAppendingPathComponent:@"Info.plist"];
//    //    NSMutableDictionary *plistData = [[NSMutableDictionary dictionaryWithContentsOfFile:finalPath] retain];
//    
//    NSDictionary *plistDic = [NSDictionary dictionaryWithContentsOfFile:finalPath];
//    NSLog(@"%@",plistDic);
//    user.BenDiBanBen=[plistDic objectForKey:@"CFBundleShortVersionString"];
//    if ([[dic objectForKey:@"versionId"]isEqualToString:[plistDic objectForKey:@"CFBundleShortVersionString"]]) {
//        NSLog(@"当前为最新版本");
//    }
//    else
//    {
//        NSLog(@"需要更新");
//        
//        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"版本更新" message:@"存在最新的版本程序，确认是否更新" delegate:self cancelButtonTitle:@"暂不更新" otherButtonTitles:@"更新版本", nil];
//        [alertView show];
//        alertView.tag=2;
//        
//    }
    //版本更新代码********************************************************
    //推送
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [APService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                       UIUserNotificationTypeSound |
                                                       UIUserNotificationTypeAlert)
                                           categories:nil];
    } else {
        //categories 必须为nil
        [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                       UIRemoteNotificationTypeSound |
                                                       UIRemoteNotificationTypeAlert)
                                           categories:nil];
    }
    
    // Required
    [APService setupWithOption:launchOptions];
    
    //获取推送的内容
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    //收到消息
    [defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
    //连接成功
    [defaultCenter addObserver:self selector:@selector(successconnect:) name:kJPFNetworkDidSetupNotification object:nil];
    //关闭连接
    [defaultCenter addObserver:self selector:@selector(closeconnect:) name:kJPFNetworkDidCloseNotification object:nil];
    //成功注册
    [defaultCenter addObserver:self selector:@selector(successregister:) name:kJPFNetworkDidRegisterNotification object:nil];
    //成功登陆
    [defaultCenter addObserver:self selector:@selector(successlogin:) name:kJPFNetworkDidLoginNotification object:nil];
    
    NSDictionary *remoteNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if(remoteNotification != nil)
    {
        self.isLaunchedByNotification = YES;
    }
    
    // Override point for customization after application launch.
    return YES;

}
#pragma mark   推送调用
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    // Required
    [APService registerDeviceToken:deviceToken];
    NSLog(@"输出token为%@",deviceToken);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required
    [APService handleRemoteNotification:userInfo];
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    // IOS 7 Support Required
    User *user=[User currentUser];
    [APService handleRemoteNotification:userInfo];
    [APService setAlias:user.merid callbackSelector:nil object:nil];
    completionHandler(UIBackgroundFetchResultNewData);
    
    NSLog(@"收到通知2:%@", [self logDic:userInfo]);
    NSDictionary *dic = userInfo[ @"aps"];
    NSString *alert = dic[@"alert"];
    NSLog(@"推送消息为%@",alert);
    
}
- (NSString *)logDic:(NSDictionary *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str =
    [NSPropertyListSerialization propertyListFromData:tempData
                                     mutabilityOption:NSPropertyListImmutable
                                               format:NULL
                                     errorDescription:NULL];
    return str;
}
#pragma mark  单个推送  f9c5dba3f5bb2f98601345f3
+ (void)setAlias:(NSString *)alias callbackSelector:(SEL)cbSelector object:(id)theTarget
{
    User *user=[User currentUser];
    alias=user.merid;
    NSLog(@"shifou成功");
}
- (void)tagsAliasCallback:(int)iResCode tags:(NSSet*)tags alias:(NSString*)alias {
    NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags , alias);
}
#pragma mark   获取推送内容调用
- (void)networkDidReceiveMessage:(NSNotification *)notification {
    NSDictionary * userInfo = [notification userInfo];
    NSString *content = [userInfo valueForKey:@"content"];
    NSLog(@"推送内容为%@,%@",userInfo,content);
    //[UIApplication sharedApplication].applicationIconBadgeNumber +=1;
    
    
}
-(void)successconnect:(NSNotification *)notification
{
    NSLog(@"成功连接");
}
-(void)closeconnect:(NSNotification *)notification
{
    NSLog(@"关闭连接");
}
-(void)successregister:(NSNotification *)notification
{
    NSLog(@"注册成功");
}
-(void)successlogin:(NSNotification *)notification
{
    NSLog(@"成功登陆");
    User *user=[User currentUser];
    NSLog(@"shucu %@",user.merid);
    [APService setAlias:user.merid callbackSelector:nil object:self];
    
}

//版本更新弹出按钮
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //如果一个界面有多个提示框，通过tag值区分，就像textField一样
    //通过buttonIndex来确定点击的是提示框上的哪个按钮
    if (!buttonIndex) {
    } else {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_URL]];
        
    }
}
- (BOOL)application:(UIApplication *)application
      handleOpenURL:(NSURL *)url
{
    return [ShareSDK handleOpenURL:url
                        wxDelegate:self];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [ShareSDK handleOpenURL:url
                 sourceApplication:sourceApplication
                        annotation:annotation
                        wxDelegate:self];
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
    //角标消除
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    NSLog(@"进入应用");
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
