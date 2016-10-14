//
//  RecomMan.h
//  TyreAlliance
//
//  Created by wdx on 16/9/12.
//  Copyright © 2016年 wdx. All rights reserved.
//

#import "SuperViewController.h"

@interface RecomMan : SuperViewController
typedef NS_ENUM(NSInteger, ContentType) {
    ContentTypeLevel1=1,//默认从0开始
    ContentTypeLevel2,
};
@property (nonatomic,assign)ContentType contentType;
@end
