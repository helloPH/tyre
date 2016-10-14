//
//  RecomIncomeCell.m
//  TyreAlliance
//
//  Created by wdx on 16/9/18.
//  Copyright © 2016年 wdx. All rights reserved.
//

#import "RecomIncomeCell.h"
#import "CellView.h"

@implementation RecomIncomeCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self newView];
    }
    return self;
}
-(void)newView{
    CellView * cellView = [[CellView alloc]initWithFrame:CGRectMake(0, 0, Vwidth, 40*self.scale)];
//    [cellView.btn removeFromSuperview];
//    [self.contentView addSubview:cellView];
//    [cellView ShowRight:YES];

    
    _labelTime=[[UILabel alloc]initWithFrame:CGRectMake(20*self.scale, 10*self.scale, 100*self.scale, 20*self.scale)];
    _labelTime.font=DefaultFont(self.scale);
    _labelTime.textColor=blackTextColor;
    [self.contentView addSubview:_labelTime];
    _labelTime.text=@"2015-5-21";
    
    
    _labelRecomMan=[[UILabel alloc]initWithFrame:CGRectMake(Vwidth/2+20*self.scale, 0, Vwidth/2-40*self.scale, 20*self.scale)];
    _labelRecomMan.font=Small10Font(self.scale);
    _labelRecomMan.textColor=blackTextColor;
    [self.contentView addSubview:_labelRecomMan];
    _labelRecomMan.text=@"推荐人:李四";
    
    
    _labelIncome=[[UILabel alloc]initWithFrame:_labelRecomMan.frame];
    _labelIncome.centerX=_labelRecomMan.centerX+10*self.scale;
    _labelIncome.top=_labelRecomMan.bottom;
    _labelIncome.font=Small10Font(self.scale);
    _labelIncome.textColor=blackTextColor;
    [self.contentView addSubview:_labelIncome];
    _labelIncome.text=@"收益:￥100";
    
    _rightImg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20*self.scale, 20*self.scale)];
    _rightImg.right=Vwidth-10*self.scale;
    _rightImg.centerY=20*self.scale;
    _rightImg.image=[UIImage imageNamed:@"jiantou_jian"];
    _rightImg.contentMode=UIViewContentModeCenter;
    [self.contentView addSubview:_rightImg];
    
    _bottomLine=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Vwidth, 0.5*self.scale)];
    _bottomLine.bottom=40*self.scale;
    _bottomLine.backgroundColor=blackLineColore;
    [self.contentView addSubview:_bottomLine];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
