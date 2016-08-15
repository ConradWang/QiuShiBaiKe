//
//  SettingViewController.h
//  QiuShiBaiKe
//
//  Created by conrad on 14-7-8.
//  Copyright (c) 2014年 conrad. All rights reserved.
//

#import "CWBaseViewController.h"

@class SettingViewController;


@interface SettingViewController : CWBaseViewController <UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UITableView *_tableView;

}

@end
