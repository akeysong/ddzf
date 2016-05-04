//
//  zhiFuViewController.m
//  The territory of payment
//
//  Created by 铂金数据 on 15/4/14.
//  Copyright (c) 2015年 铂金数据. All rights reserved.
//

#import "zhiFuViewController.h"
#import "Header.h"
#import "MyNavigationBar.h"
#import "User.h"
@interface zhiFuViewController ()

@end

@implementation zhiFuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    [self makeNav];
    User * user = [User currentUser];
    self.view.backgroundColor=[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0];
    UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64*screenWidth/320, self.view.frame.size.width, self.view.frame.size.height-60*screenWidth/320.0)];
    [webView setScalesPageToFit:YES];
    
    
    //网址字符串
   NSString *urlStr=[NSString stringWithFormat:@"http://120.26.91.233/mobile/ss/doPay.do?merId=%@&transSeqId=%@&credNo=%@&paySrc=%@",user.merid,user.dingDan,user.pingZheng,@"nor"];
    
    user.str=urlStr;
    
   // NSString *urlStr=UIWebView.request.URL.absoluteString;
    //把字符串转成网址类
    NSURL *url = [NSURL URLWithString:urlStr];
    
    //用网址创建一个请求
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    //加载请求
    [webView loadRequest:request];
      [self.view addSubview:webView];

    
    
    // Do any additional setup after loading the view.
}
-(void)makeNav
{
    //导航
    [self.navigationController setNavigationBarHidden:YES];
    MyNavigationBar *mnb = [[MyNavigationBar alloc] init];
    mnb.frame = CGRectMake(0, 20*screenWidth/320, 320*screenWidth/320, 44*screenWidth/320);
    [mnb createMyNavigationBarWithBgImageName:nil andLeftBBIIamgeNames:[NSArray arrayWithObject:@"fanhui.png"] andRightBBIImages:nil andTitle:@"充值" andClass:self andSEL:@selector(backlick)];
    [self.view addSubview:mnb];
    
    
    //状态栏颜色
    UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320*screenWidth/320, 20*screenWidth/320)];
    
    statusBarView.backgroundColor=[UIColor whiteColor];
    //statusBarView.backgroundColor=[UIColor whiteColor];
    
    [self.view addSubview:statusBarView];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
    
}
-(void)backlick
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadData" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
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
