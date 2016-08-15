//
//  ScandalsDetailViewController.m
//  QiuShiBaiKe
//
//  Created by conrad on 14-7-8.
//  Copyright (c) 2014年 conrad. All rights reserved.
//

#import "ScandalsDetailViewController.h"
#import "SeeImageViewController.h"

@interface ScandalsDetailViewController ()
{
    NSInteger _page;
    UIView *_inPutView;
    UITextField *_myComment;
    UIButton *_createCmtBtn;
    NSIndexPath *_curIndexPath;
    UIAlertView *requestFailedAlertView;
}

@end

@implementation ScandalsDetailViewController

#pragma mark - View Lifecycle

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _requestQueue = [[NSOperationQueue alloc] init];
        _dataArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _page = 1;
    
    // Config hide tabbar, create inputview
    self.tabBarController.tabBar.hidden = YES;
    [self createInputView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    // Config navgationbar
    self.navigationItem.title = [NSString stringWithFormat:@"糗事%@", self.qiuShi.qiushiID];
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
    
    // Create tableview
    _detailTableView = [[PullTableView alloc] init];
    [self.view addSubview:_detailTableView];
    if (IOS7_AND_LATER) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        _detailTableView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49);
    } else {
        _detailTableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49);
    }
    _detailTableView.pullDelegate = self;
    _detailTableView.dataSource = self;
    _detailTableView.delegate = self;
    _detailTableView.pullArrowImage = [UIImage imageNamed:@"blueArrow.png"];
    _detailTableView.pullBackgroundColor = [UIColor whiteColor];
    _detailTableView.pullTextColor = [UIColor grayColor];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tableViewTapGesture:)];
    [_detailTableView addGestureRecognizer:tap];
    
    if(!_detailTableView.pullTableIsRefreshing) {
        _detailTableView.pullTableIsRefreshing = YES;
        [self pullTableViewDidTriggerRefresh:_detailTableView];
    }
    
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

#pragma mark - Notification Methods

- (void)keyBoardWillShow:(NSNotification *)noti
{
    CGSize size = [[noti.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    [UIView animateWithDuration:0.25 animations:^{
        _detailTableView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49 - size.height);
        _inPutView.frame = CGRectMake(0, SCREEN_HEIGHT - 49 - size.height, SCREEN_WIDTH, 49);
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_dataArray.count inSection:0];
        [_detailTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }];
}

- (void)keyBoardWillHide:(NSNotification *)noti
{
    [UIView animateWithDuration:0.25 animations:^{
        _detailTableView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49);
        _inPutView.frame = CGRectMake(0, SCREEN_HEIGHT - 49, SCREEN_WIDTH, 49);
        [_detailTableView scrollToRowAtIndexPath:_curIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }];
}


#pragma mark - Button Click

- (void)createCommentBtnClick:(UIButton *)sender
{
    NSLog(@"%@", _myComment.text);
}



#pragma mark - TableView Gesture Methods

- (void)tableViewTapGesture:(UITapGestureRecognizer *)gesture
{
    [self resignInput];
    //获得当前手势触发的在UITableView中的坐标
    CGPoint location = [gesture locationInView:_detailTableView];
    //获得当前坐标对应的indexPath
    NSIndexPath *indexPath = [_detailTableView indexPathForRowAtPoint:location];

    if (indexPath) {
        if (indexPath.row == 0) {
            SandalsCell *cell = (SandalsCell *)[_detailTableView cellForRowAtIndexPath:indexPath];
            CGPoint point = [gesture locationInView:cell.contentView];
            //获得添加到cell.contentView中的子视图
            UIImageView *userIcon = (UIImageView *)[cell.contentView viewWithTag:10];
            UILabel *name = (UILabel *)[cell.contentView viewWithTag:1];
            //UILabel *content = (UILabel *)[cell.contentView viewWithTag:2];
            UIImageView *image = (UIImageView *)[cell.contentView viewWithTag:3];
            UILabel *up = (UILabel *)[cell.contentView viewWithTag:4];
            //UILabel *comment = (UILabel *)[cell.contentView viewWithTag:5];
            UIButton *funnyBtn = (UIButton *)[cell.contentView viewWithTag:6];
            UIButton *badBtn = (UIButton *)[cell.contentView viewWithTag:7];
            UIButton *commentBtn = (UIButton *)[cell.contentView viewWithTag:8];
            UIButton *shareBtn = (UIButton *)[cell.contentView viewWithTag:9];
            
            if (CGRectContainsPoint(userIcon.frame, point) | CGRectContainsPoint(name.frame, point))
            {
                //code to userIcon event
                NSLog(@"usericon");
            }
            else if (CGRectContainsPoint(image.frame, point))
            {
                //code to content event
                SeeImageViewController *seeImageVC = [[SeeImageViewController alloc] initWithNibName:@"SeeImageViewController" bundle:nil];
                CGFloat width = image.frame.size.width;
                CGFloat height = image.frame.size.height;
                if ((width / height) >= (SCREEN_WIDTH / SCREEN_HEIGHT)) {
                    height = (SCREEN_WIDTH * height) / width;
                    width = SCREEN_WIDTH;
                }
                else {
                    width = (SCREEN_HEIGHT * width) / height;
                    height = SCREEN_HEIGHT;
                }
                seeImageVC.imageFrame = CGRectMake((SCREEN_WIDTH - width) / 2, (SCREEN_HEIGHT - height) / 2, width, height);
                seeImageVC.imageURL = self.qiuShi.imageMidURL;
                
                [seeImageVC setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
                [self presentViewController:seeImageVC animated:YES completion:nil];
            }
            else if (CGRectContainsPoint(funnyBtn.frame, point))
            {
                //code to funny event
                [funnyBtn setImage:[UIImage imageNamed:@"funny_selected"] forState:UIControlStateNormal];
                [badBtn setImage:[UIImage imageNamed:@"bad_normal"] forState:UIControlStateNormal];
                NSInteger preUpCount = self.qiuShi.upCount;
                up.text = [NSString stringWithFormat:@"%d 好笑", preUpCount + 1];
                [up setFont:[UIFont boldSystemFontOfSize:12.0]];
            }
            else if (CGRectContainsPoint(badBtn.frame, point))
            {
                //code to bad event
                [funnyBtn setImage:[UIImage imageNamed:@"funny_normal"] forState:UIControlStateNormal];
                [badBtn setImage:[UIImage imageNamed:@"bad_selected"] forState:UIControlStateNormal];
                NSInteger preUpCount = self.qiuShi.upCount;
                up.text = [NSString stringWithFormat:@"%d 好笑", preUpCount - 1];
                [up setFont:[UIFont systemFontOfSize:12.0]];
            }
            else if (CGRectContainsPoint(commentBtn.frame, point))
            {
                //code to comment event
                NSLog(@"commentBtn");
            }
            else if (CGRectContainsPoint(shareBtn.frame, point))
            {
                //code to share event
                NSLog(@"shareBtn");
            }
        } else {
            CommentCell *commentCell = (CommentCell *)[_detailTableView cellForRowAtIndexPath:indexPath];
            CGPoint point = [gesture locationInView:commentCell];
            
            UIImageView *uerIcon = (UIImageView *)[commentCell viewWithTag:10];
            if (CGRectContainsPoint(uerIcon.frame, point)) {
                NSLog(@"userIcon");
            }
        }
    }
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *scandalsCellIdentifier = @"ScandalsCell";
    static NSString *commentCellIdentifier = @"CommentCell";
    UITableViewCell *cell = nil;
    if (indexPath.row == 0) {
        SandalsCell *scandalsCell = [tableView dequeueReusableCellWithIdentifier:scandalsCellIdentifier];
        if (scandalsCell == nil) {
            scandalsCell = [[[NSBundle mainBundle] loadNibNamed:@"SandalsCell" owner:self options:nil] lastObject];
            [scandalsCell configScandalsCellWithQiuShi:self.qiuShi];
            cell = scandalsCell;
        }
    } else {
        CommentCell *commentCell = [tableView dequeueReusableCellWithIdentifier:commentCellIdentifier];
        if (commentCell == nil) {
            commentCell = [[[NSBundle mainBundle] loadNibNamed:@"CommentCell" owner:self options:nil] lastObject];
            [commentCell configCommentCellWithComment:_dataArray[indexPath.row - 1]];
            
            cell = commentCell;
        }
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return self.qiuShi.totalHeight;
    }
    Comment *comment = _dataArray[indexPath.row - 1];
    return comment.totalHeight;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    _curIndexPath = indexPath;
}



#pragma mark - ASIHTTPRequestDelegate

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
    NSArray *commentArray = dic[@"items"];

    if ([self getPageOfRequest:request] == 1) {
        [_dataArray removeAllObjects];
    }
    for (NSDictionary *commentDic in commentArray) {
        Comment *comment = [[Comment alloc] initWithCommentDictionary:commentDic];
        [_dataArray addObject:comment];
    }
    
    if ([self getPageOfRequest:request] == 1) {
        [self refreshTable:_detailTableView];
    } else {
        [self loadMoreDataToTable:_detailTableView];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"%@", request.error);
    requestFailedAlertView = [[UIAlertView alloc] initWithTitle:nil message:@"网络不给力哦" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    [requestFailedAlertView show];
    [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(dismissAlertView) userInfo:nil repeats:NO];
    
    _detailTableView.pullLastRefreshDate = [NSDate date];
    _detailTableView.pullTableIsRefreshing = NO;
    _detailTableView.pullTableIsLoadingMore = NO;
}


#pragma mark - PullTableViewDelegate

- (void)pullTableViewDidTriggerRefresh:(PullTableView *)pullTableView
{
    [self startScandalsDetailRequestWithPage:1];
}

- (void)pullTableViewDidTriggerLoadMore:(PullTableView *)pullTableView
{
    if (_dataArray.count <= 0) {
        _page = 0;
    } else if (_dataArray.count <= 50) {
        _page = 1;
    }
    _page++;
    [self startScandalsDetailRequestWithPage:_page];
}


#pragma mark - Navgation Selecter

- (void)navLeftBtnClick
{
    self.tabBarController.tabBar.hidden = NO;
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Private Methods

- (void)createInputView
{
    _inPutView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 49, SCREEN_WIDTH, 49)];
    
    _myComment = [[UITextField alloc] initWithFrame:CGRectMake(15, 10, SCREEN_WIDTH - 70, 29)];
    _myComment.placeholder = @"说点什么吧...";
    [_myComment setFont:[UIFont systemFontOfSize:15.0]];
    [_myComment setBackgroundColor:UIColorFromRGB(0xFAFAFA)];
    [_myComment setBorderStyle:UITextBorderStyleRoundedRect];
    [_inPutView addSubview:_myComment];
    
    _createCmtBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _createCmtBtn.frame = CGRectMake(SCREEN_WIDTH - 45, 10, 30, 29);
    [_createCmtBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    _createCmtBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15.0];
    _createCmtBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_createCmtBtn setTitle:@"评论" forState:UIControlStateNormal];
    [_createCmtBtn addTarget:self action:@selector(createCommentBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_inPutView addSubview:_createCmtBtn];
    
    [self.view addSubview:_inPutView];
}

- (void)resignInput
{
    [_myComment resignFirstResponder];
}

- (void)startScandalsDetailRequestWithPage:(NSInteger)page
{
    NSURL *url = [NSURL URLWithString:api_comment_browse(self.qiuShi.qiushiID, 50, page)];
    ASIHTTPRequest *scandalsDetailRequest = [ASIHTTPRequest requestWithURL:url];
    scandalsDetailRequest.delegate = self;
    [_requestQueue addOperation:scandalsDetailRequest];
}

- (NSInteger)getPageOfRequest:(ASIHTTPRequest *)request
{
    NSArray *array = [[request.url description] componentsSeparatedByString:@"="];
    return [array.lastObject integerValue];
}

- (void)dismissAlertView
{
    [requestFailedAlertView dismissWithClickedButtonIndex:0 animated:YES];
}

@end
