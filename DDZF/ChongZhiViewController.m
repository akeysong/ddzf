//
//  ChongZhiViewController.m
//  DDZF
//
//  Created by 王健超 on 15/12/5.
//  Copyright (c) 2015年 wjc. All rights reserved.
//

#import "ChongZhiViewController.h"
#import "User.h"
#import "MyNavigationBar.h"
#import "PostAsynClass.h"
#import "Header.h"
#import "CardIO.h"
#import "CardIOPaymentViewControllerDelegate.h"
#import <CoreLocation/CoreLocation.h>
#import "MBProgressHUD+CZ.h"
#import "zhiFuViewController.h"
#import "nextErweiViewController.h"
#import "duanXinViewController.h"
#import "nextKaHaoViewController.h"
#import "shouKuanjiViewController.h"
#import "MBProgressHUD+CZ.h"
@interface ChongZhiViewController ()<UITextFieldDelegate,CLLocationManagerDelegate,UIAlertViewDelegate,UIActionSheetDelegate>
{
    UITextField *numTextField;
    NSString *_f;
     NSString *_t;
    NSString *_datestr;
    NSDictionary *_dic;
    
    NSDictionary *dic;
    
    NSString *resonString;
    
    // 声明成员变量
    CLLocationManager *_manager;
    // 反编码，获取地名
    CLGeocoder *_coder;
    
    
    UILabel *nameLabel;
    UILabel *tLabel;
    UILabel *rateLabel;
    
    double latitude;
    double longitude;
    
    NSString *ch;
    NSString *ch1;
    
    //显示卡号
    UILabel *kanumLab;
    
    
    UILabel *TDlabel;
    
    
    NSMutableArray *arr1;
    NSMutableArray *arr2;
    NSMutableArray *arr3;
    NSMutableArray *arr4;
    NSMutableArray *arrD0;

    UIActionSheet *_al;
    int num;
    
    NSString *feetString;
    NSString *paywayString;
    UIAlertView *_alert;
    
    UIView *imgView;
    UIImageView *xuanzeImage;
    BOOL *isSelected;
     NSMutableArray * _gfImageArray;

}

@end

@implementation ChongZhiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _gfImageArray=[[NSMutableArray alloc] init];
//    arr5= [[NSMutableArray alloc] init];
    arrD0= [[NSMutableArray alloc] init];
    arr4= [[NSMutableArray alloc] init];
    arr3= [[NSMutableArray alloc] init];
    arr2= [[NSMutableArray alloc] init];
    arr1= [[NSMutableArray alloc] init];
    _al.delegate=self;

    isSelected=NO;
    [self makeNav];
    [self feilvchaxun];
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
    [mnb createMyNavigationBarWithBgImageName:nil andLeftBBIIamgeNames:[NSArray arrayWithObject:@"fanhui.png"] andRightBBIImages:nil andTitle:@"充值" andClass:self andSEL:@selector(bacClick:)];
    [self.view addSubview:mnb];
    
    UIButton *jiluButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [jiluButton setTitle:@"充值记录" forState:UIControlStateNormal];
    jiluButton.titleLabel.textAlignment=NSTextAlignmentCenter;
    jiluButton.frame=CGRectMake(self.view.frame.size.width-100, 15, 100, 30);
    jiluButton.titleLabel.font=[UIFont systemFontOfSize:16];
    [jiluButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [jiluButton addTarget:self action:@selector(navButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [mnb addSubview:jiluButton];
    
    //状态栏颜色
    UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320*screenWidth/320, 20*screenWidth/320)];
    
    statusBarView.backgroundColor=[UIColor whiteColor];
    
    [self.view addSubview:statusBarView];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
}
#pragma mark  充值记录
-(void)navButtonClick
{
    shouKuanjiViewController *svc=[[shouKuanjiViewController alloc] init];
    [self.navigationController pushViewController:svc animated:YES];
}
-(void)bacClick:(UIButton*)btn
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadData" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)feilvchaxun
{
    User *user=[User currentUser];
    NSMutableURLRequest *rever = [PostAsynClass postAsynWithURL:url1 andInterface:url37 andKeyArr:@[@"merId"]andValueArr:@[user.merid]];
    
    NSData *receive = [NSURLConnection sendSynchronousRequest:rever returningResponse:nil error:nil];
    
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    
    // NSString *string = [reqStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString  *str = [[NSString alloc] initWithData:receive encoding:enc];
    
    NSData *ata = [NSData alloc];
    
    ata = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:ata options:NSJSONReadingMutableLeaves error:nil];
    
    NSArray *array = [dictionary objectForKey:@"merFeeInfo"];
    
    
    for(NSDictionary *dict in array)
    {
        if([[dict objectForKey:@"t0Stat"]isEqualToString:@"Y"])
        {
            [arr4 addObject:@"D0"];
            [arr3 addObject:[dict objectForKey:@"gateId"]];
            [arr2 addObject:[dict objectForKey:@"feeRateT0"]];
            [arr1 addObject:[dict objectForKey:@"gateName"]];
        }
        if([[dict objectForKey:@"t1Stat"]isEqualToString:@"Y"])
        {
            [arr4 addObject:@"T1"];
            [arr3 addObject:[dict objectForKey:@"gateId"]];
            [arr2 addObject:[dict objectForKey:@"feeRateT1"]];
            [arr1 addObject:[dict objectForKey:@"gateName"]];
        }
        
    }
    NSLog(@"feilv--------------------------------%@---%@",arr3,array);

}
-(void)makeUI
{
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
    if([feetString isEqual:nil]||feetString==NULL)
    {
        feetString=arr2[0];
    }
    //如果为选择，网关直接默认为第一个
    if([paywayString isEqual:nil]||paywayString==NULL)
    {
        paywayString=arr3[0];
    }
    if([_t isEqual:nil]||_t==NULL)
    {
        _t=arr4[0];
    }
    if ([_t isEqualToString:@"D0"])
    {
        _t=@"T0";
    }

    if(arr1.count==0)
    {
        _alert= [[UIAlertView alloc]initWithTitle:@"提示" message:@"您的交易通道未开通,暂时没有交易的权限" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
        [_alert show];
        _alert.tag=2;
    }
    
    User *user=[User currentUser];
    UILabel *yueLabel=[[UILabel alloc] initWithFrame:CGRectMake(10*screenWidth/320.0, 70*screenWidth/320.0, 150*screenWidth/320.0, 20*screenWidth/320.0)];
    NSString *yueString=[NSString stringWithFormat:@"账号余额%@",user.yu];
    NSMutableAttributedString *str=[[NSMutableAttributedString alloc] initWithString:yueString];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.99 green:0.73 blue:0.0 alpha:1.0] range:NSMakeRange(4, str.length-4)];
    yueLabel.attributedText=str;
    [self.view addSubview:yueLabel];
    
    UIView *firstView=[[UIView alloc] initWithFrame:CGRectMake(0, 95*screenWidth/320.0, self.view.frame.size.width, 150*screenWidth/320.0)];
    firstView.backgroundColor=[UIColor whiteColor];
    firstView.userInteractionEnabled=YES;
    [self.view addSubview:firstView];
    
    nameLabel=[[UILabel alloc] initWithFrame:CGRectMake(0*screenWidth/320.0, 5*screenWidth/320.0, 80*screenWidth/320.0, 30*screenWidth/320.0)];
    nameLabel.text=arr1[0];
    nameLabel.textAlignment=NSTextAlignmentCenter;
    nameLabel.font=[UIFont systemFontOfSize:14];
    [firstView addSubview:nameLabel];
    
    tLabel=[[UILabel alloc] initWithFrame:CGRectMake(80*screenWidth/320.0, 5*screenWidth/320.0, 80*screenWidth/320.0, 30*screenWidth/320.0)];
    tLabel.text=_t;
    tLabel.textAlignment=NSTextAlignmentCenter;
    tLabel.font=[UIFont systemFontOfSize:14];
    [firstView addSubview:tLabel];
    
    rateLabel=[[UILabel alloc] initWithFrame:CGRectMake(160*screenWidth/320.0, 5*screenWidth/320.0, 40*screenWidth/320.0, 30*screenWidth/320.0)];
    rateLabel.text=feetString;
    rateLabel.textAlignment=NSTextAlignmentRight;
    rateLabel.font=[UIFont systemFontOfSize:14];
    [firstView addSubview:rateLabel];
    
    UILabel *persentLabel=[[UILabel alloc] initWithFrame:CGRectMake(200*screenWidth/320.0, 5*screenWidth/320.0, 30*screenWidth/320.0, 30*screenWidth/320.0)];
    persentLabel.text=@"%";
    persentLabel.textAlignment=NSTextAlignmentLeft;
    persentLabel.font=[UIFont systemFontOfSize:14];
    [firstView addSubview:persentLabel];
    
    UIImageView *xialaImage=[[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width-30*screenWidth/320.0, 14*screenWidth/320.0, 15*screenWidth/320.0, 12*screenWidth/320.0)];
    xialaImage.image=[UIImage imageNamed:@"xiala"];
    [firstView addSubview:xialaImage];
    
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
    
    UILabel *tishiLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 125*screenWidth/320.0, self.view.frame.size.width, 20*screenWidth/320.0)];
    NSString *tishiString=@"温馨提示：充值成功后，需手工操作提现功能方可将余额转入到储蓄卡中";
    NSMutableAttributedString *string=[[NSMutableAttributedString alloc] initWithString:tishiString];
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, 5)];
    tishiLabel.attributedText=string;
    tishiLabel.font=[UIFont systemFontOfSize:12];
    tishiLabel.textAlignment=NSTextAlignmentCenter;
    [firstView addSubview:tishiLabel];
    
    UIView *secondView=[[UIView alloc] initWithFrame:CGRectMake(0, 250*screenWidth/320.0, self.view.frame.size.width, 160*screenWidth/320.0)];
    secondView.backgroundColor=[UIColor whiteColor];
    secondView.userInteractionEnabled=YES;
    [self.view addSubview:secondView];
    
    UILabel *chongzhiWayLanel=[[UILabel alloc] initWithFrame:CGRectMake(10*screenWidth/320.0, 5*screenWidth/320.0, 60*screenWidth/320.0, 20*screenWidth/320.0)];
    chongzhiWayLanel.textAlignment=NSTextAlignmentLeft;
    chongzhiWayLanel.text=@"充值方式";
    chongzhiWayLanel.font=[UIFont systemFontOfSize:15];
    [secondView addSubview:chongzhiWayLanel];
    
    //收款方式背景图
    NSArray *ary=@[@"普通充值",@"短信充值",@"二维码充值",@"扫卡充值"];
//    NSArray *imAry=@[@"putong",@"duanxin",@"erweima",@"saoka"];
    for(int i=0;i<ary.count;i++)
        
    {
        imgView=[[UIView alloc] initWithFrame:CGRectMake(0*screenWidth/320, (35+i*30)*screenWidth/320, self.view.frame.size.width, 30*screenWidth/320)];
        imgView.userInteractionEnabled=YES;
        imgView.backgroundColor=[UIColor whiteColor];
        imgView.layer.cornerRadius = 3.0;
        imgView.layer.borderWidth = 0.3;
       // [secondView addSubview:imgView];

        
        UILabel *lla=[[UILabel alloc] initWithFrame:CGRectMake(20*screenWidth/320, (35+i*30)*screenWidth/320, 100*screenWidth/320, 30*screenWidth/320)];
        lla.text=ary[i];
        lla.userInteractionEnabled=YES;
        lla.font=[UIFont systemFontOfSize:14];
        [secondView addSubview:lla];
        
        UIButton *bt = [UIButton buttonWithType:UIButtonTypeCustom];
        
        bt.frame = CGRectMake(0*screenWidth/320,(35+i*30)*screenWidth/320,self.view.frame.size.width, 30*screenWidth/320);
        
        [bt setImage:[UIImage imageNamed:@"bj_xuankuang"] forState:UIControlStateNormal];
        bt.imageEdgeInsets = UIEdgeInsetsMake(0*screenWidth/320,self.view.frame.size.width-35*screenWidth/320,0*screenWidth/320,10*screenWidth/320);
        [bt addTarget:self action:@selector(shoukuan:) forControlEvents:UIControlEventTouchUpInside];
        
        bt.tag = 10+i;
        
        if (i==0) {
            [bt setImage:[UIImage imageNamed:@"bj_xuanzhong"] forState:UIControlStateNormal];
            _f = @"1";
        }
        [secondView addSubview:bt];
        
    }
    for(int b=0;b<ary.count+1;b++)
    {
        imgView=[[UIView alloc] initWithFrame:CGRectMake(0*screenWidth/320, (35+b*30)*screenWidth/320, self.view.frame.size.width, 0.5*screenWidth/320)];
        imgView.backgroundColor=[UIColor lightGrayColor];
        [secondView addSubview:imgView];
    }
    UILabel *kahaoLabel=[[UILabel alloc] initWithFrame:CGRectMake(20*screenWidth/320.0, 415*screenWidth/320.0, 30*screenWidth/320.0, 20*screenWidth/320.0)];
    kahaoLabel.text=@"卡号:";
    kahaoLabel.textAlignment=NSTextAlignmentCenter;
    kahaoLabel.font=[UIFont systemFontOfSize:15];
    [self.view addSubview:kahaoLabel];

    
    //收款按钮
    UIButton *okButton=[UIButton buttonWithType:UIButtonTypeCustom];
    okButton.frame=CGRectMake(40*screenWidth/320.0, 450*screenWidth/320.0, self.view.frame.size.width-80*screenWidth/320.0, 40*screenWidth/320.0);
    [okButton setTitle:@"确定" forState:UIControlStateNormal];
    [okButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    okButton.backgroundColor=[UIColor colorWithRed:0.19 green:0.8 blue:0.0 alpha:1.0];
    okButton.layer.cornerRadius=15;
    okButton.clipsToBounds=YES;
    [okButton addTarget:self action:@selector(okBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:okButton];
}
#pragma mark  收款通道
-(void)btnSelect
{
    _al = [[UIActionSheet alloc]initWithTitle:@"请选择充值通道" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles: nil];
    for(int i=0;i<arr1.count;i++)
    {
        [arrD0 addObject:[NSString stringWithFormat:@"%@  %@",arr1[i],arr4[i]]];
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
        
        _t=arr4[buttonIndex-1];
        if([_t isEqualToString:@"D0"])
        {
            _t=@"T0";
        }
        tLabel.text=arr4[buttonIndex-1];
    }
}

#pragma mark  收款方式选择
-(void)shoukuan:(UIButton *)shoukuanSelect
{
    for (int i  = 0; i <4;i++)
    {
        UIButton *btnNav = (UIButton*)[self.view viewWithTag:10+i];
        
        [btnNav setImage:[UIImage imageNamed:@"bj_xuankuang"] forState:UIControlStateNormal];
        
    }
    
    [ shoukuanSelect setImage:[UIImage imageNamed:@"bj_xuanzhong"] forState:UIControlStateNormal];

        switch (shoukuanSelect.tag) {
        case 10:
        {
            _f=@"1";
            
        }
            break;
        case 11:
        {
            _f=@"2";
            
        }
            break;
            
        case 12:
        {
            _f=@"3";
            
        }
            break;
        case 13:
        {
            _f=@"4";
            
            CardIOPaymentViewController *scanViewController = [[CardIOPaymentViewController alloc] initWithPaymentDelegate:self];
            
            [self presentViewController:scanViewController animated:YES completion:nil];
            
        }
            break;
            
        default:
            break;
    }
    

}
#pragma mark  确定充值
-(void)okBtn
{
    [numTextField resignFirstResponder];
    User * user = [User currentUser];
    if(user.jing==NULL||user.jing==nil)
    {
        user.jing=@"";
    }
    if(user.wei==NULL||user.wei==nil)
    {
        user.wei=@"";
    }
    if(numTextField.text.length<=0)
    {
        [self toastResult:@"充值金额不能为空"];
        return;
        
    }
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingGB_18030_2000);
     NSString *str1 = [@"货款" stringByAddingPercentEscapesUsingEncoding:enc];

    //自动添加小数点后两位
    NSString *text1=[NSString stringWithFormat:@"%.2f",[numTextField.text doubleValue]];
    [MBProgressHUD showMessage:@"加载中..." toView:self.view];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (ino64_t)(1*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if([paywayString isEqualToString:@"weixin"]||[paywayString isEqualToString:@"alipay"])
        {
            NSLog(@"选择的是微信或者支付宝收款");
            [self erweimashoukuan];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }
        else
        {
            if ([_f isEqualToString:@"1"]) {
                //对应普通的收款网络请求  成功后跳到普通收款对你供应页面
                
                                //截取字符串后六位
                NSString *a=_datestr;
                NSString *b=[a substringFromIndex:8];               
               
                NSMutableURLRequest *rever = [PostAsynClass postAsynWithURL:url1 andInterface:url14 andKeyArr:@[@"merId",@"loginId",@"credNo",@"transAmt",@"ordRemark",@"liqType",@"clientModel",@"cardType",@"longitude",@"latitude",@"gateId"]andValueArr:@[user.merid,user.phoneText,b,text1,str1 ,_t,[[UIDevice currentDevice] model],@"X",user.jing,user.wei,paywayString]];
                NSData *receive = [NSURLConnection sendSynchronousRequest:rever returningResponse:nil error:nil];
                
                //NSString *string=[receive stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                
                NSString  *str = [[NSString alloc] initWithData:receive encoding:enc];
                
                NSData *ata = [NSData alloc];
                
                ata = [str dataUsingEncoding:NSUTF8StringEncoding];
                
                dic = [NSJSONSerialization JSONObjectWithData:ata options:NSJSONReadingMutableLeaves error:nil];
                user.dingDan=[dic objectForKey:@"transSeqId"];
                user.pingZheng=[dic objectForKey:@"credNo"];
                user.shouxu=[dic objectForKey:@"transFee"];
                
                NSString *sre = [dic objectForKey:@"respDesc"];
                NSLog(@"&&&&&&&&&&&&&%@",sre);
                NSLog(@"putongshoukuan%@",dic);
                
                if(![[dic objectForKey:@"respCode"]isEqualToString:@"000"])
                {
                    [self toastResult:sre];
                }
                
                if([[dic objectForKey:@"respCode"]isEqualToString:@"000"])
                {
                    
                    
                    NSMutableURLRequest *rever1 = [PostAsynClass postAsynWithURL:url1 andInterface:url16 andKeyArr:@[@"merId",@"transSeqId",@"credNo",@"paySrc"]andValueArr:@[user.merid,user.dingDan,user.pingZheng,@"nor"]];
                    //
                    NSData *receive1 = [NSURLConnection sendSynchronousRequest:rever1 returningResponse:nil error:nil];
                    
                    NSStringEncoding enc1 = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
                    
                    
                    //NSString *string=[receive stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                    
                    NSString  *str2 = [[NSString alloc] initWithData:receive1 encoding:enc1];
                    
                    NSData *ata1 = [NSData alloc];
                    
                    ata1 = [str2 dataUsingEncoding:NSUTF8StringEncoding];
                    
                    NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:ata1 options:NSJSONReadingMutableLeaves error:nil];
                    
                    NSLog(@"xiaofeiyemian%@",dic1);
                    
                    zhiFuViewController *zhifu=[[zhiFuViewController alloc] init];
                    [self.navigationController pushViewController:zhifu animated:YES];
                    
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    
                }
                
            }
            else if ([_f isEqualToString:@"2"])
            {
                
                //对应短信的收款网络请求  成功后跳到短信收款对你供应页面
                duanXinViewController *duan=[[duanXinViewController alloc] init];
                duan.txuan=_t;
                duan.kaxuan=@"X";
                duan.reason=str1;
                duan.payway=paywayString;
                duan.sum=text1;
                duan.jing=user.jing;
                duan.wei=user.wei;
                [self.navigationController pushViewController:duan animated:YES];
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                
            }
            else if ([_f isEqualToString:@"3"])
            {
                //截取字符串后六位
                NSString *a1=_datestr;
                NSString *b1=[a1 substringFromIndex:8];
                
            NSMutableURLRequest *rever = [PostAsynClass postAsynWithURL:url1 andInterface:url14 andKeyArr:@[@"merId",@"loginId",@"credNo",@"transAmt",@"ordRemark",@"liqType",@"clientModel",@"cardType",@"longitude",@"latitude",@"gateId"]andValueArr:@[user.merid,user.phoneText,b1,text1,str1 ,_t,[[UIDevice currentDevice] model],@"X",user.jing,user.wei,paywayString]];
                
                NSData *receive = [NSURLConnection sendSynchronousRequest:rever returningResponse:nil error:nil];
                NSString  *str = [[NSString alloc] initWithData:receive encoding:enc];
                
                NSData *ata = [NSData alloc];
                
                ata = [str dataUsingEncoding:NSUTF8StringEncoding];
                
                NSDictionary *di = [NSJSONSerialization JSONObjectWithData:ata options:NSJSONReadingMutableLeaves error:nil];
                user.xia=[di objectForKey:@"transSeqId"];
                NSLog(@"erweimashoukuan%@",di);
                NSString *sre = [di objectForKey:@"respDesc"];
                NSLog(@"&&&&&&&&&&&&&%@",sre);
                NSLog(@"putongshoukuan%@",di);
                
                if(![[di objectForKey:@"respCode"]isEqualToString:@"000"])
                {
                    [self toastResult:sre];
                }
                if([[di objectForKey:@"respCode"]isEqualToString:@"000"])
                {
                    
                    NSStringEncoding enc1 = CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingGB_18030_2000);
                    
                    //截取字符串后六位
                    NSString *b=_datestr;
                    NSString *c=[b substringFromIndex:8];
                    
                    NSMutableURLRequest *rever1 = [PostAsynClass postAsynWithURL:url1 andInterface:url15 andKeyArr:@[@"merId",@"transSeqId",@"credNo"]andValueArr:@[user.merid,user.xia,c]];
                    //
                    NSData *receive1 = [NSURLConnection sendSynchronousRequest:rever1 returningResponse:nil error:nil];
                    
                    NSString  *str2 = [[NSString alloc] initWithData:receive1 encoding:enc1];
                    
                    NSData *ata1 = [NSData alloc];
                    
                    ata1 = [str2 dataUsingEncoding:NSUTF8StringEncoding];
                    
                    NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:ata1 options:NSJSONReadingMutableLeaves error:nil];
                    user.url=[dic1 objectForKey:@"qrCodeUrl"];
                    NSLog(@"erweimashoukuan2%@",dic1);
                    NSString *sre1 = [dic1 objectForKey:@"respDesc"];
                    NSLog(@"&&&&&&&&&&&&&%@",sre1);
                    NSLog(@"putongshoukuan%@",dic1);
                    
                    if(![[dic1 objectForKey:@"respCode"]isEqualToString:@"000"])
                    {
                        [self toastResult:sre1];
                    }
                    else
                    {
                        nextErweiViewController *next1=[[nextErweiViewController alloc] init];
                        next1.string=@"收款";
                        [self.navigationController pushViewController:next1 animated:YES];
                        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                        
                    }
                    
                }
            }
            else
            {
                //对应扫描的收款网络请求  成功后跳到扫描页面
                if(kanumLab.text.length<=0)
                {
                    [self toastResult:@"扫描卡号不能为空"];
                    return ;
                }
                //截取字符串后六位
                NSString *a=_datestr;
                NSString *b=[a substringFromIndex:8];
                NSMutableURLRequest *rever = [PostAsynClass postAsynWithURL:url1 andInterface:url14 andKeyArr:@[@"merId",@"loginId",@"credNo",@"transAmt",@"ordRemark",@"liqType",@"clientModel",@"cardType",@"longitude",@"latitude",@"gateId"]andValueArr:@[user.merid,user.phoneText,b,text1,str1 ,_t,[[UIDevice currentDevice] model],@"X",user.jing,user.wei,paywayString]];
                NSData *receive = [NSURLConnection sendSynchronousRequest:rever returningResponse:nil error:nil];
                //NSString *string=[receive stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                
                NSString  *str = [[NSString alloc] initWithData:receive encoding:enc];
                
                NSData *ata = [NSData alloc];
                
                ata = [str dataUsingEncoding:NSUTF8StringEncoding];
                
                dic = [NSJSONSerialization JSONObjectWithData:ata options:NSJSONReadingMutableLeaves error:nil];
                user.dingDan=[dic objectForKey:@"transSeqId"];
                user.pingZheng=[dic objectForKey:@"credNo"];
                user.shouxu=[dic objectForKey:@"transFee"];
                
                NSString *sre = [dic objectForKey:@"respDesc"];
                NSLog(@"&&&&&&&&&&&&&%@",sre);
                NSLog(@"putongshoukuan%@",dic);
                
                if(![[dic objectForKey:@"respCode"]isEqualToString:@"000"])
                {
                    [self toastResult:sre];
                }
                
                if([[dic objectForKey:@"respCode"]isEqualToString:@"000"])
                {
                    
                    
                    NSMutableURLRequest *rever1 = [PostAsynClass postAsynWithURL:url1 andInterface:url16 andKeyArr:@[@"merId",@"transSeqId",@"credNo",@"paySrc",@"cardNo"]andValueArr:@[user.merid,user.dingDan,user.pingZheng,@"nor",user.kanum]];
                    //
                    NSData *receive1 = [NSURLConnection sendSynchronousRequest:rever1 returningResponse:nil error:nil];
                    
                    NSStringEncoding enc1 = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
                    
                    
                    //NSString *string=[receive stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                    
                    NSString  *str2 = [[NSString alloc] initWithData:receive1 encoding:enc1];
                    
                    NSData *ata1 = [NSData alloc];
                    
                    ata1 = [str2 dataUsingEncoding:NSUTF8StringEncoding];
                    
                    NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:ata1 options:NSJSONReadingMutableLeaves error:nil];
                    
                    NSLog(@"yinhangkaSaomiao%@",dic1);
                    nextKaHaoViewController *ka=[[nextKaHaoViewController alloc] init];
                    [self.navigationController pushViewController:ka animated:YES];
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    
                    
                }
            }
        }
        
    });

}
-(void)erweimashoukuan
{
    //对应二维码收款
    User * user = [User currentUser];
    
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingGB_18030_2000);
    
    //截取字符串后六位
    NSString *a1=_datestr;
    NSString *b1=[a1 substringFromIndex:8];
    
    NSString *str1 = [numTextField.text stringByAddingPercentEscapesUsingEncoding:enc];
    //自动添加小数点后两位
    NSString *text=[NSString stringWithFormat:@"%.2f",[_kuan doubleValue]];
    NSMutableURLRequest *rever = [PostAsynClass postAsynWithURL:url1 andInterface:url14 andKeyArr:@[@"merId",@"loginId",@"credNo",@"transAmt",@"ordRemark",@"liqType",@"clientModel",@"cardType",@"longitude",@"latitude",@"gateId"]andValueArr:@[user.merid,user.phoneText,b1,text,str1 ,_t,[[UIDevice currentDevice] model],@"X",user.jing,user.wei,paywayString]];
    
    NSData *receive = [NSURLConnection sendSynchronousRequest:rever returningResponse:nil error:nil];
    NSString  *str = [[NSString alloc] initWithData:receive encoding:enc];
    
    NSData *ata = [NSData alloc];
    
    ata = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *di = [NSJSONSerialization JSONObjectWithData:ata options:NSJSONReadingMutableLeaves error:nil];
    user.xia=[di objectForKey:@"transSeqId"];
    NSLog(@"erweimashoukuan%@",di);
    NSString *sre = [di objectForKey:@"respDesc"];
    NSLog(@"&&&&&&&&&&&&&%@",sre);
    NSLog(@"putongshoukuan%@",di);
    
    if(![[di objectForKey:@"respCode"]isEqualToString:@"000"])
    {
        [self toastResult:sre];
    }
    
    
    if([[di objectForKey:@"respCode"]isEqualToString:@"000"])
    {
        
        NSStringEncoding enc1 = CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingGB_18030_2000);
        
        //截取字符串后六位
        NSString *b=_datestr;
        NSString *c=[b substringFromIndex:8];
        
        NSMutableURLRequest *rever1 = [PostAsynClass postAsynWithURL:url1 andInterface:url15 andKeyArr:@[@"merId",@"transSeqId",@"credNo"]andValueArr:@[user.merid,user.xia,c]];
        //
        NSData *receive1 = [NSURLConnection sendSynchronousRequest:rever1 returningResponse:nil error:nil];
        
        //NSString *string=[receive stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSString  *str2 = [[NSString alloc] initWithData:receive1 encoding:enc1];
        
        NSData *ata1 = [NSData alloc];
        
        ata1 = [str2 dataUsingEncoding:NSUTF8StringEncoding];
        
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:ata1 options:NSJSONReadingMutableLeaves error:nil];
        user.url=[dic1 objectForKey:@"qrCodeUrl"];
        NSLog(@"erweimashoukuan2%@",dic1);
        NSString *sre1 = [dic1 objectForKey:@"respDesc"];
        NSLog(@"&&&&&&&&&&&&&%@",sre1);
        NSLog(@"putongshoukuan%@",dic1);
        
        if(![[dic1 objectForKey:@"respCode"]isEqualToString:@"000"])
        {
            [self toastResult:sre1];
        }
        else
        {
            nextErweiViewController *next1=[[nextErweiViewController alloc] init];
            if([paywayString isEqualToString:@"weixin"])
            {
                next1.string=@"微信收款";
            }
            if([paywayString isEqualToString:@"alipay"])
            {
                next1.string=@"支付宝收款";
                
            }
            [self.navigationController pushViewController:next1 animated:YES];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
            
        }
        
    }
    
}

#pragma mark  扫卡充值
- (void)userDidProvideCreditCardInfo:(CardIOCreditCardInfo *)info inPaymentViewController:(CardIOPaymentViewController *)paymentViewController {
    NSLog(@"Scan succeeded with info: %@", info);
    // Do whatever needs to be done to deliver the purchased items.
    [self dismissViewControllerAnimated:YES completion:nil];
    User *user=[User currentUser];
    self.infoLabel.text = [NSString stringWithFormat:@"Received card info. Number: %@, expiry: %02lu/%lu, cvv: %@.", info.cardNumber, (unsigned long)info.expiryMonth, (unsigned long)info.expiryYear, info.cvv];
    user.kanum=info.cardNumber;
    NSLog(@"*************** 90%@",user.kanum);
    
    //User *user=[User currentUser];
    kanumLab=[[UILabel alloc] initWithFrame:CGRectMake(60*screenWidth/320, 415*screenWidth/320, 200*screenWidth/320, 20*screenWidth/320)];
    kanumLab.text=user.kanum;
     kanumLab.backgroundColor=[UIColor yellowColor];
    kanumLab.textColor=[UIColor redColor
                        ];
    kanumLab.font=[UIFont systemFontOfSize:14];
    [self.view addSubview:kanumLab];
    
}
- (void)userDidCancelPaymentViewController:(CardIOPaymentViewController *)paymentViewController {
    NSLog(@"User cancelled scan");
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag==2)
    {
        if(!buttonIndex)
        {
            
        }
        else
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
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
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [numTextField resignFirstResponder];
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
