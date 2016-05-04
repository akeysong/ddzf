//
//  FanYongZCViewController.m
//  DDZF
//
//  Created by 王健超 on 15/12/29.
//  Copyright (c) 2015年 wjc. All rights reserved.
//

#import "FanYongZCViewController.h"
#import "Header.h"
#import "MyNavigationBar.h"
#import "User.h"
#import "PostAsynClass.h"
#import "MyMD5.h"
#import "MBProgressHUD+CZ.h"
#import "FanYongListViewController.h"
@interface FanYongZCViewController ()
{
    UITextField *_num;
    
    UITextField *_sect;
    
    UILabel *_labOne;
    UILabel *labManry;
}
@end

@implementation FanYongZCViewController

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
    mnb.userInteractionEnabled=YES;
    [mnb createMyNavigationBarWithBgImageName:nil andLeftBBIIamgeNames:[NSArray arrayWithObject:@"fanhui.png"] andRightBBIImages:nil andTitle:@"返佣" andClass:self andSEL:@selector(bacClick:)];
    [self.view addSubview:mnb];
    
    UIButton *jiluButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [jiluButton setTitle:@"返佣记录" forState:UIControlStateNormal];
    [jiluButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    jiluButton.titleLabel.textAlignment=NSTextAlignmentCenter;
    jiluButton.frame=CGRectMake(self.view.frame.size.width-100, 15, 100, 30);
    jiluButton.titleLabel.font=[UIFont systemFontOfSize:15];
    [jiluButton addTarget:self action:@selector(navButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [mnb addSubview:jiluButton];
    
    
    //状态栏颜色
    UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320*screenWidth/320, 20*screenWidth/320)];
    
    statusBarView.backgroundColor=[UIColor whiteColor];
    
    [self.view addSubview:statusBarView];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
}
-(void)navButtonClick
{
    FanYongListViewController *fvc=[[FanYongListViewController alloc] init];
    [self.navigationController pushViewController:fvc animated:YES];
}
-(void)bacClick:(UIButton*)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)makeUI
{
    NSArray *arr=@[@"转出金额",@"交易密码"];
    for(int i=0;i<2;i++)
    {
        UILabel *leftLab=[[UILabel alloc] initWithFrame:CGRectMake(20*screenWidth/320, (100+i*60)*screenWidth/320, 100*screenWidth/320, 50*screenWidth/320)];
        leftLab.text=arr[i];
        leftLab.font=[UIFont systemFontOfSize:15];
        leftLab.textColor=[UIColor lightGrayColor];
        [self.view addSubview:leftLab];
        
    }
    
    //纵向灰线
    for(int i=0;i<2;i++)
    {
        UIView *view=[[UIView alloc] initWithFrame:CGRectMake(95*screenWidth/320, (114+i*61)*screenWidth/320, 1*screenWidth/320, 20*screenWidth/320)];
        view.backgroundColor=[UIColor lightGrayColor];
        [self.view addSubview:view];
    }
    //横向灰色的线
    for(int i=0;i<2;i++)
    {
        UIView *view=[[UIView alloc] initWithFrame:CGRectMake(20*screenWidth/320, (140+i*60)*screenWidth/320, 280*screenWidth/320, 1*screenWidth/320)];
        view.backgroundColor=[UIColor lightGrayColor];
        [self.view addSubview:view];
    }
    //textfield
    for(int i=0;i<2;i++)
    {
        if (i==0) {
            _num=[[UITextField alloc] initWithFrame:CGRectMake(100*screenWidth/320, 100*screenWidth/320, 250*screenWidth/320, 50*screenWidth/320)];
            _num.delegate=self;
            _num.font=[UIFont systemFontOfSize:16];
            _num.placeholder=@"请输入转出金额";
            _num.keyboardType= UIKeyboardTypeDecimalPad;
            [_num setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
            
            [self.view addSubview:_num];
        }
        if (i==1) {
            _sect=[[UITextField alloc] initWithFrame:CGRectMake(100*screenWidth/320,160*screenWidth/320, 150*screenWidth/320, 50*screenWidth/320) ];
            _sect.delegate=self;
            _sect.font=[UIFont systemFontOfSize:16];
            _sect.placeholder=@"请输入交易密码";
            _sect.secureTextEntry=YES;
            [_sect setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
            _sect.autocapitalizationType=UITextAutocapitalizationTypeNone;
            [self.view addSubview:_sect];
        }
    }
    
    User *user=[User currentUser];
    
    //返佣
    NSMutableURLRequest *rever1 = [PostAsynClass postAsynWithURL:url1 andInterface:url13 andKeyArr:@[@"merId",@"acctType"]andValueArr:@[user.merid,@"RATE"]];
    //
    NSData *receive1 = [NSURLConnection sendSynchronousRequest:rever1 returningResponse:nil error:nil];
    
    NSStringEncoding enc1 = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    
    
    //NSString *string=[receive stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString  *str1 = [[NSString alloc] initWithData:receive1 encoding:enc1];
    
    NSData *ata1 = [NSData alloc];
    
    ata1 = [str1 dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:ata1 options:NSJSONReadingMutableLeaves error:nil];
    NSString *many1 =[dic1 objectForKey:@"acctBal"];
    NSString *many2 =[dic1 objectForKey:@"avlBal"];
    labManry=[[UILabel alloc] initWithFrame:CGRectMake(20*screenWidth/320, 208*screenWidth/320, 270*screenWidth/320, 20*screenWidth/320)];
    labManry.font=[UIFont systemFontOfSize:13];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"返佣账户余额%@元,可转出余额%@元",many1,many2]];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(6,many1.length)];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(13+many1.length,many2.length)];
    
    labManry.attributedText = str;
    [self.view addSubview:labManry];
    
    //确认按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(30*screenWidth/320, 240*screenWidth/320,screenWidth-60*screenWidth/320,40*screenWidth/320);
    [button setBackgroundColor:[UIColor colorWithRed:0.19 green:0.8 blue:0.0 alpha:1.0]];
    [button setTitle:@"确认转出" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(noBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    //须知
    UILabel *lab=[[UILabel alloc] initWithFrame:CGRectMake(20*screenWidth/320, 300*screenWidth/320, 50*screenWidth/320, 20*screenWidth/320)];
    lab.text=@"须知";
    lab.font=[UIFont boldSystemFontOfSize:13];
    lab.textColor=[UIColor blackColor];
    [self.view addSubview:lab];
    
    
    
    NSArray *titleArr=@[@"❶ 返回资金为贵方推荐商户刷卡的返利",@"❷ 你可将你的返佣资金转入到现金账户",@"❸ 转出资金可提现或购买APP中的相关产品"];
    for(int i=0;i<3;i++)
    {
        UILabel *lab=[[UILabel alloc] initWithFrame:CGRectMake(20*screenWidth/320, (330+i*30)*screenWidth/320, 250*screenWidth/320, 20*screenWidth/320)];
        lab.textColor=[UIColor lightGrayColor];
        lab.text=titleArr[i];
        lab.font=[UIFont systemFontOfSize:12];
        [self.view addSubview:lab];
    }
    
}
//确认按钮的点击事件
-(void)noBtn
{
    [_num resignFirstResponder];
    [_sect resignFirstResponder];
    
    if(_sect.text.length<=0)
    {
        [self toastResult:@"交易密码不能为空"];
    }
    if(_num.text.length<=0||[_num.text doubleValue]==0)
    {
        [self toastResult:@"返佣转出金额不能为0"];
    }
    else
    {
        [MBProgressHUD showMessage:@"请稍后..." toView:self.view];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //返佣转出
            User * user = [User currentUser];
            
            NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingGB_18030_2000);
            
            //自动添加小数点后两位
            NSString *text=[NSString stringWithFormat:@"%.2f",[_num.text doubleValue]];
            NSMutableURLRequest *rever = [PostAsynClass postAsynWithURL:url1 andInterface:url21 andKeyArr:@[@"merId",@"transAmt",@"transPwd",@"clientModel"]andValueArr:@[user.merid,text,[MyMD5 md5:_sect.text],[[UIDevice currentDevice] model]]];
            //
            NSData *receive = [NSURLConnection sendSynchronousRequest:rever returningResponse:nil error:nil];
            NSString  *str = [[NSString alloc] initWithData:receive encoding:enc];
            
            NSData *ata = [NSData alloc];
            
            ata = [str dataUsingEncoding:NSUTF8StringEncoding];
            
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:ata options:NSJSONReadingMutableLeaves error:nil];
            NSString *sre = [dic objectForKey:@"respDesc"];
            NSLog(@"&&&&&&&&&&&&&%@",sre);
            NSLog(@"---------------------------------%@",dic);
            
            
            if ([[dic objectForKey:@"respCode"] isEqualToString:@"008"])
            {
                
                UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"未登录或登录失效，请重新登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                [alertView show];
                alertView.tag=3;
            }
            if([[dic objectForKey:@"respCode"]isEqualToString:@"000"])
            {
                [self toastResult:sre];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadData" object:nil];
                [self.navigationController popViewControllerAnimated:YES];
            }
            else
            {
                [self toastResult:sre];
            }
            
        });
        
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
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //如果一个界面有多个提示框，通过tag值区分，就像textField一样
    
    //通过buttonIndex来确定点击的是提示框上的哪个按钮
    if (!buttonIndex) {
        
        
    } else {
        
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    }
}
//点击return 按钮 去掉
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_num resignFirstResponder];
    [_sect resignFirstResponder];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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
