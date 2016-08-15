//
//  OwnerOverviewViewController.m
//  QiuShiBaiKe
//
//  Created by conrad on 14-7-8.
//  Copyright (c) 2014年 conrad. All rights reserved.
//

#import "OwnerOverviewViewController.h"
#import "SettingViewController.h"
#import "QBuser.h"
#import "UIImageView+WebCache.h"
#import "OwnerLoginedCell.h"


@interface OwnerOverviewViewController ()
{
    CGFloat _height;
    NSArray *_ownerPicArray;
    NSArray *_ownerTitleArray;
    
    NSOperationQueue *_requestQueue;
}

@end

@implementation OwnerOverviewViewController

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
    // Init data
    _height = (SCREEN_HEIGHT - 64 - 49) / 23;
    _ownerPicArray = @[@[@"owner_night"], @[@"owner_mycreation", @"owner_myparticipation", @"owner_mycollection"], @[ @"owner_setting"]];
    _ownerTitleArray = @[@[@"夜间模式"], @[@"我发表的", @"我参与的", @"我收藏的"], @[@"设置"]];
    _focusLogin = NO;
    _requestQueue = [[NSOperationQueue alloc] init];
    
    // Config navgationbar
    self.navigationItem.title = @"我";
    NSDictionary *attributes = @{UITextAttributeTextColor: [UIColor grayColor]};
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    
    if (IOS7_AND_LATER) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    // Config TableView
    _tabView.contentInset = UIEdgeInsetsMake(_height, 0, 0, 0);
    
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [_tabView reloadData];
    
    if (self.focusLogin == YES && ![ToolKit getQBTokenFromLocal]) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:@"登录" forState:UIControlStateNormal];
        [self buttonClick:btn];
        self.focusLogin = NO;
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button Click

- (void)buttonClick:(UIButton *)sender
{
    LoginAndRegisterViewController *loginAndRegisterVC = [[LoginAndRegisterViewController alloc] initWithNibName:@"LoginAndRegisterViewController" bundle:nil];
    loginAndRegisterVC.delegate = self;
    UINavigationController *loginAndRegisterNC = [[UINavigationController alloc] initWithRootViewController:loginAndRegisterVC];
    
    if ([sender.titleLabel.text isEqualToString:@"登录"]) {
        [loginAndRegisterVC setStyle:CWLoginOrRegisterStyleLogin];
    }
    else if ([sender.titleLabel.text isEqualToString:@"注册"]) {
        [loginAndRegisterVC setStyle:CWLoginOrRegisterStyleRegister];
    }
    
    [self presentViewController:loginAndRegisterNC animated:YES completion:nil];
}

- (void)swithChange:(UISwitch *)swith
{
    NSLog(@"swith status:%d", swith.on);
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *ownerCell1 = @"OwnerCell1";
    NSString *ownerCell2 = @"OwnerCell2";
    NSString *ownerLoginedCell = @"OwnerLoginedCell";
    
    UITableViewCell *cell = nil;
    if (indexPath.section == 0) {
        if ([ToolKit getQBTokenFromLocal].length > 0) {
            OwnerLoginedCell *loginedCell = [tableView dequeueReusableCellWithIdentifier:ownerLoginedCell];
            if (loginedCell == nil) {
                loginedCell = [[[NSBundle mainBundle] loadNibNamed:@"OwnerLoginedCell" owner:self options:nil] lastObject];
                loginedCell.frame = [tableView cellForRowAtIndexPath:indexPath].frame;
            }
            // Config cell2
            QBUser *user = [ToolKit getQBUserFromLocal];
            
            [loginedCell.icon setImageWithURL:[NSURL URLWithString:user.icon] placeholderImage:[UIImage imageNamed:@"placeholder_icon"]];
            [loginedCell.icon.layer setMasksToBounds:YES];
            [loginedCell.icon.layer setCornerRadius:loginedCell.icon.frame.size.height / 2];
            
            loginedCell.name.text = user.login;

            cell = loginedCell;
        }
        else {
            UITableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:ownerCell1];
            if (cell1 == nil) {
                cell1 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ownerCell1];
            }
            UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            loginBtn.frame = CGRectMake( SCREEN_WIDTH / 2 -  6 * _height, _height, 5 * _height, 2 * _height);
            [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
            [loginBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:15.0]];
            [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            loginBtn.backgroundColor = [UIColor orangeColor];
            [loginBtn.layer setMasksToBounds:YES];
            [loginBtn.layer setCornerRadius:3.0]; //设置矩形四个圆角半径
            [loginBtn.layer setBorderWidth:1.0]; //边框宽度
            [loginBtn.layer setBorderColor:[UIColorFromRGB(0xED7F27) CGColor]];//边框颜色
            [loginBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [cell1 addSubview:loginBtn];
            
            UIButton *registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            registerBtn.frame = CGRectMake( SCREEN_WIDTH / 2 +  _height, _height, 5 * _height, 2 * _height);
            [registerBtn setTitle:@"注册" forState:UIControlStateNormal];
            [registerBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:15.0]];
            [registerBtn setTitleColor:UIColorFromRGB(0xED7F27) forState:UIControlStateNormal];
            registerBtn.backgroundColor = [UIColor whiteColor];
            [registerBtn.layer setMasksToBounds:YES];
            [registerBtn.layer setCornerRadius:3.0]; //设置矩形四个圆角半径
            [registerBtn.layer setBorderWidth:1.0]; //边框宽度
            [registerBtn.layer setBorderColor:[UIColorFromRGB(0xED7F27) CGColor]];//边框颜色
            [registerBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [cell1 addSubview:registerBtn];
            
            cell = cell1;
        }
        
    }
    else {
        UITableViewCell *cell2 = [tableView dequeueReusableCellWithIdentifier:ownerCell2];
        if (cell2 == nil) {
            cell2 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ownerCell2];
        }
        // Config cell2
        cell2.imageView.image = [UIImage imageNamed:_ownerPicArray[indexPath.section - 1][indexPath.row]];
        cell2.textLabel.text = _ownerTitleArray[indexPath.section - 1][indexPath.row];
        [cell2.textLabel setFont:[UIFont systemFontOfSize:13]];
        cell2.textLabel.textColor = UIColorFromRGB(0x505050);
        if (indexPath.section == 1) {
            UISwitch *swith = [[UISwitch alloc] init];
            swith.onTintColor = UIColorFromRGB(0xED7F27);
            [swith addTarget:self action:@selector(swithChange:) forControlEvents:UIControlEventValueChanged];
            cell2.accessoryView = swith;
        }
        else {
            [cell2 setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        }
        cell = cell2;
    }
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 2) {
        return 3;
    }
    return 1;
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return  4 * _height;
    }
    
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
    if (indexPath.section == 0) {
        if ([ToolKit getQBTokenFromLocal].length > 0) {
            return YES;
        }
        return NO;
    }
    else if (indexPath.section == 1) {
        return NO;
    }
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 3 & indexPath.row == 0) {
        SettingViewController *settingVC = [[SettingViewController alloc] initWithNibName:@"SettingViewController" bundle:nil];
        [self.navigationController pushViewController:settingVC animated:YES];
        [tableView cellForRowAtIndexPath:indexPath].selected = NO;
    }
    else {
        [tableView cellForRowAtIndexPath:indexPath].selected = NO;
    }
    
}

#pragma mark - ASIHTTPRequestDelegate

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
    NSLog(@"%@", dic);
    
    if (request.tag == 100) {
        NSLog(@"PUSH:%@", dic);
        if ([dic[@"err"] integerValue] == 0) {
            NSLog(@"push ok");
        }
    }

}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"%@", request.error);
}



#pragma mark - LoginAndRegisterDelegate

- (void)loginSecceededGetUser:(NSString *)user andIcon:(NSString *)icon
{
    //NSLog(@"%@, %@", user, icon);
    [_tabView reloadData];
    

    NSDictionary *pushDict = [NSDictionary dictionaryWithObjectsAndKeys:[ToolKit getQBTokenFromLocal], @"token", @"login", @"action", nil];
    NSData *pushData = [NSJSONSerialization dataWithJSONObject:pushDict options:NSJSONWritingPrettyPrinted error:nil];
        
    ASIFormDataRequest * pushRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://push.qiushibaike.com/push"]];
    pushRequest.delegate = self;
    pushRequest.tag = 100;
    [pushRequest addRequestHeader:@"Qbtoken" value:[ToolKit getQBTokenFromLocal]];
    [pushRequest setPostBody:[NSMutableData dataWithData:pushData]];
    [_requestQueue addOperation:pushRequest];
}



@end
