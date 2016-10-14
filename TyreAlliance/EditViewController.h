//
//  EditViewController.h
//  TyreAlliance
//
//  Created by wdx on 16/9/13.
//  Copyright © 2016年 wdx. All rights reserved.
//

#import "SuperViewController.h"

@interface EditViewController : SuperViewController
@property (nonatomic,strong)void (^callBack)(BOOL isSubmit);
@property (nonatomic,strong)NSString * pid;


@end
