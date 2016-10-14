//
//  OrderManage.m
//  TyreAlliance
//
//  Created by wdx on 16/9/12.
//  Copyright © 2016年 wdx. All rights reserved.
//

#import "OrderManage.h"

#import "MyOrderHeadView.h"
#import "MyOrderCell.h"
#import "MyOrderFooterView.h"
#import "EditOrder.h"
#import "OrderDetail.h"

@interface OrderManage () <UITableViewDelegate,UITableViewDataSource,headerDelegate,footerDelegate>

@property (nonatomic,assign)NSInteger yeIndex;
@property (nonatomic,strong)NSString * currentStates;
@property (nonatomic,strong)NSMutableArray * datas;


@property (nonatomic,strong)UIView * headView;
@property (nonatomic,strong)UITableView * tableView;

@end

@implementation OrderManage

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self newNavi];
    [self newView];
    [self reshData];
    // Do any additional setup after loading the view.
}
-(void)newNavi{
    self.TitleLabel.text=@"订单管理";
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
    NSString * states;
    switch (_orderType) {
        case -1:
            states=@"-1";
            _currentStates=@"已取消";
            break;
        case 0:
            states=@"0";
            _currentStates=@"待付款";
            break;
        case 1:
             states=@"1";
            _currentStates=@"待发货";
            break;
        case 2:
             states=@"2";
            _currentStates=@"已发货";
            break;
        case 3:
             states=@"3";
            _currentStates=@"已完成";
            break;
        default:
            break;
    }
    
    NSDictionary * dic=@{@"uid":[Stockpile sharedStockpile].ID,
                         @"states":states,
                         @"ye":[NSString stringWithFormat:@"%d",_yeIndex]};
    [AnalyzeObject getOrderManageWithDic:dic WithBlock:^(id model, NSString *ret, NSString *msg) {
        [self stopAnimating];
        [_tableView.mj_header endRefreshing];
    
        if (_yeIndex==1) {
            [_datas removeAllObjects];
        }
        if ([ret isEqualToString:@"1"]) {
            [_datas addObjectsFromArray:model];
            if ([model count]==0) {
                [self showPromptBoxWithSting:@"没有更多内容!"];
                [_tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [self showPromptBoxWithSting:msg];
                [_tableView.mj_footer endRefreshing];
            }
            
        }else{
            [self showPromptBoxWithSting:msg];
            [_tableView.mj_footer endRefreshing];
        }
        [_tableView reloadData];
    }];
}
-(void)newView{
    
    _headView = [[UIView alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom, Vwidth, 35*self.scale)];
    _headView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:_headView];
    
    NSArray * headTitles=@[@"待付款",@"待发货",@"已发货",@"已完成",@"已取消"];
    
    for (int i = 0; i < headTitles.count; i ++) {
        UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(i * Vwidth/headTitles.count, 0, Vwidth/headTitles.count, _headView.height)];
        [_headView addSubview:btn];
        [btn addTarget:self action:@selector(btnEvent:) forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.font=DefaultFont(self.scale);
        
        [btn setTitleColor:blackTextColor forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [btn setBackgroundImage:[UIImage ImageForColor:lightOrangeColor] forState:UIControlStateSelected];
        [btn setBackgroundImage:[UIImage ImageForColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        btn.tag=100+i;
        [btn setTitle:headTitles[i] forState:UIControlStateNormal];
        if (i != 0) {
            UIImageView * imgLine=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 0.5*self.scale, btn.height)];
            imgLine.backgroundColor=blackLineColore;
            [btn addSubview:imgLine];
        }else{
            btn.selected=YES;
        }
    }
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, _headView.bottom+10*self.scale, Vwidth, Vheight-self.NavImg.height-_headView.height-10*self.scale) style:UITableViewStyleGrouped];
    _tableView.backgroundColor=superBackgroundColor;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[MyOrderHeadView class] forHeaderFooterViewReuseIdentifier:@"headView"];
    _tableView.estimatedSectionHeaderHeight=120*self.scale;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    [_tableView registerClass:[MyOrderCell class] forCellReuseIdentifier:@"cell"];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [self.view addSubview:_tableView];
    [_tableView addHeardTarget:self Action:@selector(xiala)];
    [_tableView addFooterTarget:self Action:@selector(shangla)];
    [_tableView.mj_footer endRefreshing];
    [_tableView registerClass:[MyOrderFooterView class] forHeaderFooterViewReuseIdentifier:@"footerView"];
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
    for (UIButton * btn in _headView.subviews) {
        if ([btn isKindOfClass:[UIButton class]]) {
            btn.selected=NO;
        }
    }
    sender.selected=YES;
    _orderType=sender.tag-100;
    if ((sender.tag-100) == 4) {
        _orderType=-1;
    }
    _yeIndex=1;
    [self reshData];
//    [_tableView reloadData];
    
    
}
#pragma  mark -- tableDelegate DataSource
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 120*self.scale;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSDictionary * dic=_datas[section];
    
    MyOrderHeadView * view=[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"headView"];
    view.section=section;
    view.delegate=self;
    view.labelOrderNum.text=[NSString stringWithFormat:@"订单号:%@",dic[@"ziid"]];
    
//    NSString * states=[NSString stringWithFormat:@"%@",dic[@"states"]];
    NSMutableAttributedString * statesA=[[NSMutableAttributedString alloc]initWithString:@"订单状态:"];
    
    NSMutableAttributedString * stateA1=[[NSMutableAttributedString  alloc]initWithString:_currentStates];
    [stateA1 addAttribute:NSForegroundColorAttributeName value:lightOrangeColor range:NSMakeRange(0, _currentStates.length)];
    
    [statesA appendAttributedString:stateA1];
    view.labelOrderStates.attributedText=statesA;
//    view.labelOrderStates.text=[NSString stringWithFormat:@"订单状态:%@",_currentStates];
    
    
    view.labelConsignee.text=[NSString stringWithFormat:@"收货人:%@",dic[@"shouhuo_person"]];
    view.labelNumber.text=[NSString stringWithFormat:@"电话:%@",dic[@"shouhuo_tel"]];
    view.btnAddress.text=[NSString stringWithFormat:@"收货地址:%@",dic[@"address"]];
    return view;
}
-(void)headerActionWithSection:(NSInteger)section{
    NSDictionary * dic=_datas[section];
    OrderDetail * orderDetail=[OrderDetail new];
    orderDetail.ziid=[NSString stringWithFormat:@"%@",dic[@"ziid"]];
    orderDetail.orderType=_orderType;
    
    [self.navigationController pushViewController:orderDetail animated:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSMutableArray * pDatas=[NSMutableArray array];
    [pDatas addObjectsFromArray:[_datas[section]objectForKey:@"eary"]];
    return pDatas.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _datas.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90*self.scale;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyOrderCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    NSMutableArray * pDatas=[NSMutableArray array];
    [pDatas addObjectsFromArray:[_datas[indexPath.section]objectForKey:@"eary"]];
    NSDictionary * dic=pDatas[indexPath.row];
    
    [cell.imgView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",dic[@"plogo"]]] placeholderImage:[UIImage imageNamed:@"luntai_tai"]];
    cell.labelIntro.text=[NSString stringWithFormat:@"%@",dic[@"name"]];
   
    NSString * xian=[NSString stringWithFormat:@"￥%@  ",dic[@"newprice"]];
    NSString * yuan=[NSString stringWithFormat:@"原价￥%@",dic[@"oldprice"]];
    NSMutableAttributedString * att=[[NSMutableAttributedString alloc]initWithString:xian];
    [att appendAttributedString:[yuan getDeleteLineText]];
    cell.labelPrice.attributedText=att;
    
    
    
    
    cell.labelStandard.text=[NSString stringWithFormat:@"规格:%@",dic[@"Guige"]];;
//    cell.labelStatus.text=[NSString stringWithFormat:@"订单状态:%@",_currentStates];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

}



-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (_orderType==OrderTypeWillDeliverGoods) {
    return 87.5*self.scale;
    }
    return 50*self.scale;
    
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    MyOrderFooterView * view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"footerView"];
    NSDictionary * dic=_datas[section];
    
    view.labelGodsCount.text=[NSString stringWithFormat:@"共%@件商品",dic[@"count"]];
    view.labelPaid.text=[NSString stringWithFormat:@"实付款:%@",dic[@"allprice"]];
  
    view.delegate=self;
    view.section=section;
    if (_orderType==OrderTypeWillDeliverGoods) {
         view.isHave=YES;
    }else{
         view.isHave=NO;
    }
        return view;
}
-(void)actionWithSection:(NSInteger)section{
    EditOrder * editOrder = [EditOrder new];
    editOrder.dataDic=_datas[section];
    [self.navigationController pushViewController:editOrder animated:YES];
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
