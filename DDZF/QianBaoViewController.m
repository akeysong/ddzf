//
//  QianBaoViewController.m
//  DDZF
//
//  Created by 王健超 on 15/12/2.
//  Copyright (c) 2015年 wjc. All rights reserved.
//

#import "QianBaoViewController.h"
#import "User.h"
#import "MyNavigationBar.h"
#import "PostAsynClass.h"
#import "Header.h"
#import "ChongZhiViewController.h"
#import "nextTixianViewController.h"
#import "ShiMingViewController.h"
#import "addCardTableViewCell.h"
#import "addCardViewController.h"
#import "JiLuViewController.h"
#import "PostAsynClass.h"
@interface QianBaoViewController ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    UIScrollView *scrollview;
    UIScrollView *_scr;
    UIView *firstView;
    NSArray *imageArray;
    UIPanGestureRecognizer * pan;
    int nnn;
    
    
    UILabel *yueLabel;
    UILabel *jifenLabel;
    UILabel *fanyongLabel;
    UILabel *lastLabel;
    UILabel *firstLabel;
    UILabel *getnumLabel;
    UILabel *outnumLabel;
    
    //结算卡管理
    UITableView *_tableV;
    NSArray *_data;
    NSMutableArray *_dataArr;
    NSMutableArray *numArr;
    UIAlertView *_alertv;
    NSString *alertNum;
    NSDictionary *dict;
    
    
    NSDateFormatter *_formatter;
    NSString *_timeStr;
    NSString *_timeStr1;

}
@end

@implementation QianBaoViewController
@synthesize pageControl;
- (void)viewDidLoad {
    [super viewDidLoad];
    nnn=0;
    _dataArr = [NSMutableArray arrayWithCapacity:0];
    numArr=[[NSMutableArray alloc] init];
   

    [self makeNav];
     [self loadData];
    [self searchInAndOut];
    [self getPlace];
    [self searchPay];
    [self makeUI];
    self.view.backgroundColor=[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0];

    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated
{
    [self loadData];
    [self searchInAndOut];
    User *user=[User currentUser];
    yueLabel.text=[NSString stringWithFormat:@"%@",user.yu];
    jifenLabel.text=[NSString stringWithFormat:@"%@",user.jiFen];
    firstLabel.text=[NSString stringWithFormat:@"%@",user.fanYong];
    lastLabel.text=[NSString stringWithFormat:@"%@",user.yu];
    fanyongLabel.text=[NSString stringWithFormat:@"%@",user.fanYong];
    getnumLabel.text=[NSString stringWithFormat:@"%@",user.numGet];
    outnumLabel.text=[NSString stringWithFormat:@"%@",user.numOut];
    //NSLog(@"shuchu%lu,%@",(unsigned long)_dataArr.count,_data);
    
}
-(void)makeNav
{
    //导航
    [self.navigationController setNavigationBarHidden:YES];
    MyNavigationBar *mnb = [[MyNavigationBar alloc] init];
    mnb.frame = CGRectMake(0, 20*screenWidth/320, 320*screenWidth/320, 44*screenWidth/320);
    [mnb createMyNavigationBarWithBgImageName:nil andLeftBBIIamgeNames:[NSArray arrayWithObject:@"fanhui@2x.png"] andRightBBIImages:nil andTitle:@"钱包" andClass:self andSEL:@selector(bacClick:)];
    [self.view addSubview:mnb];
    
    UIButton *jiluButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [jiluButton setTitle:@"记录" forState:UIControlStateNormal];
    jiluButton.titleLabel.textAlignment=NSTextAlignmentCenter;
    [jiluButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    jiluButton.frame=CGRectMake(self.view.frame.size.width-50*screenWidth/320.0, 15*screenWidth/320.0, 50*screenWidth/320.0, 25*screenWidth/320.0);
    jiluButton.titleLabel.font=[UIFont systemFontOfSize:16];
    [jiluButton addTarget:self action:@selector(navButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [mnb addSubview:jiluButton];
    
    //状态栏颜色
    UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320*screenWidth/320, 20*screenWidth/320)];
    
    statusBarView.backgroundColor=[UIColor whiteColor];
    
    [self.view addSubview:statusBarView];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
    _tableV= [[UITableView alloc] initWithFrame:CGRectMake(0, 280*screenWidth/320, self.view.frame.size.width, self.view.frame.size.height-321*screenWidth/320) style:UITableViewStylePlain];//实例化，两种类型plain、group
    //两个代理
    _tableV.delegate = self;
    _tableV.dataSource = self;
    //_tableV.backgroundColor=[UIColor grayColor];
    _tableV.tableFooterView=[[UIView alloc]init];
    [self.view addSubview:_tableV];
    //可选属性，把两行之间的分隔线隐藏
    //_tableV.separatorStyle = UITableViewCellSeparatorStyleNone;
}
-(void)navButtonClick
{
    //0  3  余额  //1  积分   //-1  2  返佣
    JiLuViewController *jvc=[[JiLuViewController alloc] init];
    [self.navigationController pushViewController:jvc animated:YES];
}

-(void)loadData
{
    User *user=[User currentUser];
    //结算卡查询接口
    
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingGB_18030_2000);
    
    NSMutableURLRequest *rever = [PostAsynClass postAsynWithURL:url1 andInterface:url013 andKeyArr:@[@"merId"]andValueArr:@[user.merid]];
    //
    NSData *receive = [NSURLConnection sendSynchronousRequest:rever returningResponse:nil error:nil];
    
    //NSString *string=[receive stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString  *str = [[NSString alloc] initWithData:receive encoding:enc];
    
    NSData *ata = [NSData alloc];
    
    ata = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:ata options:NSJSONReadingMutableLeaves error:nil];
    NSLog(@"shanghujiesuankachaxun%@",dic);
    _data=[dic objectForKey:@"ordersInfo"];
    
    [_dataArr removeAllObjects];
    NSString *sre = [dic objectForKey:@"respDesc"];
    NSLog(@"&&&&&&&&&&&&&%@",sre);
    if (![[dic objectForKey:@"respCode"]isEqualToString:@"000"]) {
        [self toastResult:sre];
    }
    for(NSDictionary *dicc in _data)
    {
        [_dataArr addObject:dicc];
    }
    [_tableV reloadData];
    
}
-(void)searchInAndOut
{
    User *user=[User currentUser];
    NSDate *date=[NSDate dateWithTimeIntervalSinceNow:-7*24*60*60];
    _formatter=[[NSDateFormatter alloc]init];
    _formatter.dateFormat=@"yyyyMMdd";
    NSTimeZone *nowZone=[NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [_formatter setTimeZone:nowZone];
    _timeStr=[_formatter stringFromDate:date];
    NSLog(@"========================%@",_timeStr);
    
    
    NSDate *nowDate=[NSDate date];
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    formatter.dateFormat=@"yyyyMMdd";
    NSTimeZone *nowZone1=[NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:nowZone1];
    _timeStr1=[formatter stringFromDate:nowDate];
    NSLog(@"------------------------%@",_timeStr1);
    
    NSMutableURLRequest *rever=[PostAsynClass postAsynWithURL:url1 andInterface:url41 andKeyArr:@[@"merId",@"beginDate",@"endDate"] andValueArr:@[user.merid,_timeStr,_timeStr1]];
    NSData *receive = [NSURLConnection sendSynchronousRequest:rever returningResponse:nil error:nil];
    
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    
    
    //NSString *string=[receive stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString  *str = [[NSString alloc] initWithData:receive encoding:enc];
    
    NSData *ata = [NSData alloc];
    
    ata = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:ata options:NSJSONReadingMutableLeaves error:nil];
    NSLog(@"输出支出和收入%@",dic);
    user.numNum=[dic objectForKey:@"payNum"];
    if([[dic objectForKey:@"payAmt"] length]==0)
    {
        getnumLabel.text=@"0.00";
        user.numGet=@"0.00";
    }
    else{
        getnumLabel.text=[dic objectForKey:@"payAmt"];
        user.numGet=[dic objectForKey:@"payAmt"];
    }
    if([[dic objectForKey:@"liqNum"] length]==0)
    {
        outnumLabel.text=@"0.00";
        user.numOut=@"0.00";
    }
    else
    {
         outnumLabel.text=[dic objectForKey:@"liqNum"];
        user.numOut=[dic objectForKey:@"liqNum"];
    }
}
-(void)getPlace
{
    
}
//1、设置table的每一段有多少行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (section==0) {
        return _dataArr.count;
    }
    else
    {
        return 0;
    }
}
//4、设置图片段头
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIButton *but=[UIButton buttonWithType:UIButtonTypeCustom];
    
    but.frame=CGRectMake(20*screenWidth/320.0,0,self.view.frame.size.width-40*screenWidth/320.0, 40*screenWidth/320);
    [but setImage:[UIImage imageNamed:@"ios320x568_21.png"] forState:UIControlStateNormal];
    [but addTarget:self action:@selector(cardbtn:) forControlEvents:UIControlEventTouchUpInside];
    _tableV.backgroundColor=[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0];
    [_tableV addSubview:but];
    
    return but;
}
-(void)cardbtn:(UIButton*)btn
{
    User *user=[User currentUser];
    if(![user.sm isEqual:@"S"])
    {
       UIAlertView *alert= [[UIAlertView alloc]initWithTitle:@"提示" message:@"您未绑定收款银行卡，是否立即绑定收款银行卡！" delegate:self cancelButtonTitle:@"暂不绑定" otherButtonTitles:@"我要绑定收款银行卡",nil];
        alert.delegate=self;
        [alert show];
    }
    else
    {
        addCardViewController *add=[[addCardViewController alloc] init];
        
        [self.navigationController  pushViewController:add animated:YES];
    }
   
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
//5、设置段头高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 0;
    }
    else
    {
        return 100;
    }
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
    addCardTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:str];
    
    //判断cell有没有,在池子里找
    if(!cell)
    {//没找到进来
        //实例化一个cell
        cell = [[addCardTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str] ;
    }
    //设置cell不允许被点击
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor=[UIColor whiteColor];
    //默认按钮
    UIButton *btn3 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn3.frame = CGRectMake(self.view.frame.size.width-90*screenWidth/320.0, 30*screenWidth/320.0,80*screenWidth/320.0, 30*screenWidth/320.0);
    [btn3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn3 addTarget:self action:@selector(onClick3:) forControlEvents:UIControlEventTouchUpInside];
    btn3.titleLabel.textAlignment=NSTextAlignmentLeft;
    btn3.tag = [indexPath row];
    [cell addSubview:btn3];
    
    //删除按钮
    UIButton *btn4 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn4.frame = CGRectMake(self.view.frame.size.width-40*screenWidth/320.0, 5*screenWidth/320.0,20*screenWidth/320.0, 20*screenWidth/320.0);
    [btn4 setImage:[UIImage imageNamed:@"ios750x1334_25.png"] forState:UIControlStateNormal];
    [btn4 addTarget:self action:@selector(deleteClick:) forControlEvents:UIControlEventTouchUpInside];
    btn4.tag = [indexPath row];
    [cell addSubview:btn4];
    
    cell.isDefault.text=_dataArr[indexPath.row][@"isDefault"];
    
    if ([_dataArr[indexPath.row][@"isDefault"]isEqualToString:@"Y"]) {
        cell.isDefault.text=@"默认";
        
        [btn3 setUserInteractionEnabled:NO];
        //  [btn4 setUserInteractionEnabled:NO];
        [btn4 removeFromSuperview];
        
    }
    if ([_dataArr[indexPath.row][@"isDefault"]isEqualToString:@"N"])
    {
        cell.isDefault.text=@"设为默认";
    }
    
    
    //设置银行卡图片
    if ([_dataArr[indexPath.row][@"openBankId"]isEqualToString:@"ccb"])
    {
        cell.cardImage.image=[UIImage imageNamed:@"jiansheBank"];
    }
    if ([_dataArr[indexPath.row][@"openBankId"]isEqualToString:@"icbc"])
    {
        cell.cardImage.image=[UIImage imageNamed:@"gongshangBank"];
    }
    if ([_dataArr[indexPath.row][@"openBankId"]isEqualToString:@"abc"])
    {
        cell.cardImage.image=[UIImage imageNamed:@"nongyeBank"];
    }
    if ([_dataArr[indexPath.row][@"openBankId"]isEqualToString:@"bankcomm"])
    {
        cell.cardImage.image=[UIImage imageNamed:@"jiaotongBank"];
    }
    if ([_dataArr[indexPath.row][@"openBankId"]isEqualToString:@"cmb"])
    {
        cell.cardImage.image=[UIImage imageNamed:@"zhaoshangBank"];
    }
    if ([_dataArr[indexPath.row][@"openBankId"]isEqualToString:@"ecitic"])
    {
        cell.cardImage.image=[UIImage imageNamed:@"zhongxinBank"];
    }
    if ([_dataArr[indexPath.row][@"openBankId"]isEqualToString:@"cebbank"])
    {
        cell.cardImage.image=[UIImage imageNamed:@"guangdaBank"];
    }
     if ([_dataArr[indexPath.row][@"openBankId"] isEqual:@"spdb"])  //浦发
    {
        cell.cardImage.image=[UIImage imageNamed:@"pufaBank"];
    }
     if ([_dataArr[indexPath.row][@"openBankId"] isEqual:@"cmbc"])  //民生
    {
        cell.cardImage.image=[UIImage imageNamed:@"minshengBank"];
    }
    if ([_dataArr[indexPath.row][@"openBankId"]isEqualToString:@"bankofbj"])
    {
        cell.cardImage.image=[UIImage imageNamed:@"beijingBank"];
    }
    NSString *str2 =_dataArr[indexPath.row][@"openAcctId"];
    
    NSString *str1 = [str2 substringWithRange:NSMakeRange(str2.length-4, 4)];
    
    //[str1 replaceCharactersInRange:NSMakeRange(i-10, 6) withString:@"******"];
    cell.openAcctId.text=[NSString stringWithFormat:@"尾号%@|%@",str1,_dataArr[indexPath.row][@"openAcctName"]];
    cell.openAcctName.text=_dataArr[indexPath.row][@"openBankName"];
    
    return cell;
}
-(void)onClick3:(UIButton*)btn
{
    User *user=[User currentUser];
    user.moRenNun=_dataArr[btn.tag][@"liqCardId"];
    _alertv= [[UIAlertView alloc]initWithTitle:@"更改默认" message:@"您确定将该卡设为默认吗！" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是",nil];
    alertNum=@"1";
    [_alertv show];
    _alertv.tag=4;
}
-(void)deleteClick:(UIButton*)btn
{
    User *user=[User currentUser];
    user.moRenNun=_dataArr[btn.tag][@"liqCardId"];
    NSLog(@"输出结算卡编号为%@",user.moRenNun);
    
    UIAlertView *aler= [[UIAlertView alloc]initWithTitle:@"删除" message:@"您确认删除该银行卡吗！" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是",nil];
    [aler show];
    alertNum=@"2";
    aler.tag=5;
}

-(void)makeUI
{
    firstView=[[UIView alloc] initWithFrame:CGRectMake(0, 64.6*screenWidth/320.0, self.view.frame.size.width, 189.4*screenWidth/320.0)];
    firstView.backgroundColor=[UIColor whiteColor];
    firstView.userInteractionEnabled=YES;
    [self.view addSubview:firstView];
    //3个模块
    User *user=[User currentUser];
    
    imageArray=@[@"余额",@"积分",@"返佣"];
    _scr=[[UIScrollView alloc] initWithFrame:CGRectMake(70*screenWidth/320.0, 10*screenWidth/320.0, 180*screenWidth/320.0, 110*screenWidth/320.0)];
    _scr.contentSize=CGSizeMake(180*screenWidth/320.0*(imageArray.count+2), 110*screenWidth/320.0);
    _scr.bounces = NO;//设置是否反弹
    _scr.pagingEnabled = YES;
    _scr.scrollEnabled=YES;
    _scr.backgroundColor=[UIColor whiteColor];
    _scr.userInteractionEnabled=YES;
    _scr.showsHorizontalScrollIndicator=NO;//设置横向滑块的隐藏
    _scr.scrollsToTop = YES;
    _scr.delegate=self;
    [_scr scrollRectToVisible:CGRectMake(180*screenWidth/320.0,0,180*screenWidth/320.0,110*screenWidth/320.0) animated:NO];
    [firstView addSubview:_scr];
    for(int i=0;i<imageArray.count;i++)
    {
        UIView *view=[[UIView alloc] initWithFrame:CGRectMake(180*screenWidth/320.0*(i+1), 0, 180*screenWidth/320.0, 110*screenWidth/320.0)];
        view.backgroundColor=[UIColor whiteColor];
        [_scr addSubview:view];
        
        UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0, 5*screenWidth/320.0, view.frame.size.width, 30*screenWidth/320.0)];
        label.text=imageArray[i];
        label.font=[UIFont systemFontOfSize:18];
        label.textAlignment=NSTextAlignmentCenter;
        [view addSubview:label];
        
        //UILabel *label1=[[UILabel alloc] initWithFrame:CGRectMake(0, 40*screenWidth/320.0, view.frame.size.width, 50*screenWidth/320.0)];
        
        if(i==0)
        {
            yueLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 40*screenWidth/320.0, view.frame.size.width, 50*screenWidth/320.0)];
            yueLabel.text=user.yu;
            yueLabel.textColor=[UIColor redColor];
            yueLabel.textAlignment=NSTextAlignmentCenter;
            yueLabel.font=[UIFont systemFontOfSize:20*screenWidth/320.0];
             [view addSubview:yueLabel];
           //label1.text=user.yu;
        }
        if(i==1)
        {
            jifenLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 40*screenWidth/320.0, view.frame.size.width, 50*screenWidth/320.0)];
            jifenLabel.text=user.jiFen;
            jifenLabel.textColor=[UIColor redColor];
            jifenLabel.textAlignment=NSTextAlignmentCenter;
            jifenLabel.font=[UIFont systemFontOfSize:20*screenWidth/320.0];
            [view addSubview:jifenLabel];

        }
        if(i==2)
        {
            fanyongLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 40*screenWidth/320.0, view.frame.size.width, 50*screenWidth/320.0)];
            fanyongLabel.text=user.fanYong;
            fanyongLabel.textColor=[UIColor redColor];
            fanyongLabel.textAlignment=NSTextAlignmentCenter;
            fanyongLabel.font=[UIFont systemFontOfSize:20*screenWidth/320.0];
            [view addSubview:fanyongLabel];

        }
//        label1.textAlignment=NSTextAlignmentCenter;
//        label1.font=[UIFont systemFontOfSize:20*screenWidth/320.0];
//        label1.textColor=[UIColor redColor];
//        [view addSubview:label1];
    }
    
    //取数组最后一张图片放在第0页
    UIView *imageView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 180*screenWidth/320.0, 110*screenWidth/320.0)];
     //添加最后1页在首页用于循环
    [_scr addSubview:imageView];
    UILabel *label11=[[UILabel alloc] initWithFrame:CGRectMake(0, 5*screenWidth/320.0, imageView.frame.size.width, 30*screenWidth/320.0)];
    label11.text=@"返佣";
    label11.textAlignment=NSTextAlignmentCenter;
    [imageView addSubview:label11];

    firstLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 40*screenWidth/320.0, imageView.frame.size.width, 50*screenWidth/320.0)];
    firstLabel.text=user.fanYong;
    firstLabel.font=[UIFont systemFontOfSize:20*screenWidth/320.0];
    firstLabel.textColor=[UIColor redColor];
    firstLabel.textAlignment=NSTextAlignmentCenter;
    [imageView addSubview:firstLabel];
    //取数组第一张图片放在最后1页
    imageView = [[UIView alloc] initWithFrame:CGRectMake((180*screenWidth/320.0 * (imageArray.count + 1)) , 0,180*screenWidth/320.0, 110*screenWidth/320.0)];
     //添加第1页在最后用于循环
    UILabel *label2=[[UILabel alloc] initWithFrame:CGRectMake(0, 5*screenWidth/320.0, imageView.frame.size.width, 30*screenWidth/320.0)];
    label2.text=@"余额";
    label2.textAlignment=NSTextAlignmentCenter;
    [imageView addSubview:label2];
    
   lastLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 40*screenWidth/320.0, imageView.frame.size.width, 50*screenWidth/320.0)];
    lastLabel.text=user.yu;
    lastLabel.textAlignment=NSTextAlignmentCenter;
    lastLabel.font=[UIFont systemFontOfSize:20*screenWidth/320.0];
    lastLabel.textColor=[UIColor redColor];
    [imageView addSubview:lastLabel];

    [_scr addSubview:imageView];
    
    UIButton *leftButton=[UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame=CGRectMake(10*screenWidth/320.0, 10*screenWidth/320.0, 50*screenWidth/320.0, 120*screenWidth/320.0);
    leftButton.backgroundColor=[UIColor whiteColor];
    [leftButton setImage:[UIImage imageNamed:@"zuo@2x"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(leftBtn) forControlEvents:UIControlEventTouchUpInside];
    [firstView addSubview:leftButton];
    
    UIButton *rightButton=[UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame=CGRectMake(250*screenWidth/320.0, 10.2*screenWidth/320.0, 50*screenWidth/320.0, 120*screenWidth/320.0);
    rightButton.backgroundColor=[UIColor whiteColor];
    [rightButton setImage:[UIImage imageNamed:@"you@2x"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightBtn) forControlEvents:UIControlEventTouchUpInside];
    [firstView addSubview:rightButton];
    
     pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan:)];
    [_scr addGestureRecognizer:pan];
    
    UIView *lineView=[[UIView alloc] initWithFrame:CGRectMake(0, 140*screenWidth/320.0, self.view.frame.size.width, 0.5*screenWidth/320.0)];
    lineView.backgroundColor=[UIColor blackColor];
    [firstView addSubview:lineView];
    
    UILabel *getLabel=[[UILabel alloc] initWithFrame:CGRectMake(30*screenWidth/320.0, 145*screenWidth/320.0, 100*screenWidth/320.0, 20*screenWidth/320.0)];
    getLabel.text=@"近7日收入";
    getLabel.font=[UIFont systemFontOfSize:12*screenWidth/320.0];
    getLabel.textAlignment=NSTextAlignmentCenter;
    [firstView addSubview:getLabel];
    
    getnumLabel=[[UILabel alloc] initWithFrame:CGRectMake(30*screenWidth/320.0, 165*screenWidth/320.0, 100*screenWidth/320.0, 20*screenWidth/320.0)];
    getnumLabel.text=user.numGet;
    getnumLabel.font=[UIFont systemFontOfSize:12*screenWidth/320.0];
    getnumLabel.textAlignment=NSTextAlignmentCenter;
    [firstView addSubview:getnumLabel];
    
    
    UILabel *outLabel=[[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width-130*screenWidth/320.0, 145*screenWidth/320.0, 100*screenWidth/320.0, 20*screenWidth/320.0)];
    outLabel.text=@"近7日提现";
    outLabel.font=[UIFont systemFontOfSize:12*screenWidth/320.0];
    outLabel.textAlignment=NSTextAlignmentCenter;
    [firstView addSubview:outLabel];
    
    outnumLabel=[[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width-130*screenWidth/320.0, 165*screenWidth/320.0, 100*screenWidth/320.0, 20*screenWidth/320.0)];
    outnumLabel.text=user.numOut;
    outnumLabel.font=[UIFont systemFontOfSize:12*screenWidth/320.0];
    outnumLabel.textAlignment=NSTextAlignmentCenter;
    [firstView addSubview:outnumLabel];
    
    UILabel *kaLabel=[[UILabel alloc] initWithFrame:CGRectMake(20*screenWidth/320.0, 260*screenWidth/320.0, 100*screenWidth/320.0, 20*screenWidth/320.0)];
    kaLabel.textAlignment=NSTextAlignmentLeft;
    kaLabel.text=@"结算卡管理";
    kaLabel.font=[UIFont systemFontOfSize:13*screenWidth/320.0];
    [self.view addSubview:kaLabel];
    
    
    NSArray *selectArray=@[@"充值",@"提现"];
    {
        for(int i=0;i<selectArray.count;i++)
        {
            UIButton *butt=[UIButton buttonWithType:UIButtonTypeCustom];
            butt.frame=CGRectMake(0+(self.view.frame.size.width/2+0.4*screenWidth/320.0)*i, self.view.frame.size.height-40*screenWidth/320.0, (self.view.frame.size.width-0.4*screenWidth/320.0)/2, 40*screenWidth/320.0);
            butt.tag=100+i;
            butt.backgroundColor=[UIColor whiteColor];
            [butt setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [butt addTarget:self action:@selector(butTon:) forControlEvents:UIControlEventTouchUpInside];
            [butt setTitle:selectArray[i] forState:UIControlStateNormal];
            [self.view addSubview:butt];
        }
    }
    
}
#pragma mark  提现   收入
-(void)searchPay
{
    
}
#pragma mark  充值、提现
-(void)butTon:(UIButton *)butto
{
    User *user=[User currentUser];
    switch (butto.tag) {
        case 100:
        {
            
            if(![user.isAuthentication isEqual:@"S"])
            {
                if([user.isAuthentication isEqual:@"I"])
                {
                    [self toastResult:@"实名中不允许交易"];
                    return;
                }
                else
                {
                    UIAlertView *alert= [[UIAlertView alloc]initWithTitle:@"提示" message:@"您未绑定收款银行卡，暂不可以交易！" delegate:self cancelButtonTitle:@"暂不绑定" otherButtonTitles:@"我要绑定收款银行卡",nil];
                    [alert show];
                    alert.tag=2;
                    return;
                }
                
            }
            else
            {

            ChongZhiViewController *cvc=[[ChongZhiViewController alloc] init];
            [self.navigationController pushViewController:cvc animated:YES];
            }
          break;
        }
            
        case 101:
        {
            if(![user.isAuthentication isEqual:@"S"])
            {
                if([user.isAuthentication isEqual:@"I"])
                {
                    [self toastResult:@"实名中不允许交易"];
                    return;
                }
                else
                {
                    UIAlertView *alert= [[UIAlertView alloc]initWithTitle:@"提示" message:@"您未绑定收款银行卡，暂不可以提现！" delegate:self cancelButtonTitle:@"暂不绑定" otherButtonTitles:@"我要绑定收款银行卡",nil];
                    [alert show];

                    return;
                }
                
            }
            else
            {
                nextTixianViewController *nvc=[[nextTixianViewController alloc] init];
                [self.navigationController pushViewController:nvc animated:YES];
            }
            break;
        }
        default:
            break;
    }
}
-(void)leftBtn
{
    [[NSUserDefaults standardUserDefaults] setObject:@"left" forKey:@"dianji"];
    if(nnn==-1)
    {
        nnn=1;
    }
    else
    {
        nnn=nnn-1;
    }
    [self handlePan:pan];
}
-(void)rightBtn
{
    [[NSUserDefaults standardUserDefaults] setObject:@"right" forKey:@"dianji"];
    if(nnn==3)
    {
        nnn=1;
    }
    else
    {
       nnn=nnn+1;
    }
    
    [self handlePan:pan];
   
    
}
- (void) handlePan: (UIPanGestureRecognizer *)rec
{
NSLog(@"输出位置为2%d",nnn);
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"dianji"]isEqual:@"right" ])
    {
        [UIView animateWithDuration:0.2 animations:^{
          [_scr scrollRectToVisible:CGRectMake(180*screenWidth/320.0+180*screenWidth/320.0*nnn, 0, 180*screenWidth/320.0, 110*screenWidth/320.0) animated:NO];
        } completion:^(BOOL finished) {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"dianji"];
            NSLog(@"输出位置为%d",nnn);
        }];
        
    }
    else if([[[NSUserDefaults standardUserDefaults] objectForKey:@"dianji"]isEqual:@"left" ])
    {
        
        [UIView animateWithDuration:0.1 animations:^{
            [_scr scrollRectToVisible:CGRectMake(180*screenWidth/320.0+180*screenWidth/320.0*nnn, 0, 180*screenWidth/320.0, 110*screenWidth/320.0) animated:NO];
        } completion:^(BOOL finished) {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"dianji"];
            
        }];
    }
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
       // CGPoint point=_scr.contentOffset;
    CGFloat pagewidth = _scr.frame.size.width;
    int currentPage = floor((_scr.contentOffset.x - pagewidth/ (imageArray.count+2))/pagewidth) + 1;
    if (currentPage == 0)
    {
        // 序号0 最后1页
        [_scr scrollRectToVisible:CGRectMake(180*screenWidth/320.0 * imageArray.count, 0, 180*screenWidth/320.0, 110*screenWidth/320.0) animated:NO];
        NSLog(@"点击了2");
    }
    else if (currentPage == (imageArray.count+1))
    {
        // 最后+1,循环第1页
        [_scr scrollRectToVisible:CGRectMake( 180*screenWidth/320.0, 0, 180*screenWidth/320.0, 110*screenWidth/320.0) animated:NO];
    }

    
   // NSLog(@"输出页数%ld",(long)pageControl.currentPage);
}

-(void)bacClick:(UIButton*)btn
{
    
//    [self.navigationController popViewControllerAnimated:YES];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    User *user=[User currentUser];

    if(alertView.tag==2)
    {
        if(!buttonIndex)
        {
            
        }
        else
        {
            ShiMingViewController *svc=[[ShiMingViewController alloc] init];
            [self.navigationController pushViewController:svc animated:YES];
        }

    }
       if(alertView.tag==4)
    {
        if (!buttonIndex) {
            
            
        } else {
            
                       //结算卡查询接口
            NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingGB_18030_2000);
            
            NSMutableURLRequest *rever = [PostAsynClass postAsynWithURL:url1 andInterface:url26 andKeyArr:@[@"merId",@"liqCardId"]andValueArr:@[user.merid,user.moRenNun]];
            //
            NSData *receive = [NSURLConnection sendSynchronousRequest:rever returningResponse:nil error:nil];
                        
            NSString  *str = [[NSString alloc] initWithData:receive encoding:enc];
            
            NSData *ata = [NSData alloc];
            
            ata = [str dataUsingEncoding:NSUTF8StringEncoding];
            
            dict = [NSJSONSerialization JSONObjectWithData:ata options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"moren%@",dict);
            NSString *sre = [dict objectForKey:@"respDesc"];
            NSLog(@"&&&&&&&&&&&&&%@",sre);
            if (![[dict objectForKey:@"respCode"]isEqualToString:@"000"]) {
                [self toastResult:sre];
            }
            if ([[dict objectForKey:@"respCode"] isEqualToString:@"000"])
            {
                
                [self loadData];
            }
        }

    }
    if(alertView.tag==5)
    {
        if (!buttonIndex) {
            
            
        } else {
            
            User *user=[User currentUser];
            //结算卡查询接口
            NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingGB_18030_2000);
            
            NSMutableURLRequest *rever = [PostAsynClass postAsynWithURL:url1 andInterface:url30 andKeyArr:@[@"merId",@"liqCardId"]andValueArr:@[user.merid,user.moRenNun]];
            
            NSData *receive = [NSURLConnection sendSynchronousRequest:rever returningResponse:nil error:nil];
            
            //NSString *string=[receive stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            NSString  *str = [[NSString alloc] initWithData:receive encoding:enc];
            
            NSData *ata = [NSData alloc];
            
            ata = [str dataUsingEncoding:NSUTF8StringEncoding];
            
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:ata options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"shanchu%@",dic);
            NSString *sre = [dic objectForKey:@"respDesc"];
            NSLog(@"&&&&&&&&&&&&&%@",sre);
            if (![[dic objectForKey:@"respCode"]isEqualToString:@"000"]) {
                [self toastResult:sre];
            }
            if ([[dic objectForKey:@"respCode"] isEqualToString:@"000"])
            {
                
                [self loadData];
            }
            
        }
        

    }
}
#pragma mark  从头开始
-(void)viewDidLayoutSubviews {
    
    if ([_tableV respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableV setSeparatorInset:UIEdgeInsetsZero];
        
    }
    if ([_tableV respondsToSelector:@selector(setLayoutMargins:)])  {
        [_tableV setLayoutMargins:UIEdgeInsetsZero];
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

//用户未输入任何信息提示
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
