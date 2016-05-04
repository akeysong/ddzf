//
//  MainViewController.m
//  DDZF
//
//  Created by 王健超 on 15/11/30.
//  Copyright (c) 2015年 wjc. All rights reserved.
//

#import "MainViewController.h"
#import "MyNavigationBar.h"
#import "User.h"
#import "Header.h"
#import "PostAsynClass.h"
#import "UIImageView+WebCache.h"
#import "SettingViewController.h"
#import "aboutUsViewController.h"
#import "caozuoGuideViewController.h"
#import "yonghuXYViewController.h"
#import "tuiGuangViewController.h"
#import "ShiMingViewController.h"
#import "FeiLvXinXiViewController.h"
#import "UserDetailViewController.h"
#import "saoYSViewController.h"
#import "DuoDuoTongXunViewController.h"
#import "jIRongLiCaiViewController.h"
#import "JinRongChaoShiViewController.h"
#import "PSOViewController.h"
#import "ShouKuanViewController.h"
#import "ZhuanZhangViewController.h"
#import "LiuLiangBaoViewController.h"
#import "paihangViewController.h"
#import "YiYuanDuoBaoViewController.h"
#import "ShengHuoJiaoFeiViewController.h"
#import "GoWhereViewController.h"
#import "ShareViewController.h"
#import "QianBaoViewController.h"
#import "JiFenViewController.h"
#import <ShareSDK/ShareSDK.h>
#include <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentApiInterface.h>
#import "WXApi.h"
#import <AVFoundation/AVFoundation.h>
#import "AFHTTPRequestOperationManager.h"
#import "AFURLResponseSerialization.h"
#import "AFHTTPRequestOperation.h"
#import "erweimaFenxiangViewController.h"
#import "TongZhiViewController.h"
#import "ErWeiMaViewController.h"
#import "tuangouViewController.h"
#import "ChongZhiViewController.h"
#import "nextTixianViewController.h"
#import "FanYongZCViewController.h"
@interface MainViewController ()<UIActionSheetDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UIImagePickerControllerDelegate>
{
    UIImagePickerController *picker;
    UIActionSheet *actionSheetCename;
    NSString  *filePath;
    
    UIScrollView *_scr;
    UIScrollView *scrollview;
    UIView *firstImage;
    UIImageView *secongImage;
    UIView *thirdView;
    NSTimer *timer;
    NSArray *imageArray;
    NSArray *buttonImageArray;
    NSArray *buttonSelectImageArray;
    NSArray *changButtonArray;
    NSArray *changSelectButtonArray;
    
    NSArray *allButtonArray;
    NSArray *titileArray;
    
    
    BOOL isClicked;
    BOOL isHiden;
    BOOL isShare;
    UIButton *leftButton;
    UIView *allView;
    
    UIImageView *headImage;
    
    UIView *swipView;
    
    UIView *shareView;
    
    UIView *fanyongView;
    
    NSString *_Urlstr;
    
    UILabel *yueLabel;
    UILabel *fanyongLabel;
    
}
@end

@implementation MainViewController
@synthesize pageControl;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor colorWithRed:0/255.0 green:58/255.0 blue:85/255.0 alpha:1.0];
    self.navigationController.toolbarHidden=YES;
    [self.tabBarController.tabBar setHidden:YES];
    isShare=NO;
    isHiden=NO;
    [self makeNav];
    [self reloadData];
    [self makeUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(leftBtn) name:@"leftBtn" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:@"reloadData" object:nil];
    // Do any additional setup after loading the view.
}
-(void)makeNav
{
    //导航
    //状态栏颜色
    UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320*screenWidth/320, 22*screenWidth/320)];
    
    statusBarView.backgroundColor=[UIColor whiteColor];
    [allView addSubview:statusBarView];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
    
}
-(void)viewWillAppear:(BOOL)animated
{
    User *user=[User currentUser];
    fanyongLabel.text=[NSString stringWithFormat:@"%@元",user.fanYong];
    yueLabel.text=user.yu;
    
}
#pragma mark  侧边栏
-(void)leftBtn
{
    [self cancelBtn];
    if(isClicked==NO)
    {
        [UIView animateWithDuration:0.2 animations:^{
            allView.transform = CGAffineTransformScale(CGAffineTransformIdentity,0.8,0.8);
            allView.center = CGPointMake(340*screenWidth/320.0,300*screenWidth/320.0);
            allView.layer.borderColor=[[UIColor grayColor] CGColor];
            allView.layer.borderWidth=1;
        } completion:^(BOOL finished) {
            isClicked=YES;
            swipView=[[UIView alloc] initWithFrame:CGRectMake(0, 44*screenWidth/320.0, allView.frame.size.width, allView.frame.size.height+44*screenWidth/320.0)];
            swipView.backgroundColor=[UIColor clearColor];
            swipView.tag=500;
            [allView addSubview:swipView];
            //NSLog(@"输出位置为%f",allView.frame.origin.x);
        }];
    }
    else
    {
        [UIView animateWithDuration:0.2 animations:^{
            allView.transform = CGAffineTransformScale(CGAffineTransformIdentity,1.0,1.0);
            allView.center = CGPointMake(self.view.frame.size.width/2,(self.view.frame.size.height)/2+10*screenWidth/320.0);
            allView.layer.borderColor=[[UIColor clearColor] CGColor];
            allView.layer.borderWidth=1;
        } completion:^(BOOL finished) {
            isClicked=NO;
            for(UIView *subView in [allView subviews])
            {
                if([subView isKindOfClass:[UIView class]]&&subView.tag==500)
                {
                    [subView removeFromSuperview];
                }
            }
        }];
    }
    
}
#pragma mark  推送消息
-(void)rightBtn
{
    [self cancelBtn];
    TongZhiViewController *tvc=[[TongZhiViewController alloc] init];
    [self.navigationController pushViewController:tvc animated:YES];
}
-(void)makeUI
{
    User *user=[User currentUser];
    headImage=[[UIImageView alloc] initWithFrame:CGRectMake(20*screenWidth/320.0, 40*screenWidth/320.0, 60*screenWidth/320.0, 60*screenWidth/320.0)];
    if([user.headImage isEqual:@""]||user.headImage==nil)
    {
        headImage.image=[UIImage imageNamed:@"touxiang@2x.png"];
    }
    else
    {
        [headImage setImageWithURL:[NSURL URLWithString:user.headImage]];
    }
    headImage.layer.cornerRadius=30*screenWidth/320.0;
    headImage.clipsToBounds=YES;
    headImage.userInteractionEnabled=YES;
    [self.view addSubview:headImage];
    
    UIButton *headButton=[UIButton buttonWithType:UIButtonTypeCustom];
    headButton.frame=CGRectMake(0,0 ,60*screenWidth/320.0, 60*screenWidth/320.0);
    headButton.backgroundColor=[UIColor clearColor];
    [headButton addTarget:self action:@selector(headBtn) forControlEvents:UIControlEventTouchUpInside];
    [headImage addSubview:headButton];
    
    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(headImage.frame.origin.x+headImage.frame.size.width+10*screenWidth/320.0, headImage.frame.origin.y+5*screenWidth/320.0, 45*screenWidth/320.0, 20*screenWidth/320.0)];
    label.text=user.name;
    label.textColor=[UIColor whiteColor];
    label.textAlignment=NSTextAlignmentLeft;
    label.font=[UIFont systemFontOfSize:13*screenWidth/320.0];
    [self.view addSubview:label];
    
    UILabel *phoneNumLabel=[[UILabel alloc] initWithFrame:CGRectMake(label.frame.origin.x, label.frame.origin.y+label.frame.size.height+5*screenWidth/320.0, 100*screenWidth/320.0, 20*screenWidth/320.0)];
    NSString *str=user.phoneText;
    NSRange range=NSMakeRange(3, 4);
    phoneNumLabel.text=[NSString stringWithFormat:@"%@",[str stringByReplacingCharactersInRange:range withString:@"****"]];
    phoneNumLabel.textColor=[UIColor whiteColor];
    phoneNumLabel.font=[UIFont systemFontOfSize:14*screenWidth/320.0];
    phoneNumLabel.textAlignment=NSTextAlignmentLeft;
    [self.view addSubview:phoneNumLabel];
    
    UIButton *userButton=[UIButton buttonWithType:UIButtonTypeCustom];
    userButton.frame=CGRectMake(label.frame.origin.x+label.frame.size.width-5, label.frame.origin.y, 40*screenWidth/320.0, label.frame.size.height);
    [userButton setImage:[UIImage imageNamed:@"yonghu@2x.png"] forState:UIControlStateNormal];
    [userButton addTarget:self action:@selector(userBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:userButton];
    
    //钱包18624089620
    UILabel *qianbaoLabel=[[UILabel alloc] initWithFrame:CGRectMake(headImage.frame.origin.x, headImage.frame.origin.y+headImage.frame.size.height+12*screenWidth/320.0, 40*screenWidth/320.0, 18*screenWidth/320.0)];
    qianbaoLabel.text=@"钱包:";
    qianbaoLabel.textColor=[UIColor whiteColor];
    qianbaoLabel.textAlignment=NSTextAlignmentLeft;
    qianbaoLabel.font=[UIFont systemFontOfSize:13];
    [self.view addSubview:qianbaoLabel];
    
    //余额
    yueLabel=[[UILabel alloc] initWithFrame:CGRectMake(headImage.frame.origin.x+10*screenWidth/320.0, headImage.frame.origin.y+headImage.frame.size.height+30*screenWidth/320.0, 100*screenWidth/320.0, 25*screenWidth/320.0)];
    yueLabel.textAlignment=NSTextAlignmentLeft;
    yueLabel.text=user.yu;
    yueLabel.textColor=[UIColor whiteColor];
    yueLabel.font=[UIFont systemFontOfSize:17*screenWidth/320.0];
    [self.view addSubview:yueLabel];
    
    UIButton *yueButton=[UIButton buttonWithType:UIButtonTypeCustom];
    yueButton.frame=CGRectMake(headImage.frame.origin.x, headImage.frame.origin.y+headImage.frame.size.height+12*screenWidth/320.0, 120*screenWidth/320.0, 45*screenWidth/320.0);
    yueButton.backgroundColor=[UIColor clearColor];
    [yueButton addTarget:self action:@selector(yueBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:yueButton];
    
    //费率信息
    UIButton *feilvButton=[UIButton buttonWithType:UIButtonTypeCustom];
    feilvButton.frame=CGRectMake(self.view.frame.size.width-215*screenWidth/320.0, headImage.frame.origin.y+headImage.frame.size.height+20*screenWidth/320.0, 90*screenWidth/320.0, 25*screenWidth/320.0);
    [feilvButton setImage:[UIImage imageNamed:@"feilvxinxi@2x"] forState:UIControlStateNormal];
    feilvButton.imageEdgeInsets=UIEdgeInsetsMake(2, 40*screenWidth/320.0, 2, 0);
    [feilvButton addTarget:self action:@selector(feilvBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:feilvButton];
    
    if([user.sm isEqualToString:@"S"])
    {
        for(int i=0;i<2;i++)
        {
            UIView *lineview=[[UIView alloc] init];
            lineview.backgroundColor=[UIColor whiteColor];
            if(i==1)
            {
                lineview.frame=CGRectMake(headImage.frame.origin.x, (headImage.frame.origin.y+headImage.frame.size.height+10*screenWidth/320.0)+45*screenWidth/320.0*i, self.view.frame.size.width-40*screenWidth/320.0, 1);
            }
            else
            {
                lineview.frame=CGRectMake(headImage.frame.origin.x, (headImage.frame.origin.y+headImage.frame.size.height+10*screenWidth/320.0)+40*screenWidth/320.0*i, self.view.frame.size.width-40*screenWidth/320.0, 1);
            }
            
            [self.view addSubview:lineview];
        }
        
    }
    else
    {
        for(int i=0;i<3;i++)
        {
            UIView *lineview=[[UIView alloc] init];
            lineview.backgroundColor=[UIColor whiteColor];
            if(i==1)
            {
                lineview.frame=CGRectMake(headImage.frame.origin.x, (headImage.frame.origin.y+headImage.frame.size.height+10*screenWidth/320.0)+45*screenWidth/320.0*i, self.view.frame.size.width-40*screenWidth/320.0, 1);
            }
            else
            {
                lineview.frame=CGRectMake(headImage.frame.origin.x, (headImage.frame.origin.y+headImage.frame.size.height+10*screenWidth/320.0)+40*screenWidth/320.0*i, self.view.frame.size.width-40*screenWidth/320.0, 1);
            }
            
            [self.view addSubview:lineview];
        }
        
    }
    //155
    NSArray *titileArray1=@[@"实名认证",@"分享",@"在线客服",@"设置",@"使用指南",@"用户协议",@"关于我们"];
    NSArray *titileArray2=@[@"分享",@"在线客服",@"设置",@"使用指南",@"用户协议",@"关于我们"];
    NSArray *cehuaImageArray=@[@"shimingrenzheng@2x.png",@"fenxiangjilu@2x.png",@"lianxikefu@2x.png",@"shezhi@2x.png",@"shiyongzhinan@2x.png",@"yonghuxieyi@2x.png",@"guanyuwomen@2x.png"];
    NSArray *cehuaImageArray1=@[@"fenxiangjilu@2x.png",@"lianxikefu@2x.png",@"shezhi@2x.png",@"shiyongzhinan@2x.png",@"yonghuxieyi@2x.png",@"guanyuwomen@2x.png"];
    if([user.sm isEqualToString:@"S"])
    {
        for(int j=0;j<titileArray2.count;j++)
            
        {
            UIImageView *image=[[UIImageView alloc] initWithFrame:CGRectMake(20*screenWidth/320.0, 162*screenWidth/320.0+40*screenWidth/320.0*j, 20*screenWidth/320.0, 20*screenWidth/320.0)];
            image.image=[UIImage imageNamed:cehuaImageArray1[j]];
            [self.view addSubview:image];
            
            UILabel *titileLabel=[[UILabel alloc] initWithFrame:CGRectMake(45*screenWidth/320.0, 158*screenWidth/320.0+40*screenWidth/320.0*j, 100*screenWidth/320.0, 30*screenWidth/320.0)];
            titileLabel.textAlignment=NSTextAlignmentLeft;
            titileLabel.font=[UIFont systemFontOfSize:14];
            titileLabel.textColor=[UIColor whiteColor];
            titileLabel.text=titileArray2[j];
            [self.view addSubview:titileLabel];
            
            UIImageView *jiantou=[[UIImageView alloc] initWithFrame:CGRectMake(195*screenWidth/320.0, 165*screenWidth/320.0+40*screenWidth/320.0*j, 10*screenWidth/320.0, 12*screenWidth/320.0)];
            if(j==1)
            {
                jiantou.image=nil;
                UILabel *kefu=[[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width-230*screenWidth/320.0, 158*screenWidth/320.0+40*screenWidth/320.0*j, 100*screenWidth/320.0, 30*screenWidth/320.0)];
                kefu.text=@"4000-383-656";
                kefu.textColor=[UIColor whiteColor];
                kefu.textAlignment=NSTextAlignmentRight;
                kefu.font=[UIFont systemFontOfSize:14];
                [self.view addSubview:kefu];
            }
            else
            {
                jiantou.image=[UIImage imageNamed:@"next"];
            }
            [self.view addSubview:jiantou];
            
            //            if(j==0)
            //            {
            //                UILabel *shimingLabel=[[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width-220*screenWidth/320.0, 158*screenWidth/320.0+40*screenWidth/320.0*j, 80*screenWidth/320.0, 30*screenWidth/320.0)];
            //                shimingLabel.text=user.sm1;
            //                shimingLabel.textAlignment=NSTextAlignmentRight;
            //                shimingLabel.font=[UIFont systemFontOfSize:13];
            //                [self.view addSubview:shimingLabel];
            //            }
            
            UIButton *AllButton=[UIButton buttonWithType:UIButtonTypeCustom];
            AllButton.frame=CGRectMake(0, 165*screenWidth/320.0+40*screenWidth/320.0*j, self.view.frame.size.width-100*screenWidth/320.0, 40*screenWidth/320.0);
            [AllButton addTarget:self action:@selector(AllBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            AllButton.backgroundColor=[UIColor clearColor];
            AllButton.tag=401+j;
            [self.view addSubview:AllButton];
            
            
        }
        
    }
    else
    {
        for(int j=0;j<titileArray1.count;j++)
            
        {
            UIImageView *image=[[UIImageView alloc] initWithFrame:CGRectMake(20*screenWidth/320.0, 162*screenWidth/320.0+40*screenWidth/320.0*j, 20*screenWidth/320.0, 20*screenWidth/320.0)];
            image.image=[UIImage imageNamed:cehuaImageArray[j]];
            [self.view addSubview:image];
            
            UILabel *titileLabel=[[UILabel alloc] initWithFrame:CGRectMake(45*screenWidth/320.0, 158*screenWidth/320.0+40*screenWidth/320.0*j, 100*screenWidth/320.0, 30*screenWidth/320.0)];
            titileLabel.textAlignment=NSTextAlignmentLeft;
            titileLabel.font=[UIFont systemFontOfSize:14];
            titileLabel.textColor=[UIColor whiteColor];
            titileLabel.text=titileArray1[j];
            [self.view addSubview:titileLabel];
            
            UIImageView *jiantou=[[UIImageView alloc] initWithFrame:CGRectMake(195*screenWidth/320.0, 165*screenWidth/320.0+40*screenWidth/320.0*j, 10*screenWidth/320.0, 12*screenWidth/320.0)];
            if(j==2)
            {
                jiantou.image=nil;
                UILabel *kefu=[[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width-230*screenWidth/320.0, 158*screenWidth/320.0+40*screenWidth/320.0*j, 100*screenWidth/320.0, 30*screenWidth/320.0)];
                kefu.text=@"4000-383-656";
                kefu.textColor=[UIColor whiteColor];
                kefu.textAlignment=NSTextAlignmentRight;
                kefu.font=[UIFont systemFontOfSize:14];
                [self.view addSubview:kefu];
            }
            else
            {
                jiantou.image=[UIImage imageNamed:@"next"];
            }
            [self.view addSubview:jiantou];
            
            if(j==0)
            {
                UILabel *shimingLabel=[[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width-220*screenWidth/320.0, 158*screenWidth/320.0+40*screenWidth/320.0*j, 80*screenWidth/320.0, 30*screenWidth/320.0)];
                shimingLabel.text=user.sm1;
                shimingLabel.textColor=[UIColor whiteColor];
                shimingLabel.textAlignment=NSTextAlignmentRight;
                shimingLabel.font=[UIFont systemFontOfSize:13];
                [self.view addSubview:shimingLabel];
            }
            
            UIButton *AllButton=[UIButton buttonWithType:UIButtonTypeCustom];
            AllButton.frame=CGRectMake(0, 165*screenWidth/320.0+40*screenWidth/320.0*j, self.view.frame.size.width-100*screenWidth/320.0, 40*screenWidth/320.0);
            [AllButton addTarget:self action:@selector(AllBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            AllButton.backgroundColor=[UIColor clearColor];
            AllButton.tag=400+j;
            [self.view addSubview:AllButton];
            
            
        }
        
    }
    
    UIView *exitView=[[UIView alloc] initWithFrame:CGRectMake(20*screenWidth/320.0, 450*screenWidth/320.0, 130*screenWidth/320.0, 30*screenWidth/320.0)];
    exitView.backgroundColor=[UIColor clearColor];
    exitView.userInteractionEnabled=YES;
    [self.view addSubview:exitView];
    //侧滑背景图
    UIImageView *cehuaBackImage=[[UIImageView alloc] initWithFrame:CGRectMake(0, 5*screenWidth/320.0, 20*screenWidth/320.0, 20*screenWidth/320.0)];
    cehuaBackImage.image=[UIImage imageNamed:@"exit"];
    [exitView addSubview:cehuaBackImage];
    
    UILabel *exitLabel=[[UILabel alloc] initWithFrame:CGRectMake(25*screenWidth/320.0, 5*screenWidth/320.0, exitView.frame.size.width-25*screenWidth/320.0, 20*screenWidth/320.0)];
    exitLabel.text=@"退出登录";
    exitLabel.textAlignment=NSTextAlignmentLeft;
    exitLabel.font=[UIFont systemFontOfSize:14];
    exitLabel.textColor=[UIColor whiteColor];
    [exitView addSubview:exitLabel];
    
    UIButton *exitButton=[UIButton buttonWithType:UIButtonTypeCustom];
    exitButton.frame=CGRectMake(0, 0, exitView.frame.size.width,  exitView.frame.size.height);
    [exitButton addTarget:self action:@selector(exitBtn) forControlEvents:UIControlEventTouchUpInside];
    exitButton.backgroundColor=[UIColor clearColor];
    [exitView addSubview:exitButton];
    
    
    allView=[[UIView alloc] initWithFrame:CGRectMake(0, 20*screenWidth/320.0, self.view.frame.size.width, self.view.frame.size.height-20*screenWidth/320.0)];
    allView.userInteractionEnabled=YES;
    allView.backgroundColor=[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0];
    [self.view addSubview:allView];
    
    CALayer *layer = [CALayer layer];
    
    layer.backgroundColor = [UIColor whiteColor].CGColor;
    
    layer.frame = CGRectMake(0, 0, self.view.frame.size.width, 2);
    [allView.layer addSublayer:layer];
    
    
    MyNavigationBar *mnb = [[MyNavigationBar alloc] init];
    mnb.frame = CGRectMake(0, 0*screenWidth/320, self.view.frame.size.width, 44*screenWidth/320);
    [mnb createMyNavigationBarWithBgImageName:nil andLeftBBIIamgeNames:nil andRightBBIImages:nil andTitle:@"展延钱包" andClass:self andSEL:nil];
    [allView addSubview:mnb];
    
    //左边按钮
    leftButton=[UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame=CGRectMake(10*screenWidth/320.0, 10*screenWidth/320.0, 24*screenWidth/320.0, 24*screenWidth/320.0);
    [leftButton setImage:[UIImage imageNamed:@"xiangmu@2x"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(leftBtn) forControlEvents:UIControlEventTouchUpInside];
    [mnb addSubview:leftButton];
    
    //右边按钮
    UIButton *rightButton=[UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame=CGRectMake(self.view.frame.size.width-34*screenWidth/320.0, 10*screenWidth/320.0, 24*screenWidth/320.0, 24*screenWidth/320.0);
    [rightButton setImage:[UIImage imageNamed:@"tuisong@2x"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightBtn) forControlEvents:UIControlEventTouchUpInside];
    [mnb addSubview:rightButton];
    
    imageArray=@[@"banner1",@"banner2",@"banner3",@"banner4"];
    scrollview=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 44*screenWidth/320, self.view.frame.size.width, allView.frame.size.height-44*screenWidth/320.0)];
    
    scrollview.backgroundColor=[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0];
    scrollview.bounces=NO;
    scrollview.showsHorizontalScrollIndicator=NO;
    scrollview.showsVerticalScrollIndicator=NO;
    scrollview.scrollEnabled=YES;
    scrollview.delegate=self;
    
    _scr=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0*screenWidth/320.0, self.view.frame.size.width, 110*screenWidth/320.0)];
    _scr.contentSize=CGSizeMake(self.view.frame.size.width*(imageArray.count+2), 110*screenWidth/320.0);
    _scr.bounces = NO;//设置是否反弹
    _scr.pagingEnabled = YES;
    _scr.scrollEnabled=YES;
    _scr.backgroundColor=[UIColor purpleColor];
    _scr.userInteractionEnabled=YES;
    _scr.showsHorizontalScrollIndicator=NO;//设置横向滑块的隐藏
    _scr.scrollsToTop = YES;
    _scr.delegate=self;
    
    [scrollview addSubview:_scr];
    
    //初始化pageControl
    pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake( self.view.frame.size.width/2-50, 95*screenWidth/320.0, 100, 18)];
    //选中的设置为红色
    [pageControl setCurrentPageIndicatorTintColor:[UIColor whiteColor]];
    //没有选中的设置为黑色
    [pageControl setPageIndicatorTintColor:[UIColor grayColor]];
    //设置圆点的个数
    pageControl.numberOfPages = imageArray.count;
    //设置当前页
    pageControl.currentPage = 0;
    //触摸pagecontrol触发change这个方法事件
    [pageControl addTarget:self action:@selector(turnPage) forControlEvents:UIControlEventValueChanged];
    [scrollview addSubview:pageControl];
    
    for(int i=0;i<imageArray.count;i++)
    {
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[imageArray objectAtIndex:i]]];
        imageView.userInteractionEnabled=YES;
        //首页是第0页,默认从第1页开始的。所以+320。。。
        imageView.frame = CGRectMake( self.view.frame.size.width * (i + 1), 0, self.view.frame.size.width, 110*screenWidth/320.0);
        
        //        UIButton *bu=[UIButton buttonWithType:UIButtonTypeCustom];
        //        bu.frame=CGRectMake(0, 0, self.view.frame.size.width, 120*screenWidth/320.0);
        //        [bu addTarget:self action:@selector(imageBtn:) forControlEvents:UIControlEventTouchUpInside];
        //        bu.tag=100+i;
        //        [imageView addSubview:bu];
        [_scr addSubview:imageView];
        
    }
    //取数组最后一张图片放在第0页
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[imageArray objectAtIndex:(imageArray.count-1)]]];
    imageView.frame = CGRectMake(0, 0, self.view.frame.size.width, 110*screenWidth/320.0); //添加最后1页在首页用于循环
    [_scr addSubview:imageView];
    
    //取数组第一张图片放在最后1页
    imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[imageArray objectAtIndex:0]]];
    imageView.frame = CGRectMake((self.view.frame.size.width * (imageArray.count + 1)) , 0,self.view.frame.size.width, 110*screenWidth/320.0); //添加第1页在最后用于循环
    [_scr addSubview:imageView];
    
    //加上第1页和第4页  原理：4-[1-2-3-4]-1
    [_scr setContentSize:CGSizeMake(self.view.frame.size.width * (imageArray.count + 2), 110*screenWidth/320.0)];
    [_scr setContentOffset:CGPointMake(0, 0)];
    timer=[NSTimer scheduledTimerWithTimeInterval:2.5 target:self selector:@selector(timerDeal:) userInfo:nil repeats:YES];
    [_scr scrollRectToVisible:CGRectMake(self.view.frame.size.width,0,self.view.frame.size.width,110*screenWidth/320.0) animated:NO];
    
    //首页的三大功能（第三个空指针越界）
    //充值、返佣、提现的图标(在images.xcassets里)
    buttonImageArray=@[@"cz",@"fy",@"tx"];
    NSLog(@"buttonImageArray的值%@",buttonImageArray);
    //循环一次生成“充值，返佣，提现”三个view
    for(int i=0;i<buttonImageArray.count;i++)
    {
        NSLog(@"buttonImageArray.count的值是%lu",(unsigned long)buttonImageArray.count);
        //fistimage是个子view。，_scr是scrollview
        //****这里变量i参与了计算尺寸。所以位子不会重复
        //for循环里可以循环多个ui控件？不会覆盖?
        firstImage=[[UIView alloc] initWithFrame:CGRectMake(10*screenWidth/320.0+((self.view.frame.size.width-40*screenWidth/320.0)/3+10*screenWidth/320.0)*i, _scr.frame.origin.y+_scr.frame.size.height+5*screenWidth/320.0, (self.view.frame.size.width-40*screenWidth/320.0)/3, (self.view.frame.size.width-40*screenWidth/320.0)/3-20*screenWidth/320.0)];
        firstImage.layer.borderColor=[[UIColor lightGrayColor] CGColor];
        firstImage.layer.borderWidth=0.5;
        firstImage.layer.cornerRadius=5;
        firstImage.clipsToBounds=YES;
        //充值View是否接受并响应用户的交互
        firstImage.userInteractionEnabled=YES;
        [scrollview addSubview:firstImage];
        
        //view的logo ImageView，循环3次实现3个，也是有i参与了计算（图标数组）。所以不会重复覆盖。
        UIImageView *firstIm=[[UIImageView alloc] initWithFrame:CGRectMake(firstImage.frame.size.width/3-2.5*screenWidth/320.0, 7.5*screenWidth/320.0, firstImage.frame.size.width/3+5*screenWidth/320.0, firstImage.frame.size.width/3+5*screenWidth/320.0)];
        firstIm.image=[UIImage imageNamed:buttonImageArray[i]];
        firstIm.backgroundColor=[UIColor whiteColor];
        firstIm.layer.cornerRadius=(firstImage.frame.size.width/3+5*screenWidth/320.0)/2;
        firstIm.clipsToBounds=YES;
        //把image加到view里去
        //把cz.png加到uiview里
        [firstImage addSubview:firstIm];
        //单独的给每个加lable
        if(i==0)
        {
            //充值view的lable，click事件在哪？
            UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0, 10*screenWidth/320.0+firstIm.frame.size.height, firstImage.frame.size.width, firstImage.frame.size.height-(12*screenWidth/320.0+firstIm.frame.size.height))];
            label.font=[UIFont systemFontOfSize:14];
            label.text=@"充值";
            label.textAlignment=NSTextAlignmentCenter;
            label.backgroundColor=[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0];
            [firstImage addSubview:label];
            
        }
        if (i==1)
        {
            fanyongLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 10*screenWidth/320.0+firstIm.frame.size.height, firstImage.frame.size.width, firstImage.frame.size.height-(12*screenWidth/320.0+firstIm.frame.size.height))];
            fanyongLabel.text=[NSString stringWithFormat:@"%@元",user.fanYong];
            fanyongLabel.backgroundColor=[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0];
            fanyongLabel.textAlignment=NSTextAlignmentCenter;
            fanyongLabel.font=[UIFont systemFontOfSize:14];
            [firstImage addSubview:fanyongLabel];
        }
        if(i==2)
        {
            UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0, 10*screenWidth/320.0+firstIm.frame.size.height, firstImage.frame.size.width, firstImage.frame.size.height-(12*screenWidth/320.0+firstIm.frame.size.height))];
            label.text=@"提现";
            label.font=[UIFont systemFontOfSize:14];
            label.textAlignment=NSTextAlignmentCenter;
            label.backgroundColor=[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0];
            [firstImage addSubview:label];
        }
        
        UIButton *firstButton=[UIButton buttonWithType:UIButtonTypeCustom];
        //把按钮覆盖到view上面，尺寸和view一样大。点view就是按钮效果
        firstButton.frame=CGRectMake(0,0,firstImage.frame.size.width,firstImage.frame.size.height);
        firstButton.backgroundColor=[UIColor clearColor];
        firstButton.tag=100+i;
        [firstButton addTarget:self action:@selector(firstBtn:) forControlEvents:UIControlEventTouchUpInside];
        [firstImage addSubview:firstButton];
    }//for循环的结尾，未满足3次继续。
    //--------------------------------------------------------
    
    //钱包，积分、金融、pos之家
    changButtonArray=@[@"qianbao@2x",@"jifenpaihangdianji@2x",@"jinronglicaidianji@2x",@"poszhijiandianji@2x"];
    //changSelectButtonArray=@[@"qianbaodianji@2x",@"jifenpaihangdianji@2x",@"jinronglicaidianji@2x",@"poszhijiandianjidianji@2x"];
    for(int j=0;j<changButtonArray.count;j++)
    {
        int h=j/2;
        int v=j%2;
        secongImage=[[UIImageView alloc] initWithFrame:CGRectMake(10*screenWidth/320.0+((self.view.frame.size.width-25*screenWidth/320.0)/2+5*screenWidth/320.0)*v, _scr.frame.origin.y+_scr.frame.size.height+7*screenWidth/320.0+(self.view.frame.size.width-40*screenWidth/320.0)/3-20*screenWidth/320.0+63*screenWidth/320.0*h, (self.view.frame.size.width-25*screenWidth/320.0)/2, 60*screenWidth/320.0)];
        secongImage.image=[UIImage imageNamed:changButtonArray[j]];
        secongImage.userInteractionEnabled=YES;
        [scrollview addSubview:secongImage];
        
        UIButton *secondButton=[UIButton buttonWithType:UIButtonTypeCustom];
        secondButton.frame=CGRectMake(0,0,secongImage.frame.size.width,secongImage.frame.size.height);
        secondButton.tag=200+j;
        secondButton.backgroundColor=[UIColor clearColor];
        [secondButton addTarget:self action:@selector(secongBtn:) forControlEvents:UIControlEventTouchUpInside];
        [secongImage addSubview:secondButton];
    }
    float height=secongImage.frame.size.height+secongImage.frame.origin.y+5*screenWidth/320.0;
    
    
    
    //----------------------------------------------------------
    
    //信用卡还款",@"优享充值",@"二维码",@"分享",
    //@"团购",@"生活缴费",@"去哪儿",@"一元夺宝
    
    
    allButtonArray=@[@"xinyongkahuankuan@2x",@"liuliangbaogoumai@2x",@"erweima@2x",@"fenxiang@2x",@"tuangou@2x",@"shenghuojiaofei@2x",@"qunaerwang@2x",@"yiyuanduobao@2x"];
    titileArray=@[@"信用卡还款",@"优享充值",@"二维码",@"分享",
                  @"团购",@"生活缴费",@"去哪儿",@"一元夺宝"];
    for(int num=0;num<allButtonArray.count;num++)
    {
        int w=num/4;
        int h=num%4;
        thirdView=[[UIView alloc] initWithFrame:CGRectMake(10*screenWidth/320.0+((self.view.frame.size.width-35*screenWidth/320.0)/4+5*screenWidth/320.0)*h,height+ ((self.view.frame.size.width-50*screenWidth/320.0)/4+3*screenWidth/320.0)*w, (self.view.frame.size.width-60*screenWidth/320.0)/4+2.5*screenWidth/320.0, (self.view.frame.size.width-60*screenWidth/320.0)/4)];
        thirdView.backgroundColor=[UIColor whiteColor];
        thirdView.layer.borderColor=[[UIColor grayColor] CGColor];
        thirdView.layer.borderWidth=0.5;
        thirdView.layer.cornerRadius=5;
        thirdView.clipsToBounds=YES;
        thirdView.userInteractionEnabled=YES;
        [scrollview addSubview:thirdView];
        
        UIImageView *thirdImage=[[UIImageView alloc] initWithFrame:CGRectMake(thirdView.frame.size.width/5+2.5*screenWidth/320.0,10*screenWidth/320.0,thirdView.frame.size.width/5*3-2.5*screenWidth/320.0,thirdView.frame.size.width/5*3-2.5*screenWidth/320.0)];
        thirdImage.image=[UIImage imageNamed:allButtonArray[num]];
        [thirdView addSubview:thirdImage];
        
        UILabel *thirdLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, thirdView.frame.size.width/5*3.5, thirdView.frame.size.width, thirdView.frame.size.width/5*1.5)];
        thirdLabel.text=titileArray[num];
        thirdLabel.textAlignment=NSTextAlignmentCenter;
        thirdLabel.textColor=[UIColor blackColor];
        thirdLabel.font=[UIFont systemFontOfSize:12];
        [thirdView addSubview:thirdLabel];
        
        UIButton *thirdButton=[UIButton buttonWithType:UIButtonTypeCustom];
        thirdButton.frame=CGRectMake(0, 0, thirdView.frame.size.width, thirdView.frame.size.height);
        thirdButton.backgroundColor=[UIColor clearColor];
        thirdButton.tag=300+num;
        [thirdButton addTarget:self action:@selector(thirdBtn:) forControlEvents:UIControlEventTouchUpInside];
        [thirdView addSubview:thirdButton];
    }
    
    //    UIView *forthView=[[UIView alloc] initWithFrame:CGRectMake(0, 130*screenWidth/320.0+firstImage.frame.size.height+secongImage.frame.size.height*2+thirdView.frame.size.height*2, allView.frame.size.width, 40*screenWidth/320.0)];
    //    forthView.backgroundColor=[UIColor redColor];
    //    [scrollview addSubview:forthView];
    
    scrollview.contentSize=CGSizeMake(self.view.frame.size.width,118*screenWidth/320.0+firstImage.frame.size.height+secongImage.frame.size.height*2+thirdView.frame.size.height*2);
    [allView addSubview:scrollview];
    
    UIView *forthView=[[UIView alloc] initWithFrame:CGRectMake(0, allView.frame.size.height-40*screenWidth/320.0, allView.frame.size.width, 40*screenWidth/320.0)];
    forthView.backgroundColor=[UIColor whiteColor];
    forthView.userInteractionEnabled=YES;
    [allView addSubview:forthView];
    
    for(int m=0;m<3;m++)
    {
        UIButton *fifButton=[UIButton buttonWithType:UIButtonTypeCustom];
        
        [fifButton addTarget:self action:@selector(forthBtn:) forControlEvents:UIControlEventTouchUpInside];
        fifButton.tag=500+m;
        fifButton.backgroundColor=[UIColor whiteColor];
        if(m==0)
        {
            fifButton.frame=CGRectMake(0, 0, (self.view.frame.size.width-50*screenWidth/320.0)/2, forthView.frame.size.height);
            [fifButton setImage:[UIImage imageNamed:@"woyaoshoukuan"] forState:UIControlStateNormal];
            [fifButton setImageEdgeInsets:UIEdgeInsetsMake(3*screenWidth/320.0, 52*screenWidth/320.0, 5*screenWidth/320.0, 52*screenWidth/320.0)];
        }
        if(m==1)
        {
            fifButton.frame=CGRectMake((self.view.frame.size.width-50*screenWidth/320.0)/2, -10*screenWidth/320.0,50*screenWidth/320.0,  50*screenWidth/320.0);
            fifButton.layer.cornerRadius=25*screenWidth/320.0;
            [fifButton setImage:[UIImage imageNamed:@"sys"] forState:UIControlStateNormal];
            [fifButton setImageEdgeInsets:UIEdgeInsetsMake(3*screenWidth/320.0, 3*screenWidth/320.0, 3*screenWidth/320.0, 3*screenWidth/320.0)];
            fifButton.clipsToBounds=YES;
        }
        if(m==2)
        {
            fifButton.frame=CGRectMake((self.view.frame.size.width)/2+25*screenWidth/320.0, 0*screenWidth/320.0,(self.view.frame.size.width-50*screenWidth/320.0)/2,  forthView.frame.size.height);
            [fifButton setImage:[UIImage imageNamed:@"woyaofukuan"] forState:UIControlStateNormal];
            [fifButton setImageEdgeInsets:UIEdgeInsetsMake(3*screenWidth/320.0, 50*screenWidth/320.0, 5*screenWidth/320.0, 50*screenWidth/320.0)];
            
        }
        [forthView addSubview:fifButton];
    }
    
    
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan:)];
    [allView addGestureRecognizer:pan];
    
    
    //分享弹出框
    shareView=[[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 180*screenWidth/320.0)];
    shareView.backgroundColor=[UIColor whiteColor];
    shareView.userInteractionEnabled=YES;
    [self.view addSubview:shareView];
    UIView *shareLineView=[[UIView alloc] initWithFrame:CGRectMake(0, 7.5*screenWidth/320.0, self.view.frame.size.width, 0.5*screenWidth/320.0)];
    shareLineView.backgroundColor=[UIColor grayColor];
    [shareView addSubview:shareLineView];
    
    UILabel *shareLabel=[[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-20*screenWidth/320.0, 0, 40*screenWidth/320.0, 15*screenWidth/320.0)];
    shareLabel.text=@"分享";
    shareLabel.backgroundColor=[UIColor whiteColor];
    shareLabel.textAlignment=NSTextAlignmentCenter;
    shareLabel.font=[UIFont systemFontOfSize:14];
    [shareView addSubview:shareLabel];
    
    //分享列表
    NSArray *shareImageArray=@[@"weixinShare",@"QQShare",@"duanxinShare",@"erweimaShare"];
    NSArray *shareTitileArray=@[@"微信",@"QQ",@"短信",@"二维码"];
    
    for(int n=0;n<shareImageArray.count;n++)
    {
        UIImageView *shareImage=[[UIImageView alloc] initWithFrame:CGRectMake(25*screenWidth/320.0+75*screenWidth/320.0*n, 40*screenWidth/320.0, 45*screenWidth/320.0, 45*screenWidth/320.0)];
        shareImage.image=[UIImage imageNamed:shareImageArray[n]];
        [shareView addSubview:shareImage];
        
        UILabel *shareTitileLabel=[[UILabel alloc] initWithFrame:CGRectMake(25*screenWidth/320.0+75*screenWidth/320.0*n, 85*screenWidth/320.0, 45*screenWidth/320.0, 20*screenWidth/320.0)];
        shareTitileLabel.textAlignment=NSTextAlignmentCenter;
        shareTitileLabel.text=shareTitileArray[n];
        shareTitileLabel.font=[UIFont systemFontOfSize:13*screenWidth/320.0];
        [shareView addSubview:shareTitileLabel];
        
        UIButton *shareSelectButton=[UIButton buttonWithType:UIButtonTypeCustom];
        shareSelectButton.frame=CGRectMake(15*screenWidth/320.0+75*screenWidth/320.0*n, 25*screenWidth/320.0,65*screenWidth/320.0, 100*screenWidth/320.0);
        shareSelectButton.tag=1000+n;
        shareSelectButton.backgroundColor=[UIColor clearColor];
        [shareSelectButton addTarget:self action:@selector(shareSelect:) forControlEvents:UIControlEventTouchUpInside];
        [shareView addSubview:shareSelectButton];
    }
    //取消分享
    UIButton *cancelButton=[UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame=CGRectMake(30*screenWidth/320.0, 140*screenWidth/320.0,self.view.frame.size.width-60*screenWidth/320.0, 30*screenWidth/320.0);
    cancelButton.backgroundColor=[UIColor whiteColor];
    cancelButton.layer.borderColor=[[UIColor colorWithRed:0.09 green:0.48 blue:0.7 alpha:1.0] CGColor];
    cancelButton.layer.borderWidth=2;
    cancelButton.layer.cornerRadius=3;
    cancelButton.clipsToBounds=YES;
    [cancelButton setTitle:@"取消分享" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor colorWithRed:0.09 green:0.48 blue:0.7 alpha:1.0] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelBtn) forControlEvents:UIControlEventTouchUpInside];
    [shareView addSubview:cancelButton];
    
    fanyongView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    fanyongView.userInteractionEnabled=YES;
    fanyongView.backgroundColor=[UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.7];
    [self.view addSubview:fanyongView];
    
    UIImageView *fanyongImage=[[UIImageView alloc] initWithFrame:CGRectMake(20*screenWidth/320.0, 80*screenWidth/320.0, self.view.frame.size.width-40*screenWidth/320.0, self.view.frame.size.height-160*screenWidth/320.0)];
    fanyongImage.image=[UIImage imageNamed:@"fanyongGZ.png"];
    [fanyongView addSubview:fanyongImage];
    
    
    UIButton *guanbiButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [guanbiButton setImage:[UIImage imageNamed:@"guanbi@2x.png"] forState:UIControlStateNormal];
    guanbiButton.frame=CGRectMake(self.view.frame.size.width-40*screenWidth/320.0, 30*screenWidth/320.0, 20*screenWidth/320.0, 20*screenWidth/320.0);
    [guanbiButton addTarget:self action:@selector(guanbiBtn) forControlEvents:UIControlEventTouchUpInside];
    [fanyongView addSubview:guanbiButton];
    
}
-(void)guanbiBtn
{
    fanyongView.hidden=YES;
}
#pragma mark  退出登陆
-(void)exitBtn
{
    UIAlertView *alert= [[UIAlertView alloc]initWithTitle:@"确认退出" message:@"确认是否退出系统！" delegate:self cancelButtonTitle:@"暂不退出" otherButtonTitles:@"退出",nil];
    alert.delegate=self;
    alert.tag=200;
    [alert show];
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(!buttonIndex)
    {
        
    }
    else
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

-(void)forthBtn:(UIButton *)forth
{
    switch (forth.tag) {
        case 500:
        {
            ShouKuanViewController *svc=[[ShouKuanViewController alloc] init];
            [self.navigationController pushViewController:svc animated:YES];
            break;
        }
            
        case 501:
        {
            saoYSViewController *svc=[[saoYSViewController alloc] init];
            [self.navigationController pushViewController:svc animated:YES];
            break;
        }
        case 502:
        {
            ZhuanZhangViewController *zvc=[[ZhuanZhangViewController alloc] init];
            [self.navigationController pushViewController:zvc animated:YES];
            break;
        }
        default:
            break;
    }
}
#pragma mark  分享菜单
-(void)shareSelect:(UIButton *)shareBtn
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
    [self cancelBtn];
}
#pragma mark  隐藏分享弹出框
-(void)cancelBtn
{
    [UIView animateWithDuration:0.2 animations:^{
        shareView.transform = CGAffineTransformScale(CGAffineTransformIdentity,1,1);
        shareView.center = CGPointMake(self.view.frame.size.width/2,self.view.frame.size.height+90*screenWidth/320.0);
        
    } completion:^(BOOL finished) {
        isShare=NO;
    }];
    
    
}
- (void) handlePan: (UIPanGestureRecognizer *)rec
{
    [self cancelBtn];
    User *user=[User currentUser];
    CGFloat transX = [rec translationInView:allView].x;
    if(transX>0)
    {
        yueLabel.text=user.yu;
        [UIView animateWithDuration:0.2 animations:^{
            allView.transform = CGAffineTransformScale(CGAffineTransformIdentity,0.8,0.8);
            allView.center = CGPointMake(340*screenWidth/320.0,300*screenWidth/320.0);
            allView.layer.borderColor=[[UIColor grayColor] CGColor];
            allView.layer.borderWidth=1;
        } completion:^(BOOL finished) {
            isClicked=YES;
            swipView=[[UIView alloc] initWithFrame:CGRectMake(0, 44*screenWidth/320.0, allView.frame.size.width, allView.frame.size.height+44*screenWidth/320.0)];
            swipView.backgroundColor=[UIColor clearColor];
            swipView.tag=500;
            [allView addSubview:swipView];
            
            //NSLog(@"输出位置为%f",allView.frame.origin.x);
        }];
        
    }
    else
    {
        
        [UIView animateWithDuration:0.2 animations:^{
            allView.transform = CGAffineTransformScale(CGAffineTransformIdentity,1.0,1.0);
            allView.center = CGPointMake(self.view.frame.size.width/2,(self.view.frame.size.height)/2+10*screenWidth/320.0);
            allView.layer.borderColor=[[UIColor clearColor] CGColor];
            allView.layer.borderWidth=1;
        } completion:^(BOOL finished) {
            isClicked=NO;
            for(UIView *subView in [allView subviews])
            {
                if([subView isKindOfClass:[UIView class]]&&subView.tag==500)
                {
                    [subView removeFromSuperview];
                }
            }
            
        }];
        
    }
}
#pragma mark  选择头像
-(void)headBtn
{
    actionSheetCename = [[UIActionSheet alloc]
                         initWithTitle:nil
                         delegate:self
                         cancelButtonTitle:@"取消"
                         destructiveButtonTitle:nil
                         otherButtonTitles:@"拍照", @"从相册选择", nil];
    actionSheetCename.tag = 201;
    actionSheetCename.actionSheetStyle = UIActionSheetStyleDefault;
    [actionSheetCename showInView:self.view];
    
    NSLog(@"选择头像");
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    picker=[[UIImagePickerController alloc]init];
    picker.delegate = self;
    picker.allowsEditing=YES;
    switch (buttonIndex)
    {
        case 0:
        {
            
            if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
            {
                picker.sourceType=UIImagePickerControllerSourceTypeCamera;
                
            }
            else
            {
                return;
            }
        }
            
            break;
        case 1:
        {
            
            if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypePhotoLibrary])
            {
                picker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
                
            }
        }
            
            break;
            
        default:
            return;
            break;
    }
    
    //[self presentModalViewController:picker animated:YES];
    [self presentViewController:picker animated:YES completion:nil];
    
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    //UIImage *image1 = [info objectForKey:UIImagePickerControllerEditedImage];
    
    headImage.image = image;
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        //先把图片转成NSData
        
        UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        NSData *data;
        data = UIImageJPEGRepresentation(image, 0.05);//图片的压缩系数 1为正常大小
        
        //图片保存的路径
        //这里将图片放在沙盒的documents文件夹中
        NSString * DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        
        //文件管理器
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        //把刚刚图片转换的data对象拷贝至沙盒中 并保存为image.png
        [fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
        [fileManager createFileAtPath:[DocumentsPath stringByAppendingString:[NSString stringWithFormat:@"%@%@",@"/image",@".png"]] contents:data attributes:nil];
        
        //得到选择后沙盒中图片的完整路径
        filePath = [[NSString alloc]initWithFormat:@"%@%@%@",DocumentsPath,  @"/image",@".png"];
        NSLog(@"图片路径是%@",filePath);
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self panduan];
    
}
-(void)panduan
{
    //   //把图片上传到服务器
    User * user = [User currentUser];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"merId"] = user.merid;
    NSString *strr = [filePath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    params[@"attachPath"] = strr;
    NSLog(@"输出路径是%@",strr);
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    NSString *headUrlString=[NSString stringWithFormat:@"%@/uploadFaceImg.do",url1];
    [manager POST:headUrlString parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
     {
         [formData appendPartWithFileData:UIImageJPEGRepresentation(headImage.image, 0.05) name:@"attachPath" fileName:[NSString stringWithFormat:@"%@%@",@"image",@".png"] mimeType:@"image/png"];
         
     } success:^(AFHTTPRequestOperation *operation, id responseObject) {
         
         NSLog(@"*----------*****&7&&&7tupian1shangchuanchenggong%@",responseObject);
         NSString *sre = [responseObject objectForKey:@"respDesc"];
         NSLog(@"&&&&&&&&&&&&&%@",sre);
         [self toastResult:sre];
         [self reloadData];
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"%@",error);
         
     }];
    
}

#pragma mark  余额查询
-(void)yueBtn
{
    NSLog(@"点击余额查看");
    QianBaoViewController *qian=[[QianBaoViewController alloc] init];
    [self.navigationController pushViewController:qian animated:YES];
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerdeal:) userInfo:nil repeats:NO];
    
}
#pragma mark  费率信息
-(void)feilvBtn
{
    NSLog(@"查看费率信息");
    //    FeiLvXinXiViewController *fvc=[[FeiLvXinXiViewController alloc] init];
    JinRongChaoShiViewController *fvc=[[JinRongChaoShiViewController alloc] init];
    [self.navigationController pushViewController:fvc animated:YES];
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerdeal:) userInfo:nil repeats:NO];
}
#pragma mark  用户详情
-(void)userBtn
{
    NSLog(@"查看用户详情");
    UserDetailViewController *udvc=[[UserDetailViewController alloc] init];
    [self.navigationController pushViewController:udvc animated:YES];
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerdeal:) userInfo:nil repeats:NO];
}
#pragma 侧滑栏按钮
-(void)AllBtnClick:(UIButton *)AllBtn
{
    //NSLog(@"点击侧滑栏第%ld个按钮",AllBtn.tag-400);
    User *user=[User currentUser];
    switch (AllBtn.tag) {
            //实名认证
        case 400:
        {
            if(![user.sm isEqual:@"S"])
            {
                if([user.sm isEqual:@"I"])
                {
                    [self toastResult:@"审核中,无需再次实名"];
                }
                else
                {
                    ShiMingViewController *svc=[[ShiMingViewController alloc] init];
                    [self.navigationController pushViewController:svc animated:YES];
                }
            }
            else
            {
                [self toastResult:@"已通过实名审核,无需再次实名"];
            }
            
            break;
        }
            //  设置
        case 403:
        {
            SettingViewController *svc=[[SettingViewController alloc] init];
            [self.navigationController pushViewController:svc animated:YES];
            break;
        }
            //  联系客服
        case 402:
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel:4000-383-656"]];
            break;
        }
            // 分享记录
        case 401:
        {
            ShareViewController *tvc=[[ShareViewController alloc] init];
            [self.navigationController pushViewController:tvc animated:YES];
            break;
        }
            // 使用指南
        case 404:
        {
            caozuoGuideViewController *cvc=[[caozuoGuideViewController alloc] init];
            [self.navigationController pushViewController:cvc animated:YES];
            break;
        }
            // 用户协议
        case 405:
        {
            yonghuXYViewController *cvc=[[yonghuXYViewController alloc] init];
            [self.navigationController pushViewController:cvc animated:YES];
            
            break;
        }
            // 关于我们
        case 406:
        {
            aboutUsViewController *cvc=[[aboutUsViewController alloc] init];
            [self.navigationController pushViewController:cvc animated:YES];
            
            break;
        }
        default:
            break;
    }
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerdeal:) userInfo:nil repeats:NO];
}
#pragma mark  所以按钮
-(void)thirdBtn:(UIButton *)third
{
    //NSLog(@"点击了第%ld",third.tag-300);
    [self cancelBtn];
    switch (third.tag)
    {
            //信用卡还款
        case 300:
        {
            [self toastResult:@"暂未开通"];
            break;
        }
            //流量包
        case 301:
        {
            LiuLiangBaoViewController *lvc=[[LiuLiangBaoViewController alloc] init];
            [self.navigationController pushViewController:lvc animated:YES];
            break;
        }
            //二维码
        case 302:
        {
            ErWeiMaViewController *evc=[[ErWeiMaViewController alloc] init];
            [self.navigationController pushViewController:evc animated:YES];
            break;
        }
            //分享
        case 303:
        {
            [self shareViewShow];
            break;
        }
            //团购
        case 304:
        {
            tuangouViewController *tvc=[[tuangouViewController alloc] init];
            [self.navigationController pushViewController:tvc animated:YES];
            //[self toastResult:@"暂未开通"];
            break;
        }
            //生活缴费
        case 305:
        {
            [self toastResult:@"暂未开通"];
            break;
        }
            //去哪儿
        case 306:
        {
            GoWhereViewController *gvc=[[GoWhereViewController alloc] init];
            [self.navigationController pushViewController:gvc animated:YES];
            break;
        }
            //一元夺宝
        case 307:
        {
            [self toastResult:@"暂未开通"];
            break;
        }
            
        default:
            break;
    }
}
#pragma mark  自定义分享弹框
-(void)shareViewShow
{
    if(isShare==NO)
    {
        [UIView animateWithDuration:0.2 animations:^{
            shareView.transform = CGAffineTransformScale(CGAffineTransformIdentity,1,1);
            shareView.center = CGPointMake(self.view.frame.size.width/2,self.view.frame.size.height-90*screenWidth/320.0);
            
        } completion:^(BOOL finished) {
            isShare=YES;
        }];
        
    }
    else
    {
        [UIView animateWithDuration:0.2 animations:^{
            shareView.transform = CGAffineTransformScale(CGAffineTransformIdentity,1,1);
            shareView.center = CGPointMake(self.view.frame.size.width/2,self.view.frame.size.height+90*screenWidth/320.0);
            
        } completion:^(BOOL finished)
         {
             isShare=NO;
         }];
    }
    
}
#pragma mark  充值、返佣、提现
-(void)firstBtn:(UIButton *)first
{
    NSLog(@"点击了第%ld",first.tag-100);
    [self cancelBtn];
    switch (first.tag) {
            //转账
        case 100:
        {
            ChongZhiViewController *zzvc=[[ChongZhiViewController alloc] init];
            [self.navigationController pushViewController:zzvc animated:YES];
            break;
            
        }
            //收款
        case 101:
        {
            FanYongZCViewController *svc=[[FanYongZCViewController alloc] init];
            [self.navigationController pushViewController:svc animated:YES];
            break;
            
        }
            //扫一扫
        case 102:
        {
            nextTixianViewController *svc=[[nextTixianViewController alloc] init];
            [self.navigationController pushViewController:svc animated:YES];
            break;
            
        }
        default:
            break;
    }
}
#pragma mark  钱包，积分、金融、pos之家
-(void)secongBtn:(UIButton *)second
{
    // NSLog(@"点击了第%ld",second.tag-200);
    [self cancelBtn];
    switch (second.tag)
    {//钱包
        case 200:
        {
            //多多通讯
            DuoDuoTongXunViewController *qvc=[[DuoDuoTongXunViewController alloc] init];
            [self.navigationController pushViewController:qvc animated:YES];
            break;
        }
            //积分排行
        case 201:
        {
            //            JiFenViewController *jvc=[[JiFenViewController alloc] init];
            //            [self.navigationController pushViewController:jvc animated:YES];
            paihangViewController *pvc=[[paihangViewController alloc] init];
            [self.navigationController pushViewController:pvc animated:YES];
            break;
        }
            //金融理财
        case 202:
        {
            
            jIRongLiCaiViewController *jvc=[[jIRongLiCaiViewController alloc] init];
            [self.navigationController pushViewController:jvc animated:YES];
            
            //[self toastResult:@"暂未开通"];
            break;
        }
            //POS之家
        case 203:
        {
            PSOViewController *pvc=[[PSOViewController alloc] init];
            [self.navigationController pushViewController:pvc animated:YES];
            break;
        }
            
        default:
            break;
    }
}
#pragma mark  循环滚动
-(void)timerDeal:(NSTimer *)time
{
    CGPoint newpoint=_scr.contentOffset;
    newpoint.x+=self.view.frame.size.width;
    if(newpoint.x>=self.view.frame.size.width*(imageArray.count+1))
    {
        //newpoint.origin.x=0;
        newpoint.x=self.view.frame.size.width;
    }
    _scr.contentOffset=newpoint;
    
    
}
//scrollview委托函数
- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    CGFloat pagewidth = _scr.frame.size.width;
    int page = floor((_scr.contentOffset.x - pagewidth/(imageArray.count+2))/pagewidth)+1;
    page--;  // 默认从第二页开始
    pageControl.currentPage = page;
}

// scrollview 委托函数
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pagewidth = _scr.frame.size.width;
    int currentPage = floor((_scr.contentOffset.x - pagewidth/ (imageArray.count+2))/pagewidth) + 1;
    if (currentPage == 0)
    {
        // 序号0 最后1页
        [_scr scrollRectToVisible:CGRectMake(320 * imageArray.count, 0, 320, 110) animated:NO];
    }
    else if (currentPage == (imageArray.count+1))
    {
        // 最后+1,循环第1页
        [_scr scrollRectToVisible:CGRectMake( self.view.frame.size.width, 0, self.view.frame.size.width, 110*screenWidth/320.0) animated:NO];
    }
}

//pagecontrol事件处理方法
- (void)turnPage
{
    //获取当前的page
    long page = pageControl.currentPage;
    //触摸pagecontroller那个圆点往后翻一页 +1
    [_scr scrollRectToVisible:CGRectMake(self.view.frame.size.width * (page + 1),0,self.view.frame.size.width,110*screenWidth/320.0) animated:NO];
}
#pragma mark  循环滚动
-(void)timerdeal:(NSTimer *)time1
{
    [[NSNotificationCenter defaultCenter ] postNotificationName:@"leftBtn" object:nil];
    
}
-(void)reloadData
{
    User *user=[User currentUser];
    
    //余额
    NSMutableURLRequest *rever = [PostAsynClass postAsynWithURL:url1 andInterface:url13 andKeyArr:@[@"merId",@"acctType"]andValueArr:@[user.merid,@"PAY0"]];
    //
    NSData *receive = [NSURLConnection sendSynchronousRequest:rever returningResponse:nil error:nil];
    
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString  *str = [[NSString alloc] initWithData:receive encoding:enc];
    
    NSData *ata = [NSData alloc];
    
    ata = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:ata options:NSJSONReadingMutableLeaves error:nil];
    if ([[dic objectForKey:@"respCode"] isEqualToString:@"008"])
    {
        
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"未登录或登录失效，请重新登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
        alertView.tag=2;
        return;
    }
    
    user.yu=[dic objectForKey:@"acctBal"];
    user.KYyue=[dic objectForKey:@"avlBal"];
    NSLog(@"yu e%@",dic);
    
    
    //返佣
    NSMutableURLRequest *rever1 = [PostAsynClass postAsynWithURL:url1 andInterface:url13 andKeyArr:@[@"merId",@"acctType"]andValueArr:@[user.merid,@"RATE"]];
    //
    NSData *receive1 = [NSURLConnection sendSynchronousRequest:rever1 returningResponse:nil error:nil];
    
    NSStringEncoding enc1 = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    
    NSString  *str1 = [[NSString alloc] initWithData:receive1 encoding:enc1];
    
    NSData *ata1 = [NSData alloc];
    
    ata1 = [str1 dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:ata1 options:NSJSONReadingMutableLeaves error:nil];
    if ([[dic1 objectForKey:@"respCode"] isEqualToString:@"008"])
    {
        
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"未登录或登录失效，请重新登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
        alertView.tag=2;
        return;
    }
    
    user.fanYong=[dic1 objectForKey:@"acctBal"];
    NSLog(@"fanyong%@",dic1);
    //    //积分
    NSMutableURLRequest *rever2 = [PostAsynClass postAsynWithURL:url1 andInterface:url13 andKeyArr:@[@"merId",@"acctType"]andValueArr:@[user.merid,@"JF00"]];
    //
    NSData *receive2 = [NSURLConnection sendSynchronousRequest:rever2 returningResponse:nil error:nil];
    
    NSStringEncoding enc2 = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    
    NSString  *str2 = [[NSString alloc] initWithData:receive2 encoding:enc2];
    
    NSData *ata2 = [NSData alloc];
    
    ata2 = [str2 dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *dic2 = [NSJSONSerialization JSONObjectWithData:ata2 options:NSJSONReadingMutableLeaves error:nil];
    if ([[dic2 objectForKey:@"respCode"] isEqualToString:@"008"])
    {
        
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"未登录或登录失效，请重新登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
        alertView.tag=2;
        return;
    }
    
    user.jiFen=[dic2 objectForKey:@"acctBal"];
    int a = [user.jiFen intValue];
    user.jiFen=[NSString stringWithFormat:@"%d",a];
    NSLog(@"jifen%@",dic2);
    //详情
    
    NSMutableURLRequest *rever3 = [PostAsynClass postAsynWithURL:url1 andInterface:url11 andKeyArr:@[@"merId",@"loginId"]andValueArr:@[user.merid,user.phoneText]];
    //
    NSData *receive3 = [NSURLConnection sendSynchronousRequest:rever3 returningResponse:nil error:nil];
    
    NSStringEncoding enc3 = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    
    NSString  *str3 = [[NSString alloc] initWithData:receive3 encoding:enc3];
    
    NSData *ata3 = [NSData alloc];
    
    ata3 = [str3 dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *_dic3= [NSJSONSerialization JSONObjectWithData:ata3 options:NSJSONReadingMutableLeaves error:nil];
    user.totAmtT1=[_dic3 objectForKey:@"totAmtT1"];
    
    NSLog(@"0-0-0-0-0-0-0-0-0-0-0-5%@,%@",_dic3,user.totAmtT1);
    
    user.sm=[_dic3 objectForKey:@"isAuthentication"];
    user.headImage=[_dic3 objectForKey:@"faceImgUrl"];
    [[NSUserDefaults standardUserDefaults] setObject:user.headImage forKey:@"headImage"];
    user.isAuthentication=[_dic3 objectForKey:@"isAuthentication"];
    
    if ([[_dic3 objectForKey:@"isAuthentication"] isEqualToString:@"S"]) {
        user.sm1=@"已绑定";
    }
    else
    {
        
        if ([[_dic3 objectForKey:@"isAuthentication"] isEqualToString:@"I"])
        {
            user.sm1=@"审核中";
        }
        else
        {
            user.sm1=@"未绑定";
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
