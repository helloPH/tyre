//
//  SettleOrder.h
//  TyreAlliance
//
//  Created by wdx on 16/9/18.
//  Copyright © 2016年 wdx. All rights reserved.
//

#import "SuperViewController.h"
typedef NS_ENUM(NSInteger, OrderType) {
    OrderTypeDid,//默认从0开始
    OrderTypeNo,
};

@interface SettleOrder : SuperViewController
@property (nonatomic,assign)OrderType orderType;
@end
