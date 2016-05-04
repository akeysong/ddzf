//
//  tuangouViewController.m
//  DDZF
//
//  Created by 王健超 on 15/12/18.
//  Copyright (c) 2015年 wjc. All rights reserved.
//

#import "tuangouViewController.h"
#import "MyNavigationBar.h"
#import "Header.h"
#import "User.h"
@interface tuangouViewController ()<UIWebViewDelegate>

{
    UIWebView *webview;
}

@end

@implementation tuangouViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeNav];
    [self makeUI];
    self.view.backgroundColor=[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0];

    // Do any additional setup after loading the view.
}
-(void)makeNav
{
    //导航
    [self.navigationController setNavigationBarHidden:YES];
    MyNavigationBar *mnb = [[MyNavigationBar alloc] init];
    mnb.frame = CGRectMake(0, 20*screenWidth/320, 320*screenWidth/320, 44*screenWidth/320);
    [mnb createMyNavigationBarWithBgImageName:nil andLeftBBIIamgeNames:[NSArray arrayWithObject:@"fanhui.png"] andRightBBIImages:nil andTitle:@"团购" andClass:self andSEL:@selector(bacClick:)];
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
    //创建一个网页视图。
    webview=[[UIWebView alloc]initWithFrame:CGRectMake(0, 64.6*screenWidth/320, self.view.frame.size.width, self.view.frame.size.height-64.6*screenWidth/320.0)];
    webview.delegate=self;
    NSURL *url=[NSURL URLWithString:@"http://i.meituan.com"];
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    [webview loadRequest:request];
    [self.view addSubview:webview];

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
