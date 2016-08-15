//
//  QBUser.m
//  QiuShiBaiKe
//
//  Created by conrad on 14-7-8.
//  Copyright (c) 2014年 conrad. All rights reserved.
//

#import "QBUser.h"

@implementation QBUser

static QBUser *instance = nil;

+ (QBUser *)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [QBUser alloc];
    });
    
    return instance;
}

- (id)initWithQBUserDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        self.last_visited_at = [dictionary objectForKey:@"last_visited_at"];
        self.created_at = [dictionary objectForKey:@"created_at"];
        self.state = [dictionary objectForKey:@"state"];
        self.ID = [dictionary objectForKey:@"id"];
        self.last_device = [dictionary objectForKey:@"last_device"];
        self.role = [dictionary objectForKey:@"role"];
        self.login = [dictionary objectForKey:@"login"];
        self.email = [dictionary objectForKey:@"email"];
        
        id icon = [dictionary objectForKey:@"icon"];
        if ((NSNull *)icon != [NSNull null]) {
            self.icon = [dictionary objectForKey:@"icon"];
            NSString *prefixAuthorID = nil;
            if ([self.ID length] > 7) {
                prefixAuthorID = [_ID substringWithRange:NSMakeRange(0, 4)];
            } else {
                prefixAuthorID = [_ID substringWithRange:NSMakeRange(0, 3)];
            }
            NSString *newAuthorIconURL = [NSString stringWithFormat:@"http://pic.qiushibaike.com/system/avtnew/%@/%@/medium/%@", prefixAuthorID, _ID, icon];
            self.icon = newAuthorIconURL;
        }
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.last_visited_at = [aDecoder decodeObjectForKey:@"last_visited_at"];
        self.created_at = [aDecoder decodeObjectForKey:@"created_at"];
        self.state = [aDecoder decodeObjectForKey:@"state"];
        self.ID= [aDecoder decodeObjectForKey:@"ID"];
        self.last_device = [aDecoder decodeObjectForKey:@"last_device"];
        self.role = [aDecoder decodeObjectForKey:@"role"];
        self.login = [aDecoder decodeObjectForKey:@"login"];
        self.email = [aDecoder decodeObjectForKey:@"email"];
        self.icon = [aDecoder decodeObjectForKey:@"icon"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.last_visited_at forKey:@"last_visited_at"];
    [aCoder encodeObject:self.created_at forKey:@"created_at"];
    [aCoder encodeObject:self.state forKey:@"state"];
    [aCoder encodeObject:self.ID forKey:@"ID"];
    [aCoder encodeObject:self.last_device forKey:@"last_device"];
    [aCoder encodeObject:self.role forKey:@"role"];
    [aCoder encodeObject:self.login forKey:@"login"];
    [aCoder encodeObject:self.email forKey:@"email"];
    [aCoder encodeObject:self.icon forKey:@"icon"];
}





@end
