//
//  ForgotViewController.h
//  EPlus
//
//  Created by 韩亚周 on 2017/5/7.
//  Copyright © 2017年 韩亚周. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYHelper.h"
#import <WebKit/WebKit.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import "MBProgressHUD+YY.h"

/*!忘记密码*/
@interface ForgotViewController : UIViewController <WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) WKWebView *webView;

@end
