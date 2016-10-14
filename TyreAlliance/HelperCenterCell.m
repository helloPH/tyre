//
//  HelperCenterCell.m
//  TyreAlliance
//
//  Created by wdx on 16/9/20.
//  Copyright © 2016年 wdx. All rights reserved.
//

#import "HelperCenterCell.h"
#import "Masonry.h"


@implementation HelperCenterCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self newView];
    }
    return self;
}
-(void)newView{
    _topLine=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Vwidth, 0.5*self.scale)];
    _topLine.backgroundColor=blackLineColore;
    [self.contentView addSubview:_topLine];
    
    
    _question=[UILabel new];
    _question.font=DefaultFont(self.scale);
    _question.textColor=blackTextColor;
    [self.contentView addSubview:_question];
    [_question mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10*self.scale);
        make.top.mas_equalTo(10*self.scale);
        make.width.mas_equalTo(Vwidth-20*self.scale);
        make.height.mas_equalTo(20*self.scale);
    }];
    _ask=[UILabel new];
    _ask.font=SmallFont(self.scale);
    _ask.textColor=blackTextColor;
    _ask.numberOfLines=0;
    [self.contentView addSubview:_ask];
    [_ask mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10*self.scale);
        make.top.mas_equalTo(_question.mas_bottom).offset(5*self.scale);
        make.width.mas_equalTo(Vwidth-20*self.scale);
//        make.height.mas_equalTo(20*self.scale);
        make.bottom.mas_equalTo(-10*self.scale);
        
    }];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
