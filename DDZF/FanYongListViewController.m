//
//  FanYongListViewController.m
//  YunShouYin
//
//  Created by 王健超 on 15/12/17.
//  Copyright (c) 2015年 wjc. All rights reserved.
//

#import "FanYongListViewController.h"
#import "PostAsynClass.h"
#import "User.h"
#import "MyNavigationBar.h"
#import "Header.h"
#import "fanYongJluTableViewCell.h"
#import "UIButton+myButton.h"
@interface FanYongListViewController ()
{
    NSString *_locationString;
    NSDateFormatter *_formatter;
    NSString *_timeStr;
    NSString *_timeStr1;
    UITableView *_table;
    NSMutableArray *_dataArr;
    int _pageNum;
    
    NSArray *_data;
    
    UIButton *_button1;
    UIButton *_button2;
    BOOL _stelect;
    
}

@end

@implementation FanYongListViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0];
    
    _stelect = YES;
    
    _dataArr = [NSMutableArray arrayWithCapacity:0];
    _pageNum=1;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self loadData];
    
    
    [self makeNav];
    [self makeUI];
    //[self makebutton];
    
    if(_dataArr.count<1)
    {
        UIAlertView *alat = [[UIAlertView alloc] initWithTitle:@"提示" message:@"近期内你还没有转出记录" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        
        [alat show];
        
        return;
        
        
    }
}


-(void)makeNav
{
    //导航
    [self.navigationController setNavigationBarHidden:YES];
    MyNavigationBar *mnb = [[MyNavigationBar alloc] init];
    mnb.frame = CGRectMake(0, 20*screenWidth/320, 320*screenWidth/320, 44*screenWidth/320);
    [mnb createMyNavigationBarWithBgImageName:nil andLeftBBIIamgeNames:[NSArray arrayWithObject:@"fanhui.png"] andRightBBIImages:nil andTitle:@"返佣记录" andClass:self andSEL:@selector(bacClick:)];
    [self.view addSubview:mnb];
    
    //  UIView *
    //状态栏颜色
    UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320*screenWidth/320, 20*screenWidth/320)];
    
    statusBarView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:statusBarView];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
}


//两个按钮
-(void)makebutton
{
    
    _button1 =[UIButton buttonWithType:UIButtonTypeSystem];
    _button1.frame=CGRectMake(0, 64.5*screenWidth/320, screenWidth/2, 50*screenWidth/320);
    [_button1 makeUI:@"返佣转入" :YES];
    [_button1  addTarget:self action:@selector(btn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_button1];
    
    
    _button2 =[UIButton buttonWithType:UIButtonTypeSystem];
    _button2.frame=CGRectMake(screenWidth/2, 64.5*screenWidth/320, screenWidth/2, 50*screenWidth/320);
    [_button2 makeUI:@"返佣转出" :NO];
    [_button2  addTarget:self action:@selector(btn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_button2];
    
    //全部收款和成功交易之间的竖线
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-1, 64.5*screenWidth/320, 1, 50*screenWidth/320)];
    view.backgroundColor=[UIColor grayColor];
    [self.view addSubview:view];
    
    //全部收款和成功交易底部的竖线
    UIView *view1=[[UIView alloc] initWithFrame:CGRectMake(0,114.5*screenWidth/320, self.view.frame.size.width, 1)];
    view1.backgroundColor=[UIColor lightGrayColor];
    [self.view addSubview:view1];
}


-(void)bacClick:(UIButton*)btn
{
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)makeUI
{
    _table = [[UITableView alloc]initWithFrame:CGRectMake(0, 64.5*screenWidth/320, self.view.frame.size.width, self.view.frame.size.height-64.5*screenWidth/320) style:UITableViewStylePlain];
    //两个代理
    _table.delegate = self;
    _table.dataSource = self;
    _table.tableFooterView=[[UIView alloc]init];
    [self.view addSubview:_table];
    
    
    
    //实例化header和footer
    
    _header = [MJRefreshHeaderView header];
    
    _header.scrollView = _table;
    
    //设置header和footer的滚动视图位table
    
    _footer = [MJRefreshFooterView footer];
    _footer.scrollView = _table;
    
    //设置header footer的代理
    
    _header.delegate = self;
    _footer.delegate = self;
    
    //设置代理
    
    
}

- (void)dealloc
{
    [_header free];
    [_footer free];
}
-(void)loadData

{
    
    User *user=[User currentUser];

    NSDate *date=[NSDate dateWithTimeIntervalSinceNow:-90*24*60*60];
    _formatter=[[NSDateFormatter alloc]init];
    _formatter.dateFormat=@"yyyyMMdd";
    NSTimeZone *nowZone=[NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [_formatter setTimeZone:nowZone];
    _timeStr=[_formatter stringFromDate:date];
   
    NSDate *nowDate=[NSDate date];
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    formatter.dateFormat=@"yyyyMMdd";
    NSTimeZone *nowZone1=[NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:nowZone1];
    _timeStr1=[formatter stringFromDate:nowDate];

    NSMutableURLRequest *rever;
//    if (_stelect) {
        rever =[PostAsynClass postAsynWithURL:url1 andInterface:url24 andKeyArr:@[@"merId",@"beginDate",@"endDate",@"pageNum",@"pageSize"]andValueArr:@[user.merid,_timeStr,_timeStr1,[NSString stringWithFormat:@"%d",_pageNum],@"12"]];
//    }
//    else
//    {
//        
//       rever =[PostAsynClass postAsynWithURL:url1 andInterface:url42 andKeyArr:@[@"merId",@"beginDate",@"endDate",@"pageNum",@"pageSize"]andValueArr:@[user.merid,_timeStr,_timeStr1,[NSString stringWithFormat:@"%d",_pageNum],@"12"]];
//    }
//    
    //
    NSData *receive = [NSURLConnection sendSynchronousRequest:rever returningResponse:nil error:nil];
    
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    
    
    //NSString *string=[receive stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString  *str = [[NSString alloc] initWithData:receive encoding:enc];
    
    NSData *ata = [NSData alloc];
    
    ata = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:ata options:NSJSONReadingMutableLeaves error:nil];
    
    //
    _data=[dic objectForKey:@"ordersInfo"];
    for(NSDictionary *dicc in _data)
    {
        [_dataArr addObject:dicc];
         NSLog(@"ddddddddd%@",dicc );
    }
    
    NSLog(@"------------------------%@",dic);
    
    NSLog(@"777eygeyfgggihdihdhh5%@",_dataArr);
    [_table reloadData];
    
}
#pragma mark MJ 的代理

//开始的代理

//-refreshviewbegin

-(void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    
    if(refreshView == _header)
    {
        
        _pageNum=1;
        [_dataArr removeAllObjects];
        [self loadData];
        
    }
    else
    {
        _pageNum+=1;
        
        [self loadData];
        
        if(_dataArr.count<1)
        {
            UIAlertView *alat = [[UIAlertView alloc] initWithTitle:@"提示" message:@"近期内你还没有转出记录" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            
            [alat show];
            
            return;
            
            
        }
    }
    [refreshView endRefreshing];//结束刷新，归位
    
    
}

//全部显示按钮
-(void)btn:(UIButton*)btndown
{
    
    [_dataArr removeAllObjects];
    
    if (btndown==_button1) {
        _stelect = YES;
        
        _pageNum =1;
        
        [_button1 makeUI:@"返佣转入" :YES];
        [_button2 makeUI:@"返佣转出" :NO];
        
    }
    else
    {
        
        _stelect = NO;
        _pageNum =1;
        
        [_button1 makeUI:@"返佣转入" :NO];
        [_button2 makeUI:@"返佣转出" :YES];
    }
    [self loadData];
    
    if(_dataArr.count<1)
    {
        UIAlertView *alat = [[UIAlertView alloc] initWithTitle:@"提示" message:@"近期内你还没有返佣记录" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        
        [alat show];
        
        return;
        
        
    }
    
}
//table  从头开始
#pragma mark tableview从头开始

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
#pragma mark tableview 的代理

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath

{
    return 50*screenWidth/320;
    
}

//展现cell内容

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    //做一个标识
        static NSString *str=@"iden";
    
        fanYongJluTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:str];
    
        if (cell==nil) {
            cell=[[fanYongJluTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
    
        }
    
        //cell.transDate.text=_dataArr[indexPath.row][@"transDate"];
    
        NSRange range1=NSMakeRange(0, 4);
        NSRange range2=NSMakeRange(4, 2);
        NSRange range3=NSMakeRange(6, 2);
        NSString *string1=[NSString stringWithFormat:@"%@-%@-%@",[_dataArr[indexPath.row][@"transDate"] substringWithRange:range1],[_dataArr[indexPath.row][@"transDate"] substringWithRange:range2],[_dataArr[indexPath.row][@"transDate"] substringWithRange:range3]];
        //cell.transDate.text=string1;
        NSLog(@"%@",string1);
    
        //cell.transTime.text=_dataArr[indexPath.row][@"transTime"];
        NSRange ran1=NSMakeRange(0, 2);
        NSRange ran2=NSMakeRange(2, 2);
        NSRange ran3=NSMakeRange(4, 2);
        NSString *string2=[NSString stringWithFormat:@"%@:%@:%@",[_dataArr[indexPath.row][@"transTime"] substringWithRange:ran1],[_dataArr[indexPath.row][@"transTime"] substringWithRange:ran2],[_dataArr[indexPath.row][@"transTime"] substringWithRange:ran3]];
        //cell.transTime.text=string2;
        NSString *timeString=[NSString stringWithFormat:@"%@ %@",string1,string2];
        cell.transDate.text=timeString;
    
    
        cell.transMerName.text=_dataArr[indexPath.row][@"transMerName"];
        cell.transPosTermNo.text=_dataArr[indexPath.row][@"transPosTermNo"];
        NSString*before=[cell.transPosTermNo.text substringToIndex:3];
    
        NSString*after=[cell.transPosTermNo.text substringFromIndex:7];
    
        cell.transPosTermNo.text = [[NSString alloc] initWithFormat:@"(%@****%@)", before, after];
        cell.transAmt.text=_dataArr[indexPath.row][@"transAmt"];
        cell.rebateAmt.text=[NSString stringWithFormat:@"返佣:%@",_dataArr[indexPath.row][@"rebateAmt"]];
    //

        return cell;
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
