//
//  WithDrawRecord.m
//  TyreAlliance
//
//  Created by wdx on 16/9/20.
//  Copyright © 2016年 wdx. All rights reserved.
//

#import "WithDrawRecord.h"
#import "WithDrawRecordCell.h"

@interface WithDrawRecord ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,assign)NSInteger yeIndex;
@property (nonatomic,strong)NSMutableArray * datas;
@property (nonatomic,strong)UITableView * tableView;

@end

@implementation WithDrawRecord

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self newNavi];
    [self newView];
    [self reshData];
    // Do any additional setup after loading the view.
}
-(void)newNavi{
    self.TitleLabel.text=@"提现记录";
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
    _yeIndex=1;
    _datas=[NSMutableArray array];
    
}
-(void)reshData{
    [self startAnimating:nil];
    NSString * states=_recordType==RecordTypeVerifing?@"0":@"1";
    
    NSDictionary * dic=@{@"uid":[Stockpile sharedStockpile].ID,
                         @"states":states,
                         @"ye":[NSString stringWithFormat:@"%d",_yeIndex]};
    [AnalyzeObject getWithDrawRecordWithDic:dic WithBlock:^(id model, NSString *ret, NSString *msg) {
        [self stopAnimating];
        [_tableView.mj_header endRefreshing];

        if (_yeIndex==1) {
            [_datas removeAllObjects];
        }
        if ([ret isEqualToString:@"1"]) {
            [_datas addObjectsFromArray:model];
            if ([model count]==0) {
                [_tableView.mj_footer endRefreshingWithNoMoreData];
                [self showPromptBoxWithSting:@"没有更多数据!"];
            }else{
                [_tableView.mj_footer endRefreshing];
                [self showPromptBoxWithSting:msg];
            }

        }else{
            [_tableView.mj_footer endRefreshing];
            [self showPromptBoxWithSting:msg];
        }
        [_tableView reloadData];
    }];
    
    
}

-(void)newView{
    UIView * headView=[[UIView alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom, Vwidth, 60*self.scale)];
    [self.view addSubview:headView];
    headView.backgroundColor=[UIColor whiteColor];
    
    
    NSArray * titles=@[@"审核中",@"已审核"];
    for (int i = 0 ; i < 2 ; i ++) {
        UIButton * btn=[[UIButton alloc]initWithFrame:CGRectMake(i * Vwidth/2, 0, Vwidth/2, headView.height)];
        btn.titleLabel.font=DefaultFont(self.scale);
        [btn setTitleColor:blackTextColor forState:UIControlStateNormal];
        [btn setTitleColor:navigationControllerColor forState:UIControlStateSelected];
        [btn setTitleColor:navigationControllerColor  forState:UIControlStateSelected];
        
        btn.tag=100+i;
        if (i==1) {
            UIView * line=[[UIView alloc]initWithFrame:CGRectMake(0, 5*self.scale, 0.5*self.scale, headView.height-10*self.scale)];
            line.backgroundColor=blackLineColore;
            [btn addSubview:line];
        }else{
            btn.selected=YES;
        }
        
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnEvent:) forControlEvents:UIControlEventTouchUpInside];
        
        
        [headView addSubview:btn];
    }
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom+10*self.scale+headView.height, Vwidth, Vheight-self.NavImg.height-headView.height-10*self.scale) style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [_tableView addHeardTarget:self Action:@selector(xiala)];
    [_tableView addFooterTarget:self Action:@selector(shangla)];
    
    [_tableView registerClass:[WithDrawRecordCell class] forCellReuseIdentifier:@"cell"];
}
-(void)shangla{
    _yeIndex++;
    [self reshData];
}
-(void)xiala{
    _yeIndex=1;
    [self reshData];
}
-(void)btnEvent:(UIButton*)sender{
    for (UIButton* btn in sender.superview.subviews) {
        if ([btn isKindOfClass:[UIButton class]]) {
            btn.selected=NO;
        }
    }
    sender.selected=YES;
    _recordType=sender.tag-100;
    _yeIndex=1;
    [self reshData];

}
#pragma  mark -- delegate dataSource
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40*self.scale;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Vwidth, 40*self.scale)];
    view.backgroundColor=[UIColor whiteColor];
    
    
    UILabel * labelTime = [[UILabel alloc]initWithFrame:CGRectMake(10*self.scale, 10*self.scale, 60*self.scale, 20*self.scale)];
    [view addSubview:labelTime];
    labelTime.font=DefaultFont(self.scale);
    labelTime.textColor=blackTextColor;
    labelTime.text=@"时间";
    
    UILabel * labelOrder=[[UILabel alloc]initWithFrame:labelTime.frame];
    labelOrder.centerX=Vwidth/2-50*self.scale;
    labelOrder.textAlignment=NSTextAlignmentCenter;
    [view addSubview:labelOrder];
    labelOrder.font=DefaultFont(self.scale);
    labelOrder.textColor=blackTextColor;
    labelOrder.text=@"提现金额";
    
    UILabel * labelMoney=[[UILabel alloc]initWithFrame:labelTime.frame];
    labelMoney.left=Vwidth/2+20*self.scale;
    labelMoney.textAlignment=NSTextAlignmentLeft;
    [view addSubview:labelMoney];
    labelMoney.font=DefaultFont(self.scale);
    labelMoney.textColor=blackTextColor;
    labelMoney.text=@"状态";
    
    UILabel * labelIncome=[[UILabel alloc]initWithFrame:labelTime.frame];
    labelIncome.centerX=Vwidth-50*self.scale;
    labelIncome.textAlignment=NSTextAlignmentCenter;
    [view addSubview:labelIncome];
    labelIncome.font=DefaultFont(self.scale);
    labelIncome.textColor=blackTextColor;
    labelIncome.text=@"到账时间";
    
    return view;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _datas.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WithDrawRecordCell * cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    NSDictionary * dic=_datas[indexPath.row];
    
    cell.labelTime.text=[NSString stringWithFormat:@"%@",dic[@"ShengQing_date"]];
    cell.labelMoney.text=[NSString stringWithFormat:@"%@",dic[@"money"]];
    cell.labelStaus.text=[[NSString stringWithFormat:@"%@",dic[@"states"]] isEqualToString:@"0"]?@"审核中":@"审核完成";
    cell.labelIncomeTime.text=[NSString stringWithFormat:@"%@",dic[@"DaZhangDate"]];

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
