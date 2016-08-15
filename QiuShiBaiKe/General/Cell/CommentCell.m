//
//  CommentCell.m
//  QiuShiBaiKe
//
//  Created by conrad on 14-7-11.
//  Copyright (c) 2014年 conrad. All rights reserved.
//

#import "CommentCell.h"
#import "UIImageView+WebCache.h"

@implementation CommentCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configCommentCellWithComment:(Comment *)comment
{
    [self.userIcon setImageWithURL:[NSURL URLWithString:comment.authorImageURL] placeholderImage:[UIImage imageNamed:@"placeholder_icon.png"]];
    [_userIcon.layer setMasksToBounds:YES];
    [_userIcon.layer setCornerRadius:18.5];
    self.name.text = comment.author;
    self.content.text = comment.content;
    self.floor.text = [NSString stringWithFormat:@"%d", comment.floor];
    
    // Config content'size
    self.content.frame = CGRectMake(65, 30, 230, comment.contentSize.height);
}

@end
