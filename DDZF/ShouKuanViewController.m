//
//  ShouKuanViewController.m
//  DDZF
//
//  Created by 王健超 on 15/12/2.
//  Copyright (c) 2015年 wjc. All rights reserved.
//

#import "ShouKuanViewController.h"
#import "Header.h"
#import "MyNavigationBar.h"
#import "User.h"
#import "PostAsynClass.h"
#import "nextShouKuanViewController.h"
@interface ShouKuanViewController ()<UITextFieldDelegate>
{
    UITextField *numTextFiled;
    UITextField *textFiled;
}

@end

@implementation ShouKuanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeNav];
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
    [mnb createMyNavigationBarWithBgImageName:nil andLeftBBIIamgeNames:[NSArray arrayWithObject:@"fanhui.png"] andRightBBIImages:nil andTitle:@"收款" andClass:self andSEL:@selector(bacClick:)];
    [self.view addSubview:mnb];
    
    //状态栏颜色
    UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320*screenWidth/320, 20*screenWidth/320)];
    
    statusBarView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:statusBarView];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
}
-(void)bacClick:(UIButton*)btn
{
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)makeUI
{

    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 75*screenWidth/320.0, self.view.frame.size.width, 80*screenWidth/320.0)];
    view.backgroundColor=[UIColor whiteColor];
    view.userInteractionEnabled=YES;
    [self.view addSubview:view];
    
    NSArray *titileArray=@[@"收款金额",@"收款说明"];
    for(int i=0;i<2;i++)
    {
        UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(20*screenWidth/320.0, 5*screenWidth/320.0+40*screenWidth/320.0*i, 65*screenWidth/320.0, 30*screenWidth/320.0)];
        label.text=titileArray[i];
        label.textAlignment=NSTextAlignmentLeft;
        label.font=[UIFont systemFontOfSize:14*screenWidth/320.0];
        [view addSubview:label];
        
        if(i==0)
        {
            numTextFiled=[[UITextField alloc] initWithFrame:CGRectMake(label.frame.size.width+label.frame.origin.x+5*screenWidth/320.0, 5*screenWidth/320.0+40*screenWidth/320.0*i, 120*screenWidth/320.0, 30*screenWidth/320.0)];
            numTextFiled.delegate=self;
            numTextFiled.placeholder=@"请输入收款金额";
            numTextFiled.keyboardType=UIKeyboardTypeDecimalPad;
            [view addSubview:numTextFiled];
        }
        if(i==1)
        {
            textFiled=[[UITextField alloc] initWithFrame:CGRectMake(label.frame.size.width+label.frame.origin.x+5*screenWidth/320.0, 5*screenWidth/320.0+40*screenWidth/320.0*i, 120*screenWidth/320.0, 30*screenWidth/320.0)];
            textFiled.delegate=self;
            textFiled.placeholder=@"请输入收款说明";
            textFiled.text=@"货款";
            textFiled.textColor=[UIColor grayColor];
            [view addSubview:textFiled];
        }
        
    }
    UIView *lineView=[[UIView alloc] initWithFrame:CGRectMake(0, 40*screenWidth/320.0, self.view.frame.size.width, 0.4)];
    lineView.backgroundColor=[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0];
    [view addSubview:lineView];
    
    UIButton *nextButton=[UIButton buttonWithType:UIButtonTypeCustom];
    nextButton.frame=CGRectMake(20*screenWidth/320.0, view.frame.origin.y+view.frame.size.height+25*screenWidth/320.0, self.view.frame.size.width-40*screenWidth/320.0, 30*screenWidth/320.0);
    [nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    [nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    nextButton.backgroundColor=[UIColor colorWithRed:0.19 green:0.8 blue:0.0 alpha:1.0];
    [nextButton addTarget:self action:@selector(nextBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextButton];
}
#pragma mark  下一步
-(void)nextBtn
{
    if(numTextFiled.text==nil||numTextFiled.text.length<=0)
    {
        [self toastResult:@"请输入交易金额"];
        return;
    }
    if(textFiled.text==nil||textFiled.text.length>=20)
    {
        [self toastResult:@"请确认收款说明在0~20个字符内"];
        return;
    }
    NSString *str1 = [textFiled.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *string=[NSString stringWithFormat:@"%.2f",[numTextFiled.text doubleValue]];
    nextShouKuanViewController *skevc=[[nextShouKuanViewController alloc] init];
    skevc.numString=string;
    skevc.textString=str1;
    [self.navigationController pushViewController:skevc animated:YES];
}
#pragma mark  回缩键盘
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [numTextFiled resignFirstResponder];
    [textFiled resignFirstResponder];
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
