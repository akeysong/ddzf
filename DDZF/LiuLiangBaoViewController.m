//
//  LiuLiangBaoViewController.m
//  DDZF
//
//  Created by 王健超 on 15/12/2.
//  Copyright (c) 2015年 wjc. All rights reserved.
//

#import "LiuLiangBaoViewController.h"
#import "Header.h"
#import "MyNavigationBar.h"
#import "PostAsynClass.h"
#import "User.h"
@interface LiuLiangBaoViewController ()<UIWebViewDelegate>
{
    UIWebView *webView;
}


@end

@implementation LiuLiangBaoViewController

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
    [mnb createMyNavigationBarWithBgImageName:nil andLeftBBIIamgeNames:[NSArray arrayWithObject:@"fanhui.png"] andRightBBIImages:nil andTitle:@"优享充值" andClass:self andSEL:@selector(bacClick:)];
    [self.view addSubview:mnb];
    
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
    webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64*screenWidth/320, self.view.frame.size.width, self.view.frame.size.height-64*screenWidth/320)];
    [webView setScalesPageToFit:YES];
    
    User *user=[User currentUser];
    
    NSMutableURLRequest *rever = [PostAsynClass postAsynWithURL:url1 andInterface:url35 andKeyArr:@[@"agentId",@"merId",@"extSysId"]andValueArr:@[can,user.merid,@"0001"]];
    
    //加载请求
    [webView loadRequest:rever];
    
    [self.view addSubview:webView];

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