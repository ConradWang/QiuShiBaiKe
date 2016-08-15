//
//  LoginAndRegisterViewController.m
//  QiuShiBaiKe
//
//  Created by conrad on 14-7-15.
//  Copyright (c) 2014年 conrad. All rights reserved.
//

#import "LoginAndRegisterViewController.h"
#import "LoginInputCell.h"
#import "LoginBtnCell.h"
#import "QBUser.h"


@interface LoginAndRegisterViewController ()
{
    UITextField *_loginUser;
    UITextField *_loginPWD;
    
    UITextField *_registerUser;
    UITextField *_registerPWD;
    
    NSOperationQueue *_requestQueue;
}

@end

@implementation LoginAndRegisterViewController

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
    // Init private data
    _requestQueue = [[NSOperationQueue alloc] init];
    
    
    if (IOS7_AND_LATER) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    // Config hide tabbar, create inputview
    self.tabBarController.tabBar.hidden = YES;
    
    // Config navgationbar
    if (self.style  == CWLoginOrRegisterStyleLogin) {
        self.navigationItem.title = @"登录";
    }
    else {
        self.navigationItem.title = @"注册";
    }
    NSDictionary *attributes = @{UITextAttributeTextColor: [UIColor grayColor]};
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    self.navigationController.navigationBar.tintColor = [UIColor orangeColor];
    
    //leftBarButtonItem
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(navLeftBtnClick)];
    [leftButtonItem setTitlePositionAdjustment:UIOffsetMake(10, 0) forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
    
    // Add tap gesture
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignInput)];
    [_scrollView addGestureRecognizer:tap];
    
    // Config tableview
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 2 * (SCREEN_HEIGHT - 64));
    _registerTableView.frame = CGRectMake(0, SCREEN_HEIGHT - 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
    [_scrollView addSubview:_loginTableView];
    [_scrollView addSubview:_registerTableView];
    if (self.style  == CWLoginOrRegisterStyleLogin) {
        [_scrollView setContentOffset:CGPointMake(0, 0)];
    }
    else {
        [_scrollView setContentOffset:CGPointMake(0, SCREEN_HEIGHT - 64)];
    }
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(loginAndRegisterViewControllerWillDisappear:)]) {
        [self.delegate loginAndRegisterViewControllerWillDisappear:animated];
    }
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
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)buttonClick:(UIButton *)sender
{
    if ([sender.titleLabel.text isEqualToString:@"登录"]) {
        if (_loginUser.text.length > 0 && _loginPWD.text.length > 0) {
            [self loginWithUser:_loginUser.text andPWD:_loginPWD.text];
        }
        else {
            NSLog(@"用户名和密码不能为空");
        }
        
    }
    else if ([sender.titleLabel.text isEqualToString:@"下一步"]) {
        NSLog(@"NEXT");
        NSLog(@"user:%@  password:%@", _registerUser.text, _registerPWD.text);
    }
    else if ([sender.titleLabel.text isEqualToString:@"没有帐号？注册一个"]) {
        [_scrollView setContentOffset:CGPointMake(0, SCREEN_HEIGHT - 64) animated:YES];
        self.navigationItem.title = @"注册";
    }
    else if ([sender.titleLabel.text isEqualToString:@"已有账号？直接登录"]) {
        [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        self.navigationItem.title = @"登录";
    }
    else if (sender.tag == 188) {
        NSLog(@"sina weibo login");
    }
    else if (sender.tag == 189) {
        NSLog(@"tencent weibo login");
    }
    
}

- (void)forgetPWDClick
{
    NSLog(@"forget password");
}


#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *LoginIdentifier1 = @"LoginCell1";
    NSString *LoginIdentifier2 = @"LoginCell2";
    NSString *RegisterIdentifier = @"RegisterCell";
    UITableViewCell *cell = nil;
    
    if (tableView.tag == 25) {
        if (indexPath.section == 0) {
            LoginInputCell *inputCell = [tableView dequeueReusableCellWithIdentifier:LoginIdentifier1];
            if (inputCell == nil) {
                inputCell = [[[NSBundle mainBundle] loadNibNamed:@"LoginInputCell" owner:self options:nil] lastObject];
            }
            // Config cell
            if (indexPath.row == 0) {
                inputCell.btn.hidden = YES;
                inputCell.inputContent.placeholder = @"用户名/邮箱";
                _loginUser = inputCell.inputContent;
            }
            else if (indexPath.row == 1) {
                inputCell.inputContent.placeholder = @"密码";
                [inputCell.inputContent setSecureTextEntry:YES];
                _loginPWD = inputCell.inputContent;
                [inputCell.btn addTarget:self action:@selector(forgetPWDClick) forControlEvents:UIControlEventTouchUpInside];
            }
            
            cell = inputCell;
        }
        else if (indexPath.section == 1) {
            LoginBtnCell *btnCell = [tableView dequeueReusableCellWithIdentifier:LoginIdentifier2];
            if (btnCell == nil) {
                btnCell = [[[NSBundle mainBundle] loadNibNamed:@"LoginBtnCell" owner:self options:nil] lastObject];
            }
            // Config cell
            if (indexPath.row == 0) {
                [btnCell.btn setImage:[UIImage imageNamed:@"login_btn_sina"] forState:UIControlStateNormal];
                btnCell.btn.tag = 188;
                [btnCell.btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            }
            else if (indexPath.row == 1) {
                [btnCell.btn setImage:[UIImage imageNamed:@"login_btn_tencent"] forState:UIControlStateNormal];
                btnCell.btn.tag = 189;
                [btnCell.btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            }
            
            cell = btnCell;
        }

    }
    else if (tableView.tag == 26) {
        LoginInputCell *inputCell = [tableView dequeueReusableCellWithIdentifier:RegisterIdentifier];
        if (inputCell == nil) {
            inputCell = [[[NSBundle mainBundle] loadNibNamed:@"LoginInputCell" owner:self options:nil] lastObject];
        }
        // Config cell
        if (indexPath.row == 0) {
            inputCell.btn.hidden = YES;
            inputCell.inputContent.placeholder = @"用户名/邮箱";
            _registerUser = inputCell.inputContent;
        }
        else if (indexPath.row == 1) {
            inputCell.btn.hidden = YES;
            inputCell.inputContent.placeholder = @"密码";
            [inputCell.inputContent setSecureTextEntry:YES];
            _registerPWD = inputCell.inputContent;
        }
        
        cell = inputCell;
    }
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView.tag == 25) {
        return 2;
    }
    else if (tableView.tag == 26) {
        return 1;
    }
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 36;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 27;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (tableView.tag == 25) {
        if (section == 0) {
            return 72;
        }
        
        return 144;
    }
    else if (tableView.tag == 26) {
        return SCREEN_HEIGHT - 64 - 27 - 36 * 2;
    }
    
    return 0.1;
}


- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 25) {
        if (indexPath.section == 0) {
            return NO;
        }
        
        return YES;
    }
    else if (tableView.tag == 26) {
        return NO;
    }
    
    return NO;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UITableViewHeaderFooterView *headerView = [tableView headerViewForSection:section];
    UIView *view = [[UIView alloc] initWithFrame:headerView.bounds];
    
    if (tableView.tag == 25) {
        if (section == 1) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, SCREEN_WIDTH, 21)];
            label.text = @"已绑定糗百帐号？也可以用一下帐号登录";
            [label setFont:[UIFont systemFontOfSize:12.0]];
            label.textColor = [UIColor grayColor];
            [view addSubview:label];
        }
    }
    
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UITableViewHeaderFooterView *footerView = [tableView footerViewForSection:section];
    UIView *view = [[UIView alloc] initWithFrame:footerView.bounds];
    
    if (tableView.tag == 25) {
        if (section == 0) {
            UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            loginBtn.frame = CGRectMake(18, 18, SCREEN_WIDTH - 36, 36);
            [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
            [loginBtn.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
            [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            loginBtn.backgroundColor = [UIColor orangeColor];
            [loginBtn.layer setMasksToBounds:YES];
            [loginBtn.layer setCornerRadius:3.0]; //设置矩形四个圆角半径
            [loginBtn.layer setBorderWidth:1.0]; //边框宽度
            [loginBtn.layer setBorderColor:[UIColorFromRGB(0xED7F27) CGColor]];//边框颜色
            [loginBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:loginBtn];
        }
        else if (section == 1) {
            UIButton *goRegisterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            goRegisterBtn.frame = CGRectMake(SCREEN_WIDTH / 2 - 75, 120, 150, 21);
            [goRegisterBtn setTitle:@"没有帐号？注册一个" forState:UIControlStateNormal];
            [goRegisterBtn.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
            [goRegisterBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            //   goRegisterBtn.backgroundColor = [UIColor orangeColor];
            [goRegisterBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:goRegisterBtn];
        }

    }
    else if (tableView.tag == 26) {
        if (section == 0) {
            UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            loginBtn.frame = CGRectMake(18, 18, SCREEN_WIDTH - 36, 36);
            [loginBtn setTitle:@"下一步" forState:UIControlStateNormal];
            [loginBtn.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
            [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            loginBtn.backgroundColor = [UIColor orangeColor];
            [loginBtn.layer setMasksToBounds:YES];
            [loginBtn.layer setCornerRadius:3.0]; //设置矩形四个圆角半径
            [loginBtn.layer setBorderWidth:1.0]; //边框宽度
            [loginBtn.layer setBorderColor:[UIColorFromRGB(0xED7F27) CGColor]];//边框颜色
            [loginBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:loginBtn];
            
            
            UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 80, SCREEN_WIDTH, 21)];
            label1.text = @"爪机注册无需邀请码！";
            [label1 setFont:[UIFont systemFontOfSize:12.0]];
            label1.textAlignment = NSTextAlignmentCenter;
            label1.textColor = [UIColor grayColor];
            label1.alpha = 0.8;
            [view addSubview:label1];
            
            UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, SCREEN_WIDTH, 21)];
            label2.text = @"每个爪机仅能注册一个账号，请呵护对待";
            [label2 setFont:[UIFont systemFontOfSize:12.0]];
            label2.textAlignment = NSTextAlignmentCenter;
            label2.textColor = [UIColor grayColor];
            label2.alpha = 0.8;
            [view addSubview:label2];
            
            
            UIButton *goRegisterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            goRegisterBtn.frame = CGRectMake(SCREEN_WIDTH / 2 - 75, SCREEN_HEIGHT - 64 - 27 - 36 * 2 - 25, 150, 21);
            [goRegisterBtn setTitle:@"已有账号？直接登录" forState:UIControlStateNormal];
            [goRegisterBtn.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
            [goRegisterBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            //   goRegisterBtn.backgroundColor = [UIColor orangeColor];
            [goRegisterBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:goRegisterBtn];
        }

    }
    
    return view;
}

#pragma mark - ASIHTTPRequestDelegate

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
//    NSLog(@"request >>> %@", request.requestHeaders);
//    NSLog(@"response >> %@", dic);
    
    switch (request.tag) {
        case 100:
        {
            NSInteger err = [dic[@"err"] intValue];
            if (err == 0) {
                [ToolKit saveQBTokenToLocal:dic[@"token"]];
                QBUser *user = [[QBUser alloc] initWithQBUserDictionary:dic[@"user"]];
                [ToolKit saveQBUserToLocal:user];
                
                if (self.delegate && [self.delegate respondsToSelector:@selector(loginSecceededGetUser:andIcon:)]) {
                    [self.delegate loginSecceededGetUser:user.login andIcon:user.icon];
                }
                
                [self performSelector:@selector(navLeftBtnClick) withObject:nil afterDelay:1.0];
                
            }
            else {
                [Dialog simpleToast:dic[@"err_msg"]];
            }
            
        }
            break;
        case 101:
        {
            
        }
            break;
            
        default:
        {
            //
        }
            break;
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"err:%@", request.error);
}


#pragma mark - Private Methods

- (void)loginWithUser:(NSString *)user andPWD:(NSString *)pwd
{
    NSDictionary *loginDict = [NSDictionary dictionaryWithObjectsAndKeys:user, @"login", pwd, @"pass", nil];
    NSData *loginData = [NSJSONSerialization dataWithJSONObject:loginDict options:NSJSONWritingPrettyPrinted error:nil];
    
    ASIFormDataRequest * loginRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:api_owner_login]];
    loginRequest.delegate = self;
    loginRequest.tag = 100;
    [loginRequest setPostBody:[NSMutableData dataWithData:loginData]];
    [_requestQueue addOperation:loginRequest];
}


- (void)resignInput
{
    [_loginUser resignFirstResponder];
    [_loginPWD resignFirstResponder];
    [_registerUser resignFirstResponder];
    [_registerPWD resignFirstResponder];
}

@end
