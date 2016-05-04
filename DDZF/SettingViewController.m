//
//  SettingViewController.m
//  DDZF
//
//  Created by 王健超 on 15/12/1.
//  Copyright (c) 2015年 wjc. All rights reserved.
//

#import "SettingViewController.h"
#import "MyNavigationBar.h"
#import "Header.h"
#import "User.h"
#import "changePWDViewController.h"
#import "TongZhiViewController.h"
#import "changePhoneNumViewController.h"
@interface SettingViewController ()<UIAlertViewDelegate>
{
    UIView *firstView;
    UIView *secondView;
    //UIView *thirdView;
}
@end

@implementation SettingViewController

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
    [mnb createMyNavigationBarWithBgImageName:nil andLeftBBIIamgeNames:[NSArray arrayWithObject:@"fanhui.png"] andRightBBIImages:nil andTitle:@"设置" andClass:self andSEL:@selector(bacClick:)];
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
    User *user=[User currentUser];
    firstView=[[UIView alloc] initWithFrame:CGRectMake(0, 70*screenWidth/320.0, self.view.frame.size.width, 90*screenWidth/320.0)];
    firstView.userInteractionEnabled=YES;
    firstView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:firstView];
    NSArray *array1=@[@"密码管理",@"手机号管理"];
    for(int i=0;i<2;i++)
    {
        UILabel *mimaLabel=[[UILabel alloc] initWithFrame:CGRectMake(20*screenWidth/320.0, 5*screenWidth/320.0+45*screenWidth/320.0*i, 100*screenWidth/320.0, 35*screenWidth/320.0)];
        mimaLabel.text=array1[i];
        mimaLabel.font=[UIFont systemFontOfSize:14*screenWidth/320.0];
        mimaLabel.textAlignment=NSTextAlignmentLeft;
        [firstView addSubview:mimaLabel];
        
        UIImageView *firstJiantouImage=[[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width-25*screenWidth/320.0, 17*screenWidth/320.0+45*screenWidth/320.0*i, 8*screenWidth/320.0, 11*screenWidth/320.0)];
        firstJiantouImage.image=[UIImage imageNamed:@"xiayibujiantou@2x.png"];
        [firstView addSubview: firstJiantouImage];
        
        UIButton *firstButton=[UIButton buttonWithType:UIButtonTypeCustom];
        firstButton.frame=CGRectMake(0, 45*screenWidth/320.0*i, firstView.frame.size.width, 45*screenWidth/320.0);
        [firstButton addTarget:self action:@selector(firstBtn:) forControlEvents:UIControlEventTouchUpInside];
        firstButton.tag=100+i;
        firstButton.backgroundColor=[UIColor clearColor];
        [firstView addSubview:firstButton];
    }
    UIView *firstLineView=[[UIView alloc] initWithFrame:CGRectMake(0, 45*screenWidth/320.0, firstView.frame.size.width, 0.5)];
    firstLineView.backgroundColor=[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0];
    [firstView addSubview:firstLineView];
    
    NSArray *secondArray=@[@"推送消息",@"版本信息"];
    for(int num=0;num<2;num++)
    {
        secondView=[[UIView alloc] initWithFrame:CGRectMake(0, firstView.frame.size.height+firstView.frame.origin.y+15*screenWidth/320.0+60*screenWidth/320.0*num, self.view.frame.size.width, 45*screenWidth/320.0)];
        secondView.backgroundColor=[UIColor whiteColor];
        secondView.userInteractionEnabled=YES;
        [self.view addSubview:secondView];
        
        UILabel *secondLabel=[[UILabel alloc] initWithFrame:CGRectMake(20*screenWidth/320.0, 5*screenWidth/320.0, 100*screenWidth/320.0, 35*screenWidth/320.0)];
        secondLabel.text=secondArray[num];
        secondLabel.textAlignment=NSTextAlignmentLeft;
        secondLabel.font=[UIFont systemFontOfSize:14*screenWidth/320.0];
        [secondView addSubview:secondLabel];
        
        UIImageView *secondJiantouImage=[[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width-25*screenWidth/320.0, 17*screenWidth/320.0, 8*screenWidth/320.0, 11*screenWidth/320.0)];
        if(num==1)
        {
            secondJiantouImage.image=[UIImage imageNamed:@""];
            
            UILabel *banbenLabel=[[UILabel alloc] initWithFrame:CGRectMake(secondView.frame.size.width-55*screenWidth/320.0, 5*screenWidth/320.0, 30*screenWidth/320.0, 35*screenWidth/320.0)];
            banbenLabel.textAlignment=NSTextAlignmentCenter;
            banbenLabel.text=user.BenDiBanBen;
            banbenLabel.font=[UIFont systemFontOfSize:15];
            [secondView addSubview:banbenLabel];
        }
        else
        {
           secondJiantouImage.image=[UIImage imageNamed:@"xiayibujiantou@2x.png"];
        }
        [secondView addSubview:secondJiantouImage];
        
        UIButton *secondButton=[UIButton buttonWithType:UIButtonTypeCustom];
        secondButton.frame=CGRectMake(0, 0, firstView.frame.size.width, 45*screenWidth/320.0);
        [secondButton addTarget:self action:@selector(secondBtn:) forControlEvents:UIControlEventTouchUpInside];
        secondButton.tag=200+num;
        secondButton.backgroundColor=[UIColor clearColor];
        [secondView addSubview:secondButton];
    }
    
    //退出登录按钮
    UIButton *exitButton=[UIButton buttonWithType:UIButtonTypeCustom];
    exitButton.frame=CGRectMake(0, self.view.frame.size.height-250*screenWidth/320.0, self.view.frame.size.width, 40*screenWidth/320.0);
    [exitButton setTitle:@"退出登录" forState:UIControlStateNormal];
    [exitButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [exitButton addTarget:self action:@selector(exitBtn) forControlEvents:UIControlEventTouchUpInside];
    exitButton.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:exitButton];

}
-(void)firstBtn:(UIButton *)firstBut
{
    switch (firstBut.tag) {
        case 100:
        {
            changePWDViewController *cvc=[[changePWDViewController alloc] init];
            [self.navigationController pushViewController:cvc animated:YES];
           break;
        }
           
        case 101:
        {
            changePhoneNumViewController *cpvc=[[changePhoneNumViewController alloc] init];
            [self.navigationController pushViewController:cpvc animated:YES];
            break;
        }
        default:
            break;
    }
}
-(void)secondBtn:(UIButton *)secondBut
{
    User *user=[User currentUser];
    switch (secondBut.tag) {
        case 200:
        {
            TongZhiViewController *tvc=[[TongZhiViewController alloc] init];
            [self.navigationController pushViewController:tvc animated:YES];
            break;
        }
           
        case 201:
        {
            if([user.banBen isEqualToString:user.BenDiBanBen])
            {
                [self toastResult:@"当前是最新版本，不需要更新"];
                break;
            }
            else
            {
                UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"版本更新" message:@"存在最新的版本程序，确认是否更新" delegate:self cancelButtonTitle:@"暂不更新" otherButtonTitles:@"更新版本", nil];
                [alertView show];
                alertView.tag=3;
                //
                break;
            }

            break;
        }
    
        default:
            break;
    }
}
-(void)exitBtn
{
    UIAlertView *alert= [[UIAlertView alloc]initWithTitle:@"确认退出" message:@"确认是否退出系统！" delegate:self cancelButtonTitle:@"暂不退出" otherButtonTitles:@"退出",nil];
    alert.delegate=self;
    alert.tag=2;
    [alert show];
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    User *user=[User currentUser];

    if(alertView.tag==2)
    {
        if (!buttonIndex)
        {
            
        }
        else
        {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
    if(alertView.tag==3)
    {
        if (!buttonIndex)
        {
            
        }
        else
        {
             [[UIApplication sharedApplication] openURL:[NSURL URLWithString:user.URL]];
        }
    }
    

}
-(void)toastResult:(NSString *) toastMsg{
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:toastMsg
                          message:nil
                          delegate:self
                          cancelButtonTitle:@"确定"
                          otherButtonTitles:nil];
    [alert show];
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
