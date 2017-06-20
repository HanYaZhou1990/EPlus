//
//  QRCodeViewController.m
//  HNRuMi
//
//  Created by 韩亚周 on 15/12/3.
//  Copyright (c) 2015年 HYZ. All rights reserved.
//

#import "QRCodeViewController.h"

@interface QRCodeViewController ()

@property (nonatomic, strong) ScreenTopViewController *topViewController;

@end

@implementation QRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"扫一扫";
    
    __weak QRCodeViewController *ws = self;
    
    /*
#import<AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>
#import<AssetsLibrary/AssetsLibrary.h>
#import<CoreLocation/CoreLocation.h>
    */
    
    
    _topViewController = [[ScreenTopViewController alloc] init];
    _topViewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    
    _topViewController.backHandle = ^(){
        [ws stopReading:@{@"Type":@"失败",@"result":@""}];
    };
    self.view.backgroundColor = [UIColor blackColor];
    
    /*!判断是否支持相机*/
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (authStatus ==AVAuthorizationStatusRestricted ||//此应用程序没有被授权访问的照片数据。可能是家长控制权限
            authStatus ==AVAuthorizationStatusDenied)  //用户已经明确否认了这一照片数据的应用程序访问
            {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Eplus does not have permission to use the camera" message:@"Go to settings ?" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if ([[UIApplication sharedApplication]canOpenURL:url]) {
                    [[UIApplication sharedApplication]openURL:url];
                }
            }];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancle" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [self.navigationController popViewControllerAnimated:YES];
            }];
            [alertController addAction:okAction];
            [alertController addAction:cancelAction];
            [self presentViewController:alertController animated:YES completion:nil];
            
            } else if (authStatus ==AVAuthorizationStatusNotDetermined) {
                /*尚未设置相机权限*/
                [self presentViewController:_topViewController animated:NO completion:^{
                    
                }];
                [self startReading];
            } else {
                [self presentViewController:_topViewController animated:NO completion:^{
                    
                }];
                [self startReading];
            }
    }else{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Device does not support camera" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"不支持相机");
        }];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }

}

- (BOOL)startReading {
    NSError *error;
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    if (!input) {
        return NO;
    }else {
        
        _captureSession = [[AVCaptureSession alloc] init];
        [_captureSession addInput:input];
        
        AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
        /*CGRectMake（y的起点/屏幕的高，x的起点/屏幕的宽，扫描的区域的高/屏幕的高，扫描的区域的宽/屏幕的宽）
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        NSLog(@"%@",NSStringFromCGRect(CGRectMake(40.0f/CGRectGetHeight(self.view.frame), 40.0f/CGRectGetWidth(screenRect), (CGRectGetWidth(screenRect)-80.0f)*7.0f/6.0f/CGRectGetHeight(self.view.frame), (CGRectGetWidth(screenRect)-80.0f)/CGRectGetWidth(screenRect))));
        captureMetadataOutput.rectOfInterest = CGRectMake(40.0f/CGRectGetHeight(self.view.frame), 40.0f/CGRectGetWidth(screenRect), (CGRectGetWidth(screenRect)-80.0f)*7.0f/6.0f/CGRectGetHeight(self.view.frame), (CGRectGetWidth(screenRect)-80.0f)/CGRectGetWidth(screenRect)); */
        [_captureSession addOutput:captureMetadataOutput];
        
        dispatch_queue_t dispatchQueue;
        dispatchQueue = dispatch_queue_create("myQueue", NULL);
        [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
        captureMetadataOutput.metadataObjectTypes=@[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
        
        /*不限制有效范围扫描更快*/
        /*CGRect screenRect = [[UIScreen mainScreen] bounds];
        captureMetadataOutput.rectOfInterest = CGRectMake(40.0f/CGRectGetHeight(self.view.frame), (40.0f+64.0f)/CGRectGetWidth(screenRect), (CGRectGetWidth(screenRect)-80.0f)*7.0f/6.0f/CGRectGetHeight(self.view.frame), (CGRectGetWidth(screenRect)-80.0f)/CGRectGetWidth(screenRect));*/

        
        _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
        [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
        [_videoPreviewLayer setFrame:self.view.layer.frame];
        [self.view.layer addSublayer:_videoPreviewLayer];
        
        [_captureSession startRunning];
        
        return YES;
    }
}

-(void)stopReading:(NSDictionary *)dic {
    [_captureSession stopRunning];
    _captureSession = nil;
    [_videoPreviewLayer removeFromSuperlayer];
    
    if ([dic[@"Type"] isEqualToString:@"失败"]) {
        _screenFail();
    } else {
        _screenSuccess(dic[@"result"]);
    }
    
    [_topViewController dismissViewControllerAnimated:NO completion:nil];
    
    [self.navigationController popViewControllerAnimated:YES];
//    [_topViewController showResult:dic];
    __weak QRCodeViewController *ws = self;
    _topViewController.beginHandle = ^(){
        [ws startReading];
    };
}

#pragma mark -
#pragma mark AVCaptureMetadataOutputObjectsDelegate -
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        
        if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *codeString = [metadataObj stringValue];
                NSLog(@"二维码：%@",codeString);
                [self performSelectorOnMainThread:@selector(stopReading:) withObject:@{@"Type":@"二维码",@"result":codeString} waitUntilDone:NO];
            });
        } else {
            NSString *codeString = [metadataObj stringValue];
            NSLog(@"条形码: %@",codeString);
            [self performSelectorOnMainThread:@selector(stopReading:) withObject:@{@"Type":@"条形码",@"result":codeString} waitUntilDone:NO];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
