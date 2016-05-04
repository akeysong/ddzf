//
//  JiLuViewController.m
//  DDZF
//
//  Created by 王健超 on 15/12/7.
//  Copyright (c) 2015年 wjc. All rights reserved.
//

#import "JiLuViewController.h"
#import "User.h"
#import "Header.h"
#import "PostAsynClass.h"
#import "MyNavigationBar.h"
#import "JiLuTableViewCell.h"
@interface JiLuViewController ()<UITableViewDataSource,UITableViewDelegate,MJRefreshBaseViewDelegate>
{
    //UITableView *_tableView;
    NSString *_locationString;
    NSDateFormatter *_formatter;
    NSString *_timeStr;
    NSString *_timeStr1;
    UITableView *_table;
    NSMutableArray *_dataArr;
    int _pageNum;
    
    NSArray *_data;
    
    
    BOOL isClicked;


}

@end

@implementation JiLuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    isClicked=NO;
    _pageNum=1;
    self.view.backgroundColor=[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0];
    [self makeNav];
    [self LoadData];

    [self makeUI];
    
    // Do any additional setup after loading the view.
}
-(void)makeNav
{
    //状态栏颜色
    UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320*screenWidth/320, 20*screenWidth/320)];
    
    statusBarView.backgroundColor=[UIColor whiteColor];
    
    [self.view addSubview:statusBarView];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
    //导航
    [self.navigationController setNavigationBarHidden:YES];
    MyNavigationBar *mnb = [[MyNavigationBar alloc] init];
    mnb.frame = CGRectMake(0, 20*screenWidth/320, 320*screenWidth/320, 44*screenWidth/320);
    [mnb createMyNavigationBarWithBgImageName:nil andLeftBBIIamgeNames:[NSArray arrayWithObject:@"fanhui.png"] andRightBBIImages:nil andTitle:nil andClass:self andSEL:@selector(bacClick:)];
    [self.view addSubview:mnb];
    
    UISegmentedControl *segment=[[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"返佣",@"积分", nil]];
    segment.frame=CGRectMake(self.view.frame.size.width/2-64*screenWidth/320.0, 5*screenWidth/320.0, 128*screenWidth/320.0, 34*screenWidth/320.0);
    segment.selectedSegmentIndex=0;
    segment.tintColor=[UIColor blackColor];
    [segment addTarget:self action:@selector(segmentChanged:) forControlEvents:UIControlEventValueChanged];
    [mnb addSubview:segment];
    
    
}
-(void)makeUI
{
    _table= [[UITableView alloc] initWithFrame:CGRectMake(0, 64.6*screenWidth/320, self.view.frame.size.width, self.view.frame.size.height-64.6*screenWidth/320) style:UITableViewStylePlain];//实例化，两种类型plain、group
    //两个代理
    _table.delegate = self;
    _table.dataSource = self;
    _table.tableFooterView=[[UIView alloc]init];
    [self.view addSubview:_table];
    
    //实例化header和footer
    _header = [MJRefreshHeaderView header];
    _header.scrollView = _table;
    //设置header和footer的滚动视图为table
    _footer = [MJRefreshFooterView footer];
    _footer.scrollView = _table;
    //设置header和footer的代理
    _header.delegate = self;
    _footer.delegate = self;
    

}
-(void)segmentChanged:(UISegmentedControl *)seg
{
    _dataArr = [[NSMutableArray alloc] init];

    if(isClicked==NO)
    {
        isClicked=YES;
         _pageNum =1;
        [self LoadData];
    }
    else
    {
        isClicked=NO;
         _pageNum =1;
        [self LoadData];
    }
    [_table reloadData];
}
-(void)LoadData
{
    
    User *user=[User currentUser];
    
    NSDate *date=[NSDate dateWithTimeIntervalSinceNow:-90*24*60*60];
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
    NSMutableURLRequest *rever;
    
    if(isClicked==NO)  //返佣
    {
         rever =[PostAsynClass postAsynWithURL:url1 andInterface:url24 andKeyArr:@[@"merId",@"beginDate",@"endDate",@"pageNum",@"pageSize"]andValueArr:@[user.merid,_timeStr,_timeStr1,[NSString stringWithFormat:@"%d",_pageNum],@"12"]];
    }
    else   //积分
    {
        rever =[PostAsynClass postAsynWithURL:url1 andInterface:url12 andKeyArr:@[@"merId",@"beginDate",@"endDate",@"pageNum",@"pageSize"]andValueArr:@[user.merid,_timeStr,_timeStr1,[NSString stringWithFormat:@"%d",_pageNum],@"12"]];
    }
   
    //
    NSData *receive = [NSURLConnection sendSynchronousRequest:rever returningResponse:nil error:nil];
    
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    
    NSString  *str = [[NSString alloc] initWithData:receive encoding:enc];
    
    NSData *ata = [NSData alloc];
    
    ata = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:ata options:NSJSONReadingMutableLeaves error:nil];
    _dataArr=[[NSMutableArray alloc] init];
    _data=[dic objectForKey:@"ordersInfo"];
    for(NSDictionary *dicc in _data)
    {
        
        [_dataArr addObject:dicc];
        NSLog(@"输出为%@",dicc);
        
    }
    NSLog(@"-----==============------%@,%@",dic,_dataArr);
    
    
    
    if(_dataArr.count<1)
    {
        UIAlertView *alat = [[UIAlertView alloc] initWithTitle:@"提示" message:@"近期内你还没有记录" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        
        [alat show];
        
        return;
        
        
    }
    [_table reloadData];
    
    
}
//每一段有多少行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _dataArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 50*screenWidth/320.0;
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //做一个标识
    static NSString *str=@"iden";
    
    //fanYongJluTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:str];
    JiLuTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:str];
    if (cell==nil) {
        cell=[[JiLuTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
        
    }
    if(isClicked==NO)
    {
        NSString *string=[NSString stringWithFormat:@"%@-%@-%@",[_dataArr[indexPath.row][@"transDate"] substringWithRange:NSMakeRange(0, 4)],[_dataArr[indexPath.row][@"transDate"] substringWithRange:NSMakeRange(4, 2)],[_dataArr[indexPath.row][@"transDate"] substringWithRange:NSMakeRange(6, 2)]];
        NSString *string1=[NSString stringWithFormat:@"%@:%@:%@",[_dataArr[indexPath.row][@"transTime"] substringWithRange:NSMakeRange(0, 2)],[_dataArr[indexPath.row][@"transTime"] substringWithRange:NSMakeRange(2, 2)],[_dataArr[indexPath.row][@"transTime"] substringWithRange:NSMakeRange(4, 2)]];
        
        cell.createTimaLabel.text=[NSString stringWithFormat:@"%@ %@",string,string1];
        NSString *str=_dataArr[indexPath.row][@"transMerName"];
        NSString*before=[_dataArr[indexPath.row][@"transPosTermNo"] substringToIndex:3];
        
        NSString*after=[_dataArr[indexPath.row][@"transPosTermNo"] substringFromIndex:7];
        NSString *nameString=[str stringByReplacingCharactersInRange:NSMakeRange(1, str.length-1) withString:@"**"];
        NSString *phongNum=[NSString stringWithFormat:@"(%@***%@)",before,after];
        cell.nameLabel.text=[NSString stringWithFormat:@"%@ %@",nameString,phongNum];
        cell.numLabel.text=_dataArr[indexPath.row][@"transAmt"];
        cell.contentLabel.text=[NSString stringWithFormat:@"返佣:%@",_dataArr[indexPath.row][@"rebateAmt"]];
        cell.contentLabel.textColor=[UIColor redColor];
    }
    else
    {
        cell.createTimaLabel.text=_dataArr[indexPath.row][@"scoreOrdId"];
        NSString *string=[NSString stringWithFormat:@"%@-%@-%@",[_dataArr[indexPath.row][@"transDate"] substringWithRange:NSMakeRange(0, 4)],[_dataArr[indexPath.row][@"transDate"] substringWithRange:NSMakeRange(4, 2)],[_dataArr[indexPath.row][@"transDate"] substringWithRange:NSMakeRange(6, 2)]];
        NSString *string1=[NSString stringWithFormat:@"%@:%@:%@",[_dataArr[indexPath.row][@"transTime"] substringWithRange:NSMakeRange(0, 2)],[_dataArr[indexPath.row][@"transTime"] substringWithRange:NSMakeRange(2, 2)],[_dataArr[indexPath.row][@"transTime"] substringWithRange:NSMakeRange(4, 2)]];
        cell.nameLabel.text=[NSString stringWithFormat:@"%@ %@",string,string1];
        cell.numLabel.text=_dataArr[indexPath.row][@"transAmt"];
        cell.contentLabel.text=_dataArr[indexPath.row][@"scoreSrc"];
        cell.contentLabel.textColor=[UIColor grayColor];
        
    }

          return cell;
    
    
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

#pragma mark MJ的代理
//开始的代理
-(void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    //在这里开始网络请求
    if(refreshView == _header)
    {
        _pageNum=1;
        [_dataArr removeAllObjects];
        [self LoadData];
    }
    else
    {
        _pageNum+=1;
        [self LoadData];
        
    }
    [refreshView endRefreshing];//结束刷新，归位
}

- (void)dealloc
{
    [_header free];
    [_footer free];
}

-(void)bacClick:(UIButton*)btn
{
    [self.navigationController popViewControllerAnimated:YES];
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
