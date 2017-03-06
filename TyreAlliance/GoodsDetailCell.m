//
//  GoodsDetailCell.m
//  TyreAlliance
//
//  Created by wdx on 16/9/12.
//  Copyright © 2016年 wdx. All rights reserved.
//

#import "GoodsDetailCell.h"
#import "DefaultPageSource.h"

@interface GoodsDetailCell()
@property (nonatomic,assign)CGFloat scale;
@end
@implementation GoodsDetailCell
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
-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
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
    
    _imgView=[UIImageView new];
    _imgView.layer.cornerRadius=5*self.scale;
    _imgView.layer.masksToBounds=YES;
    _imgView.layer.borderColor=blackLineColore.CGColor;
    _imgView.layer.borderWidth=0.5;
    [self.contentView addSubview:_imgView];
    _imgView.image=[UIImage imageNamed:@"luntai_tai"];
    _imgView.contentMode=UIViewContentModeScaleAspectFit;
    
    _labelIntro=[UILabel new];
    _labelIntro.numberOfLines=2;
    _labelIntro.font=DefaultFont(self.scale);
    _labelIntro.textColor=blackTextColor;
    [self.contentView addSubview:_labelIntro];

    
    _labelPrice=[UILabel new];
    _labelPrice.numberOfLines=1;
    _labelPrice.font=Big17Font(self.scale);
    _labelPrice.textColor=lightOrangeColor;
    [self.contentView addSubview:_labelPrice];

    
    _labelStandard=[UILabel new];
    _labelStandard.numberOfLines=1;
    _labelStandard.font=DefaultFont(self.scale);
    _labelStandard.textColor=blackTextColor;
    [self.contentView addSubview:_labelStandard];
 
    _labelStandard.bottom=_imgView.bottom;
    
    
    _cellView=[CellView new];
    _cellView.topline.hidden=NO;
    _cellView.bottomline.hidden=NO;

    [self.contentView addSubview:_cellView];

   
    
    _btnAction=[UIButton new];
    [_btnAction setBackgroundImage:[UIImage ImageForColor:darkOrangeColor] forState:UIControlStateNormal];
    [_btnAction setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _btnAction.titleLabel.font=DefaultFont(self.scale);
    _btnAction.layer.cornerRadius=2;
    _btnAction.layer.masksToBounds=YES;
    _btnAction.tag=100;
    [_btnAction addTarget:self action:@selector(actionOrEdit:) forControlEvents:UIControlEventTouchUpInside];
    [_btnAction setTitle:@"上架" forState:UIControlStateNormal];
    [_cellView addSubview:_btnAction];

    
    _btnEdit=[UIButton new];
    _btnEdit.titleLabel.font=DefaultFont(self.scale);
    _btnEdit.layer.borderColor=darkOrangeColor.CGColor;
    [_btnEdit setTitleColor:darkOrangeColor forState:UIControlStateNormal];
    _btnEdit.layer.borderWidth=0.5;
    _btnEdit.layer.cornerRadius=2;
    _btnEdit.layer.masksToBounds=YES;
    _btnEdit.tag=101;
    [_btnEdit addTarget:self action:@selector(actionOrEdit:) forControlEvents:UIControlEventTouchUpInside];
    [_btnEdit setTitle:@"编辑" forState:UIControlStateNormal];
    [_cellView addSubview:_btnEdit];

}

-(void)layoutSubviews{
    [super layoutSubviews];
    _imgView.frame=CGRectMake(10*self.scale, 10*self.scale, 70*self.scale, 70*self.scale);
    
    _labelIntro.frame=CGRectMake(_imgView.right+10*self.scale, 5*self.scale, Vwidth-30*self.scale-_imgView.width, 30*self.scale);
    
    _labelPrice.frame=CGRectMake(_imgView.right+10*self.scale, _labelIntro.bottom, _labelIntro.width, 20*self.scale);
    
    _labelStandard.frame=_labelPrice.frame;
    _labelStandard.bottom =_imgView.bottom;
    
    _cellView.frame=CGRectMake(0, _imgView.bottom+10*self.scale, Vwidth, 40*self.scale);
    
//    _cellView.backgroundColor=[UIColor grayColor];
    
    _btnAction.frame=CGRectMake(40*self.scale, 0, 70*self.scale, 25*self.scale);
     _btnAction.centerY=_cellView.height/2;
    
    _btnEdit.frame=_btnAction.frame;
    _btnEdit.right=Vwidth-40*self.scale;
}
-(void)actionOrEdit:(UIButton *)sender{
    if (sender.tag==100) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(actionWithIndexPath:)]) {
            [self.delegate actionWithIndexPath:_indexPath];
        }

    }else{
        if (self.delegate && [self.delegate respondsToSelector:@selector(editWithIndexPath:)]) {
            [self.delegate editWithIndexPath:_indexPath];
        }
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
