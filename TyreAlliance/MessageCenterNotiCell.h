//
//  MessageCenterNotiCell.h
//  TyreAlliance
//
//  Created by wdx on 16/9/20.
//  Copyright © 2016年 wdx. All rights reserved.
//

#import "SuperTableViewCell.h"

@interface MessageCenterNotiCell : SuperTableViewCell

@property (nonatomic,strong)UIView * topLine;
@property (nonatomic,strong)UIView * redPoint;
@property (nonatomic,strong)UIImageView * imgTip;
@property (nonatomic,strong)UILabel * labelTime;
@property (nonatomic,strong)UILabel * labelContent;

@end
