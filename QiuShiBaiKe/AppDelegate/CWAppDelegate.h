//
//  CWAppDelegate.h
//  QiuShiBaiKe
//
//  Created by conrad on 14-7-8.
//  Copyright (c) 2014年 conrad. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OwnerOverviewViewController;

@interface CWAppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate>
{
    OwnerOverviewViewController *ownerOverviewVC;
}

@property (strong, nonatomic) UIWindow *window;

@end
