//
//  DuoDuoTongXunViewController.h
//  DDZF
//
//  Created by 王健超 on 16/2/16.
//  Copyright (c) 2016年 wjc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefresh.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
@interface DuoDuoTongXunViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,MJRefreshBaseViewDelegate>
{
    MJRefreshHeaderView *_header;
    
    MJRefreshFooterView *_footer;    
    
}


@end
