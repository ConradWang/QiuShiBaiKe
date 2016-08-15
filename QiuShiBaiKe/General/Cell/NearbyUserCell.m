//
//  NearbyUserCell.m
//  QiuShiBaiKe
//
//  Created by conrad on 14-7-17.
//  Copyright (c) 2014年 conrad. All rights reserved.
//

#import "NearbyUserCell.h"
#import "UIImageView+WebCache.h"

@implementation NearbyUserCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
/*
UIImageView *icon;
UILabel *name;
UILabel *signature;
UILabel *distanceAndTime;
UIView *ageView;
UILabel *sexAndAge;
 */
- (void)configNearbyUserCellWithNearbyUser:(NearbyUser *)nearbyUser
{
    [self.icon setImageWithURL:[NSURL URLWithString:nearbyUser.icon] placeholderImage:[UIImage imageNamed:@"placeholder_icon"]];
    [self.icon.layer setMasksToBounds:YES];
    [self.icon.layer setCornerRadius:(self.icon.frame.size.width / 2)];
    
    
    
    self.name.text = nearbyUser.name;
    self.signature.text = nearbyUser.signature;
    self.distanceAndTime.text = [NSString stringWithFormat:@"%@ | %@", nearbyUser.distance, nearbyUser.lastVisitTime];
    
    NSString *prefixSexAndAge = @"";
    if ([nearbyUser.gender isEqualToString:@"F"]) {
        prefixSexAndAge = @"♀";
        self.ageView.backgroundColor = UIColorFromRGB(0xF0A6CD);
    }
    else {
        prefixSexAndAge = @"♂";
        self.ageView.backgroundColor = UIColorFromRGB(0xABD2FC);
    }
    self.sexAndAge.text = [NSString stringWithFormat:@"%@ %@", prefixSexAndAge, nearbyUser.age];
    [self.ageView.layer setMasksToBounds:YES];
    [self.ageView.layer setCornerRadius:2];
}

@end
