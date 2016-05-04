//
//  nextRegisterViewController.m
//  DDZF
//
//  Created by 王健超 on 15/12/1.
//  Copyright (c) 2015年 wjc. All rights reserved.
//

#import "nextRegisterViewController.h"
#import "MyNavigationBar.h"
#import "User.h"
#import "Header.h"
#import "PostAsynClass.h"
#import "yonghuXYViewController.h"
#import "MyMD5.h"
@interface nextRegisterViewController ()<UITextFieldDelegate>
{
    UITextField *userNameFiled;
    UITextField *passwordFiled;
    UITextField *jiaoyimimaFiled;
    UITextField *tuijianmaFiled;
}


@end

@implementation nextRegisterViewController

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
    MyNavigationBar *mnb = [[MyNavigationBar alloc] init];
    mnb.frame = CGRectMake(0, 20*screenWidth/320, 320*screenWidth/320, 44*screenWidth/320);
    [mnb createMyNavigationBarWithBgImageName:nil andLeftBBIIamgeNames:[NSArray arrayWithObject:@"fanhui.png"] andRightBBIImages:nil andTitle:@"注册" andClass:self andSEL:@selector(bacClick:)];
    [self.view addSubview:mnb];
    
    //状态栏颜色
    UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320*screenWidth/320, 20*screenWidth/320)];
    
    statusBarView.backgroundColor=[UIColor whiteColor];
    
    [self.view addSubview:statusBarView];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
}
-(void)makeUI
{
    NSArray *titleArray=@[@"用户姓名",@"登录密码",@"交易密码",@"推 荐 码"];
    for(int i=0;i<titleArray.count;i++)
    {
        UIView *lineView=[[UIView alloc] initWithFrame:CGRectMake(20*screenWidth/320.0, 120*screenWidth/320.0+i*50*screenWidth/320.0, self.view.frame.size.width-40*screenWidth/320.0, 0.5*screenWidth/320.0)];
        lineView.backgroundColor=[UIColor colorWithRed:0.16 green:0.73 blue:0.98 alpha:1.0];
        [self.view addSubview:lineView];
    }
    //用户姓名
    userNameFiled=[[UITextField alloc] initWithFrame:CGRectMake(20*screenWidth/320.0, 75*screenWidth/320.0, 150*screenWidth/320.0, 40*screenWidth/320.0)];
    userNameFiled.delegate=self;
    userNameFiled.font=[UIFont systemFontOfSize:14*screenWidth/320.0];
    userNameFiled.placeholder=@"用户姓名";
    [self.view addSubview:userNameFiled];
    
    //登录密码
    passwordFiled=[[UITextField alloc] initWithFrame:CGRectMake(20*screenWidth/320.0, 125*screenWidth/320.0, 150*screenWidth/320.0, 40*screenWidth/320.0)];
    passwordFiled.delegate=self;
    passwordFiled.secureTextEntry=YES;
    passwordFiled.font=[UIFont systemFontOfSize:14*screenWidth/320.0];
    passwordFiled.placeholder=@"登录密码";
    [self.view addSubview:passwordFiled];
    
    // 交易密码
    jiaoyimimaFiled=[[UITextField alloc] initWithFrame:CGRectMake(20*screenWidth/320.0, 175*screenWidth/320.0, 150*screenWidth/320.0, 40*screenWidth/320.0)];
    jiaoyimimaFiled.delegate=self;
    jiaoyimimaFiled.secureTextEntry=YES;
    jiaoyimimaFiled.font=[UIFont systemFontOfSize:14*screenWidth/320.0];
    jiaoyimimaFiled.keyboardType=UIKeyboardTypeNumberPad;
    jiaoyimimaFiled.placeholder=@"交易密码";
    [self.view addSubview:jiaoyimimaFiled];
    
    //推 荐 码
    tuijianmaFiled=[[UITextField alloc] initWithFrame:CGRectMake(20*screenWidth/320.0, 225*screenWidth/320.0, 150*screenWidth/320.0, 40*screenWidth/320.0)];
    tuijianmaFiled.delegate=self;
    tuijianmaFiled.font=[UIFont systemFontOfSize:14*screenWidth/320.0];
    tuijianmaFiled.placeholder=@"推 荐 码";
    [self.view addSubview:tuijianmaFiled];
    
        
    
    UILabel *labelTiShi=[[UILabel alloc] initWithFrame:CGRectMake(20*screenWidth/320.0, 300*screenWidth/320.0, 200*screenWidth/320.0, 20*screenWidth/320.0)];
    labelTiShi.text=@"登录密码由6位或6位以上字母或数字数字组成";
    labelTiShi.textAlignment=NSTextAlignmentLeft;
    labelTiShi.font=[UIFont systemFontOfSize:13];
    [self.view addSubview:labelTiShi];
    //下一步按钮
    UIButton *nextButton=[UIButton buttonWithType:UIButtonTypeCustom];
    nextButton.frame=CGRectMake(30*screenWidth/320.0, 320*screenWidth/320.0,self.view.frame.size.width- 60*screenWidth/320.0, 30*screenWidth/320.0);
    [nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    [nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    nextButton.backgroundColor=[UIColor colorWithRed:0.16 green:0.73 blue:0.98 alpha:1.0];
    [nextButton addTarget:self action:@selector(nextBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextButton];
    
//    //遇到困难按钮
//    UIButton *questionButton=[UIButton buttonWithType:UIButtonTypeCustom];
//    questionButton.frame=CGRectMake(self.view.frame.size.width- 90*screenWidth/320.0, 350*screenWidth/320.0,60*screenWidth/320.0, 20*screenWidth/320.0);
//    [questionButton setTitle:@"遇到困难?" forState:UIControlStateNormal];
//    [questionButton setTitleColor:[UIColor colorWithRed:0.16 green:0.73 blue:0.98 alpha:1.0] forState:UIControlStateNormal];
//    questionButton.titleLabel.font=[UIFont systemFontOfSize:13*screenWidth/320.0];
//    [questionButton addTarget:self action:@selector(questionBtn) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:questionButton];
    
    //背景图
    UIImageView *backgroundImage=[[UIImageView alloc] initWithFrame:CGRectMake(0, 380*screenWidth/320.0, self.view.frame.size.width, 150*screenWidth/320.0)];
    backgroundImage.image=[UIImage imageNamed:@"zhuce2"];
    [self.view addSubview:backgroundImage];
    
    UILabel *telLabel=[[UILabel alloc] initWithFrame:CGRectMake(20*screenWidth/320.0, self.view.frame.size.height-30*screenWidth/320.0, self.view.frame.size.width-40*screenWidth/320.0, 20*screenWidth/320.0)];
    telLabel.text=@"客服电话：4000-383-656";
    telLabel.font=[UIFont systemFontOfSize:14];
    telLabel.textColor=[UIColor colorWithRed:0.16 green:0.73 blue:0.98 alpha:1.0];
    telLabel.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:telLabel];
}
-(void)bacClick:(UIButton*)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}
//回缩键盘
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [userNameFiled resignFirstResponder];
    [passwordFiled resignFirstResponder];
    [jiaoyimimaFiled resignFirstResponder];
    [tuijianmaFiled resignFirstResponder];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [userNameFiled resignFirstResponder];
    [passwordFiled resignFirstResponder];
    [jiaoyimimaFiled resignFirstResponder];
    [tuijianmaFiled resignFirstResponder];
    return YES;
}
//#pragma mark  遇到困难
//-(void)questionBtn
//{
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel:4000-383-656"]];
//}
#pragma mark  下一步
-(void)nextBtn
{
    if(userNameFiled.text.length<=0)
    {
        [self toastResult:@"请输入用户名"];
        return;
    }
    if(passwordFiled.text.length==0)
    {
        [self toastResult:@"请输入登录密码"];
        return;
    }
    if(passwordFiled.text.length<6)
    {
        [self toastResult:@"登录密码为6位数字组成,请重新输入"];
        return;
    }
    if(jiaoyimimaFiled.text.length<=0)
    {
        [self toastResult:@"请输入交易密码"];
        return;
    }
    if(jiaoyimimaFiled.text.length!=6)
    {
        [self toastResult:@"交易密码为6位数字组成,请重新输入"];
        return;
    }
    if([passwordFiled.text isEqual:jiaoyimimaFiled.text])
    {
        [self toastResult:@"交易密码和登录密码不能一致,请重新输入"];
        return;
    }
    if(tuijianmaFiled.text.length<=0)
    {
        [self toastResult:@"推荐码不能为空"];
        return;
    }

    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingGB_18030_2000);
    
    NSString *str1 = [userNameFiled.text stringByAddingPercentEscapesUsingEncoding:enc];
    NSMutableURLRequest *rever = [PostAsynClass postAsynWithURL:url1 andInterface:url3 andKeyArr:@[@"agentId",@"loginId",@"merName",@"certId",@"smsCode",@"chnlId",@"loginPwd",@"transPwd"]andValueArr:@[can,self.text,str1,@" ",self.yan,tuijianmaFiled.text,[MyMD5 md5:passwordFiled.text],[MyMD5 md5:jiaoyimimaFiled.text]]];
    
    NSData *receive = [NSURLConnection sendSynchronousRequest:rever returningResponse:nil error:nil];
    
    NSString  *str = [[NSString alloc] initWithData:receive encoding:enc];
    //    NSString *str1 = [str stringByAddingPercentEscapesUsingEncoding:enc];
    
    NSData *ata = [NSData alloc];
    
    ata = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:ata options:NSJSONReadingMutableLeaves error:nil];
    
    NSLog(@"zhuce%@",dic);
    NSString *sre = [dic objectForKey:@"respDesc"];
    NSLog(@"&&&&&&&&&&&&&%@",sre);
    NSLog(@"zhuce%@",dic);
    
    if(![[dic objectForKey:@"respCode"]isEqualToString:@"000"])
    {
        [self toastResult:sre];
    }
    
    if ([[dic objectForKey:@"respCode"]isEqualToString:@"000"]) {
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"注册成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        
        [alter show];
        self.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"loginId"];
        [self.navigationController popToRootViewControllerAnimated:YES];
        User *user=[User currentUser];
        user.yuanText=passwordFiled.text;
        user.yanText=jiaoyimimaFiled.text;
        
    }

}

//用户未输入任何信息提示
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
