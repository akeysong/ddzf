//
//  nextTixianViewController.m
//  The territory of payment
//
//  Created by 铂金数据 on 15/4/1.
//  Copyright (c) 2015年 铂金数据. All rights reserved.
//

#import "nextTixianViewController.h"
#import "ShiMingViewController.h"

#import "MyNavigationBar.h"
#import "Header.h"
#import "PostAsynClass.h"
#import "User.h"
#import "MyMD5.h"
#import "yinHangkaViewController.h"
#import "TXXQViewController.h"
#import "tiXianJiluViewController.h"
#import "MBProgressHUD+CZ.h"
@interface nextTixianViewController ()<UIActionSheetDelegate>
{
    UITextField *numTextField;
    UITextField *jiaoyiPasswordTextField;

    NSString *_f;
    NSString *_t;
    NSString *_datestr;
    NSDictionary *_dic;
    
    NSDictionary *dic;
    
    NSString *resonString;
    UIImageView *bankImage;
    UILabel *nameLabel;
    UILabel *tLabel;
    UILabel *rateLabel;
    
    double latitude;
    double longitude;
    
    NSString *ch;
    NSString *ch1;
    
    NSMutableArray *arr1;
    NSMutableArray *arr2;
    NSMutableArray *arr3;
    NSMutableArray *arr4;
    NSMutableArray *arr5;

    NSMutableArray *arrD0;
    
    UIActionSheet *_al;
    //int num;liqCardId
    
    NSString *feetString;
    NSString *paywayString;
    

    
    
    UITextField *_money;
    
    UITextField *_secrect;
    
    
    UILabel *_lab;
    
    UILabel *_nameLab;
    
    UILabel *_kaLab;
    
    UILabel *_laa;
    NSString *sre;
    
     NSArray *_data;
    NSArray *bankArray;
}
@end

@implementation nextTixianViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    arrD0= [[NSMutableArray alloc] init];
    arr5= [[NSMutableArray alloc] init];
    arr4= [[NSMutableArray alloc] init];
    arr3= [[NSMutableArray alloc] init];
    arr2= [[NSMutableArray alloc] init];
    arr1= [[NSMutableArray alloc] init];
    _al.delegate=self;

    [self makeNav];
    [self bankSearch];
    [self makeUI];
    self.view.backgroundColor=[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated
{
    
    User *user=[User currentUser];
    if([user.sm isEqualToString:@"S"])
    {
        
        User *user=[User currentUser];
        
        _nameLab.text = user.kaname;
        
        
        NSString *str2 =user.jiekahao;
        NSLog(@"shchujiekahao%@",user.jiekahao);
        if(!([user.jiekahao isEqualToString:@""]||user.jiekahao==nil) )
        {
            NSMutableString *str1 = [NSMutableString stringWithCapacity:0];
            
            [str1 appendFormat:@"%@",str2];
            
            NSInteger i = str1.length;
            
            
            [str1 replaceCharactersInRange:NSMakeRange(i-10, 6) withString:@"******"];
            
            _kaLab.text = str1;
        }
        
    }

}
-(void)bankSearch
{
    User *user=[User currentUser];
    //结算卡查询接口
    
    NSStringEncoding enc3 = CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingGB_18030_2000);
    NSMutableURLRequest *rever3 = [PostAsynClass postAsynWithURL:url1 andInterface:url013 andKeyArr:@[@"merId"]andValueArr:@[user.merid]];
    //
    NSData *receive3 = [NSURLConnection sendSynchronousRequest:rever3 returningResponse:nil error:nil];
    
    //NSString *string=[receive stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString  *str3 = [[NSString alloc] initWithData:receive3 encoding:enc3];
    
    NSData *ata3 = [NSData alloc];
    
    ata3 = [str3 dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *bankDictionary = [NSJSONSerialization JSONObjectWithData:ata3 options:NSJSONReadingMutableLeaves error:nil];
    NSLog(@"shanghujiesuankachaxun%@",bankDictionary);
    bankArray=[bankDictionary objectForKey:@"ordersInfo"];
    for(NSDictionary *bankInforDic in bankArray)
    {
        [arr1 addObject:[bankInforDic objectForKey:@"openAcctName"]]; //户主
        [arr2 addObject:[bankInforDic objectForKey:@"openAcctId"]];  //卡号
        [arr3 addObject:[bankInforDic objectForKey:@"openBankName"]];   //银行名称
        [arr4 addObject:[bankInforDic objectForKey:@"openBankId"]];   //银行代号
        [arr5 addObject:[bankInforDic objectForKey:@"liqCardId"]];   //银行代号

    }
    NSLog(@"输出ayy%@",arr1);
    

}
-(void)makeNav
{
    //状态栏颜色
    UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320*screenWidth/320, 20*screenWidth/320)];
    
    statusBarView.backgroundColor=[UIColor whiteColor];
    
    [self.view addSubview:statusBarView];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];

    //导航
        [self.navigationController setNavigationBarHidden:YES];
    MyNavigationBar *mnb = [[MyNavigationBar alloc] init];
    mnb.frame = CGRectMake(0, 20*screenWidth/320, 320*screenWidth/320, 44*screenWidth/320);
    [mnb createMyNavigationBarWithBgImageName:nil andLeftBBIIamgeNames:[NSArray arrayWithObject:@"fanhui.png"] andRightBBIImages:nil andTitle:@"提现" andClass:self andSEL:@selector(bacClick:)];
    [self.view addSubview:mnb];
    
    UIButton *jiluButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [jiluButton setTitle:@"提现记录" forState:UIControlStateNormal];
    jiluButton.titleLabel.textAlignment=NSTextAlignmentCenter;
    jiluButton.frame=CGRectMake(self.view.frame.size.width-100, 15, 100, 30);
    jiluButton.titleLabel.font=[UIFont systemFontOfSize:16];
    [jiluButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [jiluButton addTarget:self action:@selector(navButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [mnb addSubview:jiluButton];
    
}
#pragma mark  提现记录
-(void)navButtonClick
{
    tiXianJiluViewController *tvc=[[tiXianJiluViewController alloc] init];
    [self.navigationController pushViewController:tvc animated:YES];
}
-(void)bacClick:(UIButton*)btn
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadData" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}
/*
-(void)makeUI
{
    
    User *user=[User currentUser];
    
//    if(![user.sm isEqualToString:@"S"])
//    {
//        
//        if([user.sm isEqualToString:@"I"])
//        {
//            UIAlertView *alert= [[UIAlertView alloc]initWithTitle:@"提示" message:@"您未绑定收款银行卡，暂不可以提现！" delegate:self cancelButtonTitle:@"回首页" otherButtonTitles:nil,nil];
//            [alert show];
//            return;
//        }
//
//        UIAlertView *alert= [[UIAlertView alloc]initWithTitle:@"提示" message:@"您未绑定收款银行卡，暂不可以提现！" delegate:self cancelButtonTitle:@"回首页" otherButtonTitles:@"我要绑定收款银行卡",nil];
//        [alert show];
//        //        _alert.tag=2;
//        
//        
    
//        UIButton *btnn=[UIButton buttonWithType:UIButtonTypeSystem];
//        btnn.frame=CGRectMake(100*screenWidth/320, 80*screenWidth/320, 230*screenWidth/320,40*screenWidth/320);
//        [btnn addTarget:self action:@selector(btn1:) forControlEvents:UIControlEventTouchUpInside];
//        [self.view addSubview:btnn];
//        
//        
//    }
    
    
   
    NSArray *arr=@[@"结算卡号",@"提现金额",@"交易密码"];
    for(int i=0;i<3;i++)
    {
        UILabel *lab=[[UILabel alloc] initWithFrame:CGRectMake(20*screenWidth/320, (94+i*50)*screenWidth/320, 100*screenWidth/320, 20*screenWidth/320)];
        lab.text=arr[i];
        lab.font=[UIFont systemFontOfSize:13];
        lab.textColor=[UIColor lightGrayColor];
        [self.view addSubview:lab];
        
    }
   
    //横条竖条
    for(int i=0;i<3;i++)
    {
        UIView *view=[[UIView alloc] initWithFrame:CGRectMake(10*screenWidth/320, (120+i*50)*screenWidth/320, self.view.frame.size.width-20, 1*screenWidth/320)];
        view.backgroundColor=[UIColor lightGrayColor];
        [self.view addSubview:view];
    }
   
    for(int i=0;i<3;i++)
    {
        UIView *view1=[[UIView alloc] initWithFrame:CGRectMake(90*screenWidth/320, (95+i*50)*screenWidth/320, 1*screenWidth/320, 15*screenWidth/320)];
        view1.backgroundColor=[UIColor lightGrayColor];
        [self.view addSubview:view1];
    }
    
    
    for(int i=0;i<2;i++)
    {
        if (i==0) {
            _money =[[UITextField alloc] initWithFrame:CGRectMake(100*screenWidth/320, 134*screenWidth/320, 200*screenWidth/320, 40*screenWidth/320)];
            _money.delegate=self;
            double num=[user.yu doubleValue]-[user.totAmtT1 doubleValue];
            if([user.sm isEqualToString:@"S"])
            {
                if(num<0)
                {
                     _money.placeholder=[NSString stringWithFormat:@"当前可提现的金额为0.00元"];
                }
                else
                {
                    _money.placeholder=[NSString stringWithFormat:@"当前可提现的金额为%@元",[NSString stringWithFormat:@"%.2f",num ]];
                    NSLog(@"###########%@,%@,%f",user.KYyue,user.totAmtT1,num);
                }
           
            }
            //只输入数字和小数点键盘
            _money.keyboardType=UIKeyboardTypeDecimalPad;
            _money.font=[UIFont systemFontOfSize:14];
            [_money setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
            NSLog(@"%@",user.KYyue);

            [self.view addSubview:_money];
        }
        if (i==1) {
            _secrect =[[UITextField alloc] initWithFrame:CGRectMake(100*screenWidth/320, 184*screenWidth/320, 200*screenWidth/320, 40*screenWidth/320)];
            _secrect.delegate=self;
            _secrect.secureTextEntry=YES;
            //_ok.keyboardType = UIKeyboardTypeNumberPad;
            [self.view addSubview: _secrect];
        }
    }
    if([user.sm isEqualToString:@"S"])
    {
    
        //结算卡查询接口
        
        NSStringEncoding enc3 = CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingGB_18030_2000);
        
        NSMutableURLRequest *rever3 = [PostAsynClass postAsynWithURL:url1 andInterface:url013 andKeyArr:@[@"merId"]andValueArr:@[user.merid]];
        //
        NSData *receive3 = [NSURLConnection sendSynchronousRequest:rever3 returningResponse:nil error:nil];
        
        NSString  *str3 = [[NSString alloc] initWithData:receive3 encoding:enc3];
        
        NSData *ata3 = [NSData alloc];
        
        ata3 = [str3 dataUsingEncoding:NSUTF8StringEncoding];
        
        NSDictionary *dic3 = [NSJSONSerialization JSONObjectWithData:ata3 options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"shanghujiesuankachaxun%@",dic3);
        _data=[dic3 objectForKey:@"ordersInfo"];
        int i=0;
        for(NSDictionary *dicc in _data)
        {
            if(i==0)
            {
                user.jiekahao=[dicc objectForKey:@"openAcctId"];
                NSString *str2 =user.jiekahao;
                
                NSMutableString *str1 = [NSMutableString stringWithCapacity:0];
                
                [str1 appendFormat:@"%@",str2];
                
                NSInteger i = str1.length;
                
                
                [str1 replaceCharactersInRange:NSMakeRange(i-10, 6) withString:@"******"];
                
                user.jiekahao=str1;
                
                user.kaname=[dicc objectForKey:@"openBankName"];
                user.kaBian=[dicc objectForKey:@"liqCardId"];
 
            }
            i++;
        }

    //银行卡名字
    _nameLab =[[UILabel alloc] initWithFrame:CGRectMake(100*screenWidth/320, 88*screenWidth/320, 80*screenWidth/320, 20*screenWidth/320)];
    _nameLab.font=[UIFont systemFontOfSize:12];
      _nameLab.textColor=[UIColor lightGrayColor];
    _nameLab.text=user.kaname;
    NSLog(@"cccccccccccccccccccccccccccccccccccc%@",_nameLab.text);
    [self.view addSubview:_nameLab];

    //银行卡
    _kaLab =[[UILabel alloc] initWithFrame:CGRectMake(100*screenWidth/320, 100*screenWidth/320, 200*screenWidth/320, 20*screenWidth/320)];
    _kaLab.font=[UIFont systemFontOfSize:12];
    _kaLab.textColor=[UIColor lightGrayColor];
    _kaLab.text=user.jiekahao;
    NSLog(@"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa%@",_kaLab.text);
   
    
    [self.view addSubview:_kaLab];
//
    }
//    
//    _laa=[[UILabel alloc] initWithFrame:CGRectMake(15*screenWidth/320, 230*screenWidth/320, 90*screenWidth/320, 20*screenWidth/320)];
//    _laa.font=[UIFont systemFontOfSize:12];
//    _laa.text=@"手续费五万以下";
//    
//    _lab.textAlignment=NSTextAlignmentRight;
//    NSLog(@"1111weweedededededededede%@",_laa.text);
//    _laa.textColor=[UIColor grayColor];
//    [self.view addSubview:_laa];
//    
//    
//    UILabel *la1=[[UILabel alloc] initWithFrame:CGRectMake(140*screenWidth/320, 230*screenWidth/320, 90*screenWidth/320, 20*screenWidth/320)];
//    la1.text=@"元/笔，五万以上";
//    
//    la1.font=[UIFont systemFontOfSize:12];
//    la1.textColor=[UIColor lightGrayColor];
//    [self.view addSubview:la1];
//    
//    UILabel *la2=[[UILabel alloc] initWithFrame:CGRectMake(270*screenWidth/320, 230*screenWidth/320, 50*screenWidth/320, 20*screenWidth/320)];
//    la2.text=@"元/笔";
//    
//    la2.font=[UIFont systemFontOfSize:12];
//    la2.textColor=[UIColor lightGrayColor];
//    [self.view addSubview:la2];

    
    
    NSMutableURLRequest *rever = [PostAsynClass postAsynWithURL:url1 andInterface:url11 andKeyArr:@[@"merId",@"loginId"]andValueArr:@[user.merid,user.phoneText]];
    //
    NSData *receive = [NSURLConnection sendSynchronousRequest:rever returningResponse:nil error:nil];
    
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    
    
    //NSString *string=[receive stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString  *str = [[NSString alloc] initWithData:receive encoding:enc];
    
    NSData *ata = [NSData alloc];
    
    ata = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *dic= [NSJSONSerialization JSONObjectWithData:ata options:NSJSONReadingMutableLeaves error:nil];
    NSLog(@"xiangxixinxi%@",dic);
    NSString *many1 =[dic objectForKey:@"feeRateLiq1"];
    NSString *many2 =[dic objectForKey:@"feeRateLiq2"];
    UILabel *labManry=[[UILabel alloc] initWithFrame:CGRectMake(10*screenWidth/320, 230*screenWidth/320, 300*screenWidth/320, 20*screenWidth/320)];
    labManry.font=[UIFont systemFontOfSize:12];
    NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"手续费五万以下%@元/笔,五万以上%@元/笔",many1,many2]];
    [str1 addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(7,many1.length)];
    [str1 addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(15+many1.length,many2.length)];
    
    labManry.attributedText = str1;
    labManry.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:labManry];
    

    UIButton *btn1=[UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame=CGRectMake(270*screenWidth/320, 80*screenWidth/320,50*screenWidth/320, 50*screenWidth/320);
    [btn1 setImage:[UIImage imageNamed:@"lh_sanj.png"] forState:UIControlStateNormal];
    //btn1.backgroundColor=[UIColor yellowColor];
    [btn1 addTarget:self action:@selector(bttn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
    
    
    UIButton *btn2=[UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame=CGRectMake(10*screenWidth/320, 80*screenWidth/320,200*screenWidth/320, 50*screenWidth/320);
    
    [btn2 addTarget:self action:@selector(bttn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];

    
    
    
    //确认提现按钮
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame=CGRectMake(20*screenWidth/320, 270*screenWidth/320, self.view.frame.size.width-40, 40*screenWidth/320);
    [btn setTitle:@"确认提现" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.backgroundColor=[UIColor colorWithRed:0/255.0 green:55/255.0 blue:113/255.0 alpha:1];
    [btn addTarget:self action:@selector(btton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];

}
 */
-(void)makeUI
{
     User *user=[User currentUser];

    //获取当前时间
    NSDate *date=[[NSDate alloc]init];
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    NSTimeZone *zone=[NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:zone];
    
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    
    _datestr=[formatter stringFromDate:date];
    
    NSLog(@"0000000----------           %@",_datestr);
    
    //活动的
    //如果为选择，费率直接默认为第一个
    
    if(user.kaBian.length<=0)
    {
        user.kaBian=arr5[0];
    }
    
   
    double num=[user.KYyue doubleValue]-[user.totAmtT1 doubleValue];
    if(num<=0)
    {
        user.KTyue=@"0.00";
    }
    else
    {
        user.KTyue=[NSString stringWithFormat:@"%.2f",num];
    }
    UILabel *yueLabel=[[UILabel alloc] initWithFrame:CGRectMake(10*screenWidth/320.0, 70*screenWidth/320.0, 250*screenWidth/320.0, 20*screenWidth/320.0)];
    NSMutableAttributedString *str=[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"账户余额%@元可提现金额%@元",user.yu,user.KTyue]];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.99 green:0.73 blue:0.0 alpha:1.0] range:NSMakeRange(4, str.length-10-user.KTyue.length)];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.99 green:0.73 blue:0.0 alpha:1.0] range:NSMakeRange(str.length-1-user.KTyue.length, user.KTyue.length+1)];
    yueLabel.attributedText=str;
    [self.view addSubview:yueLabel];
    
    UIView *firstView=[[UIView alloc] initWithFrame:CGRectMake(0, 95*screenWidth/320.0, self.view.frame.size.width, 130*screenWidth/320.0)];
    firstView.backgroundColor=[UIColor whiteColor];
    firstView.userInteractionEnabled=YES;
    [self.view addSubview:firstView];
    
    bankImage=[[UIImageView alloc] initWithFrame:CGRectMake(10*screenWidth/320.0, 5*screenWidth/320.0, 30*screenWidth/320.0, 30*screenWidth/320.0)];
    bankImage.backgroundColor=[UIColor blackColor];
    bankImage.layer.cornerRadius=15*screenWidth/320.0;
    bankImage.clipsToBounds=YES;
    if([arr4[0] isEqual:@"icbc"])  //工商
    {
        bankImage.image=[UIImage imageNamed:@"gongshangBank"];
    }
    else if ([arr4[0] isEqual:@"abc"])  //农业
    {
        bankImage.image=[UIImage imageNamed:@"nongyeBank"];
    }
    else if ([arr4[0] isEqual:@"ccb"])  //建设
    {
        bankImage.image=[UIImage imageNamed:@"jiansheBank"];
    }
    else if ([arr4[0] isEqual:@"bankcomm"])  //交通
    {
        bankImage.image=[UIImage imageNamed:@"jiaotongBank"];
    }
    else if ([arr4[0] isEqual:@"cmb"])  //招商
    {
        bankImage.image=[UIImage imageNamed:@"zhaoshangBank"];
    }
    else if ([arr4[0] isEqual:@"ecitic"])  //中信
    {
        bankImage.image=[UIImage imageNamed:@"zhongxinBank"];
    }
    else if ([arr4[0] isEqual:@"cebbank"])  //光大
    {
       bankImage.image=[UIImage imageNamed:@"guangdaBank"];
    }
    else if ([arr4[0] isEqual:@"bankofbj"])  //北京
    {
        bankImage.image=[UIImage imageNamed:@"beijingBank"];
    }
    else if ([arr4[0] isEqual:@"spdb"])  //北京
    {
        bankImage.image=[UIImage imageNamed:@"pufaBank"];
    }
    else if ([arr4[0] isEqual:@"cmbc"])  //北京
    {
        bankImage.image=[UIImage imageNamed:@"minshengBank"];
    }
    else
    {
        bankImage.image=[UIImage imageNamed:@""];
    }
    [firstView addSubview:bankImage];
    
    nameLabel=[[UILabel alloc] initWithFrame:CGRectMake(245*screenWidth/320.0, 5*screenWidth/320.0, 40*screenWidth/320.0, 30*screenWidth/320.0)];
    //nameLabel.text=[NSString stringWithFormat:@"%@",[arr1[0] stringByReplacingCharactersInRange:NSMakeRange(1, [arr1[0] length]-1) withString:@"**"]];
    nameLabel.text=arr1[0];
    nameLabel.textAlignment=NSTextAlignmentCenter;
    nameLabel.font=[UIFont systemFontOfSize:14];
    [firstView addSubview:nameLabel];
    
    tLabel=[[UILabel alloc] initWithFrame:CGRectMake(80*screenWidth/320.0, 5*screenWidth/320.0, 160*screenWidth/320.0, 30*screenWidth/320.0)];
    tLabel.text=arr2[0];
    NSString *strr=[tLabel.text substringWithRange:NSMakeRange(tLabel.text.length-4, 4)];
    tLabel.text=[NSString stringWithFormat:@"%@ | 尾号%@",arr3[0],strr];
    tLabel.textAlignment=NSTextAlignmentCenter;
    tLabel.font=[UIFont systemFontOfSize:14];
    [firstView addSubview:tLabel];
    
    UIImageView *xialaImage=[[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width-30*screenWidth/320.0, 15*screenWidth/320.0, 15*screenWidth/320.0, 10*screenWidth/320.0)];
    xialaImage.image=[UIImage imageNamed:@"xiala.png"];
    [firstView addSubview:xialaImage];
    
   //选择通道
    UIButton *actionButton=[UIButton buttonWithType:UIButtonTypeCustom];
    actionButton.frame=CGRectMake(0, 0, firstView.frame.size.width, 40*screenWidth/320.0);
    [actionButton addTarget:self action:@selector(btnSelect) forControlEvents:UIControlEventTouchUpInside];
    actionButton.backgroundColor=[UIColor clearColor];
    [firstView addSubview:actionButton];
    

    UIView *lineView=[[UIView alloc] initWithFrame:CGRectMake(0, 40*screenWidth/320.0, firstView.frame.size.width, 0.3*screenWidth/320.0)];
    lineView.backgroundColor=[UIColor grayColor];
    [firstView addSubview:lineView];
    
    UILabel *jineLanel=[[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-30*screenWidth/320.0, 41*screenWidth/320.0, 60*screenWidth/320.0, 20*screenWidth/320.0)];
    jineLanel.textAlignment=NSTextAlignmentCenter;
    jineLanel.text=@"金额";
    jineLanel.font=[UIFont systemFontOfSize:15];
    [firstView addSubview:jineLanel];
    
    numTextField=[[UITextField alloc] initWithFrame:CGRectMake(100*screenWidth/320.0, 65*screenWidth/320.0, self.view.frame.size.width-200*screenWidth/320.0, 60*screenWidth/320.0)];
    numTextField.placeholder=@"请输入充值金额";
    numTextField.font=[UIFont systemFontOfSize:16*screenWidth/320.0];
    numTextField.textAlignment=NSTextAlignmentCenter;
    numTextField.keyboardType=UIKeyboardTypeDecimalPad;
    numTextField.textColor=[UIColor colorWithRed:0.99 green:0.73 blue:0.0 alpha:1.0];
    numTextField.delegate=self;
    [firstView addSubview:numTextField];
    
    
    UIView *secondView=[[UIView alloc] initWithFrame:CGRectMake(0, 230*screenWidth/320.0, self.view.frame.size.width, 40*screenWidth/320.0)];
    secondView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:secondView];
    
    jiaoyiPasswordTextField=[[UITextField alloc] initWithFrame:CGRectMake(40*screenWidth/320.0, 5*screenWidth/320.0, self.view.frame.size.width-80*screenWidth/320.0, 30*screenWidth/320.0)];
    jiaoyiPasswordTextField.keyboardType=UIKeyboardTypeNumberPad;
    jiaoyiPasswordTextField.secureTextEntry=YES;
    jiaoyiPasswordTextField.delegate=self;
    jiaoyiPasswordTextField.placeholder=@"交易密码";
    jiaoyiPasswordTextField.textAlignment=NSTextAlignmentCenter;
    [secondView addSubview:jiaoyiPasswordTextField];
    
    
    //确认按钮
    UIButton *okButton=[UIButton buttonWithType:UIButtonTypeCustom];
    okButton.frame=CGRectMake(30*screenWidth/320.0, secondView.frame.origin.y+secondView.frame.size.height+30*screenWidth/320.0, self.view.frame.size.width-60*screenWidth/320.0, 35*screenWidth/320.0);
    [okButton setTitle:@"确定" forState:UIControlStateNormal];
    [okButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    okButton.layer.cornerRadius=10*screenWidth/320.0;
    okButton.clipsToBounds=YES;
    [okButton addTarget:self action:@selector(okBtn) forControlEvents:UIControlEventTouchUpInside];
    okButton.backgroundColor=[UIColor colorWithRed:0.19 green:0.8 blue:0.0 alpha:1.0];
    [self.view addSubview:okButton];

}
#pragma mark  选择通道
-(void)btnSelect
{
    _al = [[UIActionSheet alloc]initWithTitle:@"请选择提现银行卡" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles: nil];
    for(int i=0;i<arr1.count;i++)
    {
        NSString *string=[NSString stringWithFormat:@"%@",arr2[i]];
        
        [arrD0 addObject:[NSString stringWithFormat:@"%@|尾号%@",arr3[i],[string substringWithRange:NSMakeRange(string.length-4, 4)]]];
        NSLog(@"输出尾号为%@",[string substringWithRange:NSMakeRange(string.length-4, 4)]);
    }
    for(int i=0;i<arr1.count;i++)
    {
        [_al addButtonWithTitle:arrD0[i]];
    }
    [_al showInView:self.view];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex

{
    //
    User *user=[User currentUser];
    NSLog(@"shuchuxians %ld",(long)buttonIndex);
    if(buttonIndex==0)
    {
        return;
    }
    else
    {
        nameLabel.text=arr1[buttonIndex-1];
        rateLabel.text=arr2[buttonIndex-1];
        paywayString=arr3[buttonIndex-1];
        tLabel.text=arrD0[buttonIndex-1];
        user.kaBian=arr5[buttonIndex-1];
        if([arr4[buttonIndex-1] isEqual:@"icbc"])  //工商
        {
            bankImage.image=[UIImage imageNamed:@"gongshangBank"];
        }
        else if ([arr4[buttonIndex-1] isEqual:@"abc"])  //农业
        {
            bankImage.image=[UIImage imageNamed:@"nongyeBank"];
        }
        else if ([arr4[buttonIndex-1] isEqual:@"ccb"])  //建设
        {
            bankImage.image=[UIImage imageNamed:@"jiansheBank"];
        }
        else if ([arr4[buttonIndex-1] isEqual:@"bankcomm"])  //交通
        {
            bankImage.image=[UIImage imageNamed:@"jiaotongBank"];
        }
        else if ([arr4[buttonIndex-1] isEqual:@"cmb"])  //招商
        {
            bankImage.image=[UIImage imageNamed:@"zhaoshangBank"];
        }
        else if ([arr4[buttonIndex-1] isEqual:@"ecitic"])  //中信
        {
            bankImage.image=[UIImage imageNamed:@"zhongxinBank"];
        }
        else if ([arr4[buttonIndex-1] isEqual:@"cebbank"])  //光大
        {
            bankImage.image=[UIImage imageNamed:@"guangdaBank"];
        }
        else if ([arr4[0] isEqual:@"spdb"])  //浦发
        {
            bankImage.image=[UIImage imageNamed:@"pufaBank"];
        }
        else if ([arr4[0] isEqual:@"cmbc"])  //民生
        {
            bankImage.image=[UIImage imageNamed:@"minshengBank"];
        }
        else if ([arr4[buttonIndex-1] isEqual:@"bankofbj"])  //北京
        {
            bankImage.image=[UIImage imageNamed:@"beijingBank"];
        }
        else
        {
            bankImage.image=[UIImage imageNamed:@""];
        }

    }
}

#pragma mark  确定按钮
-(void)okBtn
{
    [numTextField resignFirstResponder];
    [jiaoyiPasswordTextField resignFirstResponder];
    
    User *user=[User currentUser];
    //判断大小小于4
    if ([numTextField.text doubleValue]<=0.00)
    {
        
        [self toastResult:@"提现金额不能为0"];
        return;
    }
    else
    {
        [MBProgressHUD showMessage:@"loading..." toView:self.view];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //提现接口
            NSStringEncoding enc1 = CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingGB_18030_2000);
            
            //自动添加小数点后两位
            NSString *text1=[NSString stringWithFormat:@"%.2f",[numTextField.text doubleValue]];
            NSMutableURLRequest *rever1 = [PostAsynClass postAsynWithURL:url1 andInterface:url17 andKeyArr:@[@"merId",@"liqCardId",@"liqAmt",@"transPwd",@"clientModel"]andValueArr:@[user.merid,user.kaBian,text1,[MyMD5 md5:jiaoyiPasswordTextField.text],[[UIDevice currentDevice] model]]];
            //
            NSData *receive1 = [NSURLConnection sendSynchronousRequest:rever1 returningResponse:nil error:nil];
            
            NSString  *str1 = [[NSString alloc] initWithData:receive1 encoding:enc1];
            
            NSData *ata1 = [NSData alloc];
            
            ata1 = [str1 dataUsingEncoding:NSUTF8StringEncoding];
            
            NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:ata1 options:NSJSONReadingMutableLeaves error:nil];
            
            sre= [dic1 objectForKey:@"respDesc"];
            NSLog(@"tixian%@",dic1);
            
            if ([[dic1 objectForKey:@"respCode"] isEqualToString:@"000"]) {
                UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提现成功" message:@"你的提现申请已经成功，请注意银行资金账户变动" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil];
                [alter show];
                alter.tag=3;
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadData" object:nil];
                return;
            }
            if (![[dic1 objectForKey:@"respDesc"] isEqual:@"000"] ) {
                
//                UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:sre delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
//                [alter show];
                [self toastResult:sre];
                return;
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
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}
#pragma mark - 登陆失败之后显示的警示框
- (void)showFailAlertView
{
    UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"登录失败" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertView show];
    
}
#pragma mark -触摸隐藏键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [numTextField resignFirstResponder];
    [jiaoyiPasswordTextField resignFirstResponder];
    [_money  resignFirstResponder];
    [_secrect resignFirstResponder];
    
}

//点击return 按钮 去掉
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}



//提示框的代理方法，可以监控到点击了提示框上哪个按钮
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //如果一个界面有多个提示框，通过tag值区分，就像textField一样
    
    //通过buttonIndex来确定点击的是提示框上的哪个按钮
        if (!buttonIndex) {
            UIViewController *tempVC = self.navigationController.viewControllers[1];
            //self.navigationController.viewControllers可以找到导航控制器中的所有VC，是一个数组
            //然后通过数组的下表确定我们想去的VC
            [self.navigationController popToViewController:tempVC animated:YES];
            }
        else
        {
        ShiMingViewController *svc=[[ShiMingViewController alloc] init];
        [self.navigationController pushViewController:svc animated:YES];
    }
    
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
