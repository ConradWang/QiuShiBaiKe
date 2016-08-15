//
//  MessageListViewController.m
//  QiuShiBaiKe
//
//  Created by conrad on 14-7-8.
//  Copyright (c) 2014年 conrad. All rights reserved.
//

#import "MessageListViewController.h"
#import "Message.h"
#import "MessageCell.h"
#import "ASIHTTPRequest.h"

@interface MessageListViewController ()

@end

@implementation MessageListViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        _page = 1;
        _dataArray = [[NSMutableArray alloc] init];
        _requestQueue = [[NSOperationQueue alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // Config navgationbar
    self.navigationItem.title = @"小纸条";
    NSDictionary *attributes = @{UITextAttributeTextColor: [UIColor grayColor]};
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    
    // Config tableview
    _tableView = [[PullTableView alloc] init];
    _tableView.tag = 100;
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


}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (_dataArray.count == 0) {
        [self pullTableViewDidTriggerRefresh:_tableView];
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *messageCellID = @"MsseageCellID";
    
    MessageCell *messageCell = [tableView dequeueReusableCellWithIdentifier:messageCellID];
    if (messageCell == nil) {
        messageCell = [[[NSBundle mainBundle] loadNibNamed:@"MessageCell" owner:self options:nil] lastObject];
    }
    // Config cell
    Message *message = _dataArray[indexPath.row];
    [messageCell configMessageCellWithMessage:message];
    
    
    return messageCell;
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView cellForRowAtIndexPath:indexPath].selected = NO;
}


#pragma mark - ASIHTTPRequestDelegate

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
    NSLog(@"%@", request.url);
    if (dic) {
        NSInteger err = [dic[@"err"] integerValue];
        if (err == 0) {
            //
            if (_page == 1) {
                [_dataArray removeAllObjects];
            }
            
            NSArray *messageArray = dic[@"conversations"];
            for (NSDictionary *messageDic in messageArray) {
                Message *message = [[Message alloc] initWithMessageDictionary:messageDic];
                [_dataArray addObject:message];
            }
            
            if (_page == 1) {
                [self refreshTable:_tableView];
            } else {
                [self loadMoreDataToTable:_tableView];
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
    [self startMessageRuquestWithPage:_page];
}

- (void)pullTableViewDidTriggerLoadMore:(PullTableView *)pullTableView
{
    if (_dataArray.count == 0) {
        _page = 0;
    }
    else if (_dataArray.count <= 20) {
        _page = 1;
    }
    _page++;
    [self startMessageRuquestWithPage:_page];
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

#pragma mark - Private Methods

- (void)startMessageRuquestWithPage:(NSInteger)page
{
    ASIHTTPRequest *messageRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:api_message_list(page)]];
    messageRequest.delegate = self;
    [messageRequest addRequestHeader:@"Qbtoken" value:[ToolKit getQBTokenFromLocal]];
    
    [_requestQueue addOperation:messageRequest];
}



@end
