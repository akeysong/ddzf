//
//  RegisterViewController.m
//  DDZF
//
//  Created by 王健超 on 15/11/30.
//  Copyright (c) 2015年 wjc. All rights reserved.
//

#import "RegisterViewController.h"
#import "MyNavigationBar.h"
#import "User.h"
#import "Header.h"
#import "MyMD5.h"
#import "PostAsynClass.h"
#import "NSString+Extension.h"
#import "nextRegisterViewController.h"
#import "yonghuXYViewController.h"
@interface RegisterViewController ()<UITextFieldDelegate>
{
    UITextField *phoneNumFiled;
    UITextField *rescodeFiled;
    UIButton *rescodeButton;

}
@end

@implementation RegisterViewController

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
    for(int i=0;i<2;i++)
    {
        UIView *lineView=[[UIView alloc] initWithFrame:CGRectMake(20*screenWidth/320.0, 140*screenWidth/320.0+i*45*screenWidth/320.0, self.view.frame.size.width-40*screenWidth/320.0, 0.5*screenWidth/320.0)];
        lineView.backgroundColor=[UIColor colorWithRed:0.16 green:0.73 blue:0.98 alpha:1.0];
        [self.view addSubview:lineView];
    }
    //手机号
    phoneNumFiled=[[UITextField alloc] initWithFrame:CGRectMake(30*screenWidth/320.0, 100*screenWidth/320.0, 150*screenWidth/320.0, 40*screenWidth/320.0)];
    phoneNumFiled.placeholder=@"手机号";
    phoneNumFiled.delegate=self;
    phoneNumFiled.keyboardType=UIKeyboardTypeNumberPad;
    [self.view addSubview:phoneNumFiled];
    //验证码
    rescodeFiled=[[UITextField alloc] initWithFrame:CGRectMake(30*screenWidth/320.0, 145*screenWidth/320.0, 150*screenWidth/320.0, 40*screenWidth/320.0)];
    rescodeFiled.placeholder=@"验证码";
    rescodeFiled.delegate=self;
    rescodeFiled.keyboardType=UIKeyboardTypeNumberPad;
    [self.view addSubview:rescodeFiled];
    
    
    //验证码
    rescodeButton=[UIButton buttonWithType:UIButtonTypeCustom];
    rescodeButton.backgroundColor=[UIColor colorWithRed:0.16 green:0.73 blue:0.98 alpha:1.0];
    [rescodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    rescodeButton.frame=CGRectMake(self.view.frame.size.width-110*screenWidth/320.0, 145*screenWidth/320.0, 90*screenWidth/320.0, 35*screenWidth/320.0);
    [rescodeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rescodeButton addTarget:self action:@selector(rescodeBtn) forControlEvents:UIControlEventTouchUpInside];
    rescodeButton.layer.cornerRadius=5;
    rescodeButton.clipsToBounds=YES;
    rescodeButton.titleLabel.font=[UIFont systemFontOfSize:13*screenWidth/320.0];
    [self.view addSubview:rescodeButton];
    
    
    //用户协议
    UIButton *xieyiButton=[UIButton buttonWithType:UIButtonTypeCustom];
    xieyiButton.frame=CGRectMake(20*screenWidth/320.0, 190*screenWidth/320.0, 60*screenWidth/320.0, 20*screenWidth/320.0);
    [xieyiButton setTitle:@"用户协议" forState:UIControlStateNormal];
    [xieyiButton setTitleColor:[UIColor colorWithRed:0.16 green:0.73 blue:0.98 alpha:1.0] forState:UIControlStateNormal];
    xieyiButton.titleLabel.font=[UIFont systemFontOfSize:13*screenWidth/320.0];
    [xieyiButton addTarget:self action:@selector(xieyiBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:xieyiButton];

    //下一步
    UIButton *nextButton=[UIButton buttonWithType:UIButtonTypeCustom];
    nextButton.backgroundColor=[UIColor colorWithRed:0.16 green:0.73 blue:0.98 alpha:1.0];
    [nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    nextButton.frame=CGRectMake(30*screenWidth/320.0, 220*screenWidth/320.0, self.view.frame.size.width-60*screenWidth/320.0, 35*screenWidth/320.0);
    [nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextButton addTarget:self action:@selector(nextBtn) forControlEvents:UIControlEventTouchUpInside];
    nextButton.layer.cornerRadius=5;
    nextButton.clipsToBounds=YES;
    nextButton.titleLabel.font=[UIFont systemFontOfSize:13*screenWidth/320.0];
    [self.view addSubview:nextButton];
    
    //遇到困难
    UIButton *questButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [questButton setTitle:@"遇到困难?" forState:UIControlStateNormal];
    questButton.frame=CGRectMake(self.view.frame.size.width-80*screenWidth/320.0, 255*screenWidth/320.0, 60*screenWidth/320.0, 25*screenWidth/320.0);
    [questButton setTitleColor:[UIColor colorWithRed:0.16 green:0.73 blue:0.98 alpha:1.0] forState:UIControlStateNormal];
    [questButton addTarget:self action:@selector(questBtn) forControlEvents:UIControlEventTouchUpInside];
    questButton.titleLabel.font=[UIFont systemFontOfSize:13];
    [self.view addSubview:questButton];
    
    //背景图
    UIImageView *backgroundImage=[[UIImageView alloc] initWithFrame:CGRectMake(0, 280*screenWidth/320.0, self.view.frame.size.width, 150*screenWidth/320.0)];
    backgroundImage.image=[UIImage imageNamed:@"zhuce"];
    [self.view addSubview:backgroundImage];
    
    UILabel *telLabel=[[UILabel alloc] initWithFrame:CGRectMake(20*screenWidth/320.0, self.view.frame.size.height-40*screenWidth/320.0, self.view.frame.size.width-40*screenWidth/320.0, 20*screenWidth/320.0)];
    telLabel.text=@"客服电话：4000-383-656";
    telLabel.textAlignment=NSTextAlignmentCenter;
    telLabel.font=[UIFont systemFontOfSize:13*screenWidth/320.0];
    telLabel.textColor=[UIColor colorWithRed:0.16 green:0.73 blue:0.98 alpha:1.0];
    [self.view addSubview:telLabel];
}
-(void)bacClick:(UIButton*)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark  协议
-(void)xieyiBtn
{
    yonghuXYViewController *yvc=[[yonghuXYViewController alloc] init];
    [self.navigationController pushViewController:yvc animated:YES];
}
#pragma mark  遇到困难
-(void)questBtn
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel:4000-383-656"]];

}
#pragma mark  获取验证码
-(void)rescodeBtn
{
    BOOL phoneBool=[phoneNumFiled.text isPhoneNumber];
    
    if(!phoneBool)
    {
        [self toastResult:@"请输入正确的手机号"];
        return;
        
    }
    NSMutableString *paStr = [NSMutableString stringWithCapacity:0];
    //网络请求
    [paStr appendFormat:@"%@%@%@%@%@",can,phoneNumFiled.text,@"00",@"",@"1234567890"];
    
    NSLog(@"%@",paStr);
    NSMutableURLRequest *rever = [PostAsynClass postAsynWithURL:url1 andInterface:url4 andKeyArr:@[@"agentId",@"loginId",@"smsType",@"smsCon",@"chkValue"]andValueArr:@[can,phoneNumFiled.text,@"00",@"",[MyMD5 md5:paStr]]];
    
    NSData *receive = [NSURLConnection sendSynchronousRequest:rever returningResponse:nil error:nil];
    
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    
    NSString  *str = [[NSString alloc] initWithData:receive encoding:enc];
    
    NSData *ata = [NSData alloc];
    
    ata = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:ata options:NSJSONReadingMutableLeaves error:nil];
    
    NSLog(@"yanzhengma---------------------------------%@",dic);
    if(![[dic objectForKey:@"respCode"] isEqual:@"000"])
    {
        [self toastResult:[dic objectForKey:@"respDesc"]];
    }
    else
    {
        __block int timeout=30; //倒计时时间
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
        dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
        
        
        dispatch_source_set_event_handler(_timer, ^{
            
            if(timeout<=0){ //倒计时结束，关闭
                dispatch_source_cancel(_timer);
                dispatch_async(dispatch_get_main_queue(), ^{
                    //设置界面的按钮显示 根据自己需求设置
                    [rescodeButton setTitle:@"重新获取" forState:UIControlStateNormal];
                    rescodeButton.userInteractionEnabled = YES;
                    
                });
            }else{
                // int minutes = timeout / 60;
                int seconds = timeout % 91;
                NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
                dispatch_async(dispatch_get_main_queue(), ^{
                    //设置界面的按钮显示 根据自己需求设置
                    NSLog(@"____%@",strTime);
                    [rescodeButton setTitle:[NSString stringWithFormat:@"%@秒倒计时",strTime] forState:UIControlStateNormal];
                });
                timeout--;
                
            }
        });
        dispatch_resume(_timer);

    }
    

}
#pragma mark  下一步
-(void)nextBtn
{
    if(phoneNumFiled.text==NULL||[phoneNumFiled.text isEqual:@""])
    {
        [self toastResult:@"手机号不能为空"];
        return;
    }
    if(rescodeFiled.text==NULL||[rescodeFiled.text isEqual:@""])
    {
        [self toastResult:@"验证码不能为空"];
        return;
    }
    BOOL phoneBool=[phoneNumFiled.text isPhoneNumber];
    
    if(!phoneBool)
    {
        [self toastResult:@"请输入正确的手机号"];
        return;
        
    }

    //手机号网络请求
    NSMutableString *paStr = [NSMutableString stringWithCapacity:0];
    
    [paStr appendFormat:@"%@%@%@",can,phoneNumFiled.text,@"1234567890"];
    NSMutableURLRequest *rever = [PostAsynClass postAsynWithURL:url1 andInterface:url6 andKeyArr:@[@"agentId",@"loginId",@"chkValue"]andValueArr:@[can,phoneNumFiled.text,[MyMD5 md5:paStr]]];
    
    NSData *receive = [NSURLConnection sendSynchronousRequest:rever returningResponse:nil error:nil];
    
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    
    // NSString *string = [reqStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString  *str = [[NSString alloc] initWithData:receive encoding:enc];
    
    NSData *ata = [NSData alloc];
    
    ata = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:ata options:NSJSONReadingMutableLeaves error:nil];
    NSString *sre1 = [dic objectForKey:@"respDesc"];
    NSLog(@"&&&&&&&&&&&&&%@",sre1);
    
    
    if(![[dic objectForKey:@"respCode"]isEqualToString:@"000"])
    {
        [self toastResult:sre1];
    }
    
    if ([[dic objectForKey:@"isExist"] isEqualToString:@"Y"])
    {
        
        
        
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"改手机号已注册成功，请更换手机号" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
        return;
    }
    
    NSLog(@"shoujihao%@",dic);
    
    //验证码网络请求
    NSMutableURLRequest *rever1 = [PostAsynClass postAsynWithURL:url1 andInterface:url5 andKeyArr:@[@"agentId",@"loginId",@"smsCode"]andValueArr:@[can,phoneNumFiled.text,rescodeFiled.text]];
    
    NSData *receive1 = [NSURLConnection sendSynchronousRequest:rever1 returningResponse:nil error:nil];
    
    NSStringEncoding enc1 = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    
    // NSString *string = [reqStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString  *str1 = [[NSString alloc] initWithData:receive1 encoding:enc1];
    
    NSData *ata1 = [NSData alloc];
    
    ata1 = [str1 dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:ata1 options:NSJSONReadingMutableLeaves error:nil];
    NSString *sre = [dic1 objectForKey:@"respDesc"];
    NSLog(@"&&&&&&&&&&&&&%@",sre);
    NSLog(@"yanzhengma%@",dic1);
    
    if(![[dic1 objectForKey:@"respCode"]isEqualToString:@"000"])
    {
        [self toastResult:sre];
    }
    if ([[dic1 objectForKey:@"isTrue"]isEqualToString:@"N"]) {
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"验证码错误" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alter show];
    }
    if ([[dic1 objectForKey:@"isTrue"]isEqualToString:@"Y"]) {
        
        nextRegisterViewController *next=[[nextRegisterViewController alloc] init];
        next.text=phoneNumFiled.text;
        next.yan=rescodeFiled.text;
        [self.navigationController pushViewController:next animated:YES];
    }
    
    [phoneNumFiled resignFirstResponder];
    [rescodeFiled resignFirstResponder];

}
#pragma mark  键盘回缩
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [phoneNumFiled resignFirstResponder];
    [rescodeFiled resignFirstResponder];
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
