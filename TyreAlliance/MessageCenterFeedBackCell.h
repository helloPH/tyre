//
//  MessageCenterFeedBackCell.h
//  TyreAlliance
//
//  Created by wdx on 16/9/20.
//  Copyright © 2016年 wdx. All rights reserved.
//

#import "SuperTableViewCell.h"

@interface MessageCenterFeedBackCell : SuperTableViewCell
@property (nonatomic,strong)UIView * topLine;

@property (nonatomic,strong)UILabel * labelTime;
@property (nonatomic,strong)UILabel * labelTitle;

@property (nonatomic,strong)UIView * sepLine1;
@property (nonatomic,strong)UIView * imgBgView;
@property (nonatomic,strong)UIView * sepLine2;
@property (nonatomic,strong)NSArray * imgs;

@property (nonatomic,strong)UILabel * labelContent;
@property (nonatomic,strong)UILabel * sepLine3;

@property (nonatomic,strong)UILabel * labelContack;
@property (nonatomic,strong)UILabel * labelPhone;
@property (nonatomic,strong)UIView * sepLine4;

@property (nonatomic,strong)UIButton * btnSuperiorVerify;
@property (nonatomic,strong)UIButton * btnFactoryVerify;

@end
