//
//  FanYongListViewController.h
//  YunShouYin
//
//  Created by 王健超 on 15/12/17.
//  Copyright (c) 2015年 wjc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefresh.h"
@interface FanYongListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,MJRefreshBaseViewDelegate>

{
    MJRefreshHeaderView *_header;
    
    MJRefreshFooterView *_footer;
}


@end
