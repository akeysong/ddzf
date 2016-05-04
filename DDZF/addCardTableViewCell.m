//
//  addCardTableViewCell.m
//  The territory of payment
//
//  Created by 铂金数据 on 15/7/14.
//  Copyright (c) 2015年 铂金数据. All rights reserved.
//

#import "addCardTableViewCell.h"
#import "Header.h"
@implementation addCardTableViewCell

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
    
    
    self.cardImage=[[UIImageView alloc] initWithFrame:CGRectMake(10*screenWidth/320.0, 10*screenWidth/320.0, 40*screenWidth/320.0, 40*screenWidth/320.0)];
    self.cardImage.image=[UIImage imageNamed:@""];
    [self.contentView addSubview:self.cardImage];
    
    
    self. openAcctId=[[UILabel alloc] initWithFrame:CGRectMake(55*screenWidth/320, 30*screenWidth/320, 150*screenWidth/320, 20*screenWidth/320)];
    self.openAcctId.textColor=[UIColor blackColor];
    self.openAcctId.textAlignment=NSTextAlignmentLeft;
    self.openAcctId.font=[UIFont boldSystemFontOfSize:15];
    [self.contentView addSubview:self.openAcctId];

    
    self.openAcctName=[[UILabel alloc] initWithFrame:CGRectMake(55*screenWidth/320, 10*screenWidth/320, 100*screenWidth/320, 20*screenWidth/320)];
    self.openAcctName.textColor=[UIColor blackColor];
    self.openAcctName.textAlignment=NSTextAlignmentLeft;
    self.openAcctName.font=[UIFont boldSystemFontOfSize:15];
    [self.contentView addSubview:self.openAcctName];
    
    self.isDefault=[[UILabel alloc] initWithFrame:CGRectMake(220*screenWidth/320, 30*screenWidth/320, 70*screenWidth/320, 30*screenWidth/320)];
    self.isDefault.textColor=[UIColor blackColor];
    self.isDefault.textAlignment=NSTextAlignmentRight;
    self.isDefault.font=[UIFont boldSystemFontOfSize:15];
    [self.contentView addSubview:self.isDefault];
   
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
