//
//  ScandalsListViewController.h
//  QiuShiBaiKe
//
//  Created by conrad on 14-7-8.
//  Copyright (c) 2014年 conrad. All rights reserved.
//

#import "CWBaseViewController.h"
#import "PullTableView.h"
#import "ASIHTTPRequest.h"
#import "QiuShi.h"
#import "SandalsCell.h"
#import "ScandalsDetailViewController.h"

@interface ScandalsListViewController : CWBaseViewController <UIScrollViewDelegate, PullTableViewDelegate, UITableViewDataSource, UITableViewDelegate, ASIHTTPRequestDelegate>
{
    UIScrollView *_contentScrollView;
    UIView *_categoryBtnView;
    
    PullTableView *_imgtextTableView;
    PullTableView *_onlytextTableView;
    PullTableView *_onlyimageTableView;
    PullTableView *_latestTableView;
    PullTableView *_eliteTableView;
    
    NSArray *_tableViewArray;
    NSArray *_allDataArrays;
}

@end
