//
//  OrderManage.h
//  TyreAlliance
//
//  Created by wdx on 16/9/12.
//  Copyright © 2016年 wdx. All rights reserved.
//

#import "SuperViewController.h"

@interface OrderManage : SuperViewController
typedef NS_ENUM(NSInteger, OrderType) {
    OrderTypeCancel = -1,//默认从0开始
    OrderTypeWillPay,
    OrderTypeWillDeliverGoods,
    OrderTypeDidDeliverGoods,
    OrderTypeFinish,
};
@property (nonatomic,assign) OrderType orderType;
@end
