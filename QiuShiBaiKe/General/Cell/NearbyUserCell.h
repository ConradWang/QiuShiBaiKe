//
//  NearbyUserCell.h
//  QiuShiBaiKe
//
//  Created by conrad on 14-7-17.
//  Copyright (c) 2014年 conrad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NearbyUser.h"

@interface NearbyUserCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *icon;
@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UILabel *signature;
@property (strong, nonatomic) IBOutlet UILabel *distanceAndTime;
@property (strong, nonatomic) IBOutlet UIView *ageView;
@property (strong, nonatomic) IBOutlet UILabel *sexAndAge;

- (void)configNearbyUserCellWithNearbyUser:(NearbyUser *)nearbyUser;

@end
