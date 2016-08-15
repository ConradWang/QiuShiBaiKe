//
//  CreateScandalsViewController.m
//  QiuShiBaiKe
//
//  Created by conrad on 14-7-28.
//  Copyright (c) 2014年 conrad. All rights reserved.
//

#import "CreateScandalsViewController.h"
#import "CreateScandalsCell.h"

@interface CreateScandalsViewController ()

@end

@implementation CreateScandalsViewController

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
    
//    self.navigationController.navigationBar.tintColor = [UIColor orangeColor];
    
    // leftBarButtonItem
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(navLeftBtnClick)];
    [leftButtonItem setTintColor:[UIColor grayColor]];
    [leftButtonItem setTitlePositionAdjustment:UIOffsetMake(5, 0) forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
    
    // rightBarButtonItem
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"投稿" style:UIBarButtonItemStylePlain target:self action:@selector(navRightBtnClick)];
    [rightButtonItem setTintColor:[UIColor orangeColor]];
    [rightButtonItem setTitlePositionAdjustment:UIOffsetMake(-5, 0) forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CreateScandalsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CreateScandalsCellID"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CreateScandalsCell" owner:self options:nil] lastObject];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    cell.textView.backgroundColor = [UIColor clearColor];
    cell.textView.placeHolder = @"分享我的真实糗事。                                            您投递的糗事会在其他糗友审核之后发表，审核标准为：真实有笑点；不包含政治、色情；不包含邮件、电话、地址等隐私信息；人脸可打码；转载请注明出处。内容版权归糗事百科网站所有。";
    [cell.textView becomeFirstResponder];
    
    return cell;
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 367;
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


#pragma mark - Button Click

- (void)navLeftBtnClick
{
    self.tabBarController.tabBar.hidden = NO;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)navRightBtnClick
{
    self.tabBarController.tabBar.hidden = NO;
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
