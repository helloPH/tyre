//
//  GeoViewController.h
//  TyreAlliance
//
//  Created by wdx on 16/10/19.
//  Copyright © 2016年 wdx. All rights reserved.
//

#import "SuperViewController.h"

@interface GeoViewController : SuperViewController

@property (nonatomic,strong)NSMutableString * getMS;
@property (assign,nonatomic)NSInteger geoIndex;
@property (nonatomic,strong)NSString * geoId;



@property (nonatomic,strong)void (^block)(NSString * string,NSMutableDictionary * geoInfo);
@end
