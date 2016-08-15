//
//  ScandalsDetailViewController.h
//  QiuShiBaiKe
//
//  Created by conrad on 14-7-8.
//  Copyright (c) 2014年 conrad. All rights reserved.
//

#import "CWBaseViewController.h"
#import "PullTableView.h"
#import "ASIHTTPRequest.h"
#import "QiuShi.h"
#import "Comment.h"
#import "SandalsCell.h"
#import "CommentCell.h"

@interface ScandalsDetailViewController : CWBaseViewController <PullTableViewDelegate, UITableViewDataSource, UITableViewDelegate, ASIHTTPRequestDelegate>
{
    NSMutableArray *_dataArray;
    PullTableView *_detailTableView;
    NSOperationQueue *_requestQueue;

}
@property (strong, nonatomic) QiuShi *qiuShi;

@end
