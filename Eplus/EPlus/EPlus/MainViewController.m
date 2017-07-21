//
//  MainViewController.m
//  EPlus
//
//  Created by 韩亚周 on 2017/5/7.
//  Copyright © 2017年 韩亚周. All rights reserved.
//

#import "MainViewController.h"
#import "YYHelper.h"

@interface MainViewController ()

@end

@implementation MainViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.view.backgroundColor = UIColorFromRGB(0x01bbba);
    
    
    WKWebViewConfiguration *configuretion = [[WKWebViewConfiguration alloc]init];
    /*WKUserContentController *wkUController = [[WKUserContentController alloc] init];
    configuretion.userContentController = wkUController;
    // 自适应屏幕宽度js
    NSString *jSString = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
    WKUserScript *wkUserScript = [[WKUserScript alloc] initWithSource:jSString injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    // 添加自适应屏幕宽度js调用的方法
    
    [wkUController addUserScript:wkUserScript];*/
    
    // 设置偏好设置
    configuretion.preferences = [[WKPreferences alloc]init];
    configuretion.preferences.minimumFontSize = 8;
    configuretion.preferences.javaScriptEnabled = YES;
    configuretion.processPool = [[WKProcessPool alloc]init];
    // 通过js与webview内容交互配置
    configuretion.userContentController = [[WKUserContentController alloc] init];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    //OC注册供JS调用的方法
    [configuretion.userContentController addScriptMessageHandler:self name:@"screen"];
    [configuretion.userContentController addScriptMessageHandler:self name:@"drawRect"];
    [configuretion.userContentController addScriptMessageHandler:self name:@"popBack"];
    // 默认是不能通过JS自动打开窗口的，必须通过用户交互才能打开
    configuretion.preferences.javaScriptCanOpenWindowsAutomatically = NO;
    _webView = [[WKWebView alloc]initWithFrame:CGRectZero configuration:configuretion];
    _webView.scrollView.bounces = NO;
    _webView.navigationDelegate = self;
    _webView.scrollView.backgroundColor = UIColorFromRGB(0x01bbba);
    _webView.UIDelegate = self;
//    self.view =_webView;
    
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
    
//    [MBProgressHUD showMessage:@"Loading..."];
    
    /*_progressView = [[UIProgressView alloc]initWithFrame:CGRectMake(0, 85, CGRectGetWidth(self.view.frame),2)];
    _progressView.progressTintColor = UIColorFromRGB(0x2D3F57);
    [self.view addSubview:_progressView];
    [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew| NSKeyValueObservingOptionOld context:nil];
     */
    
    
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@appindex.action?user.usercode=%@&token=%@",MAINURL,_usercodeString,_tokenString]]]];
    
    /*NSString * htmlPath = [[NSBundle mainBundle] pathForResource:@"Main"
                                                          ofType:@"html"];
    NSString * htmlCont = [NSString stringWithContentsOfFile:htmlPath
                                                    encoding:NSUTF8StringEncoding
                                                       error:nil];
    [_webView loadHTMLString:htmlCont baseURL:nil];*/
    
}

#pragma mark - 代理方法 WKNavigationDelegate WKScriptMessageHandler
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    [MBProgressHUD showMessage:@"Loading..."];
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
    if ([message.name isEqualToString:@"screen"]) {
        NSString *body = message.body[@"body"];
        NSArray *params = [body componentsSeparatedByString:@","];
        NSLog(@"screen%@",params);
        QRCodeViewController *qrcodeVC = [[QRCodeViewController alloc] init];
        qrcodeVC.screenSuccess = ^(NSString *codeString){
            NSString *jsStr = [NSString stringWithFormat:@"tobackbarcode('%@')", codeString];
            [_webView evaluateJavaScript:jsStr completionHandler:^(id _Nullable data, NSError * _Nullable error) {
                if (error) {
                    NSLog(@"错误:%@", error.localizedDescription);
                }
            }];
        };
        qrcodeVC.screenFail = ^(){
            
        };
        [self.navigationController pushViewController:qrcodeVC animated:YES];
    } else  if ([message.name isEqualToString:@"drawRect"]) {
        NSString *body = message.body[@"body"];
        NSArray *params = [body componentsSeparatedByString:@","];
        NSLog(@"drawRect%@",params);
        DrawRectViewController *signatureVC = [[DrawRectViewController alloc] init];
        signatureVC.saveSuccess = ^(NSString *pathString){
            NSString *jsStr = [NSString stringWithFormat:@"tobacksignpath('%@')", pathString];
            [_webView evaluateJavaScript:jsStr completionHandler:^(id _Nullable data, NSError * _Nullable error) {
                if (error) {
                    NSLog(@"错误:%@", error.localizedDescription);
                }
            }];
        };
        [self.navigationController pushViewController:signatureVC animated:YES];
    } else if ([message.name isEqualToString:@"popBack"]) {
        NSString *body = message.body[@"body"];
        NSArray *params = [body componentsSeparatedByString:@","];
        NSLog(@"%@",params);
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        NSLog(@"其他");
    }
}

/*
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    NSLog(@" %s,change = %@",__FUNCTION__,change);
    if ([keyPath isEqual: @"estimatedProgress"] && object == _webView) {
        [self.progressView setAlpha:1.0f];
        [self.progressView setProgress:_webView.estimatedProgress animated:YES];
        if(_webView.estimatedProgress >= 1.0f)
        {
            [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
                [self.progressView setAlpha:0.0f];
            } completion:^(BOOL finished) {
                [self.progressView setProgress:0.0f animated:NO];
            }];
        }
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}


- (void)dealloc {
    [_webView removeObserver:self forKeyPath:@"estimatedProgress"];
    
    [_webView setNavigationDelegate:nil];
    [_webView setUIDelegate:nil];
}*/

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
