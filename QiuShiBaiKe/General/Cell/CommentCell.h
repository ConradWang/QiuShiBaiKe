//
//  CommentCell.h
//  QiuShiBaiKe
//
//  Created by conrad on 14-7-11.
//  Copyright (c) 2014年 conrad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Comment.h"

@interface CommentCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *userIcon;
@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UILabel *content;
@property (strong, nonatomic) IBOutlet UILabel *floor;

- (void)configCommentCellWithComment:(Comment *)comment;

@end
