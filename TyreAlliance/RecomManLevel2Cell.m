//
//  RecomManLevel2Cell.m
//  TyreAlliance
//
//  Created by wdx on 16/9/19.
//  Copyright © 2016年 wdx. All rights reserved.
//

#import "RecomManLevel2Cell.h"

@implementation RecomManLevel2Cell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self newView];
    }
    return self;
}
-(void)newView{
        self.selectionStyle=UITableViewCellSelectionStyleNone;
    
    
    UIView * topLine=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Vwidth, 0.5*self.scale)];
    topLine.backgroundColor=blackLineColore;
    [self.contentView addSubview:topLine];
    
    _labelName=[[UILabel alloc]initWithFrame:CGRectMake(10*self.scale, 10*self.scale, 60*self.scale, 15*self.scale)];
    _labelName.font=DefaultFont(self.scale);
    _labelName.textColor=blackTextColor;
    [self.contentView addSubview:_labelName];
//    _labelName.text=@"王麻子";
//    [_labelName sizeToFit];
    
    
    _labelPhone=[[UILabel alloc]initWithFrame:_labelName.frame];
    _labelPhone.left=_labelName.right+10*self.scale;
    _labelPhone.font=DefaultFont(self.scale);
    _labelPhone.textColor=grayTextColor;
    [self.contentView addSubview:_labelPhone];
//    _labelPhone.text=@"13383824275";
//    [_labelPhone sizeToFit];
    
    
    
    _recomCount=[[UILabel alloc]initWithFrame:_labelName.frame];
    _recomCount.centerX=Vwidth-70*self.scale;
    _recomCount.textAlignment=NSTextAlignmentCenter;
    _recomCount.font=DefaultFont(self.scale);
    _recomCount.textColor=blackTextColor;
    [self.contentView addSubview:_recomCount];
//    _recomCount.text=@"3";
//    [_recomCount sizeToFit];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
