//
//  newMainVCViewController.m
//  DDZF
//
//  Created by mac on 16/3/23.
//  Copyright (c) 2016年 wjc. All rights reserved.
//

#import "newMainVCViewController.h"
#import "ChongZhiViewController.h"
#import "nextChongZhiJLViewController.h"
#import "nextTixianViewController.h"
#import "saoYSViewController.h"
#import "erweimaFenxiangViewController.h"
//#import "User.h"
//
//#import "PostAsynClass.h"
//#import "UIImageView+WebCache.h"
//
//#import "aboutUsViewController.h"
//#import "caozuoGuideViewController.h"
//
//#import "ShiMingViewController.h"
//#import "FeiLvXinXiViewController.h"
//#import "UserDetailViewController.h"
//#import "saoYSViewController.h"
//#import "DuoDuoTongXunViewController.h"
//#import "jIRongLiCaiViewController.h"
//#import "JinRongChaoShiViewController.h"
//#import "PSOViewController.h"
//#import "ShouKuanViewController.h"
//#import "ZhuanZhangViewController.h"
//#import "LiuLiangBaoViewController.h"
//#import "paihangViewController.h"
//#import "YiYuanDuoBaoViewController.h"
//#import "ShengHuoJiaoFeiViewController.h"
//#import "GoWhereViewController.h"
//#import "ShareViewController.h"
//#import "QianBaoViewController.h"
//#import "JiFenViewController.h"
//#import <ShareSDK/ShareSDK.h>
//#include <TencentOpenAPI/QQApiInterface.h>
//#import <TencentOpenAPI/TencentApiInterface.h>
//#import "WXApi.h"
//#import <AVFoundation/AVFoundation.h>
//#import "AFHTTPRequestOperationManager.h"
//#import "AFURLResponseSerialization.h"
//#import "AFHTTPRequestOperation.h"
//#import "erweimaFenxiangViewController.h"
//#import "TongZhiViewController.h"
//#import "ErWeiMaViewController.h"
//#import "tuangouViewController.h"
//#import "ChongZhiViewController.h"
//#import "nextTixianViewController.h"
//#import "FanYongZCViewController.h"
@interface newMainVCViewController ()<UIScrollViewDelegate>
@property (strong, nonatomic) IBOutlet UIScrollView *Main_scrollView;
@property (strong, nonatomic) IBOutlet UIPageControl *Main_pageControl;

- (IBAction)recharge:(id)sender;//充值

- (IBAction)camera:(id)sender;//扫一扫

//
- (IBAction)draw:(id)sender;//提现

@property (nonatomic, strong) NSTimer *Main_timer;

- (IBAction)myCard_Button:(id)sender;

- (IBAction)myLoans_Button:(id)sender;

- (IBAction)myFanacal_Button:(id)sender;

- (IBAction)myYiyuan_Button:(id)sender;

- (IBAction)myBonus_points_Button:(id)sender;

- (IBAction)myRake_back_Button:(id)sender;

- (IBAction)myBonus_Shop_Button:(id)sender;

- (IBAction)myAgency_Button:(id)sender;

- (IBAction)myVIPhome_Button:(id)sender;

- (IBAction)myQRcodes_Button:(id)sender;

- (IBAction)myMore_button:(id)sender;

@end


@implementation newMainVCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
  
    
    
    
    int count = 5;
    CGSize size = self.Main_scrollView.frame.size;
    
    NSLog(@"self.Main_scrollView.frame.size = %@", NSStringFromCGSize(self.Main_scrollView.frame.size));
    
    
    //1 动态生成5个imageView
    for (int i = 0; i < count; i++) {
        //
        UIImageView *iconView = [[UIImageView alloc] init];
        [self.Main_scrollView addSubview:iconView];
        
        NSString *imgName = [NSString stringWithFormat:@"img_%02d",i+1];
        iconView.image = [UIImage imageNamed:imgName];
        
        
        CGFloat x = i * size.width;
        //frame
        iconView.frame = CGRectMake(x, 0, size.width, size.height);
    }
    
    //2 设置滚动范围
    self.Main_scrollView.contentSize = CGSizeMake(count * size.width, 0);
    
    
    self.Main_scrollView.showsHorizontalScrollIndicator = NO;
    //3 设置分页
    self.Main_scrollView.pagingEnabled = YES;
    
    //4 设置pageControl
    self.Main_pageControl.numberOfPages = count;
    
    //5 设置scrollView的代理
    self.Main_scrollView.delegate = self;
    
    //6 定时器
    [self addTimerO];
    //立即执行定时器的方法
    //    [timer fire];
    
    //线程
    //同步  异步
    
    
}

- (void)addTimerO
{
    NSTimer *timer = [NSTimer timerWithTimeInterval:2.0 target:self selector:@selector(nextImage) userInfo:nil repeats:YES];
    self.Main_timer = timer;
    //消息循环
    NSRunLoop *runloop = [NSRunLoop currentRunLoop];
    [runloop addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)nextImage
{
    //当前页码
    NSInteger page = self.Main_pageControl.currentPage;
    
    if (page == self.Main_pageControl.numberOfPages - 1) {
        page = 0;
    }else{
        page++;
    }
    
    //    self.scrollView setContentOffset:<#(CGPoint)#> animated:<#(BOOL)#>
    
    CGFloat offsetX = page * self.Main_scrollView.frame.size.width;
    [UIView animateWithDuration:1.0 animations:^{
        self.Main_scrollView.contentOffset = CGPointMake(offsetX, 0);
    }];
    
}

#pragma mark - scrollView的代理方法
//正在滚动的时候
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //   (offset.x + 100/2)/100
    int page = (scrollView.contentOffset.x + scrollView.frame.size.width / 2)/ scrollView.frame.size.width;
    self.Main_pageControl.currentPage = page;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //停止定时器
    [self.Main_timer invalidate];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self addTimerO];
    //    self.timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(nextImage) userInfo:nil repeats:YES];
}









    
    //首页的三大功能（第三个空指针越界）
    //充值、返佣、提现的图标(在images.xcassets里)
    //buttonImageArray=@[@"cz",@"fy",@"tx"];
    //buttonImageArray=@[@"money",@"RichScan",@"withdraw"];

    /* 九宫格初始Y坐标是373.046875*/
    //allButtonArray=@[@"card",@"loan",@"financial",@"snatch",@"integral",@"commission_discount",@"commission_discount",@"shop",@"tel",@"vip",@"QR_Codes",@"more"];
   // titileArray=@[@"我要办卡",@"我要贷款",@"现财",@"一元夺宝",@"积分",
                //  @"返佣",@"返佣",@"积分商城",@"通讯",@"会员之家",@"我的二维码",@"更
    //--------------------------------------------------------------------------
    



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark  所以按钮

#pragma mark  充值、返佣、提现
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


#pragma mark  隐藏分享弹出框

    




- (IBAction)recharge:(id)sender {
    
    ChongZhiViewController *zzvc=[[ChongZhiViewController alloc] init];
    [self.navigationController pushViewController:zzvc animated:YES];
    /*
    
  
     
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

     
     */
    
    
    
    
}
//扫一扫
- (IBAction)camera:(id)sender {

    saoYSViewController *svc=[[saoYSViewController alloc] init];
    [self.navigationController pushViewController:svc animated:YES];


}
//提现
- (IBAction)draw:(id)sender {
    nextTixianViewController *svc=[[nextTixianViewController alloc] init];
    [self.navigationController pushViewController:svc animated:YES];
    
    
}
- (IBAction)myCard_Button:(id)sender {
    
    [self toastResult:@"我要办卡"];
}

- (IBAction)myLoans_Button:(id)sender {
    [self toastResult:@"我要贷款"];
}

- (IBAction)myFanacal_Button:(id)sender {
    [self toastResult:@"理财"];
}

- (IBAction)myYiyuan_Button:(id)sender {
    [self toastResult:@"一元夺宝"];
}

- (IBAction)myBonus_points_Button:(id)sender {
    [self toastResult:@"积分"];
}

- (IBAction)myRake_back_Button:(id)sender {
[self toastResult:@"反现"];
}

- (IBAction)myBonus_Shop_Button:(id)sender {
    [self toastResult:@"积分商城"];
}

- (IBAction)myAgency_Button:(id)sender {
    [self toastResult:@"通讯"];
}

- (IBAction)myVIPhome_Button:(id)sender {
    [self toastResult:@"会员之家"];
}

- (IBAction)myQRcodes_Button:(id)sender {
    erweimaFenxiangViewController *evc=[[erweimaFenxiangViewController alloc] init];
    [self.navigationController pushViewController:evc animated:YES];
}

- (IBAction)myMore_button:(id)sender {
    [self toastResult:@"更多"];
}
@end
