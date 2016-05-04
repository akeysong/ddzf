//
//  xiangqingViewController.m
//  Theterritoryofpayment
//
//  Created by 铂金数据 on 15/11/30.
//  Copyright © 2015年 铂金数据. All rights reserved.
//

#import "xiangqingViewController.h"
#import "Header.h"
#import "MyNavigationBar.h"
@interface xiangqingViewController ()

{
    MyNavigationBar *mnb;
}

@end

@implementation xiangqingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0];
    [self makeNav];
    [self makeUI];
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64*screenWidth/320, screenWidth, screenHeight-20*screenHeight/320)];
    image.image = [UIImage imageNamed:@"活动详情"];
    
    [self.view addSubview:image];
    
}
-(void)makeNav
{
    //导航
    [self.navigationController setNavigationBarHidden:YES];
    mnb = [[MyNavigationBar alloc] init];
    mnb.frame = CGRectMake(0, 20*screenWidth/320, 320*screenWidth/320, 44*screenWidth/320);
    [mnb createMyNavigationBarWithBgImageName:nil andLeftBBIIamgeNames:[NSArray arrayWithObject:@"fanhui.png"] andRightBBIImages:nil andTitle:@"活动详情" andClass:self andSEL:@selector(bacClick:)];
    [self.view addSubview:mnb];
    //  UIView *
    //状态栏颜色
    UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320*screenWidth/320, 20*screenWidth/320)];
    
    statusBarView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:statusBarView];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
}
-(void)makeUI
{
    
}
-(void)bacClick:(UIButton*)btn
{
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
