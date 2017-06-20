//
//  LoginFooterView.m
//  EPlus
//
//  Created by 韩亚周 on 2017/5/7.
//  Copyright © 2017年 韩亚周. All rights reserved.
//

#import "LoginFooterView.h"

#define LEADING     20.0f

@implementation LoginFooterView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        _enterButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _enterButton.frame = CGRectMake(LEADING, LEADING*2, Main_Screen_Width*0.72f - LEADING*2.0f, 44.0f * ScreenPrecent);
        [_enterButton setImage:[UIImage imageNamed:@"enter.png"] forState:UIControlStateNormal];
        [_enterButton setBackgroundColor:UIColorFromRGB(0x009A9A)];
        [self addSubview:_enterButton];
        
        _forgotButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _forgotButton.frame = CGRectMake(LEADING, CGRectGetMaxY(_enterButton.frame)+LEADING*1.5f, Main_Screen_Width*0.72f - LEADING*2.0f, 20.0f);
        [_forgotButton setBackgroundColor:[UIColor clearColor]];
        [_forgotButton setTitle:@"Forgot Your Password ?" forState:UIControlStateNormal];
        [_forgotButton setTitleColor:UIColorFromRGB(0XB3BAC4) forState:UIControlStateNormal];
        _forgotButton.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        [self addSubview:_forgotButton];
    }
    return self;
}

@end
