//
//  tonghuaTableViewCell.m
//  DDZF
//
//  Created by 王健超 on 16/2/17.
//  Copyright (c) 2016年 wjc. All rights reserved.
//

#import "tonghuaTableViewCell.h"
#import "Header.h"
@implementation tonghuaTableViewCell

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
    self.bjhImage=[[UIImageView alloc] initWithFrame:CGRectMake(20*screenWidth/320.0, 10*screenWidth/320.0, 40*screenWidth/320.0, 40*screenWidth/320.0)];
    self.bjhImage.layer.cornerRadius=20*screenWidth/320.0;
    self.bjhImage.clipsToBounds=YES;
    [self.contentView addSubview:self.bjhImage];
    
    self.regMerId=[[UILabel alloc] initWithFrame:CGRectMake(60*screenWidth/320.0, 15*screenWidth/320.0, 150*screenWidth/320.0, 20*screenWidth/320.0)];
    self.regMerId.font=[UIFont systemFontOfSize:13*screenWidth/320.0];
    self.regMerId.adjustsFontSizeToFitWidth=YES;
    self.regMerId.textAlignment=NSTextAlignmentLeft;
    [self.contentView addSubview:self.regMerId];
    
    self.transTime=[[UILabel alloc] initWithFrame:CGRectMake(60*screenWidth/320.0, 35*screenWidth/320.0, 150*screenWidth/320.0, 15*screenWidth/320.0)];
    self.transTime.font=[UIFont systemFontOfSize:12*screenWidth/320.0];
    self.transTime.adjustsFontSizeToFitWidth=YES;
    self.transTime.textAlignment=NSTextAlignmentLeft;
    self.transTime.textColor=[UIColor colorWithRed:0.75 green:0.75 blue:0.75 alpha:1.0];
    [self.contentView addSubview:self.transTime];
    
    self.jiantouImage=[[UIImageView alloc] initWithFrame:CGRectMake(screenWidth-30*screenWidth/320.0, 22.5*screenWidth/320.0, 10*screenWidth/320.0, 15*screenWidth/320.0)];
    [self.contentView addSubview:self.jiantouImage];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
