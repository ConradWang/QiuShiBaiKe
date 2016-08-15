//
//  ScandalsListViewController.m
//  QiuShiBaiKe
//
//  Created by conrad on 14-7-8.
//  Copyright (c) 2014年 conrad. All rights reserved.
//

#import "ScandalsListViewController.h"
#import "CheckScandalsViewController.h"
#import "CreateScandalsViewController.h"

@interface ScandalsListViewController ()
{
    NSInteger _curCategory;
    NSMutableArray *_curDataArray;
    
    NSMutableArray *_imgtextDateArray;
    NSMutableArray *_onlytextDateArray;
    NSMutableArray *_onlyimageDateArray;
    NSMutableArray *_latestDateArray;
    NSMutableArray *_eliteDateArray;
    
    
    NSOperationQueue *_requestQueue;
    
    NSInteger _pageImgtext;
    NSInteger _pageOnlytext;
    NSInteger _pageOnlyimage;
    NSInteger _pageLatest;
    NSInteger _pageElite;
    
    
    UIAlertView *requestFailedAlertView;
}

@end

@implementation ScandalsListViewController

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

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        //view init
        if (IOS7_AND_LATER) {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        _categoryBtnView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 40)];
        
        _contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 104, SCREEN_WIDTH, SCREEN_HEIGHT - 49 - 104)];
        
        _imgtextTableView = [[PullTableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 49 - 104)];
        _onlytextTableView = [[PullTableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * 1, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 49 - 104)];
        _onlyimageTableView = [[PullTableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * 2, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 49 - 104)];
        _latestTableView = [[PullTableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * 3, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 49 - 104)];
        _eliteTableView = [[PullTableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * 4, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 49 - 104)];
        
        
        //date init
        _tableViewArray = [NSArray arrayWithObjects:_imgtextTableView, _onlytextTableView, _onlyimageTableView, _latestTableView, _eliteTableView, nil];
        
        _imgtextDateArray = [[NSMutableArray alloc] init];
        _onlytextDateArray = [[NSMutableArray alloc] init];
        _onlyimageDateArray = [[NSMutableArray alloc] init];
        _latestDateArray = [[NSMutableArray alloc] init];
        _eliteDateArray = [[NSMutableArray alloc] init];
        
        _allDataArrays = [NSArray arrayWithObjects:_imgtextDateArray, _onlytextDateArray, _onlyimageDateArray, _latestDateArray, _eliteDateArray, nil];
        
        
        _requestQueue = [[NSOperationQueue alloc] init];
        
        _pageImgtext = 1;
        _pageOnlytext = 1;
        _pageOnlyimage = 1;
        _pageLatest = 1;
        _pageElite = 1;
        
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
   
}

- (void)initView
{
    UIImageView *titleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nav_titleview.png"]];
    self.navigationItem.titleView = titleImageView;
    
    
    //leftBarButtonItem
    UIImage *leftBtnImage = nil;
    if (IOS7_AND_LATER) {
        leftBtnImage = [[UIImage imageNamed:@"scandals_btn_check.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    } else {
        leftBtnImage = [UIImage imageNamed:@"scandals_btn_check.png"];
    }
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithImage:leftBtnImage style:UIBarButtonItemStylePlain target:self action:@selector(navLeftBtnClick)];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
    
    
    //rightBarButtonItem
    UIImage *rightBtnImage = nil;
    if (IOS7_AND_LATER) {
        rightBtnImage = [[UIImage imageNamed:@"scandals_btn_create.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    } else {
        rightBtnImage = [UIImage imageNamed:@"scandals_btn_create.png"];
    }
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithImage:rightBtnImage style:UIBarButtonItemStylePlain target:self action:@selector(navRightBtnClick)];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    
    
    //create category button
    NSArray *categoryTitleArray = [NSArray arrayWithObjects:@"图文", @"纯文", @"纯图", @"最新", @"精华", nil];
    NSInteger btnWidth = (SCREEN_WIDTH - 4) / 5;
    for (int i = 0; i < 5; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = 8 + i;
        button.frame = CGRectMake((btnWidth + 1) * i, 0, btnWidth, 40);
        if (i == 0) [self catagoryBtnClick:button];
        [button setTitle:categoryTitleArray[i] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        [button setTitleColor:UIColorFromRGB(0x979797) forState:UIControlStateNormal];
        [button setTitleColor:UIColorFromRGB(0x242452) forState:UIControlStateSelected];
        [button addTarget:self action:@selector(catagoryBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_categoryBtnView addSubview:button];
        
        if (i != 4) {
            UIView *separatorLine = [[UIView alloc] initWithFrame:CGRectMake((btnWidth + 1) * (i + 1), 15, 1, 10)];
            separatorLine.backgroundColor = [UIColor grayColor];
            [_categoryBtnView addSubview:separatorLine];
        }
    }
    _categoryBtnView.backgroundColor = UIColorFromRGB(0xF7F7F7);
    [self.view addSubview:_categoryBtnView];
    
    
    //config tableview
    _contentScrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 5, SCREEN_HEIGHT - 49 - 104);
    _contentScrollView.tag = 100;
    _contentScrollView.delegate = self;
    _contentScrollView.pagingEnabled = YES;
    _contentScrollView.showsHorizontalScrollIndicator = NO;
    _contentScrollView.showsVerticalScrollIndicator = NO;
    _contentScrollView.scrollsToTop = YES;
    for (int i = 0; i < _tableViewArray.count; i++) {
        PullTableView *tableView = _tableViewArray[i];
        tableView.tag = i;
        tableView.pullDelegate = self;
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.pullArrowImage = [UIImage imageNamed:@"blueArrow.png"];
        tableView.pullBackgroundColor = [UIColor whiteColor];
        tableView.pullTextColor = [UIColor grayColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tableViewTapGesture:)];
        [tableView addGestureRecognizer:tap];

        [_contentScrollView addSubview:tableView];
    }
    [self.view addSubview:_contentScrollView];
}



#pragma mark - Button Click

static UIButton *preSender = nil;
- (void)catagoryBtnClick:(UIButton *)sender
{
    if (preSender.tag != sender.tag) {
        preSender.selected = NO;
    }
    sender.selected = YES;
    
    _curCategory = sender.tag - 8;
    _curDataArray =  _allDataArrays[_curCategory];
    
    [_contentScrollView setContentOffset:CGPointMake(SCREEN_WIDTH * _curCategory, 0) animated:YES];
    //加载数据
    if (_curDataArray.count == 0) {
        PullTableView *tableView = _tableViewArray[_curCategory];
        if(!tableView.pullTableIsRefreshing) {
            tableView.pullTableIsRefreshing = YES;
            [self pullTableViewDidTriggerRefresh:tableView];
        }
    }
    
    preSender = sender;
}

- (void)navLeftBtnClick
{
    CheckScandalsViewController *checkScandalsVC = [[CheckScandalsViewController alloc] initWithNibName:@"CheckScandalsViewController" bundle:nil];
    UINavigationController *checkScandalsNC = [[UINavigationController alloc] initWithRootViewController:checkScandalsVC];
    [self presentViewController:checkScandalsNC animated:YES completion:nil];
}

- (void)navRightBtnClick
{
    CreateScandalsViewController *createScandalsVC = [[CreateScandalsViewController alloc] initWithNibName:@"CreateScandalsViewController" bundle:nil];
    UINavigationController *createScandalsNC = [[UINavigationController alloc] initWithRootViewController:createScandalsVC];
    [self presentViewController:createScandalsNC animated:YES completion:nil];
}

#pragma mark - TableView Gesture Methods

- (void)tableViewTapGesture:(UITapGestureRecognizer *)gesture
{
    PullTableView *tableView = _tableViewArray[_curCategory];
    //获得当前手势触发的在UITableView中的坐标
    CGPoint location = [gesture locationInView:tableView];
    //获得当前坐标对应的indexPath
    NSIndexPath *indexPath = [tableView indexPathForRowAtPoint:location];
    QiuShi *qiuShi = (QiuShi *)_curDataArray[indexPath.row];
    if (indexPath) {
        //通过indexpath获得对应的Cell
        SandalsCell *cell = (SandalsCell *)[tableView cellForRowAtIndexPath:indexPath];
        
        //获得添加到cell.contentView中的子视图
        UIImageView *userIcon = (UIImageView *)[cell.contentView viewWithTag:10];
        UILabel *name = (UILabel *)[cell.contentView viewWithTag:1];
        UILabel *content = (UILabel *)[cell.contentView viewWithTag:2];
        UIImageView *image = (UIImageView *)[cell.contentView viewWithTag:3];
        UILabel *up = (UILabel *)[cell.contentView viewWithTag:4];
        UILabel *comment = (UILabel *)[cell.contentView viewWithTag:5];
        UIButton *funnyBtn = (UIButton *)[cell.contentView viewWithTag:6];
        UIButton *badBtn = (UIButton *)[cell.contentView viewWithTag:7];
        UIButton *commentBtn = (UIButton *)[cell.contentView viewWithTag:8];
        UIButton *shareBtn = (UIButton *)[cell.contentView viewWithTag:9];
        
        CGPoint point = [gesture locationInView:cell.contentView];
        
        if (CGRectContainsPoint(userIcon.frame, point) | CGRectContainsPoint(name.frame, point))
        {
            //code to userIcon event
            NSLog(@"usericon");
        }
        else if (CGRectContainsPoint(content.frame, point) | CGRectContainsPoint(image.frame, point) | CGRectContainsPoint(commentBtn.frame, point))
        {
            //code to content event
            ScandalsDetailViewController *scandalsDetailVC = [[ScandalsDetailViewController alloc] init];
            scandalsDetailVC.qiuShi = qiuShi;
            [self.navigationController pushViewController:scandalsDetailVC animated:YES];
        }
        else if (CGRectContainsPoint(funnyBtn.frame, point))
        {
            //code to funny event
            [funnyBtn setImage:[UIImage imageNamed:@"funny_selected"] forState:UIControlStateNormal];
            [badBtn setImage:[UIImage imageNamed:@"bad_normal"] forState:UIControlStateNormal];
            NSInteger preUpCount = qiuShi.upCount;
            up.text = [NSString stringWithFormat:@"%d 好笑", preUpCount + 1];
            [up setFont:[UIFont boldSystemFontOfSize:12.0]];
        }
        else if (CGRectContainsPoint(badBtn.frame, point))
        {
            //code to bad event
            [funnyBtn setImage:[UIImage imageNamed:@"funny_normal"] forState:UIControlStateNormal];
            [badBtn setImage:[UIImage imageNamed:@"bad_selected"] forState:UIControlStateNormal];
            NSInteger preUpCount = qiuShi.upCount;
            up.text = [NSString stringWithFormat:@"%d 好笑", preUpCount - 1];
            [up setFont:[UIFont systemFontOfSize:12.0]];
        } else if (CGRectContainsPoint(shareBtn.frame, point))
        {
            //code to share event

        }
    }

}



#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView.tag == 100) {
        NSInteger scrollViewPage = scrollView.contentOffset.x / SCREEN_WIDTH;
        
        UIButton *button = (UIButton *)[_categoryBtnView viewWithTag:scrollViewPage + 8];
        [self catagoryBtnClick:button];
    }
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView
{


}

#pragma mark - Refresh and load more methods

- (void) refreshTable:(PullTableView *)pullTableView
{
    [pullTableView reloadData];
    
    pullTableView.pullLastRefreshDate = [NSDate date];
    pullTableView.pullTableIsRefreshing = NO;
}

- (void) loadMoreDataToTable:(PullTableView *)pullTableView
{
    [pullTableView reloadData];
    
    pullTableView.pullTableIsLoadingMore = NO;
}

#pragma mark - UITableViewDataSource

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_allDataArrays[tableView.tag] count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"ScandalsCell";
    
    SandalsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SandalsCell" owner:self options:nil] lastObject];
    }
    //config cell
    QiuShi *qiuShi = [_allDataArrays[tableView.tag] objectAtIndex:indexPath.row];
    [cell configScandalsCellWithQiuShi:qiuShi];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QiuShi *qiuShi = [_allDataArrays[tableView.tag] objectAtIndex:indexPath.row];
    return qiuShi.totalHeight;
}

//- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSLog(@"OK");
//}


#pragma mark - PullTableViewDelegate

- (void)pullTableViewDidTriggerRefresh:(PullTableView *)pullTableView
{
//    if (!pullTableView.pullTableIsRefreshing) {
        [self startScandalsRequestWithCategory:_curCategory andPage:1];
//    }
}

- (void)pullTableViewDidTriggerLoadMore:(PullTableView *)pullTableView
{
//    if (!pullTableView.pullTableIsLoadingMore) {
        switch (_curCategory) {
            case 0:
            {
                if (_curDataArray.count <= 0) {
                    _pageImgtext = 0;
                } else if (_curDataArray.count <= 30) {
                    _pageImgtext = 1;
                }
                _pageImgtext++;
                [self startScandalsRequestWithCategory:_curCategory andPage:_pageImgtext];
            }
                break;
            case 1:
            {
                if (_curDataArray.count <= 0) {
                    _pageOnlytext = 0;
                } else if (_curDataArray.count <= 30) {
                    _pageOnlytext = 1;
                }
                _pageOnlytext++;
                [self startScandalsRequestWithCategory:_curCategory andPage:_pageOnlytext];
            }
                break;
            case 2:
            {
                if (_curDataArray.count <= 0) {
                    _pageOnlyimage = 0;
                } else if (_curDataArray.count <= 30) {
                    _pageOnlyimage = 1;
                }
                _pageOnlyimage++;
                [self startScandalsRequestWithCategory:_curCategory andPage:_pageOnlyimage];
            }
                break;
            case 3:
            {
                if (_curDataArray.count <= 0) {
                    _pageLatest = 0;
                } else if (_curDataArray.count <= 30) {
                    _pageLatest = 1;
                }
                _pageLatest++;
                [self startScandalsRequestWithCategory:_curCategory andPage:_pageLatest];
            }
                break;
            case 4:
            {
                if (_curDataArray.count <= 0) {
                    _pageElite = 0;
                } else if (_curDataArray.count <= 30) {
                    _pageElite = 1;
                }
                _pageElite++;
                [self startScandalsRequestWithCategory:_curCategory andPage:_pageElite];
            }
                break;
                
            default:
                break;
        }
//    }
}

#pragma mark - ASIHTTPRequestDelegate

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
    NSArray *scandalsArray = dic[@"items"];
    if ([self getPageOfRequest:request] == 1) {
        [_allDataArrays[[self getRequestCategory:request]] removeAllObjects];
    }
    for (NSDictionary *scandalsDic in scandalsArray) {
        QiuShi *qiuShi = [[QiuShi alloc] initWithQiuShiDictionary:scandalsDic];
        [_allDataArrays[[self getRequestCategory:request]] addObject:qiuShi];
    }
    
    PullTableView *tableView = _tableViewArray[[self getRequestCategory:request]];
    if ([self getPageOfRequest:request] == 1) {
        [self refreshTable:tableView];
    } else {
        [self loadMoreDataToTable:tableView];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"%@", request.error);
    requestFailedAlertView = [[UIAlertView alloc] initWithTitle:nil message:@"网络不给力哦" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    [requestFailedAlertView show];
    [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(dismissAlertView) userInfo:nil repeats:NO];

    PullTableView *tableView = _tableViewArray[[self getRequestCategory:request]];
    tableView.pullLastRefreshDate = [NSDate date];
    tableView.pullTableIsRefreshing = NO;
    tableView.pullTableIsLoadingMore = NO;
}


#pragma mark - Private Methods

- (void)startScandalsRequestWithCategory:(NSInteger)category andPage:(NSInteger)page
{
    NSURL *url = nil;
    switch (category) {
        case 0:
            url = [NSURL URLWithString:api_scandals_imgtext(30, page)];
            break;
        case 1:
            url = [NSURL URLWithString:api_scandals_onlytext(30, page)];
            break;
        case 2:
            url = [NSURL URLWithString:api_scandals_onlyimage(30, page)];
            break;
        case 3:
            url = [NSURL URLWithString:api_scandals_latest(30, page)];
            break;
        case 4:
            url = [NSURL URLWithString:api_scandals_elite(30, page)];
            break;
            
        default:
            break;
    }
    ASIHTTPRequest *scandalsRequest = [ASIHTTPRequest requestWithURL:url];
    scandalsRequest.delegate = self;
    [_requestQueue addOperation:scandalsRequest];
}

- (NSInteger)getRequestCategory:(ASIHTTPRequest *)request
{
    NSArray *array = [[request.url description] componentsSeparatedByString:@"/"];
    NSString *type = [[[array lastObject] componentsSeparatedByString:@"?"] firstObject];
    if ([type isEqualToString:@"suggest"]) return 0;
    else if ([type isEqualToString:@"text"]) return 1;
    else if ([type isEqualToString:@"imgrank"]) return 2;
    else if ([type isEqualToString:@"latest"]) return 3;
    else if ([type isEqualToString:@"day"]) return 4;
    else return -1;
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
