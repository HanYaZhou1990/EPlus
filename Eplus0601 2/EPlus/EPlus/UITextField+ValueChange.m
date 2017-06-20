//
//  UITextField+ValueChange.m
//  AustraliaCustomer
//
//  Created by 韩亚周 on 17/2/22.
//  Copyright © 2017年 韩亚周. All rights reserved.
//

#import "UITextField+ValueChange.h"

static const void *TextFieldBlockKey = &TextFieldBlockKey;
static const void *placeholderKey = &placeholderKey;

@implementation UITextField (ValueChange)

-(void)valueChange:(ChangeHandle)changed {
    objc_setAssociatedObject(self, TextFieldBlockKey, changed, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addTarget:self action:@selector(actionTouched:) forControlEvents:UIControlEventAllEditingEvents];
}
-(void)actionTouched:(UITextField *)textField{
    ChangeHandle block = objc_getAssociatedObject(self, TextFieldBlockKey);
    if (block) {
        block(textField);
    }
}

-(UIColor *)placeHolderColor
{
    return objc_getAssociatedObject(self, &placeholderKey);
}

-(void)setPlaceHolderColor:(UIColor *)placeHolderColor
{
    objc_setAssociatedObject(self, &placeholderKey, placeHolderColor, OBJC_ASSOCIATION_RETAIN);
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSForegroundColorAttributeName] = placeHolderColor;
    NSAttributedString *attribute = [[NSAttributedString alloc] initWithString:self.placeholder attributes:dict];
    [self setAttributedPlaceholder:attribute];
}

@end
