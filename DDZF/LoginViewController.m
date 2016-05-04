//
//  LoginViewController.m
//  DDZF
//
//  Created by 王健超 on 15/11/30.
//  Copyright (c) 2015年 wjc. All rights reserved.
//
#import "NavTabViewController.h"
#import "LoginViewController.h"
#import "User.h"
#import "MyMD5.h"
#import "Header.h"
#import "PostAsynClass.h"
#import "MainViewController.h"
#import "forgetPasswordViewController.h"
#import "RegisterViewController.h"
#import "nextRegisterViewController.h"
#import "APService.h"
#import "ShiMingViewController.h"
#import "Reachability.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD+CZ.h"
#import <CoreLocation/CoreLocation.h>
#import "zhiFuViewController.h"
@interface LoginViewController ()<UITextFieldDelegate,UIAlertViewDelegate,CLLocationManagerDelegate>
{
    UIImageView *headImage;
    UITextField *userNameFiled;
    UITextField *passwordFiled;
    //复选框
    UIButton *chBtn;
    BOOL isClicked;
    BOOL isHide;
    
    UIAlertView *_alert;
    NSMutableArray *mutableArray;
    UIView *xialaView;
    BOOL isXiala;
    
    // 声明成员变量
    CLLocationManager *_manager;
    // 反编码，获取地名
    CLGeocoder *_coder;
    
    double latitude;
    double longitude;
    
    NSString *_datestr;
    NSDictionary *dictionary;
    
}
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden=YES;
    self.view.backgroundColor=[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0];
    mutableArray=[[NSMutableArray alloc] init];
    [self makeUI];
     [self setLocation];
    isXiala=NO;
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated
{
    passwordFiled.text = @"";
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"headImage"] length]==0)
    {
        headImage.image=[UIImage imageNamed:@"touxiang@2x.png"];
    }
    else
    {
        [headImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"headImage"]]]];
    }
}
- (void)setLocation
{
    
    if (![CLLocationManager locationServicesEnabled])
    {
        NSLog(@"定位服务当前可能尚未打开，请设置打开！");
        [self toastResult:@"定位服务当前可能尚未打开，请设置打开"];
        
        return;
    }
    if ([CLLocationManager locationServicesEnabled] )
    {
        // 1、实例化
        _manager = [[CLLocationManager alloc] init];
        // 2、设置精度类型
        _manager.desiredAccuracy = kCLLocationAccuracyBest;
        // 3、设置代理
        _manager.delegate = self;
        // 点击开始定位
        //        // 如果是iOS8以上的话，得添加上两句话
        //        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        //        {
        //            [_manager requestWhenInUseAuthorization];
        //            //[_manager requestAlwaysAuthorization];
        //        }
        // 4、开始进行定位
        
        
        [_manager startUpdatingLocation];
        
    }else {
        NSLog(@"GPS没有开启");
    }
}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    for (CLLocation *oneLocation in locations)
    {
        // 获取当前的经纬度
        // NSLog(@"获取经纬度为%f，%f",oneLocation.coordinate.longitude,oneLocation.coordinate.latitude);
        [self doLocation:oneLocation];
        [_manager stopUpdatingLocation];
    }
}
- (void)doLocation:(CLLocation *)oneLocation
{
    latitude = oneLocation.coordinate.latitude;  //纬度
    longitude = oneLocation.coordinate.longitude; // 经度
    NSString *location = [self getBaiduAddress:oneLocation];
    NSLog(@"输出定位为%@",location);
    // 使用Apple进行反编码
    [self getAppleAddress:oneLocation];
    
}
//
//#pragma mark- 地址反编码...
//// 百度的反编码
- (NSString *) getBaiduAddress:(CLLocation *)location
{
    User *user=[User currentUser];
    latitude = location.coordinate.latitude;  //纬度
    longitude = location.coordinate.longitude; // 经度
    NSString *urlstr = [NSString stringWithFormat:
                        @"http://api.map.baidu.com/geocoder?output=json&location=%f,%f&key=dc40f705157725fc98f1fee6a15b6e60",
                        latitude, longitude];
    
    NSURL *url = [NSURL URLWithString:urlstr];
    user.jing=[NSString stringWithFormat:@"%f",longitude];
    user.wei=[NSString stringWithFormat:@"%f",latitude];
    
    // 这里是同步请求
    NSString *str = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    return str;
}
#pragma mark- Apple 的反编码，异步请求
- (NSString *)getAppleAddress:(CLLocation *)location
{
    // User *user=[User currentUser];
    // CLGeocoder自带的反编码和地理编码
    _coder = [[CLGeocoder alloc] init];
    latitude = location.coordinate.latitude;  //纬度
    longitude = location.coordinate.longitude; // 经度
    // 这个函数是向APPle的服务器发送请求，然后取得相应的结果
    [_coder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error)
     {
         CLPlacemark *placemark = [placemarks objectAtIndex:0];
         NSString *city = placemark.locality;
         if(!city)
         {
             city = placemark.administrativeArea;
         }
         // user.city=city;
         NSLog(@"city = %@", city);
     }];
    return nil;
}

-(void)makeUI
{
    headImage=[[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-40*screenWidth/320.0, 80*screenWidth/320.0, 80*screenWidth/320.0, 80*screenWidth/320.0)];
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"headImage"] length]==0)
    {
        headImage.image=[UIImage imageNamed:@"touxiang@2x.png"];
    }
    else
    {
        [headImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"headImage"]]]];
        //headImage.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"headImage"]]];
    }
    headImage.layer.cornerRadius=40*screenWidth/320.0;
    headImage.clipsToBounds=YES;
    [self.view addSubview:headImage];
    NSLog(@"头像%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"headImage"]);
    //用户名
    userNameFiled=[[UITextField alloc] initWithFrame:CGRectMake(70*screenWidth/320.0, headImage.frame.origin.y+headImage.frame.size.height+40*screenWidth/320.0, 140*screenWidth/320.0, 35*screenWidth/320.0)];
    userNameFiled.placeholder=@"账号";
    userNameFiled.delegate=self;
    userNameFiled.font=[UIFont systemFontOfSize:16*screenWidth/320.0];
     userNameFiled.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"loginId"];
    userNameFiled.keyboardType=UIKeyboardTypeNumberPad;
    [self.view addSubview:userNameFiled];
    
    
    
    isHide=NO;
    passwordFiled=[[UITextField alloc] initWithFrame:CGRectMake(70*screenWidth/320.0, userNameFiled.frame.origin.y+userNameFiled.frame.size.height+20*screenWidth/320.0, 140*screenWidth/320.0, 35*screenWidth/320.0)];
    passwordFiled.placeholder=@"密码";
    passwordFiled.delegate=self;
    passwordFiled.font=[UIFont systemFontOfSize:16*screenWidth/320.0];
    passwordFiled.secureTextEntry=YES;
    [self.view addSubview:passwordFiled];
    
    NSArray *imageArray=@[@"zhanghao",@"mima"];
    NSArray *buttonImageArray=@[@"zhanghaojilu@2x.png",@"yincang@2x.png"];
    for(int i=0;i<2;i++)
    {
        UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(30*screenWidth/320.0, headImage.frame.origin.y+headImage.frame.size.height+43*screenWidth/320.0+i*50*screenWidth/320.0, 30*screenWidth/320.0, 30*screenWidth/320.0)];
        imageView.image=[UIImage imageNamed:imageArray[i]];
        [self.view addSubview:imageView];
        
        UIButton *imageButton=[UIButton buttonWithType:UIButtonTypeCustom];
        imageButton.frame=CGRectMake(self.view.frame.size.width-55*screenWidth/320.0, headImage.frame.origin.y+headImage.frame.size.height+55*screenWidth/320.0+i*45*screenWidth/320.0, 25*screenWidth/320.0, 25*screenWidth/320.0);
        [imageButton setImage:[UIImage imageNamed:buttonImageArray[i]] forState:UIControlStateNormal];
        imageButton.tag=100+i;
        [imageButton addTarget:self action:@selector(imageBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:imageButton];
        
        UIView *lineView=[[UIView alloc] initWithFrame:CGRectMake(30*screenWidth/320.0, imageView.frame.origin.y+imageView.frame.size.height+9*screenWidth/320.0, self.view.frame.size.width-60*screenWidth/320.0, 0.3)];
        lineView.backgroundColor=[UIColor grayColor];
        [self.view addSubview:lineView];
    }
    
    //复选框
    chBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    chBtn.frame=CGRectMake(25*screenWidth/320,300*screenWidth/320,20*screenWidth/320, 20*screenWidth/320);
    [ chBtn setBackgroundImage:[UIImage imageNamed:@"bujiluzhanghao@2x.png"] forState:UIControlStateNormal];
    [ chBtn addTarget:self action:@selector(chBton) forControlEvents:UIControlEventTouchUpInside];
    isClicked = NO;
    if (![[[NSUserDefaults standardUserDefaults]objectForKey:@"loginId"] isEqualToString:@""])
    {
        [ chBtn setBackgroundImage:[UIImage imageNamed:@"jiluzhanghao@2x.png"] forState:UIControlStateNormal];
        
       isClicked = YES;
    }
    [self.view addSubview:chBtn];

    UILabel *jizhuLabel=[[UILabel alloc] initWithFrame:CGRectMake(chBtn.frame.size.width+chBtn.frame.origin.x+2*screenWidth/320.0, chBtn.frame.origin.y, 80*screenWidth/320.0, 20*screenWidth/320.0)];
    jizhuLabel.text=@"记住账号";
    jizhuLabel.textAlignment=NSTextAlignmentLeft;
    jizhuLabel.font=[UIFont systemFontOfSize:13*screenWidth/320.0];
    jizhuLabel.textColor=[UIColor colorWithRed:0/255.0 green:58/255.0 blue:85/255.0 alpha:1.0];
    [self.view addSubview:jizhuLabel];
    
    //忘记密码
    UILabel *forgetLabel=[[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width-110*screenWidth/320.0, chBtn.frame.origin.y, 80*screenWidth/320.0, 20*screenWidth/320.0)];
    forgetLabel.text=@"忘记密码";
    forgetLabel.textAlignment=NSTextAlignmentRight;
    forgetLabel.userInteractionEnabled=YES;
    forgetLabel.font=[UIFont systemFontOfSize:13*screenWidth/320.0];
    forgetLabel.textColor=[UIColor colorWithRed:0/255.0 green:58/255.0 blue:85/255.0 alpha:1.0];
    [self.view addSubview:forgetLabel];
    
    UIButton *forgetButton=[UIButton buttonWithType:UIButtonTypeCustom];
    forgetButton.frame=CGRectMake(0,0, 80*screenWidth/320, 20*screenWidth/320);
    forgetButton.backgroundColor=[UIColor clearColor];
    [forgetButton addTarget:self action:@selector(forgetBtn) forControlEvents:UIControlEventTouchUpInside];
    [forgetLabel addSubview:forgetButton];
    
    
    
    UIImageView *backImage=[[UIImageView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-180*screenWidth/320.0, self.view.frame.size.width, 140*screenWidth/320.0)];
    backImage.image=[UIImage imageNamed:@"denglu1.png"];
    //[self.view addSubview:backImage];
    
    
    //登录
    UIButton *loginbtn=[UIButton buttonWithType:UIButtonTypeCustom];
    loginbtn.frame=CGRectMake((self.view.frame.size.width-150*screenWidth/320.0)/2,forgetLabel.frame.size.height+forgetLabel.frame.origin.y+15*screenWidth/320.0,150*screenWidth/320, 35*screenWidth/320);
    loginbtn.backgroundColor=[UIColor colorWithRed:0/255.0 green:58/255.0 blue:85/255.0 alpha:1.0];
    [loginbtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginbtn addTarget:self action:@selector(loginButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginbtn];
    
    //注册
    UIButton *registerbtn=[UIButton buttonWithType:UIButtonTypeCustom];
    registerbtn.frame=CGRectMake((self.view.frame.size.width-100*screenWidth/320.0)/2,self.view.frame.size.height-85*screenWidth/320.0, 100*screenWidth/320, 40*screenWidth/320);
    [registerbtn setTitleColor:[UIColor colorWithRed:0/255.0 green:58/255.0 blue:85/255.0 alpha:1.0] forState:UIControlStateNormal];
    [registerbtn setTitle:@"注册" forState:UIControlStateNormal];
    [registerbtn addTarget:self action:@selector(registe) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerbtn];
    
    UILabel *tellLabel=[[UILabel alloc] initWithFrame:CGRectMake(30*screenWidth/320.0, self.view.frame.size.height-35*screenWidth/320.0, self.view.frame.size.width-60*screenWidth/320.0, 20*screenWidth/320.0)];
    tellLabel.textColor=[UIColor grayColor];
    tellLabel.textAlignment=NSTextAlignmentCenter;
    tellLabel.text=@"在线客服：4000-383-656";
    tellLabel.font=[UIFont systemFontOfSize:16];
    [self.view addSubview:tellLabel];
    
    xialaView=[[UIView alloc] initWithFrame:CGRectMake(30*screenWidth/320.0, userNameFiled.frame.origin.y+userNameFiled.frame.size.height+6*screenWidth/320.0, self.view.frame.size.width-60*screenWidth/320.0, 100*screenWidth/320.0)];
    xialaView.hidden=YES;
    xialaView.backgroundColor=[UIColor yellowColor];
    [self.view addSubview:xialaView];
    
    

}
-(void)imageBtnClick:(UIButton *)imageButt
{
    if(imageButt.tag==100)
    {
//        if(isXiala==NO)
//        {
//            xialaView.hidden=NO;
//            isXiala=YES;
//        }
//        else
//        {
//            xialaView.hidden=YES;
//            isXiala=NO;
//        }
//        NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
//        NSString *path=[paths objectAtIndex:0];
//        NSLog(@"path = %@",path);
//        NSString *filename=[path stringByAppendingPathComponent:@"userNamelist.plist"];
//        mutableArray=[[NSMutableArray alloc] init];
//        NSArray* dic2 = [NSArray arrayWithContentsOfFile:filename];
//        for(NSDictionary *yyy in dic2)
//        {
//            [mutableArray addObject:[yyy objectForKey:@"username"]];
//        }
//        NSLog(@"dic is:%@",mutableArray);

    }
    if(imageButt.tag==101)
    {
        if(isHide==NO)
        {
            UIButton *btn=(UIButton *)[self.view viewWithTag:101];
            [btn setImage:[UIImage imageNamed:@"xianshi@2x.png"] forState:UIControlStateNormal];
            passwordFiled.secureTextEntry=NO;
            isHide=YES;
        }
        else
        {
            UIButton *btn=(UIButton *)[self.view viewWithTag:101];
            [btn setImage:[UIImage imageNamed:@"yincang@2x.png"] forState:UIControlStateNormal];
            passwordFiled.secureTextEntry=YES;
            isHide=NO;
        }
    }
}
#pragma mark  忘记密码
-(void)forgetBtn
{
    forgetPasswordViewController *fvc=[[forgetPasswordViewController alloc] init];
    [self.navigationController pushViewController:fvc animated:YES];
}
#pragma mark  登录
-(void)loginButton
{
    
    [userNameFiled resignFirstResponder];
    [passwordFiled resignFirstResponder];

   // NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    //校验手机号
    if (userNameFiled.text == nil||[@"" isEqual:userNameFiled.text]) {
        [self toastResult:@"请输入登陆手机号"];
        return;
    }
    if (passwordFiled.text == nil ||[@"" isEqual:passwordFiled.text]) {
        [self toastResult:@"请输入登录密码"];
        return;
    }
    if (passwordFiled.text.length<6) {
        [self toastResult:@"密码为6位或6位以上数字或字母组成"];
        return;
    }
    if(isClicked)
    {
        
        [[NSUserDefaults standardUserDefaults] setObject:userNameFiled.text forKey:@"loginId"];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"loginId"];
        
    }
    
    Reachability *r= [Reachability reachabilityForInternetConnection];
    if ([r currentReachabilityStatus] == NotReachable)
    {
                NSLog(@"没有网");
        [self toastResult:@"网络连接受限,请检查网络"];
        return;
    }
    else
    {
        [MBProgressHUD showMessage:@"登录中..." toView:self.view];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            User *user=[User currentUser];
            NSMutableURLRequest *rever = [PostAsynClass postAsynWithURL:url1 andInterface:url2 andKeyArr:@[@"agentId",@"loginId",@"loginPwd",@"clientModel"]andValueArr:@[can,userNameFiled.text,[MyMD5 md5:passwordFiled.text],[[UIDevice currentDevice] model]]];
            //
            [rever setTimeoutInterval:60];
            NSData *receive = [NSURLConnection sendSynchronousRequest:rever returningResponse:nil error:nil];
            
            NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
            
            NSString  *str = [[NSString alloc] initWithData:receive encoding:enc];
            
            NSData *ata = [NSData alloc];
            
            ata = [str dataUsingEncoding:NSUTF8StringEncoding];
            
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:ata options:NSJSONReadingMutableLeaves error:nil];
            
            NSLog(@"denglu%@",dic);
            
            if ([[dic objectForKey:@"respCode"] isEqualToString:@"000"])
            {
                
                //上次登录时间
                user.phoneText=userNameFiled.text;
                user.yuanText=passwordFiled.text;
                
                user.date=[dic objectForKey:@"lastLoginDate"];
                //faceImgUrl
                user.name=[dic objectForKey:@"merName"];
                user.merid=[dic objectForKey:@"merId"];
                user.sm=[dic objectForKey:@"isAuthentication"];
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setAlias) name:@"setAlias" object:nil];
                
                [APService setAlias:user.merid callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:nil];
                if ([[dic objectForKey:@"isAuthentication"] isEqualToString:@"S"])
                {
                    user.sm1=@"已绑定";
                }
                else
                {
                    
                    if ([[dic objectForKey:@"isAuthentication"] isEqualToString:@"I"])
                    {
                        user.sm1=@"审核中";
                    }
                    else
                    {
                        user.sm1=@"未绑定";
                    }
                }
                
                mutableArray=[[NSMutableArray alloc] init];
                NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
                NSString *path=[paths    objectAtIndex:0];
                NSString *filename=[path stringByAppendingPathComponent:@"userNamelist.plist"];
                //获取路径
                NSArray *array=[NSArray arrayWithContentsOfFile:filename];
                if(array==nil)
                {
                    NSFileManager* fm = [NSFileManager defaultManager];
                    [fm createFileAtPath:filename contents:nil attributes:nil];
                    
                    NSMutableArray *arra=[NSMutableArray array];
                    
                    NSDictionary *di=[NSDictionary dictionaryWithObjectsAndKeys:userNameFiled.text,@"username",passwordFiled.text,@"password", nil];
                    [arra addObject:di];
                    [arra writeToFile:filename atomically:YES];
                    NSLog(@"zuizhong %@",array);
                    
                }
                else
                {
                    
                    for(NSDictionary *ddd in array)
                    {
                        [mutableArray addObject:[ddd objectForKey:@"username"]];
                    }
                    if(![mutableArray containsObject:userNameFiled.text])
                    {
                        NSMutableArray *arra=[NSMutableArray array];
                        
                        NSDictionary *di=[NSDictionary dictionaryWithObjectsAndKeys:userNameFiled.text,@"username",passwordFiled.text,@"password", nil];
                        [arra addObject:di];
                        for(NSDictionary *ddd in array)
                            [arra addObject:ddd];
                        [arra writeToFile:filename atomically:YES];
                        NSLog(@"输222出%@",arra);
                    }
                    
                }
                //实名认证接口
                NSMutableURLRequest *rever2 = [PostAsynClass postAsynWithURL:url1 andInterface:url11 andKeyArr:@[@"merId",@"loginId"]andValueArr:@[user.merid,user.phoneText]];
                //
                NSData *receive2 = [NSURLConnection sendSynchronousRequest:rever2 returningResponse:nil error:nil];
                
                NSStringEncoding enc2 = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
                
                
                //NSString *string=[receive stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                
                NSString  *str2 = [[NSString alloc] initWithData:receive2 encoding:enc2];
                
                NSData *ata2 = [NSData alloc];
                
                ata2 = [str2 dataUsingEncoding:NSUTF8StringEncoding];
                
                NSDictionary *dic2= [NSJSONSerialization JSONObjectWithData:ata2 options:NSJSONReadingMutableLeaves error:nil];
                
                NSLog(@"###############$$$##%@",dic2);
                user.isFirstTrans=[dic2 objectForKey:@"isFirstTrans"];
                user.headImage=[dic2 objectForKeyedSubscript:@"faceImgUrl"];
                user.tgRecordSumLev2=[dic2 objectForKey:@"tgRecordSumLev2"];
                user.tgRecordSumLev1=[dic2 objectForKey:@"tgRecordSumLev1"];

                //登陆成功后跳转到mainViewController，我要把他跳到Navtababr
                NavTabViewController *mvc=[[NavTabViewController alloc]init];
                //MainViewController *mvc=[[MainViewController alloc] init];
                [self.navigationController pushViewController:mvc animated:YES];
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                // //没有实名弹出alert
                if(![[dic objectForKey:@"isAuthentication"]isEqualToString:@"S"])
                    
                {
                    if([[dic objectForKey:@"isAuthentication"]isEqualToString:@"I"])
                    {
                        if(![user.isFirstTrans isEqualToString:@"Y"])
                        {
                            _alert= [[UIAlertView alloc]initWithTitle:@"提示" message:@"请支付领取199元话费" delegate:self cancelButtonTitle:nil otherButtonTitles:@"支付",nil];
                            [_alert show];
                            _alert.tag=3;
                            return;
                            
                        }
                        else
                        {
                            return;
                        }
                        
                    }
                    else
                    {
                        _alert= [[UIAlertView alloc]initWithTitle:@"提示" message:@"您未绑定收款银行卡，是否立即绑定收款银行卡！" delegate:self cancelButtonTitle:@"暂不绑定收款银行卡" otherButtonTitles:@"我要绑定收款银行卡",nil];
                        [_alert show];
                        _alert.tag=2;
                    }
                    
                }
                else
                {
                    return;
                }
                
            }
            else
            {
                [self toastResult:[dic objectForKey:@"respDesc"]];
            }

        });
    }
   
}
- (void)tagsAliasCallback:(int)iResCode tags:(NSSet*)tags alias:(NSString*)alias
{
    NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags , alias);
}
-(void)setAlias
{
    User *user=[User currentUser];
    [[NSUserDefaults standardUserDefaults] setObject:user.merid forKey:@"Alias"];
}
#pragma mark  注册
-(void)registe
{
    RegisterViewController *rvc=[[RegisterViewController alloc] init];
    //nextRegisterViewController *rvc=[[nextRegisterViewController alloc] init];
    [self.navigationController pushViewController:rvc animated:YES];
}
-(void)chBton
{
    isClicked=!isClicked;
    
    if (isClicked) {
        [ chBtn setBackgroundImage:[UIImage imageNamed:@"jiluzhanghao@2x.png"] forState:UIControlStateNormal];
    }
    else
    {
        [ chBtn setBackgroundImage:[UIImage imageNamed:@"bujiluzhanghao@2x.png"] forState:UIControlStateNormal];
    }
    
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [userNameFiled resignFirstResponder];
    [passwordFiled resignFirstResponder];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //如果一个界面有多个提示框，通过tag值区分，就像textField一样
    User *user=[User currentUser];
    //通过buttonIndex来确定点击的是提示框上的哪个按钮
    if(_alert.tag==2)
    {
        if (!buttonIndex)
        {
            
        }
        else
        {
            ShiMingViewController *shi=[[ShiMingViewController alloc] init];
            [self.navigationController pushViewController:shi animated:YES];
        }
    }
    if(_alert.tag==3)
    {
        
        //获取当前时间
        NSDate *date=[[NSDate alloc]init];
        NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
        NSTimeZone *zone=[NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
        [formatter setTimeZone:zone];
        
        [formatter setDateFormat:@"yyyyMMddHHmmss"];
        
        NSArray *zonearr=[NSTimeZone knownTimeZoneNames];
        NSLog(@"%@",zonearr);
        
        _datestr=[formatter stringFromDate:date];
        NSLog(@"需要支付99.00元费用");
        NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingGB_18030_2000);
        
        //截取字符串后六位
        NSString *a=_datestr;
        NSString *b=[a substringFromIndex:8];
        NSMutableURLRequest *rever = [PostAsynClass postAsynWithURL:url1 andInterface:url14 andKeyArr:@[@"merId",@"loginId",@"credNo",@"transAmt",@"ordRemark",@"liqType",@"clientModel",@"cardType",@"gateId"]andValueArr:@[user.merid,user.phoneText,b,@"99.00",@"verifiedFee" ,@"T0",[[UIDevice currentDevice] model],@"X",@"eposyeepay"]];
        
        NSData *receive = [NSURLConnection sendSynchronousRequest:rever returningResponse:nil error:nil];
        NSString  *str = [[NSString alloc] initWithData:receive encoding:enc];
        
        NSData *ata = [NSData alloc];
        
        ata = [str dataUsingEncoding:NSUTF8StringEncoding];
        
        dictionary = [NSJSONSerialization JSONObjectWithData:ata options:NSJSONReadingMutableLeaves error:nil];
        user.dingDan=[dictionary objectForKey:@"transSeqId"];
        user.pingZheng=[dictionary objectForKey:@"credNo"];
        user.shouxu=[dictionary objectForKey:@"transFee"];
        
        NSString *sre = [dictionary objectForKey:@"respDesc"];
        NSLog(@"&&&&&&&&&&&&&%@",sre);
        NSLog(@"putongshoukuan%@",dictionary);
        
        if(![[dictionary objectForKey:@"respCode"]isEqualToString:@"000"])
        {
            [self toastResult:sre];
        }
        
        if([[dictionary objectForKey:@"respCode"]isEqualToString:@"000"])
        {
            NSMutableURLRequest *rever1 = [PostAsynClass postAsynWithURL:url1 andInterface:url16 andKeyArr:@[@"merId",@"transSeqId",@"credNo",@"paySrc"]andValueArr:@[user.merid,user.dingDan,user.pingZheng,@"nor"]];
            //
            NSData *receive1 = [NSURLConnection sendSynchronousRequest:rever1 returningResponse:nil error:nil];
            
            NSStringEncoding enc1 = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
            
            NSString  *str2 = [[NSString alloc] initWithData:receive1 encoding:enc1];
            
            NSData *ata1 = [NSData alloc];
            
            ata1 = [str2 dataUsingEncoding:NSUTF8StringEncoding];
            
            NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:ata1 options:NSJSONReadingMutableLeaves error:nil];
            
            NSLog(@"xiaofeiyemian%@",dic1);
            
            
            zhiFuViewController *zhifu=[[zhiFuViewController alloc] init];
            [self.navigationController pushViewController:zhifu animated:YES];
        }
        //}
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
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
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
