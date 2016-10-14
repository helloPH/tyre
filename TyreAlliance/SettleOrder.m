//
//  SettleOrder.m
//  TyreAlliance
//
//  Created by wdx on 16/9/18.
//  Copyright © 2016年 wdx. All rights reserved.
//

#import "SettleOrder.h"
#import "SettleOrderCell.h"

@interface SettleOrder ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)NSDate * starttime;
@property (nonatomic,strong)NSDate * endtime;
@property (nonatomic,assign)NSInteger yeIndex;

@property (nonatomic,strong)NSMutableArray * datas;
@property (nonatomic,strong)UIControl * dateControl;
@property (nonatomic,strong)UIDatePicker * datePicker;

@property (nonatomic,strong)UITableView * tableView;

@property (nonatomic,strong)UIButton * btnStart;
@property (nonatomic,strong)UIButton * btnEnd;
@property (nonatomic,strong)UIButton * screenBtn;
@end

@implementation SettleOrder

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self newNavi];
    [self newView];
    [self reshData];
    // Do any additional setup after loading the view.
}
-(void)newNavi{
    if (_orderType==0) {
     self.TitleLabel.text=@"已结算订单";
    }else{
     self.TitleLabel.text=@"未结算订单";
    }
   
    
    UIButton *popBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
    [popBtn setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    [popBtn setImage:[UIImage imageNamed:@"left_b"] forState:UIControlStateHighlighted];
    [popBtn addTarget:self action:@selector(PopVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavImg addSubview:popBtn];
    
    
    UIButton *screenBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, self.TitleLabel.top, self.TitleLabel.height, self.TitleLabel.height)];
    
    screenBtn.right=self.NavImg.right-10*self.scale;
    screenBtn.height=25*self.scale;
    screenBtn.centerY=self.TitleLabel.centerY;
    //    screenBtn.width=popBtn.width*(3/2.0);
    [screenBtn setTitle:@"筛选" forState:UIControlStateNormal];
    [screenBtn addTarget:self action:@selector(screenBtn:) forControlEvents:UIControlEventTouchUpInside];
    [screenBtn setBackgroundImage:[UIImage ImageForColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.5]] forState:UIControlStateNormal];
    screenBtn.hidden=YES;
    screenBtn.layer.cornerRadius=3;
    screenBtn.layer.masksToBounds=YES;
    screenBtn.titleLabel.font=SmallFont(self.scale);
    [self.NavImg addSubview:screenBtn];
    _screenBtn=screenBtn;
    
}

-(void)PopVC:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)screenBtn:(UIButton *)sender{
    _yeIndex=1;
    [self reshData];
}
-(void)initData{
    _datas=[NSMutableArray array];
    _yeIndex=1;

    
    
    NSDateFormatter * fo=[[NSDateFormatter alloc]init];
    [fo setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8*3600]];
    [fo setDateFormat:@"yyyy-MM-dd"];
    _starttime=[fo dateFromString:@"2000-01-01"];
    _endtime=[NSDate date];
    

}
-(void)reshData{ 
    [self startAnimating:nil];
    NSString * states=_orderType==OrderTypeNo?@"0":@"1";
    NSDictionary * dic;


    if (_starttime==nil || _endtime==nil) {
        dic=@{@"uid":[Stockpile sharedStockpile].ID,
              @"states":states,
              @"ye":[NSString stringWithFormat:@"%d",_yeIndex]
              };
    }else{
        NSDateFormatter * fo=[[NSDateFormatter alloc]init];
        [fo setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8*3600]];
        [fo setDateFormat:@"yyyy-MM-dd"];
        NSString * starttime=[fo stringFromDate:_starttime];
        NSString * endtime=[fo stringFromDate:_endtime];
        dic=@{@"uid":[Stockpile sharedStockpile].ID,
                             @"states":states,
                             @"ye":[NSString stringWithFormat:@"%d",_yeIndex],
                             @"startime":starttime,
                             @"endtime":endtime};
    }
    

 
    
    [AnalyzeObject getSettleOrderWithDic:dic WithBlock:^(id model, NSString *ret, NSString *msg) {
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
          [self reshView];
    }];
    
}
-(void)reshView{
    _screenBtn.hidden=YES;
    
    
    NSDateFormatter * fo=[[NSDateFormatter alloc]init];
    [fo setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8*3600]];
    [fo setDateFormat:@"yyyy-MM-dd"];
    
    NSString * starttime=[fo stringFromDate:_starttime];
    starttime= [starttime stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
    [_btnStart setTitle:starttime forState:UIControlStateNormal];
    
    NSString * endtime=[fo stringFromDate:_endtime];
    endtime=[endtime stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
    [_btnEnd setTitle:endtime forState:UIControlStateNormal];
    
    [_tableView reloadData];
}
-(void)newDateControl{
    
        UIControl * control=[[UIControl alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom, Vwidth, Vheight-self.NavImg.height)];
        control.backgroundColor=[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:0.8];
        control.hidden=NO;
        control.alpha=1;
        [self.view addSubview:control];
        [control addTarget:self action:@selector(timeBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        UIDatePicker * datePicker=[[UIDatePicker alloc]initWithFrame:CGRectMake(0, 0, Vwidth, 150*self.scale)];
        datePicker.backgroundColor=[UIColor whiteColor];
        datePicker.bottom=control.height;
        [control addSubview:datePicker];
        datePicker.datePickerMode=UIDatePickerModeDate;
        _datePicker=datePicker;
        _dateControl=control;
        
        
        UIView * btnBg=[[UIView  alloc]initWithFrame:CGRectMake(0, 0, Vwidth, 30*self.scale)];
        [_dateControl addSubview:btnBg];
        btnBg.bottom=_datePicker.top;
        btnBg.backgroundColor=[UIColor whiteColor];
        
        
        NSArray * btnTitles=@[@"取消",@"确定"];
//        CGFloat bottonBtnH=30*self.scale;
        for (int i =0; i < 2;  i ++) {
            UIButton * btn=[[UIButton alloc]initWithFrame:CGRectMake(10*self.scale, 0, 50*self.scale,btnBg.height)];
            [btnBg addSubview:btn];
            [btn addTarget:self action:@selector(commitOrCancel:) forControlEvents:UIControlEventTouchUpInside];
            [btn setTitle:btnTitles[i] forState:UIControlStateNormal];
            btn.backgroundColor=[UIColor whiteColor];
            [btn setTitleColor:lightOrangeColor forState:UIControlStateNormal];
            btn.titleLabel.font=DefaultFont(self.scale);
            btn.tag=10000+i;
            if (i==0) {
//                [btn setBackgroundImage:[UIImage ImageForColor:lightOrangeColor] forState:UIControlStateNormal];
//                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            }else{
                btn.right=Vwidth-10*self.scale;
            }
//            btn.bottom=_datePicker.top;
        }
        
    if (_btnStart.selected) {
        _datePicker.date=_starttime;
    }else{
        _datePicker.date=_endtime;
    }
}
-(void)commitOrCancel:(UIButton *)sender{
    
    if (sender.tag!=10000) {
        NSDateFormatter * fo=[[NSDateFormatter alloc]init];
        [fo setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8*3600]];
        [fo setDateFormat:@"yyyy-MM-dd"];
        NSString * time=[fo stringFromDate:_datePicker.date];
        time = [time stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
        [_btnStart setTitle:time forState:UIControlStateNormal];
        
        if (_btnStart.selected==YES) {
            _starttime=[fo dateFromString:time];
        }
        if (_btnEnd.selected==YES) {
            _endtime=[fo dateFromString:time];
        }
        _screenBtn.hidden=NO;
//        [self reshData];
    }
    [self timeBtn:nil];
 
    
}
-(void)newView{
    UIView * timeView = [[UIView alloc]initWithFrame:CGRectMake(0, self.NavImg.bottom, Vwidth, 30*self.scale)];
    timeView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:timeView];
    
    UILabel * startLabel=[[UILabel alloc]initWithFrame:CGRectMake(10*self.scale, 5*self.scale, 45*self.scale, 20*self.scale)];
    startLabel.font=DefaultFont(self.scale);
    startLabel.textColor=blackTextColor;
    [timeView addSubview:startLabel];
    startLabel.text=@"起时间";
    

    
    UIButton * startBtn=[[UIButton alloc]initWithFrame:CGRectMake(startLabel.right+10*self.scale, startLabel.top, 70*self.scale, 20*self.scale)];
    startBtn.titleLabel.font=Small10Font(self.scale);
    startBtn.layer.cornerRadius=3;
    startBtn.layer.borderColor=blackLineColore.CGColor;
    startBtn.layer.borderWidth=0.5*self.scale;
    startBtn.layer.masksToBounds=YES;
    [timeView addSubview:startBtn];
    startBtn.tag=100;
    [startBtn setBackgroundImage:[UIImage ImageForColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [startBtn setTitleColor:blackTextColor forState:UIControlStateNormal];
    [startBtn setBackgroundImage:[UIImage ImageForColor:navigationControllerColor] forState:UIControlStateSelected];
    [startBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [startBtn addTarget:self action:@selector(timeBtn:) forControlEvents:UIControlEventTouchUpInside];
    _btnStart=startBtn;
    
    UIButton * endBtn=[[UIButton alloc]initWithFrame:CGRectMake(startLabel.right+10*self.scale, startLabel.top, 70*self.scale, 20*self.scale)];
    endBtn.right=Vwidth-10*self.scale;
    endBtn.titleLabel.font=Small10Font(self.scale);
    endBtn.layer.cornerRadius=3;
    endBtn.layer.masksToBounds=YES;
    endBtn.layer.borderColor=blackLineColore.CGColor;
    endBtn.layer.borderWidth=0.5*self.scale;
    [timeView addSubview:endBtn];
    endBtn.tag=101;
    [endBtn setBackgroundImage:[UIImage ImageForColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [endBtn setTitleColor:blackTextColor forState:UIControlStateNormal];
    [endBtn setBackgroundImage:[UIImage ImageForColor:navigationControllerColor] forState:UIControlStateSelected];
    [endBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [endBtn addTarget:self action:@selector(timeBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    _btnEnd=endBtn;
    
    
    UILabel * endLabel=[[UILabel alloc]initWithFrame:CGRectMake(10*self.scale, 5*self.scale, 45*self.scale, 20*self.scale)];
    endLabel.right=endBtn.left-10*self.scale;
    endLabel.font=DefaultFont(self.scale);
    endLabel.textColor=blackTextColor;
    [timeView addSubview:endLabel];
    endLabel.text=@"止时间";
    
    UIView * line=[[UIView alloc]initWithFrame:CGRectMake(startBtn.right+5*self.scale, startLabel.centerY, endLabel.left-startBtn.right-10*self.scale, 1*self.scale)];
    line.backgroundColor=blackLineColore;
    [timeView addSubview:line];
    
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, timeView.bottom+10*self.scale, Vwidth, Vheight-self.NavImg.height-timeView.height-10*self.scale) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [_tableView registerClass:[SettleOrderCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:_tableView];
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor=superBackgroundColor;
    
    [_tableView addHeardTarget:self Action:@selector(xiala)];
    [_tableView addFooterTarget:self Action:@selector(shangla)];
}
-(void)shangla{
    _yeIndex++;
    [self reshData];
}
-(void)xiala{
    _yeIndex=1;
    [self reshData];
}

-(void)timeBtn:(UIButton *)sender{
    if (sender.tag==100 || sender.tag==101) {
        _btnStart.selected=NO;
        _btnEnd.selected=NO;
        sender.selected=YES;
    }
    
    if (!_dateControl) {
        [self newDateControl];
        return;
    }

    
    
    if (self.dateControl.hidden==YES) {
        if (_btnStart.selected) {
            _datePicker.date=_starttime;
        }else{
            _datePicker.date=_endtime;
        }
            _dateControl.hidden=NO;
            [UIView animateWithDuration:0.3 animations:^{
                _dateControl.alpha=1;
            }];
    }else{
        
        
            [UIView animateWithDuration:0.3 animations:^{
                _dateControl.alpha=0;
            } completion:^(BOOL finished) {
                _dateControl.hidden=YES;
            }];
    }
    
    
}

#pragma mark -- tableView delegate DataSource
//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 30*self.scale;
//}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40*self.scale;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    CellView * view = [[CellView alloc]initWithFrame:CGRectMake(0, 0, Vwidth, 30*self.scale)];
    view.backgroundColor=[UIColor whiteColor];
    
    UILabel * lableTime= [[UILabel alloc]initWithFrame:CGRectMake(10*self.scale, 5*self.scale, 40*self.scale, 20*self.scale)];
    lableTime.centerX=70*self.scale;
    lableTime.font=DefaultFont(self.scale);
    lableTime.textColor=blackTextColor;
    lableTime.textAlignment=NSTextAlignmentCenter;
    lableTime.text=@"时间";
    [view addSubview:lableTime];
    
    
    UILabel * orderNum = [[UILabel alloc]initWithFrame:CGRectMake(10*self.scale, 5*self.scale, 40*self.scale, 20*self.scale)];
    orderNum.centerX=view.centerX;
    orderNum.font=DefaultFont(self.scale);
    orderNum.textColor=blackTextColor;
    orderNum.textAlignment=NSTextAlignmentCenter;
    orderNum.text=@"订单号";
    [view addSubview:orderNum];
    
    UILabel * money = [[UILabel alloc]initWithFrame:CGRectMake(10*self.scale, 5*self.scale, 40*self.scale, 20*self.scale)];
    money.centerX=Vwidth-70*self.scale;
    money.font=DefaultFont(self.scale);
    money.textColor=blackTextColor;
    money.textAlignment=NSTextAlignmentCenter;
    money.text=@"金额";
    [view addSubview:money];
    
    return view;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _datas.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SettleOrderCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    NSDictionary * dic=_datas[indexPath.row];
    cell.labelMoney.text=[NSString stringWithFormat:@"%@",dic[@"money"]];
    cell.orderNumber.text=[NSString stringWithFormat:@"%@",dic[@"order_id"]];
//    [cell.orderNumber sizeToFit];
    cell.labelTime.text=[NSString stringWithFormat:@"%@",dic[@"time"]];
//    [cell.labelTime sizeToFit];
    
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
