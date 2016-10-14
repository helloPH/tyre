//
//  FeedBackDeatil.m
//  TyreAlliance
//
//  Created by wdx on 16/9/28.
//  Copyright © 2016年 wdx. All rights reserved.
//

#import "FeedBackDeatil.h"

@interface FeedBackDeatil ()
@property (nonatomic,strong)NSMutableArray * imgs;
@property (nonatomic,assign)NSInteger  states;


@property (nonatomic,strong)NSMutableDictionary * dataDic;

@property (nonatomic,strong)UIScrollView * scrollView;
@property (nonatomic,strong)UIView * bottomView;
@end

@implementation FeedBackDeatil

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self newNavi];
//    [self newView];
    [self reshData];
    // Do any additional setup after loading the view.
}
-(void)newNavi{
    self.TitleLabel.text=@"反馈详细";
    UIButton *popBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
    [popBtn setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    [popBtn setImage:[UIImage imageNamed:@"left_b"] forState:UIControlStateHighlighted];
    [popBtn addTarget:self action:@selector(PopVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:popBtn];
}

-(void)PopVC:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)initData{
    _dataDic=[NSMutableDictionary dictionary];
    _states=0;
    _imgs=[NSMutableArray array];
    
}
-(void)reshData{
    _fid=@"2";
    NSDictionary * dic=@{@"id":_fid};
    if (_dataDic) {
        [_dataDic removeAllObjects];
    }
   [AnalyzeObject getFeedBackDetailWithDic:dic WithBlock:^(id model, NSString *ret, NSString *msg) {
        if ([ret isEqualToString:@"1"]) {
            [_dataDic addEntriesFromDictionary:model];
            [_imgs addObjectsFromArray:_dataDic[@"Logos"]];
            [self newView];
         }else{
        
             [self showPromptBoxWithSting:msg];
         }
       
    }];
    
}
-(void)newView{
    if (!_scrollView) {
        _scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom, Vwidth, Vheight-self.NavImg.height-40*self.scale)];
        _scrollView.backgroundColor=superBackgroundColor;
        [self.view addSubview:_scrollView];
    }
    [_scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    UIView * bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Vwidth, 10)];
    bgView.backgroundColor=[UIColor whiteColor];
    [_scrollView addSubview:bgView];
    
    UILabel * labelOrderNum=[[UILabel alloc]initWithFrame:CGRectMake(10*self.scale, 10*self.scale, Vwidth-20*self.scale, 20*self.scale)];
    labelOrderNum.font=DefaultFont(self.scale);
    labelOrderNum.textColor=blackTextColor;
    [_scrollView addSubview:labelOrderNum];
    labelOrderNum.text=[NSString stringWithFormat:@"订单号:%@",_dataDic[@"oid"]];
    
    UIView * line1=[[UIView alloc]initWithFrame:CGRectMake(0, labelOrderNum.bottom+10*self.scale, Vwidth, 0.5*self.scale)];
    line1.backgroundColor=blackLineColore;
    [_scrollView addSubview:line1];
    
    
    UIImageView * imgView=[UIImageView new];
    [_scrollView addSubview:imgView];
    imgView.layer.cornerRadius=5*self.scale;
    imgView.layer.masksToBounds=YES;
    imgView.layer.borderColor=blackLineColore.CGColor;
    imgView.layer.borderWidth=0.5;
    [imgView setImageWithURL:[NSURL URLWithString:[ImgDuanKou stringByAppendingString:[NSString stringWithFormat:@"%@",_dataDic[@"P_Logo"]]]] placeholderImage:[UIImage imageNamed:@"beijing_tu"]];
    [_scrollView addSubview:imgView];
    imgView.frame=CGRectMake(10*self.scale, line1.top+10*self.scale, 90*self.scale, 90*self.scale);
    
    
     UILabel * labelName=[UILabel new];
    [_scrollView addSubview:labelName];
    labelName.numberOfLines=1;
    labelName.font=SmallFont(self.scale);
    labelName.textColor=blackTextColor;
    [_scrollView addSubview:labelName];
    labelName.frame=CGRectMake(imgView.right+10*self.scale, imgView.top, Vwidth-30*self.scale-imgView.width, 20*self.scale) ;
    labelName.text=[NSString stringWithFormat:@"名称:%@",_dataDic[@"P_name"]];
    
    UILabel * labelPrice=[UILabel new];
    [_scrollView addSubview:labelPrice];
    labelPrice.numberOfLines=1;
    labelPrice.textColor=blackTextColor;
    labelPrice.font=SmallFont(self.scale);
    [_scrollView addSubview:labelPrice];
    labelPrice.frame=labelName.frame;
    labelPrice.font=Big15Font(self.scale);
    labelPrice.textColor=lightOrangeColor;
    labelPrice.centerY=imgView.centerY;
//    labelPrice.text=[NSString stringWithFormat:@"现价:￥%@ 原价:￥%@",_dataDic[@"P_NewPrice"],_dataDic[@"P_OldPrice"]];
    NSString * xian=[NSString stringWithFormat:@"￥%@  ",_dataDic[@"P_NewPrice"]];
    NSString * yuan=[NSString stringWithFormat:@"原价￥%@",_dataDic[@"P_OldPrice"]];
    NSMutableAttributedString * att=[[NSMutableAttributedString alloc]initWithString:xian];
    [att appendAttributedString:[yuan getDeleteLineText]];
    labelPrice.attributedText=att;
    
    
    
    UILabel * labelStandard=[UILabel new];
    [_scrollView addSubview:labelStandard];
    labelStandard.numberOfLines=1;
    labelStandard.textColor=blackTextColor;
    labelStandard.font=SmallFont(self.scale);
    [_scrollView addSubview:labelStandard];
    labelStandard.frame=labelName.frame;
    labelStandard.bottom=imgView.bottom;
        labelStandard.text=[NSString stringWithFormat:@"规格:%@",_dataDic[@"P_GuiGe"]];
    
    UIView * line2=[[UIView alloc]initWithFrame:CGRectMake(0, imgView.bottom+10*self.scale, Vwidth, 0.5*self.scale)];
    [_scrollView addSubview:line2];
    line2.backgroundColor=blackLineColore;
    
    UILabel * labelContent=[[UILabel alloc]initWithFrame:CGRectMake(10*self.scale, line2.top+10*self.scale, Vwidth- 20*self.scale, 100*self.scale)];
    [_scrollView addSubview:labelContent];
    labelContent.numberOfLines=0;
    labelContent.textColor=blackTextColor;
    labelContent.font=SmallFont(self.scale);
    labelContent.text=[NSString stringWithFormat:@"用户 %@ 反馈:%@",_dataDic[@"linkman"],_dataDic[@"reson"]];
    [labelContent sizeToFit];
    NSString * yongHuLoca=@"用户 ";
    NSString * yongHuLen=_dataDic[@"linkman"];
    
    NSMutableAttributedString * attri=[[NSMutableAttributedString alloc]initWithString:labelContent.text];
    [attri addAttribute:NSForegroundColorAttributeName value:navigationControllerColor range:NSMakeRange(yongHuLoca.length, yongHuLen.length)];
    labelContent.attributedText=attri;
    
    UIView * line3=[[UIView alloc]initWithFrame:CGRectMake(0, labelContent.bottom+10*self.scale, Vwidth, 0.5*self.scale)];
    [_scrollView addSubview:line3];
    line3.backgroundColor=blackLineColore;
    
    int column=3;
    CGFloat marginX=10*self.scale;
    CGFloat spX=20*self.scale;
    CGFloat spY=20*self.scale;
    CGFloat btnW=(Vwidth-marginX*2-(column-1)*spX)/column;
    CGFloat btnH=btnW*0.66;
    
    CGFloat setY=line3.top+10*self.scale;
    for (int i =0; i < _imgs.count; i ++) {
        CGFloat btnX= i % column*(spX+btnW) +marginX;
        CGFloat btnY= i / column*(spY+btnH) +10*self.scale+line3.top;
        UIImageView * img= [[ UIImageView alloc]initWithFrame:CGRectMake(btnX , btnY, btnW , btnH)];
        [_scrollView addSubview:img];
        [img setImageWithURL:[NSURL URLWithString:[ImgDuanKou stringByAppendingString:_imgs[i]]] placeholderImage:[UIImage imageNamed:@"beijing_tu"]];
        setY=img.bottom;
    }

    UIView * line4 = [[UIView alloc]initWithFrame:CGRectMake(0, setY+10*self.scale, Vwidth, 0.5*self.scale)];
    line4.backgroundColor=blackLineColore;
    [_scrollView addSubview:line4];
    
    UILabel * labelContack=[[UILabel alloc]initWithFrame:CGRectMake(10*self.scale, line4.top+10*self.scale, Vwidth, 20*self.scale)];
    labelContack.font=DefaultFont(self.scale);
    labelContack.textColor=blackTextColor;
    [_scrollView addSubview:labelContack];
    labelContack.text=[NSString stringWithFormat:@"联系人:%@",_dataDic[@"linkman"]];
    
    UILabel * labelTel=[[UILabel alloc]initWithFrame:labelContack.frame];
    labelTel.right=Vwidth-10*self.scale;
    labelTel.textAlignment=NSTextAlignmentRight;
    labelTel.font=DefaultFont(self.scale);
    labelTel.textColor=blackTextColor;
    [_scrollView addSubview:labelTel];
    labelTel.text=[NSString stringWithFormat:@"联系电话:%@",_dataDic[@"tel"]];
    setY=labelTel.bottom+10*self.scale;
    bgView.size=CGSizeMake(Vwidth, setY);
      _scrollView.contentSize=CGSizeMake(Vwidth, setY);
    
//        CGFloat eY=setY;
    if (!_bottomView) {
         _bottomView=[[UIView alloc]initWithFrame:CGRectMake(0, Vheight-40*self.scale, Vwidth, 40*self.scale)];
        [self.view addSubview:_bottomView];
    }
    [_bottomView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
  
        NSArray * btnTitles=@[@"上级代理审核",@"生产厂家审核",@"审核结束"];
        for (int i = 0; i < btnTitles.count; i ++) {
            UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100,_bottomView.height)];
            [_bottomView addSubview:btn];
            btn.titleLabel.font=DefaultFont(self.scale);
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btn setTitle:btnTitles[i] forState:UIControlStateNormal];
            setY = btn.bottom;
            switch (i) {
                case 0:
                {
                    btn.width=Vwidth*(3/7.0);
                    btn.left=0;
                    [btn setBackgroundImage:[UIImage ImageForColor:lightOrangeColor] forState:UIControlStateNormal];
    //                [btn setBackgroundImage:[UIImage ImageForColor:[UIColor blackColor]]];≥
                }
                    break;
                case 1:
                    btn.width=Vwidth*(2/7.0);
                    btn.left=Vwidth*(3/7.0);
                    [btn setBackgroundImage:[UIImage ImageForColor:navigationControllerColor] forState:UIControlStateNormal];
    
                    break;
                case 2:
                    btn.width=Vwidth*(2/7.0);
                    btn.right=Vwidth;
                    [btn setTitleColor:blackTextColor forState:UIControlStateNormal];
                    [btn setBackgroundImage:[UIImage ImageForColor:[UIColor whiteColor]] forState:UIControlStateNormal];
                    break;
    
                default:
                    break;
            }
    
            
        NSString * states=[NSString stringWithFormat:@"%@",_dataDic[@"states"]];
        btn.enabled=[states isEqualToString:[NSString stringWithFormat:@"%d",i]];
        [btn addTarget:self action:@selector(btnEvent:) forControlEvents:UIControlEventTouchUpInside];
//              setY =btn.bottom;
        }
}
-(void)btnEvent:(UIButton *)sender{
    NSString * states=[NSString stringWithFormat:@"%@",_dataDic[@"states"]];
    NSDictionary * dic=@{@"id":[Stockpile sharedStockpile].ID,
                         @"states":[NSString stringWithFormat:@"%d",[states integerValue]+1]};
    
    [self startAnimating:nil];
    [AnalyzeObject EVFeedBackWithDic:dic WithBlock:^(id model, NSString *ret, NSString *msg) {
        [self stopAnimating];
        if ([ret isEqualToString:@"1"]) {
            [self reshData];
        }else{
            [self showPromptBoxWithSting:msg];
        }
    }];
    
    
    
    

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
