//
//  MyOrderFooterView.m
//  TyreAlliance
//
//  Created by wdx on 16/9/18.
//  Copyright © 2016年 wdx. All rights reserved.
//

#import "MyOrderFooterView.h"
#import "DefaultPageSource.h"
#import "Masonry.h"
@interface MyOrderFooterView()
@property (nonatomic,assign)CGFloat scale;
@end
@implementation MyOrderFooterView
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
    self.contentView.backgroundColor=[UIColor whiteColor];
    UIView * topLine=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Vwidth, 0.5*self.scale)];
    topLine.backgroundColor=blackLineColore;
    [self.contentView addSubview:topLine];
    
    _labelGodsCount=[UILabel new];
    _labelGodsCount.font=DefaultFont(self.scale);
    _labelGodsCount.textColor=blackTextColor;
    _labelGodsCount.text=@"共0件商品";
    [self.contentView addSubview:_labelGodsCount];
    
    
    _labelPaid=[UILabel new];
    _labelPaid.font=DefaultFont(self.scale);
    _labelPaid.textColor=blackTextColor;
    _labelPaid.textAlignment=NSTextAlignmentRight;
    _labelPaid.text=@"实付：￥0.00";
    [self.contentView addSubview:_labelPaid];
    
    
    _line=[UIView new];
    _line.backgroundColor=blackLineColore;
    [self.contentView addSubview:_line];
    
    _btnAction=[UIButton new];
    _btnAction.layer.cornerRadius=4;
    _btnAction.layer.masksToBounds=YES;
   
    _btnAction.titleLabel.font=Small10Font(self.scale);
    [_btnAction setBackgroundImage:[UIImage ImageForColor:darkOrangeColor] forState:UIControlStateNormal];
    [_btnAction setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
     [_btnAction setTitle:@"发货" forState:UIControlStateNormal];
    [self.contentView addSubview:_btnAction];
    [_btnAction addTarget:self action:@selector(btnEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    _bottomView=[UIView new];
    _bottomView.backgroundColor=superBackgroundColor;
    [self.contentView addSubview:_bottomView];
}
-(void)layoutSubviews{
    [super layoutSubviews];
    _labelGodsCount.frame=CGRectMake(10*self.scale, 10*self.scale, Vwidth/2-10*self.scale, 20*self.scale);
    
    _labelPaid.frame=CGRectMake(Vwidth/2, 10*self.scale, Vwidth/2-10*self.scale, 20*self.scale);
    
    if (_isHave) {
        _line.frame=CGRectMake(0, _labelGodsCount.bottom+10*self.scale, Vwidth, 0.5*self.scale);
        _line.hidden=NO;
        
        _btnAction.frame=CGRectMake(0, _line.top+8.5*self.scale, 70*self.scale, 25*self.scale);
        _btnAction.hidden=NO;
        
        _btnAction.right=Vwidth-10*self.scale;
        
        _bottomView.frame=CGRectMake(0, _btnAction.bottom+10*self.scale, Vwidth, 10*self.scale);
    }else{
        _line.hidden=YES;
        _btnAction.hidden=YES;
        _bottomView.frame=CGRectMake(0, _labelGodsCount.bottom+10*self.scale, Vwidth, 10*self.scale);
        
    }
    

    
}
-(void)btnEvent:(UIButton*)sender{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(actionWithSection:)]) {
        [self.delegate actionWithSection:_section];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
