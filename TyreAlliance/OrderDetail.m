//
//  OrderDetail.m
//  TyreAlliance
//
//  Created by wdx on 16/9/26.
//  Copyright © 2016年 wdx. All rights reserved.
//

#import "OrderDetail.h"

@interface OrderDetail ()
@property (nonatomic,strong)UIScrollView * scrollView;
@property (nonatomic,strong)NSMutableDictionary * dataDic;
@property (nonatomic,strong)NSMutableArray * datas;
@end

@implementation OrderDetail

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self newNavi];
    [self reshData];
//    [self newView];
    // Do any additional setup after loading the view.
}
-(void)newNavi{
    self.TitleLabel.text=@"订单详情";
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
    _datas=[NSMutableArray array];
    
}
-(void)reshData{

    if (_dataDic) {
        [_dataDic removeAllObjects];
    }
    if (_datas) {
        [_datas removeAllObjects];
    }
    [self startAnimating:nil];
    
    if (_orderType==0 || _orderType==1) {
            _ziid=@"50000000";
        NSDictionary * dic=@{@"ziid":_ziid};
        [AnalyzeObject get1OrderDetailWithDic:dic WithBlock:^(id model, NSString *ret, NSString *msg) {
            [self stopAnimating];
            if ([ret isEqualToString:@"1"]) {
                [_dataDic addEntriesFromDictionary:model];
                [_datas addObjectsFromArray:(NSArray *)(_dataDic[@"plist"])];
                [self newView];
            }else{
                [self showPromptBoxWithSting:msg];
            }
        }];
    }
    
    else {
          _ziid=@"1";
        NSDictionary * dic =@{@"zipid":_ziid};
        [AnalyzeObject get2OrderDetailWithDic:dic WithBlock:^(id model, NSString *ret, NSString *msg) {
            [self stopAnimating];
            if ([ret isEqualToString:@"1"]) {
                [_dataDic addEntriesFromDictionary:model];
                [_datas addObjectsFromArray:(NSArray *)(_dataDic[@"plist"])];
                [self newView];
            }else{
                [self showPromptBoxWithSting:msg];
            }
        }];
    }
    



    

    
}
-(void)newView{
    _scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom, Vwidth, Vheight-self.NavImg.height)];
    _scrollView.backgroundColor=superBackgroundColor;
    [self.view addSubview:_scrollView];
    
    CGFloat setY=0;
    
    for (int i = 0 ; i < 2; i ++) {
        CellView * cellView = [[CellView alloc]initWithFrame:CGRectMake(0, i * 40*self.scale, Vwidth, 40*self.scale)];
        [_scrollView addSubview:cellView];
        if (i==0) {
            UILabel * labelStates=[[UILabel alloc]initWithFrame:CGRectMake(10*self.scale, 10*self.scale, Vwidth/2-10*self.scale, 20*self.scale)];
            labelStates.font=DefaultFont(self.scale);
            labelStates.textColor=blackTextColor;
            labelStates.textAlignment=NSTextAlignmentLeft;
            [cellView addSubview:labelStates];
            labelStates.text=[NSString stringWithFormat:@"订单状态:%@",_dataDic[@"states"]];
        
       
            
            UILabel * orderNum=[[UILabel alloc]initWithFrame:CGRectMake(10*self.scale, 10*self.scale, Vwidth/2-10*self.scale, 20*self.scale)];
            orderNum.font=DefaultFont(self.scale);
            orderNum.textColor=blackTextColor;
            orderNum.right=Vwidth-10*self.scale;
            orderNum.textAlignment=NSTextAlignmentLeft;
            [cellView addSubview:orderNum];
            orderNum.text=[NSString stringWithFormat:@"订单号:%@",_dataDic[@"oid"]];
    
     
        }else{
            
            UILabel * wellCome=[[UILabel alloc]initWithFrame:CGRectMake(10*self.scale, 10*self.scale, Vwidth/2-10*self.scale, 20*self.scale)];
            wellCome.font=DefaultFont(self.scale);
            wellCome.textColor=blackTextColor;
            [cellView addSubview:wellCome];
            wellCome.text=[NSString stringWithFormat:@"感谢您在%@购物，欢迎再次光临!",@"胎联盟"];
    
            [wellCome sizeToFit];
        }
        setY=cellView.bottom;
    }
    
    if (_orderType==3) {
        UIImageView * roundImg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 55*self.scale, 55*self.scale)];
        roundImg.image=[UIImage imageNamed:@"wan_cheng"];
        roundImg.bottom=setY;
        roundImg.right=Vwidth-10*self.scale;
        roundImg.contentMode=UIViewContentModeCenter;
        [_scrollView addSubview:roundImg];
    }

    
    
   //第二部分界面
    
    UIView * scordView = [[UIView alloc]initWithFrame:CGRectMake(0, setY+10*self.scale
                                                                   , Vwidth, 50*self.scale)];
  
    scordView.backgroundColor=[UIColor whiteColor];
    [_scrollView addSubview:scordView];
    UIImageView * contactImg=[[UIImageView alloc]initWithFrame:CGRectMake(10*self.scale, 10*self.scale, 20*self.scale, 20*self.scale)];
    contactImg.image=[UIImage imageNamed:@"person"];
    contactImg.contentMode=UIViewContentModeCenter;
    [scordView addSubview:contactImg];
    UILabel * labelContact=[[UILabel alloc]initWithFrame:CGRectMake(contactImg.right+5*self.scale, contactImg.top, 100*self.scale, 15*self.scale)];
    labelContact.centerY=contactImg.centerY;
    labelContact.font=DefaultFont(self.scale);
    labelContact.textColor=blackTextColor;
    [scordView addSubview:labelContact];
    labelContact.text=[NSString stringWithFormat:@"收货人:%@",_dataDic[@"person"]];
    [labelContact sizeToFit];
    

    UILabel * labelTel=[[UILabel alloc]initWithFrame:CGRectMake(0, 10*self.scale, 100*self.scale, 15*self.scale)];
    [scordView addSubview:labelTel];
    labelTel.centerY=contactImg.centerY;
    labelTel.text=[NSString stringWithFormat:@"电话:%@",_dataDic[@"tel"]];
    labelTel.font=DefaultFont(self.scale);
    labelTel.textColor=blackTextColor;
    [labelTel sizeToFit];
    labelTel.right=Vwidth-10*self.scale;
    labelTel.textAlignment=NSTextAlignmentRight;
    UIImageView * imgTel=[[UIImageView alloc]initWithFrame:CGRectMake(0, 10*self.scale, 20*self.scale, 20*self.scale)];
    [scordView addSubview:imgTel];
    imgTel.centerY=contactImg.centerY;
    imgTel.image=[UIImage imageNamed:@"phone_dian"];
    imgTel.contentMode=UIViewContentModeCenter;
    imgTel.right=labelTel.left-5*self.scale;
    
    UILabel * labelAddress=[[UILabel alloc]initWithFrame:CGRectMake(labelContact.left, contactImg.bottom+10*self.scale, Vwidth-40*self.scale, 30*self.scale)];
    [scordView addSubview:labelAddress];
    labelAddress.font=DefaultFont(self.scale);
    labelAddress.textColor=blackTextColor;
    labelAddress.numberOfLines=2;
    labelAddress.text=[NSString stringWithFormat:@"收货地址:%@",_dataDic[@"address"]];
    [labelAddress sizeToFit];
    setY=labelAddress.bottom;
    
    UIImageView * imgSep=[[UIImageView alloc]initWithFrame:CGRectMake(0, setY+10*self.scale, Vwidth, 10*self.scale)];
    [scordView addSubview:imgSep];
    imgSep.image=[UIImage imageNamed:@"youfeng_line"];
    scordView.height=imgSep.bottom;
    
    setY=scordView.bottom+10*self.scale;
    
    //
    
    for (int i = 0; i < _datas.count; i ++) {
        CellView * cellView=[[CellView alloc]initWithFrame:CGRectMake(0, setY, Vwidth, 90*self.scale)];
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
        
        NSString * imgS=[ImgDuanKou stringByAppendingString:[NSString stringWithFormat:@"%@",dic[@"logo"]]];
        [imgView setImageWithURL:[NSURL URLWithString:imgS] placeholderImage:[UIImage imageNamed:@"beijing_tu"]];
        
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
        labelPrice.font=DefaultFont(self.scale);
        [cellView addSubview:labelPrice];
        labelPrice.frame=CGRectMake(imgView.right+10*self.scale, labelIntro.bottom, labelIntro.width, 20*self.scale);
//        labelPrice.text=[NSString stringWithFormat:@"￥%@",dic[@"newprice"]];
        
        if (_orderType==0||_orderType==1) {
            NSString * xian=[NSString stringWithFormat:@"￥%@  ",dic[@"newprice"]];
            NSString * yuan=[NSString stringWithFormat:@"原价￥%@",dic[@"oldprice"]];
            NSMutableAttributedString * att=[[NSMutableAttributedString alloc]initWithString:xian];
            [att appendAttributedString:[yuan getDeleteLineText]];
            labelPrice.attributedText=att;
        }else{
            labelPrice.text=[NSString stringWithFormat:@"￥%@ ",dic[@"price"]];
        }
        
 
        
        UILabel * labelCount=[[UILabel alloc]initWithFrame:labelPrice.frame];
        labelCount.numberOfLines=1;
        labelCount.textColor=lightOrangeColor;
        labelCount.font=DefaultFont(self.scale);
        [cellView addSubview:labelCount];
        labelCount.right=Vwidth-10*self.scale;
        labelCount.textAlignment=NSTextAlignmentRight;
        labelCount.text=[NSString stringWithFormat:@"×%@",dic[@"count"]];
        
        
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
    NSArray *         bottonTitles=@[@{@"title":@"付款时间:",@"content":[NSString stringWithFormat:@"%@",_dataDic[@"paydate"]]},
                                     @{@"title":@"下单时间:",@"content":[NSString stringWithFormat:@"%@",_dataDic[@"xiadandate"]]},
                                     @{@"title":@"发货时间:",@"content":[NSString stringWithFormat:@"%@",_dataDic[@"fahuo_date"]]},
                                     @{@"title":@"收货时间:",@"content":[NSString stringWithFormat:@"%@",_dataDic[@"shouhuo_date"]]},
                                     @{@"title":@"支付方式",@"content":[NSString stringWithFormat:@"%@",_dataDic[@"pay_fangshi"]]},
                                     @{@"title":@"配送方式",@"content":[NSString stringWithFormat:@"%@",_dataDic[@"wu_liu_name"]]},
                                     @{@"title":@"运单号",@"content":[NSString stringWithFormat:@"￥%@",_dataDic[@"wu_liu_num"]]},
                                     @{@"title":@"合计:",@"content":[NSString stringWithFormat:@"￥%@",_dataDic[@"allprice"]]},
                                     ];
    
    if (_orderType==0 || _orderType==1) {
        bottonTitles=@[@{@"title":@"付款时间:",@"content":[NSString stringWithFormat:@"%@",_dataDic[@"paydate"]]},
                       @{@"title":@"下单时间:",@"content":[NSString stringWithFormat:@"%@",_dataDic[@"xiadandate"]]},
                       @{@"title":@"发货时间:",@"content":[NSString stringWithFormat:@"%@",_dataDic[@"fahuo_date"]]},
                       @{@"title":@"收货时间:",@"content":[NSString stringWithFormat:@"%@",_dataDic[@"shouhuo_date"]]},
                       @{@"title":@"合计:",@"content":[NSString stringWithFormat:@"￥%@",_dataDic[@"allprice"]]},
                       ];

    }
    
    setY=setY+10*self.scale;
    for (int i =0 ; i < bottonTitles.count; i ++) {
        CellView * cellView  =[[CellView alloc]initWithFrame:CGRectMake(0, setY, Vwidth, 35*self.scale)];
        cellView.backgroundColor=[UIColor whiteColor];
        [_scrollView addSubview:cellView];
        cellView.titleLabel.text=[NSString stringWithFormat:@"%@",[bottonTitles[i] valueForKey:@"title"]];
        
        
        UILabel * label=[[UILabel alloc]initWithFrame:cellView.titleLabel.frame];
        label.textColor=grayTextColor;
        label.textAlignment=NSTextAlignmentRight;
        label.width=Vwidth/2;
        label.right=Vwidth-10*self.scale;
        label.font=DefaultFont(self.scale);
        [cellView addSubview:label];
        label.text=[NSString stringWithFormat:@"%@",[bottonTitles[i] valueForKey:@"content"]];
        
        
        
        if (i==4 || i==5) {
            cellView.top+=10;
        }
        setY=cellView.bottom;
    }
//    CGFloat eY=setY;
//    NSArray * btnTitles=@[@"删除订单",@"再次购买",@"去评论"];
//    for (int i = 0; i < btnTitles.count; i ++) {
//        UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(0, eY+10*self.scale, 100, 30*self.scale)];
//        [_scrollView addSubview:btn];
//        btn.titleLabel.font=DefaultFont(self.scale);
//        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [btn setTitle:btnTitles[i] forState:UIControlStateNormal];
//        setY = btn.bottom;
//        switch (i) {
//            case 0:
//            {
//                btn.width=Vwidth*(3/7.0);
//                btn.left=0;
//                [btn setBackgroundImage:[UIImage ImageForColor:[UIColor blackColor]] forState:UIControlStateNormal];
////                [btn setBackgroundImage:[UIImage ImageForColor:[UIColor blackColor]]];≥
//            }
//                break;
//            case 1:
//                btn.width=Vwidth*(2/7.0);
//                btn.left=Vwidth*(3/7.0);
//                [btn setBackgroundImage:[UIImage ImageForColor:[UIColor yellowColor]] forState:UIControlStateNormal];
//                
//                break;
//            case 2:
//                btn.width=Vwidth*(2/7.0);
//                btn.right=Vwidth;
//                [btn setBackgroundImage:[UIImage ImageForColor:lightOrangeColor] forState:UIControlStateNormal];
//                break;
//
//            default:
//                break;
//        }
//          setY =btn.bottom;
//    }
    _scrollView.contentSize=CGSizeMake(Vwidth, setY);
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
