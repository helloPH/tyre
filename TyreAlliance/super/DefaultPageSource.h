//
//  DefaultPageSource.h
//  AdultStore
//
//  Created by apple on 15/5/15.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "UIViewAdditions.h"
#import "UIImage+Helper.h"
//#import "UIImageView+AFNetworking.h"
#import "CCLocation.h"


#ifndef AdultStore_DefaultPageSource_h
#define AdultStore_DefaultPageSource_h
#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)
//#define ImgDuanKou        @"http://122.114.98.248:1180"
#define ImgDuanKou        @"http://tlm.ruanmengapp.com"

#define Vwidth [UIScreen mainScreen].bounds.size.width
#define Vheight [UIScreen mainScreen].bounds.size.height

#pragma mark - 下线通知
#define orderLineKey  @"orderLine"

#define FenYe  10

#pragma mark - 界面宏定义
#define Scale ([[UIScreen mainScreen] bounds].size.height > 480)?[[UIScreen mainScreen] bounds].size.height / 568.0:1.0

#define blackLineColore [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1]
#define superBackgroundColor [UIColor colorWithRed:243/255.0 green:243/255.0 blue:243/255.0 alpha:1]
#define tabBarBackgroundColor [UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1]
#define navigationControllerColor [UIColor colorWithRed:57/255.0 green:99/255.0 blue:197/255.0 alpha:1]
#define TextColor [UIColor colorWithRed:131/255.0 green:92/255.0 blue:218/255.0 alpha:1]



#define whiteLineColore [UIColor whiteColor]
#define grayTextColor [UIColor colorWithRed:113/255.0 green:113/255.0 blue:113/255.0 alpha:1]
#define blackTextColor [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1]
#define buttonBlackColor [UIColor colorWithRed:36/255.0 green:76/255.0 blue:129/255.0 alpha:1]
#define buttonHigthedColor [UIColor colorWithRed:255/255.0 green:80/255.0 blue:0/255.0 alpha:1]



#define darkOrangeColor [UIColor colorWithRed:212/255.0 green:25/255.0 blue:37/255.0 alpha:1]
#define lightOrangeColor [UIColor colorWithRed:251/255.0 green:24/255.0 blue:8/255.0 alpha:1]

#define blueTextColor [UIColor colorWithRed:0/255.0 green:134/255.0 blue:237/255.0 alpha:1]
#define DefaultFont(__scale) [UIFont systemFontOfSize:13*__scale]
#define SmallFont(__scale) [UIFont systemFontOfSize:12*__scale]
#define BoldSmallFont(__scale) [UIFont fontWithName:@"Helvetica-Bold" size:12*__scale]
#define BoldSmall11Font(__scale) [UIFont fontWithName:@"Helvetica-Bold" size:11*__scale]
#define Small10Font(__scale) [UIFont systemFontOfSize:10*__scale];
#define BigFont(__scale) [UIFont fontWithName:@"Helvetica-Bold" size:14*__scale]

#define Big15Font(__scale) [UIFont systemFontOfSize:15*__scale]

#define Big16Font(__scale) [UIFont systemFontOfSize:16*__scale]

#define Big17Font(__scale) [UIFont systemFontOfSize:17*__scale]
#define Big17BoldFont(__scale) [UIFont fontWithName:@"Helvetica-Bold" size:17*__scale]

#define SBigFont(__scale) [UIFont systemFontOfSize:18*__scale];

#pragma mark -  旋转角度
#define DegreesToRadians(x) ((x) * M_PI / -180.0)

#pragma mark - DES加密
#define DESKey   @"CRsc123."
#define DESIV      @"@#$~^&*!"

/*
 public const string appkey = "p5tvi9dst0vz4";
 public const string appSecret = "8OWJWGElF6";
 */
#endif
