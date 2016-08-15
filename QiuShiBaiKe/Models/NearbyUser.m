//
//  NearbyUser.m
//  QiuShiBaiKe
//
//  Created by conrad on 14-7-17.
//  Copyright (c) 2014年 conrad. All rights reserved.
//

#import "NearbyUser.h"

@implementation NearbyUser


- (id)initWithNearbyUserDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        self.uID = [NSString stringWithFormat:@"%@", dictionary[@"uid"]];
        self.name = dictionary[@"name"];
        self.age = [NSString stringWithFormat:@"%@", dictionary[@"age"]];
        self.gender = dictionary[@"gender"];
        self.lastVisitTime = [ToolKit getIntervalToNowFromTime:[NSString stringWithFormat:@"%@", dictionary[@"last_visit_time"]]];
        self.distance = [NSString stringWithFormat:@"%.1fkm", 0.001 * [dictionary[@"dis"] floatValue]];
        self.signature = dictionary[@"signature"];
        
        // Get icon URL
        self.icon = [dictionary objectForKey:@"icon"];
        NSString *prefixAuthorID = nil;
        if ([self.uID length] > 7) {
            prefixAuthorID = [self.uID substringWithRange:NSMakeRange(0, 4)];
        } else {
            prefixAuthorID = [self.uID substringWithRange:NSMakeRange(0, 3)];
        }
        NSString *newAuthorIconURL = [NSString stringWithFormat:@"http://pic.qiushibaike.com/system/avtnew/%@/%@/medium/%@", prefixAuthorID, self.uID, self.icon];
        self.icon = newAuthorIconURL;
    }
    
    return self;
}

@end
