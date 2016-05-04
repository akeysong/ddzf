//
//  FirstUseViewController.m
//  DDZF
//
//  Created by 王健超 on 15/11/30.
//  Copyright (c) 2015年 wjc. All rights reserved.
//

#import "FirstUseViewController.h"
#import "LoginViewController.h"
#import "User.h"
#import "Header.h"
@interface FirstUseViewController ()

@end

@implementation FirstUseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self showFirst];
    // Do any additional setup after loading the view.
}
#pragma maek 设置引导页
-(void)showFirst
{
    
    //初始化scrollerview
    UIScrollView * scrollView = [[UIScrollView alloc]initWithFrame:self.view.frame];
    [scrollView setContentSize:CGSizeMake(self.view.frame.size.width * 4, self.view.frame.size.height)];
    [scrollView setPagingEnabled:YES];  //视图整页显示
    [scrollView setBounces:NO]; //避免弹跳效果,避免把根视图露出来
    
    //第一张图片
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [imageview setImage:[UIImage imageNamed:@"first1"]];
    [scrollView addSubview:imageview];
    
    //第二张图片
    UIImageView *imageview1 = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width,1, self.view.frame.size.width, self.view.frame.size.height)];
    [imageview1 setImage:[UIImage imageNamed:@"first2"]];
    [scrollView addSubview:imageview1];
    
    //第三张图片
    UIImageView *imageview2 = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width * 2, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [imageview2 setImage:[UIImage imageNamed:@"first3"]];
    [scrollView addSubview:imageview2];
    
    //第四张图片
    UIImageView *imageview3 = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width * 3, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [imageview3 setImage:[UIImage imageNamed:@"first4"]];
    imageview3.userInteractionEnabled = YES;
    [scrollView addSubview:imageview3];
    
    
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setFrame:CGRectMake(80*screenWidth/320 , self.view.frame.size.height - 130, self.view.frame.size.width- 160, 70*screenWidth/320)];
    button.backgroundColor=[UIColor clearColor];
    [button setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 7;
    [button addTarget:self action:@selector(btn) forControlEvents:UIControlEventTouchUpInside];
    [imageview3 addSubview:button];
    
    [self.view addSubview:scrollView];
    
    
}
-(void)btn
{
    NSLog(@"点击了");
    LoginViewController* loginVC = [[LoginViewController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
    [self.view.window setRootViewController:nav];
    
    
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
