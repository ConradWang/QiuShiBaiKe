//
//  QiuShi.h
//  QiuShiBaiKe
//
//  Created by conrad on 14-7-8.
//  Copyright (c) 2014年 conrad. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QiuShi : NSObject

@property (copy, nonatomic) NSString *imageURL;
@property (nonatomic,copy) NSString *imageMidURL;               //中等图片地址
@property (nonatomic,copy) NSString *authorImageURL;            //作者头像地址
@property (nonatomic,copy) NSString *tag;                       //标签
@property (nonatomic,copy) NSString *author;                    //作者
@property (nonatomic,copy) NSString *authorID;                  //作者ID
@property (nonatomic,copy) NSString *qiushiID;                  //糗事ID
@property (nonatomic,copy) NSString *content;                   //糗事内容
@property (nonatomic,assign) NSTimeInterval published_at;       //发布时间
@property (nonatomic,assign) NSInteger commentsCount;           //评论数量
@property (nonatomic,assign) NSInteger downCount;               //踩的数量
@property (nonatomic,assign) NSInteger upCount;                 //顶的数量

@property (assign, nonatomic) CGSize contentSize;               //文本尺寸
@property (nonatomic,assign) CGSize imageSize;                  //图片尺寸
@property (nonatomic,assign) CGSize imageMidSize;               //中等图片尺寸

@property (assign, nonatomic) NSInteger totalHeight;            //cell的建议高度

- (id)initWithQiuShiDictionary:(NSDictionary *)dictionary;

@end
