//
//  SettleOrderCell.m
//  TyreAlliance
//
//  Created by wdx on 16/9/18.
//  Copyright © 2016年 wdx. All rights reserved.
//

#import "SettleOrderCell.h"

@implementation SettleOrderCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self newView];
    }
    return self;
}
-(void)newView{

    
    _labelTime = [[UILabel alloc]initWithFrame:CGRectMake(10*self.scale, 10*self.scale, 90*self.scale, 20*self.scale)];
    _labelTime.centerX=70*self.scale;
    _labelTime.centerY=20*self.scale;
    _labelTime.font=DefaultFont(self.scale);
    _labelTime.textColor=blackTextColor;
    _labelTime.textAlignment=NSTextAlignmentCenter;
    [self.contentView addSubview:_labelTime];
    _labelTime.text=@"--";
    

    _orderNumber = [[UILabel alloc]initWithFrame:CGRectMake(10*self.scale, 10*self.scale, 90*self.scale, 20*self.scale)];
    _orderNumber.centerX=self.contentView.centerX;
    _orderNumber.centerY=20*self.scale;
    _orderNumber.font=DefaultFont(self.scale);
    _orderNumber.textColor=blackTextColor;
    _orderNumber.textAlignment=NSTextAlignmentCenter;
    [self.contentView addSubview:_orderNumber];
    _orderNumber.text=@"--";
    
    
 
    _labelMoney = [[UILabel alloc]initWithFrame:CGRectMake(10*self.scale, 10*self.scale, 90*self.scale, 20*self.scale)];
    _labelMoney.centerX=Vwidth-70*self.scale;
    _labelMoney.centerY=20*self.scale;
    _labelMoney.font=DefaultFont(self.scale);
    _labelMoney.textColor=lightOrangeColor;
    _labelMoney.textAlignment=NSTextAlignmentCenter;
    [self.contentView addSubview:_labelMoney];
    _labelMoney.text=@"--";
    
    _line=[[UIView alloc]initWithFrame:CGRectMake(0, 39.5*self.scale, Vwidth, 0.5*self.scale)];
    _line.backgroundColor=blackLineColore;
    [self.contentView addSubview:_line];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
