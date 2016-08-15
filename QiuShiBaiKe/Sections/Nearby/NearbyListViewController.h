//
//  NearbyListViewController.h
//  QiuShiBaiKe
//
//  Created by conrad on 14-7-8.
//  Copyright (c) 2014年 conrad. All rights reserved.
//

#import "CWBaseViewController.h"
#import "PullTableView.h"
#import <CoreLocation/CoreLocation.h>
#import <CoreLocation/CLLocationManagerDelegate.h>

@interface NearbyListViewController : CWBaseViewController <UIActionSheetDelegate, UITableViewDataSource, UITableViewDelegate, PullTableViewDelegate, CLLocationManagerDelegate>
{
    IBOutlet UITableView *_groupTableView;
    IBOutlet UIView *_siftView;
    IBOutlet UIView *_midView;
    
    //位置变量
    NSNumber *_longitude;
    NSNumber *_latitude;
    
    NSMutableArray *_dataArray;
    NSOperationQueue *_requestQueue;
}

@property (strong, nonatomic) PullTableView *tableView;
@property (assign ,nonatomic) BOOL allowLoc;
@property (copy, nonatomic) NSString *gender;
@property (assign, nonatomic) CGFloat time;

@end
