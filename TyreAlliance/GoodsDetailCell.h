//
//  GoodsDetailCell.h
//  TyreAlliance
//
//  Created by wdx on 16/9/12.
//  Copyright © 2016年 wdx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CellView.h"

@protocol CellDelegate <NSObject>
-(void)actionWithIndexPath:(NSIndexPath *)indexPath;
-(void)editWithIndexPath:(NSIndexPath *)indexPath;
@end

@interface GoodsDetailCell : UITableViewCell
@property (nonatomic,strong)id <CellDelegate>delegate;
@property (nonatomic,strong)NSIndexPath * indexPath;

@property (nonatomic,strong)UIImageView * imgView;
@property (nonatomic,strong)UILabel * labelIntro;
@property (nonatomic,strong)UILabel * labelPrice;
@property (nonatomic,strong)UILabel * labelStandard;

@property (nonatomic,strong)CellView * cellView;
@property (nonatomic,strong)UIButton * btnAction;
@property (nonatomic,strong)UIButton * btnEdit;


@end
