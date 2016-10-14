//
//  MyOrderHeadView.m
//  TyreAlliance
//
//  Created by wdx on 16/9/18.
//  Copyright © 2016年 wdx. All rights reserved.
//

#import "MyOrderHeadView.h"
#import "DefaultPageSource.h"
#import "Masonry.h"
@interface MyOrderHeadView()
@property (nonatomic,assign)CGFloat scale;
@end
@implementation MyOrderHeadView
-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithReuseIdentifier:reuseIdentifier]) {
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
    UITapGestureRecognizer * tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(btnEvent:)];
    [self addGestureRecognizer:tap];
    
    self.contentView.backgroundColor=[UIColor whiteColor];
    
    
    _labelOrderNum = [UILabel new];
    _labelOrderNum.font=DefaultFont(self.scale);
    _labelOrderNum.textColor=blackTextColor;
    [self addSubview:_labelOrderNum];
    
    
    _labelOrderStates = [UILabel new];
    _labelOrderStates.font=DefaultFont(self.scale);
    _labelOrderStates.textColor=blackTextColor;
    _labelOrderStates.textAlignment=NSTextAlignmentRight;
    [self addSubview:_labelOrderStates];
    
    
    _line1=[UIView new];
    _line1.backgroundColor=blackLineColore;
    [self.contentView addSubview:_line1];
    
    _labelConsignee = [UILabel new];
    _labelConsignee.font=DefaultFont(self.scale);
    _labelConsignee.textColor=blackTextColor;
    [self addSubview:_labelConsignee];
    
    
//    
//    [_labelConsignee mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(20*self.scale);
//        make.top.mas_equalTo(10*self.scale);
//        make.height.mas_equalTo(20*self.scale);
//        make.width.mas_equalTo(Vwidth/2-10*self.scale);
//        
//        make.bottom.mas_equalTo(-30);
//    }];
//    
    _labelNumber = [UILabel new];
    _labelNumber.font=DefaultFont(self.scale);
    _labelNumber.textColor=blackTextColor;
    _labelNumber.textAlignment=NSTextAlignmentRight;
    [self addSubview:_labelNumber];
//    [_labelNumber mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(-20*self.scale);
//        make.top.mas_equalTo(10*self.scale);
//        make.height.mas_equalTo(20*self.scale);
//        make.width.mas_equalTo(Vwidth/2-10*self.scale);
//    }];
    
    _imgAdd=[UIImageView new];
    _imgAdd.contentMode=UIViewContentModeCenter;
    [self.contentView addSubview:_imgAdd];
    _imgAdd.image=[UIImage imageNamed:@"map_weizhi"];
    
    _btnAddress = [UILabel new];
    _btnAddress.font=DefaultFont(self.scale);
    _btnAddress.textColor=blackTextColor;
    _btnAddress.numberOfLines=2;
    [self.contentView addSubview:_btnAddress];
//    [_btnAddress mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(10*self.scale);
//        make.top.mas_equalTo(_labelConsignee.mas_bottom).offset(0*self.scale);
//        make.width.mas_equalTo(Vwidth-20*self.scale);
//        make.height.mas_equalTo(40*self.scale);
////        make.bottom.mas_equalTo(-10*self.scale);
//    }];
}
-(void)btnEvent:(UITapGestureRecognizer *)tap{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(headerActionWithSection:)]) {
        [self.delegate headerActionWithSection:_section];
    }
    
}
-(void)layoutSubviews{
    [super layoutSubviews];
    _labelOrderNum.frame=CGRectMake(10*self.scale, 10*self.scale, Vwidth/2-10*self.scale, 20*self.scale) ;
    
    _labelOrderStates.frame=_labelOrderNum.frame;
    _labelOrderStates.right=Vwidth-10*self.scale;
    
    _line1.frame=CGRectMake(10*self.scale, _labelOrderStates.bottom+10*self.scale, Vwidth-20*self.scale, 0.5*self.scale);
    
    _labelConsignee.frame=CGRectMake(30*self.scale, _line1.top+ 10*self.scale, Vwidth/2 -10*self.scale, 20*self.scale);
    
    _labelNumber.frame=CGRectMake(Vwidth/2, _labelConsignee.top*self.scale, Vwidth/2-10*self.scale, 20*self.scale);
    _labelNumber.right=Vwidth-20*self.scale;
    
    _imgAdd.frame=CGRectMake(10*self.scale, _labelConsignee.bottom+10*self.scale, 20*self.scale, 20*self.scale);
    
    _btnAddress.frame=CGRectMake(_imgAdd.right, _labelConsignee.bottom, Vwidth-50*self.scale, 40*self.scale);
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
