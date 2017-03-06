//
//  SelectViewController.h
//  TyreAlliance
//
//  Created by wdx on 16/9/13.
//  Copyright © 2016年 wdx. All rights reserved.
//

#import "SuperViewController.h"
typedef NS_ENUM(NSInteger, ListType) {
    ListTypeBrands,//默认从0开始
    ListTypeStander,
    
};

@interface SelectViewController : SuperViewController
@property (nonatomic,assign)ListType listType;
@property (nonatomic,strong)NSString * selectedPara;
@property (nonatomic,strong)NSString * selectedId;
@property (nonatomic,strong)void (^callBack)(NSString * para,NSString * index);

@end
