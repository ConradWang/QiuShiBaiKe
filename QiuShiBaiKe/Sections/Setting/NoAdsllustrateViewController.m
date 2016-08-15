//
//  NoAdsllustrateViewController.m
//  QiuShiBaiKe
//
//  Created by conrad on 14-7-14.
//  Copyright (c) 2014年 conrad. All rights reserved.
//

#import "NoAdsllustrateViewController.h"

@interface NoAdsllustrateViewController ()

@end

@implementation NoAdsllustrateViewController

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
    
    if (IOS7_AND_LATER) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    // Config hide tabbar, create inputview
    self.tabBarController.tabBar.hidden = YES;
    
    // Config navgationbar
    self.navigationItem.title = @"无广告版本说明";
    NSDictionary *attributes = @{UITextAttributeTextColor: [UIColor grayColor]};
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    
    //leftBarButtonItem
    UIImage *leftBtnImage = nil;
    if (IOS7_AND_LATER) {
        leftBtnImage = [[UIImage imageNamed:@"nav_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    } else {
        leftBtnImage = [UIImage imageNamed:@"nav_back"];
    }
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithImage:leftBtnImage style:UIBarButtonItemStylePlain target:self action:@selector(navLeftBtnClick)];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Button Click

- (void)navLeftBtnClick
{
    self.tabBarController.tabBar.hidden = NO;
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"SettingCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = _cell;
//        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"NoAdsllustrateViewController" owner:self options:nil];
//        for (id obj in array) {
//            if ([obj isKindOfClass:[UITableViewCell class]]) {
//                cell = obj;
//            }
//        }
        
    }
    // Config cell
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return SCREEN_HEIGHT - 64;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}


- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}


@end
