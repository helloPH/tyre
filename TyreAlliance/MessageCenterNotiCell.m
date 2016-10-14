//
//  MessageCenterNotiCell.m
//  TyreAlliance
//
//  Created by wdx on 16/9/20.
//  Copyright © 2016年 wdx. All rights reserved.
//

#import "MessageCenterNotiCell.h"
#import "Masonry.h"

@implementation MessageCenterNotiCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self newView];
    }
    return self;
}
-(void)newView{
    self.selectionStyle=UITableViewCellSelectionStyleNone;
    
    _topLine=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Vwidth, 0.5*self.scale)];
    _topLine.backgroundColor=blackLineColore;
    [self.contentView addSubview:_topLine];
    
    _redPoint=[[UIView alloc]initWithFrame:CGRectMake(10*self.scale, 10*self.scale, 8*self.scale, 8*self.scale)];
    _redPoint.layer.cornerRadius=_redPoint.width/2;
    _redPoint.layer.masksToBounds=YES;
    _redPoint.backgroundColor=lightOrangeColor;
    [self.contentView addSubview:_redPoint];
    
//    _labelTime=[[UILabel alloc]initWithFrame:CGRectMake(20*self.scale, 10*self.scale, 70*self.scale, 20*self.scale)];
//    _labelTime.font=DefaultFont(self.scale);
//    _labelTime.textColor=blackTextColor;
//    [self.contentView addSubview:_labelTime];
//    _labelTime.text=@"2000-1-1";
//    [_labelTime sizeToFit];
    
    
//    [_labelTime mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(20*self.scale);
//        make.top.mas_equalTo(10*self.scale);
//        make.width.mas_equalTo(70*self.scale);
//        make.height.mas_equalTo(20*self.scale);
//    }];
    
    _labelContent=[[UILabel alloc]initWithFrame:CGRectMake(_redPoint.right+10*self.scale, 10*self.scale, Vwidth-40*self.scale, 20*self.scale)];
    _labelContent.font=DefaultFont(self.scale);
    _labelContent.textColor=blackTextColor;
    _labelContent.numberOfLines=1;
    [self.contentView addSubview:_labelContent];
    _redPoint.centerY=_labelContent.centerY;
//    _labelContent.text=@"--";

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
