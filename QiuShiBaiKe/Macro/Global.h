//
//  Global.h
//  QiuShiBaiKe
//
//  Created by conrad on 14-7-8.
//  Copyright (c) 2014年 conrad. All rights reserved.
//

#ifndef QiuShiBaiKe_Global_h
#define QiuShiBaiKe_Global_h

#define IOS7_AND_LATER [[UIDevice currentDevice].systemVersion floatValue] >= 7.0

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

#define UIColorFromRGB(rgbValue) \
        [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
                        green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
                         blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


#endif
