//
//  RecomManLevel1Cell.m
//  TyreAlliance
//
//  Created by wdx on 16/9/19.
//  Copyright © 2016年 wdx. All rights reserved.
//

#import "RecomManLevel1Cell.h"

@implementation RecomManLevel1Cell
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
    
    _imgView=[[UIImageView alloc]initWithFrame:CGRectMake(10*self.scale, 10*self.scale, 50*self.scale, 50*self.scale)];
    _imgView.layer.cornerRadius=25*self.scale;
    _imgView.layer.masksToBounds=YES;
    [self.contentView addSubview:_imgView];
    _imgView.image=[UIImage ImageForColor:blackLineColore];
    
    
    _labelName = [[UILabel alloc]initWithFrame:CGRectMake(_imgView.right+10*self.scale, _imgView.top, 70*self.scale, 15*self.scale)];
    [self.contentView addSubview:_labelName];
    _labelName.font=DefaultFont(self.scale);
    _labelName.textColor=blackTextColor;
    _labelName.text=@"---";
    
    _labelPhone = [[UILabel alloc]initWithFrame:_labelName.frame];
    _labelPhone.width=100*self.scale;
    [self.contentView addSubview:_labelPhone];
    _labelPhone.bottom=_imgView.bottom;
    _labelPhone.font=DefaultFont(self.scale);
    _labelPhone.textColor=blackTextColor;
    _labelPhone.text=@"联系方式:-----";
    
    
    _rightImg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20*self.scale, 20*self.scale)];
    _rightImg.image=[UIImage imageNamed:@"jiantou_jian"];
    [self.contentView addSubview:_rightImg];
    _rightImg.contentMode = UIViewContentModeCenter;
    _rightImg.right=Vwidth-10*self.scale;
    _rightImg.centerY=_imgView.centerY;
    
    
    _labelTime = [[UILabel alloc]initWithFrame:_labelName.frame];
    _labelTime.width=100;
    [self.contentView addSubview:_labelTime];
    _labelTime.right=_rightImg.left-5*self.scale;
    _labelTime.textAlignment=NSTextAlignmentRight;
    _labelTime.font=DefaultFont(self.scale);
    _labelTime.textColor=blackTextColor;
    _labelTime.text=@"2000-1-1";
    
    
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
