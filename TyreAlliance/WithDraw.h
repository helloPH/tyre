//
//  WithDraw.h
//  TyreAlliance
//
//  Created by wdx on 16/9/14.
//  Copyright © 2016年 wdx. All rights reserved.
//

#import "SuperViewController.h"

@interface WithDraw : SuperViewController

@property (nonatomic,strong)NSString * stringJin;
@property (nonatomic,strong)void (^block)(BOOL isSuccess);
@end
