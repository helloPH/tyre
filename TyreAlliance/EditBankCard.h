//
//  EditBankCard.h
//  TyreAlliance
//
//  Created by wdx on 16/9/27.
//  Copyright © 2016年 wdx. All rights reserved.
//

#import "SuperViewController.h"

@interface EditBankCard : SuperViewController

@property (nonatomic,strong)NSDictionary * cardInfo;
@property (nonatomic,strong)NSString * cId;
@property (nonatomic,assign)BOOL isHave;

@property (nonatomic,strong)void (^block)(BOOL succed);
@end
