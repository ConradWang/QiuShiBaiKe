//
//  SeeImageViewController.h
//  QiuShiBaiKe
//
//  Created by conrad on 14-7-17.
//  Copyright (c) 2014年 conrad. All rights reserved.
//

#import "CWBaseViewController.h"

@interface SeeImageViewController : CWBaseViewController

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (copy, nonatomic) NSString *imageURL;
@property (assign, nonatomic) CGRect imageFrame;

- (IBAction)downloadBtnClick:(UIButton *)sender;
@end
