//
//  MyOrderCell.h
//  TyreAlliance
//
//  Created by wdx on 16/9/18.
//  Copyright © 2016年 wdx. All rights reserved.
//

#import "SuperTableViewCell.h"
@protocol CellDelegate <NSObject>
-(void)actionWithIndexPath:(NSIndexPath *)indexPath;
-(void)editWithIndexPath:(NSIndexPath *)indexPath;
@end
@interface MyOrderCell : SuperTableViewCell
@property (nonatomic,strong)id <CellDelegate>delegate;
@property (nonatomic,strong)NSIndexPath * indexPath;

@property (nonatomic,strong)UIView * topLine;
@property (nonatomic,strong)UIImageView * imgView;
@property (nonatomic,strong)UILabel * labelIntro;
@property (nonatomic,strong)UILabel * labelPrice;
@property (nonatomic,strong)UILabel * labelStandard;
//@property (nonatomic,strong)UILabel * labelStatus;

@end
