//
//  QBUser.h
//  QiuShiBaiKe
//
//  Created by conrad on 14-7-8.
//  Copyright (c) 2014年 conrad. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QBUser : NSObject <NSCoding>

@property (nonatomic, copy) NSString *last_visited_at;  //1404746370
@property (nonatomic, copy) NSString *created_at;       //1404746370
@property (nonatomic, copy) NSString *state;            //active
@property (nonatomic, copy) NSString *ID;               //17650083
@property (nonatomic, copy) NSString *last_device;      //ios_3.1
@property (nonatomic, copy) NSString *role;             //n
@property (nonatomic, copy) NSString *login;            //ConradW
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *icon;             //20140707232348.jpg


+ (QBUser *)shareInstance;
- (id)initWithQBUserDictionary:(NSDictionary *)dictionary;


@end
