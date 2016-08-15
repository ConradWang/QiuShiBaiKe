//
//  NearbyListViewController.m
//  QiuShiBaiKe
//
//  Created by conrad on 14-7-8.
//  Copyright (c) 2014年 conrad. All rights reserved.
//

#import "NearbyListViewController.h"
#import "NearbyPremiseCell.h"
#import "NearbyUserCell.h"
#import "NearbyUser.h"

@interface NearbyListViewController ()
{
    NSInteger _page;  //"page":1
    
    BOOL _isFirstSecceed;
    
    UIActionSheet *_clearLocActionSheet;
    CLLocationManager *_locationManager;
    
    UIButton *_preGenderSender;
    UIButton *_preTimeSender;
}

@end

@implementation NearbyListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //Init data
    _dataArray = [[NSMutableArray alloc] init];
    _requestQueue = [[NSOperationQueue alloc] init];
    
    _page = 1;
    _gender = @"F";
    _time = 1440;
    _isFirstSecceed = NO;
    
    
    //初始化定位服务管理对象
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    _locationManager.distanceFilter =  1000.0f;
    
    // Custom actionsheet
    _clearLocActionSheet = [[UIActionSheet alloc] initWithTitle:@"清除地理位置后，别人将看不到你" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"清除地理位置" otherButtonTitles:nil];
    _clearLocActionSheet.backgroundColor = UIColorFromRGB(0xF5F5F5);
    for (UIView *view in _clearLocActionSheet.subviews) {
        if (view.tag == 1) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(20, 0, SCREEN_WIDTH - 40, 40);
            [btn setImage:[UIImage imageNamed:@"actionsheet_btn_clearloc"] forState:UIControlStateNormal];
            [btn setTitle:@"清除地理位置" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            btn.backgroundColor = [UIColor orangeColor];
            btn.adjustsImageWhenDisabled = NO;
            btn.enabled = NO;
            [view addSubview:btn];
        }
        else if (view.tag == 2) view.backgroundColor = UIColorFromRGB(0xF0F0F0);
    }
    
    // Config navgationbar
    self.navigationItem.title = @"附近";
    NSDictionary *attributes = @{UITextAttributeTextColor: [UIColor grayColor]};
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    
    NSString *leftImage = nil;
    NSString *rightImage = nil;
    if ([ToolKit getAllowNearbyFromLocal]) {
        self.navigationItem.leftBarButtonItem.enabled = YES;
        self.navigationItem.rightBarButtonItem.enabled = YES;
        leftImage = @"nav_sift";
        rightImage = @"nav_clearloc";
    }
    else {
        self.navigationItem.leftBarButtonItem.enabled = NO;
        self.navigationItem.rightBarButtonItem.enabled = NO;
        leftImage = @"nav_sift_disable";
        rightImage = @"nav_clearloc_disable";
    }
    
    //leftBarButtonItem
    UIImage *leftBtnImage = nil;
    if (IOS7_AND_LATER) {
        leftBtnImage = [[UIImage imageNamed:leftImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    } else {
        leftBtnImage = [UIImage imageNamed:leftImage];
    }
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithImage:leftBtnImage style:UIBarButtonItemStylePlain target:self action:@selector(navLeftBtnClick)];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
    
    
    //rightBarButtonItem
    UIImage *rightBtnImage = nil;
    if (IOS7_AND_LATER) {
        rightBtnImage = [[UIImage imageNamed:rightImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    } else {
        rightBtnImage = [UIImage imageNamed:rightImage];
    }
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithImage:rightBtnImage style:UIBarButtonItemStylePlain target:self action:@selector(navRightBtnClick)];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    
    
    // Config tableview
    _tableView = [[PullTableView alloc] init];
    _tableView.tag = 89;
    [self.view addSubview:_tableView];
    if (IOS7_AND_LATER) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        _tableView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49);
    } else {
        _tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49);
    }
    [_tableView setSeparatorInset:UIEdgeInsetsMake(0, 60, 0, 0)];
    _tableView.pullDelegate = self;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.pullArrowImage = [UIImage imageNamed:@"blueArrow.png"];
    _tableView.pullBackgroundColor = [UIColor whiteColor];
    _tableView.pullTextColor = [UIColor grayColor];
    
     // Config siftview
    _preGenderSender = (UIButton *)[_siftView viewWithTag:12];
    _preTimeSender = (UIButton *)[_siftView viewWithTag:22];
    _siftView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 230);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([ToolKit getQBTokenFromLocal]) {
        //用户已经登录，并且开启附近功能
        if ([ToolKit getAllowNearbyFromLocal]) {
            _groupTableView.hidden = YES;
            _tableView.hidden = NO;
            
            if (_isFirstSecceed == NO) {
                [_dataArray removeAllObjects];
            }
            
            //开始定位
            [_locationManager startUpdatingLocation];

        }
        //用户已经登录，但未开启附近功能
        else {
            
            _groupTableView.hidden = NO;
            _tableView.hidden = YES;
            
            _isFirstSecceed = NO;
            [_dataArray removeAllObjects];
        }
    }
    else {
        //用户未登录
        _groupTableView.hidden = YES;
        _tableView.hidden = YES;
        
        _isFirstSecceed = NO;
        [_dataArray removeAllObjects];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [_locationManager stopUpdatingLocation];

}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Button Click

- (void)seeNearbyUserBtnClick
{
    [ToolKit saveAllowNearbyToLocal:YES];
    [self changeNavButtonToStatus:YES];
    [self viewWillAppear:YES];
}

- (void)navLeftBtnClick
{
    [UIView animateWithDuration:0.2 animations:^{
        [[[UIApplication sharedApplication].delegate window] addSubview:_midView];
        _siftView.frame = CGRectMake(0, SCREEN_HEIGHT - 230, SCREEN_WIDTH, 230);
        [[[UIApplication sharedApplication].delegate window] addSubview:_siftView];
        self.tabBarController.tabBar.hidden = YES;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)navRightBtnClick
{
    [_clearLocActionSheet showInView:self.view];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self startClearLocRequest];
    }

}


#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *currLocation = [locations lastObject];
    _longitude = [NSNumber numberWithDouble:currLocation.coordinate.longitude];
    _latitude = [NSNumber numberWithDouble:currLocation.coordinate.latitude];
    
    if (_isFirstSecceed == NO) {
        [self startNearbyListRequsetFirst];
    }
    else if (_dataArray.count == 0) {
        [self pullTableViewDidTriggerRefresh:_tableView];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"location err:%@", error);
    [Dialog simpleToast:@"定位失败， 请检查定位是否开启"];
    [_tableView reloadData];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == 88) {
        return 1;
    }
    
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *premiseCellID = @"PremiseCellID";
    NSString *userCellID = @"NearbyUserCellID";
    UITableViewCell *cell = nil;
    
    if (tableView.tag == 88) {
        NearbyPremiseCell *premiseCell = [tableView dequeueReusableCellWithIdentifier:premiseCellID];
        if (premiseCell == nil) {
            premiseCell = [[[NSBundle mainBundle] loadNibNamed:@"NearbyPremiseCell" owner:self options:nil] lastObject];
        }
        // Config cell
        premiseCell.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 -49);
        [premiseCell.seeNearbyUserBtn addTarget:self action:@selector(seeNearbyUserBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        cell = premiseCell;
    }
    else {
        NearbyUserCell *nearbyUserCell = [tableView dequeueReusableCellWithIdentifier:userCellID];
        if (nearbyUserCell== nil) {
            nearbyUserCell = [[[NSBundle mainBundle] loadNibNamed:@"NearbyUserCell" owner:self options:nil] lastObject];
        }
        // Config cell
        [nearbyUserCell configNearbyUserCellWithNearbyUser:_dataArray[indexPath.row]];
        
    
        cell = nearbyUserCell;
    }
    
    return cell;
}



#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 88) {
        return SCREEN_HEIGHT - 64 - 49;
    }
    return 80;
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
    if (tableView.tag == 88) {
        return NO;
    }
    return YES;
}


#pragma mark - ASIHTTPRequestDelegate

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
    if (dic) {
        if (request.tag == 99) {
            NSInteger err = [dic[@"err"] integerValue];
            if (err == 0) {
                _isFirstSecceed = YES;
                [self pullTableViewDidTriggerRefresh:_tableView];
            }
        }
        else if (request.tag == 100) {
            NSInteger err = [dic[@"err"] integerValue];
            if (err == 0) {
                NSArray *nearbyArray = dic[@"nearby"];
                
                if (_page == 1) {
                    [_dataArray removeAllObjects];
                }
                
                for (NSDictionary *nearbyUserDic in nearbyArray) {
                    NearbyUser *user = [[NearbyUser alloc] initWithNearbyUserDictionary:nearbyUserDic];
                    [_dataArray addObject:user];
                }
                
                if (_page == 1) {
                    [self refreshTable:_tableView];
                } else {
                    [self loadMoreDataToTable:_tableView];
                }

            }
            
        }
        else if (request.tag == 101) {
            NSInteger err = [dic[@"err"] integerValue];
            if (err == 0) {
                [Dialog simpleToast:@"清除成功"];
                
                [ToolKit saveAllowNearbyToLocal:NO];
                [self changeNavButtonToStatus:NO];
                [self viewWillAppear:YES];
                
            }
            
        }

    }
    
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"%@", request.error);
    [Dialog simpleToast:@"网速不给力呀"];
    
    _tableView.pullLastRefreshDate = [NSDate date];
    _tableView.pullTableIsRefreshing = NO;
    _tableView.pullTableIsLoadingMore = NO;
}


#pragma mark - PullTableViewDelegate

- (void)pullTableViewDidTriggerRefresh:(PullTableView *)pullTableView
{
    _page = 1;
    [self startNearbyListRequsetWithPage:_page andGender:_gender andTime:_time andLongitude:_longitude andLatitude:_latitude];
}

- (void)pullTableViewDidTriggerLoadMore:(PullTableView *)pullTableView
{
    if (_dataArray.count == 0) {
        _page = 0;
    } else if (_dataArray.count <= 20) {
        _page = 1;
    }
    _page++;
    [self startNearbyListRequsetWithPage:_page andGender:_gender andTime:_time andLongitude:_longitude andLatitude:_latitude];
}

#pragma mark - Refresh and load more methods

- (void)refreshTable:(PullTableView *)pullTableView
{
    [pullTableView reloadData];
    
    pullTableView.pullLastRefreshDate = [NSDate date];
    pullTableView.pullTableIsRefreshing = NO;
}

- (void)loadMoreDataToTable:(PullTableView *)pullTableView
{
    [pullTableView reloadData];
    
    pullTableView.pullTableIsLoadingMore = NO;
}


#pragma mark - START

#pragma mark - Button Click

- (IBAction)cancelBtnClick:(UIButton *)sender {
    [UIView animateWithDuration:0.2 animations:^{
        _siftView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 230);
        
    } completion:^(BOOL finished) {
        [_siftView removeFromSuperview];
        [_midView removeFromSuperview];
        self.tabBarController.tabBar.hidden = NO;
       
    }];
}

- (IBAction)confirm:(UIButton *)sender {
    [UIView animateWithDuration:0.2 animations:^{
        _siftView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 230);
        
    } completion:^(BOOL finished) {
        [_siftView removeFromSuperview];
        [_midView removeFromSuperview];
        self.tabBarController.tabBar.hidden = NO;
        [self pullTableViewDidTriggerRefresh:_tableView];
        
    }];
}

//NSString *_gender;   F / M / U

- (IBAction)genderBtnClick:(UIButton *)sender {
    if (_preGenderSender != sender) {
        _preGenderSender.backgroundColor = [UIColor whiteColor];
        sender.backgroundColor = UIColorFromRGB(0xE0E0E0);
        
        if (sender.tag == 10) {
            _gender = @"U";
        }
        else if (sender.tag == 11) {
            _gender = @"M";
        }
        else if (sender.tag == 12) {
            _gender = @"F";
        }
        
    }
    
    _preGenderSender = sender;
}

//CGFloat _time;       15 / 60 / 1440 / 4320
- (IBAction)timeBtnClick:(UIButton *)sender {
    if (_preTimeSender != sender) {
        _preTimeSender.backgroundColor = [UIColor whiteColor];
        sender.backgroundColor = UIColorFromRGB(0xE0E0E0);
        
        if (sender.tag == 20) {
            _time = 15;
        }
        else if (sender.tag == 21) {
            _time = 60;
        }
        else if (sender.tag == 22) {
            _time = 1440;
        }
        else if (sender.tag == 23) {
            _time = 4320;
        }
    }
    
    _preTimeSender = sender;
}

#pragma mark - Private Methods

- (void)dismissViewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma marl - END


#pragma mark - Private Methods
//
//{"holder":"test"}
- (void)startNearbyListRequsetFirst
{
    ASIFormDataRequest *nearbyListRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:api_nearby_user]];
    [nearbyListRequest addRequestHeader:@"Qbtoken" value:[ToolKit getQBTokenFromLocal]];
    nearbyListRequest.delegate = self;
    
    NSDictionary *firstDataDic = [NSDictionary dictionaryWithObjectsAndKeys:@"test", @"holder", nil];
    NSData *firstData = [NSJSONSerialization dataWithJSONObject:firstDataDic options:NSJSONWritingPrettyPrinted error:nil];
    
    nearbyListRequest.tag = 99;
    [nearbyListRequest setPostBody:[NSMutableData dataWithData:firstData]];
    [_requestQueue addOperation:nearbyListRequest];
}


//{"gender":"F","count":30,"page":1,"longitude":113.955959378648,"time":1440,"latitude":22.58197469627456}
- (void)startNearbyListRequsetWithPage:(NSInteger)page andGender:(NSString *)gender andTime:(CGFloat)time andLongitude:(NSNumber *)lng andLatitude:(NSNumber *)lat
{
    ASIFormDataRequest *nearbyListRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:api_nearby_user]];
    [nearbyListRequest addRequestHeader:@"Qbtoken" value:[ToolKit getQBTokenFromLocal]];
    nearbyListRequest.delegate = self;
    
    NSMutableDictionary *nearbyListDict = [NSMutableDictionary dictionaryWithCapacity:20];
    [nearbyListDict setValue:[NSNumber numberWithInteger:20] forKey:@"count"];
    [nearbyListDict setValue:[NSNumber numberWithInteger:page] forKey:@"page"];
    [nearbyListDict setValue:gender forKey:@"gender"];
    [nearbyListDict setValue:[NSNumber numberWithDouble:time] forKey:@"time"];
    [nearbyListDict setValue:lng forKey:@"longitude"];
    [nearbyListDict setValue:lat forKey:@"latitude"];
    NSData *nearbyListData = [NSJSONSerialization dataWithJSONObject:nearbyListDict options:NSJSONWritingPrettyPrinted error:nil];
    
    nearbyListRequest.tag = 100;
    [nearbyListRequest setPostBody:[NSMutableData dataWithData:nearbyListData]];
    [_requestQueue addOperation:nearbyListRequest];
}

- (void)startClearLocRequest
{
    ASIFormDataRequest *clearLocRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:api_nearby_clearloc]];
    [clearLocRequest addRequestHeader:@"Qbtoken" value:[ToolKit getQBTokenFromLocal]];
    clearLocRequest.tag = 101;
    clearLocRequest.delegate = self;
    [_requestQueue addOperation:clearLocRequest];
}

- (void)changeNavButtonToStatus:(BOOL)yesOrNo
{
    self.navigationItem.leftBarButtonItem.enabled = yesOrNo;
    self.navigationItem.rightBarButtonItem.enabled = yesOrNo;
    NSString *leftImage = nil;
    NSString *rightImage = nil;
    if (yesOrNo) {
        leftImage = @"nav_sift";
        rightImage = @"nav_clearloc";
    }
    else {
        leftImage = @"nav_sift_disable";
        rightImage = @"nav_clearloc_disable";
    }
    //leftBarButtonItem
    UIImage *leftBtnImage = nil;
    if (IOS7_AND_LATER) {
        leftBtnImage = [[UIImage imageNamed:leftImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    } else {
        leftBtnImage = [UIImage imageNamed:leftImage];
    }
    [self.navigationItem.leftBarButtonItem setImage:leftBtnImage];
    
    //rightBarButtonItem
    UIImage *rightBtnImage = nil;
    if (IOS7_AND_LATER) {
        rightBtnImage = [[UIImage imageNamed:rightImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    } else {
        rightBtnImage = [UIImage imageNamed:rightImage];
    }
    [self.navigationItem.rightBarButtonItem setImage:rightBtnImage];
}


@end
