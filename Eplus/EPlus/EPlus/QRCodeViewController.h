//
//  QRCodeViewController.h
//  HNRuMi
//
//  Created by 韩亚周 on 15/12/3.
//  Copyright (c) 2015年 HYZ. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>
#import "ScreenTopViewController.h"

/*!二维码扫描页面*/
@interface QRCodeViewController : UIViewController <AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;

@property (nonatomic, copy ) void (^screenSuccess) (NSString *codeString);
@property (nonatomic, copy ) void (^screenFail) ();

@end
