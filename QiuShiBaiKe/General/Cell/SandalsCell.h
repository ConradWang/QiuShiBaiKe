//
//  SandalsCell.h
//  QiuShiBaiKe
//
//  Created by conrad on 14-7-10.
//  Copyright (c) 2014年 conrad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QiuShi.h"
#import "UIImageView+WebCache.h"

@interface SandalsCell : UITableViewCell
{
    IBOutlet UILabel *_separator;
}

@property (strong, nonatomic) IBOutlet UIImageView *userIcon;
@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UILabel *content;
@property (strong, nonatomic) IBOutlet UIImageView *image;

@property (strong, nonatomic) IBOutlet UILabel *up;
@property (strong, nonatomic) IBOutlet UILabel *comment;
@property (strong, nonatomic) IBOutlet UIButton *funnyBtn;
@property (strong, nonatomic) IBOutlet UIButton *badBtn;
@property (strong, nonatomic) IBOutlet UIButton *commentBtn;
@property (strong, nonatomic) IBOutlet UIButton *shareBtn;

- (void)configScandalsCellWithQiuShi:(QiuShi *)qiuShi;

@end
