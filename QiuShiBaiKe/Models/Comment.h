//
//  Comment.h
//  QiuShiBaiKe
//
//  Created by conrad on 14-7-8.
//  Copyright (c) 2014年 conrad. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Comment : NSObject

@property (nonatomic,copy) NSString *commentID;             //糗事id
@property (nonatomic,copy) NSString *content;               //内容
@property (nonatomic,copy) NSString *authorID;              //作者id
@property (nonatomic,copy) NSString *author;                //作者
@property (nonatomic,copy) NSString *authorImageURL;        //作者头像地址
@property (nonatomic,assign) NSInteger floor;               //楼层

@property (assign, nonatomic) CGSize contentSize;
@property (assign, nonatomic) NSInteger totalHeight;

- (id)initWithCommentDictionary:(NSDictionary *)dictionary;

@end
