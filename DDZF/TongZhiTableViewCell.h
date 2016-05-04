//
//  TongZhiTableViewCell.h
//  DDZF
//
//  Created by 王健超 on 15/12/4.
//  Copyright (c) 2015年 wjc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "myLabel.h"
@interface TongZhiTableViewCell : UITableViewCell
@property(nonatomic,retain)UIView *leftLineView;
@property(nonatomic,retain)UIView *rightLineView;
@property(nonatomic,retain)UIImageView *kefuImage;
@property(nonatomic,retain)UIImageView *kuangImage;
@property(nonatomic,retain)UILabel *createTime;
@property(nonatomic,retain)UILabel *createTime1;

@property(nonatomic,retain)UILabel *nowTime;
@property(nonatomic,retain)myLabel *contentLabel;
@end
