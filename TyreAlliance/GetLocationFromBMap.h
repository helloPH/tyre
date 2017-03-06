//
//  GetLocationFromBMap.h
//  TyreAlliance
//
//  Created by wdx on 16/9/19.
//  Copyright © 2016年 wdx. All rights reserved.
//

#import "SuperViewController.h"

@interface GetLocationFromBMap : SuperViewController
@property (nonatomic,assign)BOOL isGet;
@property (nonatomic,assign)NSString * addreString;

@property (nonatomic,strong)void (^ callBack)(NSMutableDictionary  * geoDic);
@property (nonatomic,strong)NSMutableDictionary * geoDic;
@end
