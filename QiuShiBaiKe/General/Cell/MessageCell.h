//
//  MessageCell.h
//  QiuShiBaiKe
//
//  Created by conrad on 14-7-21.
//  Copyright (c) 2014年 conrad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Message.h"

@interface MessageCell : UITableViewCell
{
    IBOutlet UIImageView *_user_icon;
    IBOutlet UILabel *_user_login;
    IBOutlet UILabel *_msg_content;
    IBOutlet UILabel *_msg_createTime;
}

- (void)configMessageCellWithMessage:(Message *)message;

@end
