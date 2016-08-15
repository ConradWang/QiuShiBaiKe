//
//  ToolKit.h
//  QiuShiBaiKe
//
//  Created by 王聪 on 14-7-9.
//  Copyright (c) 2014年 conrad. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"
#import "QBUser.h"

@interface ToolKit : NSObject

+ (BOOL)isExistenceNetwork;
+ (void)saveQBTokenToLocal:(NSString *)token;
+ (NSString *)getQBTokenFromLocal;
+ (void)saveQBUserToLocal:(QBUser *)qbUser;
+ (QBUser *)getQBUserFromLocal;
+ (UIColor *)getAppBackgroundColor;
+ (NSString *)dateStringAfterRandomDay;
+ (void)saveAllowNearbyToLocal:(BOOL)allowNearby;
+ (BOOL)getAllowNearbyFromLocal;
+ (NSString *)getIntervalToNowFromTime:(NSString *)time;

@end
