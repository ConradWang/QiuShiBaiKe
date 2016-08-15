//
//  ToolKit.m
//  QiuShiBaiKe
//
//  Created by 王聪 on 14-7-9.
//  Copyright (c) 2014年 conrad. All rights reserved.
//

#import "ToolKit.h"

@implementation ToolKit

//判断当前网络是否可用
+ (BOOL)isExistenceNetwork
{
    BOOL isExistenceNetwork = YES;
    Reachability *r = [Reachability reachabilityWithHostName:@"http://www.baidu.com"];
    switch (r.currentReachabilityStatus) {
        case NotReachable:
            isExistenceNetwork = NO;
            break;
        case ReachableViaWWAN:
            isExistenceNetwork = YES;
            break;
        case ReachableViaWiFi:
            isExistenceNetwork = YES;
            break;
        default:
            break;
    }
    
    return isExistenceNetwork;
}

//保存QBToken到本地
+ (void)saveQBTokenToLocal:(NSString *)token
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:token forKey:@"QBToken"];
}

//取出保存在本地的QBToken
+ (NSString *)getQBTokenFromLocal{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return (NSString *)[defaults objectForKey:@"QBToken"];
}

//保存QBUser到本地
+ (void)saveQBUserToLocal:(QBUser *)qbUser{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:qbUser];
    [defaults setObject:data forKey:@"QBUser"];
}

//取出保存在本地的QBUser
+ (QBUser *)getQBUserFromLocal
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [defaults objectForKey:@"QBUser"];
    QBUser *user = (QBUser *)[NSKeyedUnarchiver unarchiveObjectWithData:data];
    return user;
}

//保存AllowNearby到本地
+ (void)saveAllowNearbyToLocal:(BOOL)allowNearby
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:allowNearby forKey:@"AllNearby"];
}

//取出保存在本地的AllowNearby
+ (BOOL)getAllowNearbyFromLocal
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults boolForKey:@"AllNearby"];
}

//获取整个应用通用的背景色
+ (UIColor *)getAppBackgroundColor
{
    UIImage *image = [UIImage imageNamed:@"main_background.png"];
    UIColor *backgroundColor = [UIColor colorWithPatternImage:image];
    return backgroundColor;
}

//返回day天后的日期(若day为负数,则为|day|天前的日期)
+ (NSString *)dateStringAfterRandomDay
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // Get the weekday component of the current date
    // NSDateComponents *weekdayComponents = [calendar components:NSWeekdayCalendarUnit fromDate:self];
    NSDateComponents *componentsToAdd = [[NSDateComponents alloc] init];
    // to get the end of week for a particular date, add (7 - weekday) days
    //这边填入需要增加的天数
    [componentsToAdd setDay:[ToolKit getRandomDay]];
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *fromDate=[dateFormatter dateFromString:@"2006-11-10"];
    
    NSDate *dateAfterDay = [calendar dateByAddingComponents:componentsToAdd toDate:fromDate options:0];
    
    NSString *dateStr = [dateFormatter stringFromDate:dateAfterDay];
    
    return dateStr;
}

//获取一个随机的天数
+ (NSInteger)getRandomDay
{
    NSDateFormatter *date = [[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *d=[date dateFromString:@"2006-11-10 10:10:10"];
    
    NSTimeInterval late = [d timeIntervalSince1970] * 1;
    
    NSDate *dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval now = [dat timeIntervalSince1970] * 1;
    NSString *timeString = @"";
    NSTimeInterval cha = now - late;
    timeString = [NSString stringWithFormat:@"%f", cha / 86400];
    timeString = [timeString substringToIndex:timeString.length - 7];
    NSInteger randomDay = 1;
    randomDay = arc4random_uniform([timeString integerValue]) + 1;
    
    return randomDay;
}

//获得某个时间到当前时间的时间差
+ (NSString *)getIntervalToNowFromTime:(NSString *)time
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[time floatValue]];
    NSTimeInterval late = [date timeIntervalSince1970] * 1;
    
    NSDate *curDate = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval now = [curDate timeIntervalSince1970]*1;
    
    NSTimeInterval interval = now - late;
    
    NSString *timeString=@"";
    
    if (interval / 60 < 1) {
        timeString = @"刚刚";
    }
    if ((interval / 60 > 1) && (interval / 3600 < 1)) {
        timeString = [NSString stringWithFormat:@"%f", interval / 60];
        timeString = [timeString substringToIndex:(timeString.length - 7)];
        timeString = [NSString stringWithFormat:@"%@分钟前", timeString];
    }
    if ((interval / 3600 > 1) && (interval / 86400 < 1)) {
        timeString = [NSString stringWithFormat:@"%f", interval / 3600];
        timeString = [timeString substringToIndex:(timeString.length - 7)];
        timeString = [NSString stringWithFormat:@"%@小时前", timeString];
    }
    if (interval / 86400 > 1)
    {
        timeString = [NSString stringWithFormat:@"%f", interval / 86400];
        timeString = [timeString substringToIndex:(timeString.length - 7)];
        timeString = [NSString stringWithFormat:@"%@天前", timeString];
    }
    

    return timeString;
}


@end
