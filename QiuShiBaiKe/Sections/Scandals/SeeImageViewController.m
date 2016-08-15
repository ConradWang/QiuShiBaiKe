//
//  SeeImageViewController.m
//  QiuShiBaiKe
//
//  Created by conrad on 14-7-17.
//  Copyright (c) 2014年 conrad. All rights reserved.
//

#import "SeeImageViewController.h"
#import "UIImageView+WebCache.h"

@interface SeeImageViewController () <UIScrollViewDelegate>

@end

@implementation SeeImageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.scrollView setContentSize:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.scrollView addSubview:self.imageView];
    // Do any additional setup after loading the view from its nib.
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissViewController)];
    [self.scrollView addGestureRecognizer:tap];
    
    self.scrollView.delegate = self;
    self.scrollView.maximumZoomScale = 2.0;
    self.scrollView.minimumZoomScale = 1.0;
    
    self.imageView.frame = self.imageFrame;
    [self.imageView setImageWithURL:[NSURL URLWithString:self.imageURL]];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dismissViewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)downloadBtnClick:(UIButton *)sender {
    [Dialog simpleToast:@"下载功能暂未实现"];
    
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    for (UIView *view in scrollView.subviews) {
        if ([view isKindOfClass:[UIImageView class]]) {
            return view;
        }
    }
    
    return nil;
}

@end
