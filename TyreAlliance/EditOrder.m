//
//  EditOrder.m
//  TyreAlliance
//
//  Created by wdx on 16/9/18.
//  Copyright © 2016年 wdx. All rights reserved.
//

#import "EditOrder.h"

@interface EditOrder ()
@property (nonatomic,strong)UIScrollView * scrollView;
@property (nonatomic,strong)UITextField * tfWlname;
@property (nonatomic,strong)UITextField * tfWlnum;

@end

@implementation EditOrder

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self newNavi];
    [self newView];
    
    // Do any additional setup after loading the view.
}
-(void)newNavi{
    self.TitleLabel.text=@"填写订单";
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
    _datas=[NSArray array];
    _datas=_dataDic[@"eary"];
    
}
-(void)newView{
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom+10*self.scale, Vwidth, Vheight-self.NavImg.height-10*self.scale)];
    _scrollView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:_scrollView];
    
    
    
    UILabel * labelConsignee = [UILabel new];
    labelConsignee.font=DefaultFont(self.scale);
    labelConsignee.textColor=blackTextColor;
    [_scrollView addSubview:labelConsignee];
    labelConsignee.frame=CGRectMake(20*self.scale, 10*self.scale, Vwidth/2 -10*self.scale, 20*self.scale);
    labelConsignee.text=[NSString stringWithFormat:@"收货人:%@",_dataDic[@"shouhuo_person"]];
    

   UILabel * labelNumber = [UILabel new];
    labelNumber.font=DefaultFont(self.scale);
    labelNumber.textColor=blackTextColor;
    labelNumber.textAlignment=NSTextAlignmentRight;
    [_scrollView addSubview:labelNumber];
    labelNumber.frame=CGRectMake(Vwidth/2, labelConsignee.top, Vwidth/2-10*self.scale, 20*self.scale);
    labelNumber.right=Vwidth-20*self.scale;
    labelNumber.text=[NSString stringWithFormat:@"电话：%@",_dataDic[@"shouhuo_tel"]];

    
    UIImageView * adImg=[[UIImageView alloc]initWithFrame:CGRectMake(10*self.scale, labelConsignee.bottom+5*self.scale, 20*self.scale, 20*self.scale)];
    [_scrollView addSubview:adImg];
    adImg.contentMode=UIViewContentModeCenter;
    adImg.image=[UIImage imageNamed:@"di_zhi"];
    
    UILabel * btnAddress = [UILabel new];
    btnAddress.font=DefaultFont(self.scale);
    btnAddress.textColor=blackTextColor;
    btnAddress.numberOfLines=0;
    [_scrollView addSubview:btnAddress];
    btnAddress.frame=CGRectMake(adImg.right, labelConsignee.bottom+5*self.scale, Vwidth-20*self.scale-adImg.width-10*self.scale, 40*self.scale);
    btnAddress.text=[NSString stringWithFormat:@" 收货地址:%@",_dataDic[@"address"]];
    labelConsignee.left=btnAddress.left;
    [btnAddress sizeToFit];
    
    CGFloat setY=0;
    for (int i = 0; i < _datas.count; i ++) {
        CellView * cellView=[[CellView alloc]initWithFrame:CGRectMake(0, i * 90*self.scale + btnAddress.bottom+10*self.scale, Vwidth, 90*self.scale)];
        [_scrollView addSubview:cellView];
        NSDictionary * dic=_datas[i];
        cellView.topline.hidden=NO;
        
        
        UIImageView* imgView=[UIImageView new];
        imgView.layer.cornerRadius=5*self.scale;
        imgView.layer.masksToBounds=YES;
        imgView.layer.borderColor=blackLineColore.CGColor;
        imgView.layer.borderWidth=0.5;
        [cellView   addSubview:imgView];
        imgView.frame=CGRectMake(10*self.scale, 10*self.scale, 70*self.scale, 70*self.scale);
        [imgView setImageWithURL:[NSURL URLWithString:dic[@"plogo"]] placeholderImage:[UIImage imageNamed:@"luntai_tai"]];
        
        UILabel * labelIntro=[UILabel new];
        labelIntro.numberOfLines=2;
        labelIntro.font=Small10Font(self.scale);
        labelIntro.textColor=blackTextColor;
        [cellView addSubview:labelIntro];
        labelIntro.frame=CGRectMake(imgView.right+10*self.scale, imgView.top, Vwidth-30*self.scale-imgView.width, 30*self.scale);
        labelIntro.text=[NSString stringWithFormat:@"%@",dic[@"name"]];
        
        UILabel * labelPrice=[UILabel new];
        labelPrice.numberOfLines=1;
        labelPrice.textColor=lightOrangeColor;
        labelPrice.font=Big15Font(self.scale);
        [cellView addSubview:labelPrice];
        labelPrice.frame=CGRectMake(imgView.right+10*self.scale, labelIntro.bottom, labelIntro.width, 20*self.scale);
        NSString * xian=[NSString stringWithFormat:@"￥%@  ",dic[@"newprice"]];
        NSString * yuan=[NSString stringWithFormat:@"原价￥%@",dic[@"oldprice"]];
        NSMutableAttributedString * att=[[NSMutableAttributedString alloc]initWithString:xian];
        [att appendAttributedString:[yuan getDeleteLineText]];
        labelPrice.attributedText=att;
        
     
        
        UILabel * labelStandard=[UILabel new];
        labelStandard.numberOfLines=1;
        labelStandard.font=Small10Font(self.scale);
        labelStandard.textColor=blackTextColor;
        [cellView addSubview:labelStandard];
        labelStandard.frame=labelPrice.frame;
        labelStandard.bottom =imgView.bottom;
        labelStandard.text=[NSString stringWithFormat:@"规格：%@",dic[@"Guige"]];
        
        
        
        setY=cellView.bottom;
    }
    

    
    

    
   
    NSArray * titles=@[@{@"title":[NSString stringWithFormat:@"共%@件商品",_dataDic[@"count"]],@"place":@""},
                       @{@"title":@"发货物流",@"place":@"请输入您的物流名称"},
                       @{@"title":@"物流单号",@"place":@"请输入您的物流单号"},
                       @{@"title":@"取货时间",@"place":@"请输入您的取货时间"}];
//     CGFloat setYY=0;
    CGFloat Y=setY;
    
    for (int i =0; i < 4; i ++) {
        CellView * cellView = [[CellView alloc]initWithFrame:CGRectMake(0, Y+10*self.scale+i*40*self.scale, Vwidth, 40*self.scale)];
        [_scrollView addSubview:cellView];
        cellView.titleLabel.text=[titles[i]valueForKey:@"title"];
        
        if (i==0) {
            UILabel * labelPaid = [[UILabel alloc]initWithFrame:cellView.titleLabel.frame];
            labelPaid.font=DefaultFont(self.scale);
            labelPaid.textColor=blackTextColor;
            [cellView addSubview:labelPaid];
            labelPaid.text=[NSString stringWithFormat:@"实付:%@",[NSString stringWithFormat:@"%@",_dataDic[@"allprice"]]];
            [labelPaid sizeToFit];
             labelPaid.right=cellView.width-10*self.scale;
        }else{
            UITextField * tf=[[UITextField alloc]initWithFrame:CGRectMake(cellView.titleLabel.right+ 10*self.scale, 10*self.scale, 150*self.scale, 20*self.scale)];
            tf.font=DefaultFont(self.scale);
            tf.placeholder=[titles[i]valueForKey:@"place"];
            [cellView addSubview:tf];
            
            
            if (i==1) {
                _tfWlname=tf;
            }
            if (i==2) {
                _tfWlnum=tf;
            }
            
        }
        [cellView.titleLabel sizeToFit];
        
        setY=cellView.bottom;
    }
    
    if (setY<_scrollView.height-50*self.scale) {
        _scrollView.contentSize=CGSizeMake(Vwidth, _scrollView.height);
    }else{
        _scrollView.contentSize=CGSizeMake(Vwidth, setY+50*self.scale);
    }
  
    
    
    NSArray * btnTitles=@[@"确定",@"取消"];
    CGFloat bottonBtnH=40*self.scale;
    for (int i =0; i < 2;  i ++) {
        UIButton * btn=[[UIButton alloc]initWithFrame:CGRectMake(Vwidth/2 * i, Vheight-bottonBtnH, Vwidth/2, bottonBtnH)];
        btn.bottom=_scrollView.contentSize.height;
        
        [_scrollView addSubview:btn];
        [btn addTarget:self action:@selector(commitOrCancel:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:btnTitles[i] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage ImageForColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [btn setTitleColor:blueTextColor forState:UIControlStateNormal];
        btn.titleLabel.font=DefaultFont(self.scale);
        btn.tag=100+i;
        if (i==0) {
            [btn setBackgroundImage:[UIImage ImageForColor:lightOrangeColor] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }else{
            UIView * line=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Vwidth/2, 0.5*self.scale)];
            line.backgroundColor=blackLineColore;
            [btn addSubview:line];
            
        }
    }
    
    
}
-(void)commitOrCancel:(UIButton *)sender{
    if (sender.tag==101) {
    [self PopVC:nil];
    }else{
        NSDictionary * dic=@{@"ziid":[NSString stringWithFormat:@"%@",_dataDic[@"ziid"]],
                             @"wlname":[NSString stringWithFormat:@"%@",_tfWlname.text],
                             @"wlnum":[NSString stringWithFormat:@"%@",_tfWlnum.text]};
        [AnalyzeObject confirmDeliverGoodsWithDic:dic WithBlock:^(id model, NSString *ret, NSString *msg) {
           
            if ([ret isEqualToString:@"1"]) {
            
                
            }else{
                
            
            }
            [self ShowAlertWithMessage:msg];
//            [self showPromptBoxWithSting:msg];
        }];
        
        
        
        
    }
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
