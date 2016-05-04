//
//  ErWeiMaViewController.m
//  DDZF
//
//  Created by 王健超 on 15/12/2.
//  Copyright (c) 2015年 wjc. All rights reserved.
//

#import "ErWeiMaViewController.h"
#import "User.h"
#import "MyNavigationBar.h"
#import "PostAsynClass.h"
#import "Header.h"

#import <ShareSDK/ShareSDK.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "WXApi.h"
@interface ErWeiMaViewController ()<UIWebViewDelegate>
{
    UIWebView *webView;
}

@end

@implementation ErWeiMaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0];
    [self makeNav];
    [self makeUI];

    // Do any additional setup after loading the view.
}
-(void)makeNav
{
    //导航
    [self.navigationController setNavigationBarHidden:YES];
    MyNavigationBar *mnb = [[MyNavigationBar alloc] init];
    mnb.frame = CGRectMake(0, 20*screenWidth/320, 320*screenWidth/320, 44*screenWidth/320);
    [mnb createMyNavigationBarWithBgImageName:nil andLeftBBIIamgeNames:[NSArray arrayWithObject:@"fanhui.png"] andRightBBIImages:nil andTitle:@"二维码" andClass:self andSEL:@selector(bacClick:)];
    [self.view addSubview:mnb];
    
    
    UIButton *jiluButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [jiluButton setImage:[UIImage imageNamed:@"skfx"] forState:UIControlStateNormal];
    jiluButton.titleLabel.textAlignment=NSTextAlignmentCenter;
    jiluButton.frame=CGRectMake(self.view.frame.size.width-35*screenWidth/320.0, 10*screenWidth/320.0, 30*screenWidth/320.0, 30*screenWidth/320.0);
    [jiluButton addTarget:self action:@selector(navButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [mnb addSubview:jiluButton];

    //状态栏颜色
    UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320*screenWidth/320, 20*screenWidth/320)];
    
    statusBarView.backgroundColor=[UIColor whiteColor];
    
    [self.view addSubview:statusBarView];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
}
-(void)bacClick:(UIButton*)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)makeUI
{
    webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64.5*screenWidth/320, self.view.frame.size.width, self.view.frame.size.height-64.5*screenWidth/320)];
    [webView setScalesPageToFit:YES];
    
    User *user=[User currentUser];
    
    NSMutableURLRequest *rever = [PostAsynClass postAsynWithURL:url1 andInterface:url40 andKeyArr:@[@"merId"]andValueArr:@[user.merid]];
    
    //加载请求
    [webView loadRequest:rever];
    
    [self.view addSubview:webView];
    
    
    
}
-(void)navButtonClick:(UIButton *)btnn

{
    User *user=[User currentUser];
    NSString *urlString=[NSString stringWithFormat:@"%@%@?merId=%@",url1,url40,user.merid];
   // NSLog(@"输出网址为%@",urlString);
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"dengluLOGO" ofType:@"png"];
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:[NSString stringWithFormat:@"来自%@的分享 多多支付App固定二维码%@",user.name,urlString]
                                       defaultContent:@"默认分享内容，没内容时显示"
                                                image:[ShareSDK imageWithPath:imagePath]
                                                title:@"多多支付"
                                                  url:urlString
                                          description:@"多多支付App 固定二维码"
                                            mediaType:SSPublishContentMediaTypeNews];
    //设置短信内容
    [publishContent addSMSUnitWithContent:[NSString stringWithFormat:@"来自%@的分享 多多支付App固定二维码%@",user.name,urlString]];
    //            //创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];
    [container setIPadContainerWithView:btnn arrowDirect:UIPopoverArrowDirectionUp];
    //2、弹出分享菜单
    [ShareSDK showShareActionSheet:container
                         shareList:nil
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions:nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                
                                //可以根据回调提示用户。
                                if (state == SSResponseStateSuccess)
                                {
                                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                                    message:nil
                                                                                   delegate:self
                                                                          cancelButtonTitle:@"OK"
                                                                          otherButtonTitles:nil, nil];
                                    [alert show];
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                                    message:[NSString stringWithFormat:@"失败描述：%@",[error errorDescription]]
                                                                                   delegate:self
                                                                          cancelButtonTitle:@"OK"
                                                                          otherButtonTitles:nil, nil];
                                    [alert show];
                                }
                            }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
