//
//  FinanceManage.m
//  TyreAlliance
//
//  Created by wdx on 16/9/12.
//  Copyright © 2016年 wdx. All rights reserved.
//

#import "FinanceManage.h"
#import "MyBankCard.h"
//#import "DangDingYinHangViewController.h"
#import "WithDraw.h"
#import "SettleOrder.h"
#import "RecomIncome.h"



@interface FinanceManage ()
@property (nonatomic,strong)UIScrollView * scrollView;

@property (nonatomic,strong)NSMutableDictionary * dataDic;
@property (nonatomic,strong)UILabel * labelMoney;
@property (nonatomic,strong)UILabel * labelCard;
@property (nonatomic,strong)UILabel * labelRecom;
@end

@implementation FinanceManage

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self newNavi];
    [self newView];
    [self reshData];
    // Do any additional setup after loading the view.
}
-(void)newNavi{
    self.TitleLabel.text=@"财务管理";
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
}
-(void)reshData{
    [self startAnimating:nil];
  
    NSDictionary * dic=@{@"uid":[Stockpile sharedStockpile].ID};
    
    [AnalyzeObject getFinanceManageWithDic:dic WithBlock:^(id model, NSString *ret, NSString *msg) {
        [self stopAnimating];
        if ([ret isEqualToString:@"1"]) {
            [_dataDic addEntriesFromDictionary:model];
            [self reshView];
        }else{
            [self showPromptBoxWithSting:msg];
        }
    }];
    
}
-(void)reshView{
    _labelMoney.text=[NSString stringWithFormat:@"￥%@",_dataDic[@"allmoney"]];
    _labelCard.text=[NSString stringWithFormat:@"%@",_dataDic[@"banl_num"]];
    _labelRecom.text=[NSString stringWithFormat:@"￥%@",_dataDic[@"ShouYi"]];
    
    
}
-(void)newView{
    _scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom, Vwidth, Vheight-self.NavImg.height)];
    _scrollView.backgroundColor=superBackgroundColor;
    [self.view addSubview:_scrollView];
    
    UIView * firstView=[[UIView alloc]initWithFrame:CGRectMake(0, 10*self.scale, _scrollView.width, Vwidth*0.2)];
    [_scrollView addSubview:firstView];
    firstView.backgroundColor=[UIColor whiteColor];
    
    UILabel * accountTitle=[[UILabel alloc]initWithFrame:CGRectMake(10*self.scale, 10*self.scale, Vwidth/2, 20*self.scale)];
    [firstView addSubview:accountTitle];
    accountTitle.text=@"账户总额(元)";
    accountTitle.textColor=blackTextColor;
    accountTitle.font=DefaultFont(self.scale);
    
    UILabel * accountCount=[[UILabel alloc]initWithFrame:CGRectMake(10*self.scale, accountTitle.bottom+20*self.scale, Vwidth/2, 20*self.scale)];
    accountCount.font=Big16Font(self.scale);
    accountCount.textColor=lightOrangeColor;
    [firstView addSubview:accountCount];
    firstView.height=accountCount.bottom+10*self.scale;
    _labelMoney=accountCount;
    
    
    
    NSArray * titles=@[@"绑定账号",@"提现",@"已结算订单",@"未结算订单",@"推荐收益"];
    for (int i =  0; i < 5; i ++) {
        CellView * cellView=[[CellView alloc]initWithFrame:CGRectMake(0, firstView.bottom+ 10*self.scale+ i * 40*self.scale, _scrollView.width, 40*self.scale)];
        cellView.titleLabel.text=titles[i];
        [cellView ShowRight:YES];
        cellView.backgroundColor=[UIColor whiteColor];
        [_scrollView addSubview:cellView];
        
        cellView.btn.tag=100+i;
        [cellView.btn addTarget:self action:@selector(skip:) forControlEvents:UIControlEventTouchUpInside];
        UILabel * label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 150*self.scale, 20*self.scale)];
        label.font=DefaultFont(self.scale);
        label.textColor=grayTextColor;
        label.textAlignment=NSTextAlignmentRight;
        label.centerY=cellView.titleLabel.centerY;
        label.right=cellView.RightImg.left-10*self.scale;
        
        if (i==0) {
            [cellView addSubview:label];
            _labelCard=label;
        }
        if (i==4) {
            [cellView addSubview:label];
            label.textColor=lightOrangeColor;
            _labelRecom=label;
        }
    }
    
    
}
-(void)skip:(UIButton *)sender{
    switch (sender.tag) {
        case 100:{
            
            
            [self.navigationController pushViewController:[MyBankCard new] animated:YES];
        }
            break;
        case 101:{
            [self.navigationController pushViewController:[WithDraw new] animated:YES];
            
        }
            break;
        case 102:{
            SettleOrder * settleOrder = [SettleOrder new];
            settleOrder.orderType=0;
            [self.navigationController pushViewController:settleOrder animated:YES];
        }
            break;
        case 103:{
            SettleOrder * settleOrder = [SettleOrder new];
            settleOrder.orderType=1;
            [self.navigationController pushViewController:settleOrder animated:YES];
        }
            break;
        case 104:{
            [self.navigationController pushViewController:[RecomIncome new] animated:YES];
        }
            break;
        default:
            break;
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
