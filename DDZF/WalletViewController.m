//
//  WalletViewController.m
//  DDZF
//
//  Created by mac on 16/3/28.
//  Copyright (c) 2016年 wjc. All rights reserved.
//
#define UISCREENHEIGHT  self.view.bounds.size.height
#define UISCREENWIDTH  self.view.bounds.size.width
#import "WalletViewController.h"
#import "Header.h"
@interface WalletViewController ()

<UIScrollViewDelegate>
{
    CGFloat imageW;
    CGFloat imageH;

}


@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;

@property (nonatomic, strong) NSTimer *timer;

@property (strong, nonatomic) IBOutlet UIView *HotView;
- (IBAction)RegistCard_Button:(id)sender;
- (IBAction)SaveCard_Button:(id)sender;

- (IBAction)ProgressCard_Button:(id)sender;

- (IBAction)IncreacseCard_Button:(id)sender;
- (IBAction)XinYeQuike_Bank:(id)sender;

- (IBAction)ZhongXinQuike_Card:(id)sender;
- (IBAction)ZhaoShangQuike_Card:(id)sender;

- (IBAction)NongHang_Card:(id)sender;

- (IBAction)HuaQi_Card:(id)sender;

- (IBAction)ZhongXin_Card:(id)sender;



@end



@implementation WalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // Do any additional setup after loading the view, typically from a nib.
  // frameView.layer.borderWidth = 1;
    self.HotView.layer.borderWidth=1;
    
    self.HotView.layer.borderColor=[UIColor colorWithRed:0.00 green:0.09 blue:0.07 alpha:1].CGColor;
    
    
    
    self.HotView.layer.shadowOffset = CGSizeMake(0, 3);  // 设置阴影的偏移量
    self.HotView.layer.shadowRadius = 10.0;  // 设置阴影的半径
    self.HotView.layer.shadowColor = [UIColor blackColor].CGColor; // 设置阴影的颜色为黑色
    self.HotView.layer.shadowOpacity = 0.9; // 设置阴影的不透明度
    
    int count = 5;
    //CGSize size = self.scrollView.frame.size;
    //图片宽
    
    NSLog(@"self.scrollView.frame.size = %@", NSStringFromCGSize(self.scrollView.frame.size));
    
    
    //1 动态生成5个imageView
    for (int i = 0; i < count; i++) {
        //
        UIImageView *iconView = [[UIImageView alloc] init];
        [self.scrollView addSubview:iconView];
        
        NSString *imgName = [NSString stringWithFormat:@"img_%02d",i+1];
        iconView.image = [UIImage imageNamed:imgName];
        
        
        CGFloat x = i * imageW;
        //frame
        iconView.frame = CGRectMake(x, 0, imageW, imageH);
    }
    
    //2 设置滚动范围
    self.scrollView.contentSize = CGSizeMake(count * imageW, 0);
    
    
    self.scrollView.showsHorizontalScrollIndicator = NO;
    //3 设置分页
    self.scrollView.pagingEnabled = YES;
    
    //4 设置pageControl
    self.pageControl.numberOfPages = count;
    
    //5 设置scrollView的代理
    self.scrollView.delegate = self;
    
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
    self.timer = timer;
    //消息循环
    NSRunLoop *runloop = [NSRunLoop currentRunLoop];
    [runloop addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)nextImage
{
    //当前页码
    NSInteger page = self.pageControl.currentPage;
    
    if (page == self.pageControl.numberOfPages - 1) {
        page = 0;
    }else{
        page++;
    }
    
    //    self.scrollView setContentOffset:<#(CGPoint)#> animated:<#(BOOL)#>
    
    CGFloat offsetX = page * self.scrollView.frame.size.width;
    [UIView animateWithDuration:1.0 animations:^{
        self.scrollView.contentOffset = CGPointMake(offsetX, 0);
    }];
    
}

#pragma mark - scrollView的代理方法
//正在滚动的时候
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //   (offset.x + 100/2)/100
    int page = (scrollView.contentOffset.x + scrollView.frame.size.width / 2)/ scrollView.frame.size.width;
    self.pageControl.currentPage = page;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //停止定时器
    [self.timer invalidate];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self addTimerO];
    //    self.timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(nextImage) userInfo:nil repeats:YES];
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



- (IBAction)RegistCard_Button:(id)sender {

    [self toastResult:@"申请"];
}

- (IBAction)SaveCard_Button:(id)sender {
    [self toastResult:@"养卡"];
}

- (IBAction)ProgressCard_Button:(id)sender {
    
    [self toastResult:@"进度"];
}

- (IBAction)IncreacseCard_Button:(id)sender {
    [self toastResult:@"提额"];
}

- (IBAction)XinYeQuike_Bank:(id)sender {
   [self toastResult:@"兴业银行"];
}

- (IBAction)ZhongXinQuike_Card:(id)sender {
       [self toastResult:@"中兴银行"];
}

- (IBAction)ZhaoShangQuike_Card:(id)sender {
       [self toastResult:@"招商银行"];
}

- (IBAction)NongHang_Card:(id)sender {
       [self toastResult:@"农行"];
}

- (IBAction)HuaQi_Card:(id)sender {
       [self toastResult:@"花旗"];
}

- (IBAction)ZhongXin_Card:(id)sender {
       [self toastResult:@"中兴"];
}
@end
