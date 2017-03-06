//
//  EvaluateDetailCell.m
//  TyreAlliance
//
//  Created by wdx on 16/9/14.
//  Copyright © 2016年 wdx. All rights reserved.
//

#import "EvaluateDetailCell.h"
#import "Masonry.h"
@interface EvaluateDetailCell()
@property (nonatomic,assign)NSInteger currentIndex;
@end
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
        for (UIImageView * img in self.contentView.subviews) {
            if (img.tag>=1000) {
                if ([img isKindOfClass:[UIImageView class]]) {
                    [img removeFromSuperview];
                }
            }
        }
    
//        if (_imgView) {
//            [_imgView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
//        }
    int column=3;
    CGFloat marginX=10*self.scale;
    CGFloat spX=20*self.scale;
    CGFloat spY=20*self.scale;
    CGFloat btnW=(Vwidth-marginX*2-(column-1)*spX)/column;
    CGFloat btnH=btnW*0.75;
    
    
    for (int i =0; i < _imgs.count; i ++) {
        
        
        
        CGFloat btnX= i % column*(spX+btnW) +marginX;
        CGFloat btnY= i / column*(spY+btnH) +10*self.scale;
        UIImageView * img=[UIImageView new];
        img.tag=1000+i;
//        img.contentMode=UIViewContentModeCenter;
        [img setImageWithURL:[NSURL URLWithString:[ImgDuanKou stringByAppendingString:_imgs[i]]] placeholderImage:[UIImage imageNamed:@"noData"]];
        img.contentMode=UIViewContentModeScaleAspectFill;
        img.layer.masksToBounds=YES;
//        img.contentMode=UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:img];
        img.userInteractionEnabled=YES;
//        img.tag=i+100;
        UITapGestureRecognizer * tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(skipToPhotoBrower:)];
        [img addGestureRecognizer:tap];
        [img mas_makeConstraints:^(MASConstraintMaker *make) {
            if (_imgs.count!=0) {
                make.left.mas_equalTo(btnX);
                make.top.mas_equalTo(_labelContent.mas_bottom).offset(btnY);
                make.width.mas_equalTo(btnW);
                make.height.mas_equalTo(btnH);
            }
            
   
        }];
    }

}
-(void)newView{
    self.selectionStyle=UITableViewCellSelectionStyleNone;
    
    self.imgHead = [[UIImageView alloc]init];
//    self.imgHead.backgroundColor=[UIColor redColor];
    self.imgHead.layer.cornerRadius=20*self.scale;
    self.imgHead.layer.masksToBounds=YES;
    [self.contentView addSubview:self.imgHead];
//    self.imgHead.image=[UIImage imageNamed:@"hands_to"];
    self.imgHead.contentMode=UIViewContentModeScaleAspectFit;
//    [self.imgHead mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.top.mas_equalTo(10*self.scale);
//        make.size.mas_equalTo(CGSizeMake(40*self.scale, 40*self.scale));
//    }];
    
    
    
    self.labelName = [UILabel new];
    self.labelName.font=DefaultFont(self.scale);
    self.labelName.textColor=blackTextColor;
    [self.contentView addSubview:self.labelName];
//    [self.labelName mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(CGSizeMake(100*self.scale, 20*self.scale));
//        make.centerY.mas_equalTo(self.imgHead);
//        make.left.mas_equalTo(self.imgHead.mas_right).mas_equalTo(10*self.scale);
//    }];
    
    
    
    self.labelTime=[UILabel new];
    self.labelTime.font=Small10Font(self.scale);
    self.labelTime.textColor=grayTextColor;
    self.labelTime.textAlignment=NSTextAlignmentRight;
    [self.contentView addSubview:self.labelTime];
//    [self.labelTime mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(CGSizeMake(100*self.scale, 20*self.scale));
//        make.centerY.mas_equalTo(self.labelName);
//        make.right.mas_equalTo(self).offset(-10*self.scale);
//    }];
    
    
    
    self.line = [UIView new];
    [self.contentView addSubview:self.line];
    self.line.backgroundColor=blackLineColore;
//    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.imgHead.mas_bottom).mas_equalTo(10);
//        make.size.mas_equalTo(CGSizeMake(Vwidth, 0.5));
//        make.left.mas_equalTo(0);
//    }];
//
    
    self.starView = [UIView new];
    [self.contentView addSubview:self.starView];
    
//    [self.starView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(10*self.scale);
//        make.top.mas_equalTo(self.line.mas_bottom);
//        make.size.mas_equalTo(CGSizeMake(Vwidth-20*self.scale, 30*self.scale));
//    }];
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
//    [self.labelContent mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(10*self.scale);
//        make.top.mas_equalTo(self.starView.mas_bottom);
//        //        make.size.mas_equalTo(CGSizeMake(Vwidth-20*self.scale, 30*self.scale));
//        make.width.mas_equalTo(Vwidth-20*self.scale);
//        make.height.mas_greaterThanOrEqualTo(20*self.scale);
////        if (!isImage) {
////            make.bottom.mas_equalTo(-10*self.scale);
////        }
//    }];
    
    
    
}
-(void)layoutSubviews{
    _imgHead.left=10*self.scale;
    _imgHead.top=10*self.scale;
    _imgHead.size=CGSizeMake(40*self.scale, 40*self.scale);
    
    _labelName.size=CGSizeMake(100*self.scale, 20*self.scale);
    _labelName.centerY=self.imgHead.centerY;
    _labelName.left=self.imgHead.right+10*self.scale;
    
    _labelTime.size=CGSizeMake(100*self.scale, 20*self.scale);
    _labelTime.centerY=self.labelName.centerY;
    _labelTime.right=Vwidth-10*self.scale;
//    make.size.mas_equalTo(CGSizeMake(100*self.scale, 20*self.scale));
//    make.centerY.mas_equalTo(self.labelName);
//    make.right.mas_equalTo(self).offset(-10*self.scale);
    
    _line.top=self.imgHead.bottom+10*self.scale;
    _line.left=0;
    _line.size=CGSizeMake(Vwidth ,0.5*self.scale);
    
    _starView.left=10*self.scale;
    _starView.top=self.line.bottom;
    _starView.size=CGSizeMake(Vwidth-20*self.scale, 30*self.scale);
    
    
    _labelContent.left=10*self.scale;
    _labelContent.top=self.starView.bottom;
    _labelContent.size=CGSizeMake(Vwidth-20*self.scale, [self Text:_labelContent.text Size:CGSizeMake(Vwidth-20*self.scale, 2000) Font:[UIFont systemFontOfSize:13*self.scale]].height);
    
    
    
//    make.left.mas_equalTo(10*self.scale);
//    make.top.mas_equalTo(self.starView.mas_bottom);
//    //        make.size.mas_equalTo(CGSizeMake(Vwidth-20*self.scale, 30*self.scale));
//    make.width.mas_equalTo(Vwidth-20*self.scale);
//    make.height.mas_greaterThanOrEqualTo(20*self.scale);
//    make.left.mas_equalTo(10*self.scale);
//    make.top.mas_equalTo(self.line.mas_bottom);
//    make.size.mas_equalTo(CGSizeMake(Vwidth-20*self.scale, 30*self.scale));
//    make.top.mas_equalTo(self.imgHead.mas_bottom).mas_equalTo(10);
//    make.size.mas_equalTo(CGSizeMake(Vwidth, 0.5));
//    make.left.mas_equalTo(0);
//    make.size.mas_equalTo(CGSizeMake(100*self.scale, 20*self.scale));
//    make.centerY.mas_equalTo(self.imgHead);
//    make.left.mas_equalTo(self.imgHead.mas_right).mas_equalTo(10*self.scale);
    
//    _imgHead.left.top.mas_equalTo(10*self.scale);
//    _imgHead.size.mas_equalTo(CGSizeMake(40*self.scale, 40*self.scale));
    
    
    
}
//-(void)layoutHeight:(BOOL)isImage{
//    [self.labelContent mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(10*self.scale);
//        make.top.mas_equalTo(self.starView.mas_bottom);
//                make.size.mas_equalTo(CGSizeMake(Vwidth-20*self.scale, 30*self.scale));
//        make.width.mas_equalTo(Vwidth-20*self.scale);
//        make.height.mas_greaterThanOrEqualTo(20*self.scale);
//        if (!isImage) {
//            make.bottom.mas_equalTo(-10*self.scale);
//        }
//    }];
//}
-(void)skipToPhotoBrower:(UITapGestureRecognizer*)tap{
    if (_block) {
        _block(_imgs,tap.view.tag-1000);
    }
}
-(CGSize)Text:(NSString *)text Size:(CGSize)size Font:(UIFont *)fone{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:fone, NSParagraphStyleAttributeName:paragraphStyle.copy};
    return   [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
