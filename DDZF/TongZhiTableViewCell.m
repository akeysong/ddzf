//
//  TongZhiTableViewCell.m
//  DDZF
//
//  Created by 王健超 on 15/12/4.
//  Copyright (c) 2015年 wjc. All rights reserved.
//

#import "TongZhiTableViewCell.h"
#import "Header.h"
#import "myLabel.h"
@implementation TongZhiTableViewCell

- (void)awakeFromNib {
    // Initialization code
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        [self makeUI];
    }
    return self;
}
-(void)makeUI
{

    _kefuImage=[[UIImageView alloc] initWithFrame:CGRectMake(10*screenWidth/320.0, 10*screenWidth/320.0, 40*screenWidth/320.0, 40*screenWidth/320.0)];
    [self.contentView addSubview:_kefuImage];
    
    _kuangImage=[[UIImageView alloc] initWithFrame:CGRectMake(55*screenWidth/320.0, 10*screenWidth/320.0, screenWidth-75*screenWidth/320.0, 70*screenWidth/320.0)];
    [self.contentView addSubview:_kuangImage];
    
   _contentLabel=[[myLabel alloc] initWithFrame:CGRectMake(70*screenWidth/320.0, 15*screenWidth/320.0, screenWidth-95*screenWidth/320.0, 60*screenWidth/320.0)];
    _contentLabel.font=[UIFont systemFontOfSize:14];
    _contentLabel.numberOfLines=0;
    _contentLabel.textAlignment=NSTextAlignmentLeft;
    [_contentLabel setVerticalAlignment:VerticalAlignmentTop];
    [self.contentView addSubview:_contentLabel];
    
    _createTime=[[UILabel alloc] initWithFrame:CGRectMake(68*screenWidth/320.0, 85*screenWidth/320.0, 100*screenWidth/320.0, 15*screenWidth/320.0)];
    _createTime.font=[UIFont systemFontOfSize:12];
    [self.contentView addSubview:_createTime];
    
    
    _leftLineView=[[UIView alloc] initWithFrame:CGRectMake(0, 117.5*screenWidth/320.0, (screenWidth-82*screenWidth/320.0)/2, 0.5*screenWidth/320.0)];
    _leftLineView.backgroundColor=[UIColor grayColor];
    [self.contentView addSubview:_leftLineView];
    
    _rightLineView=[[UIView alloc] initWithFrame:CGRectMake(screenWidth/2+41*screenWidth/320.0, 117.5*screenWidth/320.0,(screenWidth-82*screenWidth/320.0)/2, 0.5*screenWidth/320.0)];
    _rightLineView.backgroundColor=[UIColor grayColor];
    [self.contentView addSubview:_rightLineView];
    
    _createTime1=[[UILabel alloc] initWithFrame:CGRectMake(screenWidth/2-40*screenWidth/320.0, 107.5*screenWidth/320.0, 80*screenWidth/320.0, 20*screenWidth/320.0)];
    _createTime1.textAlignment=NSTextAlignmentCenter;
    _createTime1.font=[UIFont systemFontOfSize:13];
    [self.contentView addSubview:_createTime1];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
