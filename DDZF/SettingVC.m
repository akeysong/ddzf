//
//  SettingVC.m
//  DDZF
//
//  Created by mac on 16/3/23.
//  Copyright (c) 2016年 wjc. All rights reserved.
//

#import "SettingVC.h"
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
@interface SettingVC ()<UIActionSheetDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UIImagePickerControllerDelegate>{


    UIImageView *headImage;
    
UILabel *yueLabel;
    UILabel *fanyongLabel;
    
    UIImagePickerController *picker;
    UIActionSheet *actionSheetCename;


}

@end

@implementation SettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self MakeSettingUI];
    [self makeNav];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)makeNav
{
    //导航
    //状态栏颜色
    UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320*screenWidth/320, 22*screenWidth/320)];

    statusBarView.backgroundColor=[UIColor redColor];
    [self.view addSubview:statusBarView];

    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];

    MyNavigationBar *SettingNav = [[MyNavigationBar alloc] init];
    SettingNav.frame = CGRectMake(0, 0*screenWidth/320, self.view.frame.size.width, 44*screenWidth/320);
    [SettingNav createMyNavigationBarWithBgImageName:nil andLeftBBIIamgeNames:nil andRightBBIImages:nil andTitle:@"设置" andClass:self andSEL:nil];
    [self.view addSubview:SettingNav];

    self.view.backgroundColor=[UIColor colorWithRed:0/255.0 green:58/255.0 blue:85/255.0 alpha:1.0];
    

}


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
            // 分享
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


-(void)viewWillAppear:(BOOL)animated
{
    User *user=[User currentUser];
    fanyongLabel.text=[NSString stringWithFormat:@"%@元",user.fanYong];
    yueLabel.text=user.yu;
    
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


#pragma mark 提示框
-(void)toastResult:(NSString *) toastMsg{
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:toastMsg
                          message:nil
                          delegate:self
                          cancelButtonTitle:@"确定"
                          otherButtonTitles:nil];
    [alert show];
}


-(void)MakeSettingUI
{
    //头像资料，加id,加费率。。。
    //侧滑的用户信息－－－－－－－－－－－－－－－－－－－－－－－－－－
    
        User *user=[User currentUser];
        headImage=[[UIImageView alloc] initWithFrame:CGRectMake(20*screenWidth/320.0, 40*screenWidth/320.0, 60*screenWidth/320.0, 60*screenWidth/320.0)];
    
    NSLog(@"头像按钮的x坐标是%f",20*screenWidth/320.0);
   NSLog(@"头像按钮的y坐标是%f",40*screenWidth/320.0);
    NSLog(@"头像按钮的宽坐标是%f",60*screenWidth/320.0);
    NSLog(@"头像按钮的高坐标是%f",60*screenWidth/320.0);
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
    //参照物
        UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(headImage.frame.origin.x+headImage.frame.size.width+10*screenWidth/320.0, headImage.frame.origin.y+5*screenWidth/320.0, 45*screenWidth/320.0, 20*screenWidth/320.0)];
    
    NSLog(@"label按钮的x坐标是%f",headImage.frame.origin.x+headImage.frame.size.width+10*screenWidth/320.0);
   NSLog(@"label按钮的y坐标是%f",headImage.frame.origin.y+5*screenWidth/320.0);
    NSLog(@"label按钮的宽坐标是%f",45*screenWidth/320.0);
    NSLog(@"label按钮的高坐标是%f",20*screenWidth/320.0);

    
    label.text=user.name;
        label.textColor=[UIColor whiteColor];
        label.textAlignment=NSTextAlignmentLeft;
        label.font=[UIFont systemFontOfSize:13*screenWidth/320.0];
        [self.view addSubview:label];
    
        //UILabel *phoneNumLabel=[[UILabel alloc] initWithFrame:CGRectMake(label.frame.origin.x, label.frame.origin.y+label.frame.size.height+5*screenWidth/320.0, 100*screenWidth/320.0, 20*screenWidth/320.0)];
    
    UILabel *phoneNumLabel=[[UILabel alloc] initWithFrame:CGRectMake(label.frame.origin.x, label.frame.origin.y+label.frame.size.height+5*screenWidth/320.0, 100*screenWidth/320.0, 20*screenWidth/320.0)];

    NSLog(@"phoneNumLabel按钮的x坐标是%f",label.frame.origin.x);
    NSLog(@"phoneNumLabel按钮的y坐标是%f",label.frame.origin.y+label.frame.size.height+5*screenWidth/320.0);
    NSLog(@"phoneNumLabel按钮的宽坐标是%f",100*screenWidth/320.0);
    NSLog(@"phoneNumLabel按钮的高坐标是%f",20*screenWidth/320.0);

    
    NSString *str=user.phoneText;
        NSRange range=NSMakeRange(3, 4);
        phoneNumLabel.text=[NSString stringWithFormat:@"%@",[str stringByReplacingCharactersInRange:range withString:@"****"]];
        phoneNumLabel.textColor=[UIColor whiteColor];
        phoneNumLabel.font=[UIFont systemFontOfSize:14*screenWidth/320.0];
        phoneNumLabel.textAlignment=NSTextAlignmentLeft;
        [self.view addSubview:phoneNumLabel];
    
        UIButton *userButton=[UIButton buttonWithType:UIButtonTypeCustom];
        userButton.frame=CGRectMake(label.frame.origin.x+label.frame.size.width, label.frame.origin.y, 40*screenWidth/320.0, label.frame.size.height);
        [userButton setImage:[UIImage
                              //用户小字按钮
                              imageNamed:@"yonghu@2x.png"] forState:UIControlStateNormal];
        [userButton addTarget:self action:@selector(userBtn) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:userButton];
    
        //钱包18624089620
        UILabel *qianbaoLabel=[[UILabel alloc] initWithFrame:CGRectMake(headImage.frame.origin.x, headImage.frame.origin.y+headImage.frame.size.height+12*screenWidth/320.0, 40*screenWidth/320.0, 18*screenWidth/320.0)];
    
    NSLog(@"qianbaoLabel按钮的x坐标是%f",headImage.frame.origin.y+headImage.frame.size.height+12*screenWidth/320.0);
    NSLog(@"qianbaoLabel按钮的y坐标是%f",label.frame.origin.y+label.frame.size.height+5*screenWidth/320.0);
    NSLog(@"qianbaoLabel按钮的宽坐标是%f",40*screenWidth/320.0);
    NSLog(@"qianbaoLabel按钮的高坐标是%f",20*screenWidth/320.0);
    

    
    
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
        [feilvButton addTarget:self action:@selector(EarnButtom) forControlEvents:UIControlEventTouchUpInside];
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
    //以上是头像信息
    //----------------------------------------------------
    
   // 以下是设置的ui
    //155
        NSArray *SettingTitileArray=@[@"实名认证",@"分享",@"在线客服",@"设置",@"使用指南",@"用户协议",@"关于我们"];
        NSArray *SettingTitileArrayTwo=@[@"分享",@"在线客服",@"设置",@"使用指南",@"用户协议",@"关于我们"];
        NSArray *cehuaImageArray=@[@"shimingrenzheng@2x.png",@"fenxiangjilu@2x.png",@"lianxikefu@2x.png",@"shezhi@2x.png",@"shiyongzhinan@2x.png",@"yonghuxieyi@2x.png",@"guanyuwomen@2x.png"];
        NSArray *cehuaImageArray1=@[@"fenxiangjilu@2x.png",@"lianxikefu@2x.png",@"shezhi@2x.png",@"shiyongzhinan@2x.png",@"yonghuxieyi@2x.png",@"guanyuwomen@2x.png"];
        if([user.sm isEqualToString:@"S"])
        {
            for(int j=0;j<SettingTitileArrayTwo.count;j++)
    
            {
                UIImageView *image=[[UIImageView alloc] initWithFrame:CGRectMake(20*screenWidth/320.0, 162*screenWidth/320.0+40*screenWidth/320.0*j, 20*screenWidth/320.0, 20*screenWidth/320.0)];
                image.image=[UIImage imageNamed:cehuaImageArray1[j]];
                [self.view addSubview:image];
    
                UILabel *titileLabel=[[UILabel alloc] initWithFrame:CGRectMake(45*screenWidth/320.0, 158*screenWidth/320.0+40*screenWidth/320.0*j, 100*screenWidth/320.0, 30*screenWidth/320.0)];
                titileLabel.textAlignment=NSTextAlignmentLeft;
                titileLabel.font=[UIFont systemFontOfSize:14];
                titileLabel.textColor=[UIColor whiteColor];
                titileLabel.text=SettingTitileArrayTwo[j];
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
            for(int j=0;j<SettingTitileArray.count;j++)
    
            {
                UIImageView *image=[[UIImageView alloc] initWithFrame:CGRectMake(20*screenWidth/320.0, 162*screenWidth/320.0+40*screenWidth/320.0*j, 20*screenWidth/320.0, 20*screenWidth/320.0)];
                image.image=[UIImage imageNamed:cehuaImageArray[j]];
                [self.view addSubview:image];
    
                UILabel *titileLabel=[[UILabel alloc] initWithFrame:CGRectMake(45*screenWidth/320.0, 158*screenWidth/320.0+40*screenWidth/320.0*j, 100*screenWidth/320.0, 30*screenWidth/320.0)];
                titileLabel.textAlignment=NSTextAlignmentLeft;
                titileLabel.font=[UIFont systemFontOfSize:14];
                titileLabel.textColor=[UIColor whiteColor];
                titileLabel.text=SettingTitileArray[j];
                [self.view addSubview:titileLabel];
    
                UIImageView *jiantou=[[UIImageView alloc] initWithFrame:CGRectMake(195*screenWidth/320.0, 165*screenWidth/320.0+40*screenWidth/320.0*j, 10*screenWidth/320.0, 12*screenWidth/320.0)];
                if(j==2)
                {
                    jiantou.image=nil;
                    UILabel *kefu=[[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width-230*screenWidth/320.0, 158*screenWidth/320.0+40*screenWidth/320.0*j, 100*screenWidth/320.0, 30*screenWidth/320.0)];
                    kefu.text=@"027-88888888";
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
    //
    //以上是侧滑setting设置ui
    //---------------------------------------------------------
    
}
#pragma 退出
-(void)exitBtn
{
    UIAlertView *alert= [[UIAlertView alloc]initWithTitle:@"确认退出" message:@"确认是否退出系统！" delegate:self cancelButtonTitle:@"暂不退出" otherButtonTitles:@"退出",nil];
    alert.delegate=self;
    alert.tag=200;
    [alert show];
    
}


#pragma mark  我要赚钱
-(void)EarnButtom
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

#pragma mark  循环滚动
-(void)timerdeal:(NSTimer *)time1
{
    [[NSNotificationCenter defaultCenter ] postNotificationName:@"leftBtn" object:nil];
    
}

@end

