//
//  Message.h
//  QiuShiBaiKe
//
//  Created by conrad on 14-7-21.
//  Copyright (c) 2014年 conrad. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Message : NSObject

@property (copy, nonatomic) NSString *msg_id;
@property (copy, nonatomic) NSString *msg_content;
@property (copy, nonatomic) NSString *msg_createTime;

@property (copy, nonatomic) NSString *user_id;
@property (copy, nonatomic) NSString *user_icon;
@property (copy, nonatomic) NSString *user_login;

- (id)initWithMessageDictionary:(NSDictionary *)dictionary;

@end
