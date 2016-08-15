//
//  Message.m
//  QiuShiBaiKe
//
//  Created by conrad on 14-7-21.
//  Copyright (c) 2014年 conrad. All rights reserved.
//

#import "Message.h"

@implementation Message

- (id)initWithMessageDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        // Message
        NSDictionary *msgDic = dictionary[@"message"];
        self.msg_id = [NSString stringWithFormat:@"%@", msgDic[@"id"]];
        self.msg_content = msgDic[@"content"];
        
        self.msg_createTime = [ToolKit getIntervalToNowFromTime:[NSString stringWithFormat:@"%@", msgDic[@"created_at"]]];
        if ([self.msg_createTime hasSuffix:@"天前"]) {
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:[[NSString stringWithFormat:@"%@", msgDic[@"create_at"]] floatValue]];
            NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            self.msg_createTime = [dateFormatter stringFromDate:date];
        }
        
        // User
        NSDictionary *userDic = dictionary[@"user"];
        self.user_id = [NSString stringWithFormat:@"%@", userDic[@"id"]];
        self.user_login = userDic[@"login"];
        
        self.user_icon = [userDic objectForKey:@"icon"];
        NSString *prefixAuthorID = nil;
        if ([self.user_id length] > 7) {
            prefixAuthorID = [self.user_id substringWithRange:NSMakeRange(0, 4)];
        } else {
            prefixAuthorID = [self.user_id substringWithRange:NSMakeRange(0, 3)];
        }
        NSString *newAuthorIconURL = [NSString stringWithFormat:@"http://pic.qiushibaike.com/system/avtnew/%@/%@/medium/%@", prefixAuthorID, self.user_id, self.user_icon];
        self.user_icon = newAuthorIconURL;
    }
    
    return self;
}

@end
