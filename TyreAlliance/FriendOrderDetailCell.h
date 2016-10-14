//
//  FriendOrderDetailCell.h
//  TyreAlliance
//
//  Created by wdx on 16/9/18.
//  Copyright © 2016年 wdx. All rights reserved.
//

#import "SuperTableViewCell.h"

@interface FriendOrderDetailCell : SuperTableViewCell
@property (nonatomic,strong)UIView * topLine;
@property (nonatomic,strong)UILabel * labelTime;
@property (nonatomic,strong)UILabel * labelOrder;
@property (nonatomic,strong)UILabel * labelMoney;
@property (nonatomic,strong)UILabel * labelIncome;
@end
