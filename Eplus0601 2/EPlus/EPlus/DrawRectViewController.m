//
//  DrawRectViewController.m
//  EPlus
//
//  Created by 韩亚周 on 17/5/10.
//  Copyright © 2017年 韩亚周. All rights reserved.
//

#import "DrawRectViewController.h"

@interface DrawRectViewController ()

@end

@implementation DrawRectViewController

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
    
    __weak DrawRectViewController *ws = self;
    [backButton buttonClickedHandle:^(UIButton *sender) {
        [ws.navigationController popViewControllerAnimated:YES];
    }];
    [navigationBackgroundButton addSubview:backButton];
    
    
    
    _resignButton.layer.borderColor = UIColorFromRGB(0x8C8C8C).CGColor;
    _SaveButton.layer.borderColor = UIColorFromRGB(0x8C8C8C).CGColor;
    _resignButton.layer.borderWidth = 0.44f;
    _SaveButton.layer.borderWidth = 0.44f;
    
    [_resignButton buttonClickedHandle:^(UIButton *sender) {
       /*重签*/
        [_signatureView clearSignature];
    }];
    [_SaveButton buttonClickedHandle:^(UIButton *sender) {
        /*保存*/
        if (_signatureView.isAlreadySignture) {
            UIImage *image = [_signatureView getSignatureImage];
            [self updataImage:image];
        } else {
            [MBProgressHUD showError:@"Invalid signature"];
        }
    }];
}

- (void)updataImage:(UIImage *)image {
    [MBProgressHUD showMessage:@"Loading..."];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager POST:[NSString stringWithFormat:@"%@fileupload.action",MAINURL]
       parameters:@{}
constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *fileName = [NSString stringWithFormat:@"%@_header.png",[formatter stringFromDate:[NSDate date]]];
    [formData appendPartWithFileData:UIImageJPEGRepresentation(image, 0.5)
                                name:@"file"
                            fileName:fileName
                            mimeType:@"image/png"];
} progress:^(NSProgress * _Nonnull uploadProgress) {
    
} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    [MBProgressHUD hideHUD];
    if ([responseObject[@"ret"] boolValue]) {
        _saveSuccess(responseObject[@"filepath"]);
        [_signatureView clearSignature];
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [MBProgressHUD showError:responseObject[@"msg"]];
    }
} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    [MBProgressHUD hideHUD];
    [MBProgressHUD showError:@"Save failed"];
}];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
