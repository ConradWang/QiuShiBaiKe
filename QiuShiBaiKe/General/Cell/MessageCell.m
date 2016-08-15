//
//  MessageCell.m
//  QiuShiBaiKe
//
//  Created by conrad on 14-7-21.
//  Copyright (c) 2014年 conrad. All rights reserved.
//

#import "MessageCell.h"
#import "UIImageView+WebCache.h"

@implementation MessageCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configMessageCellWithMessage:(Message *)message
{
    [_user_icon setImageWithURL:[NSURL URLWithString:message.user_icon] placeholderImage:[UIImage imageNamed:@"placeholder_icon"]];
    [_user_icon.layer setMasksToBounds:YES];
    [_user_icon.layer setCornerRadius:_user_icon.frame.size.width / 2];
    
    _user_login.text = message.user_login;
    _msg_content.text = message.msg_content;
    _msg_createTime.text = message.msg_createTime;
}

@end
