//
//  SettleOrderCell.h
//  TyreAlliance
//
//  Created by wdx on 16/9/18.
//  Copyright © 2016年 wdx. All rights reserved.
//

#import "SuperTableViewCell.h"

@interface SettleOrderCell : SuperTableViewCell
@property (nonatomic,strong)UIView * line;

@property (nonatomic,strong)UILabel * labelTime;
@property (nonatomic,strong)UILabel * orderNumber;
@property (nonatomic,strong)UILabel * labelMoney;


@end
