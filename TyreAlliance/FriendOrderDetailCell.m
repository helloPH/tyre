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
    
    
    _labelTime = [[UILabel alloc]initWithFrame:CGRectMake(10*self.scale, 10*self.scale, 60*self.scale, 20*self.scale)];
    [self.contentView addSubview:_labelTime];
    _labelTime.font=Small10Font(self.scale);
    _labelTime.textColor=blackTextColor;
    _labelTime.text=@"2000-1-1";
    
    _labelOrder=[[UILabel alloc]initWithFrame:_labelTime.frame];
    _labelOrder.right=Vwidth/2-20*self.scale;
    _labelOrder.textAlignment=NSTextAlignmentRight;
    [self.contentView addSubview:_labelOrder];
    _labelOrder.font=Small10Font(self.scale);
    _labelOrder.textColor=blackTextColor;
    _labelOrder.text=@"123456";
    
    
    _labelMoney=[[UILabel alloc]initWithFrame:_labelTime.frame];
    _labelMoney.left=Vwidth/2+20*self.scale;
    _labelMoney.textAlignment=NSTextAlignmentLeft;
    [self.contentView addSubview:_labelMoney];
    _labelMoney.font=Small10Font(self.scale);
    _labelMoney.textColor=blackTextColor;
    _labelMoney.text=@"￥100";
    
    _labelIncome=[[UILabel alloc]initWithFrame:_labelTime.frame];
    _labelIncome.centerX=Vwidth-50*self.scale;
    _labelIncome.textAlignment=NSTextAlignmentCenter;
    [self.contentView addSubview:_labelIncome];
    _labelIncome.font=Small10Font(self.scale);
    _labelIncome.textColor=blackTextColor;
    _labelIncome.text=@"￥10";
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
