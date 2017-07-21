//
//  LoginInputCell.m
//  EPlus
//
//  Created by 韩亚周 on 2017/5/7.
//  Copyright © 2017年 韩亚周. All rights reserved.
//

#import "LoginInputCell.h"

@interface LoginInputCell ()

@property (nonatomic, strong) UIButton *leftButton;

@end

@implementation LoginInputCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _inputTextField.placeHolderColor = UIColorFromRGB(0XB3BAC4);
//    [_leftButton setImage:[UIImage imageNamed:@"acount.png"] forState:UIControlStateNormal];
    _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _leftButton.userInteractionEnabled = NO;
    _leftButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 8);
    _leftButton.bounds = CGRectMake(0, 0, 30, 42);
    
    _inputTextField.delegate = self;
    _inputTextField.leftView = _leftButton;
    _inputTextField.leftViewMode = UITextFieldViewModeAlways;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.backgroundColor = [UIColor clearColor];
}

- (void)setLeftImage:(UIImage *)leftImage {
    _leftImage = leftImage;
    [_leftButton setImage:leftImage forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

#pragma mark -
#pragma mark UITextFieldDelegate -
- (void)textFieldDidEndEditing:(UITextField *)textField {
    _textFieldEndEidtHandle(self, textField, textField.text);
}

@end
