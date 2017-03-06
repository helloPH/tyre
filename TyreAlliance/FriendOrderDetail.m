//
//  FriendOrderDetail.m
//  TyreAlliance
//
//  Created by wdx on 16/9/18.
//  Copyright © 2016年 wdx. All rights reserved.
//

#import "FriendOrderDetail.h"
#import "FriendOrderDetailCell.h"


@interface FriendOrderDetail ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)NSMutableDictionary * dataDic;
@property (nonatomic,strong)NSMutableArray * datas;
@property (nonatomic,assign)NSInteger yeIndex;

@property (nonatomic,assign)CGFloat allInCome;
@property (nonatomic,assign)CGFloat allMoney;

@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)UILabel * labelName;

@property (nonatomic,strong)UIView * bottomView;
@property (nonatomic,strong)UILabel * labelMoney;
@property (nonatomic,strong)UILabel * labelInCome;
//@property (nonatomic,strong)UILabel * label
@end

@implementation FriendOrderDetail

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self newNavi];
    [self newView];
    [self reshData];
    // Do any additional setup after loading the view.
}
-(void)newNavi{
    self.TitleLabel.text=@"好友订单详情";
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
    _allMoney=0;
    _allInCome=0;
    _dataDic=[NSMutableDictionary dictionary];
    _datas=[NSMutableArray array];
    _yeIndex=1;
    
}
-(void)reshView{
    [_tableView reloadData];
    _labelName.text=[NSString stringWithFormat:@"姓名:%@",_dataDic[@"name"]];
    
    NSMutableAttributedString * text11=[[NSMutableAttributedString alloc]initWithString:@"总额:"];
    NSMutableAttributedString * text12=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"￥%.2f",_allMoney]];
    [text12 addAttribute:NSForegroundColorAttributeName value:lightOrangeColor range:NSMakeRange(0, text12.length)];
    [text11 appendAttributedString:text12];
//    labelTotalMoney.attributedText=text11;
    _labelMoney.attributedText=text11;
    
    
    NSMutableAttributedString * text21=[[NSMutableAttributedString alloc]initWithString:@"总收益:"];
    NSMutableAttributedString * text22=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"￥%.2f",_allInCome]];
    [text22 addAttribute:NSForegroundColorAttributeName value:lightOrangeColor range:NSMakeRange(0, text22.length)];
    [text21 appendAttributedString:text22];
//    labelTotalIncome.attributedText=text21;
    _labelInCome.attributedText=text21;
}
-(void)reshData{
    [self startAnimating:nil];
    NSDictionary * dic=@{@"uid":[Stockpile sharedStockpile].ID,
                         @"dlid":_dlid,
                         @"type":_type,
                         @"ye":[NSString stringWithFormat:@"%ld",(long)_yeIndex]};
    
    


    [AnalyzeObject getrecomIncomeDetailWithDic:dic WithBlock:^(id model, NSString *ret, NSString *msg) {
        [self stopAnimating];
        [_tableView.mj_header endRefreshing];
  
        if ([ret isEqualToString:@"1"]) {
            if (_yeIndex==1) {
                [_datas removeAllObjects];
            }
            if (_dataDic) {
                [_dataDic removeAllObjects];
            }
            [_dataDic addEntriesFromDictionary:model];
            NSArray * datas=_dataDic[@"list"];
            [_datas addObjectsFromArray:datas];
            
            if (datas.count==0) {
                [self showPromptBoxWithSting:@"无更多数据!"];
                [_tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [_tableView.mj_footer endRefreshing];
            }
            if (_yeIndex==1) {
                _allInCome=[NSString stringWithFormat:@"%@",_dataDic[@"allMyself_many"]].floatValue;
                _allMoney=[NSString stringWithFormat:@"%@",_dataDic[@"allmany"]].floatValue;
            }else{
                _allInCome=[NSString stringWithFormat:@"%@",_dataDic[@"allMyself_many"]].floatValue+_allInCome;
                _allMoney=[NSString stringWithFormat:@"%@",_dataDic[@"allmany"]].floatValue+_allMoney;
            }
            
            
            [self reshView];
        }else{
            [self showPromptBoxWithSting:msg];
            [_tableView.mj_footer endRefreshing];
        }
    }];
    
}
-(void)newView{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom, Vwidth, Vheight-self.NavImg.height-50*self.scale)];
    [self.view addSubview:_tableView];
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor=superBackgroundColor;
//    _tableView.scrollEnabled=NO;
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [_tableView registerClass:[FriendOrderDetailCell class] forCellReuseIdentifier:@"cell"];
    
    [_tableView addHeardTarget:self Action:@selector(xiala)];
    [_tableView addFooterTarget:self Action:@selector(shangla)];
    _tableView.tableHeaderView=[self headView];
    
    
    
    
    UIView * view1=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Vwidth, 40*self.scale)];
    view1.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:view1];
    view1.bottom=Vheight;
    UIView * bottomLine=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Vwidth, 0.5*self.scale)];
    bottomLine.backgroundColor=blackLineColore;
    [view1 addSubview:bottomLine];
    
    _bottomView=view1;
    
    
    
    
    UILabel * labelMoney=[[UILabel alloc]initWithFrame:CGRectMake(10*self.scale, 10*self.scale, 100*self.scale, 20*self.scale)];
    [view1 addSubview:labelMoney];
    labelMoney.centerY=view1.height/2;
    labelMoney.font=DefaultFont(self.scale);
    labelMoney.textColor=blackTextColor;
    _labelMoney=labelMoney;
//    labelMoney.text=@"二级推荐人总数";
    
    UILabel * labelInCome=[[UILabel alloc]initWithFrame:labelMoney.frame];
    [view1 addSubview:labelInCome];
    labelInCome.centerX=Vwidth-70*self.scale;
    labelInCome.textAlignment=NSTextAlignmentCenter;
    labelInCome.font=DefaultFont(self.scale);
    labelInCome.textColor=blackTextColor;
    _labelInCome=labelInCome;
    
}
-(void)shangla{
    _yeIndex++;
    [self reshData];
}
-(void)xiala{
    _yeIndex=1;
    [self reshData];
}
-(UIView *)headView{
    UIView * headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Vwidth, 40*self.scale)];
    headView.backgroundColor=[UIColor whiteColor];
    
    UILabel * labelName=[[UILabel alloc]initWithFrame:CGRectMake(10*self.scale, 10*self.scale, Vwidth/2-10*self.scale, 20*self.scale)];
    labelName.font=DefaultFont(self.scale);
    labelName.textColor=blackTextColor;
    [headView addSubview:labelName];
    labelName.text=[NSString stringWithFormat:@"姓名:%@",_dataDic[@"name"]?_dataDic[@"name"]:@""];
    _labelName=labelName;
    if ([labelName.text isEmptyString]) {
        
    }

    
    UILabel * labelTime=[[UILabel alloc]initWithFrame:CGRectMake(0, 10*self.scale, Vwidth/2-10*self.scale, 20*self.scale)];
//    [headView addSubview:labelTime];
    labelTime.right=Vwidth-10*self.scale;
    labelTime.textAlignment=NSTextAlignmentRight;
    labelTime.font=DefaultFont(self.scale);
    labelTime.textColor=blackTextColor;
    labelTime.text=[NSString stringWithFormat:@"%@",_dataDic[@""]];
    
    return headView;
}

#pragma mark -- delegate dataSource

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50*self.scale;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Vwidth, 50*self.scale)];
    view.backgroundColor=[UIColor whiteColor];
    
    
    UIView * topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Vwidth, 10*self.scale)];
    topView.backgroundColor=superBackgroundColor;
    [view addSubview:topView];
    
    UILabel * labelTime = [[UILabel alloc]initWithFrame:CGRectMake(10*self.scale, topView.bottom+10*self.scale, Vwidth/4, 20*self.scale)];
    labelTime.centerX=Vwidth*(1/8.0);
    labelTime.textAlignment=NSTextAlignmentCenter;
    [view addSubview:labelTime];
    labelTime.font=DefaultFont(self.scale);
    labelTime.textColor=blackTextColor;
    labelTime.text=@"时间";

    UILabel * labelOrder=[[UILabel alloc]initWithFrame:labelTime.frame];
    labelOrder.centerX=Vwidth*(3/8.0);
    labelOrder.textAlignment=NSTextAlignmentCenter;
    [view addSubview:labelOrder];
    labelOrder.font=DefaultFont(self.scale);
    labelOrder.textColor=blackTextColor;
    labelOrder.text=@"订单号";
    
    UILabel * labelMoney=[[UILabel alloc]initWithFrame:labelTime.frame];
    labelMoney.centerX=Vwidth*(5/8.0);
    labelMoney.textAlignment=NSTextAlignmentCenter;
    [view addSubview:labelMoney];
    labelMoney.font=DefaultFont(self.scale);
    labelMoney.textColor=lightOrangeColor;
    labelMoney.text=@"金额";
    
    UILabel * labelIncome=[[UILabel alloc]initWithFrame:labelTime.frame];
    labelIncome.centerX=Vwidth*(7/8.0);
    labelIncome.textAlignment=NSTextAlignmentCenter;
    [view addSubview:labelIncome];
    labelIncome.font=DefaultFont(self.scale);
    labelIncome.textColor=lightOrangeColor;
    labelIncome.text=@"可得收益";
    
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.00001*self.scale;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Vwidth, 50*self.scale)];
    view.backgroundColor=[UIColor whiteColor];
    
    
    UIView * topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Vwidth, 10*self.scale)];
    topView.backgroundColor=superBackgroundColor;
    [view addSubview:topView];
    
    UILabel * labelTotalMoney = [[UILabel alloc]initWithFrame:CGRectMake(10*self.scale, topView.bottom+10*self.scale, (Vwidth-20*self.scale)/2, 20*self.scale)];
    [view addSubview:labelTotalMoney];
    labelTotalMoney.textAlignment=NSTextAlignmentLeft;
    labelTotalMoney.font=DefaultFont(self.scale);
    labelTotalMoney.textColor=blackTextColor;
//    labelTotalMoney.text=[NSString stringWithFormat:@"总额:￥%.2f",_allMoney];
    NSMutableAttributedString * text11=[[NSMutableAttributedString alloc]initWithString:@"总额:"];
    NSMutableAttributedString * text12=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"￥%.2f",_allMoney]];
    [text12 addAttribute:NSForegroundColorAttributeName value:lightOrangeColor range:NSMakeRange(0, text12.length)];
    [text11 appendAttributedString:text12];
    labelTotalMoney.attributedText=text11;
//    [labelTotalMoney sizeToFit];
    
    
    
    
    
    
    
    
    
    UILabel * labelTotalIncome=[[UILabel alloc]initWithFrame:labelTotalMoney.frame];
    labelTotalIncome.right=Vwidth-20*self.scale;
    labelTotalIncome.textAlignment=NSTextAlignmentRight;
    [view addSubview:labelTotalIncome];
    labelTotalIncome.font=DefaultFont(self.scale);
    labelTotalIncome.textColor=blackTextColor;
//    labelTotalIncome.text=[NSString stringWithFormat:@"总收益:￥%@",_dataDic[@"allMyself_many"]];
    NSMutableAttributedString * text21=[[NSMutableAttributedString alloc]initWithString:@"总收益:"];
    NSMutableAttributedString * text22=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"￥%.2f",_allInCome]];
    [text22 addAttribute:NSForegroundColorAttributeName value:lightOrangeColor range:NSMakeRange(0, text22.length)];
    [text21 appendAttributedString:text22];
    labelTotalIncome.attributedText=text21;
//    [labelTotalIncome sizeToFit];
    view=nil;
    return view;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _datas.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FriendOrderDetailCell * cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    NSDictionary * dic=_datas[indexPath.row];
    cell.labelTime.text=[NSString stringWithFormat:@"%@",dic[@"time"]];
    cell.labelOrder.text=[NSString stringWithFormat:@"%@",dic[@"order_id"]];
    cell.labelMoney.text=[NSString stringWithFormat:@"￥%@",dic[@"myMany"]];
    cell.labelIncome.text=[NSString stringWithFormat:@"￥%@",dic[@"many"]];
    
    return cell;
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
