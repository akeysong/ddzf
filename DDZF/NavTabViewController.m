//
//  NavTabViewController.m
//  DDZF
//
//  Created by mac on 16/3/21.
//  Copyright (c) 2016年 wjc. All rights reserved.
//
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
#import "NavTabViewController.h"
#import "newMainVCViewController.h"
#import "tuangouViewController.h"
#import "GoWhereViewController.h"
#import "ErWeiMaViewController.h"
#import "newMainVCViewController.h"
#import "SettingVC.h"
#import "WalletViewController.h"
#import "ShareViewController.h"
/*
 */
@interface NavTabViewController () <UIAlertViewDelegate>
{
    //主页面四个子导航的类。（界面都在sb里实现，这里面我都注释了。）
//首页
    newMainVCViewController *_mainVc;
//钱包
WalletViewController *_WalletVc;
    

    
ShareViewController *_Share;
    
//二维码
//    ErWeiMaViewController *_ErWeiMaVc;

    
    SettingVC *_SettingVc;
    
    
   // UIBarButtonItem *_addFriendItem;//添加好友的那个加号。
}

@end

@implementation NavTabViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
   
   
    
    // Do any additional setup after loading the view.

    //if 使tabBarController中管理的viewControllers都符合 UIRectEdgeNone(不要边框）
    if ([UIDevice currentDevice].systemVersion.floatValue >= 7) {//如果当前的手机ios大于7
        self.view.backgroundColor = RGBACOLOR(248, 248, 248, 1);
        self.edgesForExtendedLayout = UIRectEdgeNone;//(不要边框）
    
    }
    self.title = NSLocalizedString(@"title.conversation", @"Conversations");
    [self setupSubviews];//加载tabbar的子view
    self.selectedIndex = 0;//mainviewcontroller是一个tabbar，这让他默认是左边第一个子导航


}
#pragma mark - UITabBarDelegate
#pragma mark 四个子导航的view
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    
    if (item.tag == 0) {
        //首页
        NSLog(@"tabbar标签");
        self.title = @"首页";
        self.navigationItem.rightBarButtonItem = nil;
        
        
    }else if (item.tag == 1){
        //钱包
        self.title = @"钱包";
       self.navigationItem.rightBarButtonItem = nil;
    }else if (item.tag == 2){
        //
        self.title = @"分享";
        self.navigationItem.rightBarButtonItem = nil;
        
    
       // [_settingsVC refreshConfig];//重新刷新配置
    }else if(item.tag==3){
        //地图
        self.title = @"我的";
        self.navigationItem.rightBarButtonItem = nil;
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setupSubviews
{
    //tabbar的背景颜色
    self.tabBar.backgroundImage = [[UIImage imageNamed:@"tabbarBackground"] stretchableImageWithLeftCapWidth:50
                                                                                                topCapHeight:25];
    //tabbar的图片
    self.tabBar.selectionIndicatorImage = [[UIImage imageNamed:@"tabbarSelectBg"] stretchableImageWithLeftCapWidth:50 topCapHeight:25];
 //------------------------------------------------------
    //初始化对话子栏，赋值给成员变量。
     _mainVc = [[newMainVCViewController alloc] init];
_mainVc.tabBarItem = [[UITabBarItem alloc] initWithTitle:@""
                                                         image:nil
                                                             tag:0];
    [_mainVc.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"house_blue"]
                        withFinishedUnselectedImage:[UIImage imageNamed:@"house"]];
    
    _mainVc.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    //没选中的tabbar子栏
    [self unSelectedTapTabBarItems:_mainVc.tabBarItem];
    //选中的tabbar子栏
    [self selectedTapTabBarItems:_mainVc.tabBarItem];
    
    
 //--------------------------------------------------------
//    //加开联系人的xib文件？
    //初始化对话子栏，赋值给成员变量。
    _WalletVc = [[WalletViewController alloc] init];
    
    //    //对话子栏的图标及标题
    _WalletVc.tabBarItem = [[UITabBarItem alloc] initWithTitle:@""
                                                       image:nil
                                                         tag:0];
    [_WalletVc.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"wallet_blue"]
                     withFinishedUnselectedImage:[UIImage imageNamed:@"wallet"]];
    _WalletVc.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    //没选中的tabbar子栏
    [self unSelectedTapTabBarItems:_WalletVc.tabBarItem];
    //选中的tabbar子栏
    [self selectedTapTabBarItems:_WalletVc.tabBarItem];
//-----------------------------------------------------------
//    //去哪儿
    //初始化对话子栏，赋值给成员变量。
    _Share = [[ShareViewController alloc] init];
    
    //    //对话子栏的图标及标题
    _Share.tabBarItem = [[UITabBarItem alloc] initWithTitle:@""
                                                       image:nil
                                                         tag:0];
    [_Share.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"share_blue"]
                     withFinishedUnselectedImage:[UIImage imageNamed:@"share"]];
    //没选中的tabbar子栏
    [self unSelectedTapTabBarItems:_Share.tabBarItem];
    //选中的tabbar子栏
    [self selectedTapTabBarItems:_Share.tabBarItem];
//
  _Share.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);//
    //加开联系人的xib文件？
    //初始化对话子栏，赋值给成员变量。
    _SettingVc = [[SettingVC alloc] init];
    
    //    //对话子栏的图标及标题
    _SettingVc.tabBarItem = [[UITabBarItem alloc] initWithTitle:@""
                                                       image:nil
                                                         tag:0];
    [_SettingVc.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"me_blue"]
                        withFinishedUnselectedImage:[UIImage imageNamed:@"me"]];
   _SettingVc.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    //没选中的tabbar子栏
    [self unSelectedTapTabBarItems:_SettingVc.tabBarItem];
    //选中的tabbar子栏
    [self selectedTapTabBarItems:_SettingVc.tabBarItem];
    //
//----------------------------------------------------------
    
    
//    
//    //有几个导航控制器
    self.viewControllers = @[_mainVc,_WalletVc,_Share,_SettingVc];
   
//    //首先显示是的哪一个
    [self selectedTapTabBarItems:_mainVc.tabBarItem];
}


#pragma mark tabbar子栏没被选时
-(void)unSelectedTapTabBarItems:(UITabBarItem *)tabBarItem
{
    [tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                        [UIFont systemFontOfSize:14], UITextAttributeFont,[UIColor whiteColor],UITextAttributeTextColor,
                                        nil] forState:UIControlStateNormal];
}
#pragma mark tabbar子栏被选中时
-(void)selectedTapTabBarItems:(UITabBarItem *)tabBarItem
{
    [tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                        [UIFont systemFontOfSize:14],
                                        UITextAttributeFont,RGBACOLOR(0x00, 0xac, 0xff, 1),UITextAttributeTextColor,
                                        nil] forState:UIControlStateSelected];
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
