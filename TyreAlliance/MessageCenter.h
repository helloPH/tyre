//
//  MessageCenter.h
//  TyreAlliance
//
//  Created by wdx on 16/9/12.
//  Copyright © 2016年 wdx. All rights reserved.
//

#import "SuperViewController.h"

@interface MessageCenter : SuperViewController
typedef NS_ENUM(NSInteger, MessageType) {
    MessageTypeNoti,//默认从0开始
    MessageTypeBack,
};
@property (nonatomic,assign)MessageType messageType;
@end
