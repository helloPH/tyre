//
//  GoodsManageSingle.h
//  TyreAlliance
//
//  Created by wdx on 16/9/12.
//  Copyright © 2016年 wdx. All rights reserved.
//

#import "SuperViewController.h"
//NS_ENUM(NSInteger,GoodsType){
//   GoodsTypeShang =0,
//   GoodsTypeXia =1
//} GoodsType;
typedef NS_ENUM(NSInteger, GoodsType) {
    GoodsTypeXia,//默认从0开始
    GoodsTypeShang,
    
};
@interface GoodsManageSingle : SuperViewController
@property (nonatomic,assign)GoodsType  goodsType;
@end
