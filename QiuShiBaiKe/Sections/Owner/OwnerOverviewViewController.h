//
//  OwnerOverviewViewController.h
//  QiuShiBaiKe
//
//  Created by conrad on 14-7-8.
//  Copyright (c) 2014年 conrad. All rights reserved.
//

#import "CWBaseViewController.h"
#import "LoginAndRegisterViewController.h"

@interface OwnerOverviewViewController : CWBaseViewController <UITableViewDataSource, UITableViewDelegate, LoginAndRegisterDelegate>
{
    IBOutlet UITableView *_tabView;
}

@property (assign, nonatomic) BOOL focusLogin;

@end
