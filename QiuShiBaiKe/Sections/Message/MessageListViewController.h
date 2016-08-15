//
//  MessageListViewController.h
//  QiuShiBaiKe
//
//  Created by conrad on 14-7-8.
//  Copyright (c) 2014年 conrad. All rights reserved.
//

#import "CWBaseViewController.h"
#import "PullTableView.h"

@interface MessageListViewController : CWBaseViewController <UITableViewDataSource, UITableViewDelegate, PullTableViewDelegate, ASIHTTPRequestDelegate>
{
    NSInteger _page;
    
    PullTableView *_tableView;
    NSMutableArray *_dataArray;
    NSOperationQueue *_requestQueue;
}

@end
