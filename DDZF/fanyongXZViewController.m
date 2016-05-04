//
//  fanyongXZViewController.m
//  DDZF
//
//  Created by 王健超 on 16/3/7.
//  Copyright (c) 2016年 wjc. All rights reserved.
//

#import "fanyongXZViewController.h"
#import "MyNavigationBar.h"
#import "Header.h"
#import "User.h"
@interface fanyongXZViewController ()

@end

@implementation fanyongXZViewController

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
    [mnb createMyNavigationBarWithBgImageName:nil andLeftBBIIamgeNames:[NSArray arrayWithObject:@"fanhui.png"] andRightBBIImages:nil andTitle:@"返佣须知" andClass:self andSEL:@selector(bacClick:)];
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
    UIImageView *fanyongXZimage=[[UIImageView alloc] initWithFrame:CGRectMake(0, 64.5*screenWidth/320.0, self.view.frame.size.width, self.view.frame.size.height-64.5*screenWidth/320.0)];
    fanyongXZimage.image=[UIImage imageNamed:@""];
    [self.view addSubview:fanyongXZimage];
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
