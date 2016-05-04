//
//  DuoDuoTongXunViewController.m
//  DDZF
//
//  Created by 王健超 on 16/2/16.
//  Copyright (c) 2016年 wjc. All rights reserved.
//

#import "DuoDuoTongXunViewController.h"
#import "Header.h"
#import "MyNavigationBar.h"
#import "PostAsynClass.h"
#import "User.h"
#import "NSString+Extension.h"
#import "tonghuaTableViewCell.h"
#import "tonghuaListViewController.h"
@interface DuoDuoTongXunViewController ()<UITextFieldDelegate,UIAlertViewDelegate,ABPeoplePickerNavigationControllerDelegate>
{
    UIButton *lastButton;
    NSArray *lastArray;
    NSArray *lastSelectArray;
    NSArray *imageArray;
    UIView *firstView;
    UIView *secondView;
    UIView *thirdView;
    UIView *forthView;
    
    UITextField *tellNUmField;
    UITextField *phoneNum;
    UILabel *moneyLabel;
    
    UITableView *_table;
    NSMutableArray *_dataArr;
    int _pageNum;
    NSArray *_data;

}
@end

@implementation DuoDuoTongXunViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataArr = [NSMutableArray arrayWithCapacity:0];
    _pageNum=1;

    self.view.backgroundColor=[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0];
    
    [self makeNav];
    [self makeUI];
    [self makeView];
    
    [_header free];
    [_footer free];
    // Do any additional setup after loading the view.
}
-(void)makeNav
{
    //导航
    [self.navigationController setNavigationBarHidden:YES];
    MyNavigationBar *mnb = [[MyNavigationBar alloc] init];
    mnb.frame = CGRectMake(0, 20*screenWidth/320, 320*screenWidth/320, 44*screenWidth/320);
    [mnb createMyNavigationBarWithBgImageName:nil andLeftBBIIamgeNames:[NSArray arrayWithObject:@"fanhui.png"] andRightBBIImages:nil andTitle:@"多多通讯" andClass:self andSEL:@selector(bacClick:)];
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
    UIView *topLineView=[[UIView alloc] initWithFrame:CGRectMake(0, 63.2*screenWidth/320.0, self.view.frame.size.width, 0.8*screenWidth/320.0)];
    topLineView.backgroundColor=[UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1.0];
    [self.view addSubview:topLineView];
    
    UIView *buttomView=[[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-49*screenWidth/320.0, self.view.frame.size.width, 49*screenWidth/320.0)];
    buttomView.backgroundColor=[UIColor whiteColor];
    buttomView.userInteractionEnabled=YES;
    [self.view addSubview:buttomView];
    
    UIView *lastLineView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0.8*screenWidth/320.0)];
    lastLineView.backgroundColor=[UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1.0];
    [buttomView addSubview:lastLineView];
    
    lastArray=@[@"ddbh",@"ddjl",@"ddtxl",@"ddzh"];
    lastSelectArray=@[@"ddbhs",@"ddjls",@"ddtxls",@"ddzhs"];
    
    for(int i=0;i<lastSelectArray.count;i++)
    {
        lastButton=[UIButton buttonWithType:UIButtonTypeCustom];
        lastButton.frame=CGRectMake(0+self.view.frame.size.width/4*i, 1*screenWidth/320.0, self.view.frame.size.width/4, 48*screenWidth/320.0);
        if(i==0)
        {
            [lastButton setImage:[UIImage imageNamed:@"ddbhs"] forState:UIControlStateNormal];
        }
        else
        {
            [lastButton setImage:[UIImage imageNamed:lastArray[i]] forState:UIControlStateNormal];
        }
        [lastButton setImageEdgeInsets:UIEdgeInsetsMake(5*screenWidth/320.0, 15*screenWidth/320.0, 5*screenWidth/320.0, 15*screenWidth/320.0)];
        [lastButton addTarget:self action:@selector(lastBtn:) forControlEvents:UIControlEventTouchUpInside];
        lastButton.tag=400+i;
        [buttomView addSubview:lastButton];
        
        if(i<lastSelectArray.count-1)
        {
            UIView *buttomLineView=[[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/4*(i+1), 0, 0.8*screenWidth/320.0, 49*screenWidth/320.0)];
            buttomLineView.backgroundColor=[UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1.0];
            [buttomView addSubview:buttomLineView];
        }
   
    }
}
-(void)telmoneySearch
{
    User *user=[User currentUser];
    
    //余额
    NSMutableURLRequest *rever = [PostAsynClass postAsynWithURL:url1 andInterface:url44 andKeyArr:@[@"merId"]andValueArr:@[user.merid]];
    //
    NSData *receive = [NSURLConnection sendSynchronousRequest:rever returningResponse:nil error:nil];
    
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString  *str = [[NSString alloc] initWithData:receive encoding:enc];
    
    NSData *ata = [NSData alloc];
    
    ata = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:ata options:NSJSONReadingMutableLeaves error:nil];
    if([[dic objectForKey:@"respCode"] isEqualToString:@"000"])
    {
        user.telmoney=[dic objectForKey:@"acctBal"];
        NSLog(@"telmoney yu e%@",dic);
    }
  else  if ([[dic objectForKey:@"respCode"] isEqualToString:@"008"])
    {
        
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"未登录或登录失效，请重新登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
        alertView.tag=2;
        return;
    }
    else
    {
        [self toastResult:[dic objectForKey:@"respDesc"]];
    }
}
-(void)makeView
{
    //拨号
    firstView=[[UIView alloc] initWithFrame:CGRectMake(0, 64*screenWidth/320.0, self.view.frame.size.width, self.view.frame.size.height-113*screenWidth/320.0)];
    firstView.backgroundColor=[UIColor whiteColor];
    firstView.userInteractionEnabled=YES;
    firstView.hidden=NO;
    [self.view addSubview:firstView];
    
    UIView *topView=[[UIView alloc] initWithFrame:CGRectMake(0, 0,self.view.frame.size.width , 120*screenWidth/320.0)];
    topView.backgroundColor=[UIColor greenColor];
    [firstView addSubview:topView];
    
    tellNUmField=[[UITextField alloc] initWithFrame:CGRectMake(0, 70*screenWidth/320.0, self.view.frame.size.width, 50*screenWidth/320.0)];
    tellNUmField.enabled=NO;
    tellNUmField.delegate=self;
    tellNUmField.textColor=[UIColor whiteColor];
    tellNUmField.textAlignment=NSTextAlignmentRight;
    tellNUmField.font=[UIFont systemFontOfSize:30*screenWidth/320.0];
    [topView addSubview:tellNUmField];
    
    float width=self.view.frame.size.width/3;
    float height=(firstView.frame.size.height-120*screenWidth/320.0)/4;
    NSArray *numImageArray=@[@"dd1",@"dd2",@"dd3",
                             @"dd4",@"dd5",@"dd6",
                             @"dd7",@"dd8",@"dd9",
                             @"ddt",@"dd0",@"ddb"];
    for(int i=0;i<numImageArray.count;i++)
    {
        int h=i%3;
        int s=i/3;
        UIView *numView=[[UIView alloc]initWithFrame:CGRectMake(0+width*h, 120*screenWidth/320.0+s*height, width, height)];
        numView.userInteractionEnabled=YES;
        [firstView addSubview:numView];
        
        UIImageView *numImage=[[UIImageView alloc] initWithFrame:CGRectMake(width/6, height/3, width/3*2, height/3)];
        numImage.image=[UIImage imageNamed:numImageArray[i]];
        [numView addSubview:numImage];
        
        UIButton *firstButton=[UIButton buttonWithType:UIButtonTypeCustom];
        firstButton.frame=CGRectMake(0, 0, width, height);
        firstButton.backgroundColor=[UIColor clearColor];
        [firstButton addTarget:self action:@selector(firstBtn:) forControlEvents:UIControlEventTouchUpInside];
        firstButton.tag=100+i;
        [numView addSubview:firstButton];
    }
    for(int j=0;j<3;j++)
    {
        if(j<2)
        {
            UIView *numSLineView=[[UIView alloc] initWithFrame:CGRectMake(width*(j+1), 120*screenWidth/320.0, 0.8*screenWidth/320.0, firstView.frame.size.height-120*screenWidth/320.0)];
            numSLineView.backgroundColor=[UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1.0];
            [firstView addSubview:numSLineView];
 
        }
        UIView *numHLineView=[[UIView alloc] initWithFrame:CGRectMake(0, 120*screenWidth/320.0+height*(j+1), self.view.frame.size.width, 0.8*screenWidth/320.0)];
        numHLineView.backgroundColor=[UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1.0];
        [firstView addSubview:numHLineView];
    }
    //记录
    secondView=[[UIView alloc] initWithFrame:CGRectMake(0, 64*screenWidth/320.0, self.view.frame.size.width, self.view.frame.size.height-113*screenWidth/320.0)];
    secondView.backgroundColor=[UIColor purpleColor];
    secondView.userInteractionEnabled=YES;
    secondView.hidden=YES;
    [self.view addSubview:secondView];
    
    _table= [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, secondView.frame.size.height) style:UITableViewStylePlain];//实例化，两种类型plain、group
    //两个代理
    _table.delegate = self;
    _table.dataSource = self;
    _table.backgroundColor=[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0];
    _table.tableFooterView=[[UIView alloc]init];
    [secondView addSubview:_table];
    
    //实例化header和footer
    _header = [MJRefreshHeaderView header];
    _header.scrollView = _table;
    //设置header和footer的滚动视图为table
    _footer = [MJRefreshFooterView footer];
    _footer.scrollView = _table;
    //设置header和footer的代理
    _header.delegate = self;
    _footer.delegate = self;

    
    //通讯录
    thirdView=[[UIView alloc] initWithFrame:CGRectMake(0, 64*screenWidth/320.0, self.view.frame.size.width, self.view.frame.size.height-113*screenWidth/320.0)];
    thirdView.backgroundColor=[UIColor whiteColor];
    thirdView.userInteractionEnabled=YES;
    thirdView.hidden=YES;
    [self.view addSubview:thirdView];
    
    UIView *threeview=[[UIView alloc] initWithFrame:CGRectMake(20*screenWidth/320.0, 130*screenWidth/320.0, self.view.frame.size.width-40*screenWidth/320.0, 40*screenWidth/320.0)];
    threeview.layer.cornerRadius=3;
    threeview.clipsToBounds=YES;
    threeview.layer.borderColor=[[UIColor lightGrayColor] CGColor];
    threeview.layer.borderWidth=0.5;
    threeview.userInteractionEnabled=YES;
    [thirdView addSubview:threeview];
    
    
    UILabel *nameLabel=[[UILabel alloc] initWithFrame:CGRectMake(10*screenWidth/320.0, 0*screenWidth/320.0, 70*screenWidth/320.0, 40*screenWidth/320.0)];
    nameLabel.text=@"手机号";
    nameLabel.textAlignment=NSTextAlignmentLeft;
    nameLabel.font=[UIFont systemFontOfSize:13];
    [threeview addSubview:nameLabel];
    
    phoneNum=[[UITextField alloc] initWithFrame:CGRectMake(nameLabel.frame.origin.x+nameLabel.frame.size.width+5, 0*screenWidth/320.0, 130*screenWidth/320.0, 40*screenWidth/320.0)];
    phoneNum.textAlignment=NSTextAlignmentLeft;
    phoneNum.font=[UIFont systemFontOfSize:13];
    phoneNum.delegate=self;
    phoneNum.placeholder=@"请输入对方手机号";
    [threeview addSubview:phoneNum];
    
    UIButton *imageButton=[UIButton buttonWithType:UIButtonTypeCustom];
    imageButton.frame=CGRectMake(self.view.frame.size.width-80*screenWidth/320.0, 0, 40*screenWidth/320.0, 40*screenWidth/320.0);
    [imageButton setImage:[UIImage imageNamed:@"tongxunlu@2x.png"] forState:UIControlStateNormal];
    imageButton.imageEdgeInsets=UIEdgeInsetsMake(5*screenWidth/320.0, 5*screenWidth/320.0, 5*screenWidth/320.0, 5*screenWidth/320.0);
    [imageButton addTarget:self action:@selector(address) forControlEvents:UIControlEventTouchUpInside];
    [threeview addSubview:imageButton];
    
    
    UIButton *nextButton=[UIButton buttonWithType:UIButtonTypeCustom];
    nextButton.frame=CGRectMake(20*screenWidth/320.0, 220*screenWidth/320.0, self.view.frame.size.width-40*screenWidth/320.0, 35*screenWidth/320.0);
    nextButton.backgroundColor=[UIColor colorWithRed:0.19 green:0.8 blue:0.0 alpha:1.0];
    nextButton.layer.cornerRadius=4;
    nextButton.clipsToBounds=YES;
    nextButton.titleLabel.font=[UIFont systemFontOfSize:14];
    [nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    [nextButton addTarget:self action:@selector(nextBtn) forControlEvents:UIControlEventTouchUpInside];
    [thirdView addSubview:nextButton];

    
    //账户
    forthView=[[UIView alloc] initWithFrame:CGRectMake(0, 64*screenWidth/320.0, self.view.frame.size.width, self.view.frame.size.height-113*screenWidth/320.0)];
    forthView.backgroundColor=[UIColor whiteColor];
    forthView.userInteractionEnabled=YES;
    forthView.hidden=YES;
    [self.view addSubview:forthView];
    
    UIImageView *benjihaoImage=[[UIImageView alloc] initWithFrame:CGRectMake(60*screenWidth/320.0, 10*screenWidth/320.0, 40*screenWidth/320.0, 40*screenWidth/320.0)];
    benjihaoImage.image=[UIImage imageNamed:@"ddbjh"];
    benjihaoImage.layer.cornerRadius=20*screenWidth/320.0;
    benjihaoImage.clipsToBounds=YES;
    [forthView addSubview:benjihaoImage];
    
    
    User *user=[User currentUser];

    UILabel *phoneNummberLabel=[[UILabel alloc] initWithFrame:CGRectMake(100*screenWidth/320.0, 15*screenWidth/320.0, 200*screenWidth/320.0, 30*screenWidth/320.0)];
    phoneNummberLabel.text=[NSString stringWithFormat:@"本机号码:%@",user.phoneText];
    phoneNummberLabel.font=[UIFont systemFontOfSize:15*screenWidth/320.0];
    phoneNummberLabel.textAlignment=NSTextAlignmentLeft;
    phoneNummberLabel.adjustsFontSizeToFitWidth=YES;
    [forthView addSubview:phoneNummberLabel];
    
       NSArray *forTitileArray=@[@"账户余额",@"账户充值"];
    for(int n=0;n<forTitileArray.count;n++)
    {
        UIView *forthLineView=[[UIView alloc] initWithFrame:CGRectMake(0, 60*screenWidth/320.0+50*screenWidth/320.0*n, self.view.frame.size.width, 0.8*screenWidth/320.0)];
        forthLineView.backgroundColor=[UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1.0];
        [forthView addSubview:forthLineView];
        
        UILabel *titileLabel=[[UILabel alloc] initWithFrame:CGRectMake(0+self.view.frame.size.width/2*n, 65*screenWidth/320.0, self.view.frame.size.width/2, 20*screenWidth/320.0)];
        titileLabel.textAlignment=NSTextAlignmentCenter;
        titileLabel.font=[UIFont systemFontOfSize:14*screenWidth/320.0];
        titileLabel.text=forTitileArray[n];
        [forthView addSubview:titileLabel];
        
        if(n==0)
        {
            moneyLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 85*screenWidth/320.0, self.view.frame.size.width/2, 20*screenWidth/320.0)];
            moneyLabel.text=[NSString stringWithFormat:@"%@元",user.telmoney];
            moneyLabel.textAlignment=NSTextAlignmentCenter;
            moneyLabel.textColor=[UIColor redColor];
            moneyLabel.font=[UIFont systemFontOfSize:13*screenWidth/320.0];
            [forthView addSubview:moneyLabel];
            
            UIView *suLineView=[[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2, 60*screenWidth/320.0, 0.8*screenWidth/320.0, 50*screenWidth/320.0)];
            suLineView.backgroundColor=[UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1.0];
            [forthView addSubview:suLineView];
        }
//        if(n==1)
//        {
//            UIButton *chongzhiButton=[UIButton buttonWithType:UIButtonTypeCustom];
//            chongzhiButton.frame=CGRectMake(self.view.frame.size.width/2, 60*screenWidth/320.0, self.view.frame.size.width/2, 50*screenWidth/320.0);
//            chongzhiButton.backgroundColor=[UIColor clearColor];
//            [chongzhiButton addTarget:self action:@selector(czBtn) forControlEvents:UIControlEventTouchUpInside];
//            [forthView addSubview:chongzhiButton];
//        }
        
    }
    

}
#pragma mark  数字按键
-(void)firstBtn:(UIButton *)first
{
    NSArray *nummberArray=@[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"",@"0",@""];
      if(first.tag!=109&&first.tag!=111)
        {
            if(tellNUmField.text.length>10)
            {
                [self toastResult:@"号码长度不能超过11为"];
            }
            else
            {
                 tellNUmField.text=[tellNUmField.text stringByAppendingString:nummberArray[first.tag-100]];
            }
           
        }
        if(first.tag==109)
        {
            BOOL phoneBool=[ tellNUmField.text isPhoneNumber];
            
            if(!phoneBool)
            {
                [self toastResult:@"请输入正确的手机号"];
            }
            else
            {
                //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", tellNUmField.text]]];
                [self dealNummber];
            }
        }
        if(first.tag==111)
        {
            if(tellNUmField.text.length>0)
            {
                tellNUmField.text=[tellNUmField.text substringToIndex:tellNUmField.text.length-1];
            }
            else
            {
                
            }
        }
}
#pragma mark  拨号
-(void)dealNummber
{
    User *user=[User currentUser];
    
    //拨号
    NSMutableURLRequest *rever = [PostAsynClass postAsynWithURL:url1 andInterface:url46 andKeyArr:@[@"merId",@"callMp"]andValueArr:@[user.merid,tellNUmField.text]];
    //
    NSData *receive = [NSURLConnection sendSynchronousRequest:rever returningResponse:nil error:nil];
    
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString  *str = [[NSString alloc] initWithData:receive encoding:enc];
    
    NSData *ata = [NSData alloc];
    
    ata = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:ata options:NSJSONReadingMutableLeaves error:nil];
    if([[dic objectForKey:@"respCode"] isEqualToString:@"000"])
    {
        [self toastResult:@"拨号成功"];
    }
    else  if ([[dic objectForKey:@"respCode"] isEqualToString:@"008"])
    {
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"未登录或登录失效，请重新登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
        alertView.tag=2;
        return;
    }
    else
    {
        [self toastResult:[dic objectForKey:@"respDesc"]];
    }
}
-(void)nextBtn
{
    User *user=[User currentUser];
    
    //拨号
    NSMutableURLRequest *rever = [PostAsynClass postAsynWithURL:url1 andInterface:url46 andKeyArr:@[@"merId",@"callMp"]andValueArr:@[user.merid,phoneNum.text]];
    //
    NSData *receive = [NSURLConnection sendSynchronousRequest:rever returningResponse:nil error:nil];
    
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString  *str = [[NSString alloc] initWithData:receive encoding:enc];
    
    NSData *ata = [NSData alloc];
    
    ata = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:ata options:NSJSONReadingMutableLeaves error:nil];
    if([[dic objectForKey:@"respCode"] isEqualToString:@"000"])
    {
        [self toastResult:@"拨号成功"];
    }
    else  if ([[dic objectForKey:@"respCode"] isEqualToString:@"008"])
    {
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"未登录或登录失效，请重新登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
        alertView.tag=2;
        return;
    }
    else
    {
        [self toastResult:[dic objectForKey:@"respDesc"]];
    }

}
#pragma mark  充值
-(void)czBtn
{
    
}
-(void)lastBtn:(UIButton *)last
{
    for(int nummber=0;nummber<lastArray.count;nummber++)
    {
        UIButton *btnNav = (UIButton*)[self.view viewWithTag:400+nummber];
        [btnNav setImage:[UIImage imageNamed:lastArray[nummber]] forState:UIControlStateNormal];
        
    }
    [ last setImage:[UIImage imageNamed:lastSelectArray[last.tag-400]] forState:UIControlStateNormal];
    
    switch (last.tag)
    {
        case 400:
        {
            [self makeView];
            
            [_header free];
            [_footer free];
            break;
        }
        case 401:
        {
             [self makeView];
            [self reloadData];
            [_header free];
            [_footer free];
            firstView.hidden=YES;
            secondView.hidden=NO;
            thirdView.hidden=YES;
            forthView.hidden=YES;
            break;
        }
        case 402:
        {
             [self makeView];
            [_header free];
            [_footer free];
            firstView.hidden=YES;
            secondView.hidden=YES;
            thirdView.hidden=NO;
            forthView.hidden=YES;
            break;
        }
        case 403:
        {
            [self telmoneySearch];
             [self makeView];
            [_header free];
            [_footer free];
            firstView.hidden=YES;
            secondView.hidden=YES;
            thirdView.hidden=YES;
            forthView.hidden=NO;
            break;
        }
        default:
            break;
    }
    

}
-(void)address
{
    ABPeoplePickerNavigationController *peoplePicker = [[ABPeoplePickerNavigationController alloc] init];
    peoplePicker.peoplePickerDelegate = self;
    [self presentViewController:peoplePicker animated:YES completion:nil];
}
- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController*)peoplePicker didSelectPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier {
    
    ABMultiValueRef valuesRef = ABRecordCopyValue(person, kABPersonPhoneProperty);
    CFIndex index = ABMultiValueGetIndexForIdentifier(valuesRef,identifier);
    CFStringRef value = ABMultiValueCopyValueAtIndex(valuesRef,index);
    
    [self dismissViewControllerAnimated:YES completion:^{
        phoneNum.text = (__bridge NSString*)value;
        //去掉手机号的-
        phoneNum.text=[phoneNum.text stringByReplacingOccurrencesOfString:@"-" withString:@""];
    }];
}

-(void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)reloadData
{
    User *user=[User currentUser];
    
    NSString *a=[NSString stringWithFormat:@"%d",_pageNum];
    NSMutableURLRequest *rever =[PostAsynClass postAsynWithURL:url1 andInterface:url45 andKeyArr:@[@"merId",@"pageNum",@"pageSize"]andValueArr:@[user.merid,a,@"12"]];
    
    //
    NSData *receive = [NSURLConnection sendSynchronousRequest:rever returningResponse:nil error:nil];
    
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    
    NSString  *str = [[NSString alloc] initWithData:receive encoding:enc];
    
    NSData *ata = [NSData alloc];
    
    ata = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:ata options:NSJSONReadingMutableLeaves error:nil];
    
    //
    _data=[dic objectForKey:@"ordersInfo"];
    for(NSDictionary *dicc in _data)
    {
        [_dataArr addObject:dicc];
        // NSLog(@"ddddddddd%@",dicc );
    }
    NSLog(@"------------------------%@",dic);
    
    NSLog(@"777eygeyfgggihdihdhh5%@",_dataArr);
    if(_dataArr.count<1)
    {
        UIAlertView *alat = [[UIAlertView alloc] initWithTitle:@"提示" message:@"近期内你还没有通话记录" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        alat.delegate=self;
        [alat show];
        return;
    }
    [_table reloadData];

}
#pragma mark  从头开始
-(void)viewDidLayoutSubviews {
    
    if ([_table respondsToSelector:@selector(setSeparatorInset:)]) {
        [_table setSeparatorInset:UIEdgeInsetsZero];
        
    }
    if ([_table respondsToSelector:@selector(setLayoutMargins:)])  {
        [_table setLayoutMargins:UIEdgeInsetsZero];
    }
    
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPat{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
}
#pragma mark table的代理方法
//必选代理方法

//1、设置table的每一段有多少行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60*screenWidth/320.0;
}
//2、设置每一行上面显示什么内容
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //做一个标识
    static NSString *str = @"iden";
    
    //给table注册一个cell名称标识
    tonghuaTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    
    //判断cell有没有,在池子里找
    if(!cell)
    {//没找到进来
        //实例化一个cell
        cell = [[tonghuaTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str] ;
    }
    // cell.transDate.text=_dataArr[indexPath.row][@"transDate"];
    //把20130303变成2013-03-03startTime
//    NSRange range1=NSMakeRange(0, 4);
//    NSRange range2=NSMakeRange(4, 2);
//    NSRange range3=NSMakeRange(6, 2);
//    NSString *string1=[NSString stringWithFormat:@"%@/%@/%@",[_dataArr[indexPath.row][@"transDate"] substringWithRange:range1],[_dataArr[indexPath.row][@"transDate"] substringWithRange:range2],[_dataArr[indexPath.row][@"transDate"] substringWithRange:range3]];
//    //cell.transDate.text=string1;
//    NSLog(@"%@",string1);
//    
//    //cell.transTime.text=_dataArr[indexPath.row][@"transTime"];
//    
//    NSRange ran1=NSMakeRange(0, 2);
//    NSRange ran2=NSMakeRange(2, 2);
//    NSRange ran3=NSMakeRange(4, 2);
//    NSString *string2=[NSString stringWithFormat:@"%@:%@:%@",[_dataArr[indexPath.row][@"transTime"] substringWithRange:ran1],[_dataArr[indexPath.row][@"transTime"] substringWithRange:ran2],[_dataArr[indexPath.row][@"transTime"] substringWithRange:ran3]];
//    //cell.transTime.text=string2;
//    NSString *timeString=[NSString stringWithFormat:@"%@ %@",string1,string2];
    cell.transTime.text=_dataArr[indexPath.row][@"startTime"];
    cell.regMerId.text=_dataArr[indexPath.row][@"callMp"];
    cell.bjhImage.image=[UIImage imageNamed:@"ddbjh"];
    cell.jiantouImage.image=[UIImage imageNamed:@"ddjt"];
    return cell;
}
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    tonghuaListViewController *tvc=[[tonghuaListViewController alloc] init];
    tvc.ndic=_dataArr[indexPath.row];
    [self.navigationController pushViewController:tvc animated:YES];
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
-(void)toastResult:(NSString *) toastMsg{
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:toastMsg
                          message:nil
                          delegate:self
                          cancelButtonTitle:@"确定"
                          otherButtonTitles:nil];
    [alert show];
}

#pragma mark MJ的代理
//开始的代理
-(void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    //在这里开始网络请求
    if(refreshView == _header)
    {
        _pageNum=1;
        [_dataArr removeAllObjects];
        [self reloadData];
        
    }
    else
    {
        _pageNum+=1;
        [self reloadData];
        
    }
    [refreshView endRefreshing];//结束刷新，归位
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
