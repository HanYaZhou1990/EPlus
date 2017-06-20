//
//  ForgotViewController.m
//  EPlus
//
//  Created by 韩亚周 on 2017/5/7.
//  Copyright © 2017年 韩亚周. All rights reserved.
//

#import "ForgotViewController.h"

@interface ForgotViewController ()

@end

@implementation ForgotViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.view.backgroundColor = UIColorFromRGB(0x2D3F57);
    
    WKWebViewConfiguration *configuretion = [[WKWebViewConfiguration alloc]init];
    // 设置偏好设置
    configuretion.preferences = [[WKPreferences alloc]init];
    configuretion.preferences.minimumFontSize = 8;
    configuretion.preferences.javaScriptEnabled = YES;
    configuretion.processPool = [[WKProcessPool alloc]init];
    // 通过js与webview内容交互配置
    configuretion.userContentController = [[WKUserContentController alloc] init];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    //OC注册供JS调用的方法
    [configuretion.userContentController addScriptMessageHandler:self name:@"popBack"];
    // 默认是不能通过JS自动打开窗口的，必须通过用户交互才能打开
    configuretion.preferences.javaScriptCanOpenWindowsAutomatically = NO;
    _webView = [[WKWebView alloc]initWithFrame:CGRectZero configuration:configuretion];
    _webView.scrollView.bounces = NO;
    _webView.navigationDelegate = self;
    _webView.UIDelegate = self;
//    self.view =_webView;
    _webView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_webView];
    
    
    UIView *statuesBarView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, Main_Screen_Width, 20.0f)];
    statuesBarView.backgroundColor = UIColorFromRGB(0x01bbba);
    [self.view addSubview:statuesBarView];
    
    _webView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_webView];
    
    [self.view addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"H:|[_webView]|"
                               options:1.0
                               metrics:nil
                               views:NSDictionaryOfVariableBindings(_webView)]];
    [self.view addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"V:|-20-[_webView]|"
                               options:1.0
                               metrics:nil
                               views:NSDictionaryOfVariableBindings(_webView)]];
    /*
     *http://122.114.146.13/phone/appgetpassword.action
     */
    [MBProgressHUD showMessage:@"Loading..."];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@appgetpassword.action",MAINURL]]]];
    /*NSString * htmlPath = [[NSBundle mainBundle] pathForResource:@"Forgot"
                                                          ofType:@"html"];
    NSString * htmlCont = [NSString stringWithContentsOfFile:htmlPath
                                                    encoding:NSUTF8StringEncoding
                                                       error:nil];
    [_webView loadHTMLString:htmlCont baseURL:nil];*/
}

#pragma mark - 代理方法 WKNavigationDelegate WKScriptMessageHandler
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{
    [MBProgressHUD hideHUD];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    [MBProgressHUD hideHUD];
    [MBProgressHUD showError:error.localizedDescription];
}

// 接收JavaScript
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    /*
     HTML中js方法里调用:
     window.webkit.messageHandlers.selectImage.postMessage({body:'imageid,9'});
     */
    if ([message.name isEqualToString:@"popBack"]) {
        NSString *body = message.body[@"body"];
        NSArray *params = [body componentsSeparatedByString:@","];
        NSLog(@"%@",params);
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
