//
//  EvaluateCell.m
//  TyreAlliance
//
//  Created by wdx on 16/9/13.
//  Copyright © 2016年 wdx. All rights reserved.
//

#import "EvaluateCell.h"
#import "DefaultPageSource.h"
@interface EvaluateCell()
@property (nonatomic,assign)CGFloat scale;
@end
@implementation EvaluateCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _scale=1.0;
        if ([[UIScreen mainScreen] bounds].size.height > 480)
        {
            _scale = [[UIScreen mainScreen] bounds].size.height / 568.0;
        }
        [self newView];
    }
    return self;
}
-(void)newView{
    self.selectionStyle=UITableViewCellSelectionStyleNone;
    _topLine=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Vwidth, 0.5*self.scale)];
    [self.contentView addSubview:_topLine];
    _topLine.backgroundColor=blackLineColore;
    
    
    
    _imgView=[UIImageView new];
    _imgView.layer.cornerRadius=5*self.scale;
    _imgView.layer.masksToBounds=YES;
    _imgView.layer.borderColor=blackLineColore.CGColor;
    _imgView.layer.borderWidth=0.5;
    _imgView.image=[UIImage imageNamed:@"luntai_tai"];
    [self.contentView addSubview:_imgView];
    
    _labelIntro=[UILabel new];
    _labelIntro.numberOfLines=1;
    _labelIntro.font=SmallFont(self.scale);
    _labelIntro.textColor=blackTextColor;
    [self.contentView addSubview:_labelIntro];
    
    
    _labelStandard=[UILabel new];
    _labelStandard.numberOfLines=1;
    _labelStandard.textColor=blackTextColor;
    _labelStandard.font=SmallFont(self.scale);
    [self.contentView addSubview:_labelStandard];

    
    
    _labelComCount=[UILabel new];
    _labelComCount.numberOfLines=1;
    _labelComCount.font=SmallFont(self.scale);
    _labelComCount.textColor=blackTextColor;
    [self.contentView addSubview:_labelComCount];
    _labelComCount.bottom=_imgView.bottom;
    
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
    _imgView.frame=CGRectMake(10*self.scale, 10*self.scale, 90*self.scale, 90*self.scale);
    
    _labelIntro.frame=CGRectMake(_imgView.right+10*self.scale, 5*self.scale, Vwidth-30*self.scale-_imgView.width, 30*self.scale);
    
    _labelStandard.frame=CGRectMake(_imgView.right+10*self.scale, _labelIntro.bottom, _labelIntro.width, 20*self.scale);
    _labelStandard.centerY=_imgView.centerY;
    
    _labelComCount.frame=_labelStandard.frame;
    _labelComCount.bottom =_imgView.bottom;
    

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
