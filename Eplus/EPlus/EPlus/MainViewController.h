//
//  MainViewController.h
//  EPlus
//
//  Created by 韩亚周 on 2017/5/7.
//  Copyright © 2017年 韩亚周. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import "QRCodeViewController.h"
#import "DrawRectViewController.h"
#import "MBProgressHUD+YY.h"
#import "IQKeyboardManager.h"

/*!主页*/
@interface MainViewController : UIViewController<WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

/*!webView*/
@property (nonatomic, strong) WKWebView *webView;
/*!进度条*/
/*@property (nonatomic, strong) UIProgressView *progressView;*/
/*!需要打开的连接地址*/
@property (nonatomic, strong) NSString  *usercodeString;
/*!需要打开的连接地址*/
@property (nonatomic, strong) NSString  *tokenString;

@end
