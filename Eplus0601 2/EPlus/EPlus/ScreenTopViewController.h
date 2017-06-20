//
//  ScreenTopViewController.h
//  EPlus
//
//  Created by 韩亚周 on 2017/5/7.
//  Copyright © 2017年 韩亚周. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYHelper.h"
#import "BezierView.h"
#import "UIButton+Category.h"

/*!扫描二维码时的动画层*/
@interface ScreenTopViewController : UIViewController

@property (nonatomic, strong) BezierView   *bezierView;

@property (nonatomic, copy) void (^beginHandle) ();
@property (nonatomic, copy) void (^backHandle) ();

- (void)showResult:(id)result;

@end
