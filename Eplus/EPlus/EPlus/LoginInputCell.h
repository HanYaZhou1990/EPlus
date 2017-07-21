//
//  LoginInputCell.h
//  EPlus
//
//  Created by 韩亚周 on 2017/5/7.
//  Copyright © 2017年 韩亚周. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYHelper.h"
#import "UITextField+ValueChange.h"

/*!输入框*/
@interface LoginInputCell : UITableViewCell <UITextFieldDelegate>
/*!账号密码的输入框*/
@property (weak, nonatomic) IBOutlet UITextField    *inputTextField;
/*!账号密码前边的图片*/
@property (nonatomic, strong) UIImage               *leftImage;

@property (nonatomic, copy) void (^textFieldEndEidtHandle) (LoginInputCell *inputCell, UITextField *inputTF, NSString *textString);

@end
