//
//  LoginViewController.h
//  EPlus
//
//  Created by 韩亚周 on 2017/5/7.
//  Copyright © 2017年 韩亚周. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginInputCell.h"
#import "LoginFooterView.h"
#import "MBProgressHUD+YY.h"
#import "MainViewController.h"
#import "ForgotViewController.h"
#import "AFNetworking.h"

/*!登录页面*/
@interface LoginViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

/*!登录页面的账号密码及登陆、忘记密码*/
@property (nonatomic, strong) UITableView *tableView;
/*!用来保存用户及密码*/
@property (nonatomic, strong) NSMutableDictionary *messageDictionary;

@end
