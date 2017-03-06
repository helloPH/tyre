//
//  FriendOrderDetailCell.m
//  TyreAlliance
//
//  Created by wdx on 16/9/18.
//  Copyright © 2016年 wdx. All rights reserved.
//

#import "FriendOrderDetailCell.h"

@implementation FriendOrderDetailCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self newView];
    }
    return self;
}
-(void)newView{
    self.selectionStyle=UITableViewCellSelectionStyleNone;
    

    _topLine=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Vwidth, 0.5*self.scale)];
    _topLine.backgroundColor=blackLineColore;
    [self.contentView addSubview:_topLine];
    
    
    _labelTime = [[UILabel alloc]initWithFrame:CGRectMake(10*self.scale, 10*self.scale, Vwidth/4, 20*self.scale)];
    _labelTime.centerX=Vwidth*(1/8.0);
    _labelTime.textAlignment=NSTextAlignmentCenter;
    [self.contentView addSubview:_labelTime];
    _labelTime.font=DefaultFont(self.scale);
    _labelTime.textColor=blackTextColor;
//    _labelTime.text=@"2000-1-1";
    
    _labelOrder=[[UILabel alloc]initWithFrame:_labelTime.frame];
    _labelOrder.centerX=Vwidth*(3/8.0);
    _labelOrder.textAlignment=NSTextAlignmentCenter;
    [self.contentView addSubview:_labelOrder];
    _labelOrder.font=DefaultFont(self.scale);
    _labelOrder.textColor=blackTextColor;
//    _labelOrder.text=@"123456";
    
    
    _labelMoney=[[UILabel alloc]initWithFrame:_labelTime.frame];
    _labelMoney.centerX=Vwidth*(5/8.0);
    _labelMoney.textAlignment=NSTextAlignmentCenter;
    [self.contentView addSubview:_labelMoney];
    _labelMoney.font=DefaultFont(self.scale);
    _labelMoney.textColor=lightOrangeColor;
//    _labelMoney.text=@"￥100";
    
    _labelIncome=[[UILabel alloc]initWithFrame:_labelTime.frame];
    _labelIncome.centerX=Vwidth*(7/8.0);
    _labelIncome.textAlignment=NSTextAlignmentCenter;
    [self.contentView addSubview:_labelIncome];
    _labelIncome.font=DefaultFont(self.scale);
    _labelIncome.textColor=lightOrangeColor;
//    _labelIncome.text=@"￥10";
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
