//
//  MyBankCard.h
//  TyreAlliance
//
//  Created by wdx on 16/9/26.
//  Copyright © 2016年 wdx. All rights reserved.
//

#import "SuperViewController.h"

@interface MyBankCard : SuperViewController
@property (nonatomic,assign)BOOL isHave;
@property (nonatomic,strong)void (^block)(BOOL success);
@end
