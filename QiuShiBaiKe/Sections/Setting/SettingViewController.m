//
//  SettingViewController.m
//  QiuShiBaiKe
//
//  Created by conrad on 14-7-8.
//  Copyright (c) 2014年 conrad. All rights reserved.
//

#import "SettingViewController.h"
#import "NoAdsllustrateViewController.h"
#import "AboutViewController.h"

@interface SettingViewController () <UIActionSheetDelegate>
{
    NSInteger _height;
    NSArray *_settingTitleArray;
    
    NSOperationQueue *_requestQueue;
    UIActionSheet *_logoutActionSheet;
}

@end

@implementation SettingViewController

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
    // Do any additional setup after loading the view.
    _height = (SCREEN_HEIGHT - 64) / 24;
    
    if (IOS7_AND_LATER) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    // Config hide tabbar, create inputview
    self.tabBarController.tabBar.hidden = YES;
    
    // Config navgationbar
    self.navigationItem.title = @"设置";
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
    
    // Init data
    _settingTitleArray = @[@[@"保密绑定"], @[@"清除缓存", @"意见反馈", @"打分支持糗百", @"无广告版本说明", @"关于糗百", @"消息推送", ], @[@"退出登录"]];
    
    _requestQueue = [[NSOperationQueue alloc] init];
    _logoutActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"退出登录" otherButtonTitles:nil];
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

- (void)swithChange:(UISwitch *)swith
{
    NSLog(@"swith status:%d", swith.on);
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *settingCell = @"SettingCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:settingCell];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:settingCell];
    }
    // Config cell
    cell.textLabel.text = [_settingTitleArray[indexPath.section] objectAtIndex:indexPath.row];
    [cell.textLabel setFont:[UIFont systemFontOfSize:14]];
    cell.textLabel.textColor = UIColorFromRGB(0x505050);
    
    if (indexPath.section == 1 & indexPath.row == 5) {
        UISwitch *swith = [[UISwitch alloc] init];
        swith.onTintColor = UIColorFromRGB(0xED7F27);
        [swith addTarget:self action:@selector(swithChange:) forControlEvents:UIControlEventValueChanged];
        cell.accessoryView = swith;
    }
    else {
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }

    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1) {
        return 6;
    }
    return 1;
}



#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 2 * _height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return _height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return _height;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 & indexPath.row == 5) {
        return NO;
    }
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView cellForRowAtIndexPath:indexPath].selected = NO;
    if (indexPath.section == 1 & indexPath.row == 3) {
        NoAdsllustrateViewController *noAdsVC = [[NoAdsllustrateViewController alloc] initWithNibName:@"NoAdsllustrateViewController" bundle:nil];
        [self.navigationController pushViewController:noAdsVC animated:YES];
    }
    else if (indexPath.section == 1 & indexPath.row == 4) {
        AboutViewController *aboutVC = [[AboutViewController alloc] initWithNibName:@"AboutViewController" bundle:nil];
        [self.navigationController pushViewController:aboutVC animated:YES];
    }
    else if (indexPath.section == 2) {
        if ([ToolKit getQBTokenFromLocal].length > 0) {
            [_logoutActionSheet showInView:self.view];
        }
        
    }
    
}

#pragma mark - ASIHTTPRequestDelegate

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
    
    if (request.tag == 100) {
        NSLog(@"PUSH:%@", dic);
        if ([dic[@"err"] integerValue] == 0) {
            NSLog(@"push ok");
        }
    }
    
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        // Send push
        NSDictionary *pushDict = [NSDictionary dictionaryWithObjectsAndKeys:[ToolKit getQBTokenFromLocal], @"token", @"logout", @"action", nil];
        NSData *pushData = [NSJSONSerialization dataWithJSONObject:pushDict options:NSJSONWritingPrettyPrinted error:nil];
        ASIFormDataRequest * pushRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://push.qiushibaike.com/push"]];
        pushRequest.delegate = self;
        pushRequest.tag = 100;
        [pushRequest addRequestHeader:@"Qbtoken" value:[ToolKit getQBTokenFromLocal]];
        [pushRequest setPostBody:[NSMutableData dataWithData:pushData]];
        [_requestQueue addOperation:pushRequest];
        
        // Delete local userdata and token
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults removeObjectForKey:@"QBToken"];
        [defaults removeObjectForKey:@"QBUser"];
    }
    
}

@end
