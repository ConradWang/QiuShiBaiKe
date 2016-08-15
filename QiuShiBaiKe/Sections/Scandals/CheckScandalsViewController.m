//
//  CheckScandalsViewController.m
//  QiuShiBaiKe
//
//  Created by conrad on 14-7-11.
//  Copyright (c) 2014年 conrad. All rights reserved.
//

#import "CheckScandalsViewController.h"

@interface CheckScandalsViewController ()
{
    UIButton *_startCheckBtn;
}

@end

@implementation CheckScandalsViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [_contentView.layer setMasksToBounds:YES];
    [_contentView.layer setCornerRadius:8.0];
    // Config hide tabbar, create button
    //self.tabBarController.tabBar.hidden = YES;
    
    // Config navgationbar
    self.navigationItem.title = @"审核新糗事";
    NSDictionary *attributes = @{UITextAttributeTextColor: [UIColor grayColor]};
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    
    // LeftBarButtonItem
    UIImage *leftBtnImage = nil;
    if (IOS7_AND_LATER) {
        leftBtnImage = [[UIImage imageNamed:@"nav_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    } else {
        leftBtnImage = [UIImage imageNamed:@"nav_back"];
    }
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithImage:leftBtnImage style:UIBarButtonItemStylePlain target:self action:@selector(navLeftBtnClick)];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
    
}

#pragma mark - Button Click

- (void)navLeftBtnClick
{
    self.tabBarController.tabBar.hidden = NO;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)startCheckClick:(UIButton *)sender {
    NSLog(@"OK");
}
@end
