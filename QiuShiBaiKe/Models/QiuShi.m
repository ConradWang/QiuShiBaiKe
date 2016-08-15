//
//  QiuShi.m
//  QiuShiBaiKe
//
//  Created by conrad on 14-7-8.
//  Copyright (c) 2014年 conrad. All rights reserved.
//

#import "QiuShi.h"

@implementation QiuShi

- (id)initWithQiuShiDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        self.totalHeight = 90;
        if (((NSString *)[dictionary objectForKey:@"tag"]).length > 0) {
            self.tag = [dictionary objectForKey:@"tag"];
        }
        self.qiushiID = [NSString stringWithFormat:@"%@", [dictionary objectForKey:@"id"]];
        self.content = [dictionary objectForKey:@"content"];
        if (IOS7_AND_LATER) {
            self.contentSize = [self.content boundingRectWithSize:CGSizeMake(290, 2000)
                                                      options:NSStringDrawingUsesLineFragmentOrigin
                                                   attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0]}
                                                      context:nil
                           ].size;
        } else {
            self.contentSize = [self.content sizeWithFont:[UIFont systemFontOfSize:15.0] constrainedToSize:CGSizeMake(290, 2000)];
        }
        self.totalHeight += self.contentSize.height;
        
        self.published_at = [[dictionary objectForKey:@"published_at"] doubleValue];
        self.commentsCount = [[dictionary objectForKey:@"comments_count"] integerValue];
        
        id imageSize = [dictionary objectForKey:@"image_size"];
        if ((NSNull *)imageSize != [NSNull null]) {
            NSDictionary *imageSizeDic = [dictionary objectForKey:@"image_size"];
            NSArray *s = [imageSizeDic objectForKey:@"s"];
            self.imageSize = CGSizeMake([s[0] integerValue], [s[1] integerValue]);
            NSArray *m = [imageSizeDic objectForKey:@"m"];
            self.imageMidSize = CGSizeMake([m[0] integerValue], [m[1] integerValue]);
            self.totalHeight += ((SCREEN_WIDTH - 20) / self.imageMidSize.width) * self.imageMidSize.height;
        }
        
        id image = [dictionary objectForKey:@"image"];
        if ((NSNull *)image != [NSNull null]) {
            self.imageURL = [dictionary objectForKey:@"image"];
            NSString *prefixQiuShiID = [_qiushiID substringWithRange:NSMakeRange(0, 5)];
            NSString *newImageURL = [NSString stringWithFormat:@"http://pic.qiushibaike.com/system/pictures/%@/%@/small/%@", prefixQiuShiID, _qiushiID, _imageURL];
            NSString *newImageMidURL = [NSString stringWithFormat:@"http://pic.qiushibaike.com/system/pictures/%@/%@/medium/%@", prefixQiuShiID, _qiushiID,_imageURL];
            self.imageURL = newImageURL;
            self.imageMidURL = newImageMidURL;
        }
        
        NSDictionary *vote = [dictionary objectForKey:@"votes"];
        self.downCount = [[vote objectForKey:@"down"] integerValue];
        self.upCount = [[vote objectForKey:@"up"] integerValue];
        
        id user = [dictionary objectForKey:@"user"];
        if ((NSNull *)user != [NSNull null]) {
            NSDictionary *user = [dictionary objectForKey:@"user"];
            self.author = [user objectForKey:@"login"];
            self.authorID = [NSString stringWithFormat:@"%@", [user objectForKey:@"id"]];
            self.authorImageURL = [user objectForKey:@"icon"];
            NSString *prefixAuthorID = nil;
            if ([_authorID length] > 7) {
                prefixAuthorID = [_authorID substringWithRange:NSMakeRange(0, 4)];
            } else {
                prefixAuthorID = [_authorID substringWithRange:NSMakeRange(0, 3)];
            }
            NSString *newAuthorImageURL = [NSString stringWithFormat:@"http://pic.qiushibaike.com/system/avtnew/%@/%@/medium/%@", prefixAuthorID, _authorID, _authorImageURL];
            self.authorImageURL = newAuthorImageURL;
            self.totalHeight += 40;
        }
    }
    
    return self;
}



@end
