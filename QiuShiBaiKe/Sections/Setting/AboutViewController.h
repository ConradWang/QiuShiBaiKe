//
//  AboutViewController.h
//  QiuShiBaiKe
//
//  Created by conrad on 14-7-14.
//  Copyright (c) 2014年 conrad. All rights reserved.
//

#import "CWBaseViewController.h"

@interface AboutViewController : CWBaseViewController <UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UITableView *_tableView;
    IBOutlet UITableViewCell *_cell;
    
    
    
}

@end
