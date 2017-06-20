//
//  LoginViewController.m
//  EPlus
//
//  Created by 韩亚周 on 2017/5/7.
//  Copyright © 2017年 韩亚周. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;

    self.view.backgroundColor = UIColorFromRGB(0x2D3F57);
    
    _messageDictionary = [NSMutableDictionary dictionary];
    [_messageDictionary setObject:@"" forKey:@"account"];
    [_messageDictionary setObject:@"" forKey:@"pwd"];
    
    UIImageView *logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width*0.72f, Main_Screen_Height/2.0f)];
    logoImageView.contentMode = UIViewContentModeCenter;
    logoImageView.image = [UIImage imageNamed:@"logo.png"];
    
    LoginFooterView *footerView = [[LoginFooterView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width*0.72f, Main_Screen_Height/2.0f-110.f)];
    [footerView.enterButton buttonClickedHandle:^(UIButton *sender) {
        [self.view endEditing:YES];
        NSLog(@"登录");
        NSLog(@"_messageDictionary : %@",_messageDictionary);
        NSString *accountString, *passwordString = @"";
        accountString = [NSString stringWithFormat:@"%@",_messageDictionary[@"account"]];
        passwordString = [NSString stringWithFormat:@"%@",_messageDictionary[@"pwd"]];
        if (accountString==nil || [accountString isEqualToString:@""]) {
            [MBProgressHUD showError:@"Enter user name"];
        } else if (passwordString==nil || [passwordString isEqualToString:@""]) {
            [MBProgressHUD showError:@"Enter password"];
        } else {
            [MBProgressHUD showMessage:@"Loding..."];
            [self requestWithParameters:@{@"user.usercode":accountString,@"user.password":passwordString}];
            /*[MBProgressHUD showSuccess:@"Let's go !"];*/
        }
    }];
    
    [footerView.forgotButton buttonClickedHandle:^(UIButton *sender) {
        NSLog(@"忘记密码");
        ForgotViewController *forgotVC = [[ForgotViewController alloc] init];
        [self.navigationController pushViewController:forgotVC animated:YES];
    }];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LoginInputCell class]) bundle:nil] forCellReuseIdentifier:@"LoginInputCell"];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
//    self.tableView.scrollEnabled =NO;
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = logoImageView;
    self.tableView.tableFooterView = footerView;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:self.tableView
                              attribute:NSLayoutAttributeCenterX
                              relatedBy:NSLayoutRelationEqual
                              toItem:self.view
                              attribute:NSLayoutAttributeCenterX
                              multiplier:1.0
                              constant:0]];
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:self.tableView
                              attribute:NSLayoutAttributeWidth
                              relatedBy:NSLayoutRelationEqual
                              toItem:self.view
                              attribute:NSLayoutAttributeWidth
                              multiplier:0.72f
                              constant:0]];
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:self.tableView
                              attribute:NSLayoutAttributeTop
                              relatedBy:NSLayoutRelationEqual
                              toItem:self.view
                              attribute:NSLayoutAttributeTop
                              multiplier:1.0
                              constant:0]];
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:self.tableView
                              attribute:NSLayoutAttributeHeight
                              relatedBy:NSLayoutRelationEqual
                              toItem:self.view
                              attribute:NSLayoutAttributeHeight
                              multiplier:1.0
                              constant:0]];
}

- (void)requestWithParameters:(NSDictionary *)parameters {
    /*
     *http://122.114.146.13/phone/applogin.action?user.usercode=admin&user.password=piglet529
     */
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:[NSString stringWithFormat:@"%@applogin.action",MAINURL]
       parameters:parameters
         progress:^(NSProgress * _Nonnull uploadProgress) {
             
         } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             [MBProgressHUD hideHUD];
             if ([responseObject[@"ret"] integerValue] == 1) {
                 MainViewController *mainVC = [[MainViewController alloc] init];
                 mainVC.usercodeString = parameters[@"user.usercode"];
                 mainVC.tokenString = responseObject[@"token"];
                 [self.navigationController pushViewController:mainVC animated:YES];
             } else {
                 [MBProgressHUD showError:responseObject[@"msg"]];
             }
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             [MBProgressHUD hideHUD];
             [MBProgressHUD showError:error.localizedDescription];
         }];
}

#pragma mark -
#pragma mark UITableViewDataSource -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width*0.72f, 0.72f)];
    footerView.backgroundColor = UIColorFromRGB(0x586575);
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.72f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LoginInputCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LoginInputCell" forIndexPath:indexPath];
    if (indexPath.row == 0) {
        cell.leftImage = [UIImage imageNamed:@"acount.png"];
        cell.inputTextField.placeholder = @"User Name";
        cell.inputTextField.secureTextEntry = NO;
//        cell.inputTextField.text = @"admin";
        cell.inputTextField.text = @"";
    } else {
        cell.leftImage = [UIImage imageNamed:@"pwd.png"];
        cell.inputTextField.placeholder = @"Password";
        cell.inputTextField.secureTextEntry = YES;
//        cell.inputTextField.text = @"111111";
        cell.inputTextField.text = @"";
    }
    [_messageDictionary setObject:cell.inputTextField.text forKey:indexPath.row==0 ? @"account":@"pwd"];
    cell.inputTextField.placeHolderColor = UIColorFromRGB(0XB3BAC4);
    cell.textFieldEndEidtHandle = ^(LoginInputCell *inputCell, UITextField *inputTF, NSString *textString) {
        [_messageDictionary setObject:textString forKey:indexPath.row==0 ? @"account":@"pwd"];
    };
    return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate -



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
