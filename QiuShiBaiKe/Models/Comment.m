//
//  Comment.m
//  QiuShiBaiKe
//
//  Created by conrad on 14-7-8.
//  Copyright (c) 2014年 conrad. All rights reserved.
//

#import "Comment.h"

@implementation Comment

- (id)initWithCommentDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        self.totalHeight = 25;
        self.commentID = [dictionary objectForKey:@"id"];
        self.content = [dictionary objectForKey:@"content"];
        if (IOS7_AND_LATER) {
            self.contentSize = [self.content boundingRectWithSize:CGSizeMake(230, 2000)
                                                     options:NSStringDrawingUsesLineFragmentOrigin
                                                  attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0]}
                                                     context:nil
                           ].size;
        } else {
            self.contentSize = [self.content sizeWithFont:[UIFont systemFontOfSize:15.0] constrainedToSize:CGSizeMake(230, 2000)];
        }
        self.totalHeight += self.contentSize.height + 15;
        
        self.floor = [[dictionary objectForKey:@"floor"] integerValue];

        NSDictionary *user = [dictionary objectForKey:@"user"];
        self.author = [user objectForKey:@"login"];
        self.authorID = [user objectForKey:@"id"];
        id authorImageURL = [user objectForKey:@"icon"];
        if ((NSNull *)authorImageURL != [NSNull null]) {
            self.authorImageURL = [user objectForKey:@"icon"];
            NSString *prefixAuthorID = nil;
            if ([_authorID length] > 7) {
                prefixAuthorID = [_authorID substringWithRange:NSMakeRange(0, 4)];
            } else {
                prefixAuthorID = [_authorID substringWithRange:NSMakeRange(0, 3)];
            }
            NSString *newAuthorImageURL = [NSString stringWithFormat:@"http://pic.qiushibaike.com/system/avtnew/%@/%@/medium/%@", prefixAuthorID, _authorID, _authorImageURL];
            self.authorImageURL = newAuthorImageURL;
        }
    }
    
    return self;
}


@end
