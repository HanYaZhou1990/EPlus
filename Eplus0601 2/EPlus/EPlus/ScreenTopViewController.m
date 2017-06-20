//
//  ScreenTopViewController.m
//  EPlus
//
//  Created by 韩亚周 on 2017/5/7.
//  Copyright © 2017年 韩亚周. All rights reserved.
//

#import "ScreenTopViewController.h"

@interface ScreenTopViewController ()

@end

@implementation ScreenTopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UIButton *navigationBackgroundButton = [UIButton buttonWithType:UIButtonTypeCustom];
    navigationBackgroundButton.backgroundColor = UIColorFromRGB(0x01bbba);
    navigationBackgroundButton.frame = CGRectMake(0, 0, Main_Screen_Width, 64.0f);
    [self.view addSubview:navigationBackgroundButton];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.backgroundColor = UIColorFromRGB(0x01bbba);
    [backButton setImage:[UIImage imageNamed:@"navbtnleftarrow.png"] forState:UIControlStateNormal];
    backButton.frame = CGRectMake(0, 20.0f, 88.0f, 44.0f);
    backButton.contentEdgeInsets = UIEdgeInsetsMake(10, 12, 10, 52.0f);
    
    __weak ScreenTopViewController *ws = self;
    [backButton buttonClickedHandle:^(UIButton *sender) {
        ws.backHandle();
    }];
    [navigationBackgroundButton addSubview:backButton];
    
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    /*!透明矩形*/
    CAShapeLayer *rectangularLayer = [CAShapeLayer layer];
    UIBezierPath *rectangularPath = [UIBezierPath bezierPathWithRect:CGRectMake(40.0f, 40.0f+64.0f, CGRectGetWidth(screenRect)-80.0f, (CGRectGetWidth(screenRect)-80.0f)*7.0f/6.0f)];
    [rectangularPath setUsesEvenOddFillRule:YES];
    [rectangularLayer setPath:[rectangularPath CGPath]];
    [rectangularLayer setFillColor:[[UIColor clearColor] CGColor]];
    /*摄像头扫描的全部内容*/
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 64.0f, Main_Screen_Width, Main_Screen_Height-64.0f)];
    [path appendPath:rectangularPath];
    [path setUsesEvenOddFillRule:YES];
    
    CAShapeLayer *fillLayer = [CAShapeLayer layer];
    fillLayer.name = @"fillLayer";
    fillLayer.path = path.CGPath;
    fillLayer.fillRule = kCAFillRuleEvenOdd;
    fillLayer.fillColor = [UIColor blackColor].CGColor;
    fillLayer.opacity = 0.8;
    [self.view.layer addSublayer:fillLayer];
    
    _bezierView = [[BezierView alloc] initWithFrame:CGRectMake(40.0f, 40.0f+64.0f, CGRectGetWidth(screenRect)-80.0f, (CGRectGetWidth(screenRect)-80.0f)*7.0f/6.0f)];
    
    [_bezierView start];
    [self.view addSubview:_bezierView];
    
}

- (void)start {
    [_bezierView start];
}

- (void)stop {
    [_bezierView stop];
}

- (void)showResult:(id)result {
    [self stop];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:result[@"Type"] message:result[@"result"] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self start];
        _beginHandle();
    }];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
