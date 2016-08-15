//
//  NearbyUser.h
//  QiuShiBaiKe
//
//  Created by conrad on 14-7-17.
//  Copyright (c) 2014年 conrad. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NearbyUser : NSObject

@property (copy, nonatomic) NSString *uID;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *icon;
@property (copy, nonatomic) NSString *age;
@property (copy, nonatomic) NSString *gender;

@property (copy, nonatomic) NSString *lastVisitTime;
@property (copy, nonatomic) NSString *distance;

@property (copy, nonatomic) NSString *signature;

- (id)initWithNearbyUserDictionary:(NSDictionary *)dictionary;

@end
