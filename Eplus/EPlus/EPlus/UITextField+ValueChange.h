//
//  UITextField+ValueChange.h
//  AustraliaCustomer
//
//  Created by 韩亚周 on 17/2/22.
//  Copyright © 2017年 韩亚周. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>

typedef void (^ChangeHandle)(UITextField *textField);

@interface UITextField (ValueChange)

@property (nonatomic) UIColor      *placeHolderColor;

-(void)valueChange:(ChangeHandle)changed;

@end
