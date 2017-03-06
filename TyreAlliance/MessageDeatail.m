//
//  MessageDeatail.m
//  TyreAlliance
//
//  Created by wdx on 16/9/20.
//  Copyright © 2016年 wdx. All rights reserved.
//

#import "MessageDeatail.h"

@interface MessageDeatail ()
@property (nonatomic,strong)UIScrollView * scrollView;
@end

@implementation MessageDeatail

- (void)viewDidLoad {
    [super viewDidLoad];
    [self newNavi];
    [self newView];
    // Do any additional setup after loading the view.
}
-(void)newNavi{
    self.TitleLabel.text=@"消息中心";
    UIButton *popBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
        [popBtn setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
        [popBtn setImage:[UIImage imageNamed:@"left_b"] forState:UIControlStateHighlighted];
    [popBtn addTarget:self action:@selector(PopVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:popBtn];
    
}
-(void)PopVC:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)newView{
    _scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom, Vwidth, Vheight-self.NavImg.height)];
    _scrollView.backgroundColor=superBackgroundColor;
    [self.view addSubview:_scrollView];
    
    UILabel * lable=[[UILabel alloc]initWithFrame:CGRectMake(10*self.scale, 10*self.scale, Vwidth-20*self.scale, 20*self.scale)];
    lable.textColor=blackTextColor;
    lable.font=DefaultFont(self.scale);
    [_scrollView addSubview:lable];
    lable.text=[NSString stringWithFormat:@"%@",_infoDic[@"push_title"]?_infoDic[@"push_title"]:@""];
    
    
    UILabel * labelTime=[[UILabel alloc]initWithFrame:lable.frame];
    labelTime.top=lable.bottom+10*self.scale;
    labelTime.font=Small10Font(self.scale);
    labelTime.textColor=grayTextColor;
    [_scrollView addSubview:labelTime];
    labelTime.text=[NSString stringWithFormat:@"%@",_infoDic[@"push_date"]?_infoDic[@"push_date"]:@""];
    
    
    UIImageView * line1=[[UIImageView alloc]initWithFrame:CGRectMake(0, labelTime.bottom+10*self.scale, Vwidth, 0.5*self.scale)];
    line1.backgroundColor=whiteLineColore;
    [_scrollView addSubview:line1];
    
    UILabel * labelContent=[[UILabel alloc]initWithFrame:CGRectMake(10*self.scale, line1.bottom+10*self.scale, Vwidth-20*self.scale, 20*self.scale)];
    labelContent.numberOfLines=0;
    labelContent.textColor=grayTextColor;
    labelContent.font=DefaultFont(self.scale);
    [_scrollView addSubview:labelContent];
    labelContent.text=[NSString stringWithFormat:@"  %@",_infoDic[@"push_info"]?_infoDic[@"push_info"]:@""];
    
//    UILabel * labelOrder=[[UILabel alloc]initWithFrame:CGRectMake(10*self.scale, 10*self.scale, Vwidth-20*self.scale, 20*self.scale)];
//    _scrollView ad
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
