//
//  JiLuTableViewCell.m
//  DDZF
//
//  Created by 王健超 on 15/12/7.
//  Copyright (c) 2015年 wjc. All rights reserved.
//

#import "JiLuTableViewCell.h"
#import "Header.h"
@implementation JiLuTableViewCell

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
    self.createTimaLabel=[[UILabel alloc] initWithFrame:CGRectMake(20*screenWidth/320.0, 5*screenWidth/320.0, 150*screenWidth/320.0, 20*screenWidth/320.0)];
    self.createTimaLabel.font=[UIFont systemFontOfSize:14];
    self.createTimaLabel.textAlignment=NSTextAlignmentLeft;
    [self.contentView addSubview:self.createTimaLabel];
    
    self.nameLabel=[[UILabel alloc] initWithFrame:CGRectMake(20*screenWidth/320.0, 25*screenWidth/320.0,150*screenWidth/320.0, 20*screenWidth/320.0)];
    self.nameLabel.textAlignment=NSTextAlignmentLeft;
    self.nameLabel.font=[UIFont systemFontOfSize:14];
    [self.contentView addSubview:self.nameLabel];
    
    self.numLabel=[[UILabel alloc] initWithFrame:CGRectMake(screenWidth-120*screenWidth/320.0, 5*screenWidth/320.0, 100*screenWidth/320.0, 20*screenWidth/320.0)];
    self.numLabel.textAlignment=NSTextAlignmentRight;
    self.numLabel.font=[UIFont systemFontOfSize:14];
    [self.contentView addSubview:self.numLabel];
    
    self.contentLabel=[[UILabel alloc] initWithFrame:CGRectMake(screenWidth-120*screenWidth/320.0, 25*screenWidth/320.0, 100*screenWidth/320.0, 20*screenWidth/320.0)];
    self.contentLabel.textAlignment=NSTextAlignmentRight;
    self.contentLabel.font=[UIFont systemFontOfSize:14];
    [self.contentView addSubview:self.contentLabel];

    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
