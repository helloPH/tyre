//
//  WithDrawRecordCell.h
//  TyreAlliance
//
//  Created by wdx on 16/9/20.
//  Copyright © 2016年 wdx. All rights reserved.
//

#import "SuperTableViewCell.h"

@interface WithDrawRecordCell : SuperTableViewCell
@property (nonatomic,strong)UIView * topLine;
@property (nonatomic,strong)UILabel * labelTime;
@property (nonatomic,strong)UILabel * labelMoney;
@property (nonatomic,strong)UILabel * labelStaus;
@property (nonatomic,strong)UILabel * labelIncomeTime;
@end
