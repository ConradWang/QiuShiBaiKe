//
//  LoginAndRegisterViewController.h
//  QiuShiBaiKe
//
//  Created by conrad on 14-7-15.
//  Copyright (c) 2014年 conrad. All rights reserved.
//

#import "CWBaseViewController.h"
#import "ASIFormDataRequest.h"

typedef NS_ENUM(NSInteger, CWLoginOrRegisterStyle) {
    CWLoginOrRegisterStyleLogin,
    CWLoginOrRegisterStyleRegister,
};

@class LoginAndRegisterViewController;

@protocol LoginAndRegisterDelegate <NSObject>
@optional
- (void)loginSecceededGetUser:(NSString *)user andIcon:(NSString *)icon;
- (void)loginAndRegisterViewControllerWillDisappear:(BOOL)animated;

@end



@interface LoginAndRegisterViewController : CWBaseViewController <UITableViewDataSource, UITableViewDelegate, ASIHTTPRequestDelegate>
{
    IBOutlet UIScrollView *_scrollView;
    
    IBOutlet UITableView *_loginTableView;
    IBOutlet UITableView *_registerTableView;
}

@property (assign, nonatomic) CWLoginOrRegisterStyle style;
@property (assign, nonatomic) id <LoginAndRegisterDelegate> delegate;

@end
