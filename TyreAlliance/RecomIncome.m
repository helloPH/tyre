//
//  RecomIncome.m
//  TyreAlliance
//
//  Created by wdx on 16/9/18.
//  Copyright © 2016年 wdx. All rights reserved.
//

#import "RecomIncome.h"
#import "RecomIncomeCell.h"
#import "FriendOrderDetail.h"

@interface RecomIncome ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,assign)NSInteger yeIndex;
@property (nonatomic,strong)NSMutableArray * datas;

@property (nonatomic,strong)UITableView * tableView;
@end

@implementation RecomIncome

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self newNavi];
    [self newView];
    [self reshData];
    
    
    // Do any additional setup after loading the view.
}
-(void)newNavi{
    self.TitleLabel.text=@"我推荐的人";
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
    _contentType=ContentTypeLevel1;
    _datas=[NSMutableArray array];
}
-(void)reshData{
    [self startAnimating:nil];

    if (_yeIndex==1) {
        [_datas removeAllObjects];
    }
    
    
    
    
    NSString * type=_contentType==ContentTypeLevel1?@"1":@"2";
    
    NSDictionary * dic=@{@"uid":[Stockpile sharedStockpile].ID,
                         @"type":type,
                         @"ye":[NSString stringWithFormat:@"%d",_yeIndex]};
    [AnalyzeObject getrecomIncomeWithDic:dic WithBlock:^(id model, NSString *ret, NSString *msg) {
        [self stopAnimating];
        [_tableView.mj_header endRefreshing];
//        [_tableView.mj_footer endRefreshing];
        if ([ret isEqualToString:@"1"]) {
            if ([model count]==0) {
                [_tableView.mj_footer endRefreshingWithNoMoreData];
                [self showPromptBoxWithSting:@"没有更多数据!"];
            }else{
                [_tableView.mj_footer endRefreshing];
            }
            [_datas addObjectsFromArray:model];
        }else{
            if ([msg isEqualToString:@"无更多数据！"]) {
                [_tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [_tableView.mj_footer endRefreshing];
            }
         
            [self showPromptBoxWithSting:msg];
        }
          [_tableView reloadData];
    }];
    
    
}
-(void)newView{
    UIView * selectedView = [[UIView alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom, Vwidth, 80*self.scale)];
    selectedView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:selectedView];
    NSArray * titles=@[@{@"title":@"一级推荐人",@"img":@"yiji_tuijianren"},@{@"title":@"二级推荐人",@"img":@"erji_tuijianren"}];
    
    
    
    for (int i = 0; i < 2; i ++) {
        UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(i * Vwidth/2, 0, Vwidth/2, selectedView.height)];
        [selectedView addSubview:btn];
        btn.tag=101+i;
        [btn addTarget:self action:@selector(selectBtn:) forControlEvents:UIControlEventTouchUpInside];
        if (i!=0) {
            UIView * segment = [[UIView alloc]initWithFrame:CGRectMake(0, 5*self.scale, 0.5*self.scale, selectedView.height-10*self.scale)];
            segment.backgroundColor=blackLineColore;
            [btn addSubview:segment];
        }
        if (_contentType==ContentTypeLevel1 && i==0) {
            btn.selected=YES;
        }
        if (_contentType==ContentTypeLevel2 && i==1) {
            btn.selected=YES;
        }
        
        UIImageView * imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 10*self.scale, btn.height-40*self.scale, btn.height-40*self.scale)];
        imgView.image=[UIImage imageNamed:[titles[i] valueForKey:@"img"]];
        [btn addSubview:imgView];
        imgView.centerX=btn.width/2;
        
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, imgView.bottom, 80*self.scale, 20*self.scale)];
        label.font=SmallFont(self.scale);
        label.textColor=blackTextColor;
        label.textAlignment=NSTextAlignmentCenter;
        [btn addSubview:label];
        label.text=[titles[i]valueForKey:@"title"];
        label.centerX=imgView.centerX;
        
        if (_contentType==ContentTypeLevel1 && i==0) {
            label.textColor=navigationControllerColor;
            btn.selected=YES;
        }
        if (_contentType==ContentTypeLevel2 && i==1) {
            label.textColor=navigationControllerColor;
            btn.selected=YES;
        }
        
    }
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, selectedView.bottom+10*self.scale, Vwidth, Vheight-self.NavImg.height-selectedView.height-10*self.scale)];
    _tableView.backgroundColor=superBackgroundColor;
    [self.view addSubview:_tableView];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[RecomIncomeCell class] forCellReuseIdentifier:@"cell"];

    [_tableView addHeardTarget:self Action:@selector(xiala)];
    [_tableView addFooterTarget:self Action:@selector(shangla)];
    
}
-(void)xiala{
    _yeIndex=1;
    [self reshData];
}
-(void)shangla{
    _yeIndex++;
    [self reshData];
}
-(void)selectBtn:(UIButton*)sender{
    _contentType=sender.tag-100;
    _yeIndex=1;
    [self reshData];
    sender.selected=!sender.selected;
    for (UIButton * btn in sender.superview.subviews) {
        for (UILabel * label in btn.subviews) {
            if ([label isKindOfClass:[UILabel class]]) {
                if (btn.tag==sender.tag) {
                    label.textColor=navigationControllerColor;
                }else{
                    label.textColor=blackTextColor;
                }
            }
        }
    }
}

#pragma  mark -- delegate datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _datas.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40*self.scale;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RecomIncomeCell * cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    NSDictionary *dic=_datas[indexPath.row];
    cell.labelRecomMan.text=[NSString stringWithFormat:@"推荐人:%@",dic[@"name"]];
    cell.labelIncome.text=[NSString stringWithFormat:@"收益:%@",dic[@"many"]];
    cell.labelTime.text=[NSString stringWithFormat:@"%@",dic[@"time"]];
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    FriendOrderDetail * detail  = [FriendOrderDetail new];
    detail.dlid=[NSString stringWithFormat:@"%@",[_datas[indexPath.row] valueForKey:@"uid"]];
    detail.type=_contentType==ContentTypeLevel1?@"1":@"2";
    [self.navigationController pushViewController:detail animated:YES];
    
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
