//
//  EvaluateDetailCell.h
//  TyreAlliance
//
//  Created by wdx on 16/9/14.
//  Copyright © 2016年 wdx. All rights reserved.
//

#import "SuperTableViewCell.h"

@interface EvaluateDetailCell : SuperTableViewCell
@property (nonatomic,strong)UIImageView * imgHead;
@property (nonatomic,strong)UILabel     * labelName;
@property (nonatomic,strong)UILabel     * labelTime;
@property (nonatomic,strong)UIView      * starView,*line;
@property (nonatomic,strong)UILabel     * labelContent;
@property (nonatomic,strong)UIView      * imgBgView;

@property (nonatomic,assign)NSInteger    level;
@property (nonatomic,strong)NSArray * imgs;
@property (nonatomic,strong)void (^block)(NSArray * imgs,NSInteger currentInder);
-(void)layoutHeight:(BOOL)isImage;
@end
