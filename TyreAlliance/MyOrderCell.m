//
//  MyOrderCell.m
//  TyreAlliance
//
//  Created by wdx on 16/9/18.
//  Copyright © 2016年 wdx. All rights reserved.
//

#import "MyOrderCell.h"

@implementation MyOrderCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self newView];
    }
    return self;
}
-(void)newView{
    self.selectionStyle=UITableViewCellSelectionStyleNone;
    
    _topLine=[UIView new];
    _topLine.backgroundColor=blackLineColore;
    [self.contentView addSubview:_topLine];
    
    _imgView=[UIImageView new];
    _imgView.layer.cornerRadius=5*self.scale;
    _imgView.layer.masksToBounds=YES;
    _imgView.layer.borderColor=blackLineColore.CGColor;
    _imgView.layer.borderWidth=0.5;
    _imgView.image=[UIImage imageNamed:@"luntai"];
    _imgView.contentMode=UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:_imgView];
    
    _labelIntro=[UILabel new];
    _labelIntro.numberOfLines=2;
    _labelIntro.font=Small10Font(self.scale);
    _labelIntro.textColor=blackTextColor;
    [self.contentView addSubview:_labelIntro];
    
    
    _labelPrice=[UILabel new];
    _labelPrice.numberOfLines=1;
    _labelPrice.font=Big15Font(self.scale);
    _labelPrice.textColor=lightOrangeColor;
    [self.contentView addSubview:_labelPrice];
    
    
    _labelStandard=[UILabel new];
    _labelStandard.numberOfLines=1;
    _labelStandard.font=Small10Font(self.scale);
    _labelStandard.textColor=blackTextColor;
    [self.contentView addSubview:_labelStandard];
    _labelStandard.bottom=_imgView.bottom;
    
//    _labelStatus=[UILabel new];
//    _labelStatus.numberOfLines=1;
//    _labelStatus.font=Small10Font(self.scale);
//    _labelStatus.textColor=blackTextColor;
//    _labelStatus.textAlignment=NSTextAlignmentRight;
//    [self.contentView addSubview:_labelStatus];
//    _labelStatus.bottom=_labelStandard.bottom;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    _topLine.frame=CGRectMake(0, 0, Vwidth, 0.5*self.scale);
    
    _imgView.frame=CGRectMake(10*self.scale, 10*self.scale, 70*self.scale, 70*self.scale);
    
    _labelIntro.frame=CGRectMake(_imgView.right+10*self.scale, 5*self.scale, Vwidth-30*self.scale-_imgView.width, 30*self.scale);
    
    _labelPrice.frame=CGRectMake(_imgView.right+10*self.scale, _labelIntro.bottom, _labelIntro.width, 20*self.scale);
    
    _labelStandard.frame=_labelPrice.frame;
    _labelStandard.bottom =_imgView.bottom;
    
//    _labelStatus.frame=_labelStandard.frame;
//    _labelStatus.right=Vwidth-10*self.scale;
//    
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
