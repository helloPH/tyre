//
//  EvaluateDetailCell.m
//  TyreAlliance
//
//  Created by wdx on 16/9/14.
//  Copyright © 2016年 wdx. All rights reserved.
//

#import "EvaluateDetailCell.h"
#import "Masonry.h"
@implementation EvaluateDetailCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self newView];
    }
    return self;
}
-(void)setLevel:(NSInteger)level{
    _level=level;
    for (int i =0; i < _starView.subviews.count; i ++) {
        UIButton * starBtn=_starView.subviews[i];
        starBtn.selected=NO;
        if (i < level) {
        starBtn.selected=YES;
        }
    }
}
-(void)setImgs:(NSArray *)imgs{
    _imgs=imgs;
    
    //    if (_imgView) {
    //        [_imgView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    //    }
    int column=3;
    CGFloat marginX=10*self.scale;
    CGFloat spX=20*self.scale;
    CGFloat spY=20*self.scale;
    CGFloat btnW=(Vwidth-marginX*2-(column-1)*spX)/column;
    CGFloat btnH=btnW*0.66;
    
    
    for (int i =0; i < _imgs.count; i ++) {
        
        CGFloat btnX= i % column*(spX+btnW) +marginX;
        CGFloat btnY= i / column*(spY+btnH) +10*self.scale;
        UIImageView * img=[UIImageView new];
//        img.contentMode=UIViewContentModeCenter;
        [img setImageWithURL:[NSURL URLWithString:[ImgDuanKou stringByAppendingString:_imgs[i]]] placeholderImage:[UIImage imageNamed:@"beijing_tu"]];
//        img.image=[UIImage imageNamed:_imgs[i]];
        [self.contentView addSubview:img];
        
        [img mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(btnX);
            make.top.mas_equalTo(_labelContent.mas_bottom).offset(btnY);
            make.width.mas_equalTo(btnW);
            make.height.mas_equalTo(btnH);
            make.bottom.mas_equalTo(-10*self.scale);
        }];
    }

}
-(void)newView{
    self.selectionStyle=UITableViewCellSelectionStyleNone;
    
    self.imgHead = [[UIImageView alloc]init];
    self.imgHead.backgroundColor=[UIColor redColor];
    self.imgHead.layer.cornerRadius=20*self.scale;
    self.imgHead.layer.masksToBounds=YES;
    [self.contentView addSubview:self.imgHead];
    self.imgHead.image=[UIImage imageNamed:@"hands_to"];
    [self.imgHead mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(10*self.scale);
        make.size.mas_equalTo(CGSizeMake(40*self.scale, 40*self.scale));
    }];
    
    
    
    self.labelName = [UILabel new];
    self.labelName.font=DefaultFont(self.scale);
    self.labelName.textColor=blackTextColor;
    [self.contentView addSubview:self.labelName];
    [self.labelName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100*self.scale, 20*self.scale));
        make.centerY.mas_equalTo(self.imgHead);
        make.left.mas_equalTo(self.imgHead.mas_right).mas_equalTo(10*self.scale);
    }];
    
    
    
    self.labelTime=[UILabel new];
    self.labelTime.font=Small10Font(self.scale);
    self.labelTime.textColor=grayTextColor;
    self.labelTime.textAlignment=NSTextAlignmentRight;
    [self.contentView addSubview:self.labelTime];
    [self.labelTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100*self.scale, 20*self.scale));
        make.centerY.mas_equalTo(self.labelName);
        make.right.mas_equalTo(self).offset(-10*self.scale);
    }];
    
    
    
    self.line = [UIView new];
    [self.contentView addSubview:self.line];
    self.line.backgroundColor=blackLineColore;
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.imgHead.mas_bottom).mas_equalTo(10);
        make.size.mas_equalTo(CGSizeMake(Vwidth, 0.5));
        make.left.mas_equalTo(0);
    }];
//
    
    self.starView = [UIView new];
    [self.contentView addSubview:self.starView];
    
    [self.starView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10*self.scale);
        make.top.mas_equalTo(self.line.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(Vwidth-20*self.scale, 30*self.scale));
    }];
//
    
    float starW=10*self.scale;
    for (int i = 0 ; i < 5; i ++) {
        UIButton * imgStar = [UIButton new];
        [self.starView addSubview:imgStar];
        
        [imgStar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(i * starW*2);
//            make.top.mas_equalTo(10);
            make.size.mas_equalTo(CGSizeMake(starW, starW));
            make.centerY.mas_equalTo(self.starView.height/2);
         }];
        [imgStar setBackgroundImage:[UIImage imageNamed:@"stars_light"] forState:UIControlStateNormal];
        [imgStar setBackgroundImage:[UIImage imageNamed:@"stars_red"] forState:UIControlStateSelected];
    }


    self.labelContent=[UILabel new];
    self.labelContent.numberOfLines=0;
    self.labelContent.font=DefaultFont(self.scale);
    self.labelContent.textColor=blackTextColor;
    [self.contentView addSubview:self.labelContent];
    
}
-(void)layoutHeight:(BOOL)isImage{
    [self.labelContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10*self.scale);
        make.top.mas_equalTo(self.starView.mas_bottom);
        //        make.size.mas_equalTo(CGSizeMake(Vwidth-20*self.scale, 30*self.scale));
        make.width.mas_equalTo(Vwidth-20*self.scale);
        make.height.mas_greaterThanOrEqualTo(20*self.scale);
        if (!isImage) {
            make.bottom.mas_equalTo(-10*self.scale);
        }
    }];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
