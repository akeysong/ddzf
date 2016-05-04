//
//  TongZhiViewController.m
//  DDZF
//
//  Created by 王健超 on 15/12/4.
//  Copyright (c) 2015年 wjc. All rights reserved.
//

#import "TongZhiViewController.h"
#import "MJRefresh.h"
#import "PostAsynClass.h"
#import "User.h"
#import "MyNavigationBar.h"
#import "Header.h"
#import "TongZhiTableViewCell.h"
@interface TongZhiViewController ()<UITableViewDataSource,UITableViewDelegate,MJRefreshBaseViewDelegate>

{
    
    MJRefreshHeaderView *_header;
    
    MJRefreshFooterView *_footer;
    NSDateFormatter *_formatter;
    NSString *_timeStr;
    NSString *_timeStr1;
    int _pageNum;
    
    NSArray *_data;
    
    NSDictionary *dicc;
    UITableView *_table;
     NSMutableArray *_dataArr;
    
}


@end

@implementation TongZhiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataArr = [NSMutableArray arrayWithCapacity:0];
    _pageNum=1;
    [self LoadData];
    [self makeNav];
    [self makeUI];
    self.view.backgroundColor=[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0];
    // Do any additional setup after loading the view.
}
-(void)makeNav
{
    
    //状态栏颜色
    UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320*screenWidth/320, 20*screenWidth/320)];
    
    statusBarView.backgroundColor=[UIColor whiteColor];
    
    [self.view addSubview:statusBarView];
    //导航
    [self.navigationController setNavigationBarHidden:YES];
    
    MyNavigationBar *mnb = [[MyNavigationBar alloc] init];
    mnb.frame = CGRectMake(0, 20*screenWidth/320, 320*screenWidth/320, 44*screenWidth/320);
    [mnb createMyNavigationBarWithBgImageName:nil andLeftBBIIamgeNames:[NSArray arrayWithObject:@"fanhui.png"] andRightBBIImages:nil andTitle:@"消息记录" andClass:self andSEL:@selector(bacClick:)];
    [self.view addSubview:mnb];
    
    
}
-(void)bacClick:(UIButton*)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)makeUI
{
    
    _table= [[UITableView alloc] initWithFrame:CGRectMake(0, 64.6*screenWidth/320, self.view.frame.size.width, self.view.frame.size.height-64.6*screenWidth/320) style:UITableViewStylePlain];//实例化，两种类型plain、group
    //两个代理
    _table.delegate = self;
    _table.dataSource = self;
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
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
    

    NSMutableURLRequest *rever = [PostAsynClass postAsynWithURL:url1 andInterface:url38 andKeyArr:@[@"merId",@"beginDate",@"endDate",@"pageNum",@"pageSize"]andValueArr:@[user.merid,_timeStr,_timeStr1,[NSString stringWithFormat:@"%d",_pageNum],@"12"]];
    NSData *receive = [NSURLConnection sendSynchronousRequest:rever returningResponse:nil error:nil];
    
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        NSString  *str = [[NSString alloc] initWithData:receive encoding:enc];
    
    NSData *ata = [NSData alloc];
    
    ata = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:ata options:NSJSONReadingMutableLeaves error:nil];
    //    NSLog(@"yonghushifoucunzai%@,%@",dic,self.navigationController);
    NSString *sre1 = [dic objectForKey:@"respDesc"];
    if(![[dic objectForKey:@"respCode"]isEqualToString:@"000"])
    {
        [self toastResult:sre1];
    }
    if ([[dic objectForKey:@"respCode"] isEqualToString:@"000"])
    {
        _data=[dic objectForKey:@"ordersInfo"];
        for(dicc in _data)
        {
            
            [_dataArr addObject:dicc];
            
        }
         [_table reloadData];
        if(_dataArr.count<1)
        {
            UIAlertView *alat = [[UIAlertView alloc] initWithTitle:@"提示" message:@"近期内你还没有消息通知" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            
            [alat show];
            
            return;
        }
        
        NSLog(@"输出消息%@",_dataArr);

    }

}
//每一段有多少行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _dataArr.count;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 130*screenWidth/320.0;
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //做一个标识
    static NSString *str=@"iden";
    TongZhiTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:str];
    if (cell==nil) {
        cell=[[TongZhiTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
        
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.backgroundColor=[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0];
    cell.kefuImage.image=[UIImage imageNamed:@"beforeImage"];
    cell.kuangImage.image=[UIImage imageNamed:@"kuangImage"];
    NSRange range1=NSMakeRange(0, 4);
    NSRange range2=NSMakeRange(4, 2);
    NSRange range3=NSMakeRange(6, 2);
    cell.createTime.text=[NSString stringWithFormat:@"%@-%@-%@",[_dataArr[indexPath.row][@"createDate"] substringWithRange:range1],[_dataArr[indexPath.row][@"createDate"] substringWithRange:range2],[_dataArr[indexPath.row][@"createDate"] substringWithRange:range3]];
    
    NSRange ran1=NSMakeRange(0, 2);
    NSRange ran2=NSMakeRange(2, 2);
    NSRange ran3=NSMakeRange(4, 2);
    cell.createTime1.text=[NSString stringWithFormat:@"%@:%@:%@",[_dataArr[indexPath.row][@"createTime"] substringWithRange:ran1],[_dataArr[indexPath.row][@"createTime"] substringWithRange:ran2],[_dataArr[indexPath.row][@"createTime"] substringWithRange:ran3]];
    cell.contentLabel.text=_dataArr[indexPath.row][@"msgCon"];
    return cell;
    
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
