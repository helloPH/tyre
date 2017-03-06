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

    
    _labelTime = [[UILabel alloc]initWithFrame:CGRectMake(0, 10*self.scale, Vwidth/3, 20*self.scale)];
    _labelTime.centerX=Vwidth/6;
//    _labelTime.centerY=20*self.scale;
    _labelTime.font=DefaultFont(self.scale);
    _labelTime.textColor=blackTextColor;
    _labelTime.textAlignment=NSTextAlignmentCenter;
    [self.contentView addSubview:_labelTime];
//    _labelTime.text=@"--";
    

    _orderNumber = [[UILabel alloc]initWithFrame:_labelTime.frame];
    _orderNumber.centerX=Vwidth*(3/6.0);
//    _orderNumber.centerY=20*self.scale;
    _orderNumber.font=DefaultFont(self.scale);
    _orderNumber.textColor=blackTextColor;
    _orderNumber.textAlignment=NSTextAlignmentCenter;
    [self.contentView addSubview:_orderNumber];
//    _orderNumber.text=@"--";
    
    
 
    _labelMoney = [[UILabel alloc]initWithFrame:_labelTime.frame];
    _labelMoney.centerX=Vwidth*(5/6.0);
//    _labelMoney.centerY=20*self.scale;
    _labelMoney.font=DefaultFont(self.scale);
    _labelMoney.textColor=lightOrangeColor;
    _labelMoney.textAlignment=NSTextAlignmentCenter;
    [self.contentView addSubview:_labelMoney];
//    _labelMoney.text=@"--";
    
    _line=[[UIView alloc]initWithFrame:CGRectMake(0, 39.5*self.scale, Vwidth, 0.5*self.scale)];
    _line.backgroundColor=blackLineColore;
    [self.contentView addSubview:_line];
}
//-(void)layoutSubviews{
//    [super layoutSubviews];
//     _labelTime.centerX=Vwidth/3;
//    _orderNumber.centerX=Vwidth/2;
//    _labelMoney.centerX=Vwidth*(2/3.0);
//    
//    
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
