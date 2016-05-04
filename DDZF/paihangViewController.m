//
//  paihangViewController.m
//  Theterritoryofpayment
//
//  Created by 铂金数据 on 15/11/9.
//  Copyright (c) 2015年 铂金数据. All rights reserved.
//

#define kCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]


#import "paihangViewController.h"
#import "UIView+Ex.h"
#import "MyNavigationBar.h"
#import "Header.h"
#import "User.h"
#import "PostAsynClass.h"
#import "UIImageView+WebCache.h"
#import "paihangTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "xiangqingViewController.h"
#import "UIButton+myButton.h"

@interface paihangViewController ()<UITableViewDelegate>
{
    MyNavigationBar *mnb;
    UITableView *_table;
    UIImageView *navImage;
    //loadData
    NSDateFormatter *_formatter;
    NSString *_timeStr;
    NSString *_timeStr1;
    NSArray *_data;
    
    BOOL _stelect;
    int _pageNum;
    
    NSMutableArray *_dataArr;
    
    UIView *view1;
    UIView *view2;
    UISegmentedControl *segmentedControl;
    
    //NSDictionary *dicc;
    
    NSInteger Index;
    
    CGRect cgrect;
    
    NSDictionary *_dic3;
    
    UIButton *_button1;
    UIButton *_button2;
    
    UILabel *jifenLabel;

}

@end

@implementation paihangViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataArr = [NSMutableArray arrayWithCapacity:0];
    _stelect=YES;
    self.view.backgroundColor =[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0];
    _pageNum = 1;
    
    [self makeTable];
    [self loadData];
    [self makeNav];
    [self makebutton];
    [self view1];

}
-(void)makeNav
{
    User *user=[User currentUser];
    
    navImage=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 150*screenWidth/320.0)];
    navImage.image=[UIImage imageNamed:@"paihangbangbg@2x.png"];
    navImage.userInteractionEnabled=YES;
    [self.view addSubview:navImage];
    
    UILabel *titileLabel=[[UILabel alloc] initWithFrame:CGRectMake(50*screenWidth/320.0, 20*screenWidth/320.0, self.view.frame.size.width-100*screenWidth/320.0, 44*screenWidth/320.0)];
    titileLabel.text=@"积分排行榜";
    titileLabel.font=[UIFont systemFontOfSize:20];
    titileLabel.textAlignment=NSTextAlignmentCenter;
    titileLabel.textColor=[UIColor whiteColor];
    [navImage addSubview:titileLabel];
    
    UIButton *xiangqingButton=[UIButton buttonWithType:UIButtonTypeCustom];
    xiangqingButton.frame=CGRectMake(self.view.frame.size.width-50*screenWidth/320.0, 22*screenWidth/320.0, 40*screenWidth/320.0, 40*screenWidth/320.0);
    [xiangqingButton setImage:[UIImage imageNamed:@"hdlw"] forState:UIControlStateNormal];
    [xiangqingButton addTarget:self action:@selector(xqBtn) forControlEvents:UIControlEventTouchUpInside];
    //[navImage addSubview:xiangqingButton];
    
    UIButton *backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame=CGRectMake(10*screenWidth/320.0, 20*screenWidth/320.0, 30*screenWidth/320.0, 44*screenWidth/320.0);
    [backButton setImage:[UIImage imageNamed:@"title_back.png"] forState:UIControlStateNormal];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(10*screenWidth/320.0, 5*screenWidth/320.0, 10*screenWidth/320.0, 5*screenWidth/320.0)];
    [backButton addTarget:self action:@selector(backBtn) forControlEvents:UIControlEventTouchUpInside];
    [navImage addSubview:backButton];
    
    UIImageView *headImage=[[UIImageView alloc] initWithFrame:CGRectMake(20*screenWidth/320.0, 80*screenWidth/320.0, 60*screenWidth/320.0, 60*screenWidth/320.0)];
    headImage.layer.cornerRadius=10;
    headImage.clipsToBounds=YES;
    if(user.headImage.length<=0)
    {
        headImage.image=[UIImage imageNamed:@"touxiang@2x.png"];
    }
    else
    {
        [headImage setImageWithURL:[NSURL URLWithString:user.headImage]];
        NSLog(@"输出头像为%@",user.headImage);
    }
    [navImage addSubview:headImage];
    
    UILabel *nameLabel=[[UILabel alloc] initWithFrame:CGRectMake(85*screenWidth/320.0, 82.5*screenWidth/320.0, 100*screenWidth/320.0, 30*screenWidth/320.0)];
    nameLabel.text=user.name;
    nameLabel.textAlignment=NSTextAlignmentLeft;
    nameLabel.textColor=[UIColor whiteColor];
    nameLabel.font=[UIFont systemFontOfSize:15*screenWidth/320.0];
    nameLabel.adjustsFontSizeToFitWidth=YES;
    [navImage addSubview:nameLabel];
    
    UILabel *tellLabel=[[UILabel alloc] initWithFrame:CGRectMake(85*screenWidth/320.0, 115*screenWidth/320.0, 100*screenWidth/320.0, 20*screenWidth/320.0)];
    tellLabel.text=user.phoneText;
    tellLabel.textAlignment=NSTextAlignmentLeft;
    tellLabel.textColor=[UIColor whiteColor];
    tellLabel.font=[UIFont systemFontOfSize:12*screenWidth/320.0];
    tellLabel.adjustsFontSizeToFitWidth=YES;
    [navImage addSubview:tellLabel];
    
    jifenLabel=[[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width-170*screenWidth/320.0, 80*screenWidth/320.0, 150*screenWidth/320.0, 30*screenWidth/320.0)];
    jifenLabel.textColor=[UIColor whiteColor];
    jifenLabel.textAlignment=NSTextAlignmentRight;
    jifenLabel.font=[UIFont systemFontOfSize:14*screenWidth/320.0];
    if(user.yuejiFen.length==0)
    {
        jifenLabel.text=[NSString stringWithFormat:@"月积分:0"];
    }
    else
    {
        jifenLabel.text=[NSString stringWithFormat:@"月积分:%d",[user.yuejiFen intValue]];
    }
    [navImage addSubview:jifenLabel];
    
    UILabel *paihangLabel=[[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width-170*screenWidth/320.0, 110*screenWidth/320.0, 150*screenWidth/320.0, 30*screenWidth/320.0)];
    paihangLabel.textColor=[UIColor whiteColor];
    paihangLabel.textAlignment=NSTextAlignmentRight;
    paihangLabel.font=[UIFont systemFontOfSize:14*screenWidth/320.0];
    if([[_dataArr lastObject][@"rankNo"] length]<=0)
    {
        paihangLabel.text=[NSString stringWithFormat:@"积分排行:"];
    }
    else
    {
        paihangLabel.text=[NSString stringWithFormat:@"积分排行:%@",[_dataArr lastObject][@"rankNo"]];
    }
    [navImage addSubview:paihangLabel];
}
-(void)xqBtn
{
    xiangqingViewController *xvc=[[xiangqingViewController alloc] init];
    [self.navigationController pushViewController:xvc animated:YES];
}
-(void)backBtn
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)makeTable
{
    cgrect = CGRectMake(0,40*screenWidth/320, self.view.frame.size.width,self.view.frame.size.height-236*screenWidth/320);
    _table.backgroundColor=[UIColor whiteColor];
    _table = [[UITableView alloc]initWithFrame: cgrect style:UITableViewStylePlain] ;
    
    //两个代理
    _table.delegate = self;
    _table.dataSource = self;
    _table.tableFooterView=[[UIView alloc]init];
    _table.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    //    //实例化header和footer
    //
    _header = [MJRefreshHeaderView header];
    _header.scrollView = _table;
    //    //设置header和footer的滚动视图位table
    _footer = [MJRefreshFooterView footer];
    _footer.scrollView = _table;
    //    //设置header footer的代理
    _header.delegate = self;
    _footer.delegate = self;
    
}
-(void)makebutton
{
    
    _button1 =[UIButton buttonWithType:UIButtonTypeSystem];
    _button1.frame=CGRectMake(0, 150*screenWidth/320.0, self.view.frame.size.width/2, 45*screenWidth/320.0);
    [_button1 makeUI:@"排行榜" :YES];
    [_button1  addTarget:self action:@selector(btn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_button1];
    
    
    _button2 =[UIButton buttonWithType:UIButtonTypeSystem];
    _button2.frame=CGRectMake(self.view.frame.size.width/2, 150*screenWidth/320.0, self.view.frame.size.width/2, 45*screenWidth/320.0);
    [_button2 makeUI:@"积分详情" :NO];
    [_button2  addTarget:self action:@selector(btn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_button2];
    
    //全部收款和成功交易之间的竖线
    UIView *lineview=[[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-1, 64, 1, 50)];
    lineview.backgroundColor=[UIColor grayColor];
    //[self.view addSubview:lineview];
    
    //全部收款和成功交易底部的横线
    UIView *lineview1=[[UIView alloc] initWithFrame:CGRectMake(0,195*screenWidth/320.0, self.view.frame.size.width, 1)];
    lineview1.backgroundColor=[UIColor lightGrayColor];
    [self.view addSubview:lineview1];
}
-(void)view1
{
    
    view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 196*screenWidth/320, self.view.frame.size.width, self.view.frame.size.height-196*screenWidth/320.0)];
    view1.backgroundColor   = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0];
    [self.view addSubview:view1];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0,0 , screenWidth, 40*screenWidth/320)];
    view.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0];
    [view1 addSubview:view];
    
    UIView *footview = [[UIView alloc]initWithFrame:CGRectMake(0,screenHeight-104*screenWidth/320, screenWidth, 40*screenWidth/320)];
    
    footview.backgroundColor = [UIColor grayColor];
    
    // [view1 addSubview:footview];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 15*screenWidth/320, self.view.frame.size.width, 15*screenWidth/320)];
    label.text = @"每月前10名将获得神秘礼品,敬请期待！";
    label.textColor = [UIColor redColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:15*screenWidth/320];
    
    //[footview addSubview:label];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 20*screenWidth/320, screenWidth, 15*screenWidth/320)];
    
    btn.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    //[btn addTarget:self action:@selector(touch) forControlEvents:UIControlEventTouchUpInside];
    
    //[footview addSubview:btn];
    for (int i = 0; i < 3; ++i) {
        NSArray *array = @[@"排名",@"姓名/电话",@"当月积分"];
        UILabel *pai = [[UILabel alloc]initWithFrame:CGRectMake((10+i*108)*screenWidth/320, 10*screenWidth/320, 80*screenWidth/320.0, 20*screenWidth/320)];
        
        pai.textColor = [UIColor grayColor];
        pai.text = array[i];
        
        if (i == 2) {
            
            pai.textAlignment = NSTextAlignmentRight;
        }
        [view addSubview:pai];
    }
    
    UIView *lineview=[[UIView alloc] initWithFrame:CGRectMake(0, 39.2*screenWidth/320.0, self.view.frame.size.width, 0.8*screenWidth/320.0)];
    lineview.backgroundColor=[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0];
    [view addSubview:lineview];
    //segmentedControl.selectedSegmentIndex = 0;//设置默认选择项索引
    
    //设置代理
    for (int i = 0; i < 3; ++i) {
        
        NSArray *array = @[@"diyi",@"dier",@"disan"];
        UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(20*screenWidth/320, (8+35*i)*screenWidth/320, 20*screenWidth/320,20*screenWidth/320)];
        image.image = [UIImage imageNamed:array[i]];
        [_table addSubview:image];
        
    }
    
    //禁止table滑动
    
    
    //    _table.scrollEnabled =NO;
    
    [view1 addSubview:_table];
}

-(void)touch

{
    xiangqingViewController *xiang = [[xiangqingViewController alloc]init];
    [self.navigationController pushViewController:xiang animated:YES];
}
-(void)view2
{
    view2 = [[UIView alloc]initWithFrame:CGRectMake(0, 196*screenWidth/320, self.view.frame.size.width, self.view.frame.size.height-196*screenWidth/320.0)];
    view2.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0];
    [self.view addSubview:view2];
    //segmentedControl.selectedSegmentIndex = 1;//设置默认选择项索引
    
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0,0 , self.view.frame.size.width, 40*screenWidth/320)];
    view.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0];
    [view2 addSubview:view];
    
    NSArray *array = @[@"积分来源",@"产生日期",@"产生积分"];
    for (int i = 0; i < 3; ++i) {
        UILabel *pai = [[UILabel alloc]initWithFrame:CGRectMake(0+i*self.view.frame.size.width/3, 10*screenWidth/320, self.view.frame.size.width/3, 20*screenWidth/320)];
        pai.textColor = [UIColor grayColor];
        pai.text = array[i];
        pai.font=[UIFont systemFontOfSize:13*screenWidth/320.0];
        pai.adjustsFontSizeToFitWidth=YES;
        pai.textAlignment=NSTextAlignmentCenter;
        //        if (i == 2) {
        //
        //            pai.textAlignment = NSTextAlignmentRight;
        //        }
        [view addSubview:pai];
    }
    
    UIView *lineview2=[[UIView alloc] initWithFrame:CGRectMake(0, 39.2*screenWidth/320.0, self.view.frame.size.width, 0.8*screenWidth/320.0)];
    lineview2.backgroundColor=[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0];
    [view addSubview:lineview2];
    
    [view2 addSubview:_table];
}

-(void)btn:(UIButton*)btndown
{
    User *user=[User currentUser];
    [_dataArr removeAllObjects];
    
    [_header free];
    [_footer free];
    
    if (btndown==_button1) {
        jifenLabel.text=[NSString stringWithFormat:@"月积分:%@",user.yuejiFen];
        _stelect=YES;
        [self makeTable];
        [self view1];
        [_button1 makeUI:@"排行榜" :YES];
        [_button2 makeUI:@"积分详情" :NO];
        //            if (_dataArr.count<1)
        //            {
        //                [_table removeFromSuperview];
        //            }
    }
    else{
        jifenLabel.text=[NSString stringWithFormat:@"总积分:%@",user.jiFen];
        _stelect=NO;
        [self makeTable];
        [self view2];
        [_button1 makeUI:@"排行榜" :NO];
        [_button2 makeUI:@"积分详情" :YES];
    }
    [self loadData];
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
    NSLog(@"========================%@",_timeStr);
    
    
    NSDate *nowDate=[NSDate date];
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    formatter.dateFormat=@"yyyyMMdd";
    NSTimeZone *nowZone1=[NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:nowZone1];
    _timeStr1=[formatter stringFromDate:nowDate];
    NSLog(@"------------------------%@",_timeStr1);
    //
    NSString *a=[NSString stringWithFormat:@"%d",_pageNum];
    //
    NSLog(@"------------------------+++++++++%@",a);
    NSMutableURLRequest *rever;
    
    
    if (_stelect == YES ) {
        
        rever =[PostAsynClass postAsynWithURL:url1 andInterface:url39 andKeyArr:nil andValueArr:nil];
    }
    else
    {
        rever =[PostAsynClass postAsynWithURL:url1 andInterface:url12 andKeyArr:@[@"merId",@"beginDate",@"endDate",@"pageNum",@"pageSize"]andValueArr:@[user.merid,_timeStr,_timeStr1,[NSString stringWithFormat:@"%d",_pageNum],@"12"]];
    }
    
    NSData *receive = [NSURLConnection sendSynchronousRequest:rever returningResponse:nil error:nil];
    
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    
    
    //NSString *string=[receive stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString  *str = [[NSString alloc] initWithData:receive encoding:enc];
    
    NSData *ata = [NSData alloc];
    
    ata = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:ata options:NSJSONReadingMutableLeaves error:nil];
    NSLog(@"------------------------%@",dic);
    //
    if(![[dic objectForKey:@"respCode"] isEqual:@"000"])
    {
        [self toastResult:[dic objectForKey:@"respDesc"]];
        return;
    }
    else
    {
        _data=[dic objectForKey:@"ordersInfo"];
        for(NSDictionary *dicc in _data)
        {
            [_dataArr addObject:dicc];
            NSLog(@"ddddddddd%@",dicc );
            NSLog(@"Eeeeeeee%@",_dataArr);
        }
    }
    NSLog(@"777eygeyfgggihdihdhh5%@",_dataArr);
    [_table reloadData];
    
    if (_dataArr.count <1&&Index == 1) {
        
        UIAlertView *alat = [[UIAlertView alloc] initWithTitle:@"提示" message:@"近期内你还没有积分记录" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        
        [alat show];
        user.yuejiFen=@"0";
        
    }
    else
    {
        user.yuejiFen=[_dataArr lastObject][@"transAmt"];
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

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    
    if (_stelect==YES) {
        
        if (indexPath.row %2 == 1) {
            cell.contentView.backgroundColor = [UIColor colorWithRed:236/255.0 green:236/255.0 blue:236/255.0 alpha:1];
        }
    }
}
#pragma mark tableview 的代理

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    NSUInteger i;
    
    if (_stelect==YES) {
        
        i =  _dataArr.count-1;
    }
    else
    {
        i = _dataArr.count;
        
    }
    return i;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath

{
    return  35*screenWidth/320;
}

//展现cell内容

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //做一个标识
    static NSString *str=@"iden";
    
    paihangTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:str];
    if (cell==nil) {
        cell=[[paihangTableViewCell  alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
        
    }
    
    // NSLog(@"$$$$$$$$$$$$$%ld",(long)Index);
    
    
    if (_stelect==YES) {
        
        cell.merId.text=_dataArr[indexPath.row][@"merId"];
        cell.merName.text=_dataArr[indexPath.row][@"merName"];
        NSString *ming = [cell.merName.text substringToIndex:1];
        
        cell.merMp.text=_dataArr[indexPath.row][@"merMp"];
        NSString*before=[cell.merMp.text substringToIndex:3];
        
        NSString*after=[cell.merMp.text substringFromIndex:7];
        
        cell.merMp.text = [[NSString alloc] initWithFormat:@"%@****%@", before, after];
        
        cell.merName.text = [[NSString alloc]initWithFormat:@"%@**",ming];
        
        
        if(indexPath.row<3)
        {
            cell.rankNo.text =nil;
        }
        else
        {
            cell.rankNo.text = _dataArr[indexPath.row][@"rankNo"];
        }
        
        NSString *trans = _dataArr[indexPath.row][@"transAmt"];
        
        int i = [trans intValue];
        
        cell.transAmt.text = [NSString stringWithFormat:@"%d",i];
        
        
    }
    else
    {
        //            cell.transDate.text=_dataArr[indexPath.row][@"transDate"];
        
        NSRange range1=NSMakeRange(0, 4);
        NSRange range2=NSMakeRange(4, 2);
        NSRange range3=NSMakeRange(6, 2);
        NSString *string1=[NSString stringWithFormat:@"%@-%@-%@",[_dataArr[indexPath.row][@"transDate"] substringWithRange:range1],[_dataArr[indexPath.row][@"transDate"] substringWithRange:range2],[_dataArr[indexPath.row][@"transDate"] substringWithRange:range3]];
        //cell.transDate.text=string1;
        
        NSRange ran1=NSMakeRange(0, 2);
        NSRange ran2=NSMakeRange(2, 2);
        NSRange ran3=NSMakeRange(4, 2);
        NSString *string2=[NSString stringWithFormat:@"%@:%@:%@",[_dataArr[indexPath.row][@"transTime"] substringWithRange:ran1],[_dataArr[indexPath.row][@"transTime"] substringWithRange:ran2],[_dataArr[indexPath.row][@"transTime"] substringWithRange:ran3]];
        cell.cssj.text=[NSString stringWithFormat:@"%@ %@",string1,string2];
        int a = [_dataArr[indexPath.row][@"transAmt"] intValue];
        cell.csjf.text=[NSString stringWithFormat:@"%d",a];
        //
        NSString *name=_dataArr[indexPath.row][@"scoreSrc"];
        NSString *nnn=[name stringByReplacingOccurrencesOfString:@"产生积分" withString:@""];
        cell.jfly.text = nnn;
    }
    
    return cell;
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
        
        //[_dataArr removeAllObjects];
        if(_stelect==YES)
        {
            [_dataArr removeAllObjects];
            [self loadData];
        }
        else
        {
            _pageNum+=1;
            [self loadData];
        }
    }
    
    [refreshView endRefreshing];
    //结束刷新，归位
}
- (void)dealloc
{
    [_header free];
    [_footer free];
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


@end
