//
//  ShareViewController.m
//  JYBF
//
//  Created by 王健超 on 15/8/24.
//  Copyright (c) 2015年 wjc. All rights reserved.
//

#import "ShareViewController.h"
#import "User.h"
#import "Header.h"
#import "MyNavigationBar.h"
#import <ShareSDK/ShareSDK.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "WXApi.h"
#import "PostAsynClass.h"
#import "tuiGuangViewController.h"
#import "erweimaFenxiangViewController.h"
#import "zhiFuViewController.h"
@interface ShareViewController ()
{
    UILabel *_numLabel;
    UIAlertView *mfAlertview;//定义一个弹出框
    NSString *_Urlstr;
     NSString *_datestr;

}
@end

@implementation ShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeNav];
    [self getNum];
    [self makeUI];
    self.view.backgroundColor=[UIColor colorWithRed:236/255.0 green:236/255.0 blue:236/255.0 alpha:1];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    User *user=[User currentUser];
    [self getNum];
     _numLabel.text=[NSString stringWithFormat:@"%@个",user.Yue];
}
-(void)makeNav
{
    //导航
    [self.navigationController setNavigationBarHidden:YES];
    MyNavigationBar *mnb = [[MyNavigationBar alloc] init];
    mnb.frame = CGRectMake(0, 20*screenWidth/320, 320*screenWidth/320, 44*screenWidth/320);
    [mnb createMyNavigationBarWithBgImageName:nil andLeftBBIIamgeNames:[NSArray arrayWithObject:@""] andRightBBIImages:nil andTitle:@"分享" andClass:self andSEL:@selector(sharebacClick:)];
    [self.view addSubview:mnb];
    
    UIButton *jiluButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [jiluButton setTitle:@"分享记录" forState:UIControlStateNormal];
    jiluButton.titleLabel.textAlignment=NSTextAlignmentCenter;
    [jiluButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    jiluButton.frame=CGRectMake(self.view.frame.size.width-100, 15, 100, 30);
    jiluButton.titleLabel.font=[UIFont systemFontOfSize:16];
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
    tuiGuangViewController *tvc=[[tuiGuangViewController alloc] init];
    [self.navigationController pushViewController:tvc animated:YES];
}
-(void)getNum
{
    User *user=[User currentUser];
    
    //余额
    //post请求用NSMutableURLRequest,可变request的请求头
    NSMutableURLRequest *rever = [PostAsynClass postAsynWithURL:url1 andInterface:url13 andKeyArr:@[@"merId",@"acctType"]andValueArr:@[user.merid,@"MER0"]];
    //开始post请求
    NSData *receive = [NSURLConnection sendSynchronousRequest:rever returningResponse:nil error:nil];
    
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    //NSString *string=[receive stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString  *str = [[NSString alloc] initWithData:receive encoding:enc];
    
    NSData *ata = [NSData alloc];
    
    ata = [str dataUsingEncoding:NSUTF8StringEncoding];
    //数据解析
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:ata options:NSJSONReadingMutableLeaves error:nil];
    user.Yue=[dic objectForKey:@"acctBal"];
    int a = [user.Yue intValue];
    user.Yue=[NSString stringWithFormat:@"%d",a];

}
-(void)makeUI
{ 
   User *user=[User currentUser];
//    
//    //余额
//    //post请求用NSMutableURLRequest,可变request的请求头
//    NSMutableURLRequest *rever = [PostAsynClass postAsynWithURL:url1 andInterface:url13 andKeyArr:@[@"merId",@"acctType"]andValueArr:@[user.merid,@"MER0"]];
//    //开始post请求
//    NSData *receive = [NSURLConnection sendSynchronousRequest:rever returningResponse:nil error:nil];
//    
//    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
//    //NSString *string=[receive stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    
//    NSString  *str = [[NSString alloc] initWithData:receive encoding:enc];
//    
//    NSData *ata = [NSData alloc];
//    
//    ata = [str dataUsingEncoding:NSUTF8StringEncoding];
//    //数据解析
//    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:ata options:NSJSONReadingMutableLeaves error:nil];
//    user.Yue=[dic objectForKey:@"acctBal"];
//    int a = [user.Yue intValue];
//    user.Yue=[NSString stringWithFormat:@"%d",a];
//    NSLog(@"yu e%@",dic);
    
    //剩余推广名额
    NSArray *arr=@[@"分享名额剩余:",@"分享须知"];
    for(int i=0;i<2;i++)
    {
        UILabel *lab=[[UILabel alloc] initWithFrame:CGRectMake(10*screenWidth/320, (70+i*85)*screenWidth/320, 100*screenWidth/320, 25*screenWidth/320)];
        lab.text=arr[i];
        lab.font=[UIFont systemFontOfSize:14];
        lab.textColor=[UIColor blackColor];
        [self.view addSubview:lab];
    }
    _numLabel=[[UILabel alloc] initWithFrame:CGRectMake(100*screenWidth/320, 70*screenWidth/320, 50*screenWidth/320, 25*screenWidth/320)];
    _numLabel.text=[NSString stringWithFormat:@"%@个",user.Yue];
    _numLabel.font=[UIFont systemFontOfSize:14];
    _numLabel.textColor=[UIColor orangeColor];
    [self.view addSubview: _numLabel];
    
    for(int k=0;k<2;k++)
    {
        UILabel *xiajiLabel=[[UILabel alloc] initWithFrame:CGRectMake(10*screenWidth/320, (100+k*25)*screenWidth/320, 150*screenWidth/320, 20*screenWidth/320)];
        if(k==0)
        {
            xiajiLabel.text=[NSString stringWithFormat:@"下级商户数:  %@",user.tgRecordSumLev1];
        }
        if(k==1)
        {
            xiajiLabel.text=[NSString stringWithFormat:@"下下级商户数:  %@",user.tgRecordSumLev2];
        }
        xiajiLabel.font=[UIFont systemFontOfSize:14];
        xiajiLabel.textAlignment=NSTextAlignmentLeft;
        xiajiLabel.textColor=[UIColor blackColor];
        [self.view addSubview:xiajiLabel];
    }
    UIButton *buyButton=[UIButton buttonWithType:UIButtonTypeCustom];
    buyButton.frame=CGRectMake(self.view.frame.size.width-60*screenWidth/320.0, 80*screenWidth/320.0, 40*screenWidth/320.0, 25*screenWidth/320.0);
    [buyButton setTitle:@"购买" forState:UIControlStateNormal];
    [buyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    buyButton.backgroundColor=[UIColor purpleColor];
    buyButton.layer.cornerRadius=5*screenWidth/320.0;
    buyButton.clipsToBounds=YES;
    [buyButton addTarget:self action:@selector(buyBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buyButton];
    
    for(int i=0;i<2;i++)
    {
        UIView *view=[[UIView alloc] initWithFrame:CGRectMake(5*screenWidth/320, (150+i*140)*screenWidth/320, self.view.frame.size.width-10, 0.5*screenWidth/320)];
        view.backgroundColor=[UIColor grayColor];
        [self.view addSubview:view];
    }
    
    
    NSArray *arr1=@[@"1.  系统默认赠送3个分享名额",@"2.  3个分享名额注册并实名,可购买名额",@"3.  分享商户产生交易，您将实时获得返佣",@"4. 分享商户,商户注册并实名认证将增加100积分"];
    for(int i=0;i<4;i++)
    {
        UILabel *lab=[[UILabel alloc] initWithFrame:CGRectMake(10*screenWidth/320, (175+i*25)*screenWidth/320, 300*screenWidth/320, 25*screenWidth/320)];
        lab.text=arr1[i];
        lab.font=[UIFont systemFontOfSize:14];
        lab.textColor=[UIColor lightGrayColor];
        [self.view addSubview:lab];
    }

    NSArray*imageArr=@[@"weixinShare",@"QQShare",@"duanxinShare",@"erweimaShare"];
    for(int i=0;i<imageArr.count;i++)
    {
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame=CGRectMake((15+i*80)*screenWidth/320,320*screenWidth/320, 50*screenWidth/320, 50*screenWidth/320);
        [btn setImage:[UIImage imageNamed:imageArr[i]] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btn:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag=1000+i;
        [self.view addSubview:btn];
    }
    
    
    NSArray *titaleArr=@[@"微信",@"QQ",@"短信",@"二维码"];
    for(int i=0;i<4;i++)
    {
        UILabel *lab=[[UILabel alloc] initWithFrame:CGRectMake((5+i*80)*screenWidth/320, 370*screenWidth/320, 70*screenWidth/320, 25*screenWidth/320)];
        lab.text=titaleArr[i];
        
        lab.textAlignment=NSTextAlignmentCenter;
        lab.font=[UIFont systemFontOfSize:13];
        lab.textColor=[UIColor blackColor];
        [self.view addSubview:lab];
    }
}
#pragma mark  购买名额
-(void)buyBtn
{
    NSLog(@"点击购买");
    User *user=[User currentUser];
    if(user.jing.length<=0)
    {
        user.jing=@"";
    }
    if(user.wei.length<=0)
    {
        user.wei=@"";
    }
    //获取当前时间
    NSDate *date=[[NSDate alloc]init];
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    NSTimeZone *zone=[NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:zone];
    
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    
    NSArray *zonearr=[NSTimeZone knownTimeZoneNames];
    NSLog(@"%@",zonearr);
    
    _datestr=[formatter stringFromDate:date];
    NSLog(@"需要支付99元费用");
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingGB_18030_2000);
    
    //截取字符串后六位
    NSString *a=_datestr;
    NSString *b=[a substringFromIndex:8];
    NSMutableURLRequest *rever = [PostAsynClass postAsynWithURL:url1 andInterface:url14 andKeyArr:@[@"merId",@"loginId",@"credNo",@"transAmt",@"ordRemark",@"liqType",@"clientModel",@"cardType",@"gateId",@"longitude",@"latitude"]andValueArr:@[user.merid,user.phoneText,b,@"99.00",@"shopRegNumDD" ,@"T0",[[UIDevice currentDevice] model],@"X",@"eposyeepay",user.jing,user.wei]];
    
    NSData *receive = [NSURLConnection sendSynchronousRequest:rever returningResponse:nil error:nil];
    
    //NSString *string=[receive stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString  *str = [[NSString alloc] initWithData:receive encoding:enc];
    
    NSData *ata = [NSData alloc];
    
    ata = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *dictio = [NSJSONSerialization JSONObjectWithData:ata options:NSJSONReadingMutableLeaves error:nil];
    user.dingDan=[dictio objectForKey:@"transSeqId"];
    user.pingZheng=[dictio objectForKey:@"credNo"];
    user.shouxu=[dictio objectForKey:@"transFee"];
    
    NSString *sre = [dictio objectForKey:@"respDesc"];
    NSLog(@"&&&&&&&&&&&&&%@",sre);
    NSLog(@"putongshoukuan%@",dictio);
    
    if(![[dictio objectForKey:@"respCode"]isEqualToString:@"000"])
    {
        [self toastResult:sre];
    }
    if([[dictio objectForKey:@"respCode"]isEqualToString:@"000"])
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
    }

}
-(void)btn:(UIButton*)shareBtn
{
    
    User *user=[User currentUser];
    _Urlstr=[NSString stringWithFormat:@"http://dd.appfu.cn/mobile/ss/doReg.do?agentId=%@&mobile=%@",can,user.phoneText];
    switch (shareBtn.tag) {
            //微信分享
        case 1000:
        {
            
            NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"dengluLOGO" ofType:@"png"];
            id<ISSContent> publishContent = [ShareSDK content:[NSString stringWithFormat:@"来自%@的分享 多多支付App下载注册地址%@",user.name,_Urlstr]
                                               defaultContent:@"默认分享内容，没内容时显示"
                                                        image:[ShareSDK imageWithPath:imagePath]
                                                        title:@"多多支付"
                                                          url:_Urlstr
                                                  description:@"多多支付App 下载注册"
                                                    mediaType:SSPublishContentMediaTypeNews];
            
            [publishContent addSMSUnitWithContent:[NSString stringWithFormat:@"来自%@的分享 多多支付App下载注册地址%@",user.name,_Urlstr]];
            
            [ShareSDK shareContent:publishContent
                              type:ShareTypeWeixiSession
                       authOptions:nil
                      shareOptions:nil
                     statusBarTips:YES
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                if (state == SSPublishContentStateSuccess)
                                {
                                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                                    message:nil
                                                                                   delegate:self
                                                                          cancelButtonTitle:@"OK"
                                                                          otherButtonTitles:nil, nil];
                                    [alert show];
                                }
                                else if (state == SSPublishContentStateFail)
                                {
                                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                                    message:[NSString stringWithFormat:@"失败描述：%@",[error errorDescription]]
                                                                                   delegate:self
                                                                          cancelButtonTitle:@"OK"
                                                                          otherButtonTitles:nil, nil];
                                    [alert show];
                                    
                                }
                                
                            }];
            
            break;
        }
            //QQ分享
        case 1001:
        {
            NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"dengluLOGO" ofType:@"png"];
            id<ISSContent> publishContent = [ShareSDK content:[NSString stringWithFormat:@"来自%@的分享 多多支付App下载注册地址%@",user.name,_Urlstr]
                                               defaultContent:@"默认分享内容，没内容时显示"
                                                        image:[ShareSDK imageWithPath:imagePath]
                                                        title:@"多多支付"
                                                          url:_Urlstr
                                                  description:@"多多支付App 下载注册"
                                                    mediaType:SSPublishContentMediaTypeNews];
            
            [publishContent addSMSUnitWithContent:[NSString stringWithFormat:@"来自%@的分享 多多支付App下载注册地址%@",user.name,_Urlstr]];
            
            [ShareSDK shareContent:publishContent
                              type:ShareTypeQQ
                       authOptions:nil
                      shareOptions:nil
                     statusBarTips:YES
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                if (state == SSPublishContentStateSuccess)
                                {
                                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                                    message:nil
                                                                                   delegate:self
                                                                          cancelButtonTitle:@"OK"
                                                                          otherButtonTitles:nil, nil];
                                    [alert show];
                                }
                                else if (state == SSPublishContentStateFail)
                                {
                                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                                    message:[NSString stringWithFormat:@"失败描述：%@",[error errorDescription]]
                                                                                   delegate:self
                                                                          cancelButtonTitle:@"OK"
                                                                          otherButtonTitles:nil, nil];
                                    [alert show];
                                    
                                }
                                
                            }];
            
            break;
        }
            //短信分享
        case 1002:
        {
            NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"dengluLOGO" ofType:@"png"];
            id<ISSContent> publishContent = [ShareSDK content:[NSString stringWithFormat:@"来自%@的分享 多多支付App下载注册地址%@",user.name,_Urlstr]
                                               defaultContent:@"默认分享内容，没内容时显示"
                                                        image:[ShareSDK imageWithPath:imagePath]
                                                        title:@"多多支付"
                                                          url:_Urlstr
                                                  description:@"多多支付App 下载注册"
                                                    mediaType:SSPublishContentMediaTypeNews];
            
            [publishContent addSMSUnitWithContent:[NSString stringWithFormat:@"来自%@的分享 多多支付App下载注册地址%@",user.name,_Urlstr]];
            
            [ShareSDK shareContent:publishContent
                              type:ShareTypeSMS
                       authOptions:nil
                      shareOptions:nil
                     statusBarTips:YES
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                if (state == SSPublishContentStateSuccess)
                                {
                                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                                    message:nil
                                                                                   delegate:self
                                                                          cancelButtonTitle:@"OK"
                                                                          otherButtonTitles:nil, nil];
                                    [alert show];
                                }
                                else if (state == SSPublishContentStateFail)
                                {
                                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                                    message:[NSString stringWithFormat:@"失败描述：%@",[error errorDescription]]
                                                                                   delegate:self
                                                                          cancelButtonTitle:@"OK"
                                                                          otherButtonTitles:nil, nil];
                                    [alert show];
                                    
                                }
                                
                            }];
            
            break;
        }
            //二维码分享
        case 1003:
        {
            erweimaFenxiangViewController *evc=[[erweimaFenxiangViewController alloc] init];
            [self.navigationController pushViewController:evc animated:YES];
            break;
        }
        default:
            break;
    }
}

-(void)sharebacClick:(UIButton*)btn
{
//    [self.navigationController popViewControllerAnimated:YES];
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
