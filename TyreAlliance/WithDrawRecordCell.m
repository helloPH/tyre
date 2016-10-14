//
//  WithDrawRecordCell.m
//  TyreAlliance
//
//  Created by wdx on 16/9/20.
//  Copyright © 2016年 wdx. All rights reserved.
//

#import "WithDrawRecordCell.h"

@implementation WithDrawRecordCell
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
    
    
    _labelTime = [[UILabel alloc]initWithFrame:CGRectMake(10*self.scale, 10*self.scale, 60*self.scale, 20*self.scale)];
    [self.contentView addSubview:_labelTime];
    _labelTime.font=Small10Font(self.scale);
    _labelTime.textColor=blackTextColor;
    _labelTime.text=@"2000-1-1";
    
    _labelMoney=[[UILabel alloc]initWithFrame:_labelTime.frame];
    _labelMoney.centerX=Vwidth/2-50*self.scale;
    _labelMoney.textAlignment=NSTextAlignmentCenter;
    [self.contentView addSubview:_labelMoney];
    _labelMoney.font=Small10Font(self.scale);
    _labelMoney.textColor=lightOrangeColor;
    _labelMoney.text=@"￥100";
    
    
    _labelStaus=[[UILabel alloc]initWithFrame:_labelTime.frame];
    _labelStaus.left=Vwidth/2+20*self.scale;
    _labelStaus.textAlignment=NSTextAlignmentLeft;
    [self.contentView addSubview:_labelStaus];
    _labelStaus.font=Small10Font(self.scale);
    _labelStaus.textColor=navigationControllerColor;
    _labelStaus.text=@"已审核";
    
    _labelIncomeTime=[[UILabel alloc]initWithFrame:_labelTime.frame];
    _labelIncomeTime.centerX=Vwidth-50*self.scale;
    _labelIncomeTime.textAlignment=NSTextAlignmentCenter;
    [self.contentView addSubview:_labelIncomeTime];
    _labelIncomeTime.font=Small10Font(self.scale);
    _labelIncomeTime.textColor=blackTextColor;
    _labelIncomeTime.text=@"2000-1-1";
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
