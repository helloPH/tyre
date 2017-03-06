//
//  MessageCenterFeedBackCell.m
//  TyreAlliance
//
//  Created by wdx on 16/9/20.
//  Copyright © 2016年 wdx. All rights reserved.
//

#import "MessageCenterFeedBackCell.h"
#import "Masonry.h"

@implementation MessageCenterFeedBackCell
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
    
    
//    _labelTime=[[UILabel alloc]initWithFrame:CGRectMake(10*self.scale, 10*self.scale, 80*self.scale, 20*self.scale)];
//    _labelTime.centerY=20*self.scale;
//    _labelTime.font=DefaultFont(self.scale);
//    _labelTime.textColor=blackTextColor;
//    [self.contentView addSubview:_labelTime];
//    _labelTime.text=@"2000-1-1";
    
    
    _labelTitle=[[UILabel alloc]initWithFrame:CGRectMake(10*self.scale, 10*self.scale, Vwidth-20*self.scale, 20*self.scale)];
    _labelTitle.centerY=20*self.scale;
    _labelTitle.font=DefaultFont(self.scale);
    _labelTitle.textColor=blackTextColor;
    [self.contentView addSubview:_labelTitle];

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
