//
//  CWAppDelegate.m
//  QiuShiBaiKe
//
//  Created by conrad on 14-7-8.
//  Copyright (c) 2014年 conrad. All rights reserved.
//

#import "CWAppDelegate.h"
#import "ScandalsListViewController.h"
#import "NearbyListViewController.h"
#import "MessageListViewController.h"
#import "OwnerOverviewViewController.h"

@implementation CWAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    // Init ViewController
    //  [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
    
    ScandalsListViewController *scandalsListVC = [[ScandalsListViewController alloc] init];
    NearbyListViewController *nearbyListVC = [[NearbyListViewController alloc] initWithNibName:@"NearbyListViewController" bundle:nil];
    MessageListViewController *messageListVC = [[MessageListViewController alloc] init];
    ownerOverviewVC = [[OwnerOverviewViewController alloc] initWithNibName:@"OwnerOverviewViewController" bundle:nil];
    NSMutableArray *viewControllerArray = [NSMutableArray arrayWithObjects:scandalsListVC, nearbyListVC, messageListVC, ownerOverviewVC, nil];
    
    NSArray *barTitleArray = [NSArray arrayWithObjects:@"糗事", @"附近", @"小纸条", @"我", nil];
    NSArray *barNormalImageArray = [NSArray arrayWithObjects:@"bar_scandals_normal.png", @"bar_nearby_normal.png", @"bar_message_normal.png", @"bar_owner_normal.png", nil];
    NSArray *barSelectedImageArray = [NSArray arrayWithObjects:@"bar_scandals_selected.png", @"bar_nearby_selected.png", @"bar_message_selected.png", @"bar_owner_selected.png", nil];
    
    for (int i = 0; i < 4; i++) {
        UIViewController *viewController = viewControllerArray[i];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
        UITabBarItem *tabBarItem = [[UITabBarItem alloc] initWithTitle:barTitleArray[i] image:nil tag:i];
        if (IOS7_AND_LATER) {
            tabBarItem.image = [[UIImage imageNamed:barNormalImageArray[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            tabBarItem.selectedImage = [[UIImage imageNamed:barSelectedImageArray[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        } else {
            tabBarItem.image = [UIImage imageNamed:barNormalImageArray[i]];
            tabBarItem.selectedImage = [UIImage imageNamed:barSelectedImageArray[i]];
        }
        navigationController.tabBarItem = tabBarItem;
        navigationController.navigationBar.backgroundColor = UIColorFromRGB(0xFFFFFF);
        
        [viewControllerArray replaceObjectAtIndex:i withObject:navigationController];
    }
    
    //Create tabBarController
    
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    tabBarController.delegate = self;
    tabBarController.tabBar.tintColor = UIColorFromRGB(0xE1A041);
    tabBarController.viewControllers = viewControllerArray;
    self.window.rootViewController = tabBarController;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - UITabBarControllerDelegate

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    NSInteger index = viewController.tabBarItem.tag;
    if (index == 0) {
        //
    }
    else if (index == 1) {
        if (![ToolKit getQBTokenFromLocal]) {
            ownerOverviewVC.focusLogin = YES;
            tabBarController.selectedIndex = 3;
        }
    }
    else if (index == 2) {
        if (![ToolKit getQBTokenFromLocal]) {
            ownerOverviewVC.focusLogin = YES;
            tabBarController.selectedIndex = 3;
        }
    }
    else if (index == 3) {
        //
    }
}

- (void)jumpToOwner
{
    
}


@end
