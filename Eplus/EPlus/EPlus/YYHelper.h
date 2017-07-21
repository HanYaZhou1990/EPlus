//
//  YYHelper.h
//  EPlus
//
//  Created by 韩亚周 on 2017/5/7.
//  Copyright © 2017年 韩亚周. All rights reserved.
//

#ifndef YYHelper_h
#define YYHelper_h

//#define MAINURL @"http://58.185.138.130/phone/"



#define MAINURL @"http://eplus.7tech.sg/phone/"

// rgb颜色转换（16进制->10进制）
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define UIColorFromRGBA(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]

#define Main_Screen_Height      [[UIScreen mainScreen] bounds].size.height
#define Main_Screen_Width       [[UIScreen mainScreen] bounds].size.width
#define ScreenPrecent  Main_Screen_Width / 320.0

#endif /* YYHelper_h */
